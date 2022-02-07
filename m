Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DFDC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 13:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358806AbiBGNt0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 08:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358126AbiBGN1S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 08:27:18 -0500
X-Greylist: delayed 1040 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 05:27:17 PST
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4DFC043181;
        Mon,  7 Feb 2022 05:27:17 -0800 (PST)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jsmbj5fqSz6GCbt;
        Mon,  7 Feb 2022 21:05:53 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Mon, 7 Feb 2022 14:09:55 +0100
Received: from [10.47.86.164] (10.47.86.164) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 7 Feb
 2022 13:09:48 +0000
Message-ID: <1114e27f-e6b3-e9b9-a892-f543f4636c4e@huawei.com>
Date:   Mon, 7 Feb 2022 13:09:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 00/16] scsi: libsas and users: Factor out LLDD TMF code
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <artur.paszkiewicz@intel.com>, <jinpu.wang@cloud.ionos.com>,
        <chenxiang66@hisilicon.com>, <Ajish.Koshy@microchip.com>
CC:     <yanaijie@huawei.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <liuqi115@huawei.com>,
        <Viswas.G@microchip.com>
References: <1643110372-85470-1-git-send-email-john.garry@huawei.com>
 <1893d9ef-042b-af3b-74ea-dd4d0210c493@opensource.wdc.com>
 <14df160f-c0f2-cc9f-56d4-8eda67969e0b@huawei.com>
 <a8fae323-1877-058a-b03e-d175a725213f@opensource.wdc.com>
 <a2de1656-b1ec-2fb7-caab-657e27dacb48@huawei.com>
 <49da4d80-5cc3-35c3-ccaa-6def8165eb65@huawei.com>
 <59a198a8-1d87-bc09-d2d8-2d495ed74c16@opensource.wdc.com>
 <098f988e-1f12-c412-3111-60393dfe0f0b@huawei.com>
 <f3362c6f-b4b6-2914-0652-d786e19b6b03@opensource.wdc.com>
 <62e56609-7026-93a1-a446-a6fd68328653@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <62e56609-7026-93a1-a446-a6fd68328653@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.164]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien,

On 04/02/2022 03:02, Damien Le Moal wrote:
> This is the submission path, not completion. The code is:
> 
> (gdb) list *(pm8001_queue_command+0x842)
> 0x3d42 is in pm8001_queue_command (drivers/scsi/pm8001/pm8001_sas.c:491).
> 486				atomic_dec(&pm8001_dev->running_req);
> 487				goto err_out_tag;
> 488			}
> 489			/* TODO: select normal or high priority */
> 490			spin_lock(&t->task_state_lock);
> 491			t->task_state_flags |= SAS_TASK_AT_INITIATOR;
> 492			spin_unlock(&t->task_state_lock);
> 493		} while (0);
> 494		rc = 0;
> 495		goto out_done;
> 
> So the task is already completed when the submission path tries to set
> the state flag ? Debugging...

JFYI, I am putting together a patch to drop SAS_TASK_AT_INITIATOR 
altogether. I just need to ensure that the logic in the isci code is 
correct.

Thanks,
John
