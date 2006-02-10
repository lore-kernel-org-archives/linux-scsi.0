From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI BLIST_*, sdev_bflags, and scsi_device flags
Date: Thu, 9 Feb 2006 16:17:30 -0800
Message-ID: <20060210001730.GA4865@us.ibm.com>
References: <Pine.LNX.4.44L0.0602091438550.5532-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48793 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750860AbWBJARh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 19:17:37 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1A0Hbgi010416
	for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2006 19:17:37 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1A0FU47272200
	for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2006 17:15:30 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k1A0HaqD012330
	for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2006 17:17:36 -0700
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0602091438550.5532-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Feb 09, 2006 at 02:55:15PM -0500, Alan Stern wrote:
> A fair number of SCSI BLIST bits have duplicate entries in the scsi_device 
> structure (in one instance the meaning is inverted):
> 
> BLIST_BORKEN			borken
> BLIST_SINGLELUN			single_lun
> BLIST_USE_10_BYTE_MS		use_10_for_ms
> BLIST_MS_SKIP_PAGE_08		skip_ms_page_8
> BLIST_MS_SKIP_PAGE_3F		skip_ms_page_3f
> BLIST_MS_192_BYTES_FOR_3F	use_192_bytes_for_3f
> BLIST_RETRY_HWERROR		retry_hwerror
> BLIST_NOT_LOCKABLE		lockable
> BLIST_NOSTARTONADD		no_start_on_add
> 
> There's no good reason for this duplication.  It's largely historical; at 
> the time the device flags were added there was no way to alter the bflags 
> value.  Now there is, since sdev_bflags is stored in the scsi_device.
> 
> Should we keep this duplication?  Should we remove the device bits and use
> the sdev_bflags bitmasks instead?  I presume we don't want to remove the
> BLIST entries because they are visible to userspace.  (Although probably
> some of them are not used anywhere at all.)

I'd like to see the bit fields replaced by sdev_flags masks. Best with a
macro or macros. I don't see why you would get rid of the BLIST_NNN fields
even ignoring user space and devinfo, as you can use them as the mask
values.

Higher level macros would be easier to replace if we ever move the flags
into the starget or such.

I mean if we have:

#define scsi_nostartonadd(sdev)	(sdev->sdev_bflags & BLIST_NOSTARTONADD)

Used as:

	if (scsi_nostartonadd(sdev))
		...

It can easily be changed in the future to:

#define scsi_nostartonadd(sdev)	\
	(sdev->sdev_target->starget_bflags & BLIST_NOSTARTONADD)

> What about things like BLIST_REPORTLUN2 and BLIST_NOREPORTLUN?  They don't
> mean anything for scsi_devices, only for scsi_targets.  Nevertheless they
> are part of the same BLIST entries.  Again, I don't see any way around
> that without affecting userspace.

A lot of the values are really per target, maybe all of them, plus we
have those bit fields that are set by the host driver (or transport).
And the devinfo code treats them as per vendor + product.

IMO store them all in sdev_bflags for now.

For a given target is it allowed per standard, or does hardware exist that
returns a different vendor and product for different LU's?

I don't see anything looking at the SPC 3 for INQUIRY.

It doesn't make much sense to me, but then there are some crazy devices
out there.

-- Patrick Mansfield
