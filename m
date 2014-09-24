From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH V5 01/17] scsi: fixing the "type" for well known LUs
Date: Wed, 24 Sep 2014 20:49:52 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9BD49@G9W0745.americas.hpqcorp.net>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
 <1411571653-22729-2-git-send-email-draviv@codeaurora.org>
 <20140924160430.GA13541@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:18141 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaIXUvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 16:51:19 -0400
In-Reply-To: <20140924160430.GA13541@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Dolev Raviv <draviv@codeaurora.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>


> From: Christoph Hellwig [mailto:hch@infradead.org]
...
> On Wed, Sep 24, 2014 at 06:13:57PM +0300, Dolev Raviv wrote:
> > From: Subhash Jadavani <subhashj@codeaurora.org>
> >
> > Some devices may respond with wrong type for well-known logical units.
> > This patch forces well-known type for devices which doesn't report it
> > correct.
> 
> This looks fine to me, as the well known LUN addresses seem to be nailed
> down nicely in t10, but let's see if Martin or Robert disagree..
> 
...
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 56675db..a34db9e 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -805,6 +805,14 @@ static int scsi_add_lun(struct scsi_device *sdev,
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
> > +		if (scsi_is_wlun(sdev->lun))
> > +			sdev->type = TYPE_WLUN;
> >  	}
...

My only concern is that the peripheral device type was included
at the outset in spc3r01 in 2001, so a design that can't get this
right might have other problems.  A print might be justified
to report something is amiss:

	if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
		sdev_printk(KERN_WARNING, sdev,
			"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16phN\n",
			__func__, sdev->type, sdev->lun);
		sdev->type = TYPE_WLUN;
	}


---
Rob Elliott    HP Server Storage





