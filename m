From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] remove scsi_cmnd.eh_state
Date: Mon, 20 Jun 2005 08:26:24 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520CD6@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:205 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261226AbVFTM1K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 08:27:10 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

A bugfix was submitted a couple of weeks ago for the code affected by
Christoph's patch. I suggest the following modification to merge the two
patches:

--- linux-2.6.orig/drivers/scsi/dpt_i2o.c	2005-06-19
00:16:48.000000000 +0200
+++ linux-2.6/drivers/scsi/dpt_i2o.c	2005-06-19 11:47:20.000000000
+0200
@@ -419,7 +419,7 @@
 		return 1;
 	}
 
-	if(cmd->eh_state != SCSI_STATE_QUEUED){
+	if(cmd->device->type == TYPE_DISK){
 		// If we are not doing error recovery
 		mod_timer(&cmd->eh_timeout, timeout);
 	}

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Sunday, June 19, 2005 7:39 AM
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] remove scsi_cmnd.eh_state

it's never set to anything, and just three broken drivers are looking
at it and doing odd things.


Index: linux-2.6/drivers/scsi/dpt_i2o.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dpt_i2o.c	2005-06-19
00:16:48.000000000 +0200
+++ linux-2.6/drivers/scsi/dpt_i2o.c	2005-06-19 11:47:20.000000000
+0200
@@ -419,11 +419,6 @@
 		return 1;
 	}
 
-	if(cmd->eh_state != SCSI_STATE_QUEUED){
-		// If we are not doing error recovery
-		mod_timer(&cmd->eh_timeout, timeout);
-	}
-
 	// TODO if the cmd->device if offline then I may need to issue a
bus rescan
 	// followed by a get_lct to see if the device is there anymore
 	if((pDev = (struct adpt_device*) (cmd->device->hostdata)) ==
NULL) {
Index: linux-2.6/drivers/scsi/eata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata.c	2005-06-19 00:16:48.000000000
+0200
+++ linux-2.6/drivers/scsi/eata.c	2005-06-19 11:46:55.000000000
+0200
@@ -1899,16 +1899,6 @@
 			printk("%s: abort, mbox %d, interrupt
pending.\n",
 			       ha->board_name, i);
 
-		if (SCarg->eh_state == SCSI_STATE_TIMEOUT) {
-			unmap_dma(i, ha);
-			SCarg->host_scribble = NULL;
-			ha->cp_stat[i] = FREE;
-			printk
-			    ("%s, abort, mbox %d, eh_state timeout, pid
%ld.\n",
-			     ha->board_name, i, SCarg->pid);
-			return SUCCESS;
-		}
-
 		return FAILED;
 	}
 
Index: linux-2.6/drivers/scsi/u14-34f.c
===================================================================
--- linux-2.6.orig/drivers/scsi/u14-34f.c	2005-06-19
00:16:48.000000000 +0200
+++ linux-2.6/drivers/scsi/u14-34f.c	2005-06-19 11:47:01.000000000
+0200
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
--- linux-2.6.orig/include/scsi/scsi_cmnd.h	2005-04-30
10:17:20.000000000 +0200
+++ linux-2.6/include/scsi/scsi_cmnd.h	2005-06-19 12:00:47.000000000
+0200
@@ -38,7 +38,6 @@
 	struct list_head list;  /* scsi_cmnd participates in queue lists
*/
 
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
-	int eh_state;		/* Used for state tracking in error
handlr */
 	int eh_eflags;		/* Used by error handlr */
 	void (*done) (struct scsi_cmnd *);	/* Mid-level done
function */
 
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
