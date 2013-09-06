From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND 2/2] Hard disk S3 resume time optimization
Date: Fri, 6 Sep 2013 15:19:10 -0700
Message-ID: <20130906221910.GC7205@linux.intel.com>
References: <20130906004425.GA31998@linux.intel.com>
 <8426004.FBs8WcKaAG@amdc1032>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50772 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3IFWTH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Sep 2013 18:19:07 -0400
Content-Disposition: inline
In-Reply-To: <8426004.FBs8WcKaAG@amdc1032>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-scsi@vger.kernel.org

I'll resubmit with a better description. As for the return value, if you look
at the mailing list history you'll see that I already tried that approach (and 
was actually advised to do it this way):

http://marc.info/?l=linux-scsi&m=136881989601276&w=2

On Fri, Sep 06, 2013 at 07:03:26PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday, September 05, 2013 05:44:25 PM Todd E Brandt wrote:
> > Part 2 of the hard disk resume optimization patch, this one applies
> > to the scsi subsystem.
> 
> Please update the patch description to say what the patch does (and why).
> 
> > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> >  drivers/scsi/sd.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 81 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 86fcf2c..d4bf784 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -107,6 +107,7 @@ static int  sd_remove(struct device *);
> >  static void sd_shutdown(struct device *);
> >  static int sd_suspend(struct device *);
> >  static int sd_resume(struct device *);
> > +static int sd_resume_async(struct device *);
> >  static void sd_rescan(struct device *);
> >  static int sd_done(struct scsi_cmnd *);
> >  static int sd_eh_action(struct scsi_cmnd *, unsigned char *, int, int);
> > @@ -484,7 +485,7 @@ static struct class sd_disk_class = {
> >  
> >  static const struct dev_pm_ops sd_pm_ops = {
> >  	.suspend		= sd_suspend,
> > -	.resume			= sd_resume,
> > +	.resume			= sd_resume_async,
> 
> Same comment as with patch #1.
> 
> When the command execution later fails the error will be now lost
> (->resume returned 0 already and nothing can be done to fix it).
> 
> Sorry but this looks like a wrong approach and you should fix
> the PM layer to do async ->resume when possible instead.
> 
> >  	.poweroff		= sd_suspend,
> >  	.restore		= sd_resume,
> >  	.runtime_suspend	= sd_suspend,
> > @@ -3137,6 +3138,85 @@ done:
> >  	return ret;
> >  }
> >  
> > +static void sd_resume_async_end(struct request *rq, int error)
> > +{
> > +	struct scsi_sense_hdr sshdr;
> > +	struct scsi_disk *sdkp = rq->end_io_data;
> > +	char *sense = rq->sense;
> > +
> > +	if (error) {
> > +		sd_printk(KERN_WARNING, sdkp, "START FAILED\n");
> > +		sd_print_result(sdkp, error);
> > +		if (sense && (driver_byte(error) & DRIVER_SENSE)) {
> > +			scsi_normalize_sense(sense,
> > +				SCSI_SENSE_BUFFERSIZE, &sshdr);
> > +			sd_print_sense_hdr(sdkp, &sshdr);
> > +		}
> > +	} else
> > +		sd_printk(KERN_NOTICE, sdkp, "START SUCCESS\n");
> > +
> > +	kfree(sense);
> > +	rq->sense = NULL;
> > +	rq->end_io_data = NULL;
> > +	__blk_put_request(rq->q, rq);
> > +	scsi_disk_put(sdkp);
> > +}
> > +
> > +static int sd_resume_async(struct device *dev)
> > +{
> > +	unsigned char cmd[6] = { START_STOP };
> > +	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> > +	struct request *req;
> > +	char *sense = NULL;
> > +	int ret = 0;
> > +
> > +	if (!sdkp->device->manage_start_stop)
> > +		goto error;
> > +
> > +	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> > +
> > +	cmd[4] |= 1;
> > +
> > +	if (sdkp->device->start_stop_pwr_cond)
> > +		cmd[4] |= 1 << 4;	/* Active or Standby */
> > +
> > +	if (!scsi_device_online(sdkp->device)) {
> > +		ret = -ENODEV;
> > +		goto error;
> > +	}
> > +
> > +	req = blk_get_request(sdkp->device->request_queue, 0, __GFP_WAIT);
> > +	if (!req) {
> > +		ret = -ENOMEM;
> > +		goto error;
> > +	}
> > +
> > +	sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
> > +	if (!sense) {
> > +		ret = -ENOMEM;
> > +		goto error_sense;
> > +	}
> > +
> > +	req->cmd_len = COMMAND_SIZE(cmd[0]);
> > +	memcpy(req->cmd, cmd, req->cmd_len);
> > +	req->sense = sense;
> > +	req->sense_len = 0;
> > +	req->retries = SD_MAX_RETRIES;
> > +	req->timeout = SD_TIMEOUT;
> > +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> > +	req->cmd_flags |= REQ_PM | REQ_QUIET | REQ_PREEMPT;
> > +
> > +	req->end_io_data = sdkp;
> > +	blk_execute_rq_nowait(req->q, NULL, req, 1, sd_resume_async_end);
> > +	return 0;
> > +
> > + error_sense:
> > +	__blk_put_request(req->q, req);
> > + error:
> > +	scsi_disk_put(sdkp);
> > +	return ret;
> > +}
> > +
> >  /**
> >   *	init_sd - entry point for this driver (both when built in or when
> >   *	a module).
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
