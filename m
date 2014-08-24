From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH/RFC V2 07/16] scsi: support well known logical units
Date: Sun, 24 Aug 2014 13:56:05 -0700
Message-ID: <20140824205605.GA30004@infradead.org>
References: <82e763120409310e9d6b332854804858.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <82e763120409310e9d6b332854804858.squirrel@www.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: subhashj@codeaurora.org
Cc: Dolev Raviv <draviv@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 22, 2014 at 12:02:30AM -0000, subhashj@codeaurora.org wrote:
> >> +	/*
> >> +	 * put runtime pm reference for well-known logical units,
> >> +	 * drivers are expected to _get_* again during probe.
> >> +	 */
> >> +	if (scsi_is_wlun(sdev->lun))
> >> +		scsi_autopm_put_device(sdev);
> > Special casing the well known LUNs here seems wrong.  Shouldn't we do
> this
> > for any devices that don't get a driver attached to them?
> 
> Agreed, i will replace "if (scsi_is_wlun(sdev->lun))" check with "if
> (sdev->sdev_gendev.driver)".

I would really prefer the callers of autopm get/put to be symmetric to
issues with later than probe driver attach or similar.  Think of the
case say the CDROM or tape driver only gets loaded after we already
did a bus scan.  A quick check of the autopm code and it's underlying
implementation seems to suggest that nesting them is okay.  If that's
indeed the case I would suggest to restructure it the following way:

 - make the scsi_autopm_put_device call you add at the end of
   scsi_sysfs_add_sdev unconditional to make it balance out
   the get earlier in the function (and delete the now incorrect comment
   above the scsi_autopm_get_device call).
 - let drivers do paired get/put calls in their probe/remove methods.

If you still need any wlun changes after that please send them as a
separate patch with a detailed description on why you need it.

All in all the autopm code and it's underlying implementation is highly
confusing, so additional documentation on it would also be very welcome.
