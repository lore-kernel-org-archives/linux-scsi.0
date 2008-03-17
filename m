From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 9/9] mptfc: convert mptfc to use fc queueing helper.
Date: Mon, 17 Mar 2008 13:39:37 -0500
Message-ID: <47DEBAE9.8090701@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-6-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-7-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-8-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-9-git-send-email-michaelc@cs.wisc.edu> <47D97813.5040505@sgi.com> <47DEB93E.8050909@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47952 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYCQSjv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 14:39:51 -0400
In-Reply-To: <47DEB93E.8050909@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com

Mike Christie wrote:
> Michael Reed wrote:
>>
>> michaelc@cs.wisc.edu wrote:
>>> From: Mike Christie <michaelc@cs.wisc.edu>
>>>
>>> Convert mptfc to use fc queueing helper.
>>
>> I've been trying to exercise the fusion FC change.
>> I can't seem to force the code into returning either
>> TARGET_BUSY or DID_NO_CONNECT.  Any suggestions on
> 
> Did you mean DID_IMM_RETRY in the original code?
> 
>> how I might get a command down to the driver while
>> the rport is blocked or in DEVLOSS_PENDING?
>>
>> I've been running 32 outstanding commands to 16 targets,
>> disabling/enabling the various FC switch ports, AND
>> I disabled the usage of the scsi_host_lock in
>> fc_remote_port_delete() and I unlock/relock it in the
>> mptfc_qmnd() function.
>>
> 
> For FC it is a small window where the rport is being blocked but the 
> scsi_device is not yet in the blocked state. Instead of lots of targets 
> you want lots of devices on just one target.
> 
> To test it with just one device you can just add a sleep in 
> fc_remote_port_delete after the port_state and flags are set and the 
> host lock is dropped and before the call to scsi_target_block.
> 
>        rport->port_state = FC_PORTSTATE_BLOCKED;
> 
>         rport->flags |= FC_RPORT_DEVLOSS_PENDING;
> 
>         spin_unlock_irqrestore(shost->host_lock, flags);
> 
>         if (rport->roles & FC_PORT_ROLE_FCP_INITIATOR &&
>             shost->active_mode & MODE_TARGET)
>                 fc_tgt_it_nexus_destroy(shost, (unsigned long)rport);
> 
> 
> ssleep(1);
> 
>         scsi_target_block(&rport->dev);

I think we could actually avoid the transition checks if we just held 
the host lock around the code we set the port state and when we call 
scsi_target_block. scsi_target_block would just need to be modified so 
that it did not grab the host lock (the driver model code does not use a 
mutex anymore).

On the scsi_target_unblock side we would grab the host lock and set the 
rport state and unblock the devices at the same time. Again we would 
need to not take the host lock when looping over the devices and we 
could just plug the queue instead of running the request_fn (because 
performance is not an issue in this code path instead of using 
blk_start_queue we could call somehing that cleared the stop flag and 
always plugged the queue).
