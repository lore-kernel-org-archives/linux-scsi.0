From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 13/13] scsi: consolidate scsi_cmd_retry() calls in scsi_error.c
Date: Thu, 31 Mar 2005 18:08:55 +0900 (KST)
Message-ID: <20050331090647.121616FD@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.207]:58185 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261270AbVCaJJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 04:09:01 -0500
Received: by rproxy.gmail.com with SMTP id 1so339716rny
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 01:09:00 -0800 (PST)
In-Reply-To: <20050331090647.FEDC3964@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

13_scsi_consolidate_cmd_retry_calls_in_eh.patch

	Replace all scsi_setup_cmd_retry() calls in scsi_error.c with
	a call just above scsi_finish_command() in scsi_eh_flush_done_q().

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_error.c |   25 +------------------------
 1 files changed, 1 insertion(+), 24 deletions(-)

Index: scsi-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_error.c	2005-03-31 18:06:22.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_error.c	2005-03-31 18:06:23.000000000 +0900
@@ -615,11 +615,6 @@ static int scsi_request_sense(struct scs
 
 	kfree(scsi_result);
 
-	/*
-	 * when we eventually call scsi_finish, we really wish to complete
-	 * the original request, so let's restore the original data. (db)
-	 */
-	scsi_setup_cmd_retry(scmd);
 	scmd->result = saved_result;
 	return rtn;
 }
@@ -641,14 +636,7 @@ static void scsi_eh_finish_cmd(struct sc
 {
 	scmd->device->host->host_failed--;
 	scmd->state = SCSI_STATE_BHQUEUE;
-
 	scsi_eh_eflags_clr_all(scmd);
-
-	/*
-	 * set this back so that the upper level can correctly free up
-	 * things.
-	 */
-	scsi_setup_cmd_retry(scmd);
 	list_move_tail(&scmd->eh_entry, done_q);
 }
 
@@ -785,12 +773,6 @@ retry_tur:
 	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT);
 
 	/*
-	 * when we eventually call scsi_finish, we really wish to complete
-	 * the original request, so let's restore the original data. (db)
-	 */
-	scsi_setup_cmd_retry(scmd);
-
-	/*
 	 * hey, we are done.  let's look to see what happened.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
@@ -913,12 +895,6 @@ static int scsi_eh_try_stu(struct scsi_c
 	rtn = scsi_send_eh_cmnd(scmd, START_UNIT_TIMEOUT);
 
 	/*
-	 * when we eventually call scsi_finish, we really wish to complete
-	 * the original request, so let's restore the original data. (db)
-	 */
-	scsi_setup_cmd_retry(scmd);
-
-	/*
 	 * hey, we are done.  let's look to see what happened.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
@@ -1558,6 +1534,7 @@ static void scsi_eh_flush_done_q(struct 
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
 							" cmd: %p\n",
 							current->comm, scmd));
+			scsi_setup_cmd_retry(scmd);
 			scsi_finish_command(scmd);
 		}
 	}

