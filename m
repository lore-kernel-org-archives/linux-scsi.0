From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] 2.5.67+ scsi_release_request call queue next
Date: Tue, 29 Apr 2003 16:56:29 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304291630510.656-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1796 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261775AbTD2UoK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 16:44:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike:

I just noticed that your patch below isn't included in 2.5.68.  It still
works just fine.  Is it going to be submitted?

Alan Stern


Date: Mon, 14 Apr 2003 23:33:03 -0700
From: Mike Anderson <andmike@us.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: stern@rowland.harvard.edu
Subject: [PATCH] 2.5.67+ scsi_release_request call queue next

This patch is against 2.5.67 as of 04-14 as it needs extern for
scsi_queue_next_request.

I just compiled and booted this patch. I currently do not have a setup to
check door lock post error recovery.

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
The patch adds a call to scsi_queue_next_request from scsi_release_request. It
also removes a call in scsi_eh_lock_done to scsi_put_command.
scsi_release_request will do a call to scsi_put_command if needed.
EDESC


 drivers/scsi/scsi.c       |    2 ++
 drivers/scsi/scsi_error.c |    4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/scsi.c~scsi-release-req drivers/scsi/scsi.c
--- sysfs-bleed-2.5/drivers/scsi/scsi.c~scsi-release-req	Mon Apr 14 15:34:14 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi.c	Mon Apr 14 15:34:14 2003
@@ -224,8 +224,10 @@ void scsi_release_request(Scsi_Request *
 {
 	if( req->sr_command != NULL )
 	{
+    		request_queue_t *q = req->sr_device->request_queue;
 		scsi_put_command(req->sr_command);
 		req->sr_command = NULL;
+		scsi_queue_next_request(q, NULL);
 	}
 
 	kfree(req);
diff -puN drivers/scsi/scsi_error.c~scsi-release-req drivers/scsi/scsi_error.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_error.c~scsi-release-req	Mon Apr 14 15:34:14 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_error.c	Mon Apr 14 15:34:14 2003
@@ -1334,10 +1334,6 @@ static void scsi_eh_lock_done(struct scs
 {
 	struct scsi_request *sreq = scmd->sc_request;
 
-	scmd->sc_request = NULL;
-	sreq->sr_command = NULL;
-
-	scsi_put_command(scmd);
 	scsi_release_request(sreq);
 }
 

_



