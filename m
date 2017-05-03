From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 25/27] block: remove the discard_zeroes_data flag
Date: Wed, 3 May 2017 10:33:39 -0400
Message-ID: <20170503143338.GA24111@redhat.com>
References: <20170405172125.22600-1-hch@lst.de>
 <20170405172125.22600-26-hch@lst.de>
 <1493671519.2665.15.camel@sandisk.com>
 <1493707425.23202.77.camel@haakon3.risingtidesystems.com>
 <1493709373.23202.79.camel@haakon3.risingtidesystems.com>
 <20170502072328.GA11522@lst.de>
 <1493782395.23202.84.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493782395.23202.84.camel@haakon3.risingtidesystems.com>
Sender: linux-block-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "shli@kernel.org" <shli@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 02 2017 at 11:33pm -0400,
Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:

> On Tue, 2017-05-02 at 09:23 +0200, hch@lst.de wrote:
> > On Tue, May 02, 2017 at 12:16:13AM -0700, Nicholas A. Bellinger wrote:
> > > Or, another options is use bdev_write_zeroes_sectors() to determine when
> > > dev_attrib->unmap_zeroes_data should be set.
> > 
> > Yes, that in combination with your patch to use bdev_write_zeroes_sectors
> > for zeroing from write same seems like the right fix.
> 
> The larger target/iblock conversion patch looks like post v4.12 material
> at this point, so to avoid breakage wrt to existing LBPRZ behavior, I'll
> plan to push the following patch post -rc1.
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index d2f089c..e7caf78 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -851,7 +851,7 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
>         attrib->unmap_granularity = q->limits.discard_granularity / block_size;
>         attrib->unmap_granularity_alignment = q->limits.discard_alignment /
>                                                                 block_size;
> -       attrib->unmap_zeroes_data = 0;
> +       attrib->unmap_zeroes_data = (q->limits.max_write_zeroes_sectors);
>         return true;
>  }
>  EXPORT_SYMBOL(target_configure_unmap_from_queue);
> 

Completely a nit but: why the extra parenthesis?
