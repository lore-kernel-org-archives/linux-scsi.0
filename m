From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 16:59:00 +0200
Message-ID: <20080716145900.GA31258@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain> <20080716141805.GB22631@elte.hu> <20080716144106.GD25255@parisc-linux.org> <20080716144602.GB4369@elte.hu> <20080716145703.GF25255@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760220AbYGPO7e@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080716145703.GF25255@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jul 16, 2008 at 04:46:02PM +0200, Ingo Molnar wrote:
> > yeah, that's OK - but why is scsi.h #ifdef-ed? For example we can 
> > include blkdev.h without #ifdef CONFIG_BLOCK.
> 
> Sure.  The important bit comes when deciding which bits need to be 
> available when CONFIG_BLOCK isn't set.  Obviously, there is no SCSI 
> without block (while sg is a character device, not a block device, it 
> depends on the block infrastructure to the extent that you couldn't 
> use it without CONFIG_BLOCK).
> 
> While it's not impossible that someone could want the SCSI protocol 
> and opcodes, status codes, etc. for a different character device, that 
> seems unlikely.  The four opcodes defined in the header seem to be 
> pretty SCSI-specific and not useful to use on non-scsi devices. 
> SCSI_IOCTL_GET_PCI looks like it might possibly be useful on more than 
> just SCSI, but we have better ways (ie sysfs) of determining the same 
> information in a more general way.
> 
> So I think it's fair to put an #ifdef CONFIG_BLOCK right after the 
> _SCSI_SCSI_H define and close it right at the end of the file.

yes, that's what blkdev.h does, and that's what i was suggesting we do, 
instead of #ifdef-ing around scsi.h use in fs/compat_ioctl.c.

	Ingo
