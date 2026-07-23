Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A47F44C4F9
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832988; cv=none; b=R6OUiCvNVUAJ+UDml1hXepkzal2sx853eyttYj5kVVlweE8INch8fKbxGYhVqzwukAzJ1ZpN8GRs3v7GKeWq/dP7v1CAq/47B4miPauheMUuGBdYC68u2E6EX7ET9J7RZKYambpD2o63J1LbGy8HaAobZbHZxfNgw+8zNzEcKI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832988; c=relaxed/simple;
	bh=e5ckpkGHQVrPJGv/+xdTgLgrth340QNUWoDGbDNph6Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WclC9XtZGYXGFXr8u4n82z+w2tum7ioNvzZOz4pRUL6HJPVwQjXYabUS5kJlo1D5fI/msoNRZS/cLnn53SaFYcxhPGLPzYudSoZkTY91SB1l5e5uzSrRDmmsxDcsTQI2pFPUCmpqV2G/dDwp61HJkSPeBK3VEdHmQ72EgM0ydxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF451F000E9;
	Thu, 23 Jul 2026 18:56:24 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 49/56] scsi: qla2xxx: Check entry_status in
 qla24xx_modify_vp_config()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-50-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-50-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 18:56:23 +0000
Message-Id: <20260723185624.2BF451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing IOCB `entry_status` checks cause firmware rejections to be=
 incorrectly treated as success.
--

--- Patch [49]: [PATCH v6 49/56] scsi: qla2xxx: Check entry_status in qla24=
xx_modify_vp_config() ---
commit 2e991988fb5984a6e00b391f35371b9211fc9e9a
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()

This commit fixes a bug in qla24xx_modify_vp_config() where the IOCB
completion handler checked comp_status instead of entry_status. This
prevented early firmware rejections from being properly detected.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
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

[Severity: High]
This isn't a bug introduced by this patch, but since you are fixing the
missing entry_status check here, do we have similar vulnerabilities in other
IOCB handlers across the driver?

Looking at other parts of the driver, several functions appear to make the
same mistake of ignoring entry_status when an IOCB is rejected early.

For example, in qla84xx_verify_chip(), it only checks comp_status:

drivers/scsi/qla2xxx/qla_mbx.c:qla84xx_verify_chip() {
    ...
    status[0] =3D le16_to_cpu(mn->p.rsp.comp_status);
    status[1] =3D status[0] =3D=3D CS_VCS_CHIP_FAILURE ?
        le16_to_cpu(mn->p.rsp.failure_code) : 0;
    ...
    if (status[0] !=3D CS_COMPLETE) {
    ...
}

Could this treat a rejected verify chip IOCB as a success if entry_status
is set but comp_status remains zero?

Similarly, the BSG handlers qla84xx_updatefw() and qla84xx_mgmt_cmd() in
drivers/scsi/qla2xxx/qla_bsg.c only check the mailbox command return
status (rval) but ignore both entry_status and comp_status entirely.

Do these need to be updated to prevent returning DID_OK to userspace if
the firmware update fails, or copying zeroed memory into the user's BSG
reply payload?

Finally, in the ELS/ABTS paths, qla24xx_process_abts() in qla_isr.c and
qla24xx_process_purex_rdp() in qla_os.c both check rsp_els->comp_status
but completely ignore entry_status.

Could a rejected exchange termination be silently treated as successful
here, leaving active exchanges in the firmware and potentially causing
resource exhaustion?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D49
