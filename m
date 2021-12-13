Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A804C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 11:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhLMLNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 06:13:00 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4259 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhLMLNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 06:13:00 -0500
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCJhv5js1z67wCQ;
        Mon, 13 Dec 2021 19:10:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 13 Dec 2021 12:12:57 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 13 Dec
 2021 11:12:57 +0000
Subject: Re: [PATCH 09/15] scsi: libsas: Resume sas host before sending SMP
 IOs
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-10-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <017482f2-47a0-f924-629e-88e956ce3f61@huawei.com>
Date:   Mon, 13 Dec 2021 11:12:37 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-10-git-send-email-chenxiang66@hisilicon.com>
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

Please consider these points:

About "scsi: libsas: Resume sas host before sending SMP IOs", just have 
"Resume host while sending SMP IOs"

On 17/11/2021 02:45, chenxiang wrote:
> From: Xiang Chen<chenxiang66@hisilicon.com>
> 
> Need to resume sas host before sending SMP IOs to ensure that
> SMP IOs are sent sucessfully.

successfully

 >

When sending SMP IOs to the host we need to ensure that that host is not 
suspended and may handle the commands. This is a better approach than 
relying on the host to resume itself to handle such commands. So use 
pm_runtime_get_sync() and pm_runtime_get_sync() calls for the host when 
executing SMP tasks.

> 
> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
> Reviewed-by: John Garry<john.garry@huawei.com>

