Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38693C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 10:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhLMKua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 05:50:30 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4257 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhLMKu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 05:50:28 -0500
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCJBw2dDdz67wRq;
        Mon, 13 Dec 2021 18:48:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 11:50:26 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 13 Dec
 2021 10:50:25 +0000
Subject: Re: [PATCH 15/15] scsi: hisi_sas: Use autosuspend for SAS controller
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-16-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ac517067-b119-0a47-bf65-ec9e3fcf9944@huawei.com>
Date:   Mon, 13 Dec 2021 10:50:05 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-16-git-send-email-chenxiang66@hisilicon.com>
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

Please consider this rewrite:

On 17/11/2021 02:45, chenxiang wrote:

scsi: hisi_sas: Use autosuspend for the host controller

> From: Xiang Chen<chenxiang66@hisilicon.com>
> 
> For some scenarios, it may send many IOs in a short time, then SAS controller
> will enter suspend and resume frequently which is invalid.
> To avoid it, use autosuspend mode for SAS controller and set default
> autosuspend delay time to 5s.

The controller may frequently enter and exit suspend for each IO which 
we need to deal with. This is inefficient and may cause too much 
suspend+resume activity for the controller.

To avoid this, use a default 5s autosuspend for the controller to stop 
frequently suspending and resuming. This value may still be still 
modified via sysfs.

> 
> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
> Signed-off-by: John Garry<john.garry@huawei.com>

Acked-by please

Thanks,
John
