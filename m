From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
	auditing
Date: Thu, 16 Aug 2007 12:18:29 -0500
Message-ID: <1187284710.3367.31.camel@localhost.localdomain>
References: <4695F76F.5000305@panasas.com>
	 <20070712135750.2a4a4a54.rdunlap@xenotime.net> <469B38CC.50501@panasas.com>
	 <20070717171607.ffc278eb.rdunlap@xenotime.net>
	 <469DDD74.2060208@panasas.com>
	 <20070718103320.4b6ad7b3.rdunlap@xenotime.net>
	 <20070718145818.8eebbd66.rdunlap@xenotime.net>
	 <20070718194335.e21a01e5.rdunlap@xenotime.net>
	 <20070718200315.3adcd194.rdunlap@xenotime.net>
	 <469F616D.1000909@panasas.com>
	 <20070719083719.33d8994c.rdunlap@xenotime.net>
	 <469F89FE.4080900@panasas.com>
	 <20070719104930.7ae87df8.rdunlap@xenotime.net>
	 <20070815222258.2601797f.rdunlap@xenotime.net>
	 <1187275194.3367.21.camel@localhost.localdomain>
	 <20070816102006.8a46281e.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53573 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757702AbXHPRSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2007 13:18:32 -0400
In-Reply-To: <20070816102006.8a46281e.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dougg@torque.net>, "=?ISO-8859-1?Q? _J=FCrgen_E._Fischer_ ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, matthew@wil.cx, jens.axboe@oracle.com

On Thu, 2007-08-16 at 10:20 -0700, Randy Dunlap wrote:
> > For DMA transfers ... which is where you give the device a bus physical
> > address and a length and tell it to go off and perform the transfer on
> > its own, you need to use the dma_map_ functions.
> > 
> > For PIO transfers, which are usually ones where you have to feed the
> > data into a special device register, since the kernel needs access to do
> > this, it has to be done via kmap_atomic()/kunmap_atomic().  So, if
> > everything has to go via pio, you use a sequence like
> 
> Thanks for the confirmation.
> 
> > scsi_for_each_sg(cmd, sg, max, i) {
> > 	offset = sg->offset;
> > 	len = sg->len;
> 		->length;
> 
> > 	do {
> > 		coffset = offset; clen =len;
> > 		buf = scsi_kmap_atomic_sg(sg, 1, &coffset, &clen)
> 
> 					why   1 ?

You're mapping a single segment at a time to do the PIO.

> > 		offset -= coffset; clen -= len;
> 
> 		       += ?
> 
> > 		<feed buf+coffset to/from PIO for clen>
> > 		scsi_kunmap_atomic_sg(buf);
> > 	} while (len > 0);
> > }
> 

James


