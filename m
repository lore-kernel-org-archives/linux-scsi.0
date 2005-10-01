From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: SATA suspend/resume (was Re: [PATCH] updated version of Jens'
 SATA suspend-to-ram patch)
Date: Sat, 1 Oct 2005 11:39:06 -0700
Message-ID: <20051001113906.2105f152.rdunlap@xenotime.net>
References: <20050923163334.GA13567@triplehelix.org>
	<433B79D8.9080305@pobox.com>
	<433ED44C.3060805@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:17376 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750819AbVJASjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2005 14:39:08 -0400
Received: from midway ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sat, 1 Oct 2005 11:39:08 -0700
In-Reply-To: <433ED44C.3060805@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: jgarzik@pobox.com, joshk@triplehelix.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de, torvalds@osdl.org

On Sat, 01 Oct 2005 14:24:12 -0400 Mark Lord wrote:

> Jeff Garzik wrote:
> ..
> > Ah hah!  I found the other SCSI suspend patch:
> >     http://lwn.net/Articles/97453/
> > Anybody (Joshua?) up for reconciling and testing the two?
> 
> I just now tried out *only* "the other SCSI suspend patch",
> and by itself it hangs on resume.  Laptop computer, blank screen,
> no serial ports, no printk()s visible.
> 
> And there's one minor bug in that patch:  it uses GFP_KERNEL to
> alloc a buffer, but on resume it really should use GFP_ATOMIC instead,
> since the swap device is the same drive we're trying to resume..
> 
> > 2) sd should call START STOP UNIT on resume
> 
> That's probably why it hangs when used as-is by itself.
> I may do some further testing.
> 
> Anyone else out there playing with this yet?

Not playing with it yet, just making some changes as suggested
by Jeff and Christoph.  Patches are in
  http://www.xenotime.net/linux/scsi/

1.  http://www.xenotime.net/linux/scsi/scsi-suspend-resume.patch
2.  http://www.xenotime.net/linux/scsi/scsi-susres-startstop2.patch

and work-in-progress:  adding <spindown> ok/allowed to scsi
targets:  http://www.xenotime.net/linux/scsi/scsi-susres-stst-spin.patch
(this patch file includes 1. and 2. above)

---
~Randy
