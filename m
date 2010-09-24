From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit   rather
 than to max memory
Date: Fri, 24 Sep 2010 21:26:03 +0200
Message-ID: <4C9CFB4B.10404@fusionio.com>
References: <c9516154fabc03112353.1285107750@malahal> <4C9CAE68.4060706@fusionio.com> <20100924170532.GA29071@us.ibm.com> <4C9CEDE5.902@fusionio.com> <20100924192059.GA550@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:58887 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab0IXT0I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2010 15:26:08 -0400
In-Reply-To: <20100924192059.GA550@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Malahal Naineni <malahal@us.ibm.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-24 21:20, Malahal Naineni wrote:
> Jens Axboe [jaxboe@fusionio.com] wrote:
>>> This patch also _fixed_ our problem. So we are fine with either patch,
>>> but this patch is preferred as it enables more request merges. Also,
>>> both patches maybe needed for some configurations.
>>
>> Plus it doesn't needlessly bounce, that's the real problem you want to
>> fix. I have applied this thread patch to for-2.6.37/core, thanks.
> 
> There is a shortcut check in blk_queue_bounce() that uses blk_max_pfn to
> return without doing anything.  blk_max_pfn is not updated when we do
> hot-plug memory add, so bounce buffers are NOT really used in our case
> (thankfully)! 

Any reason we can't just add a hot mem add notifier and update the block
copies when we need to?

-- 
Jens Axboe

