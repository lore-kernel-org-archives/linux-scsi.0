From: <brking@charter.net>
Subject: RE: [patch 1/1] megaraid: Add support for change_queue_depth
Date: Thu, 6 Jul 2006 20:22:06 -0700
Message-ID: <548093187.1152242526772.JavaMail.root@fepweb10>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf02.cluster1.charter.net ([209.225.28.202]:25274 "EHLO
	mxsf02.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S1751166AbWGGDWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 23:22:08 -0400
Received: from mxip06a.cluster1.charter.net (mxip06a.cluster1.charter.net [209.225.28.136])
	by mxsf02.cluster1.charter.net (8.12.11/8.12.11) with ESMTP id k673M6bb008866
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 23:22:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kolli, Neela" <Neela.Kolli@engenio.com>, "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: linux-scsi@vger.kernel.org

---- "Ju wrote: 
> Hi,
> Wednesday, July 05, 2006 6:00 PM, brking wrote:
> > Adds support for change_queue_depth so that device
> > queue depth can be changed at runtime through sysfs. 
> Can you share any reason to have queue depth chanaged at runtime?
> It is set with MBOX_MAX_SCSI_CMDS at driver attach.

For my own purposes, I've been wanting to try different max queue depths to see how it affects my overall performance when memory is fragmented after the system has been up for a while, so rebooting to try a different queue depth doesn't help me much. 

Brian


> 
> Thank you,
> 
> Seokmann
> 
> > -----Original Message-----
> > From: brking@charter.net [mailto:brking@charter.net] 
> > Sent: Wednesday, July 05, 2006 6:00 PM
> > To: Kolli, Neela
> > Cc: Ju, Seokmann; linux-scsi@vger.kernel.org; brking@charter.net
> > Subject: [patch 1/1] megaraid: Add support for change_queue_depth
> > 
> > 
> > Adds support for change_queue_depth so that device
> > queue depth can be changed at runtime through sysfs.
> > 
> > Signed-off-by: <brking@charter.net>
> > ---
> > 
> > 
> > diff -puN 
> > drivers/scsi/megaraid/megaraid_mbox.c~megaraid_change_queue_de
> > pth drivers/scsi/megaraid/megaraid_mbox.c
> > --- 
> > linux-2.6/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_chang
> > e_queue_depth	2006-07-05 14:00:04.000000000 -0500
> > +++ linux-2.6-brking/drivers/scsi/megaraid/megaraid_mbox.c	
> > 2006-07-05 16:53:36.000000000 -0500
> > @@ -330,6 +330,21 @@ static struct device_attribute *megaraid
> >  	NULL,
> >  };
> >  
> > +/**
> > + * megaraid_change_queue_depth - Change the device's queue depth
> > + * @sdev:	scsi device struct
> > + * @qdepth:	depth to set
> > + *
> > + * Return value:
> > + * 	actual depth set
> > + **/
> > +static int megaraid_change_queue_depth(struct scsi_device 
> > *sdev, int qdepth)
> > +{
> > +	if (qdepth > MBOX_MAX_SCSI_CMDS)
> > +		qdepth = MBOX_MAX_SCSI_CMDS;
> > +	scsi_adjust_queue_depth(sdev, 0, qdepth);
> > +	return sdev->queue_depth;
> > +}
> >  
> >  /*
> >   * Scsi host template for megaraid unified driver
> > @@ -343,6 +358,7 @@ static struct scsi_host_template megarai
> >  	.eh_device_reset_handler	= megaraid_reset_handler,
> >  	.eh_bus_reset_handler		= megaraid_reset_handler,
> >  	.eh_host_reset_handler		= megaraid_reset_handler,
> > +	.change_queue_depth		= megaraid_change_queue_depth,
> >  	.use_clustering			= ENABLE_CLUSTERING,
> >  	.sdev_attrs			= megaraid_sdev_attrs,
> >  	.shost_attrs			= megaraid_shost_attrs,
> > _
> > 
