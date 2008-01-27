From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Sun, 27 Jan 2008 12:13:46 -0600
Message-ID: <1201457626.3746.21.camel@localhost.localdomain>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
	 <479727D5.8060901@garzik.org>
	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
	 <1201300769.3119.78.camel@localhost.localdomain>
	 <20080127152733.GC21302@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33338 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbYA0SNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jan 2008 13:13:54 -0500
In-Reply-To: <20080127152733.GC21302@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, kewei@marvell.com

On Sun, 2008-01-27 at 23:27 +0800, Ke Wei wrote:
> > I really don't think you should be doing this.  That single ring governs
> > all the potential tag slots for everything in this device.  If you do a
> > simple head tail allocation, what can happen is that you get a slow tag
> > (attached to a format command, or a tape command) and then the ring head
> > will hit the slow tag and the entire device will halt.  I think you need
> > a bitmap based allocation algorithm to ensure that if you have a free
> > tag anywhere, you'll use it.
> > 
> > If you look at the aic94xx index functions in aic94xx_hwi.h you'll see
> > asd_tc_index_get() and asd_tc_index_release() doing exactly what you
> > want with the native linux bitmap functions (the aic also uses a single
> > issue queue with indexes into it).
> 
> I don't think we need to make use of a bitmap based allocation
> algorithm.
> My algorithm is a simple non-blocking scheduling. Some faster tag may
> be free in advance, so ring will alloc a tag number which has been
> stored in mvi->tags array instead of waiting to hit the slow tag. 

Ah, sorry I didn't see you were actually shuffling entries in the tag
array ... 

> I think that the bitmap based allocation algorithm try to poll and
> find
> the first zero bit. So process may be slow. 
> 
> pls point out anything wrong.

I think you'll find a bitmap based algorithm can be much faster.  The
linux bitmap routines are optimally coded on most architectures (large
numbers actually have a find bit in word/long word instruction).  Even
for a nearly full bitmap, a 512bit array can find the free tag in at
most sixteen machine instructions; if the array is sparse, it can do it
in about two.  Plus a bitmap based scheme has the advantage of tending
to allocate hot tags, thus usually keeping reasonable hot cache reuse.

A ring based algorithm will effectively do levelling to ensure that
every tag is used just about equally, which actually promotes pessimal
hot cache reuse.

Whether cache locality actually matters to the driver is something I
can't actually determine, so I'll leave it up to you to decide.

James


