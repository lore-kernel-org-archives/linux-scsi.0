From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/4] scsi_debug: fix endianness bug in sdebug_build_parts()
Date: Thu, 25 Jul 2013 16:16:42 -0400
Message-ID: <51F187AA.1090001@interlog.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>  <1373889127-17083-2-git-send-email-akinobu.mita@gmail.com> <1374772228.15813.3.camel@br9vgx5g.de.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38850 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab3GYURO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 16:17:14 -0400
In-Reply-To: <1374772228.15813.3.camel@br9vgx5g.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On 13-07-25 01:10 PM, Martin Peschke wrote:
> On Mon, 2013-07-15 at 20:52 +0900, Akinobu Mita wrote:
>> With module parameter num_parts > 0, partition table is built on the
>> ramdisk storage when loading the driver.  Unfortunately, there is an
>> endianness bug in sdebug_build_parts().  So the partition table is not
>> correctly initialized on big-endian systems.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Douglas Gilbert <dgilbert@interlog.com>
>> Cc: linux-scsi@vger.kernel.org
>> ---
>>   drivers/scsi/scsi_debug.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index cb4fefa..2f39b13 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -2659,8 +2659,8 @@ static void __init sdebug_build_parts(unsigned char *ramp,
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
>
>
> I have posted the same fix several times, e.g.
> http://marc.info/?l=linux-scsi&m=137051617907423&w=2
> Good luck!
>
> Acked-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>

(Re-)Acked-by: Douglas Gilbert <dgilbert@interlog.com>
