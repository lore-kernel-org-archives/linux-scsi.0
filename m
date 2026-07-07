Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834CB226CF6
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407819; cv=none; b=H2F4F8UGYuOIkcavt0TQ8Hb79pEbntvhAsBs4pErGLm8MLITGQsucTwhVzZRmMhpYnvOtvG8p6vI5lV6HvqdvY0yY2AucOkChGLl8f2Q3gmtT2lbNPfw1kAkSeEMvwyApGXGeSPGmb8oAZxroSPeYAzArh5C4jdcksBzVnjvC1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407819; c=relaxed/simple;
	bh=/dT47W6X37W8aMV6fhLoQxmQnJVzAa9FF5BV2I32kQ4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ITzalKGj4HkALEnLE1Au82wiyE4nyZ0oOHnM2G2Wcd1E8VBDWJLhdtUv1KLm/p+XYCkrTHir/L0TeG5ehUH55Xpdwb9oL7Jdgm0vbiPZ9b5SY6409zrRvvpBbnIBlCf4gCxBHbL6eRS5XAUhUFpuwBpvd5mMNDM1VBl7J2hlO30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=En3ae+8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="En3ae+8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B20C1F000E9;
	Tue,  7 Jul 2026 07:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407818;
	bh=nvRvQQug9yOpjBkEOXRDY/WICEMZLdlGbHjWHesO3mQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=En3ae+8oOdG6Q/1ozeeHI27iKA2l1MgefBL/I+YGbiPbCMCIcbMTlu6O1xpBoZ4wQ
	 xnV9duGbXyQyGOT+0+MwKRcu2LQva3dCvWwYcjh4tZ/14HKtwwi6Ai0eOxQVutY9SR
	 6xjR6UodwUC6FzU5xmwNt662/L1pwr8JKaIcs86cbDyCEiGRlhlbOcLMYlrfAFTM2J
	 xt55RUlZKa1fSQP3xnR9Vfa/vOSKAmba9ZFajw2XI/p1+XtIcbwLypZ/LM2WkOkQL9
	 1cuKARUHY3sDcLpVszx0ms8wcxChyMsG260c4F//JLVY0qOGOs3oFue6k/JWfwAK6L
	 67olu0NsmGcKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 50/88] scsi: qla2xxx: Hold vport reference in
 qla24xx_report_id_acquisition()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-51-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-51-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:03:37 +0000
Message-Id: <20260707070338.1B20C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The lockless atomic_dec(&vp->vref_count) lacks a memory barrier, a=
llowing CPU reordering that leads to a Use-After-Free.

Pre-existing issues:
- [High] Failing to check the VPORT_DELETE flag before updating the vport a=
llows a dying vport to be resurrected into the global B-tree, creating a da=
ngling pointer.
--

--- Patch [50]: [PATCH v3 50/88] scsi: qla2xxx: Hold vport reference in qla=
24xx_report_id_acquisition() ---
commit cc05285288870e8f9cfc205d3a17b3cc31c7a415
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()

This commit acquires a vport reference (vref_count) under vport_slock
during format 1 ID acquisition to prevent concurrent teardown. The
reference is dropped after the last use of the vp pointer.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 59023492c5a98..ba4a4764de1fb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4267,6 +4267,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			list_for_each_entry(vp, &ha->vp_list, list) {
>  				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
> +					atomic_inc(&vp->vref_count);
>  					break;
>  				}
>  			}

[Severity: High]
This is a pre-existing issue, but should we check for the VPORT_DELETE flag
here before taking the reference?

If qla24xx_vport_delete() is running concurrently, it sets VPORT_DELETE and
clears vha->d_id.b24. If we don't check test_bit(VPORT_DELETE, &vp->dpc_fla=
gs),
we could take a reference on a dying vport.

When qla_update_host_map(vp, id) is subsequently called just below this blo=
ck,
it might re-insert this dying vp back into the ha->host_map B-tree.

After the reference is dropped and the vport freed, could this leave a dang=
ling
pointer in the B-tree?

Also, is it safe that qla_update_host_map(vp, id) is called without holding
ha->vport_slock?

[ ... ]

> @@ -4284,6 +4285,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
>  			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
> +
> +			atomic_dec(&vp->vref_count);

[Severity: High]
Could the CPU reorder the set_bit() stores to happen after this atomic_dec(=
)?

On weakly-ordered architectures like ARM64 or PowerPC, atomic_dec() does not
provide a memory barrier.

If qla24xx_deallocate_vp_id() is polling for atomic_read(&vp->vref_count) =
=3D=3D 0
concurrently, it might observe the 0 and free the vp struct before the
set_bit() operations are globally visible.

Would it be safer to use atomic_dec_and_test() or add a memory barrier here
to ensure the bit flag updates complete before the reference is released?

>  		}
>  		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
>  		qla2xxx_wake_dpc(vha);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D50
