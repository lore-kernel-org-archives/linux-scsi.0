From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
Date: Wed, 3 Dec 2003 18:05:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031204020508.GB1775@beaverton.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E57037F83D5@exa-atlanta.se.lsil.com> <200312032348.AA02824@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:14052 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263024AbTLDCAO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 21:00:14 -0500
Content-Disposition: inline
In-Reply-To: <200312032348.AA02824@fukuchi.jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: "Moore, Eric Dean" <emoore@lsil.com>, Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>, linux-scsi <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsil.com

Masao Fukuchi [fukuchi.masao@jp.fujitsu.com] wrote:
> 
> I also tested with kernel 2.6.0-test11 + mpt fusion 2.05.00.05 driver,
> but the problem didn't solve.
> I think the problem is in the retry sequence of mid layer not mpt driver.
> At the last retry sequence, bus reset finished with success but mid layer
> didn't retry read command again and returned to application with success 
> status.
> 

In reviewing the error handler with Patrick it looks like there is a bug
in scsi_eh_flush_done_q when scmd->allowed has been exceeded and the
command error was a timeout.

The patch below may help, but I only have compile / boot tested it.
Could you test this on your error and see if it helps.

If it does not help. Turning on scsi logging for error recovery would
provide more info.

-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
This patch fixes a bug in scsi_eh_flush_done_q when the allowed count has
been exceeded and the command errored for a timeout. The bug is that the
result will be left at zero and the command finished.

Thu Dec  4 01:42:46 UTC 2003
EDESC


 drivers/scsi/scsi_error.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/scsi_error.c~scsi_error_retry drivers/scsi/scsi_error.c
--- 2.6/drivers/scsi/scsi_error.c~scsi_error_retry	Wed Dec  3 16:36:35 2003
+++ 2.6-andmike/drivers/scsi/scsi_error.c	Wed Dec  3 16:43:02 2003
@@ -1421,23 +1421,20 @@ static void scsi_eh_flush_done_q(struct 
 	list_for_each_safe(lh, lh_sf, done_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
 		list_del_init(lh);
-		if (!scmd->device->online) {
-			 scmd->result |= (DRIVER_TIMEOUT << 24);
-		} else {
-			if (++scmd->retries < scmd->allowed) {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					printk("%s: flush retry"
-					       " cmd: %p\n",
-						  current->comm,
-						  scmd));
+		if (scmd->device->online && 
+		    	(++scmd->retries < scmd->allowed)) {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
+							  " retry cmd: %p\n",
+							  current->comm,
+							  scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
-				continue;
-			}
+		} else {
+			scmd->result |= (DRIVER_TIMEOUT << 24);
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
+							" cmd: %p\n",
+							current->comm, scmd));
+			scsi_finish_command(scmd);
 		}
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
-				       " cmd: %p\n",
-					  current->comm, scmd));
-		scsi_finish_command(scmd);
 	}
 }
 

_
