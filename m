From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Fix endianess in partition table
Date: Tue, 12 Feb 2013 09:45:29 -0500
Message-ID: <511A5589.1060709@interlog.com>
References: <1360604094.24863.1.camel@br8ggx07.de.ibm.com> <1360659837.11990.9.camel@br8ggx07.de.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34286 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759743Ab3BLOpu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 09:45:50 -0500
In-Reply-To: <1360659837.11990.9.camel@br8ggx07.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 13-02-12 04:03 AM, Martin Peschke wrote:
> On Mon, 2013-02-11 at 18:34 +0100, Martin Peschke wrote:
>> Both start_sect and nr_sects in struct partition are __le32 and
>> require cpu_to_le32() on assignment.
>
> Steffen Maier has pointed me at:
>
> block/partitions/msdos.c:	return
> (sector_t)get_unaligned_le32(&p->start_sect);
>
> Unfortunately, both get_unaligned_le32() and le32_to_cpu() appear to be
> in use for start_sect and nr_sects.
>
> Any one who would argue for changing my patch from cpu_to_le32 to
> put_unaligned_le32()?

No (because I don't know). However since SCSI is big
endian and you are introducing some "le" code then a line
or so of explanation (comments) in your revised patch might
be helpful.


BTW Finding a big endian architecture to test this patch on is
not easy. The openwrt in my router is big endian (MIPS) but
openwrt don't distribute the scsi_debug module :-(

Doug Gilbert

>> Without this fix tools like fdisk show an invalid partition table
>> for SCSI devices emulated by scsi_debug on big-endian architectures,
>> like s390x. Besides a kernel message like this was emitted:
>>
>> sda: p1 start 536870912 is beyond EOD, enabling native capacity
>> sda: p1 start 536870912 is beyond EOD, truncated
>>
>> For verification 'xxd -l 512 /dev/sda' has been used to make sure
>> that this fix makes scsi_debug generated partition tables on s390x
>> look like the ones generated on my laptop.
>>
>> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
>> Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
>>
>> ---
>>   drivers/scsi/scsi_debug.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -2662,8 +2662,8 @@ static void __init sdebug_build_parts(un
>>   			       / sdebug_sectors_per;
>>   		pp->end_sector = (end_sec % sdebug_sectors_per) + 1;
>>
>> -		pp->start_sect = start_sec;
>> -		pp->nr_sects = end_sec - start_sec + 1;
>> +		pp->start_sect = cpu_to_le32(start_sec);
>> +		pp->nr_sects = cpu_to_le32(end_sec - start_sec + 1);
>>   		pp->sys_ind = 0x83;	/* plain Linux partition */
>>   	}
>>   }
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

