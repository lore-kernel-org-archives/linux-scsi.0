From: Gabriel C <nix.or.die@gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.9-rc3
Date: Sat, 12 Nov 2016 03:05:32 +0100
Message-ID: <02467dd3-21ab-9807-d516-87cc75b793a1@gmail.com>
References: <1478352591.2858.5.camel@HansenPartnership.com>
 <1eee17da-1166-6a48-8a21-0ad5d6a0660a@gmail.com>
 <024723a1-3dec-f644-277b-4178118cc241@gmail.com>
 <8275700b8bd4c457dab7b6e7260fce00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <8275700b8bd4c457dab7b6e7260fce00@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 12.11.2016 02:08, Kashyap Desai wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Gabriel C
>> Sent: Friday, November 11, 2016 9:40 AM
>> To: James Bottomley; Andrew Morton; Linus Torvalds
>> Cc: linux-scsi; linux-kernel; stable@vger.kernel.org
>> Subject: Re: [GIT PULL] SCSI fixes for 4.9-rc3
>>
>>
>>
>> On 11.11.2016 04:30, Gabriel C wrote:
>>>
>>> On 05.11.2016 14:29, James Bottomley wrote:
>>>
>>>
>>> ...
>>>
>>>> Kashyap Desai (1):
>>>>       scsi: megaraid_sas: Fix data integrity failure for JBOD
>>>> (passthrough) devices
>>>>
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> index 9ff57de..d8b1fbd 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> @@ -1700,16 +1700,13 @@ megasas_queue_command(struct Scsi_Host
>> *shost, struct scsi_cmnd *scmd)
>>>>  		goto out_done;
>>>>  	}
>>>>
>>>> -	switch (scmd->cmnd[0]) {
>>>> -	case SYNCHRONIZE_CACHE:
>>>> -		/*
>>>> -		 * FW takes care of flush cache on its own
>>>> -		 * No need to send it down
>>>> -		 */
>>>> +	/*
>>>> +	 * FW takes care of flush cache on its own for Virtual Disk.
>>>> +	 * No need to send it down for VD. For JBOD send
>> SYNCHRONIZE_CACHE to FW.
>>>> +	 */
>>>> +	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
>>>> +MEGASAS_IS_LOGICAL(scmd)) {
>>>>  		scmd->result = DID_OK << 16;
>>>>  		goto out_done;
>>>> -	default:
>>>> -		break;
>>>>  	}
>>>>
>>>>  	return instance->instancet->build_and_issue_cmd(instance, scmd);
>>>
>>> This patch breaks my box.. I'm not able to boot it anymore.
>>> It seems with this patch I have /dev/sda[a-z] to /dev/sdz[a-z] ?!?
>>>
>>> I'm not sure how to get an log since dracut times out and I'm dropped
>>> , after a very long time of probing 'ghost devices', in a emercency
>>> shell,
>> journalctl doesn't work also..
>>>
>>> After reverting this one I can boot normal.
>>>
>>> Box is a FUJITSU PRIMERGY TX200 S5..
> 
> Please  check now commit.  Below commit has complete fix.
> 
> http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=5e5ec1759dd663a1d5a2f10930224dd009e500e8
> 


This patch fixes the problem for me. Thank you.


Regards,

Gabriel C
