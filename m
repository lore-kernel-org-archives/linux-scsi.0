From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Getting TRIM working
Date: Mon, 9 Mar 2009 08:14:51 -0600
Message-ID: <20090309141451.GS25995@parisc-linux.org>
References: <20090303190700.GD20511@parisc-linux.org> <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org> <49B39DCB.3040203@panasas.com> <1236547480.4861.12.camel@localhost.localdomain> <1236547956.4861.17.camel@localhost.localdomain> <20090309083614.GP25995@parisc-linux.org> <1236607495.3318.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1236607495.3318.5.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 09, 2009 at 02:04:55PM +0000, James Bottomley wrote:
> > Disadvantages:
> >  - UNMAP gets less testing
> 
> Also disadvantages: UNMAP will not work unless trim is pulled back out
> of libata again ... which makes this look a bit like a temporary hack.

Huh?  sd.c will continue to have sd_discard_fn() which will work fine
for UNMAP.  This will give us a different path for ATA discs and SCSI
discs, as far as discard functions go.

> As I've said before, I don't like the bio based approach.  I think you
> leak a page on every trim command doing it (why?  because the kernel
> mapped bios have special bio->end_io routines to collect and free the
> pages, you have no such routine).

I added that in an earlier patch:

http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=commitdiff;h=f6ebf54cb8045a0cab19d73e26a07945c29d1394;hp=1223b373ae0283221b46e70955eb825679c5a6cb

I'm all in favour of a less messy approach than using bios directly, if
there is one.  I don't see what it might look like yet.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
