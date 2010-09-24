From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA
 limit rather than to max memory
Date: Fri, 24 Sep 2010 12:20:59 -0700
Message-ID: <20100924192059.GA550@us.ibm.com>
References: <c9516154fabc03112353.1285107750@malahal>
	<4C9CAE68.4060706@fusionio.com> <20100924170532.GA29071@us.ibm.com>
	<4C9CEDE5.902@fusionio.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C9CEDE5.902@fusionio.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jens Axboe [jaxboe@fusionio.com] wrote:
> > This patch also _fixed_ our problem. So we are fine with either patch,
> > but this patch is preferred as it enables more request merges. Also,
> > both patches maybe needed for some configurations.
> 
> Plus it doesn't needlessly bounce, that's the real problem you want to
> fix. I have applied this thread patch to for-2.6.37/core, thanks.

There is a shortcut check in blk_queue_bounce() that uses blk_max_pfn to
return without doing anything.  blk_max_pfn is not updated when we do
hot-plug memory add, so bounce buffers are NOT really used in our case
(thankfully)! 

Here is the code that may need some fix in future:

        if (!(q->limits.bounce_gfp & GFP_DMA)) {
		if (queue_bounce_pfn(q) >= blk_max_pfn)
			return;


Thank you so much for applying this patch.

Thanks, Malahal.
