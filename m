From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] - mptfusion - adding back the spin locks in eh handle
  rs
Date: Thu, 23 Jun 2005 19:47:56 -0400
Message-ID: <42BB4A2C.3050009@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C02DD8E97@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42675 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262915AbVFWXsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 19:48:09 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C02DD8E97@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On 06/23/05 18:06, Moore, Eric Dean wrote:
> Luben
> 
> Ok - So you agree that completing Task management request
> in the same context as the eh threads is the way to go, right?

I think so -- process context.
 
> Because that is what this LLD is doing.  Have you had
> a chance to look at our code?

No, I haven't looked -- I'm swamped.
 
> That previous patch submitted by Jeff(I guess) was removing code which
> enabled interrupts.  My patch was restoring it back to previous
> working code which doesn't hang the driver.

In LLDD yes (since they were never disabled when eh_abort() was called).
In SCSI Core -- the opposite: removing code which disabled ints and then
calling eh_abort() of the LLDD.
 
> The reason that the previous patch hangs the driver is we are issuing
> the task managment request using interrupt mode, not polling.
> Meaning it requires interrupts to be enabled. 

They are!  The abort handler is called with ints enabled.
See the core of Jeff's patch here:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -528,10 +528,8 @@ static int scsi_send_eh_cmnd(struct scsi
 		 * abort a timed out command or not.  not sure how
 		 * we should treat them differently anyways.
 		 */
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->hostt->eh_abort_handler)
 			shost->hostt->eh_abort_handler(scmd);
-		spin_unlock_irqrestore(shost->host_lock, flags);
 			
 		scmd->request->rq_status = RQ_SCSI_DONE;
 		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
@@ -737,11 +735,8 @@ static int scsi_eh_get_sense(struct list
  **/
 static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	unsigned long flags;
-	int rtn = FAILED;
-
 	if (!scmd->device->host->hostt->eh_abort_handler)
-		return rtn;
+		return FAILED;
 
 	/*
 	 * scsi_done was called just after the command timed out and before
@@ -752,11 +747,7 @@ static int scsi_try_to_abort_cmd(struct 
 
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
-	rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
-
-	return rtn;
+	return scmd->device->host->hostt->eh_abort_handler(scmd);
 }
 
 /**

So the LLDD is free to sleep in eh_abort().  If it needs to do
something with ints disabled, it should disable them itself.

	Luben



