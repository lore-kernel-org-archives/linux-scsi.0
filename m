From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: 17 Jun 2004 20:45:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087523134.2210.97.camel@mulgrave>
References: <1087481331.2210.27.camel@mulgrave>
	<m33c4tsnex.fsf@defiant.pm.waw.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:48307 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264929AbUFRBph (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 21:45:37 -0400
In-Reply-To: <m33c4tsnex.fsf@defiant.pm.waw.pl>
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-06-17 at 19:46, Krzysztof Halasa wrote:
> #define OUR_COST_32 = 4
> #define OUR_COST_39 = 8
> #define OUR_COST_64 = 10
> 
> int cost32 = check_dma_mask(32 bits);
> int cost39 = check_dma_mask(39 bits);
> int cost64 = check_dma_mask(64 bits);
> 
> if (!cost32  && !cost39 && !cost64)
> 	printk(KERN_ERR "64 bits aren't enough for RAM addressing?\n")
> else
> 	use_mode_with_minimal_cost(cost32 * OUR_COST_32,
> 				   cost39 * OUR_COST_39,
> 				   cost64 * OUR_COST_64);
> 
> This check_dma_mask() should be renamed + extended to cover different
> RAM access types:
> - coherent vs non-coherent memory
> - preallocated/initialized memory (such as skb->data passed to
>   hard_start_xmit()) vs uninitialized memory (such as returned by
>   kmalloc()).

Well, I did consider a similar API, but not for long.

It falls victim to the 95/5 rule---when you engineer an API, if 95% of
the complexity is dealing with the 5% of special cases, you're over
engineering.

So the original proposal is the remaining 5% that covers 95% of the use
cases (and will do better even on the remaining 5%).

James


