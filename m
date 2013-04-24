From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 08:27:34 -0400
Message-ID: <5177CFB6.9070105@redhat.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de> <5177CB23.5090802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab3DXM2A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 08:28:00 -0400
In-Reply-To: <5177CB23.5090802@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Black, David" <david.black@emc.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

On 04/24/2013 08:08 AM, Paolo Bonzini wrote:
> Il 24/04/2013 14:07, Hannes Reinecke ha scritto:
>> On 04/24/2013 01:17 PM, Paolo Bonzini wrote:
>>> Il 23/04/2013 22:07, James Bottomley ha scritto:
>>>> On Tue, 2013-04-23 at 15:41 -0400, Ric Wheeler wrote:
>>>>> For many years, we have used WCE as an indication that a device has a volatile
>>>>> write cache (not just a write cache) and used this as a trigger to send down
>>>>> SYNCHRONIZE_CACHE commands as needed.
>>>>>
>>>>> Some arrays with non-volatile cache seem to have WCE set and simply ignore the
>>>>> command.
>>>> I bet they don't; they probably obey the spec.  There's a SYNC_NV bit
>>>> which if unset (which it is in our implementation) means only sync your
>>>> non-NV cache.  For a device with all NV, that equates to nop.
>>> Isn't it the other way round?
>>>
>>> SYNC_NV = 0 means "sync all your caches to the medium", and it's what we do.
>>>
>>> SYNC_NV = 1 means "sync volatile to non-volatile", and it's what Ric wants.
>>>
>>> So we should set SYNC_NV=1 if NV_SUP is set, perhaps only if the medium
>>> is non-removable just to err on the safe side.
>> Or use 'WRITE_AND_VERIFY' here; that's guaranteed to hit the disk.
>> Plus it even has a guarantee about data consistency on the disk,
>> which the normal WRITE command has not.
> The point is to _avoid_ hitting the disk. :)
>
> Paolo
>

The point is to have a crash-proof version of the data acknowledged by the 
target device while letting data sit in volatile state as long as possible. To 
be even clearer, we would love to do this for a sub-range of the device but 
currently use a "big hammer" to flush the entire cache (possibly for multiple 
file systems on one target storage device).

Once we use the SYNCHRONIZE_CACHE (or CACHE_FLUSH_EXT) command, we want the data 
on that target device to be there if someone loses power.

If the device can promise this, we don't care (and don't know) how it manages 
that promise. It can leave the data on battery backed DRAM, can archive it to 
flash or any other scheme that works.

Just as importantly, we don't want to "destage" data to the back end drives if 
that is not required since it is really, really slow.

The confusion here is that various storage devices have used the standard bits 
in arbitrary ways which makes it very hard to have one clear set of rules.

Even harder to explain to end users when to use a work around (like mount -o 
nobarrier) or the proposed "ignore flushes" block level call :)

Regards,

Ric

