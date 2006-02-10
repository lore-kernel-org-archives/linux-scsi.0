From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI BLIST_*, sdev_bflags, and scsi_device flags
Date: Thu, 9 Feb 2006 22:00:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602092150430.24417-100000@netrider.rowland.org>
References: <20060210001730.GA4865@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:5390 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1751023AbWBJDAx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 22:00:53 -0500
In-Reply-To: <20060210001730.GA4865@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 9 Feb 2006, Patrick Mansfield wrote:

> On Thu, Feb 09, 2006 at 02:55:15PM -0500, Alan Stern wrote:
> > A fair number of SCSI BLIST bits have duplicate entries in the scsi_device 
> > structure (in one instance the meaning is inverted):
> > 
> > BLIST_BORKEN			borken
> > BLIST_SINGLELUN			single_lun
> > BLIST_USE_10_BYTE_MS		use_10_for_ms
> > BLIST_MS_SKIP_PAGE_08		skip_ms_page_8
> > BLIST_MS_SKIP_PAGE_3F		skip_ms_page_3f
> > BLIST_MS_192_BYTES_FOR_3F	use_192_bytes_for_3f
> > BLIST_RETRY_HWERROR		retry_hwerror
> > BLIST_NOT_LOCKABLE		lockable
> > BLIST_NOSTARTONADD		no_start_on_add
> > 
> > There's no good reason for this duplication.  It's largely historical; at 
> > the time the device flags were added there was no way to alter the bflags 
> > value.  Now there is, since sdev_bflags is stored in the scsi_device.
> > 
> > Should we keep this duplication?  Should we remove the device bits and use
> > the sdev_bflags bitmasks instead?  I presume we don't want to remove the
> > BLIST entries because they are visible to userspace.  (Although probably
> > some of them are not used anywhere at all.)
> 
> I'd like to see the bit fields replaced by sdev_flags masks. Best with a
> macro or macros. I don't see why you would get rid of the BLIST_NNN fields
> even ignoring user space and devinfo, as you can use them as the mask
> values.
> 
> Higher level macros would be easier to replace if we ever move the flags
> into the starget or such.
> 
> I mean if we have:
> 
> #define scsi_nostartonadd(sdev)	(sdev->sdev_bflags & BLIST_NOSTARTONADD)
> 
> Used as:
> 
> 	if (scsi_nostartonadd(sdev))
> 		...
> 
> It can easily be changed in the future to:
> 
> #define scsi_nostartonadd(sdev)	\
> 	(sdev->sdev_target->starget_bflags & BLIST_NOSTARTONADD)

Makes sense.

> > What about things like BLIST_REPORTLUN2 and BLIST_NOREPORTLUN?  They don't
> > mean anything for scsi_devices, only for scsi_targets.  Nevertheless they
> > are part of the same BLIST entries.  Again, I don't see any way around
> > that without affecting userspace.
> 
> A lot of the values are really per target, maybe all of them, plus we
> have those bit fields that are set by the host driver (or transport).
> And the devinfo code treats them as per vendor + product.

Which BLIST bits exactly are per-target?  Obviously everything with LUN in
the name and probably the two INQUIRY flags.  Anything else?

> IMO store them all in sdev_bflags for now.

In fact, the sdev_bflags and the starget_bflags can be copies of each
other (subject to modification by the host adapter driver, of course).  I
think the accessors should be inline routines, so they can do
type-checking on the argument (scsi_device vs. scsi_target).

Do you mind if I don't bother to write setter routines?

> For a given target is it allowed per standard, or does hardware exist that
> returns a different vendor and product for different LU's?
> 
> I don't see anything looking at the SPC 3 for INQUIRY.
> 
> It doesn't make much sense to me, but then there are some crazy devices
> out there.

I don't know -- I've never heard of such a thing, but that doesn't mean 
much.

Alan Stern

