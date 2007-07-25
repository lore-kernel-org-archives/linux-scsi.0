From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.23-rc1-mm1: SCSI_SRP_ATTRS compile error
Date: Wed, 25 Jul 2007 20:06:18 +0200
Message-ID: <20070725180618.GE3572@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A77C28.1050807@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44178 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755529AbXGYSGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 14:06:45 -0400
Content-Disposition: inline
In-Reply-To: <46A77C28.1050807@shadowen.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@shadowen.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James.Bottomley@SteelEye.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, linux-scsi@vger.kernel.org

On Wed, Jul 25, 2007 at 05:36:56PM +0100, Andy Whitcroft wrote:
> Of the machines we test releases on automatically this only compiles on
> NUMA-Q and does not boot there (some PCI issue).
> 
> 
> ppc64 (beavis):
> 
> drivers/built-in.o(.text+0xd2784): In function `.srp_rport_add':
> : undefined reference to `.scsi_tgt_it_nexus_create'
> drivers/built-in.o(.text+0xd2884): In function `.srp_rport_del':
> : undefined reference to `.scsi_tgt_it_nexus_destroy'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> x86_64 (bl6-13):
> 
> ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko]
> undefined!
> ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko]
> undefined!
> make[1]: *** [__modpost] Error 1
>...

Caused-By  : git-scsi-target.patch
Workaround : enable CONFIG_SCSI_TGT

Is there any good reason why all the SCSI transport attributes options 
are user visible?

With an answer to this question I can fix this bug.

> -apw

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

