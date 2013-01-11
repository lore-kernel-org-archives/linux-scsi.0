From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v12 7/9] libata: scsi: no poll when ODD is powered off
Date: Fri, 11 Jan 2013 10:11:10 +0800
Message-ID: <20130111021110.GB26270@aaronlu.sh.intel.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-8-git-send-email-aaron.lu@intel.com>
 <20130110195610.GL20454@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130110195610.GL20454@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 10, 2013 at 11:56:10AM -0800, Tejun Heo wrote:
> On Thu, Jan 10, 2013 at 05:24:28PM +0800, Aaron Lu wrote:
> > @@ -182,6 +182,13 @@ void zpodd_enable_run_wake(struct ata_device *dev)
> >  {
> >  	struct zpodd *zpodd = dev->zpodd;
> >  
> > +	/*
> > +	 * Silence the media change poll, as we will be notified when
> > +	 * user wants to use the ODD so there is no meaning to poll
> > +	 * it when it is powered off
> > +	 */
> > +	dev->sdev->disable_disk_events = true;
> 
> What's the synchronization rule for this field?

I documented the rule in include/scsi/scsi_device.h.

This field is modified in the ata port's runtime suspend and resume
callback, and is read accessed in the check_events callback of the sr
block driver. The runtime PM callback is synchronized by PM core, in
that the two callbacks will never run concurrently. So I guess saying
synchronized by PM core is enough for this field?

This is what I've added in v12 for scsi_device structure:

+	bool disable_disk_events; /* disable poll for disk events, used in
+				   * ATA layer, sychronized by PM core */
+

Or do you mean I should add a comment explaining the sync rule when it
is modifed, like in the above code?

Thanks,
Aaron

> 
> Thanks.
> 
> -- 
> tejun
