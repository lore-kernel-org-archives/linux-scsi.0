From: <Shyam_Iyer@Dell.com>
Subject: RE: [dm-devel] [PATCH 3/3] scsi_dh: rdac handler: Batch up MODE SELECTsand send few of them
Date: Sat, 12 Sep 2009 09:39:57 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CA02579491@blrx3m10.blr.amer.dell.com>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu><20090428025248.11108.38596.sendpatchset@chandra-ubuntu><4A02580A.2060704@cs.wisc.edu> <1241742975.27327.3.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:7011 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZILEKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Sep 2009 00:10:01 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1241742975.27327.3.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com, dm-devel@redhat.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Yanqing_Liu@Dell.com, Jordan_Hargrave@Dell.com

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Chandra Seetharaman
> Sent: Friday, May 08, 2009 6:06 AM
> To: Mike Christie
> Cc: device-mapper development; linux-scsi@vger.kernel.org
> Subject: Re: [dm-devel] [PATCH 3/3] scsi_dh: rdac handler: Batch up
> MODE SELECTsand send few of them
> 
> 
> On Wed, 2009-05-06 at 22:39 -0500, Mike Christie wrote:
> > Chandra Seetharaman wrote:
> > >  }
> > >
> > > -static int rdac_activate(struct scsi_device *sdev,
> activate_complete fn, void *data)
> > > +static int queue_mode_select(struct scsi_device *sdev,
> > > +				activate_complete fn, void *data)
> > > +{
> > > +	struct rdac_queue_data *qdata;
> > > +	struct rdac_controller *ctlr;
> > > +
> > > +	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> >
> >
> > I think you want to use GFP_NOIO or GFP_ATOMIC here. If GFP_NOIO can
> > block and screw up other devices using that multipathd workqueue
> struct
> > maybe GFP_ATOMIC would be best since we can have dm-mpath retry
> later.
> 
> Will do.
> 
> Thanks
> >

Chandra - Thanks for doing this. How can we help here to get this
upstream?
