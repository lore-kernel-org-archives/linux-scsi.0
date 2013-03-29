From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Fri, 29 Mar 2013 17:32:53 +0100
Message-ID: <5155C235.40807@redhat.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org> <5152A19C.7010500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab3C2Qds (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Mar 2013 12:33:48 -0400
In-Reply-To: <5152A19C.7010500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

On 03/27/2013 08:37 AM, Hannes Reinecke wrote:
> On 03/26/2013 07:00 PM, Chad Dupuis wrote:
>>
>>
>> On Tue, 19 Feb 2013, Hannes Reinecke wrote:
>>
>>> This patchset updates the SCSI midlayer to use 64-bit LUNs
>>> internally.
>>> It eliminates the need to limit the number of LUNs artificially to
>>> avoid aliasing issues; the SCSI midlayer can now accept any LUN
>>> presented
>>> to it.
>>>
>>> The LLDD specific settings for 'max_lun' have been left untouched;
>>> it should be raised to '~0' if the HBA supports 64-bit LUNs
>>> internally.
>>> However, it is up to the driver maintainer to raise that limit.
>>>
>>> Hannes Reinecke (4):
>>>  scsi_scan: Fixup scsilun_to_int()
>>>  scsi: use 64-bit LUNs
>>>  scsi: use 64-bit value for 'max_luns'
>>>  scsi: Remove CONFIG_SCSI_MULTI_LUN
>>>
>>
>> Hannes,
>>
>> As we've reviewed these patches internally, the one question that keeps
>> coming up is how do we handle hardware that cannot handle a 64-bit LUN
>> address? For example, some of our older 2G/bps hardware can only
>> handle a 16-bit LUN address.  Currently we convert the u32 value to u16.
>  >  Do we do the same for the 64-bit conversion? Can a way be 
> devised to
>> "opt-out" of receiving a 64-bit address in the first place (IIRC this
>  > was an option in the v1 patch set)?
>>
> Yes, you can.
>
> The idea here is to let 'max_luns' control this behaviour; 
> 'max_luns' is the highest LUN number the host can support.
> So for 16-bit LUN you would set max_luns to '0xFFFF', and for 32-bit
> LUN addresses you would be setting max_luns to '0xFFFFFFFF'.

Hi all,

in scsi_report_lun_scan is max_lun compared with the result of scsilun_to_int,
but in that value is also stored the address method. This means, that we compare
the max_lun to a LUN 'handle' which doesn't seem to make much sense.
This makes that test dependent on which address method is used and not
only to the LUN number which is I think expected.
The solution is to have a new function 'scsilun_to_num', (I can send a patch)
or let the individual drivers set the max_lun to -1 and test for the allowed LUNs
in the driver.

Thanks,
Tomas

>
> However, since you mention it, maybe I should add a 'scsilun_to_u32'
> conversion routine, as this is requested in several places.
>
> Cheers,
>
> Hannes

