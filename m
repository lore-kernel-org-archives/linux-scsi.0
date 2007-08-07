From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold
 structure
Date: Wed, 08 Aug 2007 07:38:01 +0900
Message-ID: <20070808073801U.fujita.tomonori@lab.ntt.co.jp>
References: <46B600F4.7020601@torque.net>
	<20070806130944R.fujita.tomonori@lab.ntt.co.jp>
	<46B8A845.4080106@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:51070 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbXHGWiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 18:38:24 -0400
In-Reply-To: <46B8A845.4080106@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: fujita.tomonori@lab.ntt.co.jp, dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com

On Tue, 07 Aug 2007 12:13:41 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> FUJITA Tomonori wrote:
> > Allocating 64K contiguous memory is not good so the next thing to do
> > is converting sg to use the sg chaining support fully. Or it might be
> 
> For LLDs like aic7xxx, I think we are stuck with a small 
> scsi_host_template->sg_tablesize, so to continue to get large requests 
> like before will we have to still allocate large segments?

No. sg.c has:

sizeof(struct scatterlist) * min(q->max_hw_segments, q->max_phys_segments)

If a lld has small max_hw_segments, it doesn't allocate big contiguous
memory.


> Is block/scsi_ioctl.c converted to sg chaining in any tree yet? Is that 
> in your tree or one of Jen's branches.

block/scsi_ioctl.c uses the standard block layer functions, there is
nothing to convert in it. sglist doesn't change the standard block
layer functions much since it doesn't allocate sg list. It changes
only blk_rq_map_sg.

Now only scsi-ml is changed to allocate chaining sg list
properly. Others like cciss are not converted yet, I think. It might
make sense to have the standard block layer functions to allocate
chaining sg list properly. So we could convert to potential consumers
(scsi-ml, sg, ccisss, etc) use them though I'm not sure how many non
scsi-ml needs chaining sg list.
