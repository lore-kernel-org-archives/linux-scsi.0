From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] Use the correct size to set block max sectors
Date: Fri, 27 May 2016 04:06:30 +0000
Message-ID: <SN1PR0301MB198345E6E86A47124B79316ACE420@SN1PR0301MB1983.namprd03.prod.outlook.com>
References: <1464307708-4315-1-git-send-email-longli@microsoft.com>
 <aad00979-740e-b844-64fb-4bfa646796e5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aad00979-740e-b844-64fb-4bfa646796e5@sandisk.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: KY Srinivasan <kys@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Bart Van Assche [mailto:bart.vanassche@sandisk.com]
> Sent: Thursday, May 26, 2016 7:19 PM
> To: Long Li <longli@microsoft.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: KY Srinivasan <kys@microsoft.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] Use the correct size to set block max sectors
> 
> On 05/26/16 17:08, Long Li wrote:
> > The block sector size should be in unit of 512 bytes, not in bytes.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
> >
> > ---
> >  drivers/scsi/sd.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> > 428c03e..4bce17e 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2862,9 +2862,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >  	if (sdkp->opt_xfer_blocks &&
> >  	    sdkp->opt_xfer_blocks <= dev_max &&
> >  	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
> > -	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE)
> > -		rw_max = q->limits.io_opt =
> > +	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE) {
> > +		q->limits.io_opt =
> >  			sdkp->opt_xfer_blocks * sdp->sector_size;
> > +		rw_max = (q->limits.io_opt >> 9);
> > +	}
> >  	else
> >  		rw_max = BLK_DEF_MAX_SECTORS;
> 
> Isn't this a duplicate of a patch Martin Petersen posted three weeks ago? See
> also
> https://na01.safelinks.protection.outlook.com/?url=http%3a%2f%2fthread.g
> mane.org%2fgmane.linux.scsi%2f113746&data=01%7c01%7clongli%40micros
> oft.com%7c4396718e6f9749d178bf08d385d53bba%7c72f988bf86f141af91ab2
> d7cd011db47%7c1&sdata=UpiYwEdYMtqcwuNS1llVuXcQ6riFT3b5%2b44Sn56
> Bl14%3d.
> 
> Bart.
> 
> 

Yes, this has been fixed in that patch.

Please drop this one.
