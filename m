From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH] scsi_transport_fc: handle transient error on multipath
 environment
Date: Thu, 01 Apr 2010 17:42:52 +0900
Message-ID: <4BB45C8C.6000003@jp.fujitsu.com>
References: <4B750CB7.4030805@jp.fujitsu.com> <4B7593F4.2050102@cs.wisc.edu> <4B7597F4.6070403@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38942 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0DAImy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 04:42:54 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o318grOD007607
	for <linux-scsi@vger.kernel.org> (envelope-from kusumi.tomohiro@jp.fujitsu.com);
	Thu, 1 Apr 2010 17:42:53 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id DC25245DE64
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:52 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id AE54545DE55
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:52 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8A5F7E38003
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:52 +0900 (JST)
Received: from m020.s.css.fujitsu.com (m020.s.css.fujitsu.com [10.0.81.60])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 30C601DB803E
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:52 +0900 (JST)
In-Reply-To: <4B7597F4.6070403@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, James Smart <james.smart@emulex.com>

Hi Mike,

Sorry for the late reply, and thanks for giving me advice.

> On 02/12/2010 11:46 AM, Mike Christie wrote:

> What transport problems are you seeing where the rport is not blocked
> and the scsi cmd timer fires? Would it be mostly buggy switches or
> something like that?

 When a disk is broken (broken FC switch is possible though) there is a case
 that SCSI command times out without blocking fibre channel remote port which
 simply means no response (no hardware interrupt on I/O completion) from the disk.
 In the current SCSI driver, that ends up fc_timed_out returning BLK_EH_NOT_HANDLED,
 and as a result it takes long time to get through unjam function of error handler.
 The older scsi driver has no transport timeout, but it basically does the same.

 The previous patch was to avoid unjam and let multipath software quickly discard
 the broken path, but as you and James had mentioned dm layer should handle I/O
 latency as path quality issue, not transport.

> > - Maybe you want to instead hook something into the dm-mutlipath's
> > request (no more bios like in 2004 :)). Can you set a timer on that
> > level of request. If that times out then, dm-multipath could do
> > something like call blk_abort_queue.
>
> Some more detail. I was thinking maybe you could stack the timeout
> handlers like is done for request_fn handlers or maybe the scsi cmd
> would use the upper layer's timer somehow. Not sure... but at the least
> I think we would not want both a scsi request and dm request timers
> running at the same time.

 I've been reading device mapper and dmsetup command code, trying to understand
 what you were saying. It seems there are two ways to do it in device mapper layer.
 One is to simply modify dm-mpath target driver, and let request_queue override the
 timeout handler and use different one instead of normal scsi timeout handler. 
 Another is to make something like dm-timeout target driver which stacks timeout
 functionality on top of another device mapper. First one looks much easier, but
 stacking another functionality on top of dm-mpath has more flexibility (if it's
 possible).

> Then for the error handling and timeout handling, most FC drivers have a
> terminate_rport_io which works without having to block the entire host.
> Those drivers could implement a newer eh where instead of firing the
> code in scsi_error.c when a cmd times out, it would run
> terminate_rport_io from some workqueue.
>
> new dm request timed out()
> 	-> scsi_timed_out
> 		-> fc_timed_out()
> 			{
> 				run new eh from workqueue();
> 			}
> 
> new_eh()
> 	/* no new cmds should be started until we figure out what is going on */
> 	block rport()
> 	/* releases cmds upwards so they can run while we try to figure out
> what is going on */
> 	terminate_rport_io()
> 	/* check if devices are ok */
> 	send_tur()
> 	if (tur failed)
> 		start old scsi_error.c code to unjam us.
> 	else
> 		/* everything looks ok so let IO run to this path again */
> 		unblock rport()

 Agree, even if I take care of I/O latency issue in dm timeout, I still have to
 add different timeout handler in SCSI/FC layer, and that might end up removing
 remote port like what I did in the previous patch (and I agree removing a fibre
 channel remote port just because of a single I/O latency is somewhat odd).

> > 
> > I think the problem with blk_abort_queue might be that it stops all IO
> > to the entire host where you probably just want to work on the remote
> > port/path. For that you could call something like
> > recover_transient_error. Maybe it could just be a call to
> > terminate_rport_io from a workqueue though.

 I think I'll post a patch to dm-devel and scsi mailing list before long.

Thanks,
Tomohiro Kusumi



(2010/02/13 3:03), Mike Christie wrote:
> On 02/12/2010 11:46 AM, Mike Christie wrote:
>> - Maybe you want to instead hook something into the dm-mutlipath's
>> request (no more bios like in 2004 :)). Can you set a timer on that
>> level of request. If that times out then, dm-multipath could do
>> something like call blk_abort_queue.
> 
> Some more detail. I was thinking maybe you could stack the timeout
> handlers like is done for request_fn handlers or maybe the scsi cmd
> would use the upper layer's timer somehow. Not sure... but at the least
> I think we would not want both a scsi request and dm request timers
> running at the same time.
> 
> Then for the error handling and timeout handling, most FC drivers have a
> terminate_rport_io which works without having to block the entire host.
> Those drivers could implement a newer eh where instead of firing the
> code in scsi_error.c when a cmd times out, it would run
> terminate_rport_io from some workqueue.
> 
> new dm request timed out()
> 	->  scsi_timed_out
> 		->  fc_timed_out()
> 			{
> 				run new eh from workqueue();
> 			}
> 
> 
> new_eh()
> 	/* no new cmds should be started until we figure out what is going on */
> 	block rport()
> 	/* releases cmds upwards so they can run while we try to figure out
> what is going on */
> 	terminate_rport_io()
> 	/* check if devices are ok */
> 	send_tur()
> 	if (tur failed)
> 		start old scsi_error.c code to unjam us.
> 	else
> 		/* everything looks ok so let IO run to this path again */
> 		unblock rport()
> 
> 
>>
>> I think the problem with blk_abort_queue might be that it stops all IO
>> to the entire host where you probably just want to work on the remote
>> port/path. For that you could call something like
>> recover_transient_error. Maybe it could just be a call to
>> terminate_rport_io from a workqueue though.
> 
> 


