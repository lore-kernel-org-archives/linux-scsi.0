From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [dm-devel] [PATCH 3/3] scsi_dh: rdac handler: Batch up MODE
	SELECTsand send few of them
Date: Mon, 14 Sep 2009 12:25:03 -0700
Message-ID: <1252956303.2541.24.camel@chandra-ubuntu>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
	 <20090428025248.11108.38596.sendpatchset@chandra-ubuntu>
	 <4A02580A.2060704@cs.wisc.edu> <1241742975.27327.3.camel@chandra-ubuntu>
	 <46A00B48CC54E4468EF6911F877AC4CA02579491@blrx3m10.blr.amer.dell.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:52470 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZINTYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 15:24:51 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8EJKvsX014051
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2009 13:20:57 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8EJOqEO223048
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2009 13:24:53 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8EJOqKL014590
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2009 13:24:52 -0600
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CA02579491@blrx3m10.blr.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Yanqing_Liu@Dell.com, Jordan_Hargrave@Dell.com

Hi Shyam,

As per Mike (Christie)'s suggestion I am working on getting all the
hardware handlers to do async pg_init(), EMC handler is getting little
cumbersome. Working on it. Will try to post the set of patches by end of
week.

Testing and reporting the same (for as many hardware handler as
possible) would certainly help these get accepted (of course after I
post them :)....

chandra
On Sat, 2009-09-12 at 09:39 +0530, Shyam_Iyer@Dell.com wrote:
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> > On Behalf Of Chandra Seetharaman
> > Sent: Friday, May 08, 2009 6:06 AM
> > To: Mike Christie
> > Cc: device-mapper development; linux-scsi@vger.kernel.org
> > Subject: Re: [dm-devel] [PATCH 3/3] scsi_dh: rdac handler: Batch up
> > MODE SELECTsand send few of them
> > 
> > 
> > On Wed, 2009-05-06 at 22:39 -0500, Mike Christie wrote:
> > > Chandra Seetharaman wrote:
> > > >  }
> > > >
> > > > -static int rdac_activate(struct scsi_device *sdev,
> > activate_complete fn, void *data)
> > > > +static int queue_mode_select(struct scsi_device *sdev,
> > > > +				activate_complete fn, void *data)
> > > > +{
> > > > +	struct rdac_queue_data *qdata;
> > > > +	struct rdac_controller *ctlr;
> > > > +
> > > > +	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> > >
> > >
> > > I think you want to use GFP_NOIO or GFP_ATOMIC here. If GFP_NOIO can
> > > block and screw up other devices using that multipathd workqueue
> > struct
> > > maybe GFP_ATOMIC would be best since we can have dm-mpath retry
> > later.
> > 
> > Will do.
> > 
> > Thanks
> > >
> 
> Chandra - Thanks for doing this. How can we help here to get this
> upstream?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

