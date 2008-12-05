From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH] Correctly release and allocate a new request on TUR
	retries
Date: Fri, 5 Dec 2008 10:08:51 -0800
Message-ID: <20081205180851.GA9671@linux.vnet.ibm.com>
References: <49393C88.8080103@hp.com> <20081205144954.GO18255@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:52594 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYLESIx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 13:08:53 -0500
Content-Disposition: inline
In-Reply-To: <20081205144954.GO18255@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, James.Bottomley@HansenPartnership.com

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, Dec 05 2008, Alan D. Brunelle wrote:
> > 
> 
> > 
> > Commands needing to be retried (TUR in this case) would result in a block
> > I/O request being re-used, without being re-initialized properly. This
> > patch ensures that the requests are correctly re-initialized via
> > standard allocation means.
> > 
> > Prior to this patch, boots were failing consistently as in:
> > http://lkml.org/lkml/2008/12/5/161
> > 
> > With this patch in place, the system is booting reliably.
> > 
> > Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> 
> Looks good.
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> 
> Perhaps James can push it in, I'm about to shutdown for the day...
> 

I know a failure was not detected in the hp_sw_start_stop function, but it
uses the same retry method as hp_sw_tur we should update this function
also.

I made a quick scope of callers of blk_get_request and I did not see a
repeated of this retry usage model. I will make another pass to see if I
missed something.

> 
> > ---
> >  drivers/scsi/device_handler/scsi_dh_hp_sw.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> > index 9aec4ca..1f6b6a8 100644
> > --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> > +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> > @@ -107,6 +107,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
> >  	struct request *req;
> >  	int ret;
> >  
> > +retry:
> >  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
> >  	if (!req)
> >  		return SCSI_DH_RES_TEMP_UNAVAIL;
> > @@ -121,7 +122,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
> >  	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
> >  	req->sense_len = 0;
> >  
> > -retry:
> >  	ret = blk_execute_rq(req->q, NULL, req, 1);
> >  	if (ret == -EIO) {
> >  		if (req->sense_len > 0) {
> > @@ -136,8 +136,10 @@ retry:
> >  		h->path_state = HP_SW_PATH_ACTIVE;
> >  		ret = SCSI_DH_OK;
> >  	}
> > -	if (ret == SCSI_DH_IMM_RETRY)
> > +	if (ret == SCSI_DH_IMM_RETRY) {
> > +		blk_put_request(req);
> >  		goto retry;
> > +	}
> >  	if (ret == SCSI_DH_DEV_OFFLINED) {
> >  		h->path_state = HP_SW_PATH_PASSIVE;
> >  		ret = SCSI_DH_OK;
> > -- 
> > 1.5.6.3
> > 
> 
> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
