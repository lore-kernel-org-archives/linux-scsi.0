Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9773624A9
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262326; cv=none; b=YIUep+F6A4aV6I/C18upfVkdBATvNpn+AhY5iIuszk1tfROVkeTCZ9JUMV59fPStv4tCoNdQ62wPjEGouoVZYoAzfMS3i13AcxQu0rlfFhSDRNy4Az5GfCqaJYOScKVGuTONIbNh6MNAJHF9wAYbqRnZPJzso06jd8dIGLPYXrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262326; c=relaxed/simple;
	bh=NqzWIzr8wcE8eHYUxAKRModn++JPJjzX0Spe06ui8vs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PlpP/HkVQlqF3LHlJ9MCG32k5Dq8nDcJ0/YJy6BbfLsDRa7Cdqmu6UeZ++MU46dLD53anCgqvf+5wJbQ05Wkgg/Kd9ROfgUKF6xLe4nAyswByIQoSQphaUSio4YWLxFPUXOGNikCJ7W41dd3d4c2yu9H0mqnruoixSXlpaIK5m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YLKeIiBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YLKeIiBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA321F000E9;
	Fri, 12 Jun 2026 11:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781262325;
	bh=tF3e/PR43bJk+veX0s5JZ/TGCONFPsm8u6LgpRYIFb8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YLKeIiBgVjWaQM27FFcMfKdV9tYKB/9yQJWwc0Ij8HX+33+cEcujmRwiPsGIUzRm8
	 V4whuC9tVdtSoF/DilR7EA86d//Fx9RX10DvW+7PyH4D1uwQdTumcFx7N2wJSJixj4
	 qhEEn35CJ1+urRQnzP4sC2WyEmw56qlAdkPUICjQRU5ppipIUWG2dkaWKd2Yzblr58
	 tq+Rkgte5pLte3qTIO436xSvmGP+ja2JPOEohSjVmFI6apHFLVP5yn/+1cTLtzlv+H
	 gskWewkfC0HcOb1lblmPetilN+gMSVtn8jTUzCspnaJtQua7Fa/ULSdHjBK5GokOXk
	 QyPbmchcTZDtQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 40/60] scsi: qla2xxx: Add size check for extended VP
 report ID entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-41-njavali@marvell.com>
References: <20260612095333.1666592-41-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:05:24 +0000
Message-Id: <20260612110525.0AA321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dangling pointer `fcport` is accessed after dropping `sess_lock`, =
and list traversal is performed entirely locklessly for Format 2 reports.
--

commit 4be1e7bdd8412a09686257ce5b4981203d404668
Author: Nilesh Javali <njavali@marvell.com>
scsi: qla2xxx: Add size check for extended VP report ID entry

This patch adds padding to the vp_rpt_id_entry_24xx_ext structure to match
the hardware IOCB stride. It also updates qla24xx_report_id_acquisition()
to extract vp_idx and vp_status from the extended structure on 29xx adapter=
s.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4094,15 +4094,18 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint=
16_t loop_id,
>  }
> =20
>  void
> -qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
> -	struct vp_rpt_id_entry_24xx *rptid_entry)
> +qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
>  {

[Severity: High]
This is a pre-existing issue, but can this function trigger a use-after-free
or list corruption?

In the format 1 path, the sess_lock is dropped right before modifying the
fcport structure without acquiring a reference:

    spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
    ...
    fcport =3D qla2x00_find_fcport_by_wwpn(vha, rptid_entry->u.f1.port_name=
, 1);
    spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);

    if (fcport) {
        fcport->plogi_nack_done_deadline =3D jiffies + HZ;
        ...

Without a reference count being taken, could a concurrent thread remove
and free this fcport before it is modified here?

Additionally, in the format 2 path, the vha->vp_fcports list is iterated
locklessly, and then fcport is searched and dereferenced locklessly:

    list_for_each_entry(fcport, &vha->vp_fcports, list) {
        fcport->scan_state =3D QLA_FCPORT_SCAN;
        fcport->n2n_flag =3D 0;
    }

    fcport =3D qla2x00_find_fcport_by_wwpn(vha, rptid_entry->u.f2.port_name=
, 1);

    if (fcport) {
        fcport->login_retry =3D vha->hw->login_retry_count;
        ...

Could concurrent modifications to this list by the DPC thread or sysfs cause
list corruption panics or a use-after-free here?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D40
