Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D2A348C4A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303758; cv=none; b=rQ98pxLBhfb5yYfnSi38VYr9dTfVM4hnbOeAGlTpk4hcB2bULS1FnIODfjTj4DYXzNxrfWE55CpQtGGZVG2wOPAIqgYyzp8DX8V52WMv3y/aHJcP6zSEoTaxHnKgCFTkDH0TaeBnh6/goaccbFCMTkMrM3Wfz2byTwcVQFwI1fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303758; c=relaxed/simple;
	bh=JoMQS/m1x+aNWETbTuuh8J9NdgMJSULAMfBgvWRHZWI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qQM9BHqT3H4OqQsEr4nj/Bo70+5IKmHIBsIZm/wttIpNkoimrKLMoZzvadzZolL4FypNNto5l0g7NXok2ZRjl0N5CM1pbbiILk7mbK5+p3eBFanKloxakeeFSPc7pYsCeJEPFdesFhOIVYRAmG1oHOGzXDREyM/daphNpp964c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8vbnSIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8vbnSIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7231F000E9;
	Fri, 17 Jul 2026 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784303755;
	bh=n2PYJ6snqOMPm7nEXodmRdSy3N7f37JKJzf3AYeR+e4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n8vbnSIUWS1cx8ZE1TJnPkESTS6j+Z8m+iNNJXHUlrOQWX9vS2DwfVixSApElTLJ4
	 PTxHKHpv+ax3qFQy0wLQ0GfO1fGLxsa/rqEV6HN2n88o+GcVxyLWfQVGcebhlcg7zA
	 ayuY0kveLHwnBB8e2/9AJ3b3V1WGmH99v0YP5mufozsrgGT8SoKMpA17ctUmE/0Tfz
	 g+41pBovQQKX3IodnZrKJbU191qWOGXXTH0NbmgMQ4A/DHJzu1kndG3UbRS8oEQGUq
	 Vbfm5eKl/8ln/Tin+CAx48Tc2sWgWgv+idTDUl0rKbMNOuJRWrduyn4iD7+pCNz4JW
	 PNkuJ+Asi1klA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/56] scsi: qla2xxx: Enable get_fw_version mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-15-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-15-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 15:55:55 +0000
Message-Id: <20260717155555.7E7231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] EDIF hardware support (`edif_hw`) is never initialized for 29xx =
adapters, rendering the newly added EDIF enablement logic in `qla2x00_get_f=
w_version()` dead code.
- [Medium] Firmware capabilities (MPI version, PEP version, and MPI firmwar=
e state) successfully retrieved for 29xx adapters cannot be read via sysfs.
--

--- Patch [14]: [PATCH v5 14/56] scsi: qla2xxx: Enable get_fw_version mailb=
ox for 29xx ---
commit 0005c70371943e965a788152e6f343dce174f604
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable get_fw_version mailbox for 29xx

This commit adds IS_QLA29XX checks to various firmware version retrieval
paths in the get_fw_version mailbox and sysfs handlers. It enables 29xx
adapters to correctly retrieve and expose firmware version, EDIF, and
serdes information.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c

[ ... ]

> @@ -1212,7 +1212,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
>  			vha->flags.nvme2_enabled =3D 1;
>  		}
> =20
> -		if (IS_QLA28XX(ha) && ha->flags.edif_hw && ql2xsecenable &&
> +		if ((IS_QLA28XX(ha) || IS_QLA29XX(ha)) && ha->flags.edif_hw && ql2xsec=
enable &&
>  		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_EDIF)) {

[Severity: Medium]
Will this EDIF check actually work for 29xx adapters?

Looking at qla2x00_execute_fw(), edif_hw is only initialized for 28xx:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_execute_fw() {
    ...
    if (IS_QLA28XX(ha) && (mcp->mb[5] & EDIF_HW_SUPPORT)) {
        ha->flags.edif_hw =3D 1;
    ...
}

Since edif_hw is never set for 29xx, does this make the newly added EDIF
enablement logic dead code for those adapters?

>  			ha->flags.edif_enabled =3D 1;
>  			ql_log(ql_log_info, vha, 0xffff,
> @@ -1220,7 +1220,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
>  		}
>  	}
> =20
> -	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +	if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  		ha->serdes_version[0] =3D mcp->mb[7] & 0xff;
>  		ha->serdes_version[1] =3D mcp->mb[8] >> 8;
>  		ha->serdes_version[2] =3D mcp->mb[8] & 0xff;

[Severity: Medium]
Are we missing sysfs updates for the newly retrieved 29xx firmware data?

This change successfully retrieves the MPI version, PEP version, and
MPI firmware state for 29xx adapters. However, the sysfs show functions
still exclude 29xx.

For example, in qla2x00_mpi_version_show():

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_mpi_version_show() {
    if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha) &&
        !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
            return scnprintf(buf, PAGE_SIZE, "\n");
    ...
}

Similar exclusions exist in qla2x00_pep_version_show() and
qla2x00_mpi_fw_state_show().

Will userspace receive empty newlines or 'not supported' messages instead
of the actual data when reading these attributes on 29xx?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D14
