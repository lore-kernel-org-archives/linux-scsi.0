Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C4B38BF9A
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 03:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785382879; cv=none; b=aO3EmqDH0yqJENE/Hcu1Awu5LKikEvWMgB3Vjx0Vu5smQJbbgkycHvUxDB9ZgBVmzrEnOhCd9xCjRhc14UGxfdzyfAKCUDwsLqSO5H2/1Ns8aiU5Go9Yb2nyVXMPP3+bWDmsML133st1kZ5yrisS8sGpQl/BQf2X9cnT0KVwWco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785382879; c=relaxed/simple;
	bh=4oEWvswD1SPYJ82Ja6lJUgiEJiBHXQz1O7mwuqhP6yw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uLudT6TmHrF2vv5QFts1TBjp08vxXMApX6RaYt5NeKPyuFGGnIdCeZkk5JVAScKvxRL9PcpYtrVUnyURloKRrSK0HFK44S7HAgNP5FB59k2oOs7d2rvTum1vSYhFu9Thqq+e4meUbDQhyyop0f5LQ1F6OF7Utz7waUlA1AUlblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnxL2CI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnxL2CI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5841F000E9;
	Thu, 30 Jul 2026 03:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785382877;
	bh=Leu892mAKvn2Z0tpTpB9LBc8i46cMxQMrAdCGvg6DSw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mnxL2CI6dCL+LYu78dXkVxLBPlyGH8eEqb38CRAnMFRdB720gMLC/e1WqiPO5fx1Q
	 hoDgWwTVfLWX8ZKWWDU3EONCPlnoJt8/p8LR/YvRQWdSp4rQ94WVSN0m/M5wro6N3e
	 KCz3JPj/DF8Y6L4PMfmDY4+RkrZTkeY4VyDhZXh+Ja19N/nP71GBNEzLOjR72ad55A
	 cC/2Pt+L82geGEqvZIA5GD/uQ5t41IEpUh9kV25W6uFHJpXlQTOjmMJWh7Ir536vRg
	 0czN1nrrKL6UAnigFz5tqZVVz+N7nHVEmZP6hKaoD3GiHQga1nNUpg3cpalPlZdhSr
	 zH0h9iT8q3NGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: Fix stack out-of-bounds in ALUA lu_gp and
 tg_pt_gp store
Reply-To: sashiko-reviews@lists.linux.dev
To: kensanya@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260730031917.72750-1-kensanya@163.com>
References: <20260730031917.72750-1-kensanya@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 03:41:17 +0000
Message-Id: <20260730034117.8D5841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Writing "NULL" to a device's alua_lu_gp configfs file when the cur=
rent group is NULL triggers a guaranteed NULL pointer dereference.
--

--- Patch [1]: [PATCH] scsi: target: Fix stack out-of-bounds in ALUA lu_gp =
and tg_pt_gp store ---
commit 57ed25faa0822b84299ce2ade4007a8dc2229f88
Author: TanZheng <tanzheng@kylinos.cn>

scsi: target: Fix stack out-of-bounds in ALUA lu_gp and tg_pt_gp store

Both alua_lu_gp and alua_tg_pt_gp allow a write of exactly
LU/TG_PT_GROUP_NAME_BUF bytes into a same-sized stack buffer. This commit
enlarges the local buffers by one byte so a full-sized write remains
NUL-terminated when passed to strstrip().

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index 2b19a956007b7..0e50987e6dbee 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2518,7 +2518,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct c=
onfig_item *item,
>  	struct se_hba *hba =3D dev->se_hba;
>  	struct t10_alua_lu_gp *lu_gp =3D NULL, *lu_gp_new =3D NULL;
>  	struct t10_alua_lu_gp_member *lu_gp_mem;
> -	unsigned char buf[LU_GROUP_NAME_BUF] =3D { };
> +	unsigned char buf[LU_GROUP_NAME_BUF + 1] =3D { };
>  	int move =3D 0;
> =20
>  	lu_gp_mem =3D dev->dev_alua_lu_gp_mem;

[Severity: High]
This is a pre-existing issue, but I noticed a potential NULL pointer
dereference further down in target_dev_alua_lu_gp_store().

If a user writes "NULL" to the alua_lu_gp attribute when the current LU gro=
up
is already NULL (e.g., by writing "NULL" twice), the early return block ins=
ide
if (lu_gp) is bypassed:

drivers/target/target_core_configfs.c:target_dev_alua_lu_gp_store() {
    ...
	lu_gp =3D lu_gp_mem->lu_gp;
	if (lu_gp) {
        ...
		if (!lu_gp_new) {
            ...
			return count;
		}
        ...
	}
	/*
	 * Associate lu_gp_mem with lu_gp_new.
	 */
	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
    ...
}

This causes the function to fall through to __core_alua_attach_lu_gp_mem()
with lu_gp_new =3D=3D NULL, where it is unconditionally dereferenced during=
 lock
acquisition:

drivers/target/target_core_alua.c:__core_alua_attach_lu_gp_mem() {
    ...
	spin_lock(&lu_gp->lu_gp_lock);
    ...
}

Should there be a check to return early if both lu_gp and lu_gp_new are NUL=
L?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730031917.7275=
0-1-kensanya@163.com?part=3D1
