From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Tue, 11 Jul 2017 11:22:38 +0100
Message-ID: <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com>
References: <20170616082755.22832-1-hch@lst.de>
 <1499701840.3555.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9819 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753081AbdGKKW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 06:22:56 -0400
In-Reply-To: <1499701840.3555.7.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>

On 10/07/2017 16:50, Bart Van Assche wrote:
> On Fri, 2017-06-16 at 10:27 +0200, Christoph Hellwig wrote:
>> Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq I/O
>> path now that we had plenty of testing, and have I/O schedulers for
>> blk-mq.  The module option to disable the blk-mq path is kept around
>> for now.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  drivers/scsi/Kconfig | 11 -----------
>>  drivers/scsi/scsi.c  |  4 ----
>>  2 files changed, 15 deletions(-)
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 3c52867dfe28..d384f4f86c26 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -47,17 +47,6 @@ config SCSI_NETLINK
>>  	default	n
>>  	depends on NET
>>
>> -config SCSI_MQ_DEFAULT
>> -	bool "SCSI: use blk-mq I/O path by default"
>> -	depends on SCSI
>> -	---help---
>> -	  This option enables the new blk-mq based I/O path for SCSI
>> -	  devices by default.  With the option the scsi_mod.use_blk_mq
>> -	  module/boot option defaults to Y, without it to N, but it can
>> -	  still be overridden either way.
>> -
>> -	  If unsure say N.
>> -
>>  config SCSI_PROC_FS
>>  	bool "legacy /proc/scsi/ support"
>>  	depends on SCSI && PROC_FS
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 1bf274e3b2b6..3d38c6d463b8 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -800,11 +800,7 @@ MODULE_LICENSE("GPL");
>>  module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
>>  MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
>>
>> -#ifdef CONFIG_SCSI_MQ_DEFAULT
>>  bool scsi_use_blk_mq = true;
>> -#else
>> -bool scsi_use_blk_mq = false;
>> -#endif
>>  module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
>>
>>  static int __init init_scsi(void)
>
> Since a fix for the performance regression triggered by this patch will be upstream
> soon (see also https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-linus&id=32825c45ff8f4cce937ab85b030dc693ceb1aa0a):
>

FYI, on linux-next 20170711 (which now includes the above patch Bart 
mentioned) we see a large performance regression on hisi_sas (LLDD does 
not config shost for mq).

fio read mode iops goes from ~833K (scsi_mod.use_blk_mq=n on cmdline) to 
~320K

John

> Acked-by: Bart Van Assche <bart.vanassche@wdc.com>
>
>
>
>
