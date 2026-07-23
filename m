Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3372494F0
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766902; cv=none; b=JFqy24JotvVQO509hb4FfZqH8rNZ3ryND9XjivLnLhQZck2Qfb9nq08h6dGgJqM6UOBDGbVFm9S859R/Wnx8oW/9TP3LP0EITJ8817uCA8ydJ/0XhpHrqQvtNIe2gZVAOLjqpdnlwaiIMgCTLsq1iX4/QQUSR1SWtL8gntAnAjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766902; c=relaxed/simple;
	bh=W6mOxCamqkoYcACrUcFJfXdTOG2TqNjiJ67n4YtBiew=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DzTriBllsWTJxjDnTIB/u6STQsqhmVYlu7t7D/EONDtBylH6MXM3PxINP49yA7M4AFRD0RfBgJjtXvgFdTkEC1BNednq+Up3FNf/df750DMTy/A53NB2SGxlIzBbz7m5YQfy0W4eAUsFwbRgytLSkxPBCD//Rr0ZfIcjGuHlueQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncFIbBEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncFIbBEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32951F000E9;
	Thu, 23 Jul 2026 00:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766901;
	bh=T3uw7lnMuG0wQNwvbcfGlvqdR++LCRZHXfVz4vzdT8o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ncFIbBEBOOeuzeXj9ZvCryqJkVvmXC3CXALNLsWKEs+i5umUssdS3GLdaqqCgCxvw
	 /1N+HYGw2Hwg3j0+26K16RLjkSTJ/RDNeJ4rT/ZvI890lhNXral3ohqYqqWzs+nY1Q
	 DQB0zh9ZO/HwLldtee2W0aiW9Vo+x3WhAiWTHhZsHVmfMBqJN2Bu2fg4lPQumjFevz
	 OFgR/UfgiXi2zXwFCym6hVh1Pr0gZeL5zbXte6Ye60qYNQSzuGsShfAT2HbkGAbjQB
	 DolLQCGZH2WFh8d+ryf/b9fXsbNpsVAIaPfhuCqDD76Vum1fUX/DJEgzvwsZ8tke2h
	 tenV6RGSKzKUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/33] ibmvfc: flush rport_add_work_q during driver
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-3-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:35:00 +0000
Message-Id: <20260723003500.D32951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] The patch incorrectly assumes all events with `!evt->cmnd` are MAD=
 events, assigning an uninitialized `evt->_done` pointer to `evt->done` for=
 TMF events, causing a kernel panic or deadlock.

Pre-existing issues:
- [High] The error path in `ibmvfc_probe()` lacks a `cancel_work_sync()` or=
 `flush_work()` for `vhost->rport_add_work_q`, leading to a workqueue leak =
and a use-after-free.
- [High] Target objects allocated from `vhost->tgt_pool` are improperly fre=
ed using `kfree()` instead of `mempool_free()`, permanently depleting the m=
empool's reserves.
- [High] In `ibmvfc_cancel_all_mq()`, the return value of `ibmvfc_send_even=
t()` is ignored. If sending fails with `H_CLOSED`, the event is freed inter=
nally but the caller adds it to a wait list, causing a use-after-free and a=
n indefinite hang.
--

--- Patch [2]: [PATCH v2 02/33] ibmvfc: flush rport_add_work_q during drive=
r teardown ---
commit 17edf5c871930177f3e5dcc29059e768abdcd3dd
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

    ibmvfc: flush rport_add_work_q during driver teardown
   =20
    INIT_WORK is called on rport_add_work_q during driver probe. When the
    adapter is removed, ibmvfc_remove() stops the work thread and proceeds
    to tear down the FC host, but any work item queued via schedule_work()
    that raced the teardown could still be running or pending in the
    system workqueue.
   =20
    Add a flush_work() call after kthread_stop() and before fc_remove_host()
    to drain any outstanding rport add work before the FC host and its rpor=
ts
    are torn down.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 0a5f73df8d7d2..72317d7840a53 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -6443,6 +6443,7 @@ static void ibmvfc_remove(struct vio_dev *vdev)
> =20
>  	ibmvfc_wait_while_resetting(vhost);
>  	kthread_stop(vhost->work_thread);
> +	flush_work(&vhost->rport_add_work_q);
>  	fc_remove_host(vhost->host);
>  	scsi_remove_host(vhost->host);

[Severity: High]
This isn't a bug introduced by this patch, but does ibmvfc_probe() also nee=
d=20
a similar flush_work() or cancel_work_sync() in its error path?

If ibmvfc_probe() fails after starting the kthread and initializing the CRQ=
=20
(for example, if scsi_add_host() fails), it stops the kthread and frees the
host memory:

kill_kthread:
	kthread_stop(vhost->work_thread);
free_host_mem:
	ibmvfc_free_mem(vhost);
free_scsi_host:
	scsi_host_put(shost);

If the CRQ initialization has already received an interrupt, transitioned t=
he
host state, and scheduled rport_add_work_q on the system workqueue, wouldn't
ibmvfc_rport_add_thread() execute after the vhost structure has been freed,
causing a use-after-free?

[ ... ]

> @@ -1367,8 +1367,8 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc=
_rport *rport, u32 timeout)
>  static void ibmvfc_release_tgt(struct kref *kref)
>  {
>  	struct ibmvfc_target *tgt =3D container_of(kref, struct ibmvfc_target, =
kref);
>  	kfree(tgt);
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does ibmvfc_release_tgt()
permanently deplete the tgt_pool mempool reserves?

Target structures are allocated from a mempool in ibmvfc_alloc_target():

	tgt =3D mempool_alloc(vhost->tgt_pool, GFP_NOIO);

However, ibmvfc_release_tgt() frees them directly using kfree(). While the
memory is returned to the slab allocator, bypassing mempool_free() means the
mempool's internal reserve count is never replenished.

Could this permanently deplete the mempool's preallocated reserves and lead
to allocation failures or device discovery hangs under memory pressure?

[ ... ]

> @@ -1591,8 +1591,8 @@ static void ibmvfc_init_event(struct ibmvfc_event *=
evt,
>  {
>  	evt->cmnd =3D NULL;
>  	evt->sync_iu =3D NULL;
>  	evt->eh_comp =3D NULL;
>  	evt->crq.format =3D format;
>  	if (format =3D=3D IBMVFC_CMD_FORMAT)
>  		evt->done =3D done;
>  	else {
>  		evt->_done =3D done;

[ ... ]

> @@ -1774,9 +1774,9 @@ static int ibmvfc_send_event(struct ibmvfc_event *e=
vt,
>  		if (evt->cmnd) {
>  			evt->cmnd->result =3D DID_ERROR << 16;
>  			evt->done =3D ibmvfc_scsi_eh_done;
>  		} else {
>  			evt->xfer_iu->mad_common.status =3D cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
>  			evt->done =3D evt->_done;
>  		}
> =20
>  		evt->done(evt);

[Severity: High]
Does this else branch in ibmvfc_send_event() correctly handle Task
Management Function (TMF) events?

TMF events use the IBMVFC_CMD_FORMAT format and have evt->cmnd =3D NULL.
When ibmvfc_init_event() initializes a CMD format event, it explicitly leav=
es
evt->_done uninitialized.

If ibmvfc_send_event() encounters an error sending a TMF event, it evaluates
!evt->cmnd, enters the else branch, and assigns evt->done =3D evt->_done.

Could this execute an uninitialized or stale callback?

[ ... ]

> @@ -2630,8 +2630,8 @@ static int ibmvfc_cancel_all_mq(struct scsi_device =
*sdev, int type)
>  			}
>  			evt->sync_iu =3D &queues[i].cancel_rsp;
>  			ibmvfc_send_event(evt, vhost, default_timeout);
>  			list_add_tail(&evt->cancel, &cancelq);
>  		}
> =20
>  		spin_unlock(queues[i].q_lock);
>  	}
>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> =20
>  	if (list_empty(&cancelq)) {
>  		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
>  			sdev_printk(KERN_INFO, sdev, "No events found to cancel\n");
>  		return 0;
>  	}
> =20
>  	sdev_printk(KERN_INFO, sdev, "Cancelling outstanding commands.\n");
> =20
>  	list_for_each_entry_safe(evt, temp, &cancelq, cancel) {
>  		wait_for_completion(&evt->comp);

[Severity: High]
This isn't a bug introduced by this patch, but does ibmvfc_cancel_all_mq()=
=20
hang indefinitely if ibmvfc_send_event() fails with H_CLOSED?

If ibmvfc_send_event() returns H_CLOSED, it returns SCSI_MLQUEUE_HOST_BUSY=
=20
and frees the event via ibmvfc_free_event().

However, ibmvfc_cancel_all_mq() ignores the return value of=20
ibmvfc_send_event(). It unconditionally proceeds to call=20
list_add_tail(&evt->cancel, &cancelq) on the now-freed event and=20
subsequently loops over the cancelq list calling=20
wait_for_completion(&evt->comp).=20

Could this cause a use-after-free and an indefinite hang since the completi=
on
object resides in freed memory and will never be signaled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D2
