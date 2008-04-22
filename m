From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 4/7] scsi_dh: add EMC Clariion device handler
Date: Tue, 22 Apr 2008 14:09:19 -0700
Message-ID: <1208898559.1025.191.camel@chandra-ubuntu>
References: <20080416011818.19580.41106.sendpatchset@chandra-ubuntu>
	 <20080416011842.19580.92056.sendpatchset@chandra-ubuntu>
	 <4806294C.9090703@cs.wisc.edu> <1208390384.1025.40.camel@chandra-ubuntu>
	 <48078571.9040806@cs.wisc.edu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52987 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbYDVVIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 17:08:49 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3ML8lsS011993
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 17:08:47 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3ML8lvP290702
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 17:08:47 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3ML8kZP023872
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2008 17:08:47 -0400
In-Reply-To: <48078571.9040806@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, andmike@us.ibm.com, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com


On Thu, 2008-04-17 at 12:14 -0500, Mike Christie wrote:
> Chandra Seetharaman wrote:
> > On Wed, 2008-04-16 at 11:29 -0500, Mike Christie wrote:
> >> Chandra Seetharaman wrote:
> >>> +
> >>> +static int send_cmd(struct scsi_device *sdev, int cmd)
> >>> +{
> >>> +	struct request *rq = get_req(sdev, cmd);
> >>> +
> >>> +	if (!rq)
> >>> +		return SCSI_DH_RES_TEMP_UNAVAIL;
> >>> +
> >>> +	return blk_execute_rq(sdev->request_queue, NULL, rq, 1);
> >>> +}
> >>> +
> >> My only concerns are:
> >>
> >> 1. EMC and HP need to send a command to every device to transition them. 
> >> Because we do blk_execute_rq from the dm multipath workqueue we can now 
> >> only failover/failback for a couple devices at a time.
> >>
> > 
> >> I am not sure if this is a big deal, because this the error handler path 
> >> so it is going to be slower than the normal path. But it seems like 
> > 
> > Yes. But...
> > 
> > pg_init() due to failover/failback will be sent only when I/O is
> > sent/resent to a multipath device, isn't it ? and we don't expect I/Os
> > to be sent to all the devices at the same time (all the time), do we ?
> > 
> 
> I am not sure what you mean by all the time, because I am talking about 

What I meant was that we do not expect I/Os to be sent to all the
devices at all the times (pg_init will be sent only when I/Os fails on a
path, right ?).

Sorry for not being clear.

> failover times above. And for failover I think I said yes in the 
> previous mail. For EMC we are currently sending failover commands to all 
> the devices at the same time, because EMC does not do the controller 
> failover RDAC does.

RDAC doesn't do controller failover. It also does per lun failover.

> 
> > So, as you pointed, is it a big deal ? :)
> > 
> 
> In the previous mail I specifically said users might care, because they 
> are picky about failover times, real    3m39.728s
user    0m4.135s
sys     0m14.536s

> so the answer is to your question is 
> what I said before, maybe :) I said I am not sure, because I do not have 
> any numbers for the failover times.

Since RDAC also does the failover per device (as is the case with EMC),
I ran tests on about 49 luns. I ran disktest on all the disks at the
same time and disabled/enabled the port to the preferred path to
generate failover and failback.

Let me know what do you think.

Here are the results:
Tests run in an idle system. With 49 luns and the following script:
******************************************************
for i in `ls -1 /dev/mapper/mpath*`
do
	disktest $i -L 4000 -t 100 -P X &
	sleep 1
done

wait
******************************************************
Simple Run:

with patchset:		2.6.25-mm1:
real    3m30.122s	real    3m29.746s
user    0m4.069s	user    0m4.099s
sys     0m14.876s	sys     0m14.535s
-----------------------------------------------

Failover Run:

with patchset:		2.6.25-mm1:
real    5m18.875s	real    5m31.741s
user    0m4.069s	user    0m3.883s
sys     0m14.838s	sys     0m13.822s
-----------------------------------------------

Failback Run:

with patchset:		2.6.25-mm1*:
real    4m50.313s	real    3m39.728s
user    0m4.051s	user    0m4.135s
sys     0m14.809s	sys     0m14.536s

* In 2.6.25-mm1 not all paths failed back for I/Os to
be completed due to the delay/failures during probing
(which is being handled in the new patchset)
-----------------------------------------------

> 
> > BTW, As you know, it was originally coded that way(patchset posted on
> > Jan 23, 2008) and later changed as per James comments (through you) that
> > the code was overusing blk_execute_rq_nowait().
> >  
> 
> Yes, I know, and as you know I did not agree with James. The reason I 
> bring it up again is that Ed is not doing dm-multipath stuff, so EMC 
> does not have a good reviewer right now, and I want to make sure these 
> issues are raised on the list during the review so we can all discuss 
> them together.
> 
> If James thinks it is a big enough problem he can offer some of this 
> alternatives. If not then he will merge it and we can see if people even 
> notice and handle it later. I just want to make sure we all know what is 
> going on, because Alasdair is not a scsi guy. James does not know all 
> the fun details of every box. And the EMC guys are not up to speed on 
> linux. I am just worried we are going to get a bad review.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

