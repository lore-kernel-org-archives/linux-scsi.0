From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
 sysfs
Date: Fri, 10 Apr 2009 05:08:54 +0000
Message-ID: <1239340134.19984.276.camel@grinch>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	 <20090409215226.8b03bc2b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27767 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbZDJFI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2009 01:08:58 -0400
In-Reply-To: <20090409215226.8b03bc2b.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, mike.miller@hp.com

On Thu, 2009-04-09 at 21:52 -0700, Andrew Morton wrote:
> On Tue, 7 Apr 2009 13:04:11 -0500 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > Patch 1 of 1 resubmit
> > 
> > cciss: add cciss driver sysfs entries
> > 
> > This patch adds sysfs entries to the cciss driver needed for the
> > dm/multipath tools. A file for vendor, model, rev, and unique_id are
> > added for each logical drive under directory
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
> > host) number and Y is the logical drive number. A link from
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
> > /sys/block/cciss!cXdY/device is also created.
> > 
> > ...
> >
> > +static ssize_t dev_show_model(struct device *dev,
> > +			      struct device_attribute *attr,
> > +			      char *buf)
> > +{
> > +	drive_info_struct *drv = to_drv(dev);
> > +	struct ctlr_info *h = to_hba(drv->dev.parent);
> > +	char model[MODEL_LEN + 1];
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> > +	if (h->busy_configuring)
> > +		ret = -EBUSY;
> > +	else
> > +		memcpy(model, drv->model, MODEL_LEN + 1);
> > +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> > +
> > +	if (ret)
> > +		return ret;
> > +	else
> > +		return snprintf(buf, MODEL_LEN + 2, "%s\n", drv->model);
> 
> Isn't the buffer sizing wrong here?  Should be MODEL_LEN+1.
> 

Don't we need space for the '\0' and the '\n'?

> > +}
> > +DEVICE_ATTR(model, S_IRUGO, dev_show_model, NULL);
> > +
> > +static ssize_t dev_show_rev(struct device *dev,
> > +			    struct device_attribute *attr,
> > +			    char *buf)
> > +{
> > +	drive_info_struct *drv = to_drv(dev);
> > +	struct ctlr_info *h = to_hba(drv->dev.parent);
> > +	char rev[REV_LEN + 1];
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> > +	if (h->busy_configuring)
> > +		ret = -EBUSY;
> > +	else
> > +		memcpy(rev, drv->rev, REV_LEN + 1);
> > +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> > +
> > +	if (ret)
> > +		return ret;
> > +	else
> > +		return snprintf(buf, REV_LEN + 2, "%s\n", drv->rev);
> 
> Repeated in various places.
> 
> > +}


