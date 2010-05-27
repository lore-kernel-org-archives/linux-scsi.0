From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 16058] New: [BUG] Cannot boot any kernel from
 2.6.27 on if a 256 byte sector SCSI disk is attached
Date: Thu, 27 May 2010 16:30:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1005271626320.3239-100000@iolanthe.rowland.org>
References: <20100527100752.c12d8e2e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41469 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751905Ab0E0Uaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:30:39 -0400
In-Reply-To: <20100527100752.c12d8e2e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markh@compro.net
Cc: SCSI development list <linux-scsi@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org

On Thu, 27 May 2010, Andrew Morton wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=16058
> 
>            Summary: [BUG] Cannot boot any kernel from 2.6.27 on if a 256
>                     byte sector SCSI disk is attached

> As of 2.6.27 if any SCSI disk is attached that has been formatted with a 256
> byte sector size, the boot process hangs. 512, 768, and 1024 byte sector disks
> do not seem to trigger this. The disks in use do NOT have a partition table.
> They are being used by out applications via the sg_io interface only.
> 
> A 2.6.26.8 kernel works fine. 
> 
> I have bisected this problem to the following commit:
> 
> # git bisect good
> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
> commit 427e59f09fdba387547106de7bab980b7fff77be
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Mar 8 18:24:17 2008 -0600
> 
>     [SCSI] make use of the residue value
> 
>     USB sometimes doesn't return an error but instead returns a residue
>     value indicating part (or all) of the command wasn't completed.  So if
>     the driver _done() error processing indicates the command was fully
>     processed, subtract off the residue so that this USB error gets
>     propagated.
> 
>     Cc: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd
> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
> 
> Now, what USB has to do with my SCSI disks is beyond me. I have a
> feeling that this commit is just uncovering another problem. I've attached
> a bootlog from a serial console that ends where the boot hangs.
> 
> The does the same thing on a 2.6.34 kernel. Anything I can do to help, I'm
> available.

I'd guess that this has nothing to do with the sector size.  Instead
the drive probably reports a non-zero residue when it shouldn't.  Can
you add some debugging printk's to the patch to find out in more detail
what's going wrong?

Alan Stern

