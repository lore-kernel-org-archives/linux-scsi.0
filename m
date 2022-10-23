Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB94ECAAA1
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 07:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJWHHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 03:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiJWHHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 03:07:37 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2099E70E7E
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 00:07:36 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mw8N24dSHzJn7M
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 15:04:50 +0800 (CST)
Received: from [10.67.100.231] (10.67.100.231) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 23 Oct 2022 15:07:33 +0800
Subject: Re: [PATCH 0/2] Check and update the device link rate during
 discovery
To:     <john.garry@huawei.com>, <linuxarm@huawei.com>
References: <20221020141635.2479412-1-liyihang9@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <chenxiang66@hisilicon.com>,
        <prime.zeng@hisilicon.com>, <yangxingui@huawei.com>
From:   Yihang Li <liyihang9@huawei.com>
Message-ID: <fe9b63da-fa50-e7c4-495e-d02ade4f8cc3@huawei.com>
Date:   Sun, 23 Oct 2022 15:07:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20221020141635.2479412-1-liyihang9@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.100.231]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Sorry, I sent the wrong email address, please ignore this series.

Yihang

On 2022/10/20 22:16, Yihang Li wrote:
> SATA devices attached to an expander maybe generate incorrect IOs when
> physical link re-establish at a lower link rate. This is due to the
> expander PHY attached to a SATA PHY is using link rate greater than the
> physical PHY link rate which is re-established.
> 
> This patchset fixes the issue.
> 
> Yihang Li (2):
>   scsi: libsas: Add sas_update_linkrate()
>   scsi: libsas: Add sas_check_port_linkrate()
> 
>  drivers/scsi/libsas/sas_discover.c | 18 +++++++++++++-
>  drivers/scsi/libsas/sas_expander.c | 40 ++++++++++++++++++++++++++++++
>  drivers/scsi/libsas/sas_internal.h |  1 +
>  3 files changed, 58 insertions(+), 1 deletion(-)
> 
