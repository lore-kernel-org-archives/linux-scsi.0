From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] scsi_transport_sas: check for allocation failure
Date: Mon, 11 Mar 2013 16:10:32 +0300
Message-ID: <20130311131032.GO9189@mwanda>
References: <20130308120215.GB18712@longonot.mountain>
 <513A2678.5000803@interlog.com>
 <1362783019.2370.45.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1362783019.2370.45.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 08, 2013 at 10:50:19PM +0000, James Bottomley wrote:
> On Fri, 2013-03-08 at 12:57 -0500, Douglas Gilbert wrote:
> > On 13-03-08 07:02 AM, Dan Carpenter wrote:
> > > Static checkers complain that this allocation isn't checked.  We
> > > should return zero if the allocation fails.
> > >
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > >
> > > diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> > > index 1b68142..a022997 100644
> > > --- a/drivers/scsi/scsi_transport_sas.c
> > > +++ b/drivers/scsi/scsi_transport_sas.c
> > > @@ -379,9 +379,12 @@ sas_tlr_supported(struct scsi_device *sdev)
> > >   {
> > >   	const int vpd_len = 32;
> > >   	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
> > > -	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
> > > +	char *buffer;
> > >   	int ret = 0;
> > >
> > > +	buffer = kzalloc(vpd_len, GFP_KERNEL);
> > > +	if (!buffer)
> > > +		goto out;
> > >   	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
> > >   		goto out;
> > >
> > 
> > For 32 bytes, why not use the stack?
> 
> Because the buffer is a DMA target.  You can't DMA to stack because of
> padding and cacheline issues.
> 

I think stack data works here.  scsi_execute() calls
blk_rq_map_kern() which handles stack memory and alignment issues.

regards,
dan carpenter
