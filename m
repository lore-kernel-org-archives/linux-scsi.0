From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3 v2] libsas: fix sas_queuecommand return values
Date: Sat, 16 Jul 2011 15:00:35 -0400
Message-ID: <20110716190035.GA9500@infradead.org>
References: <20110711184922.859239377@bombadil.infradead.org>
 <20110711185045.547083012@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33011
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794Ab1GPTAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2011 15:00:39 -0400
Content-Disposition: inline
In-Reply-To: <20110711185045.547083012@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

->queuecommand must return either 0, or one of the SCSI_MLQUEUE_* return
values.  Non-transient errors are indicated by setting cmd->result before
calling ->scsi_done and returning 0.  Fix libsas to adhere to this calling
convention.  Note that the DID_ERROR for returns from the low-level driver
might not be correct for all cases, but it's the best we can do with
the current layering in libsas.  I also suspect that the pre-existing
handling of -SAS_QUEUE_FULL should really be SCSI_MLQUEUE_HOST_BUSY, but
I'll leave that for a separate change.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2011-07-16 11:24:36.852182194 -0700
+++ linux-2.6/drivers/scsi/libsas/sas_scsi_host.c	2011-07-16 11:24:50.022110847 -0700
@@ -207,7 +207,7 @@ int sas_queuecommand(struct Scsi_Host *h
 
 	task = sas_create_task(cmd, dev, GFP_ATOMIC);
 	if (!task)
-		return -ENOMEM;
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	/* Queue up, Direct Mode or Task Collector Mode. */
 	if (sas_ha->lldd_max_execute_num < 2)
@@ -223,9 +223,10 @@ out_free_task:
 	SAS_DPRINTK("lldd_execute_task returned: %d\n", res);
 	ASSIGN_SAS_TASK(cmd, NULL);
 	sas_free_task(task);
-	if (res != -SAS_QUEUE_FULL)
-		return res;
-	cmd->result = DID_SOFT_ERROR << 16; /* retry */
+	if (res == -SAS_QUEUE_FULL)
+		cmd->result = DID_SOFT_ERROR << 16; /* retry */
+	else
+		cmd->result = DID_ERROR << 16;
 out_done:
 	cmd->scsi_done(cmd);
 	return 0;
