Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84762C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6C8619F6
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353232AbhI3SIH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:08:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3904 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353098AbhI3SHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 14:07:46 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HL1Lg3xFNz67Lng;
        Fri,  1 Oct 2021 02:03:07 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 20:06:01 +0200
Received: from [10.47.26.77] (10.47.26.77) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 30 Sep
 2021 19:06:00 +0100
Subject: Re: [PATCH v2 45/84] libsas: Call scsi_done() directly
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Lee Duncan <lduncanb@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>,
        <lduncanb@suse.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-46-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a2a1eaf0-91cd-df48-eca8-1b1e03ecd3e9@huawei.com>
Date:   Thu, 30 Sep 2021 19:08:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210929220600.3509089-46-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.26.77]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/09/2021 23:05, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Reviewed-by: Lee Duncan <lduncanb@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Hi Bart,

Can you double-check these tags, as I know I provided a RB tag, but I'm 
not sure about Lee?

Thanks

> ---
>   drivers/scsi/libsas/sas_scsi_host.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 2bf37151623e..d337fdf1b9ca 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -125,7 +125,7 @@ static void sas_scsi_task_done(struct sas_task *task)
>   	}
>   
>   	sas_end_task(sc, task);
> -	sc->scsi_done(sc);
> +	scsi_done(sc);
>   }
>   
>   static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
> @@ -198,7 +198,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   	else
>   		cmd->result = DID_ERROR << 16;
>   out_done:
> -	cmd->scsi_done(cmd);
> +	scsi_done(cmd);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(sas_queuecommand);
> .
> 

