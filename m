Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5595FC3A5A7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 07:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DC45233A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 07:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfH1HPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 03:15:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:60000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfH1HPq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 03:15:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88DA3AE0C;
        Wed, 28 Aug 2019 07:15:45 +0000 (UTC)
Subject: Re: [PATCH] lpfc: Raise config max for lpfc_fcp_mq_threshold variable
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
References: <20190827212823.30107-1-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dd45e95e-d714-a2a5-325c-73c46a183228@suse.de>
Date:   Wed, 28 Aug 2019 09:15:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190827212823.30107-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/27/19 11:28 PM, James Smart wrote:
> Raise the config max for lpfc_fcp_mq_threshold variable to 256.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> CC: Hannes Reinecke <hare@suse.de>
> 
> ---
> Martin, this fix applies 5.3/scsi-fixes patch:
>    scsi: lpfc: Mitigate high memory pre-allocation by SCSI-MQ
> ---
>   drivers/scsi/lpfc/lpfc_attr.c | 2 +-
>   drivers/scsi/lpfc/lpfc_sli4.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 491a999056aa..25aa7a53d255 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -5713,7 +5713,7 @@ LPFC_ATTR_RW(nvme_embed_cmd, 1, 0, 2,
>    *      0    = Set nr_hw_queues by the number of CPUs or HW queues.
>    *      1,128 = Manually specify the maximum nr_hw_queue value to be set,
>    *
> - * Value range is [0,128]. Default value is 8.
> + * Value range is [0,256]. Default value is 8.
>    */
>   LPFC_ATTR_R(fcp_mq_threshold, LPFC_FCP_MQ_THRESHOLD_DEF,
>   	    LPFC_FCP_MQ_THRESHOLD_MIN, LPFC_FCP_MQ_THRESHOLD_MAX,
> diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
> index 2d1823e449aa..a4be83d1f37e 100644
> --- a/drivers/scsi/lpfc/lpfc_sli4.h
> +++ b/drivers/scsi/lpfc/lpfc_sli4.h
> @@ -46,7 +46,7 @@
>   
>   /* FCP MQ queue count limiting */
>   #define LPFC_FCP_MQ_THRESHOLD_MIN	0
> -#define LPFC_FCP_MQ_THRESHOLD_MAX	128
> +#define LPFC_FCP_MQ_THRESHOLD_MAX	256
>   #define LPFC_FCP_MQ_THRESHOLD_DEF	8
>   
>   /* Common buffer size to accomidate SCSI and NVME IO buffers */
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
