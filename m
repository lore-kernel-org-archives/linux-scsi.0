From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH as494] Add a scsi_device flag for RETRY_HWERROR
Date: Fri, 25 Mar 2005 10:37:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0503251027070.1130-100000@ida.rowland.org>
References: <4243498D.6070409@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:3332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261671AbVCYPhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 10:37:53 -0500
In-Reply-To: <4243498D.6070409@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 25 Mar 2005, Douglas Gilbert wrote:

> Alan Stern wrote:
> > James:
> > 
> > It turns out that a bunch of USB-IDE converters make the mistake of
> > returning SK = 04 (Hardware Error) whenever the IDE device signals any
> > sort of error, without bothering to distinguish recoverable from
> > non-recoverable errors. 
> 
> Alan,
> The sense key of HARDWARE ERROR is a superset of MEDIUM ERROR.
> SBC-2 treats them as synonymous. If it is a "real" medium
> error then the LBA of the first (i.e. lowest address) bad
> block should be placed in the "info" field and the "valid"
> bit should be set. If this is done the block layer does
> its job well.

I don't have a copy of SBC-2.  The (very old) document I do have and the 
code in scsi_error.c both treat HARDWARE_ERROR as nonrecoverable and 
MEDIUM_ERROR as recoverable.  So in a sense the patch does go some way 
towards treating one as a superset of the other.

Were the errors in question "real" medium errors?  I don't know -- maybe 
not.  There wasn't much information available.

> Also for both hardware and medium errors the "sense key
> specific" field (if SKSV=1) reports the actual retry
> count. The read/write retry count is set in the "read
> write error recovery" mode page. Anyways if the disk
> has already retried reading the bad block 64 times (say)
> what is the point of the mid level retrying??

For the devices I've had to deal with, it's not obvious that the disk has
already retried 64 times.  (And the error-recovery mode page may not exist
either; remember these are slightly buggy USB adaptors trying to pretend
that an IDE drive is a SCSI device.)  All I know for certain is that the
first time the command was issued the we got back HARDWARE_ERROR and then
on a retry the command succeeded.

(The IBM drive that started this whole thing is a different story.  But 
regardless, it's clear that having these patches helps with some devices 
and doesn't hurt others.)

Alan Stern

