From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: don't treat underrun as an error on SMP tasks
Date: Sun, 30 Dec 2007 09:48:14 -0600
Message-ID: <1199029694.5380.0.camel@localhost.localdomain>
References: <1198950594.3264.36.camel@localhost.localdomain>
	 <20071230192209S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38589 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757759AbXL3PsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Dec 2007 10:48:21 -0500
In-Reply-To: <20071230192209S.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp


On Sun, 2007-12-30 at 19:34 +0900, FUJITA Tomonori wrote:
> On Sat, 29 Dec 2007 11:49:53 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > All SMP tasks sent through bsg generate messages like:
> > 
> > sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x81
> > 
> > Three times (because the task gets retried).  Firstly, don't retry
> > either overrun or underrun (the data buffer isn't going to change size)
> > and secondly, just report the underrun but don't set an error for it.
> > This is necessary so bsg can report back the residual.
> > 
> > James
> > 
> > diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> > index 76555b1..1578059 100644
> > --- a/drivers/scsi/libsas/sas_expander.c
> > +++ b/drivers/scsi/libsas/sas_expander.c
> > @@ -109,6 +109,16 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
> >  		    task->task_status.stat == SAM_GOOD) {
> >  			res = 0;
> >  			break;
> > +		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
> > +		      task->task_status.stat == SAS_DATA_UNDERRUN) {
> > +			/* no error, but return the number of bytes of
> > +			 * underrun */
> > +			res = task->task_status.residual;
> > +			break;
> > +		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
> > +		      task->task_status.stat == SAS_DATA_OVERRUN) {
> > +			res = -EMSGSIZE;
> > +			break;
> >  		} else {
> >  			SAS_DPRINTK("%s: task to dev %016llx response: 0x%x "
> >  				    "status 0x%x\n", __FUNCTION__,
> > @@ -1924,6 +1934,11 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> >  
> >  	ret = smp_execute_task(dev, bio_data(req->bio), req->data_len,
> >  			       bio_data(rsp->bio), rsp->data_len);
> > +	if (ret > 0) {
> > +		/* positive number is the untransferred residual */
> > +		rsp->data_len = ret;
> > +		ret = 0;
> > +	}
> 
> Would be better to update dout_resid too (on sucess, we can set
> req->data_len to zero, I think)?

Yes, I'll add that.

> Here's a patch to do the same thing for mpt sas, an updated version
> of:
> 
> http://marc.info/?l=linux-scsi&m=119811872823947&w=2

And this.

James


> --
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] mpt fusion: mptsas_smp_handler updates resid
> 
> This patch fixes mptsas_smp_handler to update both din_resid or
> dout_resid on success. bsg can report back the residual.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/message/fusion/mptsas.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index e4c94f9..f77b329 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1343,6 +1343,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>  		memcpy(req->sense, smprep, sizeof(*smprep));
>  		req->sense_len = sizeof(*smprep);
> +		req->data_len = 0;
> +		rsp->data_len -= smprep->ResponseDataLength;
>  	} else {
>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
>  		    ioc->name, __FUNCTION__);

