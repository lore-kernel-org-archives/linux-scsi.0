Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B12EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Dec 2021 02:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhL1CDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Dec 2021 21:03:54 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34850 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbhL1CDx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2021 21:03:53 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JNHrD4wptzccDH;
        Tue, 28 Dec 2021 10:03:24 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 28 Dec 2021 10:03:51 +0800
Subject: Re: [PATCH v2 05/15] scsi: hisi_sas: Fix some issues related to
 asd_sas_port->phy_list
To:     Nathan Chancellor <nathan@kernel.org>,
        <martin.petersen@oracle.com>, <john.garry@huawei.com>
References: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
 <1639999298-244569-6-git-send-email-chenxiang66@hisilicon.com>
 <Ycn3FoW9eOZNFMiL@archlinux-ax161>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <llvm@lists.linux.dev>,
        <colin.i.king@gmail.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <3d20171c-f5ac-d01e-9f0e-ba51835d68f0@hisilicon.com>
Date:   Tue, 28 Dec 2021 10:03:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <Ycn3FoW9eOZNFMiL@archlinux-ax161>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Nathan and Colin,
Thank you for your report.

在 2021/12/28 1:25, Nathan Chancellor 写道:
> Hi Xiang,
>
> On Mon, Dec 20, 2021 at 07:21:28PM +0800, chenxiang wrote:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> Most places that use asd_sas_port->phy_list are protected by spinlock
>> asd_sas_port->phy_list_lock, but there are some places which lack of it
>> in hisi_sas driver, so add it in function hisi_sas_refresh_port_id() when
>> accessing asd_sas_port->phy_list. But it has a risk that list mutates while
>> dropping the lock at the same time in function
>> hisi_sas_send_ata_reset_each_phy(), so read asd_sas_port->phy_mask
>> instead of accessing asd_sas_port->phy_list to avoid the risk.
>>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> Acked-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_main.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> index ad64ccd41420..051092e294f7 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> @@ -1428,11 +1428,13 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
>>   		sas_port = device->port;
>>   		port = to_hisi_sas_port(sas_port);
>>   
>> +		spin_lock(&sas_port->phy_list_lock);
>>   		list_for_each_entry(sas_phy, &sas_port->phy_list, port_phy_el)
>>   			if (state & BIT(sas_phy->id)) {
>>   				phy = sas_phy->lldd_phy;
>>   				break;
>>   			}
>> +		spin_unlock(&sas_port->phy_list_lock);
>>   
>>   		if (phy) {
>>   			port->id = phy->port_id;
>> @@ -1509,22 +1511,25 @@ static void hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
>>   	struct ata_link *link;
>>   	u8 fis[20] = {0};
>>   	u32 state;
>> +	int i;
>>   
>>   	state = hisi_hba->hw->get_phys_state(hisi_hba);
>> -	list_for_each_entry(sas_phy, &sas_port->phy_list, port_phy_el) {
>> +	for (i = 0; i < hisi_hba->n_phy; i++) {
>>   		if (!(state & BIT(sas_phy->id)))
>>   			continue;
>> +		if (!(sas_port->phy_mask & BIT(i)))
>> +			continue;
>>   
>>   		ata_for_each_link(link, ap, EDGE) {
>>   			int pmp = sata_srst_pmp(link);
>>   
>> -			tmf_task.phy_id = sas_phy->id;
>> +			tmf_task.phy_id = i;
>>   			hisi_sas_fill_ata_reset_cmd(link->device, 1, pmp, fis);
>>   			rc = hisi_sas_exec_internal_tmf_task(device, fis, s,
>>   							     &tmf_task);
>>   			if (rc != TMF_RESP_FUNC_COMPLETE) {
>>   				dev_err(dev, "phy%d ata reset failed rc=%d\n",
>> -					sas_phy->id, rc);
>> +					i, rc);
>>   				break;
>>   			}
>>   		}
>> -- 
>> 2.33.0
>>
>>
> Please ignore this if it was already reported, I do not see any reports
> of it on lore.kernel.org nor a commit fixing it in Martin's tree.
>
> This commit as commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues
> related to asd_sas_port->phy_list") in -next causes the following clang
> warning, which will break the build under -Werror:
>
> drivers/scsi/hisi_sas/hisi_sas_main.c:1536:21: error: variable 'sas_phy' is uninitialized when used here [-Werror,-Wuninitialized]
>                  if (!(state & BIT(sas_phy->id)))
>                                    ^~~~~~~
> ./include/vdso/bits.h:7:30: note: expanded from macro 'BIT'
> #define BIT(nr)                 (UL(1) << (nr))
>                                             ^~
> drivers/scsi/hisi_sas/hisi_sas_main.c:1528:29: note: initialize the variable 'sas_phy' to silence this warning
>          struct asd_sas_phy *sas_phy;
>                                     ^
>                                      = NULL
> 1 error generated.
>
> It seems like this variable is entirely unused now, should it be removed
> along with this check?
>

Right, it needs to be removed as the additional check is enough.

@Martin and @John Garry, could you have a review and consider to merge 
following patch ?

From: Xiang Chen <chenxiang66@hisilicon.com>
Date: Tue, 28 Dec 2021 09:40:01 +0800
Subject: [PATCH] scsi: libsas: Remove unused variable and check in function
  hisi_sas_send_ata_reset_each_phy()

In commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to
asd_sas_port->phy_list"), we use asd_sas_port->phy_mask instead of
accessing asd_sas_port->phy_list, and it is enough to use
asd_sas_port->phy_mask to check the state of phy, so removing the
old and unused check.

Fixes: 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to 
asd_sas_port->phy_list")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
  drivers/scsi/hisi_sas/hisi_sas_main.c | 5 -----
  1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c 
b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f46f679fe825..a05ec7aece5a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1525,16 +1525,11 @@ static void 
hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
         struct device *dev = hisi_hba->dev;
         int s = sizeof(struct host_to_dev_fis);
         int rc = TMF_RESP_FUNC_FAILED;
-       struct asd_sas_phy *sas_phy;
         struct ata_link *link;
         u8 fis[20] = {0};
-       u32 state;
         int i;

-       state = hisi_hba->hw->get_phys_state(hisi_hba);
         for (i = 0; i < hisi_hba->n_phy; i++) {
-               if (!(state & BIT(sas_phy->id)))
-                       continue;
                 if (!(sas_port->phy_mask & BIT(i)))
                         continue;

--
2.33.0



