From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 07/10] hpsa: hide logical drives with format in progress from linux
Date: Fri, 27 Sep 2013 09:41:55 -0500
Message-ID: <20130927144155.GZ31476@beardog.cce.hp.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com> <20130923183401.19995.99662.stgit@beardog.cce.hp.com> <5245868B.4080900@redhat.com> <20130927133451.GY31476@beardog.cce.hp.com> <52458FBA.3010602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46746 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab3I0OmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2013 10:42:01 -0400
Content-Disposition: inline
In-Reply-To: <52458FBA.3010602@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com, scameron@beardog.cce.hp.com

On Fri, Sep 27, 2013 at 04:01:30PM +0200, Tomas Henzl wrote:
> On 09/27/2013 03:34 PM, scameron@beardog.cce.hp.com wrote:
> > On Fri, Sep 27, 2013 at 03:22:19PM +0200, Tomas Henzl wrote:
> >> On 09/23/2013 08:34 PM, Stephen M. Cameron wrote:
> >>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >>>
> >>> SCSI mid layer doesn't seem to handle logical drives undergoing format
> >>> very well.  scsi_add_device on such devices seems to result in hitting
> >>> those devices with a TUR at a rate of 3Hz for awhile, transitioning
> >>> to hitting them with a READ(10) at a much higher rate indefinitely,
> >>> and at boot time, this prevents the system from coming up.  If we
> >>> do not expose such devices to the kernel, it isn't bothered by them.
> >> Is the result of this patch that the drive is no more visible for the user
> >> and he can't follow the formatting progress? 
> > Yes (subsequent patch monitors the progress and brings the drive
> > online when it's ready).
> >
> >> I think a better option is to fix the kernel to handle formatting devices better
> > Yeah, you're probably right. (This is what comes of writing code for all
> > the distros then forward porting to kernel.org code.  Grumble-grumble-management
> > grumble-grumble real-world problems.)
> >
> >> or harden the hpsa so it can cope with TURs or reads (ignore) from a formatting
> >> device.
> > I don't think hpsa driver had any problem with the TURs or READs though,
> > they would be returned to the mid layer just fine (TUR returned sense data
> > indicating not ready, format in progress, I forget what the reads
> > returned, whatever the firmware filled in for the sense data, which
> > was reasonable), but the mid-layer was relentless and just never
> > really proceeded, iirc.
> >
> > Since we were trying to make this work on existing OSes where fixing the
> > SCSI mid layer wasn't an option, we came up with this.
> 
> I'm actually glad that you care about existing OSes :)

And the pain of porting would be much the same regardless of
whether the port is forward or backward, I suppose.

> 
> Do you know whether the midlayer has similar problems with other drivers?

No, not sure.   One thing that's a bit unusual about hpsa is it uses
the scan_start and scan_finished members of scsi_host_template, so hpsa
does its own scanning, rather than let the midlayer do the scanning which
is due to Smart Array's weirdness around the vicinity of SCSI_REPORT_LUNS.

I suspect that a lld driver calling scsi_add_device() on something which
is NOT READY/FORMAT IN PROGRESS is what provokes the trouble.  Most drivers
do not call scsi_add_device() directly at all, so it's quite possible most
drivers do not experience such a problem. A few do call scsi_add_device()
directly, like ipr or pmcraid, so these might conceivably have a similar
problem.  

We ran into this problem with what we call "Rapid Parity Initialization", which
is what you get when the RAID controller leaves the logical volume in a NOT
READY/FORMAT IN PROGRESS state and devotes itself entirely to initializing
parity data and when that's done, then the volume starts acting normally.  

Initializing the parity data can take quite a long time (hours), but not as
long as initializing it on the fly under load, which, with very large,
relatively slow drives can take nigh on forever, hence the "rapid" parity
initialization moniker.  So, if those other RAID controllers don't have a
similar feature that produces a relatively long lived NOT READY/FORMAT IN
PROGRESS state, they may not bump into the problem.

It has been awhile since I've tried letting the driver call scsi_add_device()
on a device which is undergoing Rapid Parity Initialization, so I need to try
that with current code and see how it behaves.  I haven't thought about how to
fix it within the SCSI mid layer (presuming it still doesn't behave well)
since previously we only concerned ourselves with avoiding provoking the
undesirable behavior.

-- steve

> 
> Tomas
> 
> >
> >> Also maybe a cmd_special_free is missing - see below
> > D'oh.  Ok, now that's just embarassing.  Thanks.
> >
> > -- steve
> >
> >> Cheers, Tomas
> >> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >> ---
> >>  drivers/scsi/hpsa.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >>  drivers/scsi/hpsa.h |    1 +
> >>  2 files changed, 49 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> >> index b7f405f..38e3af4 100644
> >> --- a/drivers/scsi/hpsa.c
> >> +++ b/drivers/scsi/hpsa.c
> >> @@ -1010,6 +1010,20 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
> >>  	for (i = 0; i < nsds; i++) {
> >>  		if (!sd[i]) /* if already added above. */
> >>  			continue;
> >> +
> >> +		/* Don't add devices which are NOT READY, FORMAT IN PROGRESS
> >> +		 * as the SCSI mid-layer does not handle such devices well.
> >> +		 * It relentlessly loops sending TUR at 3Hz, then READ(10)
> >> +		 * at 160Hz, and prevents the system from coming up.
> >> +		 */
> >> +		if (sd[i]->format_in_progress) {
> >> +			dev_info(&h->pdev->dev,
> >> +				"Logical drive format in progress, device c%db%dt%dl%d offline.\n",
> >> +				h->scsi_host->host_no,
> >> +				sd[i]->bus, sd[i]->target, sd[i]->lun);
> >> +			continue;
> >> +		}
> >> +
> >>  		device_change = hpsa_scsi_find_entry(sd[i], h->dev,
> >>  					h->ndevices, &entry);
> >>  		if (device_change == DEVICE_NOT_FOUND) {
> >> @@ -1715,6 +1729,34 @@ static inline void hpsa_set_bus_target_lun(struct hpsa_scsi_dev_t *device,
> >>  	device->lun = lun;
> >>  }
> >>  
> >> +static unsigned char hpsa_format_in_progress(struct ctlr_info *h,
> >> +		unsigned char scsi3addr[])
> >> +{
> >> +	struct CommandList *c;
> >> +	unsigned char *sense, sense_key, asc, ascq;
> >> +#define ASC_LUN_NOT_READY 0x04
> >> +#define ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS 0x04
> >> +
> >> +
> >> +	c = cmd_special_alloc(h);
> >> +	if (!c)
> >> +		return 0;
> >> +	fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
> >> +	hpsa_scsi_do_simple_cmd_core(h, c);
> >> +	sense = c->err_info->SenseInfo;
> >> +	sense_key = sense[2];
> >> +	asc = sense[12];
> >> +	ascq = sense[13];
> >> +	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
> >> +		c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
> >> +		sense_key == NOT_READY &&
> >> +		asc == ASC_LUN_NOT_READY &&
> >> +		ascq == ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS)
> >> +		return 1;
> >> return^ without cmd_special_free
> >>
> >> +	cmd_special_free(h, c);
> >> +	return 0;
> >> +}
> >> +
> >>  static int hpsa_update_device_info(struct ctlr_info *h,
> >>  	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
> >>  	unsigned char *is_OBDR_device)
> >> @@ -1753,10 +1795,14 @@ static int hpsa_update_device_info(struct ctlr_info *h,
> >>  		sizeof(this_device->device_id));
> >>  
> >>  	if (this_device->devtype == TYPE_DISK &&
> >> -		is_logical_dev_addr_mode(scsi3addr))
> >> +		is_logical_dev_addr_mode(scsi3addr)) {
> >>  		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
> >> -	else
> >> +		this_device->format_in_progress =
> >> +			hpsa_format_in_progress(h, scsi3addr);
> >> +	} else {
> >>  		this_device->raid_level = RAID_UNKNOWN;
> >> +		this_device->format_in_progress = 0;
> >> +	}
> >>  
> >>  	if (is_OBDR_device) {
> >>  		/* See if this is a One-Button-Disaster-Recovery device
> >> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> >> index bc85e72..4fd0d45 100644
> >> --- a/drivers/scsi/hpsa.h
> >> +++ b/drivers/scsi/hpsa.h
> >> @@ -46,6 +46,7 @@ struct hpsa_scsi_dev_t {
> >>  	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
> >>  	unsigned char model[16];        /* bytes 16-31 of inquiry data */
> >>  	unsigned char raid_level;	/* from inquiry page 0xC1 */
> >> +	unsigned char format_in_progress;
> >>  };
> >>  
> >>  struct reply_pool {
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
