From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (3/4)
Date: Thu, 13 Feb 2003 00:24:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030213082410.GB2493@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <20030211081536.GB1368@beaverton.ibm.com> <20030211081744.GC1368@beaverton.ibm.com> <1045087146.1623.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1045087146.1623.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> >  	list_for_each_entry(sdev, &shost->my_devices, siblings) {
> Your eh_list here is per host, so there's no need to loop over all the
> devices above. 
> 

This is a left over artifact. Since the list is not sorted by device and
that log message displays total fails and number of devices with
failure.

> > -		for (scmd = sc_list; scmd; scmd = scmd->bh_next) {
> > +		list_for_each_entry(scmd, &shost->eh_cmd_list, eh_list) {
> >  			if (scmd->device == sdev) {
> >  				++total_failures;
> >  				if (scsi_eh_eflags_chk(scmd,
> [...] 
> > -static int scsi_eh_bus_device_reset(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
> > +static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
> > +				    struct list_head *done_list)
> >  {
> >  	int rtn;
> > -	Scsi_Cmnd *scmd;
> > -	Scsi_Device *sdev;
> > -
> > -	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Trying BDR\n", __FUNCTION__));
> > +	struct list_head *lh, *lh_sf;
> > +	struct scsi_cmnd *scmd, *bdr_scmd;
> > +	struct scsi_device *sdev;
> >  
> >  	list_for_each_entry(sdev, &shost->my_devices, siblings) {
> 
> Same problem here. 
> 

Our failed_cmd_q may contain more than a single failed command per device so
traversing the list allows only one BDR per device failing to be sent.

> > @@ -1477,6 +1469,8 @@
> >  
> >  	ASSERT_LOCK(shost->host_lock, 0);
> >  
> > +	shost->in_recovery = 0;
> > +
> >  	/*
> >  	 * If the door was locked, we need to insert a door lock request
> >  	 * onto the head of the SCSI request queue for the device.  There
> 
> This is a lot better than we had previously, but still, I think resetting
> in_recovery should happen after we've potentially queued door lock commands
> on the queue head, since as soon as we reset this, the queue can potentially
> be restarted (even without the necessary restart below this in the code).
> 

Ok I moved it after lock door and right before the wake_up.

-andmike
--
Michael Anderson
andmike@us.ibm.com

