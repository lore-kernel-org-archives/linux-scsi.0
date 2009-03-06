From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 6 Mar 2009 18:27:21 +0900
Message-ID: <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
References: <20090306085529.GP11787@kernel.dk>
	<20090306181302X.fujita.tomonori@lab.ntt.co.jp>
	<20090306092114.GS11787@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36587 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZCFJcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Mar 2009 04:32:02 -0500
In-Reply-To: <20090306092114.GS11787@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org, mike.miller@hp.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Fri, 6 Mar 2009 10:21:14 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Mar 06 2009, FUJITA Tomonori wrote:
> > On Fri, 6 Mar 2009 09:55:29 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > > If it's settable at init time, that would probably be enough for
> > > > the vast majority of uses (and more flexible than what we have now)
> > > > and a lot easier to implement.
> > > 
> > > Completely agree, don't waste time implementing something that nobody
> > > will ever touch. The only reason to fiddle with such a setting would be
> > > to increase it, because ios are too small. And even finding out that the
> > > segment limit is the one killing you would take some insight and work
> > > from the user.
> > > 
> > > Just make it Big Enough to cover most cases. 32 is definitely small, 256
> > > entries would get you 1MB ios which I guess is more appropriate.
> > 
> > I guess that the dynamic scheme is overdoing but seems that vendors
> > like some way to configure the sg entry size. The new MPT2SAS driver
> > has SCSI_MPT2SAS_MAX_SGE kernel config option:
> > 
> > http://marc.info/?l=linux-scsi&m=123619290803547&w=2
> > 
> > 
> > The kernel module option for this might be appropriate.
> 
> Dunno, still seems pretty pointless to me. The config option there
> quotes memory consumption as the reason to reduce the number of sg
> entries, however I think that's pretty silly. Additionally, a kernel
> config entry just means that customers will be stuck with a fixed value
> anyway. So I just don't see any merit to doing it that way either.

Yeah, agreed. the kernel config option is pretty pointless. But I'm
not sure that reducing memory consumption is completely pointless.
