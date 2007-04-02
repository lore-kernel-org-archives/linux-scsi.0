From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SMP pass through interface via bsg
Date: Tue, 03 Apr 2007 03:55:42 +0900
Message-ID: <20070403035542B.fujita.tomonori@lab.ntt.co.jp>
References: <1175533302.3680.31.camel@mulgrave.il.steeleye.com>
	<20070402221349L.fujita.tomonori@lab.ntt.co.jp>
	<20070402181238.GB15273@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:57566 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965680AbXDBS4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 14:56:00 -0400
In-Reply-To: <20070402181238.GB15273@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 2 Apr 2007 20:12:38 +0200

> On Tue, Apr 03 2007, FUJITA Tomonori wrote:
> > From: James Bottomley <James.Bottomley@SteelEye.com>
> > Subject: Re: SMP pass through interface via bsg
> > Date: Mon, 02 Apr 2007 12:01:41 -0500
> > 
> > > On Tue, 2007-04-03 at 01:43 +0900, FUJITA Tomonori wrote:
> > > > OK. I found another bug in smp_test tool (sends bogus response buffer
> > > > len to kernel). I've uploaded a new patch:
> > > > 
> > > > http://zaal.org/bsg/smp-test2.diff
> > > 
> > > That sort of works; you have a final bug in that the manufacturer info
> > > response frame is 64 bytes, not 128 bytes, but with that corrected
> > > everything goes through and I get the result back:
> > > 
> > > hobholes:~# /home/jejb/git/sgv4-tools/smp_test /sys/class/bsg/expander-2\:0
> > >   SAS-1.1 format: 0
> > >   vendor identification: LSILOGIC
> > >   product identification: SASx12 A.0      
> > >   product revision level: 
> > > 
> > > So we can class this one as a success ... 
> > >
> > > Thanks!
> > 
> > Great! Thanks. I'll try to finish the mpt driver's hook
> > sometime. Finally, We have a bsg user (though it also needs proper
> > bidi support).
> > 
> > Jens, what remains to be done before bsg is merged into mainline?
> 
> Well the bi-dir stuff and sg v4 design were the two bits that needed to
> get done before pushing bsg made sense, so we are getting there...
> Probably a 2.6.23 target, leaving the bidi bits a revision cycle to get
> sorted out.

sg v4 design issues refer to:

- iovec support

- an alternative to the read/write interface

- scsi command tag (possibly larger than 64 bits)

What else?
