From: Mark Lord <lkml@rtr.ca>
Subject: Re: SATA suspend/resume (was Re: [PATCH] updated version of Jens'
 SATA suspend-to-ram patch)
Date: Sat, 01 Oct 2005 14:24:12 -0400
Message-ID: <433ED44C.3060805@rtr.ca>
References: <20050923163334.GA13567@triplehelix.org> <433B79D8.9080305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750780AbVJASYa@vger.kernel.org>
In-Reply-To: <433B79D8.9080305@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Joshua Kwan <joshk@triplehelix.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de, torvalds@osdl.org, randy_dunlap <rdunlap@xenotime.net>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
..
> Ah hah!  I found the other SCSI suspend patch:
>     http://lwn.net/Articles/97453/
> Anybody (Joshua?) up for reconciling and testing the two?

I just now tried out *only* "the other SCSI suspend patch",
and by itself it hangs on resume.  Laptop computer, blank screen,
no serial ports, no printk()s visible.

And there's one minor bug in that patch:  it uses GFP_KERNEL to
alloc a buffer, but on resume it really should use GFP_ATOMIC instead,
since the swap device is the same drive we're trying to resume..

> 2) sd should call START STOP UNIT on resume

That's probably why it hangs when used as-is by itself.
I may do some further testing.

Anyone else out there playing with this yet?
