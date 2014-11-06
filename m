From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large disk drives
Date: Thu, 06 Nov 2014 16:54:18 +0100
Message-ID: <1415289258.10617.4.camel@jarvis.quadriga.com>
References: <1415203668.13212.2.camel@jarvis>
		 <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>
		 <20141105193045.GA13265@infradead.org>
	 <1415269814.29907.19.camel@jarvis.quadriga.com>
	 <545B86AC.3080704@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47325 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaKFPyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 10:54:24 -0500
In-Reply-To: <545B86AC.3080704@plexistor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, "Dale R. Worley" <worley@alum.mit.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Thu, 2014-11-06 at 16:33 +0200, Boaz Harrosh wrote:
> On 11/06/2014 12:30 PM, James Bottomley wrote:
> > On Wed, 2014-11-05 at 11:30 -0800, Christoph Hellwig wrote:
> >> On Wed, Nov 05, 2014 at 11:34:11AM -0500, Alan Stern wrote:
> >>>> Sorry, meant to.  In principle I'm OK with this as the lever for the
> >>>> hack (largely because it means we don't need to do anything) but will
> >>>> the distributions support it?
> >>>
> >>> While I can't speak for the distributions, it's reasonable to assume 
> >>> that if something becomes part of the upstream kernel then they will 
> >>> include it.
> >>
> >> Btw, we do have precedence for looking at partition tables from SCSI
> >> code with scsi_partsize(), so the layering violation of looking at
> >> EFI labels for disks sizes wouldn't be something entirely new even
> >> if we did it in kernel space.
> > 
> > We really don't want to make the decision within the kernel of whether
> > we believe the partition size or the disk capacity.   For these disk
> > problems we need it to be the former, but if we choose that always,
> > we'll get weird results on mispartitioned devices.
> > 
> > The usual rule is no policy in the kernel and which to choose is policy,
> > so just export the knob (as Alan's patch does) and then let userspace
> > decide.
> > 
> 
> I do not think it is a matter of policy.
> 
> From what I understand the situation is that read_capacity_10() which is
> 32bit, Max 2T byte disks. fails with 0xffffffff and read_capacity_16() (64bit)
> is not supported because of wrong scsi-version or because it is blacklisted.
> (or device returns not-supported)

Actually, no, RC(10) returns the lowest 32 bits of the actual result.
Which is out of spec, but hey, this is a USB bridge ...

> Now If sd_read_capacity() succeed then off-course we choose it.

Um, the problem is we can't tell ... sd_read_capacity() returns a
number, it just may be wrong by a factor of 2TB.

>  What I'm saying
> is if read-capacity fails, then should we attempt a new read_capacity_part()?

We can't tell we have a failure.  We can tell if the partition capacity
and the read capacity differ that one of them must be wrong ...

> And sure a user-mode knob if he wants to make policy, like you said, is fine
> by me.
> 
> But just the simple case of read-capacity failure should we then?

We don't have a failure.  This is the problem.  Determining that a
problem exists 

James


