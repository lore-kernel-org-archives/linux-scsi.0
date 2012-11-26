From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI LLDs, the SCSI error handler and host resource lifetime
Date: Mon, 26 Nov 2012 18:23:43 +0100
Message-ID: <50B3A59F.3050506@acm.org>
References: <50AB9286.8040403@acm.org> <50AC808D.1060700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:47095 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab2KZRXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 12:23:46 -0500
In-Reply-To: <50AC808D.1060700@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11/21/12 08:19, Hannes Reinecke wrote:
> Hmm.
> This would still mean that the eh thread will run until finished.
> Which can take _A LOT_ of time (we're speaking hours here).
> I would rather have an additional return code in the various 
> scsi_try_XXX functions to terminate the loop quickly.

Hello Hannes,

Since I'm not sure that I understood you properly: is something like
the patch below what you had in mind ?

Thanks,

Bart.

[PATCH] Skip invoking error handler once device removal started

---
 drivers/scsi/scsi_error.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..697f7f2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -582,7 +582,8 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_bus_reset_handler(scmd);
+	rtn = scsi_host_scan_allowed(host) ?
+		hostt->eh_bus_reset_handler(scmd) : FAST_IO_FAIL;
 
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
@@ -621,7 +622,8 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_target_reset_handler(scmd);
+	rtn =  scsi_host_scan_allowed(host) ?
+		hostt->eh_target_reset_handler(scmd) : FAST_IO_FAIL;
 	if (rtn == SUCCESS) {
 		spin_lock_irqsave(host->host_lock, flags);
 		__starget_for_each_device(scsi_target(scmd->device), NULL,
@@ -645,12 +647,14 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
-	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd);
+	rtn = scsi_host_scan_allowed(host) ?
+		hostt->eh_device_reset_handler(scmd) : FAST_IO_FAIL;
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
-- 
1.7.10.4


