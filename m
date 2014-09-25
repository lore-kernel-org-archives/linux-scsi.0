From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V5 01/17] scsi: fixing the "type" for well known LUs
Date: Wed, 24 Sep 2014 23:18:25 -0700
Message-ID: <001801cfd888$851d8550$8f588ff0$@codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org> <1411571653-22729-2-git-send-email-draviv@codeaurora.org> <20140924160430.GA13541@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958C9BD49@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C9BD49@G9W0745.americas.hpqcorp.net>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: "'Elliott, Robert (Server Storage)'" <Elliott@hp.com>, 'Christoph Hellwig' <hch@infradead.org>, 'Dolev Raviv' <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, "'Martin K. Petersen'" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

>> > +		 * some devices may respond with wrong type for
>> > +		 * well-known logical units. Force well-known type
>> > +		 * to enumerate them correctly.
>> > +		 */
>> > +		if (scsi_is_wlun(sdev->lun))
>> > +			sdev->type = TYPE_WLUN;
>> >  	}
> ...
>
> My only concern is that the peripheral device type was included at the
outset in spc3r01 in 2001, so a design that can't get this right might have
other problems.  A print might be justified to report something is amiss:
>
>	if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
>		sdev_printk(KERN_WARNING, sdev,
>			"%s: correcting incorrect peripheral device type
0x%x for W-LUN 0x%16phN\n",
>			__func__, sdev->type, sdev->lun);
>		sdev->type = TYPE_WLUN;
>	}

Agreed, will take care of this in next patch revision.


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Elliott, Robert
(Server Storage)
Sent: Wednesday, September 24, 2014 1:50 PM
To: Christoph Hellwig; Dolev Raviv
Cc: James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org;
linux-scsi-owner@vger.kernel.org; linux-arm-msm@vger.kernel.org;
santoshsy@gmail.com; Subhash Jadavani; Sujit Reddy Thumma; Martin K.
Petersen
Subject: RE: [PATCH V5 01/17] scsi: fixing the "type" for well known LUs


> From: Christoph Hellwig [mailto:hch@infradead.org]
...
> On Wed, Sep 24, 2014 at 06:13:57PM +0300, Dolev Raviv wrote:
> > From: Subhash Jadavani <subhashj@codeaurora.org>
> >
> > Some devices may respond with wrong type for well-known logical units.
> > This patch forces well-known type for devices which doesn't report 
> > it correct.
> 
> This looks fine to me, as the well known LUN addresses seem to be 
> nailed down nicely in t10, but let's see if Martin or Robert disagree..
> 
...
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c 
> > index 56675db..a34db9e 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -805,6 +805,14 @@ static int scsi_add_lun(struct scsi_device 
> > *sdev,
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

My only concern is that the peripheral device type was included at the
outset in spc3r01 in 2001, so a design that can't get this right might have
other problems.  A print might be justified to report something is amiss:

	if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
		sdev_printk(KERN_WARNING, sdev,
			"%s: correcting incorrect peripheral device type
0x%x for W-LUN 0x%16phN\n",
			__func__, sdev->type, sdev->lun);
		sdev->type = TYPE_WLUN;
	}


---
Rob Elliott    HP Server Storage





--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
