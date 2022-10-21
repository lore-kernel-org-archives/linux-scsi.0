Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3188C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Oct 2022 08:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiJUIR4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 04:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiJUIRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 04:17:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CE71A403E
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 01:17:53 -0700 (PDT)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mty3s22ymz689ls
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 16:16:41 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 10:17:50 +0200
Received: from [10.126.168.107] (10.126.168.107) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 09:17:49 +0100
Message-ID: <c9767b92-6fb2-bffd-e675-a74766d6cc3c@huawei.com>
Date:   Fri, 21 Oct 2022 09:17:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 0/2] Check and update the device link rate during
 discovery
To:     Yihang Li <liyihang9@huawei.com>, Linuxarm <linuxarm@huawei.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yangxingui <yangxingui@huawei.com>
References: <20221020141635.2479412-1-liyihang9@huawei.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20221020141635.2479412-1-liyihang9@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.168.107]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/10/2022 15:16, Yihang Li wrote:
> SATA devices attached to an expander maybe generate incorrect IOs when
> physical link re-establish at a lower link rate. This is due to the
> expander PHY attached to a SATA PHY is using link rate greater than the
> physical PHY link rate which is re-established.
> 

How do you create this scenario? I thought that I added min pathway 
support for root phy, such that we have min pathway support for root phy 
through 1x expander to a sata disk for initial discovery. I can't 
remember exactly the scenario I added support for....

BTW, did you mean the send this to mainline scsi mailng list? You did 
not cc maintainers Martin and James.

> This patchset fixes the issue.
> 
> Yihang Li (2):
>    scsi: libsas: Add sas_update_linkrate()
>    scsi: libsas: Add sas_check_port_linkrate()
> 
>   drivers/scsi/libsas/sas_discover.c | 18 +++++++++++++-
>   drivers/scsi/libsas/sas_expander.c | 40 ++++++++++++++++++++++++++++++
>   drivers/scsi/libsas/sas_internal.h |  1 +
>   3 files changed, 58 insertions(+), 1 deletion(-)
> 

