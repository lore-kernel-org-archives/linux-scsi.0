From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH] scsi_transport_fc: handle transient error on multipath
 environment
Date: Thu, 01 Apr 2010 17:42:49 +0900
Message-ID: <4BB45C89.6060009@jp.fujitsu.com>
References: <4B750CB7.4030805@jp.fujitsu.com> <4B75736F.5040405@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38932 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0DAImw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 04:42:52 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o318gno3007591
	for <linux-scsi@vger.kernel.org> (envelope-from kusumi.tomohiro@jp.fujitsu.com);
	Thu, 1 Apr 2010 17:42:49 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 7AAF645DE4F
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:49 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 55E2545DE4E
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:49 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 41A3FE18004
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:49 +0900 (JST)
Received: from m022.s.css.fujitsu.com (m022.s.css.fujitsu.com [10.0.81.62])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id F1689E18001
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 17:42:48 +0900 (JST)
In-Reply-To: <4B75736F.5040405@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>

Hi James,

Sorry for the late reply,
I basically agree to what you have mentioned.

> > We've been working on SCSI-FC for enterprise system using MD/DMMP.
> > In enterprise system, response time from disk is important factor,
> > thus it is important for multipathd to quickly discard current path and
> > failover to secondary RAID disk if any problem with disk I/O is detected.
> > In order to switch to alternative path as quick as possible, multipathd
> > should quickly recognize phenomenon such as fibre channel link down,
> > no response from disk, etc.
> > 
> > In the past, we've posted a patch that reduces response time from disk,
> > although it was a trial patch since there wasn't good framework to
> > implement those features. We did it in block layer and that wasn't
> > a good choice I guess.
> > http://marc.info/?l=linux-kernel&m=109598324018681&w=2
> > 
> > But in the recent SCSI driver, transport layer for each lower level
> > interface is getting bigger and better which I think is a good platform
> > to implement them. As far as I know, Mr. Mike Christie has already been
> > working on fast io fail timeout feature for fibre channel transport layer,
> > and that enables userland multipathd quickly guess that the path is down
> > when fibre channel linkdown occured on LLD like lpfc. This patch is a
> > simple additional feature to what Mike has been working on.
> > 
> > This is what I'm trying to do.
> > 1. If SCSI command had timed out, I assume it's time to failover to the
> >    secondary disk without error recovery. Let's call it transient error.
> 
> Link down is an indication of path connectivity loss, and connectivity loss is
> one one of the tasks of the transport - to isolate the upper layers from
> transient loss.  Mike's addition was appropriate as it changed the way i/o was
> dealt with while in one of the transient loss states.
>
> But interpretation of an i/o completion status is a very different matter. The
> transport/LLDD shouldn't be making any inferences based on i/o completion
> state. That's for upper layers who better know the device and the task at hand
> to decide. The transport is simply tracking connectivity status *as driven by
> the LLDD*.
> 
> So, although I can understand that you would like to use latency as a path
> quality issue, I don't agree with making the transport be the one making a
> failover policy, even if the feature is optional. Failover policy choice is
> for the multipathing software.
> 
> Can you give me a reason why it is not addressed in multipathing layers ? Why
> isn't the upper layer monitoring latency, which doesn't have to be an i/o
> timeout, not tracked in the multipathing software.  The additional advantage
> of doing this (at the right level) is that this failover due to latency on a
> path, would apply to all transports.

 Since scsi_transport.h says "eh_timed_out allows the transport to become
 involved when a scsi io timer fires", making action based on I/O completion
 state once made sense to me. Plus, how current fc transport code works when
 trying to delete remote port (blocks queue at first, and then unblock after
 fast fail tmo which make I/O fast fail in queuecommand) was good for what I
 was trying to do. But I do understand what you say, that decision should be
 made in upper layer.

> > 2. Schedule fc_rport_recover_transient_error from fc_timed_out using work
> >    queue if the feature is enabled. Also, make fc_timed_out return
> >    BLK_EH_HANDLED so as not to wake up error handler kernel thread.
> > 3. That workqueue calls transport template function recover_transient_error
> >    if LLD implements it. Otherwise, it simply calls fc_remote_port_delete
> >    and delete fibre channel remote port that corresponds to the SCSI target
> >    device that caused transient error.
> 
> In order to agree to such a patch, I would need to know, very clearly, what an
> LLDD is supposed to do in a "transient error" handler.  This was unspecified.

 I think the name "transient error" was difficult to understand. I meant to say
 transient error handler does whatever necessary in order to recover from transient
 error such as I/O latency. In multipath environment, it would be to quickly let
 multipath software recognize the broken path and discard it. In the case of fibre
 channel, deleting a remote port and avoiding unjam function would do it.

 Without such handler, normal scsi_times_out (unjam function) just takes too
 much time before it gets offlined and lets upper layer's multipath software
 discard it.

> I have a hard time agreeing with a default policy that says, just because a
> single i/o timed out, the entire target topology tree should be torn down. Due
> to the reasons for a timeout, it may require more than 1 before a pattern
> exists that says it should be considered "bad".  Mostly though - the topology
> tree is there to represent the connectivity on the FC fabric *as seen by the
> LLDD* and largely tracks to the LLDD discovery and login state.  Asynchronous
> teardown of this tree by an i/o timeout can leave a mismatch in the transport
> vs LLDD on the rport state (perhaps causing other errors) as well as forcing a
> condition where OS tools/admins viewing the sysfs tree - see a colored view of
> what the fabric connectivity actually is.
> 
> > 4. Once fc_remote_port_delete is called, it removes the remote port and
> >    take care of existing and incoming I/O just like when fibre channel
> >    linkdown occured.
> 
> Additionally, I think it's very odd to have a single i/o, which timed out,
> kill all other i/o's to all luns on that target. Given array implementations
> that may make lun relationships vary greatly (with preferred paths,
> distributed controller implementations), this is too broad a scope to imply.

 Agree, me myself thought it's odd to get rid of that remote port just because
 of a single I/O latency from fabric topology's point of view, although it did
 not have a problem after removing it (in my test environment).

> All of this is solved if you deal with it at the "device" level in the
> multipathing software.
> 
> 
> > 5. If fast io fail timeout is enabled, multipathd can quickly recognize
> >    disk I/O problem and make dm-mpath driver failover to secondary disk.
> >    Even if fast io fail timeout is disabled, multipathd can recognize it
> >    anyway after dev loss timeout expired.
> > 
> > In the current SCSI mid layer driver, SCSI command timeout wakes up error
> > handler kernel thread which takes quite long time depending on the imple-
> > mentation of LLD. Although waking up SCSI error handler is right thing to
> > do in most cases, I think it is not suitable for multipath environment
> > with requirement of quick response. Enabling recover_transient_feature
> > might help those who don't want recovery operation, but just quick failover.
> 
> Then it hints the error handler should be fixed....

 As you and Mike mentioned, implementing it on dm layer makes sense to me. 
 I think I'll post a patch to dm-devel and scsi mailing list before long.

Thanks,
Tomohiro Kusumi



(2010/02/13 0:27), James Smart wrote:
> Tomohiro Kusumi wrote:
>> Hi
>>
>> We've been working on SCSI-FC for enterprise system using MD/DMMP.
>> In enterprise system, response time from disk is important factor,
>> thus it is important for multipathd to quickly discard current path and
>> failover to secondary RAID disk if any problem with disk I/O is detected.
>> In order to switch to alternative path as quick as possible, multipathd
>> should quickly recognize phenomenon such as fibre channel link down,
>> no response from disk, etc.
>>
>> In the past, we've posted a patch that reduces response time from disk,
>> although it was a trial patch since there wasn't good framework to
>> implement those features. We did it in block layer and that wasn't
>> a good choice I guess.
>> http://marc.info/?l=linux-kernel&m=109598324018681&w=2
>>
>> But in the recent SCSI driver, transport layer for each lower level
>> interface is getting bigger and better which I think is a good platform
>> to implement them. As far as I know, Mr. Mike Christie has already been
>> working on fast io fail timeout feature for fibre channel transport layer,
>> and that enables userland multipathd quickly guess that the path is down
>> when fibre channel linkdown occured on LLD like lpfc. This patch is a
>> simple additional feature to what Mike has been working on.
>>
>> This is what I'm trying to do.
>> 1. If SCSI command had timed out, I assume it's time to failover to the
>>     secondary disk without error recovery. Let's call it transient error.
> 
> Link down is an indication of path connectivity loss, and connectivity loss is
> one one of the tasks of the transport - to isolate the upper layers from
> transient loss.  Mike's addition was appropriate as it changed the way i/o was
> dealt with while in one of the transient loss states.
> 
> But interpretation of an i/o completion status is a very different matter. The
> transport/LLDD shouldn't be making any inferences based on i/o completion
> state. That's for upper layers who better know the device and the task at hand
> to decide. The transport is simply tracking connectivity status *as driven by
> the LLDD*.
> 
> So, although I can understand that you would like to use latency as a path
> quality issue, I don't agree with making the transport be the one making a
> failover policy, even if the feature is optional. Failover policy choice is
> for the multipathing software.
> 
> Can you give me a reason why it is not addressed in multipathing layers ? Why
> isn't the upper layer monitoring latency, which doesn't have to be an i/o
> timeout, not tracked in the multipathing software.  The additional advantage
> of doing this (at the right level) is that this failover due to latency on a
> path, would apply to all transports.
> 
> 
>> 2. Schedule fc_rport_recover_transient_error from fc_timed_out using work
>>     queue if the feature is enabled. Also, make fc_timed_out return
>>     BLK_EH_HANDLED so as not to wake up error handler kernel thread.
>> 3. That workqueue calls transport template function recover_transient_error
>>     if LLD implements it. Otherwise, it simply calls fc_remote_port_delete
>>     and delete fibre channel remote port that corresponds to the SCSI target
>>     device that caused transient error.
> 
> In order to agree to such a patch, I would need to know, very clearly, what an
> LLDD is supposed to do in a "transient error" handler.  This was unspecified.
> 
> I have a hard time agreeing with a default policy that says, just because a
> single i/o timed out, the entire target topology tree should be torn down. Due
> to the reasons for a timeout, it may require more than 1 before a pattern
> exists that says it should be considered "bad".  Mostly though - the topology
> tree is there to represent the connectivity on the FC fabric *as seen by the
> LLDD* and largely tracks to the LLDD discovery and login state.  Asynchronous
> teardown of this tree by an i/o timeout can leave a mismatch in the transport
> vs LLDD on the rport state (perhaps causing other errors) as well as forcing a
> condition where OS tools/admins viewing the sysfs tree - see a colored view of
> what the fabric connectivity actually is.
> 
>> 4. Once fc_remote_port_delete is called, it removes the remote port and
>>     take care of existing and incoming I/O just like when fibre channel
>>     linkdown occured.
> 
> Additionally, I think it's very odd to have a single i/o, which timed out,
> kill all other i/o's to all luns on that target. Given array implementations
> that may make lun relationships vary greatly (with preferred paths,
> distributed controller implementations), this is too broad a scope to imply.
> 
> All of this is solved if you deal with it at the "device" level in the
> multipathing software.
> 
> 
>> 5. If fast io fail timeout is enabled, multipathd can quickly recognize
>>     disk I/O problem and make dm-mpath driver failover to secondary disk.
>>     Even if fast io fail timeout is disabled, multipathd can recognize it
>>     anyway after dev loss timeout expired.
>>
>> In the current SCSI mid layer driver, SCSI command timeout wakes up error
>> handler kernel thread which takes quite long time depending on the imple-
>> mentation of LLD. Although waking up SCSI error handler is right thing to
>> do in most cases, I think it is not suitable for multipath environment
>> with requirement of quick response. Enabling recover_transient_feature
>> might help those who don't want recovery operation, but just quick failover.
> 
> Then it hints the error handler should be fixed....
> 
> -- james s
> 
> 
> 


