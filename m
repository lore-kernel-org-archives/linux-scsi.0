Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EFEECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 09:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiINJcE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 05:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiINJbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 05:31:47 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3D264D8
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 02:21:36 -0700 (PDT)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MSF8k4FrZz67p52;
        Wed, 14 Sep 2022 17:17:10 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Wed, 14 Sep 2022 11:21:34 +0200
Received: from [10.48.151.55] (10.48.151.55) by lhrpeml500003.china.huawei.com
 (7.191.162.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 10:21:33 +0100
Message-ID: <0c708d51-e853-f5e6-dc93-cb43ff2e4109@huawei.com>
Date:   Wed, 14 Sep 2022 10:21:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 0/4] Prepare for constifying SCSI host templates
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
References: <20220913195716.3966875-1-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220913195716.3966875-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.151.55]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/09/2022 20:57, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series prepares for constifying SCSI host templates by moving the
> members that are not constant out of the SCSI host template. Please consider
> this patch series for the next merge window.
> 
> Thanks,
> 

note: I find that this series does not apply cleanly to mkp-scsi 6.1 
staging (which I guess it should), but ok for v6.0-c5

Thanks,
John

> Bart.
> 
> Changes compared to v3:
> - Changed the 'present' counter from 8 to 32 bits.
> - Fixed a bug in an error path (reported by John Garry).
> - Changed EXPORT_SYMBOL() into EXPORT_SYMBOL_GPL().
> - Split patch 1/3 into two patches.
> 
> Changes compared to v2:
> - Optimized the show_info == NULL case.
> - Added a patch that removes the code that clears the module pointer in the host
>    template.
> 
> Changes compared to v1:
> - Fix the CONFIG_SCSI_PROC_FS=n build.
> 
> Bart Van Assche (4):
>    scsi: esas2r: Initialize two host template members implicitly
>    scsi: esas2r: Introduce scsi_template_proc_dir()
>    scsi: core: Introduce a new list for SCSI proc directory entries
>    scsi: core: Rework the code for dropping the LLD module reference
> 
>   drivers/scsi/esas2r/esas2r_main.c |  19 +++--
>   drivers/scsi/scsi_priv.h          |   4 +-
>   drivers/scsi/scsi_proc.c          | 120 ++++++++++++++++++++++++++----
>   drivers/scsi/scsi_sysfs.c         |   7 +-
>   include/scsi/scsi_device.h        |   1 +
>   include/scsi/scsi_host.h          |  18 ++---
>   6 files changed, 127 insertions(+), 42 deletions(-)
> 
> 
> .

