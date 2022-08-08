Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECEFC19F2A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Aug 2022 02:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiHHChn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Aug 2022 22:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiHHChm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2022 22:37:42 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA09B10A7
        for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2022 19:37:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VLbiN8e_1659926256;
Received: from 192.168.3.3(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VLbiN8e_1659926256)
          by smtp.aliyun-inc.com;
          Mon, 08 Aug 2022 10:37:37 +0800
Message-ID: <5e0b3b8a-7728-9fda-d952-411d0fa1938d@linux.alibaba.com>
Date:   Mon, 8 Aug 2022 10:37:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH] scsi: megaraid_sas: fix double kfree
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <1659424729-46502-1-git-send-email-kanie@linux.alibaba.com>
In-Reply-To: <1659424729-46502-1-git-send-email-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Gentle ping.

在 2022/8/2 15:18, Guixin Liu 写道:
> When alloc log_to_span fail, call kfree(instance->ctrl_context) first,
> then jump to megasas_free_ctrl_mem() in megasas_init_fw(), call
> kfree(instance->ctrl_context) second.
>
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 5b5885d..3e9b2b0 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -5311,7 +5311,6 @@ void megasas_fusion_ocr_wq(struct work_struct *work)
>   		if (!fusion->log_to_span) {
>   			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
>   				__func__, __LINE__);
> -			kfree(instance->ctrl_context);
>   			return -ENOMEM;
>   		}
>   	}
