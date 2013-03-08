From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] [SCSI] scsi_transport_sas: check for allocation failure
Date: Fri, 08 Mar 2013 22:50:19 +0000
Message-ID: <1362783019.2370.45.camel@dabdike.int.hansenpartnership.com>
References: <20130308120215.GB18712@longonot.mountain>
	 <513A2678.5000803@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513A2678.5000803@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-03-08 at 12:57 -0500, Douglas Gilbert wrote:
> On 13-03-08 07:02 AM, Dan Carpenter wrote:
> > Static checkers complain that this allocation isn't checked.  We
> > should return zero if the allocation fails.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >
> > diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> > index 1b68142..a022997 100644
> > --- a/drivers/scsi/scsi_transport_sas.c
> > +++ b/drivers/scsi/scsi_transport_sas.c
> > @@ -379,9 +379,12 @@ sas_tlr_supported(struct scsi_device *sdev)
> >   {
> >   	const int vpd_len = 32;
> >   	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
> > -	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
> > +	char *buffer;
> >   	int ret = 0;
> >
> > +	buffer = kzalloc(vpd_len, GFP_KERNEL);
> > +	if (!buffer)
> > +		goto out;
> >   	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
> >   		goto out;
> >
> 
> For 32 bytes, why not use the stack?

Because the buffer is a DMA target.  You can't DMA to stack because of
padding and cacheline issues.

James
