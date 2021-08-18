Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252F2C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 15:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 094E260EBD
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 15:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhHRP04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 11:26:56 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3667 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbhHRP0x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 11:26:53 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqWtX2pKlz6BCxZ;
        Wed, 18 Aug 2021 23:25:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 18 Aug 2021 17:26:16 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 18 Aug 2021 16:26:15 +0100
Subject: Re: [PATCH 2/2] scsi: qla1280: Fix DEBUG_QLA1280 compilation issues
To:     <jejb@linux.ibm.com>, <mdr@sgi.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bvanassche@acm.org>
References: <1629294801-32102-1-git-send-email-john.garry@huawei.com>
 <1629294801-32102-3-git-send-email-john.garry@huawei.com>
 <996f1de7010aa3ebfd334fb09562944550f894c3.camel@linux.ibm.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d89827e2-a221-e11a-d376-708492da40c8@huawei.com>
Date:   Wed, 18 Aug 2021 16:26:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <996f1de7010aa3ebfd334fb09562944550f894c3.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/08/2021 15:27, James Bottomley wrote:
> On Wed, 2021-08-18 at 21:53 +0800, John Garry wrote:
>> The driver does not compile under DEBUG_QLA1280 flag, so fix up with
>> as
>> little fuss as possible some debug statements.
>>
>> Also delete ql1280_dump_device(), which looks to have never been
>> referenced.
>>
>> Signed-off-by: John Garry<john.garry@huawei.com>
>> ---
>>   drivers/scsi/qla1280.c | 39 ++++++++-------------------------------
>>   1 file changed, 8 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
>> index b4f7d8d7a01c..27b16ec399cd 100644
>> --- a/drivers/scsi/qla1280.c
>> +++ b/drivers/scsi/qla1280.c
>> @@ -2807,7 +2807,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host
>> *ha, struct srb * sp)
>>   
>>   	dprintk(2, "start: cmd=%p sp=%p CDB=%xm, handle %lx\n", cmd,
>> sp,
>>   		cmd->cmnd[0], (long)CMD_HANDLE(sp->cmd));
>> -	dprintk(2, "             bus %i, target %i, lun %i\n",
>> +	dprintk(2, "             bus %i, target %i, lun %lld\n",
>>   		SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
>>   	qla1280_dump_buffer(2, cmd->cmnd, MAX_COMMAND_SIZE);
>>   
>> @@ -2879,7 +2879,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host
>> *ha, struct srb * sp)
>>   			remseg--;
>>   		}
>>   		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
>> -			"command packet data - b %i, t %i, l %i \n",
>> +			"command packet data - b %i, t %i, l %lld \n",
>>   			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
>>   			SCSI_LUN_32(cmd));

Hi James,

> These are the wrong fixes, I think.  The qla1280 can only cope with 32
> bits, which is why all the macros have an _32.

Looking structures like struct cmd_entry, mrk_entry, ecmd_entry, lun 
member is an 8-bit value. There is also this definition:
#define MAX_LUNS	8	/* 32 */
#define MAX_L_BITS	3	/* 5 */

But not sure on where 32/5 comes from - I suppose it's the size the 
driver uses to hold the lun. Or the 32 bits you mention.

>  Over the years we've
> expanded the values in the SCSI command to be 64 bit but by and large,
> the truncation in this driver is silent.  However, the correct fix
> should be to make the truncation explicit in the macro, so
> 
> #define SCSI_LUN_32(Cmnd)	((int)Cmnd->device->lun)

SCSI_LUN_32 is used outside the masked debug code, so I didn't want to 
mess with that.

> 
> And the same for all the other _32 macros.  This avoids the unexpected
> outcome that the _32 macros are actually returning 64 bits and cause me
> to do a WTF at your %lld change.

If a relevant scsi_device member really hold values > 32b in size for 
this driver then it's in trouble, as chopping off the top bits by 
casting won't help.

And if we only ever expect the bottom 32b to be used, using %lld as 
opposed to casting to an int and using %i should not really make a 
difference.

Anyway, I can change as you suggest. But I would rather do it only in 
SCSI_LUN_32().

Thanks!
