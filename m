From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] don't set underflow for REQ_BLOCK_PC
Date: Mon, 22 Sep 2003 12:50:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922125009.A3244@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:17326 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262861AbTIVTun
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 15:50:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org
Cc: axboe@suse.de

I got underflow warnings and failures when sending an INQUIRY page 0x83
via the SG_IO REQ_BLOCK_PC interface.

The underflow field should only be set if we know for certain the size of
the data being transfered, so fix this by leaving it at zero for scsi
REQ_BLOCK_PC cases.

diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/sd.c bl-25-sd_underflow-fix/drivers/scsi/sd.c
--- bl-25/drivers/scsi/sd.c	Mon Sep  8 14:50:56 2003
+++ bl-25-sd_underflow-fix/drivers/scsi/sd.c	Tue Sep 16 16:58:14 2003
@@ -174,7 +174,6 @@ static int sd_init_command(struct scsi_c
 			timeout = rq->timeout;
 
 		SCpnt->transfersize = rq->data_len;
-		SCpnt->underflow = rq->data_len;
 		goto queue;
 	}
 
diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/sr.c bl-25-sd_underflow-fix/drivers/scsi/sr.c
--- bl-25/drivers/scsi/sr.c	Mon Sep  8 14:50:56 2003
+++ bl-25-sd_underflow-fix/drivers/scsi/sr.c	Tue Sep 16 16:58:27 2003
@@ -301,7 +301,6 @@ static int sr_init_command(struct scsi_c
 			timeout = rq->timeout;
 
 		SCpnt->transfersize = rq->data_len;
-		SCpnt->underflow = rq->data_len;
 		goto queue;
 	}
 
-- Patrick Mansfield
