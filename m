From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Requested changes for the SCSI error handler
Date: Fri, 4 Jun 2004 16:23:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040604232344.GA3214@us.ibm.com>
References: <1086122775.2061.87.camel@mulgrave> <Pine.LNX.4.44L0.0406041655550.843-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:49372 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266084AbUFDXXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 19:23:38 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0406041655550.843-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> 
> How does this look?
> 

Looks ok. I know your patch is in line with James requests, but I had a
counter idea that allows for setting the settle delays up, down, or to
zero post scsi_host_alloc. If the LLDD does nothing behavior should not
change. This would allow increasing settle if some LLDD wanted it and
also set it through sysfs if we wanted that in the future.  You can
throw this patch in the bit bucket if you want to go the previously
stated direction.

-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
Make bus reset and host reset settle times adjustable.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
EDESC


 patched-2.6-andmike/drivers/scsi/hosts.c      |    8 ++++++++
 patched-2.6-andmike/drivers/scsi/scsi_error.c |    7 +++++--
 patched-2.6-andmike/include/scsi/scsi_host.h  |    4 ++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/scsi/scsi_host.h~host_settle include/scsi/scsi_host.h
--- patched-2.6/include/scsi/scsi_host.h~host_settle	Fri Jun  4 00:14:29 2004
+++ patched-2.6-andmike/include/scsi/scsi_host.h	Fri Jun  4 00:21:02 2004
@@ -485,6 +485,10 @@ struct Scsi_Host {
 	 */
 	struct list_head sht_legacy_list;
 
+	/* settle times */
+	int b_rst_settle_time;
+	int h_rst_settle_time;
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff -puN drivers/scsi/scsi_error.c~host_settle drivers/scsi/scsi_error.c
--- patched-2.6/drivers/scsi/scsi_error.c~host_settle	Fri Jun  4 00:17:53 2004
+++ patched-2.6-andmike/drivers/scsi/scsi_error.c	Fri Jun  4 00:20:37 2004
@@ -1026,7 +1026,7 @@ static int scsi_try_bus_reset(struct scs
 	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
-		scsi_sleep(BUS_RESET_SETTLE_TIME);
+		scsi_sleep(scmd->device->host->b_rst_settle_time);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
@@ -1057,7 +1057,7 @@ static int scsi_try_host_reset(struct sc
 	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
-		scsi_sleep(HOST_RESET_SETTLE_TIME);
+		scsi_sleep(scmd->device->host->h_rst_settle_time);
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
@@ -1218,6 +1218,9 @@ void scsi_sleep(int timeout)
 {
 	DECLARE_MUTEX_LOCKED(sem);
 	struct timer_list timer;
+
+	if (!timeout)
+		return;
 
 	init_timer(&timer);
 	timer.data = (unsigned long)&sem;
diff -puN drivers/scsi/hosts.c~host_settle drivers/scsi/hosts.c
--- patched-2.6/drivers/scsi/hosts.c~host_settle	Fri Jun  4 00:21:33 2004
+++ patched-2.6-andmike/drivers/scsi/hosts.c	Fri Jun  4 14:36:07 2004
@@ -38,6 +38,12 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+/*
+ *  * These should *probably* be handled by the host itself.
+ *   * Since it is allowed to sleep, it probably should.
+ *    */
+#define BUS_RESET_SETTLE_TIME   10*HZ
+#define HOST_RESET_SETTLE_TIME  10*HZ
 
 static int scsi_host_next_hn;		/* host_no for next new host */
 
@@ -280,6 +286,8 @@ struct Scsi_Host *scsi_host_alloc(struct
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
 
+	shost->b_rst_settle_time = BUS_RESET_SETTLE_TIME;
+	shost->h_rst_settle_time = HOST_RESET_SETTLE_TIME;
 	shost->eh_notify = &complete;
 	rval = kernel_thread(scsi_error_handler, shost, 0);
 	if (rval < 0)

_

