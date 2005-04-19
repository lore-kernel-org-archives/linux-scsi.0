From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 04/05] scsi: make scsi_requeue_request() use blk_requeue_request()
Date: Wed, 20 Apr 2005 08:15:59 +0900 (KST)
Message-ID: <20050419231435.177BB9D6@htj.dyndns.org>
References: <20050419231435.D85F89C0@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.196]:30568 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261751AbVDSXQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 19:16:03 -0400
Received: by rproxy.gmail.com with SMTP id j1so27094rnf
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 16:16:03 -0700 (PDT)
In-Reply-To: <20050419231435.D85F89C0@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

04_scsi_REQ_SPECIAL_semantic_scsi_requeue_command.patch

	scsi_requeue_request() used to use blk_insert_request() for
	requeueing requests.  This depends on the unobvious behavior
	of blk_insert_request() setting REQ_SPECIAL and
	REQ_SOFTBARRIER when requeueing.  This patch makes
	scsi_queue_insert() use blk_requeue_request().  As REQ_SPECIAL
	means special requests and REQ_SOFTBARRIER is automatically
	handled by blk layer now, no flag needs to be set.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-04-20 08:13:34.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-04-20 08:13:35.000000000 +0900
@@ -480,8 +480,13 @@ static void scsi_run_queue(struct reques
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
+	unsigned long flags;
+
 	cmd->request->flags &= ~REQ_DONTPREP;
-	blk_insert_request(q, cmd->request, 1, cmd, 1);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_requeue_request(q, cmd->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
 }

