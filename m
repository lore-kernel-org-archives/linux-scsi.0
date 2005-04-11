From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/04] scsi: make scsi_requeue_request() use blk_requeue_request()
Date: Mon, 11 Apr 2005 12:45:52 +0900 (KST)
Message-ID: <20050411034451.6204E57B@htj.dyndns.org>
References: <20050411034451.B75F3870@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.204]:35951 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261692AbVDKDqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 23:46:05 -0400
Received: by wproxy.gmail.com with SMTP id 68so1434414wri
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2005 20:45:58 -0700 (PDT)
In-Reply-To: <20050411034451.B75F3870@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

03_scsi_REQ_SPECIAL_semantic_scsi_requeue_command.patch

	scsi_requeue_request() used to use blk_insert_request() for
	requeueing requests.  This behavior depends on the unobvious
	behavior of blk_insert_request() setting REQ_SPECIAL and
	REQ_SOFTBARRIER when requeueing.  This patch makes
	scsi_requeue_request() use blk_requeue_request() and
	explicitly set REQ_SOFTBARRIER.  As REQ_SPECIAL now means
	special requests, the flag is not set on requeue.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-04-11 12:27:07.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-04-11 12:27:08.000000000 +0900
@@ -483,8 +483,14 @@ static void scsi_run_queue(struct reques
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
+	unsigned long flags;
+
 	cmd->request->flags &= ~REQ_DONTPREP;
-	blk_insert_request(q, cmd->request, 1, cmd, 1);
+	cmd->request->flags |= REQ_SOFTBARRIER;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_requeue_request(q, cmd->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
 }

