From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH V6 01/18] scsi: fixing the "type" for well known LUs
Date: Fri, 3 Oct 2014 18:40:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCCE9C@G4W3202.americas.hpqcorp.net>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
 <1411648356-3883-2-git-send-email-draviv@codeaurora.org>
 <20140926081343.GA22805@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57084 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaJCSlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2014 14:41:42 -0400
In-Reply-To: <20140926081343.GA22805@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Dolev Raviv <draviv@codeaurora.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, 26 September, 2014 3:14 AM
> To: Dolev Raviv
> Cc: James.Bottomley@HansenPartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org; linux-arm-
> msm@vger.kernel.org; santoshsy@gmail.com; Subhash Jadavani; Sujit Reddy
> Thumma; Elliott, Robert (Server Storage); Martin K. Petersen
> Subject: Re: [PATCH V6 01/18] scsi: fixing the "type" for well known LUs
> 
> Robert, I guess this version is okay with you?
> 
> On Thu, Sep 25, 2014 at 03:32:19PM +0300, Dolev Raviv wrote:
> > From: Subhash Jadavani <subhashj@codeaurora.org>
> >
> > Some devices may respond with wrong type for well-known logical units.
> > This patch forces well-known type for devices which doesn't report it
> > correct.
> >
> > Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> > Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> > Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> >
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 56675db..1095d5a 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -805,6 +805,19 @@ static int scsi_add_lun(struct scsi_device *sdev,
> unsigned char *inq_result,
> >  	} else {
> >  		sdev->type = (inq_result[0] & 0x1f);
> >  		sdev->removable = (inq_result[1] & 0x80) >> 7;
> > +
> > +		/*
> > +		 * some devices may respond with wrong type for
> > +		 * well-known logical units. Force well-known type
> > +		 * to enumerate them correctly.
> > +		 */
> > +		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
> > +			sdev_printk(KERN_WARNING, sdev,
> > +				"%s: correcting incorrect peripheral device type
> 0x%x for W-LUN 0x%16phN\n",
> > +				__func__, sdev->type, sdev->lun);
> > +			sdev->type = TYPE_WLUN;
> > +		}
> > +

Yes, that looks good.

Reviewed-by: Robert Elliott <elliott@hp.com>

