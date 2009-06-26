From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] mechanism for multipath to pass information to
	hardware handler
Date: Fri, 26 Jun 2009 12:45:09 -0700
Message-ID: <1246045509.14164.33.camel@chandra-ubuntu>
References: <1245863681.8709.135.camel@eddie-laptop>
	 <1246043447.3925.64.camel@mulgrave.site>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60880 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbZFZTmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2009 15:42:51 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5QJde5T000691
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 13:39:40 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5QJgqRD239550
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 13:42:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5QJgpZF024595
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 13:42:52 -0600
In-Reply-To: <1246043447.3925.64.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Christie <mchristi@redhat.com>, Edward Goggin <egoggin@vmware.com>, "Benoit, Arthur" <Benoit_Arthur@emc.com>, asson_ronald <asson_ronald@emc.com>, berthiaume_wayne <berthiaume_wayne@emc.com>

Yes, Mike Christie and I were aware of this and it was one of the issue
we were trying to resolve before we pushed scsi_dh interface upstream.
(It is little complicated as we need the parameters to be set per
vendor-product tuple).

The original code I ported to scsi_dh interface was from Ed Goggin(who
was working for EMC then). IIRC, he was also aware of this issue.

When we pushed scsi_dh interface, we did get few of the EMC folks (on
Cc) to review/test the code and they did, and this issue was not seen as
a problem. 

We wanted to get back to that issue sometime later, got busy with other
things, and it disappeared from my list of things-to-do as the
regression was not seen as an issue (till now :)... I will get back to
it.

chandra

On Fri, 2009-06-26 at 14:10 -0500, James Bottomley wrote:
> On Wed, 2009-06-24 at 13:14 -0400, Eddie Williams wrote:
> > I notice in scsi_dh_emc.c that there is a comment:
> > 
> > TODO: need some interface so we can set trespass values
> > 
> > I don't see where any such interface has been developed or even any
> > discussion on the different mailing lists to create such an interface.
> > Did I miss something?
> > 
> > As it stands now there is no way that I can see to have the emc hardware
> > handler support the "honor trespass" feature short of recompiling the
> > module forcing the flag to be set.  This leaves a feature that worked in
> > earlier versions of multipath not working now.
> 
> OK so as I understand it that means that the line
> 
> hardware handler "1 emc 0 1"
> 
> now fails to function correctly because dm-emc no longer exists.  That
> makes this a functionality regression from 2.6.26 because of this
> commit:
> 
> 
> commit cb520223d7f22c5386aff27a5856a66e2c32aaac
> Author: Chandra Seetharaman <sekharan@us.ibm.com>
> Date:   Thu May 1 14:50:34 2008 -0700
> 
>     [SCSI] scsi_dh: Remove hardware handlers from dm
>     
>     This patch removes the 3 hardware handlers that currently exist
>     under dm as the functionality is moved to SCSI layer in the earlier
>     patches.
> 
> Because we haven't actually moved all the functionality.
> 
> James
> 
> 
> 

