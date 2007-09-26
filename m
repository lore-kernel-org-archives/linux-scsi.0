From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] fix leftover from default sdev attribute switch
Date: Wed, 26 Sep 2007 20:32:00 +0200
Message-ID: <1190831520.3773.79.camel@lov.localdomain>
References: <1190829289.3773.74.camel@lov.localdomain>
	 <1190831039.3359.69.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:46036 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbXIZSbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 14:31:46 -0400
In-Reply-To: <1190831039.3359.69.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2007-09-26 at 13:23 -0500, James Bottomley wrote:
> On Wed, 2007-09-26 at 19:54 +0200, Kay Sievers wrote:
> > Hi James,
> > seems we miss the following fix in the current tree.
> > 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: [SCSI] fix scsi_is_sdev_device() after switch to default sdev attributes
> > 
> > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > ---
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 0088c4d..8e880ef 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -995,7 +995,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
> >  
> >  int scsi_is_sdev_device(const struct device *dev)
> >  {
> > -	return dev->release == scsi_device_dev_release;
> > +	return dev->type == &scsi_dev_type;
> 
> This will make the check different from all the others in the
> mid-layer ... is there any reason to change it?

The release function moved to device_type, so the "hack" with checking
for the release pointer at the device doesn't work anymore. With Hannes'
patches here on the list, the target and host will get device_type too,
and the same way of matching.

Kay

