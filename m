Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01BBC433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92336208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBJP45LE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgGTCzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 22:55:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37555 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726225AbgGTCzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 22:55:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595213709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y2lZucPvH8YTGFtx2kv9Ey2gk+9GxAGGFi8c5GbSU7A=;
        b=SBJP45LEQ9ntRs8ki8gCIwzHp7Ru1mLAeWLpHg4eWoyt+SroahwmoUFia97RLek2isgoBy
        XLCeh1SAH5Git9s942txej0dENPImdjMHYrQckWU+bPK9NwqMs80C1UbuN7hjeX8QdBCfj
        2RYNsI1otHynZTGP2xlaTgcWMv90n48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-wF3uT3IjPCy-chxQSGzfcg-1; Sun, 19 Jul 2020 22:55:07 -0400
X-MC-Unique: wF3uT3IjPCy-chxQSGzfcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D852410059A9;
        Mon, 20 Jul 2020 02:55:05 +0000 (UTC)
Received: from localhost (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE05B5F9DB;
        Mon, 20 Jul 2020 02:55:01 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH V2] scsi: core: run queue in case of IO queueing failure
Date:   Mon, 20 Jul 2020 10:54:35 +0800
Message-Id: <20200720025435.812030-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IO requests may be held in scheduler queue because of resource contention.
However, not like normal completion, when queueing request failed, we don't
ask block layer to queue these requests, so IO hang[1] is caused.

Fix this issue by run queue when IO request failure happens.

[1] IO hang log by running heavy IO with removing scsi device

[   39.054963] scsi 13:0:0:0: rejecting I/O to dead device
[   39.058700] scsi 13:0:0:0: rejecting I/O to dead device
[   39.087855] sd 13:0:0:1: [sdd] Synchronizing SCSI cache
[   39.088909] scsi 13:0:0:1: rejecting I/O to dead device
[   39.095351] scsi 13:0:0:1: rejecting I/O to dead device
[   39.096962] scsi 13:0:0:1: rejecting I/O to dead device
[  247.021859] INFO: task scsi-stress-rem:813 blocked for more than 122 seconds.
[  247.023258]       Not tainted 5.8.0-rc2 #8
[  247.024069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.025331] scsi-stress-rem D    0   813    802 0x00004000
[  247.025334] Call Trace:
[  247.025354]  __schedule+0x504/0x55f
[  247.027987]  schedule+0x72/0xa8
[  247.027991]  blk_mq_freeze_queue_wait+0x63/0x8c
[  247.027994]  ? do_wait_intr_irq+0x7a/0x7a
[  247.027996]  blk_cleanup_queue+0x4b/0xc9
[  247.028000]  __scsi_remove_device+0xf6/0x14e
[  247.028002]  scsi_remove_device+0x21/0x2b
[  247.029037]  sdev_store_delete+0x58/0x7c
[  247.029041]  kernfs_fop_write+0x10d/0x14f
[  247.031281]  vfs_write+0xa2/0xdf
[  247.032670]  ksys_write+0x6b/0xb3
[  247.032673]  do_syscall_64+0x56/0x82
[  247.034053]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  247.034059] RIP: 0033:0x7f69f39e9008
[  247.036330] Code: Bad RIP value.
[  247.036331] RSP: 002b:00007ffdd8116498 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  247.037613] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f69f39e9008
[  247.039714] RDX: 0000000000000002 RSI: 000055cde92a0ab0 RDI: 0000000000000001
[  247.039715] RBP: 000055cde92a0ab0 R08: 000000000000000a R09: 00007f69f3a79e80
[  247.039716] R10: 000000000000000a R11: 0000000000000246 R12: 00007f69f3abb780
[  247.039717] R13: 0000000000000002 R14: 00007f69f3ab6740 R15: 0000000000000002

Cc: linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- add scsi_run_queue_async() for running queue from async context,
	  otherwise we may risk to overflow stack

 drivers/scsi/scsi_lib.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b9adee0a9266..9798fbffe307 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -564,6 +564,15 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	scsi_uninit_cmd(cmd);
 }
 
+static void scsi_run_queue_async(struct scsi_device *sdev)
+{
+	if (scsi_target(sdev)->single_lun ||
+	    !list_empty(&sdev->host->starved_list))
+		kblockd_schedule_work(&sdev->requeue_work);
+	else
+		blk_mq_run_hw_queues(sdev->request_queue, true);
+}
+
 /* Returns false when no more bytes to process, true if there are more */
 static bool scsi_end_request(struct request *req, blk_status_t error,
 		unsigned int bytes)
@@ -608,11 +617,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 
 	__blk_mq_end_request(req, error);
 
-	if (scsi_target(sdev)->single_lun ||
-	    !list_empty(&sdev->host->starved_list))
-		kblockd_schedule_work(&sdev->requeue_work);
-	else
-		blk_mq_run_hw_queues(q, true);
+	scsi_run_queue_async(sdev);
 
 	percpu_ref_put(&q->q_usage_counter);
 	return false;
@@ -1721,6 +1726,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		 */
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
+		scsi_run_queue_async(sdev);
 		break;
 	}
 	return ret;
-- 
2.25.2

