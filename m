From: Jens Axboe <axboe@suse.de>
Subject: Re: Write cache on SATA drives?
Date: Sat, 2 Jul 2005 09:07:55 +0200
Message-ID: <20050702070750.GL2243@suse.de>
References: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com> <20050701062416.GQ2243@suse.de> <m3acl7ym7f.fsf@merlin.emma.line.org> <20050701083308.GZ2243@suse.de> <20050701084717.GA18306@merlin.emma.line.org> <20050701085412.GA2243@suse.de> <m38y0qnlt7.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:41652 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261827AbVGBHG2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2005 03:06:28 -0400
Content-Disposition: inline
In-Reply-To: <m38y0qnlt7.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: "Edwards, Scott (GE Healthcare)" <J.Scott.Edwards@ge.com>, linux-scsi@vger.kernel.org

On Sat, Jul 02 2005, Matthias Andree wrote:
> Jens Axboe <axboe@suse.de> writes:
> 
> >> I'm not acquainted with kernel/block I/O queueing internals.
> >
> > SCSI without TCQ or with TCQ depth=1 should be safe, provided the driver
> > never reorders a command once it has received it.
> 
> Wouldn't we rather use *deep* TCQ and set write cache enable to 0 then?

Depends, if you can't use ordered tags it wont help you.

> Does anybody have benchmarks with TCQ depth = 1/WCE = 1 vs. TCQ = <deep>
> (64+)/WCE = 0? I only have ancient SCSI drives in test machines, so my
> testing wouldn't be representative.

I posted some for NCQ, see lkml/linux-ide.

> >> > > 2. for traditional IDE (such as VIA 82*, PIIX_*)?
> >> > 
> >> > In SUSE kernels, for many years. Since 2.6.7/8'ish in Linus' kernels.
> >> 
> >> I don't care for vendor kernels. Is listing 2.6.8 safe?
> >
> > Check the changelogs, I can't remember exactly if it was 2.6.7 or 2.6.8
> > (or perhaps .6...).
> 
> Hm. Any buzz^Wkeywords to look for? "barrier" doesn't seem to be the
> right word, it yields only memory barriers and an as-iosched fix in
> 2.6.7.  I checked ChangeLog-2.6.[56789].

Grep for blk_queue_ordered or similar in the patch.

-- 
Jens Axboe

