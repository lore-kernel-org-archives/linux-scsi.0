From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] Don't crash on IOMMU overflow in A100U2W driver
Date: Tue, 15 Jul 2008 10:15:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807151014180.24544@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0807151011350.24544@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0807151012200.24544@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbYGOOPg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 10:15:36 -0400
In-Reply-To: <Pine.LNX.4.64.0807151012200.24544@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Handle IOMMU overflow correctly, by retrying.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
  drivers/scsi/a100u2w.c |   11 ++++++++---
  1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.26-fast/drivers/scsi/a100u2w.c
===================================================================
--- linux-2.6.26-fast.orig/drivers/scsi/a100u2w.c	2008-07-15 15:49:39.000000000 +0200
+++ linux-2.6.26-fast/drivers/scsi/a100u2w.c	2008-07-15 16:04:50.000000000 +0200
@@ -840,7 +840,7 @@ static irqreturn_t orc_interrupt(struct
   *	Build a host adapter control block from the SCSI mid layer command
   */

-static void inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struct scsi_cmnd * cmd)
+static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struct scsi_cmnd * cmd)
  {				/* Create corresponding SCB     */
  	struct scatterlist *sg;
  	struct orc_sgent *sgent;		/* Pointer to SG list           */
@@ -865,7 +865,8 @@ static void inia100_build_scb(struct orc
  	sgent = (struct orc_sgent *) & escb->sglist[0];

  	count_sg = scsi_dma_map(cmd);
-	BUG_ON(count_sg < 0);
+	if (count_sg < 0)
+		return count_sg;
  	BUG_ON(count_sg > TOTAL_SG_ENTRY);

  	/* Build the scatter gather lists */
@@ -898,6 +899,7 @@ static void inia100_build_scb(struct orc
  		scb->tag_msg = 0;	/* No tag support               */
  	}
  	memcpy(scb->cdb, cmd->cmnd, scb->cdb_len);
+	return 0;
  }

  /**
@@ -921,7 +923,10 @@ static int inia100_queue(struct scsi_cmn
  	if ((scb = orc_alloc_scb(host)) == NULL)
  		return SCSI_MLQUEUE_HOST_BUSY;

-	inia100_build_scb(host, scb, cmd);
+	if (inia100_build_scb(host, scb, cmd)) {
+		orc_release_scb(host, scb);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
  	orc_exec_scb(host, scb);	/* Start execute SCB            */
  	return 0;
  }
