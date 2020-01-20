Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B76C33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 07:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8479E207E0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 07:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgATHcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 02:32:32 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45400 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbgATHcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 02:32:31 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8F3AA3317DCD53F554F4;
        Mon, 20 Jan 2020 15:32:30 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.231) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 Jan 2020
 15:32:21 +0800
Message-ID: <5E255784.2020506@huawei.com>
Date:   Mon, 20 Jan 2020 15:32:20 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <zhengchuan@huawei.com>,
        <jiangyiwen@huawei.com>, <robin.yb@huawei.com>
Subject: Re: [PATCH] scsi: sd: provide a new module parameter to set whether
 SCSI disks support WRITE_SAME_16 by default
References: <5E246413.8010408@huawei.com> <c3c8c949-b557-1e34-5143-7a0b348a609e@acm.org>
In-Reply-To: <c3c8c949-b557-1e34-5143-7a0b348a609e@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.231]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/1/20 3:36, Bart Van Assche wrote:
> On 2020-01-19 06:13, AlexChen wrote:
>> When the SCSI device is initialized, check whether it supports
>> WRITE_SAME_16 or WRITE_SAME_10 in the sd_read_write_same(). If
>> the back-end storage device does not support queries, it will not set
>> sdkp->ws16 as 1.
>>
>> When the WRITE_SAME io is issued through the blkdev_issue_write_same(),
>> the WRITE_SAME type is set to WRITE_SAME_10 by default in the
>> sd_setup_write_same_cmnd() since of "sdkp->ws16=0". If the storage device
>> does not support WRITE_SAME_10, then the SCSI device is set to not support
>> WRITE_SAME.
>>
>> Currently, some storage devices do not provide queries for
>> WRITE_SAME_16/WRITE_SAME_10 support, but they do support WRITE_SAME_16 and
>> do not support WRITE_SAME_10. So in order for these devices to use
>> WRITE_SAME, we need a new module parameter to set whether SCSI disks
>> support WRITE_SAME_16 by default.
>>
>> Signed-off-by: AlexChen <alex.chen@huawei.com>
>> ---
>>  drivers/scsi/sd.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 4f7e7b607..ff368701d 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -104,6 +104,9 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
>>  #define SD_MINORS	0
>>  #endif
>>
>> +static int sd_default_support_ws16;
>> +module_param(sd_default_support_ws16, int, 0644);
>> +
>>  static void sd_config_discard(struct scsi_disk *, unsigned int);
>>  static void sd_config_write_same(struct scsi_disk *);
>>  static int  sd_revalidate_disk(struct gendisk *);
>> @@ -3014,7 +3017,8 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>>  			sdev->no_write_same = 1;
>>  	}
>>
>> -	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1)
>> +	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16) == 1 ||
>> +			sd_default_support_ws16)
>>  		sdkp->ws16 = 1;
>>
>>  	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME) == 1)
> 
> Should this be fixed using the quirk mechanism instead of introducing a
> new kernel module parameter? Kernel module parameters apply to all SCSI
> disk devices irrespective of their vendor and model. The quirk mechanism
> can be used to introduce special behavior for certain disk models and
> types. See also the output of the following grep command:
> 
> $ git grep -nH '& BLIST'
> 
> Bart.
> 
Thanks for your reply.
I will try to fix the problem by the way you suggested above.

Thanks
Alex
> 
> .
> 


