From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] Re: [PATCH RFC] move scsi parts of dm hw handlers
 to	scsi layer
Date: Fri, 21 Jul 2006 08:15:04 -0400
Message-ID: <44C0C548.4080806@cs.wisc.edu>
References: <1153480817.8030.15.camel@max>	<581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>	<44C0BF4C.5060102@cs.wisc.edu> <44C0C0BA.90006@cs.wisc.edu> <4880914.1153483821524.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.208.38.107] ([216.208.38.107]:58753 "EHLO
	OTTLS.pngxnet.com") by vger.kernel.org with ESMTP id S1161053AbWGUMPY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jul 2006 08:15:24 -0400
In-Reply-To: <4880914.1153483821524.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Am Fr 21.07.2006 13:55 schrieb Mike Christie <michaelc@cs.wisc.edu>:
> 
>> Mike Christie wrote:
>>> Hannes Reinecke wrote:
>>>>> The patch below begins to push the scsi hw handler code down to
>>>>> the
>>>>> scsi
>>>>> layer. I only began to covert dm-emc.c and it only hooks in at the
>>>>> sense
>>>>> decoding in scsi_error.c. I wanted to make sure I was going about
>>>>> the
>>>>> module loading and binding correctly. With a new target bus we
>>>>> could
>>>>> do
>>>>> some driver model stuff instead, but I was not sure if that was
>>>>> appropriate for this?
>>>>>
>>>> Why don't we use scsi_devinfo for this?
>>> I was adding my fields when I noticed this comment:
>>>
>>>
>>> * Do not add to this list, use the command line or proc interface to
>>>  add
>>>  * to the scsi_dev_info_list. This table will eventually go away.
>>>
>>>
>>>> We have to have some sort of device table anyway as these handlers
>>>> are
>>>> far from being generic, so any sense code which triggers action on
>>>> one
>>>> device might be perfectly ok for others.
>>> When I was looking for the history of that commet, I thought I read
>>> that
>>> we are supposed to be moving to some userspace approach that pushes
>>> that
>>> info down via some magic interface.
>>>
>> I added this comment at the wrong place. I meant to say I thought we
>> are
>> supposed to be moving away from the kernel devinfo list to some
>> userspace one that gets sent down via the module_param or some new
>> magic
>> interface.
> 
> Or so they claim. I seem to remember some discussion about it; the net
> result was the scsi_devinfo will stay with us for the time being.
> 
> Otherwise you'll end up having to configure your kernel / module during
> startup. With parameters which are static anyway. Can't say I like it.
> And the tricky bit is that these information has to be present prior
> to any initialisation, so you basically have to feed it during
> modprobe time. Not really clever.
> 

He He fun :)

Sticking what we need in devinfo is a lot easier. And I think it makes
sense since the devices info we want to bind with is in there already.
If nobody says anything, I will send the next version of the path with
devinfo integration.
