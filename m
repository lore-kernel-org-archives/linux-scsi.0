From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 3 Sep 2014 14:44:48 -0400
Message-ID: <201409031844.s83IimIl011663@hobgoblin.ariadne.com>
References: <Pine.LNX.4.44L0.1408301710120.4299-100000@netrider.rowland.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta14.westchester.pa.mail.comcast.net ([76.96.59.212]:48176
	"EHLO qmta14.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbaICSov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 14:44:51 -0400
In-reply-to: <Pine.LNX.4.44L0.1408301710120.4299-100000@netrider.rowland.org>
	(stern@rowland.harvard.edu)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

> From: Alan Stern <stern@rowland.harvard.edu>
> 
> On Fri, 29 Aug 2014, Matthew Dharm wrote:
> > Is there an 'easy' way to override the detected size of a storage
> > device from userspace?  If we had that, someone could write a helper
> > application which looked for this particular fubar and try to Do The
> > Right Thing(tm), or at least offer the user some options.
> 
> You mean, force a Media Change event and override the capacity reported 
> by the hardware?  I'm not aware of any API for doing that, although it 
> probably wouldn't be too hard to add one.
> 
> How would the user know what value to put in for the capacity?  Unless 
> the drive had been hooked up to a different computer and the user 
> manually noted the correct capacity and typed it in, it would have to 
> be guesswork.

The value would most sanely be extracted from the partition table.
(After verifying that the partition table looks correct.)  That seems
to be what Windows does, and it seems to work consistently enough for
Windows to trust that method.  Or at least, it could take the disk
size to be the end of the last partition, which would at least make
all the partitions accessible.

As somebody else hinted at, the userspace program could check the USB
device against a list of device types known to have this problem.

It could even verify that the SCSI-reported size matches the size
reported by the partition table (modulo two-to-the-whatever) (at least
for GPT tables, I don't know if MBR tables report the disk size).

Do we have any way of knowing what algorithm Windows uses in this
situation?

Dale
