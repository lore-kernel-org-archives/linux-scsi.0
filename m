From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Fri, 25 May 2007 01:47:52 +0900
Message-ID: <20070525014752A.fujita.tomonori@lab.ntt.co.jp>
References: <464C1721.8030009@panasas.com>
	<20070517201243E.fujita.tomonori@lab.ntt.co.jp>
	<4655BF32.2020403@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:39804 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXEXQsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 12:48:37 -0400
In-Reply-To: <4655BF32.2020403@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 24 May 2007 19:37:06 +0300

> FUJITA Tomonori wrote:
> >> FUJITA Tomonori wrote:
> > 
> > One thing that I found is:
> > 
> > +#define scsi_resid(cmd) ((cmd)->sg_table->resid)
> > 
> > 
> > This doesn't work for some drivers (at least ipr) since they set
> > cmd->resid even with commands without data transfer.
> > 
> 
> James, Tomo.
> 
> the last accessor:
> +#define scsi_resid(cmd) ((cmd)->resid)
> 
> used as an l-value in drivers does not serve our purpose, as seen by the test
> implementation of scsi_sg_table. Now clearly this needs an accessor and it is a
> bidi parameter (need 2 of them).

I thought that it would be better to fix several drivers (less than 10).
