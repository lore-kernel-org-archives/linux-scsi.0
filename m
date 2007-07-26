From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: 2.6.23-rc1-mm1: SCSI_SRP_ATTRS compile error
Date: Thu, 26 Jul 2007 19:49:20 +0900
Message-ID: <20070726194920K.fujita.tomonori@lab.ntt.co.jp>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<46A77C28.1050807@shadowen.org>
	<20070725180618.GE3572@stusta.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:35452 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXGZK6G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 06:58:06 -0400
In-Reply-To: <20070725180618.GE3572@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bunk@stusta.de
Cc: apw@shadowen.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, James.Bottomley@SteelEye.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, drfickle@us.ibm.com, mel@csn.ul.ie, linux-scsi@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.23-rc1-mm1: SCSI_SRP_ATTRS compile error
Date: Wed, 25 Jul 2007 20:06:18 +0200

> On Wed, Jul 25, 2007 at 05:36:56PM +0100, Andy Whitcroft wrote:
> > Of the machines we test releases on automatically this only compiles on
> > NUMA-Q and does not boot there (some PCI issue).
> > 
> > 
> > ppc64 (beavis):
> > 
> > drivers/built-in.o(.text+0xd2784): In function `.srp_rport_add':
> > : undefined reference to `.scsi_tgt_it_nexus_create'
> > drivers/built-in.o(.text+0xd2884): In function `.srp_rport_del':
> > : undefined reference to `.scsi_tgt_it_nexus_destroy'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > 
> > x86_64 (bl6-13):
> > 
> > ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko]
> > undefined!
> > ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko]
> > undefined!
> > make[1]: *** [__modpost] Error 1
> >...
> 
> Caused-By  : git-scsi-target.patch
> Workaround : enable CONFIG_SCSI_TGT

Sorry about this.

Andrew, could you drop the scsi-target tree from -mm?

I was surprised that the scsi-target tree is still in -mm (it had been
tested in -mm before the mainline inclusion). I guess that it's the
right way to push scsi-target stuff into -mm via James' scsi-misc.


> Is there any good reason why all the SCSI transport attributes options 
> are user visible?

No, I messed up the dependency somewhere. I'll fix it before it is
merged into scsi-misc.

Thanks,
