Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044810;
	b=yHGOuHo9xiOP0dpOymcsSsLa44DLP65YE0mBAnM0EAFzKBc2aJUpDgaaMuywUO4dO62p
	 ZUD10eVdTE9I1Yoxvb5fFyirrlFQ+4cdwHrii7M7pRbRi77r4VnlZ4P/3/m4VlUH+0srK
	 9riOtRc6v8h1VysOt39/1+jgeduY5HiH2o70+mycfvoeTVXps0to9yqcG1ccn6SlujoVK
	 IA8ctH3ApgTzPBHQAuezdhcCMlzCCfmT/bIIOyD1pa5U2SQyKrv4l8OXv85u6BeiEOc5Y
	 q6CXc2YJ63hQgCCx6R/ACxMLf9Tg1mnieffFRfZv5iQ3GRmcbbK7Qvk224xcWFGIerg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044810;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OBAYbr3OIV9trRJuu6dInuIxhKlqc9idSYeHlkZLew4=;
	b=5CsPp7Rhz8tBEz/S7e78B+MWAJc9v/00ySjsJlxBD1AA/kvKR8ZXWX/0saFYf5FW8rDy
	 L+xuvJoG7pZhq7u7MU2k4otXcVP68MVVKwGJ3a/ENyGn/mYOqeVy7JLaCStkCGo5mm6dQ
	 nOCbp/34DTAO898skB5fU6hEqGhfmM2IXm7jNI9hdvqZUnhE1i2yCRLWpZjoFjA6XjZgE
	 2tLIQL77tv+BjTK9GRc+tDc57VVohiQFlx/BtttAmtmVuKd7NjXVwXQCAApF7ctrowiRe
	 mks5o/174KjTd2Uk5fDSh6CYeR0l73/LNJyXDOcn15i7mzrVKBYibzQKV47xKGjcFYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n1yWC88b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB4D60A2630
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n1yWC88b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A660F1F000C6;
	Wed, 18 Nov 2026 23:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044809;
	bh=OBAYbr3OIV9trRJuu6dInuIxhKlqc9idSYeHlkZLew4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n1yWC88bjyCtmkhSD29R5QViSsKe1n4sgT9Je8Nw7X6YT4FCGmmTdvrqHnopqk70P
	 EtLFQDIQ4huxZfB9xqWr3/PwZwQN5Rp6nnbHj4Sw7WpVW5Cf9aT6W/L3daVXm0HUT1
	 AUAuu9vfajmCLvSKsXRyHE1f9pPNmHoTenGnfk7dXg7yks63COa5NyDDZfjzFan5NV
	 wVE5M5+nY7jNOHdXUOMEvFkOwZqz7tKKhnzZoc9LBOu8nAHmWd9USEmVPTRbQLDqMt
	 ywp0QasbPyp3DghT7iNZ2n0vdqKwpvA/ZiFpPnuteWq1heJyOPKjO7K/osrtD2okhk
	 RYDdFy6bjospg==
Message-ID: <sashiko-outbox-222185@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/11] scsi: mpt3sas: Don't leave requeued firmware
 events pending at teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261118-sas-abba-v3-1-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
 <20261118-sas-abba-v3-1-5562d690cf61@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:33:29 +0000
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
- [High] scsi: mpt3sas: races in _scsih_fw_event_requeue() and cleanup
  queue
--

commit 462c12ccec856fed92f29e6abf5abd84f2b713ca
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Don't leave requeued firmware events pending at teardown

This commit initializes fw_event->delayed_work at allocation, skips
requeuing events when the queue is being cleaned up or the host is being
removed, and cancels pending delayed_work items during queue cleanup.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 04255286a2a69..545913123d01f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
[ ... ]
> @@ -3704,20 +3712,31 @@ _scsih_fw_event_requeue(struct MPT3SAS_ADAPTER *i=
oc, struct fw_event_work
>  {
>  	unsigned long flags;
> =20
> -	if (ioc->firmware_event_thread =3D=3D NULL)
> -		return;
> -
>  	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> +	/*
> +	 * Don't rearm the event while the queue is being flushed or the
> +	 * host is going away.  _scsih_fw_event_cleanup_queue() may already
> +	 * be past it, and the timer could then fire after the workqueue
> +	 * has been destroyed.
> +	 */
> +	if (!ioc->firmware_event_thread || ioc->remove_host ||
> +	    ioc->fw_events_cleanup)
> +		goto drop;
> +	fw_event->delayed_work_active =3D 1;
> +	/*
> +	 * Cleanups can overlap, and one can clear fw_events_cleanup while
> +	 * another is cancelling, and so disabling, the delayed work.
> +	 */
> +	if (!queue_delayed_work(ioc->firmware_event_thread,
> +	    &fw_event->delayed_work, msecs_to_jiffies(delay)))
> +		goto drop;
>  	fw_event_work_get(fw_event);
>  	list_add_tail(&fw_event->list, &ioc->fw_event_list);
> -	if (!fw_event->delayed_work_active) {
> -		fw_event->delayed_work_active =3D 1;
> -		INIT_DELAYED_WORK(&fw_event->delayed_work,
> -		    _firmware_event_work_delayed);
> -	}
> -	queue_delayed_work(ioc->firmware_event_thread, &fw_event->delayed_work,
> -	    msecs_to_jiffies(delay));
>  	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +	return;
> +drop:
> +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> +	fw_event_work_put(fw_event);
>  }
> =20
>   /**
> @@ -3869,9 +3888,17 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPT=
ER *ioc)
>  		 *
>  		 * If it did execute, we wait for it to finish, and the put will
>  		 * happen from _firmware_event_work()
> +		 *
> +		 * An event requeued by _scsih_fw_event_requeue() is pending
> +		 * on its delayed_work instead, and its timer must not fire
> +		 * after the workqueue is destroyed.
>  		 */
> -		if (cancel_work_sync(&fw_event->work))
> +		if (fw_event->delayed_work_active) {
> +			if (cancel_delayed_work_sync(&fw_event->delayed_work))
> +				fw_event_work_put(fw_event);
> +		} else if (cancel_work_sync(&fw_event->work)) {
>  			fw_event_work_put(fw_event);
> +		}
> =20
>  	}
>  	ioc->fw_events_cleanup =3D 0;

[Severity: High]
Can a delayed_work timer still fire after ioc->firmware_event_thread is
destroyed when two cleanups overlap, or can a stale topology change event
still requeue itself after a host reset cleanup?

_scsih_fw_event_cleanup_queue() does not serialize concurrent callers and
does not wait for a running topology change event (it skips waiting when
ioc->current_event->event !=3D MPT3SAS_REMOVE_UNRESPONDING_DEVICES and
clears ioc->fw_events_cleanup =3D 0 as soon as the loop finishes).  If a
reset cleanup overlaps with teardown in scsih_remove() or scsih_shutdown():

CPU0 (reset cleanup)              CPU1 (scsih_shutdown / scsih_remove)
_scsih_fw_event_cleanup_queue()
  fw_event =3D dequeue_next_fw_event()
                                  _scsih_fw_event_cleanup_queue()
                                    /* list_empty && !current_event */
                                    return;
                                  wq =3D ioc->firmware_event_thread;
                                  ioc->firmware_event_thread =3D NULL;
                                  destroy_workqueue(wq);
                                  /* delayed_work timer fires on wq */
                                    __queue_work()  <-- use-after-free
  cancel_delayed_work_sync()

In addition, when a host reset cleanup runs while a topology change event
is executing, _scsih_fw_event_cleanup_queue() sets
ioc->current_event->ignore =3D 1, clears ioc->current_event =3D NULL, and
resets ioc->fw_events_cleanup =3D 0 without cancelling or disabling
fw_event->delayed_work.  If _scsih_add_device() or _scsih_pcie_add_device()
fails on the final entry of the event (or an earlier entry already set
requeue_event =3D 1), _scsih_sas_topology_change_event() exits its loop and
returns requeue_event =3D 1 without re-checking fw_event->ignore.  When
_mpt3sas_fw_work() then calls _scsih_fw_event_requeue(),
ioc->fw_events_cleanup is already 0 and ioc->remove_host is 0, and
_scsih_fw_event_requeue() checks neither fw_event->ignore nor
ioc->shost_recovery, so the stale pre-reset event still requeues itself.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-sas-abba-v=
3-0-5562d690cf61@kernel.org?part=3D1
