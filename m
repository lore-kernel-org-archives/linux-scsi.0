From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Mon, 14 May 2007 17:07:09 +0900
Message-ID: <20070514170709R.fujita.tomonori@lab.ntt.co.jp>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
	<46481654.7060101@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:45327 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXENIH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 04:07:26 -0400
In-Reply-To: <46481654.7060101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bhalevy@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org

From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Mon, 14 May 2007 10:57:08 +0300

> FUJITA Tomonori wrote:
> > +#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
> > +	for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
> > +
> 
> This feels like a layering violation, why not use for_each_sg()?
> 
> +#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
> 	for_each_sg(scsi_sglist(cmd), (sg), (nseg), (__i))	\

As I said before, when for_each_sg is ready, we'll convert
scsi_for_each_sg to use for_each_sg.


> That said, I'm not sure that scsi_for_each_sg() is worth abstracting
> since the caller can just as well do for_each_sg() directly
> as sketched above...

I'm not sure why you think it's a layering violation.

With scsi_for_each_sg(), many drivers don't need scsi_sglist().
