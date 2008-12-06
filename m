From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 15:51:08 +0100
Message-ID: <200812061551.08525.bzolnier@gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <20081203100643.GA29340@infradead.org> <1228316941.5551.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:54459 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYLFOyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Dec 2008 09:54:43 -0500
Received: by mu-out-0910.google.com with SMTP id g7so409333muf.1
        for <linux-scsi@vger.kernel.org>; Sat, 06 Dec 2008 06:54:41 -0800 (PST)
In-Reply-To: <1228316941.5551.6.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

On Wednesday 03 December 2008, James Bottomley wrote:
> On Wed, 2008-12-03 at 05:06 -0500, Christoph Hellwig wrote:
> > On Wed, Dec 03, 2008 at 10:38:54AM +0900, FUJITA Tomonori wrote:
> > > This is for 2.6.29 (not 2.6.28) as feature-removal-schedule.txt says.
> > > 
> > > It's against linux-next (which seems to has some changes to ide-scsi
> > > for 2.6.29 from the ide tree). 
> > 
> > Isn't ide-scsi the only way to use ATAPI OnStream tapes supported by
> > the osst driver?
> 
> Depends.  If you're still using drivers/ide then yes, it is.  With
> libata (which is what most modern distros use), osst just works as an
> ATAPI transport.
> 
> git log tells me ide-scsi has been updated quite a bit recently, but it
> mostly looks to be fallout around the drivers/ide churn.  Can we get ide
> maintainer's buy in for this (I think they've been maintaining ide-tape
> and ide-cd in preference to ide-scsi)?

Certainly, native ide-{cd,gd,tape} drivers are far superior over ide-scsi
and are actively maintained.

ide-scsi has been practically a dead code for a long time now (IIRC it has
even been broken -- by some general kernel changes -- for few releases and
nobody noticed, till Boaz discovered it while doing unrelated SCSI fixes)
but I kept it on the live support anyway.  However there needs to be some
limit to it, especially given that driver has been officially orphaned for
over a year now and nobody stepped in...

I applied the scheduled removal patch to pata-2.6 tree, thanks Tomo!

Thanks,
Bart

PS If somebody wants to work on OSST support for IDE we can provide an
assistance into porting osst.c over generic ATAPI code -- it would still
be much less hassle than trying to figure out remaining ide-scsi issues
(lifetime rules for IDE / SCSI / IDE-SCSI objects, error handling etc.).
