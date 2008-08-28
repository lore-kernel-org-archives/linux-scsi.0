From: "Abhijeet Joglekar" <ajoglekar@nuovasystems.com>
Subject: RE: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Wed, 27 Aug 2008 18:31:24 -0700
Message-ID: <34BDD2A93E5FD84594BB230DD6C18EA205B873F8@nuova-ex1.hq.nuovaimpresa.com>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com> <48B2F880.7080108@cs.wisc.edu> <48B304BD.9060404@emulex.com> <48B30885.1010808@cs.wisc.edu> <48B30A81.9020406@emulex.com> <48B31DAF.3060400@nuovasystems.com> <48B32967.9000306@cs.wisc.edu> <48B32A52.1040100@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nuova-ex1.nuovasystems.com ([67.91.200.196]:41296 "EHLO
	nuova-ex1.nuovasystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbYH1Bb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 21:31:26 -0400
Content-class: urn:content-classes:message
In-Reply-To: <48B32A52.1040100@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Joe Eykholt <jre@nuovasystems.com>
Cc: James Smart <James.Smart@Emulex.Com>, jeykholt@cisco.com, linux-scsi@vger.kernel.org

>Mike Christie wrote:
>> Joe Eykholt wrote:
>>> James Smart wrote:
>>>>
>>>> Mike Christie wrote:
>>>>>> Well - what should be happening is - prior to the reset or as
part of
>>>>>> it, the fc transport fc_remote_port_delete() call should be made
on 
>>>>>> all
>>>>>> those remote ports that connectivity is about to be terminated
on.  
>>>>>> This
>>>>>> will place all the associated targets/luns on those rports into a
>>>>>> blocked state, and start the devloss timer on them.  This will
>>>>>>suspend
>>>>>> the eh path as well.  Thus, things suspend until either the 
>>>>>> driver/fcoe
>>>>> What do you mean by that? For lpfc it will or for this driver?
This
>>>>> driver does not have that block call like
lpfc_block_error_handler, so
>>>>> if the rport event occurs after the scsi eh is running we do not 
>>>>> suspend
>>>>> the eh.
>>>>>
>>>>> So below I am saying we should make the lpfc_block_error_handler
>>>>> functionality and the equivalent in the qla2xxx and mpfc common so
>>>>> libfc/fcoe and fnic can use it.
>>>> Well there's successive layers of the onion here. And your right,
one >>>>of
>>>> them is the block_error_handler.  Agreed, all of this should be
common.
>>>>
>>>> -- james s
>>>>
>>>
>>> I think you're both on the right track.  When we reset the local
port, 
>>> it should make all
>>> remote ports non-ready ... we no longer have a PLOGI to them.  Until

>>> we redo FLOGI and
>>> discovery, no SCSI ops will succeed.  fc_lport_reset() calls 
>>> fc_lport_set_fid, which calls
>>> lp_rport_reset_list() ... but that doesn't seem to do much to rports

>>> other than the
>>> directory server.
>>>
>>> fc_rport_reset() puts the rport in state INIT, but I don't think 
>>> that's enough.  Maybe
>>> that's where the remote port should get blocked.  Sound right?
>>>
>> 
>> Did you see the thread
>> http://www.open-fcoe.org/pipermail/devel/2008-July/000394.html
>> I think we basically said we need to overhaul the fc class 
>> fc_remote_port and the libfc's use - some of the discussion went off 
>> list into some call. James and Chris were going to work on it. I
think 
>> both got busy with other issues or are still working on it.

>Hit send too soon.

>We basically should be deleting the port for these scenarios, then that

>sets the dev_loss_tmo and blocks the rport. We should then wait in the 
>eh for the rport to be added back or for the dev_loss_tmo to fire.

Apologies for not getting back earlier, I just got a chance to look at
this thread and review the code. Here's the summary of what I think
should be fixed, please correct if wrong -

1) fnic_host_reset should wait after call to lport_reset to allow all
rports to come back up or get offlined after dev_loss_tmo. Ideally,
there should be a wait on state for lport to get ready and then a wait
on each of the discovered rports to go to unblock. 

Currently, the fnic driver was relying on HOST_RESET_SETTLE_TIME (10
secs) after host reset success (since skip_settle_delay is 0) before
trying to send TUR to online devices. If fabric login succeeded and
rports came back up within that time, the TUR would succeed, and
commands would get moved out of the eh_work_q.

At a minimum, the wait and check lport state after initiating
lport_reset can be moved down to the fnic driver instead of relying on
SCSI-ML to do it.

2) fnic_abort_cmd and fnic_device_reset wait for rport to unblock as the
first step in the fxn since there is no point in sending any recovery
commands to remote port if it is currently gone. However, its not clear
why fnic_host_reset needs to block as its first step. All it does it
clean up all the SCSI commands locally and then resets the local port
which in turn resets the rports and restarts fabric login. As discussed
in (1) above, it is clear why blocking the thread is required after call
to lport_reset, it is not clear why the first step in host_reset should
be to block error handler (unless you never said that, and I
misunderstood)

3) In queuecommand, if local port is not ready after rport check is ok,
then return busy. This is to cover transition of rport from online to
blocked which started just after we did the rport check. Eventually if
dev_loss_tmo really fires and rport goes away, then the scsi_device will
get blocked and scsi-ml will block the device queue. If rport comes
back, subsequent queuecommand calls will be able to successfully issue
IOs.

Let me know if you have more review comments.

thanks,
--abhijeet


