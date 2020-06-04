Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62888C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 06:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41003205CB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 06:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgFDGGA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 02:06:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:54212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDGF7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jun 2020 02:05:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 77FA1AFC1;
        Thu,  4 Jun 2020 06:06:01 +0000 (UTC)
Subject: Re: [PATCH] scsi: Fix incorrect usage of shost_for_each_device
To:     Ye Bin <yebin10@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200518074420.39275-1-yebin10@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c772dacb-b16a-e404-4333-ab5abf6daaf9@suse.de>
Date:   Thu, 4 Jun 2020 08:05:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518074420.39275-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/18/20 9:44 AM, Ye Bin wrote:
> shost_for_each_device(sdev, shost) \
> 	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
> 	     (sdev); \
> 	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
> 
> When terminating shost_for_each_device() iteration with break or return,
> scsi_device_put() should be used to prevent stale scsi device references from
> being left behind.
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   drivers/scsi/scsi_error.c | 2 ++
>   drivers/scsi/scsi_lib.c   | 4 +++-
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 978be1602f71..927b1e641842 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1412,6 +1412,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
>   				sdev_printk(KERN_INFO, sdev,
>   					    "%s: skip START_UNIT, past eh deadline\n",
>   					    current->comm));
> +			scsi_device_put(sdev);
>   			break;
>   		}
>   		stu_scmd = NULL;
> @@ -1478,6 +1479,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>   				sdev_printk(KERN_INFO, sdev,
>   					    "%s: skip BDR, past eh deadline\n",
>   					     current->comm));
> +			scsi_device_put(sdev);
>   			break;
>   		}
>   		bdr_scmd = NULL;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index be1a4a9a5fca..173bc7fc2836 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2859,8 +2859,10 @@ scsi_host_unblock(struct Scsi_Host *shost, int new_state)
>   
>   	shost_for_each_device(sdev, shost) {
>   		ret = scsi_internal_device_unblock(sdev, new_state);
> -		if (ret)
> +		if (ret) {
> +			scsi_device_put(sdev);
>   			break;
> +		}
>   	}
>   	return ret;
>   }
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
