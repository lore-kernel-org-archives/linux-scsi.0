From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with sr_get_events
Date: Tue, 17 Apr 2012 11:33:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204171128580.1364-100000@iolanthe.rowland.org>
References: <20120416225512.GH12421@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53009 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756252Ab2DQPd2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 11:33:28 -0400
In-Reply-To: <20120416225512.GH12421@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 16 Apr 2012, Tejun Heo wrote:

> Hello, Alan.  Sorry about the delay.
> 
> On Sun, Apr 08, 2012 at 09:24:32AM -0400, Alan Stern wrote:
> > There are several closely related issues involving sr_get_events().
> > 
> > The first may just be confusion on my part.  You've got a 
> > cd->ignore_get_event flag, whose name seems to mean that the result 
> > from sr_get_events() should be ignored.  But the result isn't ignored 
> > entirely; only the DISK_EVENT_MEDIA_CHANGE bit is cleared.
> >
> > Furthermore, if you really do intend to ignore the result from 
> > sr_get_events() then why call it in the first place?  Or does the flag 
> > actually mean that you want to ignore the media-change bit from 
> > get_events while still using the other bits?
> 
> The only thing which caused actual problem was media changed
> detection.  This being a workaround for badly broken hardware, I think
> it would be better to keep the behavior minmially deviated from the
> normal path.  Let's say it's abbreviation of
> ->ignore_media_changed_from_get_event.
> 
> > Finally, the GET_EVENT_STATUS_NOTIFICATION command is not present in 
> > all versions of SCSI, and not all drives support it.  sr_get_events() 
> > should check for an ILLEGAL_REQUEST sense key and stop sending the 
> > command if it is found.  Maybe a new flag will be needed for this.
> 
> Hmmm... Maybe but we've been sending GET_EVENT without such provision
> for very long time now.  I feel reluctant to change something which
> seems to work in this area even if that something is technically
> wrong.  It's not like cheap USB devices tend to be technically correct
> anyway.

All right, then how do you feel about this patch?  It makes minimal
changes, to avoid the inefficiency of sending repeated commands that
can never work.

Alan Stern



Index: usb-3.4/drivers/scsi/sr.h
===================================================================
--- usb-3.4.orig/drivers/scsi/sr.h
+++ usb-3.4/drivers/scsi/sr.h
@@ -46,7 +46,8 @@ typedef struct scsi_cd {
 	int tur_mismatch;		/* nr of get_event TUR mismatches */
 	bool tur_changed:1;		/* changed according to TUR */
 	bool get_event_changed:1;	/* changed according to GET_EVENT */
-	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
+	bool ignore_get_event:1;	/* MEDIA_CHANGE is unreliable, use TUR */
+	bool skip_get_event:1;		/* GET_EVENT is unavailable, use TUR */
 
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
Index: usb-3.4/drivers/scsi/sr.c
===================================================================
--- usb-3.4.orig/drivers/scsi/sr.c
+++ usb-3.4/drivers/scsi/sr.c
@@ -166,7 +166,7 @@ static void scsi_cd_put(struct scsi_cd *
 	mutex_unlock(&sr_ref_mutex);
 }
 
-static unsigned int sr_get_events(struct scsi_device *sdev)
+static unsigned int sr_get_events(struct scsi_cd *cd)
 {
 	u8 buf[8];
 	u8 cmd[] = { GET_EVENT_STATUS_NOTIFICATION,
@@ -182,10 +182,17 @@ static unsigned int sr_get_events(struct
 	struct scsi_sense_hdr sshdr;
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
+	result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
+				  buf, sizeof(buf),
 				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
-		return DISK_EVENT_MEDIA_CHANGE;
+	if (scsi_sense_valid(&sshdr)) {
+		if (sshdr.sense_key == UNIT_ATTENTION)
+			return DISK_EVENT_MEDIA_CHANGE;
+		if (sshdr.sense_key == ILLEGAL_REQUEST) {
+			cd->skip_get_event = 1;
+			return 0;
+		}
+	}
 
 	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
 		return 0;
@@ -213,14 +220,16 @@ static unsigned int sr_check_events(stru
 	struct scsi_cd *cd = cdi->handle;
 	bool last_present;
 	struct scsi_sense_hdr sshdr;
-	unsigned int events;
+	unsigned int events = 0;
 	int ret;
 
 	/* no changer support */
 	if (CDSL_CURRENT != slot)
 		return 0;
 
-	events = sr_get_events(cd->device);
+	if (cd->skip_get_event)
+		goto do_tur;
+	events = sr_get_events(cd);
 	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
 
 	/*

