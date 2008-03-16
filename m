From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: new kernel oops in recent kernels
Date: Sun, 16 Mar 2008 10:42:23 -0600
Message-ID: <20080316164223.GA26285@parisc-linux.org>
References: <1205680748.3050.29.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39008 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYCPQmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Mar 2008 12:42:39 -0400
Content-Disposition: inline
In-Reply-To: <1205680748.3050.29.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 16, 2008 at 04:19:08PM +0100, Giuseppe Sacco wrote:
> testing latest kernels on SGI O2, I found this new kernel oops. It has
> been produced with kernel from linux-mips.org git of yesterday night.
> A very similar oops has been reported by others[0] using 2.6.22.

> CPU 0 Unable to handle kernel paging request at virtual address 0000000000000000, epc == 0000000000000000, ra == 0000000000000000

I'm not familiar with MIPS; is epc the program counter?  If so, this
would be a branch to 0.  That's somewhat confusing as I don't see any
function pointers used within sr_drive_status().  How accurate are MIPS
backtraces?

> Call Trace:
> [<ffffffff802460b0>] sr_drive_status+0x50/0xe8
> [<ffffffff8024bb84>] cdrom_ioctl+0x5f4/0x1208
> [<ffffffff80245c6c>] sr_block_ioctl+0x64/0xe8

It would be interesting to see a disassembly (objdump -dr
drivers/scsi/sr_ioctl.o) of sr_drive_status from say 0x40 to 0x60.

And if that calls a function, it would be interesting to put in printks
to figure out where we're dereferencing a null pointer.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
