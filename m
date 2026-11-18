Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044809;
	b=1lLew+aOqK2EhZEn9mjwS64TWPEoHOy3jEmX3X8aFXDPNQYYrEcqk2wix4FgbWoGyTuZ
	 Qjm4prQHMFAwMUKhJSjfMPii9va6fgZsLqJHUABiB3F7UUzO+Xg1fBnhhGY09I0nPF388
	 RLhkyzo2nH1ZGAWHQKGtl18iQyJapa9lUT2pgS2ddR69iPcJ41+wD8gDdqKbH+kRh/0Sq
	 ipaiXKBCORgPKOfqfBc4zUona++9THKMSeXe4ErrHeXSigWfbwJTqoAFr/6nAHaBowpjZ
	 DWGnvM7iDiVfqXuP9dXkIIHHu3i3fXKDPnDfNSEStvZo1xMzs4llPvDsAdUk5VxciSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044809;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HdO/btX1/Fvwe93IMJTemCMkMbwYfFx2AxyeoZY4knU=;
	b=fpB4AyFmE9g+Kqj6gy2DR1t3ryzGw0FXS6NL4qcacGIN5edkc56C9rosR8aPU5X3iIMZ
	 +63L5q26rRHUqhmBG4cp7bGMn31a/JQIsU2Ztuz+fuPXz6XjDnWYIckbq7Q6vndABm/0a
	 jgihlVA/+sVNvbYFm7fCHHsxMhEw/k0/NoY9umUlF9dHs50qR+Y0amSTvGj5DdMUsqp7N
	 jKVWFjEhCfm6po3R8W/xIa77LRWfhCeqVy7T2h2GogrUyEYWQFiFYcgwu1nohIdLr6p42
	 vooFxsJkM8xtieHeDawBqiquEGI1QN+ChDN6jbSzrRcfuYPBCOHOTjtbUZxvEWgErjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YgJpZN3d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7D760A2601
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YgJpZN3d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067C81F000C7;
	Wed, 18 Nov 2026 23:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044809;
	bh=HdO/btX1/Fvwe93IMJTemCMkMbwYfFx2AxyeoZY4knU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YgJpZN3duzMfwrhgKolrOojDpLwQJrwyjky+gl5QyVJUdLEdp48N+zTN5JLdI4MaY
	 uMNeyHTQOHdc76JFBZruHd6T4wNrGpm5vaPIufKqD/8BT4e4xV5ctWAIqvZKV80sPZ
	 hceDB7qva/wzS06iG47rdnB/xpgh1m4nuq0aDiHRbblXe6ADujtt3IUrpkggXcIPzq
	 gIVjyzzSosjHelbG9rjTQNCOQ98Z9SXPvUtXVv75kHRgwLHTgx8w3NKFWNzSjbUTad
	 Dcc3bmtjJ8KAp8Wd5TYEdWrqsYHR8c1nj4Cocn+kaT6RVfpIIGhm6jPxU1Gnj3i3ig
	 jwV5VmJ424eLg==
Message-ID: <sashiko-outbox-222184@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/11] scsi: mpt3sas: Time out delayed not-responding
 device blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261118-sas-abba-v3-11-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
 <20261118-sas-abba-v3-11-5562d690cf61@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:33:28 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] scsi: mpt3sas: new DNR events ignored while polling in
  _scsih_block_io_device()
- [Medium] scsi: mpt3sas: sticky deleted flag on sdev prevents future
  device blocking
--

commit bc92a124ea93f9bf48382ebe6742a2dde2541670
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Time out delayed not-responding device blocks

This commit adds a delayed work item to time out and release delayed
not-responding SDEV_BLOCK states after the firmware device missing delay
plus a 30-second margin, and coordinates that timeout with device readiness
polling and broadcast primitive handling.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 814c18289cf1c..6eb92bd4f1225 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
[ ... ]
> @@ -4125,23 +4128,106 @@ _scsih_get_target_ids(struct MPT3SAS_ADAPTER *io=
c, struct scsi_device *sdev,
[ ... ]
> +static bool
> +_scsih_claim_block(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
> +		   struct MPT3SAS_DEVICE *sas_device_priv_data,
> +		   unsigned int *block_seq)
> +{
> +	unsigned long flags;
> +	bool claimed =3D false;
> +
> +	spin_lock_irqsave(&ioc->block_lock, flags);
> +	if (sdev->hostdata =3D=3D sas_device_priv_data &&
> +	    (sas_device_priv_data->block || sas_device_priv_data->dnr_expired))=
 {
> +		sas_device_priv_data->block_deadline =3D 0;
> +		sas_device_priv_data->dnr_expired =3D 0;
> +		*block_seq =3D sas_device_priv_data->block_seq;
> +		claimed =3D true;
> +	}
> +	spin_unlock_irqrestore(&ioc->block_lock, flags);
> +	return claimed;
> +}
[ ... ]
> @@ -4149,8 +4235,15 @@ _scsih_end_poll(struct MPT3SAS_ADAPTER *ioc, struc=
t scsi_device *sdev,
>  	spin_lock_irqsave(&ioc->block_lock, flags);
>  	if (!__scsih_get_target_ids(sdev, sas_device_priv_data, ids))
>  		goto out;
> +	if (sas_device_priv_data->block_seq !=3D block_seq) {
> +		sdev_printk(KERN_INFO, sdev,
> +		    "blocked again while polled, handle(0x%04x)\n",
> +		    ids->handle);
> +		goto out;
> +	}
>  	if (!ready)
>  		sas_device_priv_data->deleted =3D 1;
> +	/* not blocked if dnr_unblock_work released it before polling */
>  	if (sas_device_priv_data->block)
>  		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
>  	ret =3D true;
[ ... ]
> @@ -4536,10 +4818,30 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *io=
c, u16 handle)
>  			goto next;
>  		if (sas_device_priv_data->sas_target->handle !=3D handle)
>  			goto next;
> -		if (sas_device_priv_data->block)
> +		deadline =3D (jiffies + _scsih_dnr_block_timeout(ioc,
> +		    sas_device_priv_data->sas_target)) ?: 1;
> +		if (sas_device_priv_data->block) {
> +			/* a repeat DNR restarts the firmware's missing delay */
> +			if (sas_device_priv_data->block_deadline &&
> +			    sas_device_priv_data->block_extends <
> +			    MPT3SAS_DNR_BLOCK_MAX_EXTENDS) {
> +				sas_device_priv_data->block_extends++;
> +				sas_device_priv_data->block_deadline =3D deadline;
> +				__scsih_dnr_unblock_work_by(ioc, deadline);
> +			}
>  			goto next;
> +		}

[Severity: Medium]
Does _scsih_block_io_device() drop a new DELAY_NOT_RESPONDING event that
arrives while the firmware event worker is polling a still-blocked sdev?

Before polling, _scsih_ublock_io_all_device(),
_scsih_ublock_io_device_wait() and _scsih_claim_block() clear
sas_device_priv_data->block_deadline to 0 while leaving
sas_device_priv_data->block set to 1:

kworker                           <hardirq>
_scsih_ublock_io_device_wait()
  block_deadline =3D 0
  _scsih_claim_block()
    *block_seq =3D priv->block_seq
                                  _scsih_block_io_device()
                                    if (priv->block)
                                      if (priv->block_deadline && ...)
                                      goto next;
  _scsih_end_poll()
    if (priv->block_seq !=3D block_seq)
    _scsih_internal_device_unblock()  <-- unblocks or offlines during DNR

Because sas_device_priv_data->block is still 1 and block_deadline is 0,
_scsih_block_io_device() neither increments block_seq nor sets a new
block_deadline.  _scsih_end_poll() then sees an unchanged block_seq and
either unblocks the non-responding device to SDEV_RUNNING or marks it
deleted and offlines it during the active device missing delay.

Also, in the second loop of _scsih_ublock_io_all_device() and
_scsih_ublock_io_device_wait(), _scsih_claim_block() is called lazily per
sdev.  If an sdev whose previous block already expired (block =3D=3D 0,
dnr_expired =3D=3D 1) receives a new DELAY_NOT_RESPONDING block while an
earlier sdev is being polled, _scsih_claim_block() will claim that new
block, clear its block_deadline and poll it immediately.

>  		if (sas_device && sas_device->pend_sas_rphy_add)
>  			goto next;
> +		/*
> +		 * Expiry would bring it back running without a TUR check.
> +		 * _scsih_ublock_io_device_wait() polls offline devices anyway.
> +		 * A device that failed its TUR check is marked deleted under
> +		 * block_lock, before it is set offline.
> +		 */
> +		if (sdev->sdev_state =3D=3D SDEV_OFFLINE ||
> +		    sas_device_priv_data->deleted)
> +			goto next;

[Severity: Medium]
Can sas_device_priv_data->deleted remain set to 1 after an offlined sdev is
returned to SDEV_RUNNING?

When a readiness check fails, _scsih_end_poll() sets
sas_device_priv_data->deleted =3D 1 under ioc->block_lock before the caller
sets sdev->sdev_state to SDEV_OFFLINE.  The only place that clears
sas_device_priv_data->deleted back to 0 is the first loop of
_scsih_ublock_io_device_wait(), and only when sdev->sdev_state is still
SDEV_OFFLINE.

If an administrator brings the offlined device back to SDEV_RUNNING via
sysfs, sas_device_priv_data->deleted stays 1, so _scsih_block_io_device()
and _scsih_block_io_all_device() will skip blocking that sdev on all future
DELAY_NOT_RESPONDING and broadcast primitive events.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-sas-abba-v=
3-0-5562d690cf61@kernel.org?part=3D11
