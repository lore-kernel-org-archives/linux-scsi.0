From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 14/22] ncr5380: Add MAX_LUN limit
Date: Mon, 14 Mar 2016 15:27:14 +1100
Message-ID: <20160314042704.285983735@telegraphics.com.au>
References: <20160314042700.596192247@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-MAX_LUN
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

The driver has a limit of eight LUs because of the byte-sized bitfield
that is used for busy flags. Reject commands with LUN > 7.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |    6 ++++++
 drivers/scsi/NCR5380.h |    2 ++
 2 files changed, 8 insertions(+)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-14 15:26:45.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-14 15:26:48.000000000 +1100
@@ -661,6 +661,12 @@ static int NCR5380_queue_command(struct
 	}
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
+	if (cmd->device->lun > MAX_LUN) {
+		cmd->result = DID_NO_CONNECT << 16;
+		cmd->scsi_done(cmd);
+		return 0;
+	}
+
 	cmd->result = 0;
 
 	if (!NCR5380_acquire_dma_irq(instance))
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-03-14 15:26:45.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-03-14 15:26:48.000000000 +1100
@@ -244,6 +244,8 @@ struct NCR5380_hostdata {
 
 #ifdef __KERNEL__
 
+#define MAX_LUN	7
+
 struct NCR5380_cmd {
 	struct list_head list;
 };
