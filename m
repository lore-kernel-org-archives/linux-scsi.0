From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [patch] 3/5 scsi-locking-2.5 prevent looping when processing starved queues
Date: Wed, 9 Apr 2003 16:47:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409164733.C23701@beaverton.ibm.com>
References: <20030409164612.A23701@beaverton.ibm.com> <20030409164701.B23701@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:17367 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263868AbTDIXjj (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 19:39:39 -0400
Content-Disposition: inline
In-Reply-To: <20030409164701.B23701@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Apr 09, 2003 at 04:47:01PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Ensure that we cannot loop forever (however unlikely) when processing the
starved queues.

diff -purN -X /home/patman/dontdiff 02_no_hier/drivers/scsi/scsi_lib.c 03_no_loop/drivers/scsi/scsi_lib.c
--- 02_no_hier/drivers/scsi/scsi_lib.c	Wed Apr  9 12:39:20 2003
+++ 03_no_loop/drivers/scsi/scsi_lib.c	Wed Apr  9 12:39:22 2003
@@ -470,6 +470,13 @@ void scsi_queue_next_request(request_que
 		spin_unlock_irqrestore(sdev2->request_queue->queue_lock, flags);
 
 		spin_lock_irqsave(shost->host_lock, flags);
+		if (unlikely(!list_empty(&sdev->starved_entry)))
+			/*
+			 * sdev lost a race, and was put back on the
+			 * starved list. This is unlikely but without this
+			 * in theory we could loop forever.
+			 */
+			break;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
