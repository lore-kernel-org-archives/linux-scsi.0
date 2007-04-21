From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] utilities: add helper functions for safe 64-bit integer
 operations as 32-bit halves
Date: Sat, 21 Apr 2007 14:06:22 -0700
Message-ID: <20070421140622.dc197b38.akpm@linux-foundation.org>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
	<1176995934.31764.7.camel@mulgrave.il.steeleye.com>
	<226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net>
	<1176999730.31764.15.camel@mulgrave.il.steeleye.com>
	<558F4D473FD7FE419B019232BF2D37B401167D74@G3W0634.americas.hpqcorp.net>
	<20070419222028.d33c7f86.akpm@linux-foundation.org>
	<1177074641.3718.5.camel@mulgrave.il.steeleye.com>
	<20070420114337.12a67141.akpm@linux-foundation.org>
	<1177095007.3718.43.camel@mulgrave.il.steeleye.com>
	<20070420123041.94aac1e1.akpm@linux-foundation.org>
	<1177100459.3718.45.camel@mulgrave.il.steeleye.com>
	<20070420141218.a0222472.akpm@linux-foundation.org>
	<alpine.DEB.0.98.0704201732240.11655@sigma.j-a-k-j.com>
	<alpine.DEB.0.98.0704202040150.16687@sigma.j-a-k-j.com>
	<20070421030825.bed0b8a9.akpm@linux-foundation.org>
	<20070421220147.7144113e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbXDUVH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Apr 2007 17:07:56 -0400
In-Reply-To: <20070421220147.7144113e@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, James Bottomley <James.Bottomley@SteelEye.com>, "Cameron, Steve" <Steve.Cameron@hp.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, trivial@kernel.org

On Sat, 21 Apr 2007 22:01:47 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > +#define lower_32_bits(n) (sizeof(n) == 8 ? (u32)(n) : (n))
> > 
> > n&0xffffffff would be simpler.
> > 
> > Do we actually have any call for this?
> 
> The only case for all of this we care about is sector_t, which is one
> type, with specific properties (eg always being positive). The rest is
> over-engineering. Call it sector_upper32() do it the simple way and stop
> trying to solve a problem we don't have

James said we have the same problem with dma_addr_t.
