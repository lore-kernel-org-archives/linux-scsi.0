Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA012798EA
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792024478; cv=none; b=R9m9wXzSnDGcuWc/RnaoCi1Kt44z6xtCd+8U/nR8+9cQnatIO1m89R0WRV++bWtOelojQcqDOctUgFvdoVF31aZvwqXd9I71FmBnahr73u3TM9kEjxtQdgnsxKWlVwG25IWulwhROuWr5suU3RqaJPgARUTDHzZZGEFeARyM1ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792024478; c=relaxed/simple;
	bh=BVV2lwvj60A1d2yRev58ceJWGTVCx2dZl/mJ4JGJl3I=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eKft5DCmzBv4Er2Lc2AwLrGEx76BZBp8e8porEjDhMRLCCgWC1PF6NIgM/All2gVhim5k1JEPbfuqbhyrBRl8o82asTf0iGpL7k2M9I/ESIOO0ug26/b9XkdxFyxXY0iP4pPQ30/wQrElrU69JzxfIfg2W/mE8Rivz96jxzUPMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdIGkrdV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdIGkrdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8171F000C4;
	Thu, 15 Oct 2026 00:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792024477;
	bh=XMz39wFDDgpAdG+Jco/cARRW7T6NKlAspYHF/gRliPA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PdIGkrdVMlGaycgEhWkERFZwxCo/jcqBdA2RK0IDE74tmI6sMBxYZEIcERdynGOEr
	 ZtzVyazq2zF4+tw5ygt8TD5MlDiDnELJxKusxb/8u7GgfiY6pfw6crTRKpWc9ye5BE
	 Amrt6diX+VSr1DTADUYm3xYz7W9+pS+rD6RtJty850pD4ajwy0hKD2zrJJW5csmzs/
	 By4Clpw3ZGQxvQIfpNOlR/jZDF8ZHWVEca5hZkxBg8cF/m/K6sMuSPwlcJdzpV+tpx
	 2Mgl1Uemmb7tqTVGmMDe8aXiM4aQiJ0hj0KsPn0ZiPQ3YuYZgyRBxTGw73TrqNYKFC
	 oX2/HKhNmrpnw==
Message-ID: <sashiko-outbox-172059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/5] scsi: ufs: bsg: Clear the reply buffer before
 use
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015001855.3450573-3-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
 <20261015001855.3450573-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 00:34:36 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ufs: heap overflow in ufs_bsg_exec_advanced_rpmb_req()
--

commit 8509b25f617ae6bb6b7c915900b84d8957279281
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: bsg: Clear the reply buffer before use

This commit clears the bsg job reply buffer upon entry to ufs_bsg_request()
to prevent leaking bytes from an earlier request on the same tag. It
replaces a targeted zeroing of the length field with a memset of the entire
buffer.

> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 18c318d781224..545ef7b79ceb5 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -140,7 +140,7 @@ static int ufs_bsg_request(struct bsg_job *job)
>  	int ret;
>  	bool rpmb =3D false;
> =20
> -	bsg_reply->reply_payload_rcv_len =3D 0;
> +	memset(job->reply, 0, job->reply_len);

[Severity: High]
Does this regression still allow a heap buffer overflow when processing
Advanced RPMB requests?

While the memset safely clears the 96 bytes initialized by bsg_init_rq()
in block/bsg-lib.c, the subsequent handling in
ufs_bsg_exec_advanced_rpmb_req() in drivers/ufs/core/ufs_bsg.c casts this
96-byte buffer to a struct ufs_rpmb_reply, which is 104 bytes in size.

When ufshcd_advanced_rpmb_req_handler() in drivers/ufs/core/ufshcd.c
handles the response, it executes:

memcpy(rsp_ehs, ehs_data, ehs_len * 32);

Will this copy write 64 bytes starting at offset 40, exceeding the 96-byte
allocation by 8 bytes and corrupting out-of-bounds memory?

> =20
>  	ufshcd_rpm_get_sync(hba);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015001855.3450=
573-1-stanleyjhu@google.com?part=3D2
