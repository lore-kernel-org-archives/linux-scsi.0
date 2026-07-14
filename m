Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF33417BE5
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 17:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051659; cv=none; b=bm5rwewEtznZjbffx/cT/hLcMJmzBYhcd78wY9OdqhM/6+EJis3Ko3TJfVJdo/bgB5ZEj56BoeSbVBBNlmo9Tuf/JMG5XcDiCBP+gQrbbleKRBiZMs4L9ZfojsccoXy5EMhU7V8lEpaP6ei1v6OJsRj8as020tijmEpO3dAxfaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051659; c=relaxed/simple;
	bh=Xpo6fV4ae9rOKsQ2VfpTSSKFCb18GdhQ5F9dJTUyFYY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gtLqbjDWE9y9xtQjWGReS2/DS8uXitb6iIY3Abq7PrF9RGJwlyIuU+L+GjnGw/5qFx96jhR2Vsp5F+0TEIEvm8O4d3YMFnW78zL9Ic/nXBeUb1u0BgMTgJa0LdlBuYH1f581nZo5ZFjr90kESY8BpWvDA6K1VT0ZoR1D0BD+Ntw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bj1Wfoe6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bj1Wfoe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787D01F000E9;
	Tue, 14 Jul 2026 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051656;
	bh=FyFY8/uyZS55h0JzAapFXf1Zm8ow9r3umjv/kdjn5co=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bj1Wfoe6r59Yb5FFvzsqZIvS0cR6pITWADy/NPJbjw1vxNM+A3uUV3sXvWAZF6ARF
	 DoW/SIvXcV2NEh5jK91LIuMSpd68452lVDV6PcesfMlH6CHcQ2Ue4qfjViGQSLrzsC
	 zjgnCRVCM3n52KquAL1ErJB+L18wiucarYIqlMzrNH1CT0nxnHXFvB3sWOrpyjY7kc
	 Hyr8yEWvw0DLj0ki/6PapPV03QjWUTKiddReuVLphhoXcfHI02jzH/G7+nzpALv0Wp
	 Dyni4b3Ent93CJ0qtv2y/w/XCICPpfDizZ1NQscgiD52kfnMqNEEMGVa6iCSVQfgql
	 4dq/RGBW/8FPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 49/56] scsi: qla2xxx: Check entry_status in
 qla24xx_modify_vp_config()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-50-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-50-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 17:54:16 +0000
Message-Id: <20260714175416.787D01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] qla84xx_verify_chip misses checking entry_status after issuing VER=
IFY_CHIP_IOCB_TYPE command, mirroring the bug patched in qla24xx_modify_vp_=
config.
--

--- Patch [49]: [PATCH v4 49/56] scsi: qla2xxx: Check entry_status in qla24=
xx_modify_vp_config() ---
commit 3b96c82a05342dd19f7fa76f7754bb1b19a11803
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()

This commit addresses a completion handling bug in the Modify VP Config
handler where the driver incorrectly treated early firmware IOCB
rejections as success by checking only comp_status. Adding a check for
entry_status fixes the bug by properly detecting early rejections.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index b32ca8ed274d6..59023492c5a98 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4401,10 +4401,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
>  	if (rval !=3D QLA_SUCCESS) {
>  		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
>  		    "Failed to issue VP config IOCB (%x).\n", rval);
> -	} else if (vpmod->comp_status !=3D 0) {
> +	} else if (vpmod->entry_status !=3D 0) {
>  		ql_dbg(ql_dbg_mbx, vha, 0x10be,
>  		    "Failed to complete IOCB -- error status (%x).\n",
> -		    vpmod->comp_status);
> +		    vpmod->entry_status);
>  		rval =3D QLA_FUNCTION_FAILED;
>  	} else if (vpmod->comp_status !=3D cpu_to_le16(CS_COMPLETE)) {
>  		ql_dbg(ql_dbg_mbx, vha, 0x10bf,

[Severity: High]
This isn't a bug introduced by this patch, but does the same missing
entry_status check issue exist in qla84xx_verify_chip() in the same file?

Looking at drivers/scsi/qla2xxx/qla_mbx.c:qla84xx_verify_chip(), the
IOCB buffer is zeroed out before being issued:

    memset(mn, 0, sizeof(*mn));
    mn->p.req.entry_type =3D VERIFY_CHIP_IOCB_TYPE;
    ...
    rval =3D qla2x00_issue_iocb_timeout(vha, mn, mn_dma, 0, 120);

After the command completes, the function directly checks comp_status:

    status[0] =3D le16_to_cpu(mn->p.rsp.comp_status);
    status[1] =3D status[0] =3D=3D CS_VCS_CHIP_FAILURE ?
        le16_to_cpu(mn->p.rsp.failure_code) : 0;
    ...
    if (status[0] !=3D CS_COMPLETE) {
        rval =3D QLA_FUNCTION_FAILED;

If the firmware rejects the IOCB early, would it set entry_status and
leave comp_status at 0 (which matches CS_COMPLETE)? This would cause
the driver to incorrectly assume the verify succeeded, similarly to the
issue fixed here.

Could this potentially leave the ISP8432 chip initialization in a broken
state with an internal firmware version of 0, leading to subsequent timeouts
or adapter lockups?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D49
