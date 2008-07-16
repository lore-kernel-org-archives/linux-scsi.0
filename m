From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 14:51:51 -0500
Message-ID: <487E5157.7050709@cs.wisc.edu>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>	<487E4443.7090601@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com> <487E4DC6.4030108@cs.wisc.edu> <487E4FE3.8040904@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56565 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbYGPTwE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 15:52:04 -0400
In-Reply-To: <487E4FE3.8040904@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Mike Christie wrote:
>> James.Smart@Emulex.Com wrote:
>>>  
>>>
>>>> michaelc@cs.wisc.edu wrote:
>>>> Oh yeah, I ccd linux-scsi for this patch and not others, because 
>>>> JamesS and them are not on fcoe devel list, and it seems like all fc 
>>>> drivers fail the sync cache command.
>>>>
>>>> What happens is that we remove the rport which sets the rport state, 
>>>> then the fc class removes the target. This causes the target and its 
>>>> devices to be removed, which can cause a sync cache to be sent. But 
>>>> because the the rport is not in the online state it will fail the 
>>>> command.
>>> Well, excepting detachment paths, if we're tearing the rport down, it's
>>> because
>>> we've already lost connectivity to the target, so there's no way a sync
>>> cache would ever succeed. It's a suprise-removal scenario.
>>>
>>
>> Yeah, I am only talking about the paths where we want a clean shutdown 
>> like if for fcoe we did echo ethX > /sys/module/fcoe/destroy. For 
>> normal fc do we want to be able to remove rpots too? Did you guys do 
>> that with the ioctl modules before? Then there is the module removal 
>> case. I think for module removal we want a clean shutdown too, but I 
>> am not sure if other people feel that for module removal there are 
>> gaurantees like that.
>>
>> So during a clean shutdown are drivers supposed to remove the targets 
>> by calling scsi_remove_target to remove the devices, then remove the 
>> rports through the class?
> 
> Or for the case where we are stopping a host (rmmod or single host stop 
> like with fcoe), should drivers call
> 
> 1. fc_remove_host()
>     This could be modified to cleanup shutdown targets then remove 
> rports. We could then have a rport shutdown callback which the class 
> could call and drivers could cleanup and shutdown the rport here before

I guess we have the terminate_rport_io callback already. So we could do:


fc_remove_host()
for each target
	scsi_remove_target();
for each rport
	fc_queue_work(shost, &rport->rport_delete_work);

.....


fc_rport_final_delete()
	i->f->terminate_rport_io

.......

then in the fcoe termniate_rport_io function we could stop the port?
