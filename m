From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 56/72] ncr5380: Remove redundant volatile qualifiers
Date: Sun, 06 Dec 2015 12:32:22 +1100
Message-ID: <20151206013140.855498906@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
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
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-06 12:30:52.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-12-06 12:30:57.000000000 +1100
@@ -248,14 +248,14 @@ struct NCR5380_hostdata {
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
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:56.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:57.000000000 +1100
@@ -1004,7 +1004,7 @@ static void NCR5380_dma_complete(struct
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int transferred;
 	unsigned char **data;
-	volatile int *count;
+	int *count;
 	int saved_data = 0, overrun = 0;
 	unsigned char p;
 
