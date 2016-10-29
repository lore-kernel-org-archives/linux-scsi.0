From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Sat, 29 Oct 2016 02:12:32 +0200
Message-ID: <20161029001232.qbrga5kp3nk6fb7h@linux-x5ow.site>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
 <20161027094634.fifk7wd43vyu64bd@linux-x5ow.site>
 <72f0f8f4-d08e-547d-6c40-f56916b31e7d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938771AbcJ2AM7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 20:12:59 -0400
Content-Disposition: inline
In-Reply-To: <72f0f8f4-d08e-547d-6c40-f56916b31e7d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Oct 27, 2016 at 08:38:03AM -0700, Bart Van Assche wrote:
> On 10/27/2016 02:46 AM, Johannes Thumshirn wrote:
> > On Wed, Oct 26, 2016 at 11:44:51AM -0700, Bart Van Assche wrote:
> > > +static void scsi_remove_device_async(struct scsi_device *sdev)
> > > +{
> > > +	if (scsi_device_get(sdev) < 0)
> > 
> > Nit: the < 0 could be dropped, scsi_device_get returns either -ENXIO or
> > 0. But no reason to respin.
> > 
> > Anyways,
> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> Hello Johannes,
> 
> Thanks for the review. But I'd like to clarify that I added the "< 0" on
> purpose. Some *_get*() functions in the Linux kernel return 0 upon failure
> (e.g. kref_get_unless_zero()) and others a negative value (e.g.
> scsi_device_get()). The "< 0" part avoids that someone who reads this code
> has to look up what return value convention scsi_device_get() uses.

OK, that makes sense to me.

	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
