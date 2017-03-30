From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH v2] sd: Consider max_xfer_blocks if opt_xfer_blocks is
 unusable
Date: Thu, 30 Mar 2017 12:13:11 +0800
Message-ID: <20170330041311.GA32392@lemon.lan>
References: <20170328044126.10006-1-famz@redhat.com>
 <yq1k2774hht.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1k2774hht.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 03/29 22:37, Martin K. Petersen wrote:
> Fam Zheng <famz@redhat.com> writes:
> 
> Fam,
> 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index fcfeddc..a5c7e67 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2957,6 +2957,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >  		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
> >  	} else
> >  		rw_max = BLK_DEF_MAX_SECTORS;
> > +	rw_max = min_not_zero(rw_max, logical_to_sectors(sdp, dev_max));
> >  
> >  	/* Combine with controller limits */
> >  	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
> 
> Instead of updating rw_max twice, how about:
> 
> } else
> 	rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
>                               BLK_DEF_MAX_SECTORS);

Yes, it is better. Is it okay to make the change when you apply?

Fam
