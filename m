From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/13] scsi: remove unused scsi_cmnd->internal_timeout field
Date: Thu, 31 Mar 2005 18:08:05 +0900 (KST)
Message-ID: <20050331090647.CFA961FE@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.203]:49256 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261226AbVCaJIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 04:08:10 -0500
Received: by rproxy.gmail.com with SMTP id a41so330728rng
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 01:08:10 -0800 (PST)
In-Reply-To: <20050331090647.FEDC3964@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

03_scsi_remove_internal_timeout.patch

	scsi_cmnd->internal_timeout field doesn't have any meaning
	anymore.  Kill the field.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 drivers/scsi/advansys.c   |    2 --
 drivers/scsi/pci2000.c    |    4 ++--
 drivers/scsi/scsi.c       |    1 -
 drivers/scsi/scsi_error.c |    1 -
 drivers/scsi/scsi_lib.c   |    1 -
 drivers/scsi/scsi_priv.h  |    5 -----
 include/scsi/scsi_cmnd.h  |    6 ------
 7 files changed, 2 insertions(+), 18 deletions(-)

Index: scsi-export/drivers/scsi/advansys.c
===================================================================
--- scsi-export.orig/drivers/scsi/advansys.c	2005-03-31 17:42:05.000000000 +0900
+++ scsi-export/drivers/scsi/advansys.c	2005-03-31 18:06:20.000000000 +0900
@@ -9206,8 +9206,6 @@ asc_prt_scsi_cmnd(struct scsi_cmnd *s)
 " timeout_per_command %d, timeout_total %d, timeout %d\n",
         s->timeout_per_command, s->timeout_total, s->timeout);
 
-    printk(" internal_timeout %u\n", s->internal_timeout);
-
     printk(
 " scsi_done 0x%lx, done 0x%lx, host_scribble 0x%lx, result 0x%x\n",
         (ulong) s->scsi_done, (ulong) s->done,
Index: scsi-export/drivers/scsi/pci2000.c
===================================================================
--- scsi-export.orig/drivers/scsi/pci2000.c	2005-03-31 17:42:05.000000000 +0900
+++ scsi-export/drivers/scsi/pci2000.c	2005-03-31 18:06:20.000000000 +0900
@@ -438,8 +438,8 @@ int Pci2000_QueueCommand (Scsi_Cmnd *SCp
 	if ( bus )
 		{
 		DEB (if(*cdb) printk ("\nCDB: %X-  %X %X %X %X %X %X %X %X %X %X ", SCpnt->cmd_len, cdb[0], cdb[1], cdb[2], cdb[3], cdb[4], cdb[5], cdb[6], cdb[7], cdb[8], cdb[9]));
-		DEB (if(*cdb) printk ("\ntimeout_per_command: %d, timeout_total: %d, timeout: %d, internal_timout: %d", SCpnt->timeout_per_command,
-							  SCpnt->timeout_total, SCpnt->timeout, SCpnt->internal_timeout));
+		DEB (if(*cdb) printk ("\ntimeout_per_command: %d, timeout_total: %d, timeout: %d", SCpnt->timeout_per_command,
+							  SCpnt->timeout_total, SCpnt->timeout));
 		outl (SCpnt->timeout_per_command, padapter->mb1);
 		outb_p (CMD_SCSI_TIMEOUT, padapter->cmd);
 		if ( WaitReady (padapter) )
Index: scsi-export/drivers/scsi/scsi.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi.c	2005-03-31 17:42:05.000000000 +0900
+++ scsi-export/drivers/scsi/scsi.c	2005-03-31 18:06:20.000000000 +0900
@@ -716,7 +716,6 @@ void scsi_init_cmd_from_req(struct scsi_
 	/*
 	 * Start the timer ticking.
 	 */
-	cmd->internal_timeout = NORMAL_TIMEOUT;
 	cmd->abort_reason = 0;
 	cmd->result = 0;
 
Index: scsi-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_error.c	2005-03-31 17:42:05.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_error.c	2005-03-31 18:06:20.000000000 +0900
@@ -1843,7 +1843,6 @@ scsi_reset_provider(struct scsi_device *
 	scmd->bufflen			= 0;
 	scmd->request_buffer		= NULL;
 	scmd->request_bufflen		= 0;
-	scmd->internal_timeout		= NORMAL_TIMEOUT;
 	scmd->abort_reason		= DID_ABORT;
 
 	scmd->cmd_len			= 0;
Index: scsi-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_lib.c	2005-03-31 18:06:20.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_lib.c	2005-03-31 18:06:20.000000000 +0900
@@ -414,7 +414,6 @@ static int scsi_init_cmd_errh(struct scs
 	memcpy(cmd->data_cmnd, cmd->cmnd, sizeof(cmd->cmnd));
 	cmd->buffer = cmd->request_buffer;
 	cmd->bufflen = cmd->request_bufflen;
-	cmd->internal_timeout = NORMAL_TIMEOUT;
 	cmd->abort_reason = 0;
 
 	return 1;
Index: scsi-export/drivers/scsi/scsi_priv.h
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_priv.h	2005-03-31 17:42:05.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_priv.h	2005-03-31 18:06:20.000000000 +0900
@@ -30,11 +30,6 @@ struct Scsi_Host;
 #define SCSI_REQ_MAGIC		0x75F6D354
 
 /*
- *  Flag bit for the internal_timeout array
- */
-#define NORMAL_TIMEOUT		0
-
-/*
  * Scsi Error Handler Flags
  */
 #define scsi_eh_eflags_chk(scp, flags) \
Index: scsi-export/include/scsi/scsi_cmnd.h
===================================================================
--- scsi-export.orig/include/scsi/scsi_cmnd.h	2005-03-31 17:42:05.000000000 +0900
+++ scsi-export/include/scsi/scsi_cmnd.h	2005-03-31 18:06:20.000000000 +0900
@@ -65,12 +65,6 @@ struct scsi_cmnd {
 	int timeout_total;
 	int timeout;
 
-	/*
-	 * We handle the timeout differently if it happens when a reset, 
-	 * abort, etc are in process. 
-	 */
-	unsigned volatile char internal_timeout;
-
 	unsigned char cmd_len;
 	unsigned char old_cmd_len;
 	enum dma_data_direction sc_data_direction;

