From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm-multipath test scripts
Date: Mon, 22 Feb 2016 09:51:28 +0000
Message-ID: <56CADA20.7050209@ce.jp.nec.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com> <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com> <20160219194216.GB21133@redhat.com>
 <20160220061247.GA23333@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:55879 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbcBVJxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 04:53:20 -0500
In-Reply-To: <20160220061247.GA23333@redhat.com>
Content-Language: ja-JP
Content-ID: <E6053B34216AF94181D53C47BCA874BE@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 02/20/16 15:12, Mike Snitzer wrote:
> On Fri, Feb 19 2016 at  2:42pm -0500, Mike Snitzer <snitzer@redhat.com> wrote:
>> Have you been running with blk-mq?
>> Either by setting CONFIG_DM_MQ_DEFAULT or:
>> echo Y > /sys/module/dm_mod/parameters/use_blk_mq
>>
>> I'm seeing test_02_sdev_delete fail with blk-mq enabled.
> 
> I only see failure if I stack dm-mq ontop of old non-mq scsi devices with:
> 
> echo N > /sys/module/scsi_mod/parameters/use_blk_mq
> echo Y > /sys/module/dm_mod/parameters/use_blk_mq

Ah, I didn't test that combination. I can see the failure, too.

> But this makes me think the novelty of having dm-mq support stacking on
> non-blk-mq devices was misplaced.  It is a senseless config.  I'll
> probably remove support for such stacking soon (next week). 

Looking at the failure, I suspect it could be a common issue of dm-mq
regardless of underlying device type.

When requeueing, following calls happen in dm-mq:
  dm_requeue_original_request() {
    ..
    blk_mq_requeue_request(rq);
    blk_mq_kick_requeue_list(rq->q);

then from block workqueue:
  blk_mq_requeue_work() {
    ..
    blk_mq_start_hw_queue(q);

and blk_mq_start_hw_queue() re-starts the queue even if DM has
stopped it for suspending. As a result, dm-mq ends up repeating
submit-error-requeue forever and suspend never completes. Or,
suspend somehow proceeds to clear DMF_NOFLUSH_SUSPENDING and
I/O error may directly be returned to submitter.

Attached patch fixes the problem for DM. But given the code comment,
there should be call sites which depend on 'start-if-stopped' behavior
of blk_mq_requeue_work and we may need other solution.

-- 
Jun'ichi Nomura, NEC Corporation

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 56c0a72..bbfe936 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -481,11 +481,7 @@ static void blk_mq_requeue_work(struct work_struct *work)
 		blk_mq_insert_request(rq, false, false, false);
 	}
 
-	/*
-	 * Use the start variant of queue running here, so that running
-	 * the requeue work will kick stopped queues.
-	 */
-	blk_mq_start_hw_queues(q);
+	blk_mq_run_hw_queues(q, false);
 }
 
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)