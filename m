From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 2/3] scsi_dh: Provide set_params interface in emc
	device handler
Date: Mon, 20 Jul 2009 18:02:00 -0700
Message-ID: <1248138120.10481.37.camel@chandra-ubuntu>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	 <20090702031320.28354.96958.sendpatchset@chandra-ubuntu>
	 <1248094813.6307.10.camel@eddie-laptop>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:41651 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZGUA7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2009 20:59:10 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6L0vx5M029286
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2009 18:57:59 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6L0wlUA254114
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2009 18:58:47 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6L0wkQH025548
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2009 18:58:46 -0600
In-Reply-To: <1248094813.6307.10.camel@eddie-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@steeleye.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com


I will reroll the patch with this fix and ported to the latest RC.
On Mon, 2009-07-20 at 09:00 -0400, Eddie Williams wrote:
> On Wed, 2009-07-01 at 20:13 -0700, Chandra Seetharaman wrote:
> > Handle the parameters provided by user thru multipath.
> > 
> > This handler expects only 2 parameters and their value can either be 0 or 1.
> > 
> > This code originates from the old dm-emc.c file. Appropriate changes have
> > been made to make it work in the new design.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  drivers/scsi/device_handler/scsi_dh_emc.c |   56 ++++++++++++++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> > 
> > Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
> > ===================================================================
> > --- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh_emc.c
> > +++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
> > @@ -561,6 +561,61 @@ done:
> >  
> >  	return result;
> >  }
> > +/*
> > + * params - parameters in the following format
> > + *      "no_of_params\0param1\0param2\0param3\0...\0"
> > + *      for example, string for 2 parameters with value 10 and 21
> > + *      is specified as "2\010\021\0".
> > + */
> > +static int clariion_set_params(struct scsi_device *sdev, const char *params)
> > +{
> > +	struct clariion_dh_data *csdev = get_clariion_data(sdev);
> > +	unsigned int hr = 0, st = 0, argc;
> > +	char *p = params;
> 
> This throws a compiler warning resolved with a type cast:
> 	char *p = (char *)params;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

