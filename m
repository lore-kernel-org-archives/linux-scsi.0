Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E569C7EE2D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 02:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbjFBCiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjFBCiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 22:38:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4259B18D;
        Thu,  1 Jun 2023 19:38:01 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QXRrF6D2lzqTbZ;
        Fri,  2 Jun 2023 10:33:17 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 10:37:58 +0800
Subject: Re: [PATCH] ata: libata-sata: Simplify ata_change_queue_depth()
To:     Damien Le Moal <dlemoal@kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     John Garry <john.g.garry@oracle.com>
References: <20230601222607.263024-1-dlemoal@kernel.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <a21cd2a8-fe80-0201-38c6-62945dfb6698@huawei.com>
Date:   Fri, 2 Jun 2023 10:37:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230601222607.263024-1-dlemoal@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/6/2 6:26, Damien Le Moal wrote:
> Commit 141f3d6256e5 ("ata: libata-sata: Fix device queue depth control")
> added a struct ata_device argument to ata_change_queue_depth() to
> address problems with changing the queue depth of ATA devices managed
> through libsas. This was due to problems with ata_scsi_find_dev() which
> are now fixed with commit 7f875850f20a ("ata: libata-scsi: Use correct
> device no in ata_find_dev()").
> 
> Undo some of the changes of commit 141f3d6256e5: remove the added struct
> ata_device aregument and use again ata_scsi_find_dev() to find the
> target ATA device structure. While doing this, also make sure that
> ata_scsi_find_dev() is called with ap->lock held, as it should.
> 
> libsas and libata call sites of ata_change_queue_depth() are updated to
> match the modified function arguments.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> ---
>   drivers/ata/libata-sata.c           | 19 ++++++++++---------
>   drivers/scsi/libsas/sas_scsi_host.c |  3 +--
>   include/linux/libata.h              |  4 ++--
>   3 files changed, 13 insertions(+), 13 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>

Thanks,
Jason
