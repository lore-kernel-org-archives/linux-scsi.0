From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] workqueue: defer work to a draining queue
Date: Fri, 2 Dec 2011 17:53:40 -0800
Message-ID: <CABE8wwvLysxv=dGxsP2zKAvWFaZwHdZDf9PwXpdYHZQNDTvJpg@mail.gmail.com>
References: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
	<20111202235655.24470.24712.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:51373 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901Ab1LCBxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 20:53:42 -0500
In-Reply-To: <20111202235655.24470.24712.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Dec 2, 2011 at 3:56 PM, Dan Williams <dan.j.williams@intel.com>=
 wrote:
[..]
> @@ -2405,7 +2434,7 @@ void drain_workqueue(struct workqueue_struct *w=
q)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0spin_lock_irq(&workqueue_lock);
> =A0 =A0 =A0 =A0if (!wq->nr_drainers++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wq->flags |=3D WQ_DRAINING;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wq->flags |=3D WQ_DRAINING | flags;
> =A0 =A0 =A0 =A0spin_unlock_irq(&workqueue_lock);
> =A0reflush:
> =A0 =A0 =A0 =A0flush_workqueue(wq);
> @@ -2429,9 +2458,25 @@ reflush:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0spin_lock_irq(&workqueue_lock);
> - =A0 =A0 =A0 if (!--wq->nr_drainers)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wq->flags &=3D ~WQ_DRAINING;
> + =A0 =A0 =A0 if (!--wq->nr_drainers) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wq->flags &=3D ~(WQ_DRAINING | WQ_NO_DE=
=46ER);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_splice_init(&wq->drain_defer, &dra=
in_defer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D !list_empty(&drain_defer);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0spin_unlock_irq(&workqueue_lock);
> +
> + =A0 =A0 =A0 /* requeue work on this queue provided it was not being=
 destroyed */
> + =A0 =A0 =A0 list_for_each_entry_safe(work, w, &drain_defer, entry) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&work->entry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_work(wq, work);
> + =A0 =A0 =A0 }

Actually, this won't work.  The queuing of deferred work would need to
be under the lock and then flushed again to guarantee workqueue
semantics which just devolves into a "wait until all work stops being
submitted to the queue for one drain_workqueue() duration".  Which is
more than what we need for libsas.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
