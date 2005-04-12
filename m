From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/07] scsi: replace scsi_queue_insert() usages with scsi_retry_command()
Date: Tue, 12 Apr 2005 21:52:36 +0900 (KST)
Message-ID: <20050412125219.D4AAB938@htj.dyndns.org>
References: <20050412125219.88E5C1F6@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.201]:27458 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262431AbVDLMwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 08:52:46 -0400
Received: by rproxy.gmail.com with SMTP id a41so1506907rng
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2005 05:52:42 -0700 (PDT)
In-Reply-To: <20050412125219.88E5C1F6@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

03_scsi_requeue_use_scsi_retry_command_instead_of_scsi_queue_insert.patch

	There are two users of scsi_queue_insert() left now.  One in
	scsi_softirq() and the other in scsi_eh_flush_done_q().  The
	only additional functionality of scsi_queue_insert() used is
	setting device_blocked on ADD_TO_MLQUEUE case in
	scsi_softirq().

	Open code device_blocked setting and replace
	scsi_queue_insert() with scsi_retry_command() in both cases.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi.c       |    7 ++++---
 scsi_error.c |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi.c	2005-04-12 21:50:11.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi.c	2005-04-12 21:50:11.000000000 +0900
@@ -638,6 +638,7 @@ static void scsi_softirq(struct softirq_
 	while (!list_empty(&local_q)) {
 		struct scsi_cmnd *cmd = list_entry(local_q.next,
 						   struct scsi_cmnd, eh_entry);
+		struct scsi_device *sdev = cmd->device;
 		list_del_init(&cmd->eh_entry);
 
 		disposition = scsi_decide_disposition(cmd);
@@ -646,12 +647,12 @@ static void scsi_softirq(struct softirq_
 		case SUCCESS:
 			scsi_finish_command(cmd);
 			break;
+		case ADD_TO_MLQUEUE:
+			sdev->device_blocked = sdev->max_device_blocked;
+			/* fall through */
 		case NEEDS_RETRY:
 			scsi_retry_command(cmd);
 			break;
-		case ADD_TO_MLQUEUE:
-			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
-			break;
 		default:
 			if (!scsi_eh_scmd_add(cmd, 0))
 				scsi_finish_command(cmd);
Index: scsi-reqfn-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_error.c	2005-04-12 21:50:10.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_error.c	2005-04-12 21:50:11.000000000 +0900
@@ -1522,7 +1522,7 @@ static void scsi_eh_flush_done_q(struct 
 							  " retry cmd: %p\n",
 							  current->comm,
 							  scmd));
-				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+			scsi_retry_command(scmd);
 		} else {
 			if (!scmd->result)
 				scmd->result |= (DRIVER_TIMEOUT << 24);

