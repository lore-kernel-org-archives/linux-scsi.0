From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Getting TRIM working
Date: Mon, 09 Mar 2009 14:04:55 +0000
Message-ID: <1236607495.3318.5.camel@localhost.localdomain>
References: <20090303190700.GD20511@parisc-linux.org>
	 <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org>
	 <49B39DCB.3040203@panasas.com>
	 <1236547480.4861.12.camel@localhost.localdomain>
	 <1236547956.4861.17.camel@localhost.localdomain>
	 <20090309083614.GP25995@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090309083614.GP25995@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2009-03-09 at 02:36 -0600, Matthew Wilcox wrote:
> On Sun, Mar 08, 2009 at 04:32:36PM -0500, James Bottomley wrote:
> > Actually, found the reason, blk_rq_map_kern will blast the original bio
> > from the request.  You could fix this by chaining it back again at the
> > beginning.  If that works, we could just wrap it into a block API to
> > prevent users from having to muck with bios.
> 
> How about constructing the TRIM entirely within libata?  I won't be able
> to test this patch until Oregon wakes up, but is this acceptable?
> 
> Advantages:
>  - Don't need to wait for T10 to finish designing UNMAP
>  - Uses well-tested ATA_16 passthrough layer
>  - Changing the UNMAP implementation to do multiple ranges won't break TRIM
>  - Will be easier to adapt to a future separation of scsi and libata
> 
> Disadvantages:
>  - UNMAP gets less testing

Also disadvantages: UNMAP will not work unless trim is pulled back out
of libata again ... which makes this look a bit like a temporary hack.
If we're going to get this working, we might as well do the job
properly.  Even if we don't quite know what UNMAP looks like, all we
need is for the SAT to work on our approximation.

As I've said before, I don't like the bio based approach.  I think you
leak a page on every trim command doing it (why?  because the kernel
mapped bios have special bio->end_io routines to collect and free the
pages, you have no such routine).

I think this is also a reflection of the fact that our discard structure
isn't quite complete in practice.  We need some sort of tear down to
allow us to free the allocated parameter list for the command.

James


