From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] scsi_debug: fix endianness bug in sdebug_build_parts()
Date: Sat, 27 Jul 2013 02:07:41 +0900
Message-ID: <CAC5umyi8LkZ1kETSpbDNSu2YaAJRXf6Ag0VYCPdFs4zD2hqeKQ@mail.gmail.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
	<1373889127-17083-2-git-send-email-akinobu.mita@gmail.com>
	<1374772228.15813.3.camel@br9vgx5g.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41636 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3GZRHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 13:07:42 -0400
Received: by mail-oa0-f48.google.com with SMTP id f4so8134360oah.35
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2013 10:07:41 -0700 (PDT)
In-Reply-To: <1374772228.15813.3.camel@br9vgx5g.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

2013/7/26 Martin Peschke <mpeschke@linux.vnet.ibm.com>:
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
>>  drivers/scsi/scsi_debug.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index cb4fefa..2f39b13 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -2659,8 +2659,8 @@ static void __init sdebug_build_parts(unsigned char *ramp,
>>                              / sdebug_sectors_per;
>>               pp->end_sector = (end_sec % sdebug_sectors_per) + 1;
>>
>> -             pp->start_sect = start_sec;
>> -             pp->nr_sects = end_sec - start_sec + 1;
>> +             pp->start_sect = cpu_to_le32(start_sec);
>> +             pp->nr_sects = cpu_to_le32(end_sec - start_sec + 1);
>>               pp->sys_ind = 0x83;     /* plain Linux partition */
>>       }
>>  }
>
>
> I have posted the same fix several times, e.g.
> http://marc.info/?l=linux-scsi&m=137051617907423&w=2
> Good luck!
>
> Acked-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>

Thanks.  I found this problem from sparse warning noticed by 0-DAY kernel
build testing.
