Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11E03B776D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260136; cv=none; b=CaONcgXFhasIiWFFWNvkY9kKmAUjGzzp0odGg/Fhr54y13Nvx4xWUK6WU6jWB7XC+PVGAWYFBehkaT2PcfDZ7BAXjdmXKuD2SsKZ5Hpo9ZrTbW2nbXbMDqdzeuDgdTAH29JSxx6neMLsVkQho6gFFASahq6si9DsCJ0FIfZ/jYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260136; c=relaxed/simple;
	bh=aejCy7jymgDVo8m5ywHSEL9vhrjMBH5W/9qmwpqrgho=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eFqolhSu7NcLBUCwWZAs4fUz7zc6yE9k4IevfdoQfV9rufRhkxWZZ/hw/TzvHRLkTbnbOXnJ7FLR44jrJNPvfx/1WVpOIIrMCj/jfsDjRpCd9ZjKhRAAJDQ2thvA+TysK28/ck0tYPVFc0QpU3ephPuB1l1ncAa3MHU4kDH3asc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCxhoYe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCxhoYe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874F21F000E9;
	Fri, 12 Jun 2026 10:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260134;
	bh=6JD92Y/8l+9OSfpkvRQrwSRb0Kxf+dn3NN+EJgiWQ6g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DCxhoYe8ae3MdLx5Eq8+z4TwaCFGRvX5OH751Sj9cAHHhf4PXqC5DVbiioXaQT57j
	 0IbKirI8oxgiGflRm9ho49ro6du72wSKpwHJ9lLshYNbjW3m5vg1B2hrwt/yvqiHBI
	 TXP0gw9u14glfyAZGFvp143NCIi7sFbTwYMFt2S8EMMGjc2YEnr5cUSgTo2HO4jt9K
	 NOTcrnQ86b3GAYAuQTLBU8ZLI065bfAmlGF9gR9grHQbPB/iO7S7dY2D4fVPsnW9m5
	 pivhdyRD0Mv0j0oaG8PAq/LbbIVCZkUqiN5lKQZK0QabptAQNMWqEx5UMsQ0maNCqN
	 BJTB7Vmj3lopw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/60] scsi: qla2xxx: Skip unsupported sysfs
 attributes for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-16-njavali@marvell.com>
References: <20260612095333.1666592-16-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:28:54 +0000
Message-Id: <20260612102854.874F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free of `ha->cs84xx` due to premature release in `qla2x0=
0_remove_one`.
--

commit ace8a251663829b774dad26691a4ec0924aeadf0
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx

This commit updates several sysfs attribute show functions to return
-EPERM for the QLA29xx adapter. This prevents userspace tools from
seeing stale or undefined values for attributes that are meaningless
on this hardware.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 800751ab562a1..e8755ab86b6ac 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1499,6 +1502,9 @@ qla24xx_84xx_fw_version_show(struct device *dev,
>  	scsi_qla_host_t *vha =3D shost_priv(class_to_shost(dev));
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
> +	if (IS_QLA29XX(ha))
> +		return -EPERM;
> +
>  	if (!IS_QLA84XX(ha))
>  		return scnprintf(buf, PAGE_SIZE, "\n");
> =20
>  	if (!ha->cs84xx->op_fw_version) {

[Severity: High]
This isn't a bug introduced by this patch, but can this lead to a
use-after-free during driver teardown?

During driver teardown, qla2x00_remove_one() appears to drop the reference
to cs84xx and free it before the sysfs attributes are unregistered:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_remove_one() {
    ...
    qla84xx_put_chip(base_vha);
    ...
    scsi_remove_host(base_vha->host);
    ...
}

If a user concurrently reads the 84xx_fw_version sysfs file during this win=
dow,
it executes qla24xx_84xx_fw_version_show() which unconditionally dereferenc=
es
the now-freed ha->cs84xx pointer:

drivers/scsi/qla2xxx/qla_attr.c:qla24xx_84xx_fw_version_show() {
    ...
    if (!ha->cs84xx->op_fw_version) {
    ...
}

Does this window between dropping the reference to ha->cs84xx and unregiste=
ring
the host sysfs attributes allow for a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D15
