Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDF6C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 08:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 816B820BED
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 08:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387834AbgDBIvq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 04:51:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12603 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387715AbgDBIvq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Apr 2020 04:51:46 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8E3031276CA38C65E99B;
        Thu,  2 Apr 2020 16:51:42 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.234) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 16:51:34 +0800
Subject: Re: [PATCH] scsi: hisi_sas: Fix build error without SATA_HOST
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <chenxiang66@hisilicon.com>
References: <20200402063021.34672-1-yuehaibing@huawei.com>
 <855fee9e-ae2d-ca70-8630-df27a273e6f3@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        <linux-ide@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <d965beec-bcdd-8e3e-e0a4-2b53d9681f19@huawei.com>
Date:   Thu, 2 Apr 2020 16:51:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <855fee9e-ae2d-ca70-8630-df27a273e6f3@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/4/2 15:30, John Garry wrote:
> On 02/04/2020 07:30, YueHaibing wrote:
> 
> +
> 
>> If SATA_HOST is n, build fails:
>>
>> drivers/scsi/hisi_sas/hisi_sas_main.o: In function `hisi_sas_fill_ata_reset_cmd':
>> hisi_sas_main.c:(.text+0x2500): undefined reference to `ata_tf_to_fis'
>>
>> Select SATA_HOST to fix this.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: 7c594f0407de ("scsi: hisi_sas: add softreset function for SATA disk")
> 
> That's not right. SATA_HOST was only introduced recently in the ATA code. It would fix those kconfig changes.

Ok, thanks

> 
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
>> index 90a17452a50d..13ed9073fc72 100644
>> --- a/drivers/scsi/hisi_sas/Kconfig
>> +++ b/drivers/scsi/hisi_sas/Kconfig
>> @@ -6,6 +6,7 @@ config SCSI_HISI_SAS
>>       select SCSI_SAS_LIBSAS
>>       select BLK_DEV_INTEGRITY
>>       depends on ATA
>> +    select SATA_HOST
> 
> That does not feel right.
> 
> SCSI_HISI_SAS depends on ATA, but SATA_HOST also depends on ATA, so it seems better to just depend on SATA_HOST (and omit explicit ATA dependency), rather than select it.

Depends on SATA_HOST will result int this:

scripts/kconfig/mconf  Kconfig
drivers/scsi/hisi_sas/Kconfig:2:error: recursive dependency detected!
drivers/scsi/hisi_sas/Kconfig:2:        symbol SCSI_HISI_SAS depends on SATA_HOST
drivers/ata/Kconfig:37: symbol SATA_HOST is selected by SCSI_SAS_ATA
drivers/scsi/libsas/Kconfig:18: symbol SCSI_SAS_ATA depends on SCSI_SAS_LIBSAS
drivers/scsi/libsas/Kconfig:9:  symbol SCSI_SAS_LIBSAS is selected by SCSI_HISI_SAS
For a resolution refer to Documentation/kbuild/kconfig-language.rst
subsection "Kconfig recursive dependency limitations"


All users of SATA_HOST have the 'select' statement, so we should do the same here.

> 
> Thanks,
> John
> 
> .
> 

