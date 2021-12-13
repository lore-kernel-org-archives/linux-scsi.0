Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E54EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 10:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhLMKof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 05:44:35 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4256 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbhLMKof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 05:44:35 -0500
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCJ1S6tQGz67n09;
        Mon, 13 Dec 2021 18:40:12 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 11:44:33 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 13 Dec
 2021 10:44:32 +0000
Subject: Re: [PATCH 13/15] scsi: hisi_sas: Keep controller active between ISR
 of phyup and the event being processed
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-14-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <eda21591-d691-f892-8ca5-0f5b3d49f496@huawei.com>
Date:   Mon, 13 Dec 2021 10:44:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-14-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.94]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/11/2021 02:45, chenxiang wrote:
> From: Xiang Chen<chenxiang66@hisilicon.com>
> 
> It is possible that controller may be suspended between ISR of phyup
> and the event being processed, then it can't ensure controller is
> active when processing the phyup event which will cause issues.
> To avoid the issue, add pm_runtime_get_noresume() in ISR of phyup
> and pm_runtime_put_sync() in the work handler exit of a new event
> HISI_PHYE_PHY_UP_PM which is called in v3 hw as runtime PM is
> only supported for v3 hw.

Please consider this rewrite:

It is possible that the controller may become suspended between 
processing a phyup interrupt and the event being processed by libsas. As 
such, we can't ensure that the controller is active when processing the 
phyup event - this may cause the phyup event to be lost or other issues.
To avoid any possible issues, add pm_runtime_get_noresume() in the phyup 
interrupt handler and pm_runtime_put_sync() in the work handler exit to 
ensure that we stay always active. Since we only want 
pm_runtime_get_noresume() called for v3 hw, signal this will a new 
event, HISI_PHYE_PHY_UP_PM.

Thanks,
John
