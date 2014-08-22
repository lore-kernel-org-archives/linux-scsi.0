From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Fri, 22 Aug 2014 17:29:35 +0000
Message-ID: <bug-80711-11613-cgWy7xBT3K@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36686 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbaHVR3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2014 13:29:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D36592018A
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 17:29:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4F4DC201BA
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 17:29:36 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #17 from Alan Stern <stern@rowland.harvard.edu> ---
On Fri, 22 Aug 2014, James Bottomley wrote:

> On Fri, 2014-08-22 at 10:53 -0400, Alan Stern wrote:

> > Sending the initial INQUIRY command to LUNs larger than 0 involves a
> > chicken-and-egg problem -- we don't know whether to fill in the LUN
> > bits in the command until we know the SCSI level, and we don't know the
> > SCSI level until the INQUIRY response is received.  The solution we 
> > have been using is to store the most recently discovered level in the 
> > target structure, and use it as a default.  If probing starts with LUN 
> > 0, and if all the LUNs have similar levels, this ought to work.
> > 
> > Except for one thing: The code does store the default level in the
> > scsi_target, but forgets to copy it back into each newly allocated
> > scsi_device!  I added a line to do that into the patch.

> > --- usb-3.16.orig/include/scsi/scsi_host.h
> > +++ usb-3.16/include/scsi/scsi_host.h
> > @@ -695,6 +695,9 @@ struct Scsi_Host {
> >  	/* The controller does not support WRITE SAME */
> >  	unsigned no_write_same:1;
> >  
> > +	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
> > +	unsigned no_scsi2_lun_in_cdb:1;
> 
> I think Christoph mentioned shortening this flag length, but personally
> I'm not that bothered.

It was shorter in the original version of the patch, but I decided to
make it a little longer to match the name of the new scsi_device flag
added in this version.

> > --- usb-3.16.orig/drivers/scsi/scsi_scan.c
> > +++ usb-3.16/drivers/scsi/scsi_scan.c
> > @@ -257,6 +257,7 @@ static struct scsi_device *scsi_alloc_sd
> >  
> >  	sdev->sdev_gendev.parent = get_device(&starget->dev);
> >  	sdev->sdev_target = starget;
> > +	sdev->scsi_level = starget->scsi_level;
> 
> Why is this necessary?  Isn't this set correctly in scsi_probe_lun?  The
> target level is actually set from the device level.

The reason was mentioned in the quoted text at the start of this email.

In greater detail: Yes, sdev->scsi_level is set correctly in
scsi_probe_lun, but only _after_ the INQUIRY data has been received
(because the level is part of the INQUIRY data).  So how can the
INQUIRY CDB be set up correctly before we know the device's level?

(When the current code sends an INQUIRY for LUN 1, it will _not_ put 
the LUN bits in CDB[1] -- even if LUN 0 reported SCSI-2.  That doesn't 
seem right.)

My answer is to use a default level copied from the target.  The
target's level in turn was set from the previously probed device...  
which means that the first device to be probed gets a default level of
SCSI-2.  That's okay as long as the first device probed is LUN 0.

Hmmm, but now I see the patch doesn't set a default value for the new
sdev->lun_in_cdb flag.  That needs to be fixed...

> Other than this, I'm fine with the code ... you can add the acked by
> from me when we resolve the above question.

Okay.  It's true that this issue is only tangentially related to the 
main point of the patch.  It could be removed and addressed later.

Alan Stern

-- 
You are receiving this mail because:
You are the assignee for the bug.