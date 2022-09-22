Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF18BC6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 08:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiIVIOA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 04:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIVIN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 04:13:59 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F21CD1D4
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 01:13:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=gumi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VQRoM6W_1663834434;
Received: from 30.178.81.208(mailfrom:gumi@linux.alibaba.com fp:SMTPD_---0VQRoM6W_1663834434)
          by smtp.aliyun-inc.com;
          Thu, 22 Sep 2022 16:13:55 +0800
Message-ID: <620ba343-6c5e-51b6-c115-287df48f4610@linux.alibaba.com>
Date:   Thu, 22 Sep 2022 16:13:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: [PATCH] scsi: mpt3sas: Modify the comment and exception return value
 of function _base_get_event_diag_triggers()
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <1663580962-64851-1-git-send-email-gumi@linux.alibaba.com>
From:   Gu Mi <gumi@linux.alibaba.com>
In-Reply-To: <1663580962-64851-1-git-send-email-gumi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> For function _base_get_event_diag_triggers(), it has a return
> value, but the description of the comment information is
> incorrect. In addition, in the abnormal process, 0 should
> not be returned, 0 means success, here an abnormal value
> needs to be return, In order to retry after an exception
> occurs, the setting returns to -EAGAIN, from code analysis,
> it will not cause infinite retries.
>
> Signed-off-by: Gu Mi <gumi@linux.alibaba.com>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 565339a..dabbab6 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5025,7 +5025,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
>    *				persistent pages
>    * @ioc : per adapter object
>    *
> - * Return: nothing.
> + * Return: zero on success; otherwise return EAGAIN error codes
> + * asking the caller to retry.
>    */
>   static int
>   _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
> @@ -5050,7 +5050,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
>   		    ioc_err(ioc,
>   		    "%s: Failed to get trigger pg2, ioc_status(0x%04x)\n",
>   		   __func__, ioc_status));
> -		return 0;
> +		return -EAGAIN;
>   	}
>   
>   	if (le16_to_cpu(trigger_pg2.NumMPIEventTrigger)) {
