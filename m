Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A0ECA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 16:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D869120679
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 16:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410006AbfJXQ5p convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:57:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34153 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410003AbfJXQ5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 12:57:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id k7so12167397pll.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2019 09:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UCChcMMO2mnLYCYMjv4y0CkUxDSZX2QqeO6cOTn0LcA=;
        b=XWwwt8EN1wmnYEzT5BndzsWTD84jckttvhDVCa4bN7FitNlZ2FZ63MRl0noowRw0eZ
         3AAojg+NRQzrFk2TkQjnFB/5PG/PLfd82BonZrJ7XrLwW4VJGQ34JxhcPR/mP0r11nh8
         O69FXa51QpI5QwuE0xHb3yF+VaF2nIaYMSPUEuShCgooFT+gE9L8kwCdnvT65nzujnNy
         AvdhhwSr1LK6fXaolUe4gz5IRCUfMN1EbbsnjlrU0uUy/J5u0bu84OHjjSAupT6RK/Lx
         lDwv1iXxdH3rxCZFaOLJE+0EzNfQ/CHVTslpJS0Yi+XvnBO4EW+tDs28/z4rf950zvzS
         bauQ==
X-Gm-Message-State: APjAAAUubRTHHKhcOFbL1orCEcmFaqrLvMqahNniLDQ0ePjeAJRCAndH
        Z6zdxNHNTIllh9/Sp7eHc/w=
X-Google-Smtp-Source: APXvYqzt/ifU14lSRs3Sq+z87x1S3loWuoT9krPFltXKyaHeIc9fObnTKN0wDC79ySaibAwxCHUppA==
X-Received: by 2002:a17:902:b70f:: with SMTP id d15mr13244435pls.210.1571936263809;
        Thu, 24 Oct 2019 09:57:43 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id k32sm3192285pje.10.2019.10.24.09.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 09:57:42 -0700 (PDT)
Subject: Re: [PATCH] scsi:sd: define variable dif as unsigned int instead of
 bool
To:     chenxiang <chenxiang66@hisilicon.com>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com
Cc:     linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        john.garry@huawei.com
References: <1571725628-132736-1-git-send-email-chenxiang66@hisilicon.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <93832371-e007-bd88-bb0a-5e3ebe628b14@acm.org>
Date:   Thu, 24 Oct 2019 09:57:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571725628-132736-1-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/19 11:27 PM, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> Variable dif in function sd_setup_read_write_cmnd() is the return value
> of function scsi_host_dif_capable() which returns dif capability of disks.
> If define it as bool, even for the disks which support DIF3, the function
> still return dif=1, which causes IO error. So define variable dif as
> unsigned int instead of bool.
> 
> Fixes: e249e42d277e ("scsi: sd: Clean up sd_setup_read_write_cmnd()")
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/scsi/sd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 32d9517..a763b70 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1166,11 +1166,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>  	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
>  	sector_t threshold;
>  	unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
> -	bool dif, dix;
>  	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
>  	bool write = rq_data_dir(rq) == WRITE;
>  	unsigned char protect, fua;
>  	blk_status_t ret;
> +	unsigned int dif;
> +	bool dix;
>  
>  	ret = scsi_init_io(cmd);
>  	if (ret != BLK_STS_OK)
> 

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

