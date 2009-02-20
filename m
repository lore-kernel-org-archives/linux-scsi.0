From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: PATCH 1/1] : Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 06:53:48 -0700
Message-ID: <20090220135347.GS16841@parisc-linux.org>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC7D@GVW1105EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56522 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZBTNyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2009 08:54:04 -0500
Content-Disposition: inline
In-Reply-To: <DB8E544DD4B3D346A36F2698103530AE292A9BDC7D@GVW1105EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Feb 20, 2009 at 12:03:58PM +0000, Rengarajan, Narayanan (STSD) wrote:
>   Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time in 2.6.27 kernel.
> 
>  Steps to reproduce:
>  1. present a standby lun to the host
>  2. do a discovery from the host (scan the scsi bus)  3. Spinning of disks is  observed in  /var/log/messages
> 
> Whenever a device goes offline and comes back, the new sd device takes longer time to get created. This is because of the spinning up of disk in sd_spinup_disk fuction as the standby paths would return device not ready with 0x04/0x0b asc/ascq.

I think your analysis is correct.

It's probably better for you to not use Outlook to send email here; it's
failed at line wrapping and it's mangled your patch quite badly.  See
Documentation/email-clients.txt for more details.

> Recommended patch :
> 
>   diff -pNaur /usr/src/linux/drivers/scsi/sd.c sd.c
> --- /usr/src/linux/drivers/scsi/sd.c    2009-02-09 22:24:56.000000000 +0530
> +++ sd.c        2009-02-19 16:39:16.000000000 +0530
> @@ -1181,8 +1181,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>                  */
>                 if (sense_valid &&
>                     sshdr.sense_key == NOT_READY &&
> -                   sshdr.asc == 4 && sshdr.ascq == 3) {
> -                       break;          /* manual intervention required */
> +                   sshdr.asc == 4 && (sshdr.ascq == 3 || sshdr.ascq == 
> + 0x0b ||
> sshdr.ascq == 0x0c) ) {
> +                       break;  /* manual intervention required || 
> + Standby ||
> Unavailable */
> 
>  signed off : narayanan.rengarajan@hp.com

I don't like the patch though.  Apart from being badly mangled, it makes
the if condition rather unbalanced and hard to read.  I think the patch
would be better.

Even this patch, I wonder about.  I've looked at the ASC/ASCQ tables for
'NOT_READY', and really only ASC 4, ASCQ 2 seems to require the
START_STOP command to be sent.  Should we invert the sense of these
tests so we only send START_STOP in cases where it's known to do some
good?

---

Don't try to spin up drives that are connected to an inactive port

We currently try to spin up drives connected to standby and unavailable
ports.  This will never succeed and wastes a lot of time.  Fail quickly
if the sense data reports the port is in standby or unavailable state.

Reported-by: Narayanan Rengarajan <narayanan.rengarajan@hp.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d57566b..289cd46 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1166,23 +1166,19 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		/*
 		 * The device does not want the automatic start to be issued.
 		 */
-		if (sdkp->device->no_start_on_add) {
+		if (sdkp->device->no_start_on_add)
 			break;
-		}
-
-		/*
-		 * If manual intervention is required, or this is an
-		 * absent USB storage device, a spinup is meaningless.
-		 */
-		if (sense_valid &&
-		    sshdr.sense_key == NOT_READY &&
-		    sshdr.asc == 4 && sshdr.ascq == 3) {
-			break;		/* manual intervention required */
 
-		/*
-		 * Issue command to spin up drive when not ready
-		 */
-		} else if (sense_valid && sshdr.sense_key == NOT_READY) {
+		if (sense_valid && sshdr.sense_key == NOT_READY) {
+			if (sshdr.asc == 4 && sshdr.ascq == 3)
+				break;	/* manual intervention required */
+			if (sshdr.asc == 4 && sshdr.ascq == 0xb)
+				break;	/* standby */
+			if (sshdr.asc == 4 && sshdr.ascq == 0xc)
+				break;	/* unavailable */
+			/*
+			 * Issue command to spin up drive when not ready
+			 */
 			if (!spintime) {
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
 				cmd[0] = START_STOP;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
