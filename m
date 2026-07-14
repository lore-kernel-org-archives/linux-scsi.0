Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF9444708
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 12:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784031573; cv=none; b=p813JfHfFFOIGPw9DlnZoxucm5yw9czPf7vZGZVuCk3sLlUeGiXZzV3m8rJjGr+K3xe6HKKdF+WZ3anxTo9p6rMz1p8UygBHCFaQrbCfuiZ0CxqZU8cd62I8n48rodvTmkMSykVuUyWrYow/ysbrxuclBLeK0R5fcpbkK8zXv0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784031573; c=relaxed/simple;
	bh=LULNmG870jqsJaBI3/3ZliucTsf6IWAozAL8tp5ws38=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TQDkk1X2saOAbJ/PEznHVfQE2EOtveGcGapTBsNkR0BFKJNwPknC7C9R9e2TlJqIg3tfCEVJ2+/fEY0Ll6y3AViMQoG3ycZPKfXSH+Jer1LnBpCLOepwZVHKdkNCgPt6Fu12i9qDAo0L8zqsYbTSW3Ai/AVw0Qx27ZKLUB3l0yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OID164Y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OID164Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6D71F000E9;
	Tue, 14 Jul 2026 12:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031568;
	bh=LdtE1wftjRMBUzU+uyIXgkvEH9ZKoQ0/nyHL47smJs8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OID164Y8B+F69/r2h3yg0ySp/B0rmlff6cP13DhVC8GKgxPJ8tbF8CrF7HOCz4SqY
	 m6NHUiywGqc0Ei+phMnMBHGG/21Xeogi0RH8GxH0iIAEy5aG1kj9UgxIW2PTt7N6cp
	 S8POa/bNjnCrpdivxgx0NXRs1UXvMHL2QYzube/1XoYkej8a7+k23N2jPIlCrSMJj+
	 rPRBL0+aQgLBNmU9x6Qt8L+/px6eSI+fhFw4nVbBRAmIuWJXFHjThUv7u2hHXRVin6
	 TsUG/Qb/KIiy1F0v5eKAczGEB0ene1n6i06fr88Feod+KLgVggVxkDasbh7BXPYJaD
	 oO/hP3+NZfRwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/56] scsi: qla2xxx: Enable get_adapter_id mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-17-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-17-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 12:19:27 +0000
Message-Id: <20260714121928.6B6D71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The patch enables reading Buffer-to-Buffer Credit (BBCR) data fo=
r 29xx adapters but fails to update the corresponding BSG handler `qla27xx_=
get_bbcr_data()`, preventing userspace retrieval.

Pre-existing issues:
- [High] Kernel stack memory leak to userspace due to uninitialized variabl=
e usage when `qla2x00_mailbox_command` fails.
--

--- Patch [16]: [PATCH v4 16/56] scsi: qla2xxx: Enable get_adapter_id mailb=
ox for 29xx ---
commit 357f8972de7904807dc36791b48b4a0731c044b6
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx

Add IS_QLA29XX() alongside the existing 27xx/28xx checks in
qla2x00_get_adapter_id() so that the additional mailbox
registers (buffer-to-buffer credit, SCM/EDC status) are read
on 29xx adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 52d70b61654c7..3fc08120fdf11 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1772,7 +1772,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16=
_t *id, uint8_t *al_pa,
>  		mcp->in_mb |=3D MBX_13|MBX_12|MBX_11|MBX_10;
>  	if (IS_FWI2_CAPABLE(vha->hw))
>  		mcp->in_mb |=3D MBX_19|MBX_18|MBX_17|MBX_16;
> -	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
> +	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))
>  		mcp->in_mb |=3D MBX_15|MBX_21|MBX_22|MBX_23;

[Severity: Medium]
Will userspace actually be able to retrieve BBCR data for 29xx adapters?

Looking at qla27xx_get_bbcr_data() in drivers/scsi/qla2xxx/qla_bsg.c,
the BSG handler seems to explicitly reject anything other than 27xx and 28x=
x:

drivers/scsi/qla2xxx/qla_bsg.c:qla27xx_get_bbcr_data() {
    ...
    if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
        return -EPERM;
    ...
}

Could qla27xx_get_bbcr_data() also need an update to allow 29xx adapters so
userspace doesn't just receive an -EPERM error when requesting this data?

[ ... ]

> @@ -1827,7 +1827,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16=
_t *id, uint8_t *al_pa,
>  			}
>  		}
> =20
> -		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
> +		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))=
 {
>  			vha->bbcr =3D mcp->mb[15];
>  			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {

[Severity: High]
This is a pre-existing issue, but does qla2x00_get_adapter_id() leak
uninitialized kernel stack memory to userspace on error paths?

In qla2x00_get_adapter_id(), mc is allocated on the stack but not fully
initialized. If qla2x00_mailbox_command() fails, mcp->mb[1] remains
uninitialized, but it is unconditionally copied to the output pointer:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_get_adapter_id() {
    mbx_cmd_t mc;
    ...
    rval =3D qla2x00_mailbox_command(vha, mcp);
    ...
    *id =3D mcp->mb[1];
    ...
}

When called from qla27xx_get_bbcr_data(), this uninitialized loop_id
(which comes from *id) is copied to userspace via bbcr.mbx1 when an
error is handled:

drivers/scsi/qla2xxx/qla_bsg.c:qla27xx_get_bbcr_data() {
    ...
    if (rval !=3D QLA_SUCCESS) {
        bbcr.status =3D QLA_BBCR_STATUS_UNKNOWN;
        bbcr.state =3D QLA_BBCR_STATE_OFFLINE;
        bbcr.mbx1 =3D loop_id;
        goto done;
    }
    ...
done:
    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
        bsg_job->reply_payload.sg_cnt, &bbcr, sizeof(bbcr));
}

Should mc be initialized to zero, or should the output assignments be skipp=
ed
if qla2x00_mailbox_command() fails?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D16
