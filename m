From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] ncr53c8xx updates
Date: Mon, 7 Mar 2005 02:32:51 +0000
Message-ID: <20050307023251.GZ28741@parcelfarce.linux.theplanet.co.uk>
References: <20050306201153.GV28741@parcelfarce.linux.theplanet.co.uk> <20050307004015.GA7697@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:24473 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261726AbVCGCcw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 21:32:52 -0500
Content-Disposition: inline
In-Reply-To: <20050307004015.GA7697@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Mon, Mar 07, 2005 at 12:40:15AM +0000, Christoph Hellwig wrote:
> On Sun, Mar 06, 2005 at 08:11:53PM +0000, Matthew Wilcox wrote:
> > This isn't for applying so much as it is for showing people where I am
> > with this driver.  As with the sym2 driver, I commit each piece to the
> > parisc-linux CVS tree (since parisc is currently the only user of this
> > driver, it makes even more sense to do development there).
> 
> It's also used on i386/voyager (or in theory every MCA i386 system).

Thanks for reminding me; still the only person who cares about the Q720
also follows the parisc-linux-cvs list ;-)

> While we're at it, is there anyce chance to kill/rename sym53c8xx_defs.h
> and sym53c8xx_comm.h which are only ever used by the ncr53c8xx driver.
> 
> In fact I'd really love to see the driver organized similarly to the sym2
> driver - ncr53c8xx.c is too f***ing large for it's own sake.

I'm not particularly enamoured with the way sym2 is laid out.  Indeed,
I'm currently moving stuff around; mostly to reduce some of the function
spaghetti, but I'm aiming to turn sym_glue.c into sym_pci.c.  At that
point, it becomes much more plausible to write a sym_mca.c and sym_gsc.c,
and maybe we can get rid of the ncr53c8xx driver altogether.  

The sym2 main driver file isn't much smaller than ncr53c8xx.  Splitting
the firmware out of it would probably be the biggest benefit:

-rw-r--r--  1 willy willy  46652 Sep 27 21:41 sym_fw1.h
-rw-r--r--  1 willy willy 147620 Mar  4 15:19 sym_hipd.c

-rw-r--r--  1 willy willy 201778 Mar  2 16:53 ncr53c8xx.c

(the firmware embedded in the ncr53c8xx driver is approximately 40k in size).

One of the issues with trying to turn sym2 into the all-singing,
all-dancing 7xx,8xx,1010 driver is that there's two parisc models
(the 735 and 755) that have an ncr53c720 chip but don't support dma
coherent memory.  I'd really rather not have sym2 use the advanced magic
DMA APIs.  I'm also not looking forward to trying to make ncr53c8xx use
them either ...  maybe the right thing to do is teach ncr53c700 to drive
the 720 chip too?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
