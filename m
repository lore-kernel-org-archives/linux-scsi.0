From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] fix badness in scsi_single_lun_run
Date: Fri, 30 Jan 2004 12:14:42 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040130121442.A12509@beaverton.ibm.com>
References: <20040127003244.GM23308@serve.riede.org> <20040128033041.GY23308@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:52216 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263625AbUA3UPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 15:15:14 -0500
Content-Disposition: inline
In-Reply-To: <20040128033041.GY23308@serve.riede.org>; from wrlk@riede.org on Tue, Jan 27, 2004 at 10:30:41PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Willem - the WARN_ON is bogus. 

James - can you please apply?

This patch against recent mainline bk removes the bogus WARN_ON for
single_lun devices, and a meaningless comment.

We clear the starget_sdev_user, and immediately blk_run_queue for the LUN
that just issued IO. Another LUN could race in scsi_request_fn, but it is
most likely that the last user will get there first, and reset
starget_sdev_user. If it does not, it will have to wait for the other LUN
to finish all of its IO.

===== drivers/scsi/scsi_lib.c 1.115 vs edited =====
--- 1.115/drivers/scsi/scsi_lib.c	Sat Nov 22 16:20:45 2003
+++ edited/drivers/scsi/scsi_lib.c	Fri Jan 30 11:18:39 2004
@@ -340,7 +340,6 @@
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	WARN_ON(!current_sdev->sdev_target->starget_sdev_user);
 	current_sdev->sdev_target->starget_sdev_user = NULL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -352,10 +351,6 @@
 	 */
 	blk_run_queue(current_sdev->request_queue);
 
-	/*
-	 * After unlock, this races with anyone clearing starget_sdev_user,
-	 * but we always enter this function again, avoiding any problems.
-	 */
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (current_sdev->sdev_target->starget_sdev_user)
 		goto out;
