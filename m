From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: new kernel oops in recent kernels
Date: Sun, 16 Mar 2008 22:41:42 -0600
Message-ID: <20080317044142.GC26285@parisc-linux.org>
References: <1205680748.3050.29.camel@localhost> <20080316164223.GA26285@parisc-linux.org> <1205692147.5470.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40016 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYCQEl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 00:41:58 -0400
Content-Disposition: inline
In-Reply-To: <1205692147.5470.3.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 16, 2008 at 07:29:07PM +0100, Giuseppe Sacco wrote:
> > > [<ffffffff802460b0>] sr_drive_status+0x50/0xe8
> > > [<ffffffff8024bb84>] cdrom_ioctl+0x5f4/0x1208
> > > [<ffffffff80245c6c>] sr_block_ioctl+0x64/0xe8
> > 

> 0xffffffff802460a4 <sr_drive_status+68>:	daddiu	sp,sp,32
> 0xffffffff802460a8 <sr_drive_status+72>:	jal	0xffffffff8024c838 <cdrom_get_media_event>
> 0xffffffff802460ac <sr_drive_status+76>:	move	a1,sp
> 0xffffffff802460b0 <sr_drive_status+80>:	bnez	v0,0xffffffff802460fc <sr_drive_status+156>

I think I was confused earlier.  156 is 0x9c, thus within the function.
The backtrace must be incorrect; this is really 0x48 and thus a call to
cdrom_get_media_event, which points the finger at
cdi->ops->generic_packet being NULL.

Put a BUG_ON(!cdi->ops->generic_packet) in drivers/cdrom/cdrom.c right
before the line that calls it (ie line 11 of cdrom_get_media_event).
That should trigger and give a better backtrace.  Then it's a simple (*)
matter of figuring out why it's NULL.

* This is sarcasm.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
