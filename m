From: Hannes Reinecke <hare@suse.de>
Subject: DID_IMM_RETRY considered harmful
Date: Mon, 06 Feb 2012 09:07:31 +0100
Message-ID: <4F2F8A43.70104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab2BFIHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2012 03:07:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <jbottomley@parallels.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>

Hi all,

I've run into a spot of bother during stress-testing the recent 3.x
seriesl kernel. The consistent signature is req->special =3D=3D NULL
in scsi_done_softirq(). Apparently this is caused by retrying that
command due to DID_IMM_RETRY in scsi_decide_disposition().

I have added a WARN_ON statement in block/blk-softirq.c:
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c216..89a68a3 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -156,6 +156,7 @@ void blk_complete_request(struct request *req)
 {
        if (unlikely(blk_should_fake_timeout(req->q)))
                return;
+       WARN_ON(!(req->cmd_flags & REQ_STARTED));
        if (!blk_mark_rq_complete(req))
                __blk_complete_request(req);
 }

which caused this nice stack trace:
[<000003c001336cba>] zfcp_scsi_queuecommand+0xbe/0x1d0 [zfcp])
[<000003c0046ed07a>] scsi_dispatch_cmd+0x15e/0x34c [scsi_mod]
[<000003c0046f5920>] scsi_request_fn+0x4b8/0x5bc [scsi_mod]
[<0000000000353fb0>] queue_unplugged+0x9c/0xe0
[<0000000000354282>] blk_flush_plug_list+0x28e/0x2f4
[<00000000004de5f8>] io_schedule+0x94/0x100
[<00000000001fabd6>] sleep_on_page_killable+0x22/0x68
[<00000000001face4>] __lock_page_killable+0xc8/0x114
[<00000000001fc530>] do_generic_file_read+0x3f0/0x54c
[<00000000001fd436>] generic_file_aio_read+0x1a2/0x2ec
[<000000000025c87c>] do_sync_read+0xc8/0x12c
[<000000000025d7f4>] vfs_read+0xac/0x184
[<000000000025d9c8>] SyS_read+0x58/0xb4
[<00000000004e1170>] sysc_noemu+0x16/0x1c
[<000003fffd3f0054>] 0x3fffd3f0054

However, seeing all the nice safeguards around in scsi_request_fn():

		spin_unlock(q->queue_lock);
		cmd =3D req->special;
		if (unlikely(cmd =3D=3D NULL)) {

this _cannot_ have happened within this thread.
Hence some other thread must have modified this particular request.

Looking closer at the requeuing code, it just adds the request to
the _head_ of the request queue and kicks off a worker thread:

	spin_lock_irqsave(q->queue_lock, flags);
	blk_requeue_request(q, cmd->request);
	spin_unlock_irqrestore(q->queue_lock, flags);

	if (reason =3D=3D SCSI_MLQUEUE_DELAYED_RETRY)
		blk_delay_queue(q, 2000);
	else
		kblockd_schedule_work(q, &device->requeue_work);

However, as this might have been called asynchronously via
scsi_done(), the original thread might still be running at this
point, and, as request_fn() hasn't signalled an error, continue
trying to pull requests off the request queue.

So now we have _two_ instances trying to pull requests.
And, as the hardware is blocked at this point, _both_ will be having
to requeue commands. But as the requeueing code puts the request at
the _head_ of the queue, both will be working _on the same request_.
Which of course will lead to all sorts of race issues.

So, question for the experts here:

What are the safeguards that blk_run_queue() might not be called on
a queue where ->request_fn is already active?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Immend=F6rfer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
