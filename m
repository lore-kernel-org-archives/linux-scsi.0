From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Thu, 30 Sep 2004 10:09:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415BBF38.2080300@suse.de>
References: <Pine.LNX.4.44L0.0409291455180.1700-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020905010703020204090205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:31657 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S268781AbUI3INQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 04:13:16 -0400
In-Reply-To: <Pine.LNX.4.44L0.0409291455180.1700-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

This is a multi-part message in MIME format.
--------------020905010703020204090205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Alan Stern wrote:
> On Wed, 29 Sep 2004, Mike Anderson wrote:
> 
> 
>>Is it possible usb storage could do something else beside just ignore
>>the commands like return them with DID_NO_CONNECT.
>>
>>In storage_disconnect it looks like you set some state, wait for the
>>current command, but do not set anything that queuecommand can look at
>>to start rejecting commands.
> 
> 
> No, there is a flag set: US_FLIDX_DISCONNECTING.  queuecommand could use 
> that to reject commands.
> 
> On the other hand, considering the race between queuecommand and 
> scsi_remove_host, it shouldn't matter if queuecommand accepts the 
> commands.  After all, it's not really possible for the SCSI core to tell 
> whether queuecommand was called before or after scsi_remove_host.
> 
Ok, since this is essential the same thread then on linux-scsi
(cf. "Bug: CD driver sends commands during host removal") the same 
solution applies here also.

Alan, I did a different patch which omit the special case handling in
scsiglue.c and rather reorders usb_stor_control_thread. I'd prefer mine 
(naturally), but any of those will do.
And yes, both patches fix the problem.

Back to the maintainer for patch inclusion.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------020905010703020204090205
Content-Type: text/plain;
 name="usb-drop-requests-for-disconnect"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb-drop-requests-for-disconnect"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/30 09:59:42+02:00 hare@lammermuir.suse.de 
#   When a device is disconnected, we should mark the state accordingly
#   and drop the packet as there is no device we could talk to.
#   Fix suggested by James Bottomley.
#   
#   Signed-off-by: Hannes Reinecke <hare@suse.de>
# 
# drivers/usb/storage/usb.c
#   2004/09/30 09:59:34+02:00 hare@lammermuir.suse.de +3 -2
#   Fix SCSI command handling on disconnect.
# 
diff -Nru a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c	2004-09-30 10:09:01 +02:00
+++ b/drivers/usb/storage/usb.c	2004-09-30 10:09:01 +02:00
@@ -320,7 +320,8 @@
 
 		/* don't do anything if we are disconnecting */
 		if (test_bit(US_FLIDX_DISCONNECTING, &us->flags)) {
-			US_DEBUGP("No command during disconnect\n");
+			US_DEBUGP("Ignoring command during disconnect\n");
+			us->srb->result = DID_NO_CONNECT << 16;
 			goto SkipForDisconnect;
 		}
 
@@ -374,6 +375,7 @@
 		/* lock access to the state */
 		scsi_lock(host);
 
+SkipForDisconnect:
 		/* indicate that the command is done */
 		if (us->srb->result != DID_ABORT << 16) {
 			US_DEBUGP("scsi cmd done, result=0x%x\n", 
@@ -393,7 +395,6 @@
 			complete(&(us->notify));
 
 		/* empty the queue, reset the state, and release the lock */
-SkipForDisconnect:
 		us->srb = NULL;
 		us->sm_state = US_STATE_IDLE;
 		scsi_unlock(host);

--------------020905010703020204090205--
