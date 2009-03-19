From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Thu, 19 Mar 2009 11:54:40 -0700
Message-ID: <1237488880.26341.15.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	 <1237403902.14147.25.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:51818 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZCSSvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 14:51:50 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2JIlJmM029872
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2009 12:47:19 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2JIpmAd206546
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2009 12:51:48 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2JIph3t010606
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2009 12:51:47 -0600
In-Reply-To: <1237403902.14147.25.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@hansenpartnership.com


On Wed, 2009-03-18 at 12:18 -0700, Chandra Seetharaman wrote:
> On Wed, 2009-03-18 at 19:30 +0100, Kay Sievers wrote:
> > On Wed, Mar 18, 2009 at 02:36, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> > > From: Peter Jones <pjones@redhat.com>
> > >
> > > This patch allows the use of modaliases on scsi targets to correctly
> > > load scsi device handler modules when the devices are found.
> > > +++ linux-2.6.28/include/linux/mod_devicetable.h
> > > @@ -454,4 +454,10 @@ struct dmi_system_id {
> > >
> > >  #define DMI_MATCH(a, b)        { a, b }
> > >
> > > +struct scsi_dh_device_id {
> > > +       unsigned char type;
> > > +       char vendor[9];
> > > +       char model[17];
> > > +};
> > 
> > Doesn't the static array waste space, when used for the long lists of
> > entries stuffed in arrays of this structure? It will carry a lot of \0
> > chars, and identical strings can not be de-duplicated by the compiler,
> > unlike when pointers are used?
> > 
> 
> I had some problems when we used the pointers instead of arrays. Don't
> recall it now.
> 
> Will retry and report.

Hi Kay,

I tried it and realized modpost is what is giving the problem.

When the array for vendor and model is changed to pointers, modpost (at
the end of make modules) dies with a segmentation fault. 

Peter, Any details that you can provide ?

> > Thanks,
> > Kay
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

