From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] scsi: Add helper code so transport classes/driver
 can control queueing
Date: Wed, 30 Apr 2008 12:45:05 -0500
Message-ID: <4818B021.9010500@cs.wisc.edu>
References: <1209442937-15130-1-git-send-email-michaelc@cs.wisc.edu> <1209442937-15130-2-git-send-email-michaelc@cs.wisc.edu> <4817271A.8020708@emulex.com> <48174FB7.2080805@cs.wisc.edu> <48189059.7000803@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46162 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925AbYD3RpS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2008 13:45:18 -0400
In-Reply-To: <48189059.7000803@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Mike Christie wrote:
>> James Smart wrote:
>>> The starget->can_queue value should come from the targets device_list 
>>> entry, not the LLD.
>>>
>>
>> I am not sure what you mean. How would the device_list->tgt_can_queue 
>> get set in the first place? Is there some scsi inquiry setting that 
>> can be parsed or are you saying it should be based on the 
>> scsi_device->queue_depth or cmd_per_lun?
> 
> I'm proposing, just as we set different scan options, lun capacities, etc
> from the device_list info via scsi_scan, we would also want to set a max
> target can_queue value at the same time. It's a value per target port, that
> is independent of the number of luns presented on that target port.
> Yes, it would be based on matching inquiry data to device_list entries.
> 
> This solves lots of headaches that we've been dealing with where adapter
> capacities have been a lot higher than target capacities. In general, the
> queue full handling kicks in to help this, but how queue full is handled
> is a per-driver thing and even if it works, it has a cost overhead with all
> the reactive ramp-up/ramp-down. We've also seen less than desired array
> behaviors when it gets overloaded that actually works against the queue 
> full
> algorithms and forces some long i/o timeouts (i/o just gets discarded as
> the array can't keep up).

Ah ok neat. I get it.

> 
>>> To complete this fully, if the LLD had a per-target resource 
>>> restriction (which I doubt
>>> would be target-specific), it should set a value within the shost 
>>> template much along the
>>
>> I thought we were trying to not add new scsi_host_template fields for 
>> settings, so I was setting this like how we would set new blk_queue 
>> settings in the slave_alloc/config callouts.
> 
> Perhaps I missed this new direction. Adding "byproducts" to 
> slave_alloc/config
> seems ugly to me, especially as the slave works at the lun basis, while the
> byproducts can affect lun, target, and perhaps rport as well. Can you 
> refer to
> the thread that indicates this direction ?


I will dig through linux-scsi and send it.

> 
> Whether it's from the slave_alloc or the host template isn't my top 
> concern.
> I simply want to see a target-based cap get put in place, and as the 
> cases I've
> seen are target vendor-centric and not hba-centric, it makes sense to 
> set it
> based on device_list data and outside of the LLD.
> 
>> I can move it but we wanted to be able to set this for each session. 
>> Instead of resetting the host_template value it seemed nicer to do 
>> this in the slave functions for each target.
>>
>> The problem I have is that for bnx2i we have to preallocate X 
>> commands/itts for each session in the firmware/hardware. Each session 
>> than can only accept the amount of commands I tell the fw/hw about at 
>> session setup time. So a user can setup the driver so that session1 
>> has a limit of X commands, but later create a second session to some 
>> other target that has a limit of Y commands.
>>
>> What do you think?
> 
> Ok - we're solving slightly different, although related problems. 
> Interesting that
> the adapter partitions resources to targets/sessions. With most SPI/FC 
> adapters,
> we share the cmd capacities across all targets, and don't know who the 
> target is
> until we scan it, and it can change based on a connectivity change. 
> Whereas the
> iscsi session code effectively knows about the target and its capacities 
> at the
> time the shost is created and it really doesn't change.
> 
> How about the following:
> - Let's let the value be set via slave_alloc as you propose, so we have a
>   dynamic per-LLD cap. Thus, the process of scanning Lun 0, results in 
> the LLD cap
>   to be initially set.
> - I'll work up a patch to scsi_scan that adds a target can_queue to the 
> device_list,
>   and on the lun 0 scan, if the can_queue is specied and is less than 
> the LLD cap
>   (which should have just been put in place) will further reduce the 
> target limit.
> 

Sounds ok to me.
