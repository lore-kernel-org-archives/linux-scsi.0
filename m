From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 2/3] scsi_dh: Remove the workqueue
	usedforactivate
Date: Thu, 07 May 2009 22:25:34 -0700
Message-ID: <1241760334.17612.3.camel@chandra-ubuntu>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
	 <20090428025242.11108.43024.sendpatchset@chandra-ubuntu>
	 <4A02565B.9060105@cs.wisc.edu><1241742949.27327.1.camel@chandra-ubuntu>
	 <4A03A278.2080105@cs.wisc.edu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:37290 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZEHFZO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2009 01:25:14 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e37.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n485OepJ012730
	for <linux-scsi@vger.kernel.org>; Thu, 7 May 2009 23:24:40 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n485PEsx208948
	for <linux-scsi@vger.kernel.org>; Thu, 7 May 2009 23:25:14 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n485PDJE008170
	for <linux-scsi@vger.kernel.org>; Thu, 7 May 2009 23:25:14 -0600
In-Reply-To: <4A03A278.2080105@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org


On Thu, 2009-05-07 at 22:09 -0500, Mike Christie wrote:
> Chandra Seetharaman wrote:
> > On Wed, 2009-05-06 at 22:32 -0500, Mike Christie wrote:
> >> Chandra Seetharaman wrote:
> >>> Since scsi_dh_activate() has become an asynchronous function,
> >>> we do not need a workqueue for submitting scsi_dh_activate().
> >>>
> >>> This patch just removes the workqueue that submits scsi_dh_activate().
> >>>
> >> Before this is merged, we need to convert the other device handlers to 
> >> use blk_execute_rq_nowait or use their own workqueue_struct right?
> > 
> > If we want those modules also behave async, then yes.
> > 
> > But, this set of 3 patches would work fine as I made the relevant
> > changes to those modules so that they work properly.
> >  
> 
> What was the point of the workqueue?
> 
> I think if you merged the patch and left the other modules as is you 
> would hit a problem where the multipathd work queue struct thread is 
> busy waiting on activate commands when it should be routing IO to paths 
> that do not need a activate.

I am sorry for not being clear. As I mentioned in my original posting, I
am working on making the other modules also async. WIll be posting those
patches in a day or two. May be I will resubmit this set (with your
suggestion for GFP_NOIO) along with those.

In my reply (above), I was just trying to say that these set of patches
work (with the caveat you noted).

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

