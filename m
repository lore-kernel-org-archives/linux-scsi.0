From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suggestion for addition to Documentation/scsi/scsi_mid_low_api.txt
Date: Fri, 2 Jul 2004 11:37:53 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0407021128500.1038-100000@ida.rowland.org>
References: <1088721250.40e4916212bed@wwws.torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6660 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263020AbUGBPhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2004 11:37:53 -0400
In-Reply-To: <1088721250.40e4916212bed@wwws.torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 1 Jul 2004 dougg@torque.net wrote:

> Quoting Alan Stern <stern@rowland.harvard.edu>:
> 
> > 	The test given for valid data in the sense_buffer isn't correct.
> > 	The actual test used is ((cmd->sense_buffer[0] & 0x7f) == 0x70).
> > 	This is mentioned in a couple of places in the document.
> 
> If that comparison is in linux code then the comparison
> is wrong! The comparison that is correct is bits 4, 5 and 6
> all being set. So we don't care about bit 7 and the bottom
> two bits can be 0x0, 0x1, 0x2 or 0x3. The fact that linux
> can't handle sense buffer "descriptor" format is an issue
> that needs to be addressed soon (but is unlikely to be an
> issue for usb-storage devices for some time).

Hmmm...  I see the test being done two different ways, sometimes masked 
with 0x70 and sometimes with 0x7f.  The latter form is used in scsi_lib.c, 
sd.c, sr.c, and sg.c.  Maybe a patch is in order.

> > 	You didn't mention cmd->underflow.
> 
> I thought that 'resid' superseded 'underflow'. I'll look
> into it.

Look at http://marc.theaimsgroup.com/?l=linux-scsi&m=108671007701796&w=2 
and followup messages.

> > 	Although it's pretty obvious, you might want to add that 
> > 	cmd->device points to the scsi_device for which the command was 
> > 	queued.
> 
> Thought about that. In lk 2.6 I don't think there is a
> 'device' (I need to check) but there is an access
> function (that bumps the usage counter on the scsi_device
> object in question).

No, there definitely is a device.

Alan Stern

