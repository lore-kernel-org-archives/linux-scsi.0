Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073652;
	b=bgNZOGY2e6j/uxPWUebupcCNzE85kPUn0KRUbvXiaxWGccWg+IV1LFfzvjLUcObC810M
	 zZWBzbIUoeixZqaFasznpG+SXUxJGMRiD+uJapgx365QMxgaQb3xtXtK4mem9KtGuqTE/
	 /g9x+3Zr/zpo5vDVQIX1lMtubKoILxSuA3iLElAx3Sp+pf2zDnKghsFPxEoKAsNa1MFl6
	 fxume1uNeADhWMZZByEjdyzKo2cy1bYDfdAmR4oPVM54NXxKernMa7TkpK/3/vZO2bwmp
	 rH8svPiA9Rpo9bUCKlm15bLnk7RMRY46N8ju9FTLAzHm+R2NLH6nF5WUZSTcnXW2wAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073652;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nM1mXnrQYsTZGohO+IzpVKG3W1NHZ4NGSu801R5vpbw=;
	b=R3JkslSNXGxW+BKPeugWaOmSZx4RQqRD6qHlXKSRGEdrSh7RS6Hm63snkM0YpVm4MuOu
	 Jt4b6Zp/nktxKlmgcV1JP2oeV7602cZ+NsjYptTVJfMnFvm+aSc4wc6zhQXQXeb9RGBEH
	 jnH7qSxts+KH0c90qlP6cC3H8iiSMeSWkr/GVA6Xp6+SRtVoaSB5MJSqNjOh/LU6lyyjt
	 6gqhATjpmn2YiBqNSiNXFHLNB8xW9Sy7ukONINov7qNB0YTzH5SjSPMWOUd2rSlR+S2z0
	 796kRP3LDMBsK7ImXM9LnPQeq9AChWVJK2LDedno03UYe1oPG5wxuxUay/s/wAZoB8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmPQqVUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B34606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmPQqVUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D621F000C4;
	Thu, 19 Nov 2026 07:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795073652;
	bh=nM1mXnrQYsTZGohO+IzpVKG3W1NHZ4NGSu801R5vpbw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=BmPQqVUpOw47xkNvLpLkfJ4IAcIl6NUEoSTKpFZmNG/CXdsBJLGIs8hGGroWCgSAT
	 RKnzac9/iTHTgbYMN1LdcfEJbnnipIHHXVW9TAvcufi7UoHDe78Tz3Ik2OrYxM2iPg
	 W7XEn25C645zitqhqW/NbIrB8whcI9yYxw22YA6oZPCqoZlAAsQj/r4QFwFRKnKr6c
	 j9Lp210DUIOfXjT9PPrww6O0Y3mLX+VKDt42v3ZfPpfsBq89mGHcwOSYSqcB3F0GYM
	 cOjDZgy0nnAbY05MOY4k2wssB5hzQWkj3tKN+s6925RkvEN6gU83xkGKM1GbhjgMQk
	 Dcx7yIh0RG5KA==
Message-ID: <sashiko-outbox-222605@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/20] scsi: mpi3mr: Fix sense buffer use after free
 on BSG command completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261119071133.127282-17-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
 <20261119071133.127282-17-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 07:34:11 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: mpi3mr: race on bsg_cmds.done and reply in
  mpi3mr_bsg_process_mpt_cmds()
--

commit 8590d021fe282f240b050a47484ba6f1b211d756
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

scsi: mpi3mr: Fix sense buffer use after free on BSG command completion

This commit adds a spinlock to struct mpi3mr_drv_cmd to serialize access to
command state, sense buffers, and completion callbacks between BSG command
handling, admin reply processing, and controller resets.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 30a01b02a9fc6..fb54bd8093da5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
[ ... ]
> @@ -2795,11 +2797,13 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bs=
g_job *job)
>  			block_seq =3D mpi3mr_tgtdev_block_io_inc(mrioc, tgtdev);
>  	}
> =20
> +	spin_lock_irqsave(&mrioc->bsg_cmds.state_lock, flags);
>  	mrioc->bsg_cmds.state =3D MPI3MR_CMD_PENDING;
>  	mrioc->bsg_cmds.is_waiting =3D 1;
>  	mrioc->bsg_cmds.callback =3D NULL;
>  	mrioc->bsg_cmds.is_sense =3D 0;
>  	mrioc->bsg_cmds.sensebuf =3D sense_buff_k;
> +	spin_unlock_irqrestore(&mrioc->bsg_cmds.state_lock, flags);
>  	memset(mrioc->bsg_cmds.reply, 0, mrioc->reply_sz);
>  	mpi_header->host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_BSG_CMDS);
>  	if (mrioc->logging_level & MPI3_DEBUG_BSG_INFO) {

[Severity: Medium]
Should memset(mrioc->bsg_cmds.reply, ...) and
init_completion(&mrioc->bsg_cmds.done) run before releasing
mrioc->bsg_cmds.state_lock?

Once state is set to MPI3MR_CMD_PENDING with is_waiting =3D 1 and state_lock
is released, a concurrent reset or a late reply from an earlier timed-out
BSG command can acquire state_lock and complete bsg_cmds before
init_completion(&mrioc->bsg_cmds.done) runs:

CPU0                                  CPU1
mpi3mr_bsg_process_mpt_cmds()
  spin_lock_irqsave(&state_lock)
  bsg_cmds.state =3D MPI3MR_CMD_PENDING
  bsg_cmds.is_waiting =3D 1
  spin_unlock_irqrestore(&state_lock)
                                      mpi3mr_soft_reset_handler()
                                        ...
                                        mpi3mr_drv_cmd_comp_reset()
                                          spin_lock_irqsave(&state_lock)
                                          complete(&bsg_cmds.done)
                                            <-- NULL pointer dereference
                                          spin_unlock_irqrestore(&state_loc=
k)
  init_completion(&bsg_cmds.done)

Because mpi3mr_init_drv_cmd() does not initialize cmdptr->done, on the
first BSG command after probe bsg_cmds.done is still all-zeroes and
complete() dereferences NULL in swake_up_locked().  On later BSG commands,
init_completion() outside state_lock races with complete() on
done.wait.lock or resets done.done after the wakeup, and memset() on
bsg_cmds.reply races with memcpy() in mpi3mr_process_admin_reply_desc().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119071133.1272=
82-1-ranjan.kumar@broadcom.com?part=3D16
