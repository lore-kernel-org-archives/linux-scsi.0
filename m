From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: atomic_kmap for PIO (was Re: Fw: Kernel panic with dc395x in 2.6.12.2)
Date: Sun, 7 Aug 2005 22:49:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0508072214240.7539@poirot.grange>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
 <Pine.LNX.4.60.0507132312050.8774@poirot.grange> <42E03506.7030707@drzeus.cx>
 <20050721235348.05eace11.rdunlap@xenotime.net> <20050722135055.6cb4597d.rdunlap@xenotime.net>
 <42E17451.6090706@drzeus.cx> <20050722153651.28d5db51.rdunlap@xenotime.net>
 <42E17772.3020903@drzeus.cx> <20050723100945.7d43d063.rdunlap@xenotime.net>
 <42E2933C.4050808@drzeus.cx> <20050723152714.4212ba52.rdunlap@xenotime.net>
 <42E2ECF1.8070501@drzeus.cx> <20050723184014.49629f9e.rdunlap@xenotime.net>
 <42E39462.3040007@drzeus.cx> <20050724100153.3e891484.rdunlap@xenotime.net>
 <42E565FE.4070708@drzeus.cx> <20050725203133.3cfa650d.rdunlap@xenotime.net>
 <42E6A5C3.6070501@drzeus.cx> <20050726202058.133382c1.rdunlap@xenotime.net>
 <42E964CC.5060600@drzeus.cx> <20050728201339.216ab3b8.rdunlap@xenotime.net>
 <42F37893.30006@drzeus.cx> <Pine.LNX.4.60.05080700
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39808 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1752713AbVHGUtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 16:49:33 -0400
In-Reply-To: <42F5FCBF.7080902@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, oliver@neukum.name, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Jamie Lenehan <lenehan@twibble.org>

Hi all

A problem has first been reported in

Date: Thu, 6 Jan 2005 05:18:25 -0500
From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: dc395x: can't write to tape

whereby a bug has become apparent in driver's virtual address calculation. 
I wrote a patch, which propagated into the mainline, before Jens A. 
(added to CC:) noticed, that it was buggy. Now Pierre actually hit that 
bug. Yesterday in 

http://marc.theaimsgroup.com/?l=linux-scsi&m=112336777508938&w=2

I sent him and to the SCSI list a patch, which made his system again 
usable. Which doesn't mean, however, that the patch is correct. The patch 
uses the same 2 functions that I used earlier in a proposed in 

http://marc.theaimsgroup.com/?l=linux-scsi&m=111435313619444&w=2

patch to tmscsim:

static void *dc395x_kmap_atomic_sg(struct scatterlist *sg, int sg_count, 
size_t *offset, size_t *len)

and

static void dc395x_kunmap_atomic_sg(void *virt)

to atomically map and unmap a byte sequence from an sg. This has also been 
discussed around April this year in a thread with subject: "Re: [PATCH] 
dc395x: Fix support for highmem." That discussion didn't come to a 
definite conclusion. As well as my patch to tmscsim didn't produce any 
reaction, and, I think, wasn't included in any "official" tree.

Now, it would be best, I think, if somebody could review the patches to 
dc395x and tmscsim. In case the 2 functions are correct, they could be 
included in a central file (scsi_lib?) for all drivers, needing PIO (I 
think IDE and libata won't be able to use them in this form). The rest of 
the 2 patches could then be applied to respective drivers.

Thanks
Guennadi

On Sun, 7 Aug 2005, Pierre Ossman wrote:

> Guennadi Liakhovetski wrote:
> 
> >So, now that we have somebody to test alternative patches, let's try it... 
> >Please, first revert the first patch (apply with -R), and then apply the 
> >second one. There, probably, will be offsets, don't worry about them. 
> >Warning: untested. Please, try some read-only test first, if you get so 
> >far at all... I prepared this patch a long time ago, and didn't revisit it 
> >since then, hope, it's still fresh enough:-)
> >  
> >
> 
> Ok, I've tried the included patches now and everything seems to work
> fine. Note though that I only have a CD writer hooked up to the
> controller, no disks.
> 
> Anything special I should try to make sure the patch does what it's
> supposed to?
> 
> Rgds
> Pierre
> 

---
Guennadi Liakhovetski
