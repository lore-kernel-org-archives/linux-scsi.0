From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 06/12] scsi/ncr5380: Improve hostdata struct member alignment
 and cache-ability
Date: Tue,  4 Oct 2016 01:40:50 -0400 (EDT)
Message-ID: <4c0e9a772102531e1dcb7975cd99ed36b537cd9c.1475559357.git.fthain@telegraphics.com.au>
References: <cover.1475559357.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1475559357.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Re-order struct members so that hot data lies at the beginning of the
struct and cold data at the end. Improve the comments while we're here.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 13d7aff..8212efb6 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -219,27 +219,27 @@
 #define FLAG_TOSHIBA_DELAY		128	/* Allow for borken CD-ROMs */
 
 struct NCR5380_hostdata {
-	NCR5380_implementation_fields;		/* implementation specific */
-	struct Scsi_Host *host;			/* Host backpointer */
-	unsigned char id_mask, id_higher_mask;	/* 1 << id, all bits greater */
-	unsigned char busy[8];			/* index = target, bit = lun */
-	int dma_len;				/* requested length of DMA */
-	unsigned char last_message;		/* last message OUT */
-	struct scsi_cmnd *connected;		/* currently connected cmnd */
-	struct scsi_cmnd *selecting;		/* cmnd to be connected */
-	struct list_head unissued;		/* waiting to be issued */
-	struct list_head autosense;		/* priority issue queue */
-	struct list_head disconnected;		/* waiting for reconnect */
-	spinlock_t lock;			/* protects this struct */
-	int flags;
-	struct scsi_eh_save ses;
-	struct scsi_cmnd *sensing;
+	NCR5380_implementation_fields;		/* Board-specific data */
+	unsigned long poll_loops;		/* Register polling limit */
+	spinlock_t lock;			/* Protects this struct */
+	struct scsi_cmnd *connected;		/* Currently connected cmnd */
+	struct list_head disconnected;		/* Waiting for reconnect */
+	struct Scsi_Host *host;			/* SCSI host backpointer */
+	struct workqueue_struct *work_q;	/* SCSI host work queue */
+	struct work_struct main_task;		/* Work item for main loop */
+	int flags;				/* Board-specific quirks */
+	int dma_len;				/* Requested length of DMA */
+	int read_overruns;	/* Transfer size reduction for DMA erratum */
+	struct list_head unissued;		/* Waiting to be issued */
+	struct scsi_cmnd *selecting;		/* Cmnd to be connected */
+	struct list_head autosense;		/* Priority cmnd queue */
+	struct scsi_cmnd *sensing;		/* Cmnd needing autosense */
+	struct scsi_eh_save ses;		/* Cmnd state saved for EH */
+	unsigned char busy[8];			/* Index = target, bit = lun */
+	unsigned char id_mask;			/* 1 << Host ID */
+	unsigned char id_higher_mask;		/* All bits above id_mask */
+	unsigned char last_message;		/* Last Message Out */
 	char info[256];
-	int read_overruns;                /* number of bytes to cut from a
-	                                   * transfer to handle chip overruns */
-	struct work_struct main_task;
-	struct workqueue_struct *work_q;
-	unsigned long poll_loops;		/* register polling limit */
 };
 
 #ifdef __KERNEL__
-- 
2.7.3
