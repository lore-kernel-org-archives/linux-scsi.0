From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 16:55:30 -0500
Message-ID: <48B32A52.1040100@cs.wisc.edu>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com> <48B2F880.7080108@cs.wisc.edu> <48B304BD.9060404@emulex.com> <48B30885.1010808@cs.wisc.edu> <48B30A81.9020406@emulex.com> <48B31DAF.3060400@nuovasystems.com> <48B32967.9000306@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60304 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYHYVzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 17:55:43 -0400
In-Reply-To: <48B32967.9000306@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jre@nuovasystems.com>
Cc: James Smart <James.Smart@Emulex.Com>, "jeykholt@cisco.com" <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ajoglekar@nuovasystems.com" <ajoglekar@nuovasystems.com>

Mike Christie wrote:
> Joe Eykholt wrote:
>> James Smart wrote:
>>>
>>> Mike Christie wrote:
>>>>> Well - what should be happening is - prior to the reset or as part of
>>>>> it, the fc transport fc_remote_port_delete() call should be made on 
>>>>> all
>>>>> those remote ports that connectivity is about to be terminated on.  
>>>>> This
>>>>> will place all the associated targets/luns on those rports into a
>>>>> blocked state, and start the devloss timer on them.  This will suspend
>>>>> the eh path as well.  Thus, things suspend until either the 
>>>>> driver/fcoe
>>>> What do you mean by that? For lpfc it will or for this driver? This
>>>> driver does not have that block call like lpfc_block_error_handler, so
>>>> if the rport event occurs after the scsi eh is running we do not 
>>>> suspend
>>>> the eh.
>>>>
>>>> So below I am saying we should make the lpfc_block_error_handler
>>>> functionality and the equivalent in the qla2xxx and mpfc common so
>>>> libfc/fcoe and fnic can use it.
>>> Well there's successive layers of the onion here. And your right, one of
>>> them is the block_error_handler.  Agreed, all of this should be common.
>>>
>>> -- james s
>>>
>>
>> I think you're both on the right track.  When we reset the local port, 
>> it should make all
>> remote ports non-ready ... we no longer have a PLOGI to them.  Until 
>> we redo FLOGI and
>> discovery, no SCSI ops will succeed.  fc_lport_reset() calls 
>> fc_lport_set_fid, which calls
>> lp_rport_reset_list() ... but that doesn't seem to do much to rports 
>> other than the
>> directory server.
>>
>> fc_rport_reset() puts the rport in state INIT, but I don't think 
>> that's enough.  Maybe
>> that's where the remote port should get blocked.  Sound right?
>>
> 
> Did you see the thread
> http://www.open-fcoe.org/pipermail/devel/2008-July/000394.html
> I think we basically said we need to overhaul the fc class 
> fc_remote_port and the libfc's use - some of the discussion went off 
> list into some call. James and Chris were going to work on it. I think 
> both got busy with other issues or are still working on it.

Hit send too soon.

We basically should be deleting the port for these scenarios, then that 
sets the dev_loss_tmo and blocks the rport. We should then wait in the 
eh for the rport to be added back or for the dev_loss_tmo to fire.
