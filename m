From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: Mon, 21 Jun 2004 18:41:58 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D69F56.2000307@torque.net>
References: <20040508003906.GA26338@gondor.apana.org.au> 	<20040519103800.GA9891@gondor.apana.org.au> <1086026538.2004.7.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:21516 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S266163AbUFUImc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 04:42:32 -0400
In-Reply-To: <1086026538.2004.7.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

James Bottomley wrote:
> On Wed, 2004-05-19 at 05:38, Herbert Xu wrote:
> 
>>Hi:
>>
>>This is a resend of my patch that adds basic support for highmem
>>on i386 to the advansys driver.  It has been tested in
>>http://bugs.debian.org/245238.
>>
>>The maintainer email address listed in the MAINTAINERS file bounced
>>so someone else will need to look at this.
> 
> 
> I converted your patch to use the DMA-API.  This will be necessary to
> use the EISA advansys boards---Of course, EISA won't work properly until
> the entire driver is converted to the driverfs probing API, sigh, but
> I'll get around to that eventually.
> 
> OK, and I couldn't resist getting rid of the stupid in_isr locking on
> the done function.
> 
> Could someone who actually has one of these things please test?  Thanks,

James,
I just tested it in lk 2.6.7-bk2 and the advansys driver is
broken. The disk access light stays on for several seconds
while it tries to read the partition table after which it
announces "unknown partition table". Since my rootfs is on
that disk it's all downhill from there.

HBA is a ASB3940U2VV (PCI) and it worked ok in lk 2.6.6 .
I haven't tried lk 2.6.7 (release yet).


Also when I put an ISA Advansys HBA in the box (with the PCI
advansys HBA) it causes an oops during bootup in
AscInitGetConfig+0x75/0x1d0
which is called from advansys_detect().
I think this ISA HBA has been causing this oops each
time I have tried it in the lk 2.6 series (not just
with lk 2.6.7-bk2).

Doug Gilbert
