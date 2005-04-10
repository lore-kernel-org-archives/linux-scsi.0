From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 07/07] scsi: make reuse of SCSI cmd timer strict
Date: Mon, 11 Apr 2005 03:45:41 +0900 (KST)
Message-ID: <20050410184215.FFD7AAEA@htj.dyndns.org>
References: <20050410184214.4AAD0992@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.195]:43568 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261577AbVDJSpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 14:45:50 -0400
Received: by wproxy.gmail.com with SMTP id 68so1362749wri
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2005 11:45:46 -0700 (PDT)
In-Reply-To: <20050410184214.4AAD0992@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

07_scsi_timer_strict_reuse.patch

	SCSI cmd timer shouldn't be reused while it's active.  Make
	sure that the unused condition is marked with
	eh_timeout->function = NULL and BUG() active reuse path.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_error.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_error.c	2005-04-11 03:42:12.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_error.c	2005-04-11 03:42:13.000000000 +0900
@@ -99,6 +99,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
  **/
 static void scsi_times_out(struct scsi_cmnd *scmd)
 {
+	scmd->eh_timeout.function = NULL;
+
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
 	if (scmd->device->host->hostt->eh_timed_out)
@@ -136,14 +138,7 @@ static void scsi_times_out(struct scsi_c
  **/
 void scsi_add_timer(struct scsi_cmnd *scmd, int timeout)
 {
-
-	/*
-	 * If the clock was already running for this command, then
-	 * first delete the timer.  The timer handling code gets rather
-	 * confused if we don't do this.
-	 */
-	if (scmd->eh_timeout.function)
-		del_timer(&scmd->eh_timeout);
+	BUG_ON(scmd->eh_timeout.function);
 
 	scmd->eh_timeout.data = (unsigned long)scmd;
 	scmd->eh_timeout.expires = jiffies + timeout;
@@ -177,7 +172,6 @@ int scsi_delete_timer(struct scsi_cmnd *
 					 " rtn: %d\n", __FUNCTION__,
 					 scmd, rtn));
 
-	scmd->eh_timeout.data = (unsigned long)NULL;
 	scmd->eh_timeout.function = NULL;
 
 	return rtn;

