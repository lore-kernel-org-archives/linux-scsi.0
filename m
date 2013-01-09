From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v11 3/9] libata: identify and init ZPODD devices
Date: Wed, 09 Jan 2013 11:20:37 +0800
Message-ID: <50ECE205.3000005@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com> <1357440509-28108-4-git-send-email-aaron.lu@intel.com> <20130107182052.GP3926@htj.dyndns.org> <50EBE1E2.5080406@intel.com> <20130108175202.GZ3926@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20130108175202.GZ3926@htj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

On 01/09/2013 01:52 AM, Tejun Heo wrote:
> Hello, Aaron.
> 
> On Tue, Jan 08, 2013 at 05:07:46PM +0800, Aaron Lu wrote:
>>>> +struct zpodd {
>>>> +	bool slot:1;
>>>> +	bool drawer:1;
>>>> +
>>>> +	struct ata_device *dev;
>>>> +};
>>>
>>> Field names are usually indented.  It would be nice to have a comment
>>
>> checkscript.sh doesn't seem like this if I put a tab around the ':'
>>
>> ERROR: spaces prohibited around that ':' (ctx:VxW)
>> #222: FILE: include/uapi/linux/cdrom.h:915:
>> +	__u8 reserved1:		2;
>>  	              ^
>>
>> Which style should I follow?
> 
> struct zpodd {
> 	bool			slot:1;
> 	bool			drawer:1;
> 
> 	struct ata_device	*dev;
> };

Oh, got it :-)

> 
>>> explaining synchronization.  Bitfields w/ their implicit RMW ops tend
>>> to make people wonder about what the access rules are.
>>
>> The slot and drawer bit field is assigned only once during ata probe
>> time in EH context, and accessed later in PM's callback context.
>> Not sure what access rule should I describe...
> 
> /* init during probe, RO afterwards */ should do but I'd prefer if you
> stay away from bitfields altogether.  There are cases where bitfields
> are okay but when you're working across multiple locking domains, it
> usually is a bad idea because the code which accesses those fields
> look completely independent while still being able to interact with
> each other.  They look properly synchronized until you realized they
> live on the same machine word.

Then I will not use bitfields, I was just thinking to save some space
and didn't realize it would bring such nasty problems...

> 
>>>> +/*
>>>> + * Per the spec, only slot type and drawer type ODD can be supported
>>>> + *
>>>> + * Return 0 for slot type, 1 for drawer, -ENODEV for other types or on error.
>>>> + */
>>>
>>> Maybe bool odd_has_drawer() is better?
>>
>> There are other types of ODD other than slot and drawer, and both slot
>> and drawer type ODDs can be supported for ZPODD. So a bool can't convey
>> such information :-)
> 
> Then please make it a proper ATA enum and use it in struct zpodd too.

Sure, and thanks for all the suggestions!

-Aaron

