Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC263ECBE2
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307225; cv=none; b=PXVcVzTuc67NNutODd7jgv/J5XxDGfqRyon3Rye38wqP39NIFlHZmrkNO4hAjOcBpRrIfqiN1EgCc++sXyIcBpxIxcseMEFoxJEsz0MIuF4B1rLhR0rnKe/3Pr1WnswywOjfEVFRcL0zxe1kP7cXJMgdUpKO+gWX6epW0BvxyLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307225; c=relaxed/simple;
	bh=SGvgM84rUBmOptkrV/52pcQyZYuprei9RbmfLkjeEaY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cBw5vcGN7Lpq9KGPpqwZK59klszU52M3No1yBUeplgF7zjkY6nu3ESE07M2Zu3S7r0nZyQH/6sbzN1G9YTb6T1dbbxidv8pkqLOJMYA4FoRzYePtbNJGsSBEA9sB/IxmqZcaSM5PuAqr/8LBKWi91Ua33FojTozIfv2jc/xcqTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFYqyH35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFYqyH35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5AF1F000E9;
	Fri, 17 Jul 2026 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307224;
	bh=PP4nFE9T6DMCMNm3I1tncVx6rCFlOnEyrX/eKEri8bk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kFYqyH358xK8OuHAfJYZkMfRLe9f4UzMLTvVv/JiLzp29yiamvbw8b/MBipbLUFeB
	 Z5VFbqigRJRvMnlWu7gF1btX04AFPvfyalscvBYL+mmhGfvxrTSZnV8PyaGY9opLth
	 qZh3imWHXqxkGMgzilqP1MbzYyco0W9ln4lXhxEDWeMuclo8/Od47ciXWbvWhQx7F9
	 rW/4f1F+530M+HavrTmhVJvORsjoj150PETF7OrugvtBHlQ/6aULrBpZGr5MREcCwx
	 0p9nMaGSTPbngAQWQrcl05XcMGsyLvdgeq8PUWZiAF41tTfUaPiwh2hBp3rJ7mpE/N
	 ywbQrole/Ja5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 48/56] scsi: qla2xxx: Bound VP index against VP_CTRL
 IOCB bitmap size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-49-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-49-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:53:43 +0000
Message-Id: <20260717165343.ED5AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch prevents disabling virtual ports with an index > 128 but=
 fails to prevent their creation. This creates an asymmetric lifecycle wher=
e high-index vports can be successfully created but will silently fail to b=
e disabled, permanently leaking firmware resources.
--

--- Patch [48]: [PATCH v5 48/56] scsi: qla2xxx: Bound VP index against VP_C=
TRL IOCB bitmap size ---
commit d14a096bfdf302413bad8d30ac696540d3cc6f7a
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

This commit adds bounds checking for vp_index when issuing VP_CTRL IOCBs
to prevent out-of-bounds writes to the vp_idx_map array. It explicitly
rejects commands for virtual ports with an index greater than 128.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
[ ... ]
> @@ -987,6 +987,14 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>  	if (vp_index =3D=3D 0 || vp_index >=3D ha->max_npiv_vports)
>  		return QLA_PARAMETER_ERROR;
> =20
> +	/*
> +	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
> +	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
> +	 * if firmware advertises more NPIV vports.
> +	 */
> +	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
> +		return QLA_PARAMETER_ERROR;

[Severity: High]
This is a pre-existing issue, but by blocking control commands for virtual
ports with an index over 128, does this create an asymmetric lifecycle that
leaks firmware resources?

If the firmware advertises ha->max_npiv_vports up to 255, creating a vport
with an index > 128 can still succeed since qla24xx_vport_create() uses
VP_CONFIG_IOCB, which has an 8-bit index capable of addressing up to 255.

However, when deleting the vport, qla24xx_vport_delete() calls
qla24xx_disable_vp(), which in turn calls qla24xx_control_vp() to send
the disable command. With this new check, disabling the vport will fail
and return QLA_PARAMETER_ERROR.

Looking at qla24xx_vport_delete(), it ignores the return value of
qla24xx_disable_vp():

drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete() {
    ...
    qla24xx_disable_vp(vha);
    qla2x00_wait_for_sess_deletion(vha);

    qla_nvme_delete(vha);
    qla_enode_stop(vha);
    qla_edb_stop(vha);

    vha->flags.delete_progress =3D 1;
    ...
}

Since the failure is ignored, the OS-side structures are destroyed and the
vp_idx is freed for reuse, but the firmware port remains fully active and
logged into the fabric. Reusing the ID later could then corrupt the firmware
state machine.

Should ha->max_npiv_vports be capped at 128 during initialization to
prevent creating these unmanageable virtual ports in the first place?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D48
