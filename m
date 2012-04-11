From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Wed, 11 Apr 2012 12:10:08 -0400
Message-ID: <yq18vi2ckrj.fsf@sermon.lab.mkp.net>
References: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com>
	<4F83EC71.90904@acm.org> <4F8461E3.3050808@cs.wisc.edu>
	<4F846398.5030609@cs.wisc.edu> <4F846506.4060801@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31345 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2DKQKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Apr 2012 12:10:38 -0400
In-Reply-To: <4F846506.4060801@cs.wisc.edu> (Mike Christie's message of "Tue,
	10 Apr 2012 11:51:18 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, Elric Fu <elricfu1@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Felipe Balbi <balbi@ti.com>, Alex He <alex.he@amd.com>, Andiry Xu <andiry.xu@amd.com>, Greg KH <gregkh@linuxfoundation.org>, Linux USB Mailing List <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:

>>>> I have observed crashes at the same point while testing device
>>>> removal with the ib_srp driver. As far as I can see that code was
>>>> added through commit 18a4d0a22ed6c54b67af7718c305cd010f09ddf8
>>>> (February 9, 2012). The approach of that patch looks questionable
>>>> to me: what guarantees that the struct scsi_driver will be
>>>> available at the time the SCSI error handler needs it ?

Sorry about that!


Mike> That is wrong. I guess REQ_DISCARD and REQ_FLUSH will, so I guess
Mike> we just have to check for a NULL sdrv above.

How about we do this?


SCSI: Fix error handling when no ULD is attached

Commit 18a4d0a2 introduced a bug in which we would attempt to
dereference the scsi driver even when the device had no ULD attached.

Ensure that a driver is registered and make the driver accessor function
more resilient to errors during device discovery.

Reported-by: Elric Fu <elricfu1@gmail.com>
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2cfcbff..386f0c5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -835,7 +835,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-	if (sdrv->eh_action)
+	if (sdrv && sdrv->eh_action)
 		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
 
 	return rtn;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 377df4a..1e11985 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -134,6 +134,9 @@ struct scsi_cmnd {
 
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
+	if (!cmd->request->rq_disk)
+		return NULL;
+
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
