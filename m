Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795451514;
	b=SaTUNEILJU0DoOAbMc59LyLRwALpxINh0ldKab76U3Z2kBsJ2b4tRFdCjWZR0Vz0RqG1
	 5ODcAYAbADTgUUJ2v1zn1FC/e3XBfs2wddSDBSaChBqjyu/FhmyMBVFwOyrdiB8sHTe05
	 BFfKQ+YLVFEAPRT7PAcVFSFxVupbZNyYFhVaABNLP/H9V3vSQbHZXOcZFqsZRi14RK1kC
	 ummjgGo7bs2Vugcg1bSo+HFRjUceu7P/ODP2X39g16dfP0V4dLfygcGdSHTYUfbw0o0ZO
	 eERtUqt2Nz3D7qx7/vjv+tAs4ltovHrm9t6IHfk6xYqBi9cQzadXJPvoUXxRr6gP5Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795451514;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=2XFZAHG8/lZ5+XUZ37cLNWgBIJz2v/s7Nafot/IvbTE=;
	b=roNeWKzWVwudn/04OMX4ol806b2kzVAiI4GKCBrDi/kdmHT3xd4P1cNNMQWkL86MdP4+
	 vq7MH4AIt6UVfAWXSEMuRErE2MVFEMO/IPIQ0A+LX5wGQUa0gb00egHJFOcwTkPCJgWmE
	 OvwrLJIu4z7YtVpNCA1A/1ptKA2Y7Jf6CR0egbIp4cgQP/fXbGAJ1siVijB8zK0mOYoBH
	 EO2BXBZPVsHBrOkMOow3OKL3+YKsq50fSnN6m7CGDVlmpGqg2VlIMEZP/ExB2tnt/MfCi
	 aQOAHkdr4v+dyHJak3OeLmZdhsZ2/YZaYJ6aUhwRoWOtD/fFKAWf5z2dH2I2JPsAPmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hgy0FGoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A27606A32A;
	Mon, 23 Nov 2026 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hgy0FGoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE0F1F000C6;
	Mon, 23 Nov 2026 16:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451513;
	bh=2XFZAHG8/lZ5+XUZ37cLNWgBIJz2v/s7Nafot/IvbTE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hgy0FGoD8ej25eIXvJHGtr/2Q6sOKV7FJFSBh6CupZqfVfiv9GlGd/z8vuutwD9DB
	 54xoZ2SSYki8OGZaZnjtmBmiqnLVVIDXRdSG2CFlMvyxlpAK666h//ev336hRnWW45
	 kCGq2wCW+8A1TLNRZLRq2siZcYUVJmElPeeL51xSXhkCLhorJeVILka/Q8mEDiQbpu
	 /rlJXkMn7Ynvr5/GDoFTIDyf9+hILGaWMgl+JOyH4aVQnQw/X9gc0BnpwFIfvc6M2A
	 9m1GWNpAxrWZj80jBYdZD/RD7/miLiHzw1oYyPztqFzskV2+nRJNlasBhglKYYG3te
	 G3wl8uZFvVBuA==
Message-ID: <e0c3e7028b10b99b6ebd416d42bfcf19b568aed7.camel@kernel.org>
Subject: Re: [PATCH v3 01/11] scsi: mpt3sas: Don't leave requeued firmware
 events pending at teardown
From: Jeff Layton <jlayton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Date: Mon, 23 Nov 2026 11:31:47 -0500
In-Reply-To: <sashiko-outbox-222185@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
	 <20261118-sas-abba-v3-1-5562d690cf61@kernel.org>
	 <sashiko-outbox-222185@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Wed, 2026-11-18 at 23:33 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] scsi: mpt3sas: races in _scsih_fw_event_requeue() and cleanup
>   queue
> --
>=20
> commit 462c12ccec856fed92f29e6abf5abd84f2b713ca
> Author: Jeff Layton <jlayton@kernel.org>
>=20
> scsi: mpt3sas: Don't leave requeued firmware events pending at teardown
>=20
> This commit initializes fw_event->delayed_work at allocation, skips
> requeuing events when the queue is being cleaned up or the host is being
> removed, and cancels pending delayed_work items during queue cleanup.
>=20
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sa=
s/mpt3sas_scsih.c
> > index 04255286a2a69..545913123d01f 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> [ ... ]
> > @@ -3704,20 +3712,31 @@ _scsih_fw_event_requeue(struct MPT3SAS_ADAPTER =
*ioc, struct fw_event_work
> >  {
> >  	unsigned long flags;
> > =20
> > -	if (ioc->firmware_event_thread =3D=3D NULL)
> > -		return;
> > -
> >  	spin_lock_irqsave(&ioc->fw_event_lock, flags);
> > +	/*
> > +	 * Don't rearm the event while the queue is being flushed or the
> > +	 * host is going away.  _scsih_fw_event_cleanup_queue() may already
> > +	 * be past it, and the timer could then fire after the workqueue
> > +	 * has been destroyed.
> > +	 */
> > +	if (!ioc->firmware_event_thread || ioc->remove_host ||
> > +	    ioc->fw_events_cleanup)
> > +		goto drop;
> > +	fw_event->delayed_work_active =3D 1;
> > +	/*
> > +	 * Cleanups can overlap, and one can clear fw_events_cleanup while
> > +	 * another is cancelling, and so disabling, the delayed work.
> > +	 */
> > +	if (!queue_delayed_work(ioc->firmware_event_thread,
> > +	    &fw_event->delayed_work, msecs_to_jiffies(delay)))
> > +		goto drop;
> >  	fw_event_work_get(fw_event);
> >  	list_add_tail(&fw_event->list, &ioc->fw_event_list);
> > -	if (!fw_event->delayed_work_active) {
> > -		fw_event->delayed_work_active =3D 1;
> > -		INIT_DELAYED_WORK(&fw_event->delayed_work,
> > -		    _firmware_event_work_delayed);
> > -	}
> > -	queue_delayed_work(ioc->firmware_event_thread, &fw_event->delayed_wor=
k,
> > -	    msecs_to_jiffies(delay));
> >  	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> > +	return;
> > +drop:
> > +	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> > +	fw_event_work_put(fw_event);
> >  }
> > =20
> >   /**
> > @@ -3869,9 +3888,17 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADA=
PTER *ioc)
> >  		 *
> >  		 * If it did execute, we wait for it to finish, and the put will
> >  		 * happen from _firmware_event_work()
> > +		 *
> > +		 * An event requeued by _scsih_fw_event_requeue() is pending
> > +		 * on its delayed_work instead, and its timer must not fire
> > +		 * after the workqueue is destroyed.
> >  		 */
> > -		if (cancel_work_sync(&fw_event->work))
> > +		if (fw_event->delayed_work_active) {
> > +			if (cancel_delayed_work_sync(&fw_event->delayed_work))
> > +				fw_event_work_put(fw_event);
> > +		} else if (cancel_work_sync(&fw_event->work)) {
> >  			fw_event_work_put(fw_event);
> > +		}
> > =20
> >  	}
> >  	ioc->fw_events_cleanup =3D 0;
>=20
> [Severity: High]
> Can a delayed_work timer still fire after ioc->firmware_event_thread is
> destroyed when two cleanups overlap, or can a stale topology change event
> still requeue itself after a host reset cleanup?
>=20
> _scsih_fw_event_cleanup_queue() does not serialize concurrent callers and
> does not wait for a running topology change event (it skips waiting when
> ioc->current_event->event !=3D MPT3SAS_REMOVE_UNRESPONDING_DEVICES and
> clears ioc->fw_events_cleanup =3D 0 as soon as the loop finishes).  If a
> reset cleanup overlaps with teardown in scsih_remove() or scsih_shutdown(=
):
>=20
> CPU0 (reset cleanup)              CPU1 (scsih_shutdown / scsih_remove)
> _scsih_fw_event_cleanup_queue()
>   fw_event =3D dequeue_next_fw_event()
>                                   _scsih_fw_event_cleanup_queue()
>                                     /* list_empty && !current_event */
>                                     return;
>                                   wq =3D ioc->firmware_event_thread;
>                                   ioc->firmware_event_thread =3D NULL;
>                                   destroy_workqueue(wq);
>                                   /* delayed_work timer fires on wq */
>                                     __queue_work()  <-- use-after-free
>   cancel_delayed_work_sync()
>=20

True, but this is a preexisting bug and the race window is narrow. It's
fixable, but I don't think it's worthwhile here.

> In addition, when a host reset cleanup runs while a topology change event
> is executing, _scsih_fw_event_cleanup_queue() sets
> ioc->current_event->ignore =3D 1, clears ioc->current_event =3D NULL, and
> resets ioc->fw_events_cleanup =3D 0 without cancelling or disabling
> fw_event->delayed_work.  If _scsih_add_device() or _scsih_pcie_add_device=
()
> fails on the final entry of the event (or an earlier entry already set
> requeue_event =3D 1), _scsih_sas_topology_change_event() exits its loop a=
nd
> returns requeue_event =3D 1 without re-checking fw_event->ignore.  When
> _mpt3sas_fw_work() then calls _scsih_fw_event_requeue(),
> ioc->fw_events_cleanup is already 0 and ioc->remove_host is 0, and
> _scsih_fw_event_requeue() checks neither fw_event->ignore nor
> ioc->shost_recovery, so the stale pre-reset event still requeues itself.

Also true, but the effect is harmless because fw_event->ignore is
sticky: nothing in the driver ever clears it. So when the requeued
event runs 1s later,  _scsih_sas_topology_change_event() and
_scsih_pcie_topology_change_event() return 0 early and no device is
touched.

--=20
Jeff Layton <jlayton@kernel.org>
