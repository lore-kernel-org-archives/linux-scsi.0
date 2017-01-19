From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/7] scsi: hisi_sas: modify some values of ITCT table
Date: Thu, 19 Jan 2017 08:55:47 +0000
Message-ID: <c861893c-d51a-2c0d-0cee-1e92926f8f9a@huawei.com>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
 <1484757173-235951-3-git-send-email-john.garry@huawei.com>
 <20170119084337.GF5054@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:39657 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdASI4j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2017 03:56:39 -0500
In-Reply-To: <20170119084337.GF5054@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>

On 19/01/2017 08:44, Johannes Thumshirn wrote:
> On Thu, Jan 19, 2017 at 12:32:48AM +0800, John Garry wrote:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> Set SMP connection timeout and continue AWT timer;
>> Clear ITCT table when dev gone.
>>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> index 6c787eb..452e329 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> @@ -334,6 +334,8 @@
>>  #define ITCT_HDR_MCR_MSK		(0xf << ITCT_HDR_MCR_OFF)
>>  #define ITCT_HDR_VLN_OFF		9
>>  #define ITCT_HDR_VLN_MSK		(0xf << ITCT_HDR_VLN_OFF)
>> +#define ITCT_HDR_SMP_TIMEOUT_OFF	16
>> +#define ITCT_HDR_AWT_CONTINUE_OFF	25
>>  #define ITCT_HDR_PORT_ID_OFF		28
>>  #define ITCT_HDR_PORT_ID_MSK		(0xf << ITCT_HDR_PORT_ID_OFF)
>>  /* qw2 */
>> @@ -696,6 +698,8 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
>>  	qw0 |= ((1 << ITCT_HDR_VALID_OFF) |
>>  		(device->linkrate << ITCT_HDR_MCR_OFF) |
>>  		(1 << ITCT_HDR_VLN_OFF) |
>> +		(0xfa << ITCT_HDR_SMP_TIMEOUT_OFF) |
>                  ^~ You may want to give that magic value a name.
>

Thanks for having a look.

We will create a new patch without the mysterious value.

Regards,
John

> Other than that,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>


