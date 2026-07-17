Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036E120010A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304030; cv=none; b=XO7mnTndnMdt/IoOvssqkJM5q4ctp5xVILVjLWbLCTMKKOvytM4jsXLRYFDlSuR6xKUc6uZn8qRvDvMMQMHBJWFyn4QGhzYUzXVIcjo8BHBNYbfwKn+zhcjbmmotX/vq4P4vbAU+JSu0CnrNVLOAbFBcRq3d7EjqfFGgEoBw2o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304030; c=relaxed/simple;
	bh=l2FFvV33BWYt7P4F7T4iVWbZBeTKdTem0vS0ZFd0juQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BtWrBHy09AMRfWj9VCC2XTKWYUj5bV1q7RLOsEjjvdaEuljZoMFBMCr+m2yEjbhzN9r4GiGLd1+vTxfw/9siDQIgoqI1zO6ei5Ll1Wxl+n21/KEmVFMQLiOv1273UzoaQZ88MzjA6j9IeZSDFNDVLSACZosazGK7Senwk6LM33A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KD4I4353; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KD4I4353"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8F21F000E9;
	Fri, 17 Jul 2026 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304028;
	bh=tONTAFyua5ThJH1eIhcgWY7npVGBXVoOOD+gfb/PH6I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KD4I4353DxOip1/6ofumk6QqsHQdQFDF1oWXi+4hjyd+MAWPdVFZUdZaCmoO/Uzv0
	 9YjuLxXBW6/rm+y5w/eqwQF8GPAwNcHBgSshtdgiQX1Z5dbC8h4Om6tn4Ex07YtN4O
	 m7PGieXPRsGBCEnhUYzCSSBYiTmeQfyITj3FHZeV7LOrE5CJj4Pm8zCHCVg7NoRJZ/
	 BTr3+G46TRZaid8lklz5HhA14pdsgHm1eZjfU7aYhFfkv4YB46kUO/4VKi+UOgz7W2
	 uozKnqpGdO2XPKfhTLQqvv50J08L0A3Z0QnwCBg0DU/fGCm6hTc5t3XAkH+TJ5X9v2
	 VkQK+DIhKa4ww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/56] scsi: qla2xxx: Enable get_adapter_id mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-17-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-17-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:00:28 +0000
Message-Id: <20260717160028.7C8F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] Missing QLA29XX support in BSG command handler prevents BBCR fea=
ture access.

Pre-existing issues:
- [High] Uninitialized kernel stack memory leak to userspace in `qla27xx_ge=
t_bbcr_data()`.
- [High] Race condition due to unprotected read-modify-write on shared `vha=
->hw->flags` bitfield.
--

--- Patch [16]: [PATCH v5 16/56] scsi: qla2xxx: Enable get_adapter_id mailb=
ox for 29xx ---
commit 6a9facae245c0e3d5c4d496991f281dbefb90de2
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx

This patch adds the IS_QLA29XX() check to qla2x00_get_adapter_id() alongside
the existing 27xx/28xx logic. This allows 29xx adapters to read additional
mailbox registers for buffer-to-buffer credits and SCM/EDC status.

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

[Severity: High]
This is a pre-existing issue, but does this function leak uninitialized ker=
nel
stack memory to userspace?

In qla2x00_get_adapter_id(), the mailbox command structure is allocated on
the stack without initialization:

	mbx_cmd_t mc;
	mbx_cmd_t *mcp =3D &mc;

If qla2x00_mailbox_command() fails early (e.g., due to timeout or reset),
the mc.mb array isn't populated from the hardware registers. However, the
function still unconditionally assigns the uninitialized stack data to the
id pointer:

	/* Return data. */
	*id =3D mcp->mb[1];

When called from the BSG handler, this uninitialized data is saved to
bbcr.mbx1 in the error path and then copied to userspace:

drivers/scsi/qla2xxx/qla_bsg.c:qla27xx_get_bbcr_data() {
...
	rval =3D qla2x00_get_adapter_id(vha, &loop_id, &al_pa, &area,
...
	if (rval !=3D QLA_SUCCESS) {
		bbcr.status =3D QLA_ST_WWN_MN_FAIL;
		bbcr.mbx1 =3D loop_id;
		goto done;
	}
...
done:
	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
		bsg_job->reply_payload.sg_cnt, &bbcr, sizeof(bbcr));
...
}

Should mc be zero-initialized to prevent leaking stack data?

>  		mcp->in_mb |=3D MBX_15|MBX_21|MBX_22|MBX_23;
> =20
>  	mcp->tov =3D MBX_TOV_SECONDS;

[ ... ]

> @@ -1827,7 +1827,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16=
_t *id, uint8_t *al_pa,
>  			}
>  		}
> =20
> -		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
> +		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))=
 {

[Severity: Medium]
Will this BBCR data actually be accessible for 29xx adapters from userspace?

While this patch adds support for reading the BBCR and SCM/EDC data for 29xx
adapters, the BSG command handler used to retrieve this data appears to lack
the corresponding IS_QLA29XX() check:

drivers/scsi/qla2xxx/qla_bsg.c:qla27xx_get_bbcr_data() {
...
	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
		return -EPERM;
...
}

Does qla27xx_get_bbcr_data() also need to be updated to include 29xx adapte=
rs
so the feature is fully reachable?

>  			vha->bbcr =3D mcp->mb[15];
>  			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {
>  				ql_log(ql_log_info, vha, 0x11a4,

[Severity: High]
This isn't a bug introduced by this patch, but does the following SCM logic
have a race condition?

Just below this log statement in the same block, there is an unprotected
read-modify-write on a shared bitfield:

			if (mcp->mb[7] & SCM_RDF_ACC_RECEIVED) {
				vha->hw->flags.scm_enabled =3D 1;

The flags member is a volatile struct containing bitfields like
scm_enabled:1, lip_ae:1, and n2n_ae:1. Because this modification occurs
in process context without holding a hardware spinlock, it performs a
non-atomic read-modify-write on the shared 32-bit word.

If an asynchronous hardware event fires during this operation, the ISR
might set a bit like lip_ae =3D 1. The process context would then overwrite
the change with stale data, silently dropping the ISR's modification.

Could this lead to dropped loop initialization events?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D16
