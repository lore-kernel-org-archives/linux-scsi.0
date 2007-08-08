From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold  structure
Date: Wed, 8 Aug 2007 09:15:28 +0200
Message-ID: <20070808071528.GJ5245@kernel.dk>
References: <46B600F4.7020601@torque.net> <20070806130944R.fujita.tomonori@lab.ntt.co.jp> <46B8A845.4080106@cs.wisc.edu> <20070808073801U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2796 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765026AbXHHHPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Aug 2007 03:15:31 -0400
Content-Disposition: inline
In-Reply-To: <20070808073801U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: michaelc@cs.wisc.edu, dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Wed, Aug 08 2007, FUJITA Tomonori wrote:
> Now only scsi-ml is changed to allocate chaining sg list
> properly. Others like cciss are not converted yet, I think. It might
> make sense to have the standard block layer functions to allocate
> chaining sg list properly. So we could convert to potential consumers
> (scsi-ml, sg, ccisss, etc) use them though I'm not sure how many non
> scsi-ml needs chaining sg list.

The scsi chain table allocation/freeing could be made generic. The
reason I didn't do that is - as you list - that probably not many
non-scsi drivers need/want it. If they do, we can put that functionality
in the block layer.

The cciss hardware doesn't support more than 31 segments iirc. Newer
firmwares can do chaining as well, but the linux driver doesn't actually
support it. Once it does, we can add sg chaining support there too.

-- 
Jens Axboe

