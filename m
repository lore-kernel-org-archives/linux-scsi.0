From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] megaraid2 bad queuecommand return
Date: Fri, 19 Nov 2004 10:01:00 +0100
Message-ID: <20041119090100.GD26240@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:15808 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261318AbUKSJB2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 04:01:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi,

If the command is already completed, megaraid_queue_command() must
return 0.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/megaraid/megaraid_mbox.c 1.9 vs edited =====
--- 1.9/drivers/scsi/megaraid/megaraid_mbox.c	2004-10-08 17:12:09 +02:00
+++ edited/drivers/scsi/megaraid/megaraid_mbox.c	2004-11-18 23:12:10 +01:00
@@ -1623,6 +1623,7 @@ megaraid_queue_command(struct scsi_cmnd 
 
 	if (!scb) {	// command already completed
 		done(scp);
+		return 0;
 	}
 
 	return if_busy;

-- 
Jens Axboe

