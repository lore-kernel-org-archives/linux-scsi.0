From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 4/7] scsi_dh: add EMC Clariion device handler
Date: Tue, 22 Apr 2008 16:45:53 -0700
Message-ID: <1208907953.1025.235.camel@chandra-ubuntu>
References: <20080416011818.19580.41106.sendpatchset@chandra-ubuntu>
	 <20080416011842.19580.92056.sendpatchset@chandra-ubuntu>
	 <4806294C.9090703@cs.wisc.edu> <1208390384.1025.40.camel@chandra-ubuntu>
	 <48078571.9040806@cs.wisc.edu> <1208898559.1025.191.camel@chandra-ubuntu>
	 <480E5D08.3000905@cs.wisc.edu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36833 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYDVXpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 19:45:24 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3MNjLxN025231
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 19:45:21 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3MNjLWY239594
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 19:45:21 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3MNjKWZ028980
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 19:45:21 -0400
In-Reply-To: <480E5D08.3000905@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, andmike@us.ibm.com, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com, berthiaume_wayne@emc.com


On Tue, 2008-04-22 at 16:47 -0500, Mike Christie wrote:
<snip>
> > wait
> > ******************************************************
> > Simple Run:
> > 
> > with patchset:		2.6.25-mm1:
> > real    3m30.122s	real    3m29.746s
> > user    0m4.069s	user    0m4.099s
> > sys     0m14.876s	sys     0m14.535s
> > -----------------------------------------------
> 
> Is this just a boot up test or a test just running IO but no 
> failback/failover?

Test running IO but no failover/failback.

> 
> > 
> > Failover Run:
> > 
> > with patchset:		2.6.25-mm1:
> > real    5m18.875s	real    5m31.741s
> > user    0m4.069s	user    0m3.883s
> > sys     0m14.838s	sys     0m13.822s
> 
> Ehh, I have no idea if this is good or bad. Does it mean it is talking 
> 13 more seconds to complete?

It is taking 13 more seconds without the serialization :) (i.e the old
code).

> 
> Have you seen the type of thread on dm-devel or the iscsi list where 
> people are concerned with getting the time the failure is detected to 
> the time IO is running on a new path down from something like 10 to 5

I totally agree with you that shaving a second here and a second there
has lot of value to the customers.
>  
> seconds. One time the iscsi driver did not implement time2wait correctly 
> and by fixing it we shaved only 2 seconds off and users were very happy 
> with the extra 2 seconds. We added the nop timer stuff so we could get 
> faster failovers. We have the fast io fail tmo so we can speed up the 
> process even more. Shaving off a second here or there is really nitpicky 
> and if I were you I would give me the middle finger :) It just seems

But, I wouldn't :)
>  
> like people expect better performance from this type of error.
> 
> If my comment is too nitpicky then I am fine with ignoring this for now. 
> We just have to fix the emc short/long tress pass code then. I added 
> another EMC guy to the thread so he can ping the other EMC devs to get 
> going (I had sent them questions on how to handle it and have not got a 
> response).

