From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_cmnd.eh_state
Date: Sun, 19 Jun 2005 13:39:23 +0200
Message-ID: <20050619113923.GB18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:8108 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262244AbVFSLj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 07:39:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

it's never set to anything, and just three broken drivers are looking
at it and doing odd things.


Index: linux-2.6/drivers/scsi/dpt_i2o.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dpt_i2o.c	2005-06-19 00:16:48.000000000 +0200
+++ linux-2.6/drivers/scsi/dpt_i2o.c	2005-06-19 11:47:20.000000000 +0200
@@ -419,11 +419,6 @@
 		return 1;
 	}
 
-	if(cmd->eh_state != SCSI_STATE_QUEUED){
-		// If we are not doing error recovery
-		mod_timer(&cmd->eh_timeout, timeout);
-	}
-
 	// TODO if the cmd->device if offline then I may need to issue a bus rescan
 	// followed by a get_lct to see if the device is there anymore
 	if((pDev = (struct adpt_device*) (cmd->device->hostdata)) == NULL) {
Index: linux-2.6/drivers/scsi/eata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata.c	2005-06-19 00:16:48.000000000 +0200
+++ linux-2.6/drivers/scsi/eata.c	2005-06-19 11:46:55.000000000 +0200
@@ -1899,16 +1899,6 @@
 			printk("%s: abort, mbox %d, interrupt pending.\n",
 			       ha->board_name, i);
 
-		if (SCarg->eh_state == SCSI_STATE_TIMEOUT) {
-			unmap_dma(i, ha);
-			SCarg->host_scribble = NULL;
-			ha->cp_stat[i] = FREE;
-			printk
-			    ("%s, abort, mbox %d, eh_state timeout, pid %ld.\n",
-			     ha->board_name, i, SCarg->pid);
-			return SUCCESS;
-		}
-
 		return FAILED;
 	}
 
Index: linux-2.6/drivers/scsi/u14-34f.c
===================================================================
--- linux-2.6.orig/drivers/scsi/u14-34f.c	2005-06-19 00:16:48.000000000 +0200
+++ linux-2.6/drivers/scsi/u14-34f.c	2005-06-19 11:47:01.000000000 +0200
@@ -1372,15 +1372,6 @@
       if (inb(sh[j]->io_port + REG_SYS_INTR) & IRQ_ASSERTED)
          printk("%s: abort, mbox %d, interrupt pending.\n", BN(j), i);
 
-      if (SCarg->eh_state == SCSI_STATE_TIMEOUT) {
-         unmap_dma(i, j);
-         SCarg->host_scribble = NULL;
-         HD(j)->cp_stat[i] = FREE;
-         printk("%s, abort, mbox %d, eh_state timeout, pid %ld.\n",
-                BN(j), i, SCarg->pid);
-         return SUCCESS;
-         }
-
       return FAILED;
       }
 
Index: linux-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_cmnd.h	2005-04-30 10:17:20.000000000 +0200
+++ linux-2.6/include/scsi/scsi_cmnd.h	2005-06-19 12:00:47.000000000 +0200
@@ -38,7 +38,6 @@
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
-	int eh_state;		/* Used for state tracking in error handlr */
 	int eh_eflags;		/* Used by error handlr */
 	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
 
