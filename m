Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E72C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 02:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiLSCTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Dec 2022 21:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLSCTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2022 21:19:48 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58738636B;
        Sun, 18 Dec 2022 18:19:47 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nb3KX1R3WzmWmj;
        Mon, 19 Dec 2022 10:18:40 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 19 Dec 2022 10:19:44 +0800
Subject: Re: [PATCH V2] scsi: libsas: Directly kick-off EH when ATA device
 fell off
To:     Xingui Yang <yangxingui@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <john.g.garry@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
        <kangfenglong@huawei.com>
References: <20221216100327.7386-1-yangxingui@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <baf759c8-a738-903d-4ff1-a98ce20d9f43@huawei.com>
Date:   Mon, 19 Dec 2022 10:19:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20221216100327.7386-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/16 18:03, Xingui Yang wrote:
> If the ATA device fell off, call sas_ata_device_link_abort() directly and
> mark all outstanding QCs as failed and kick-off EH Immediately. This avoids
> having to wait for block layer timeouts.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
> Changes to v1:
> - Use dev_is_sata() to check ATA device type
>   drivers/scsi/libsas/sas_discover.c | 3 +++
>   1 file changed, 3 insertions(+)

Looks good,
Reviewed-by: Jason Yan <yanaijie@huawei.com>
