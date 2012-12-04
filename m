From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Tue, 04 Dec 2012 13:04:42 +0800
Message-ID: <50BD846A.6050601@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike> <21511277.LLinyDpbAK@vostro.rjw.lan> <20121128013928.GB15971@htj.dyndns.org> <1354092969.2276.49.camel@dabdike> <20121203081321.GA9990@mint-spring.sh.intel.com> <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com> <20121203162323.GB19802@htj.dyndns.org> <50BCF5F8.2030802@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50BCF5F8.2030802@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/04/2012 02:56 AM, Jeff Garzik wrote:
> On 12/03/2012 11:23 AM, Tejun Heo wrote:
>> Hello, James.
>>
>> On Mon, Dec 03, 2012 at 08:25:43AM +0000, James Bottomley wrote:
>>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>>>> index e65c62e..1756151 100644
>>>> --- a/include/scsi/scsi_device.h
>>>> +++ b/include/scsi/scsi_device.h
>>>> @@ -160,6 +160,7 @@ struct scsi_device {
>>>>   	unsigned can_power_off:1; /* Device supports runtime power off */
>>>>   	unsigned wce_default_on:1;	/* Cache is ON by default */
>>>>   	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
>>>> +	unsigned event_driven:1; /* No need to poll the device */
>>>>
>>>>   	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>>>>   	struct list_head event_list;	/* asserted events */
>>>
>>> Yes, but if we can get away with doing that, it should be in genhd
>>> because it's completely generic.
>>>
>>> I was imagining we'd have to fake the reply to the test unit ready or
>>> some other commands, which is why it would need to be in sr.c
>>>
>>> The check events code is Tejun's baby, if he's OK with it then just do
>>> it in genhd.c
>>
>> The problem here is there's no easy to reach genhd from libata (or the
>> other way around) without going through sr.  I think we're gonna have
>> to have something in sr one way or the other.
> 
>   ...which is precisely as I said when v1 of this ZPODD patchset appeared.
> 
> sr modifications cannot be avoided.

So I'm gonna use the above code to silence the poll when ODD is powered
off. I suppose everybody is OK with this, right? James, please let me
know if you disagree.

Thanks,
Aaron

> 
> 	Jeff
> 
> 
> 
> 

