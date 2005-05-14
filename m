From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/03] scsi: remove a timer race in scsi_queue_insert()
Date: Sat, 14 May 2005 09:46:08 +0900 (KST)
Message-ID: <20050514004601.9B37DCE8@htj.dyndns.org>
References: <20050514004601.783910E3@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.204]:37211 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262648AbVENAqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 20:46:12 -0400
Received: by rproxy.gmail.com with SMTP id a41so476288rng
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2005 17:46:11 -0700 (PDT)
In-Reply-To: <20050514004601.783910E3@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

01_scsi_timer_dispatch_race_fix.patch

	scsi_queue_insert() has four callers.  Three callers call with
	timer disabled and one (the second invocation in
	scsi_dispatch_cmd()) calls with timer activated.
	scsi_queue_insert() used to always call scsi_delete_timer()
	and ignore the return value.  This results in race with timer
	expiration.  Remove scsi_delete_timer() call from
	scsi_queue_insert() and make the caller delete timer and check
	the return value.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi.c     |   10 ++++++----
 scsi_lib.c |    8 +-------
 2 files changed, 7 insertions(+), 11 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi.c	2005-05-14 09:43:18.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi.c	2005-05-14 09:45:59.000000000 +0900
@@ -638,10 +638,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
-		atomic_inc(&cmd->device->iodone_cnt);
-		scsi_queue_insert(cmd,
-				(rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
-				 rtn : SCSI_MLQUEUE_HOST_BUSY);
+		if (scsi_delete_timer(cmd)) {
+			atomic_inc(&cmd->device->iodone_cnt);
+			scsi_queue_insert(cmd,
+					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
+					  rtn : SCSI_MLQUEUE_HOST_BUSY);
+		}
 		SCSI_LOG_MLQUEUE(3,
 		    printk("queuecommand : request rejected\n"));
 	}
Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-05-14 09:43:18.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-05-14 09:45:59.000000000 +0900
@@ -128,13 +128,7 @@ int scsi_queue_insert(struct scsi_cmnd *
 		 printk("Inserting command %p into mlqueue\n", cmd));
 
 	/*
-	 * We are inserting the command into the ml queue.  First, we
-	 * cancel the timer, so it doesn't time out.
-	 */
-	scsi_delete_timer(cmd);
-
-	/*
-	 * Next, set the appropriate busy bit for the device/host.
+	 * Set the appropriate busy bit for the device/host.
 	 *
 	 * If the host/device isn't busy, assume that something actually
 	 * completed, and that we should be able to queue a command now.

