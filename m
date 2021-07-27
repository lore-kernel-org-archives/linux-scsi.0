Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D2EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F5E661077
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhG0C6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:58:43 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:39840 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbhG0C6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 22:58:42 -0400
Received: by mail-pl1-f172.google.com with SMTP id e5so12257123pld.6;
        Mon, 26 Jul 2021 20:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sZkIhanFYkY2vIMYu6ANcE0looF7hlq8r4h6+faW4J0=;
        b=FBg4Yi9D1YHrAeIzMzFXtaFFR3iQE0or8//6sJoCuKdMC3rRio2ALmvaMx7f3u+NPw
         rvimvexGMpFRRUSpwOtQuV4cqsmjqB+C2LSSfi2mJpD1ZdWPNW7iAqoQvBMXyNJAaj/q
         e7bz0T+kljeT/uY15kqH+cuoxiZqlL4GHzM2DDwUtGRnTrfe0WIdaX6hoxnGWBS+h8Ek
         UHDBgFW+UqVhKnAwDY7JcXSXKDzEUla+BqA+jIBAYzHHH0OHSYS/UxNI8T3yxM56hPTc
         CSRLuUIbee0/AzhtOBZgfBiSoSCNKA+LOXlr+CPSdLn49OUM7yPtLHH0O2O2mi6bsE50
         VFoQ==
X-Gm-Message-State: AOAM532FDVgIx6mlriiSfWA3I3w0/Wxzx/9b99l7sn4TwE0xAGknEXnc
        efkSY5zqTInJ8tQMKCryi4o=
X-Google-Smtp-Source: ABdhPJwcN/DeItXsgz5Ve8vngqdPqGw3Q61lpvRxCQzLQN1T3d5HD2d+CXKNqI1w2Wzx+037CnbA1g==
X-Received: by 2002:aa7:9ec3:0:b029:32b:4eb5:4bad with SMTP id r3-20020aa79ec30000b029032b4eb54badmr20957694pfq.6.1627357147654;
        Mon, 26 Jul 2021 20:39:07 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:d009:b5bd:a16e:1de3? ([2601:647:4000:d7:d009:b5bd:a16e:1de3])
        by smtp.gmail.com with ESMTPSA id b3sm1585811pfi.179.2021.07.26.20.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 20:39:07 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: Fix the issue that the disk capacity set to zero
To:     lijinlin3@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     john.garry@huawei.com, yanaijie@huawei.com, linfeilong@huawei.com,
        wubo40@huawei.com
References: <20210727034455.1494960-1-lijinlin3@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <54403480-2a57-ba54-57eb-927d706cafed@acm.org>
Date:   Mon, 26 Jul 2021 20:39:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210727034455.1494960-1-lijinlin3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/21 8:44 PM, lijinlin3@huawei.com wrote:
> From: lijinlin <lijinlin3@huawei.com>
> 
> After add physical volumes to a volume group through vgextend, kernel
> will rescan partitions, which will read the capacity of the device.
> If the device status is set to offline through sysfs at this time,
> read capacity command will return a result which the host byte is
> DID_NO_CONNECT, the capacity of the device will be set to zero in
> read_capacity_error(). However, the capacity of the device can't be
> reread after reset the device status to running, is still zero.
> 
> Fix this issue by rescan device when the device state changes to
> SDEV_RUNNING.
> 
> Signed-off-by: lijinlin <lijinlin3@huawei.com>
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 32489d25158f..ae9bfc658203 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -807,11 +807,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>  	mutex_lock(&sdev->state_mutex);
>  	ret = scsi_device_set_state(sdev, state);
>  	/*
> -	 * If the device state changes to SDEV_RUNNING, we need to run
> -	 * the queue to avoid I/O hang.
> +	 * If the device state changes to SDEV_RUNNING, we need to
> +	 * rescan the device to revalidate it, and run the queue to
> +	 * avoid I/O hang.
>  	 */
> -	if (ret == 0 && state == SDEV_RUNNING)
> +	if (ret == 0 && state == SDEV_RUNNING) {
> +		scsi_rescan_device(dev);
>  		blk_mq_run_hw_queues(sdev->request_queue, true);
> +	}
>  	mutex_unlock(&sdev->state_mutex);
>  
>  	return ret == 0 ? count : -EINVAL;

In the future, please mention what has been changed between v1 and v2
under the three dashes ("---"). Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
