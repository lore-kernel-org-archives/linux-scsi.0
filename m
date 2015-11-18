From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 56/71] ncr5380: Remove redundant volatile qualifiers
Date: Wed, 18 Nov 2015 19:35:51 +1100
Message-ID: <20151118083514.092779109@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-redundant-volatile-qualifiers
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The hostdata struct is now protected by a spin lock so the volatile
qualifiers are redundant. Remove them.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.h       |   12 ++++++------
 drivers/scsi/atari_NCR5380.c |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-18 19:34:14.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-18 19:34:19.000000000 +1100
@@ -249,14 +249,14 @@ struct NCR5380_hostdata {
 	NCR5380_implementation_fields;		/* implementation specific */
 	struct Scsi_Host *host;			/* Host backpointer */
 	unsigned char id_mask, id_higher_mask;	/* 1 << id, all bits greater */
-	volatile unsigned char busy[8];		/* index = target, bit = lun */
+	unsigned char busy[8];			/* index = target, bit = lun */
 #if defined(REAL_DMA) || defined(REAL_DMA_POLL)
-	volatile int dma_len;			/* requested length of DMA */
+	int dma_len;				/* requested length of DMA */
 #endif
-	volatile unsigned char last_message;	/* last message OUT */
-	volatile struct scsi_cmnd *connected;	/* currently connected command */
-	volatile struct scsi_cmnd *issue_queue;	/* waiting to be issued */
-	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
+	unsigned char last_message;		/* last message OUT */
+	struct scsi_cmnd *connected;		/* currently connected cmnd */
+	struct scsi_cmnd *issue_queue;		/* waiting to be issued */
+	struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
 	spinlock_t lock;			/* protects this struct */
 	int flags;
 	struct scsi_eh_save ses;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:18.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:19.000000000 +1100
@@ -1006,7 +1006,7 @@ static void NCR5380_dma_complete(struct
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int transferred;
 	unsigned char **data;
-	volatile int *count;
+	int *count;
 	int saved_data = 0, overrun = 0;
 	unsigned char p;
 
