From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Mon, 23 Mar 2009 15:13:49 -0700
Message-ID: <1237846429.14853.6.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	 <1237403902.14147.25.camel@chandra-ubuntu>
	 <1237488880.26341.15.camel@chandra-ubuntu>  <49C3DF49.8050408@redhat.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38960 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZCWWKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2009 18:10:44 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2NM9LSk032332
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2009 16:09:21 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2NMAfqc198330
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2009 16:10:42 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2NMAf14002422
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2009 16:10:41 -0600
In-Reply-To: <49C3DF49.8050408@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

Hi James,

Are your concerns answered with Peter's response ?

Or, changes are required for the patches I posted ?

Thanks and regards,

chandra
On Fri, 2009-03-20 at 14:24 -0400, Peter Jones wrote:
> On 03/19/2009 02:54 PM, Chandra Seetharaman wrote:
> > On Wed, 2009-03-18 at 12:18 -0700, Chandra Seetharaman wrote:
> >> On Wed, 2009-03-18 at 19:30 +0100, Kay Sievers wrote:
> >>> On Wed, Mar 18, 2009 at 02:36, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> >>>> From: Peter Jones <pjones@redhat.com>
> >>>>
> >>>> This patch allows the use of modaliases on scsi targets to correctly
> >>>> load scsi device handler modules when the devices are found.
> >>>> +++ linux-2.6.28/include/linux/mod_devicetable.h
> >>>> @@ -454,4 +454,10 @@ struct dmi_system_id {
> >>>>
> >>>>  #define DMI_MATCH(a, b)        { a, b }
> >>>>
> >>>> +struct scsi_dh_device_id {
> >>>> +       unsigned char type;
> >>>> +       char vendor[9];
> >>>> +       char model[17];
> >>>> +};
> >>> Doesn't the static array waste space, when used for the long lists of
> >>> entries stuffed in arrays of this structure? It will carry a lot of \0
> >>> chars, and identical strings can not be de-duplicated by the compiler,
> >>> unlike when pointers are used?
> >>>
> >> I had some problems when we used the pointers instead of arrays. Don't
> >> recall it now.
> >>
> >> Will retry and report.
> > 
> > Hi Kay,
> > 
> > I tried it and realized modpost is what is giving the problem.
> > 
> > When the array for vendor and model is changed to pointers, modpost (at
> > the end of make modules) dies with a segmentation fault. 
> > 
> > Peter, Any details that you can provide ?
> 
> In this case, the tail wags the dog -- it's a string instead of a pointer basicallly so that the new bits in file2alias.c can look like the other parts of that same file.  It's sortof inconvenient for them to be pointers in there...
> 

