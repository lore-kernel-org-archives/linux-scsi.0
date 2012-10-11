From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] [SCSI] pm: use callbacks from dev_pm_ops for scsi
 devices
Date: Thu, 11 Oct 2012 16:09:37 +0800
Message-ID: <20121011080935.GA1819@mint-spring.sh.intel.com>
References: <1349854086-2502-2-git-send-email-aaron.lu@intel.com>
 <Pine.LNX.4.44L0.1210101414570.1170-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab2JKIJl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2012 04:09:41 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1210101414570.1170-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Wed, Oct 10, 2012 at 02:32:13PM -0400, Alan Stern wrote:
> On Wed, 10 Oct 2012, Aaron Lu wrote:
> 
> > +static int run_dev_callback(struct device *dev, pm_message_t mesg)
> > +{
> > +	int ret;
> > +
> > +	switch (mesg.event) {
> > +		case PM_EVENT_SUSPEND:
> > +			ret = pm_generic_suspend(dev);
> > +			break;
> > +		case PM_EVENT_RESUME:
> > +			ret = pm_generic_resume(dev);
> > +			break;
> > +		case PM_EVENT_FREEZE:
> > +			ret = pm_generic_freeze(dev);
> > +			break;
> > +		case PM_EVENT_THAW:
> > +			ret = pm_generic_thaw(dev);
> > +			break;
> > +		case PM_EVENT_HIBERNATE:
> > +			ret = pm_generic_poweroff(dev);
> > +			break;
> > +		case PM_EVENT_RESTORE:
> > +			ret = pm_generic_restore(dev);
> > +			break;
> > +		case PM_EVENT_AUTO_SUSPEND:
> > +			ret = pm_generic_runtime_suspend(dev);
> > +			break;
> > +		case PM_EVENT_AUTO_RESUME:
> > +			ret = pm_generic_runtime_resume(dev);
> > +			break;
> > +		default:
> > +			ret = -1;
> > +			break;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> > @@ -115,23 +145,40 @@ static int scsi_bus_suspend(struct device *dev)
> >  	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
> >  }
> >  
> > +static int scsi_bus_resume(struct device *dev)
> > +{
> > +	return scsi_bus_resume_common(dev, PMSG_RESUME);
> > +}
> > +
> >  static int scsi_bus_freeze(struct device *dev)
> >  {
> >  	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
> >  }
> >  
> > +static int scsi_bus_thaw(struct device *dev)
> > +{
> > +	return scsi_bus_resume_common(dev, PMSG_THAW);
> > +}
> > +
> >  static int scsi_bus_poweroff(struct device *dev)
> >  {
> >  	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
> >  }
> >  
> > +static int scsi_bus_restore(struct device *dev)
> > +{
> > +	return scsi_bus_resume_common(dev, PMSG_RESTORE);
> > +}
> > +
> 
> This is just dumb.  Do the parts that depend on the event type here, in 
> these routines, instead of using a big "switch" statement somewhere 
> else.  For example, have these routines figure out which callback 
> routine or generic routine to use, and pass that pointer to 
> scsi_bus_{suspend,resume}_common() instead of the PMSG_* argument.

Updated in v2, please take a look.

> 
> One thing may help simplify the conversion (you can do this in a
> separate patch).  Linus's current git tree contains a new commit
> 88d26136a256576e444db312179e17af6dd0ea87 (PM: Prevent runtime suspend
> during system resume) which makes some of the code in scsi_pm.c
> unnecessary.  The following two commits can now be reverted:
> 
> 	33a2285d96b5e7b9500612ec623bf4313397bb53
> 	[SCSI] scsi_pm: set device runtime state before parent suspended
> 
> 	28fd00d42cca178638f51c08efa986a777c24a4b
> 	[SCSI] runtime resume parent for child's system-resume
> 
> This will reduce the amount of code you need to worry about.

Yes, thanks for the info.

-Aaron

