From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large   IO sg-chaining
Date: Wed, 8 Aug 2007 09:16:45 +0200
Message-ID: <20070808071644.GK5245@kernel.dk>
References: <46AF97AA.5000908@panasas.com> <20070806162205P.fujita.tomonori@lab.ntt.co.jp> <20070807065549.GR5245@kernel.dk> <20070807173619J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2810 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765200AbXHHHQs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Aug 2007 03:16:48 -0400
Content-Disposition: inline
In-Reply-To: <20070807173619J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, bhalevy@panasas.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Tue, Aug 07 2007, FUJITA Tomonori wrote:
> On Tue, 7 Aug 2007 08:55:49 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, Aug 06 2007, FUJITA Tomonori wrote:
> > > On Tue, 31 Jul 2007 23:12:26 +0300
> > > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > > 
> > > > The tested Kernels:
> > > > 
> > > > 1. Jens's sglist-arch
> > > >   I was not able to pass all tests with this Kernel. For some reason when
> > > >   bigger than 256 pages commands are queued the Machine will run out
> > > >   of memory and will kill the test. After the test is killed the system
> > > >   is left with 10M of memory and can hardly reboot.
> > > >   I have done some prints at the queuecommand entry in scsi_debug.c
> > > >   and I can see that I receive the expected large sg_count and bufflen
> > > >   but unlike other tests I get a different pointer at scsi_sglist().
> > > >   In other tests since nothing is happening at this machine while in
> > > >   the test, the sglist pointer is always the same. commands comes in,
> > > >   allocates memory, do nothing in scsi_debug, freed, and returns. 
> > > >   I suspect sglist leak or allocation bug.
> > > 
> > > Ok, I found the leak.
> > > 
> > > 
> > > From 011c05c2e514d1db4834147ed83526473711b0a3 Mon Sep 17 00:00:00 2001
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Date: Mon, 6 Aug 2007 16:16:24 +0900
> > > Subject: [PATCH] fix sg chaining leak
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  drivers/scsi/scsi_lib.c |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 5884b1b..25988b9 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -48,7 +48,6 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
> > >  	SP(32),
> > >  	SP(64),
> > >  	SP(128),
> > > -	SP(256),
> > >  };
> > >  #undef SP
> > 
> > Thanks Tomo! Trying to catch up with mails, will apply this one right
> > away.
> 
> You can add the following patch to your sglist branches:
> 
> 
> From abd73c05d5f08ee307776150e1deecac7a709b60 Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <tomof@acm.org>
> Date: Mon, 30 Jul 2007 23:01:32 +0900
> Subject: [PATCH] zfcp: sg chaining support

Thanks, applied!

-- 
Jens Axboe

