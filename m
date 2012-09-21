From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 3/6] scsi: sr: support zero power ODD(ZPODD)
Date: Fri, 21 Sep 2012 09:39:18 +0800
Message-ID: <20120921013917.GB2142@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
 <1347438597-5903-4-git-send-email-aaron.lu@intel.com>
 <201209210007.23494.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab2IUBjV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 21:39:21 -0400
Content-Disposition: inline
In-Reply-To: <201209210007.23494.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Fri, Sep 21, 2012 at 12:07:23AM +0200, Rafael J. Wysocki wrote:
> On Wednesday, September 12, 2012, Aaron Lu wrote:
> >  static struct scsi_driver sr_template = {
> >  	.owner			= THIS_MODULE,
> > @@ -87,6 +89,8 @@ static struct scsi_driver sr_template = {
> >  		.name   	= "sr",
> >  		.probe		= sr_probe,
> >  		.remove		= sr_remove,
> > +		.suspend        = sr_suspend,
> > +		.resume         = sr_resume,
> >  	},
> >  	.done			= sr_done,
> >  };
> > @@ -172,6 +176,52 @@ static void scsi_cd_put(struct scsi_cd *cd)
> >  	mutex_unlock(&sr_ref_mutex);
> >  }
> 
> Besides, I need some help to understand how this is supposed to work.
> 
> Do I think correctly that sr_suspend(), for example, will be run by the
> SCSI bus type layer in case of a CD device runtime suspend?  However,

Yes.

> won't this routine be used during system suspend as well and won't it cause
> problems to happen if so?

On system suspend, nothing needs to be done.
I'll add the following code in next version.

	if (!PMSG_IS_AUTO(msg))
		return 0;

Thanks,
Aaron

