From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Round II on sysfs attributes
Date: 23 May 2003 15:43:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053718992.1810.29.camel@mulgrave>
References: <1053707904.1810.4.camel@mulgrave>
	<20030523185150.GB1160@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:7686 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264153AbTEWTaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 15:30:19 -0400
In-Reply-To: <20030523185150.GB1160@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-05-23 at 14:51, Mike Anderson wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> >  static void scsi_device_release(struct device *dev)
> > @@ -287,9 +290,9 @@
> >  	if (error)
> >  		return error;
> >  
> > -	for (i = 0; !error && i < ARRAY_SIZE(sdev_attrs); i++)
> > +	for (i = 0; !error && sdev->host->hostt->sdev_attrs[i] != NULL; i++)
> >  		error = device_create_file(&sdev->sdev_driverfs_dev,
> > -					   sdev_attrs[i]);
> > +					   sdev->host->hostt->sdev_attrs[i]);
> >  
> >  	if (error)
> >  		scsi_device_unregister(sdev);
> 
> What about this style of bounds check.
> for (i = 0; !error && sdev->host->hostt->sdev_attrs[i]; i++)

It's just personal, but I prefer the explicit check against an object
rather than relying on the promotional to logical value rules.  I don't
see that it matters much either way.


> kfree of this memory in driver?

Yes, tricky issue.  I'd really rather it be done at template release
time (which we don't have) since we've sort of moved away from template
register/unregister.

I don't like an explicit kfree in the driver since I was trying to hide
the memory manipluations from the LLDs.  I suppose we could make the
model per host, rather than per template and use the add/remove host
interfaces, but this property is really a per template property. I'm
open to suggestions.

James


