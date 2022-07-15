Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2508CC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 16:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbiGOQt1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 12:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiGOQt0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 12:49:26 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F0012AE9
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 09:49:25 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id v7so5166600pfb.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 09:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=inCBo+/btCFN0ogWc5b4UYYNn0HFnbQdDJtBtJ8yrrs=;
        b=TJtnvonSG3AU5RjPuaxGCwTpWSUVpLB+ZTWDctyReSuH3z0MTkfCy8jLEYcOA78bbT
         kur3A12D3u2SWfY/Oh/c82Qhcv5dIXYRO2k7ad8+pLKi5MrqugjbyVWQQIFcM6CAkzlV
         Rk0SEaNk35yqakO2lHzZ05IkTCynA/CCza8MwGrPTcvSSUtQmzZRyLxvSmpYMWshiEgG
         ePCf+Dz38vqT8IT3lmvd8jog2ETHHUMBraWD0N/jZ2coLE7VBWihuk/EDGfyW275vlbM
         f2vpxWnuOVknu5NWiHtZOR8Q3DkQxFO8G55LBvVRhZAvUef6OSqKecf/icZv/7RroKUZ
         g5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=inCBo+/btCFN0ogWc5b4UYYNn0HFnbQdDJtBtJ8yrrs=;
        b=MEYIoKFHHjc+CiJzUenKnD1cD/Z1BndHTN6j5eAySSKY603ohEQMLV34lUSJay8HA9
         0aEyWWL4qZhzjWTieW1ClbGB/iMdi+nQZPaM7+DM3KoFagbNjZVCMkjmqnSnU2MzXFSR
         zNvdor2xMEAavPbEkTc7109EadKtd6aBQSeH64v82DUR1pfI9Z4UosIPowTvqirAddqn
         3k4QBjgphBO3awKd8mcuxXDdefibSmMlhoj/+qYJ9MyIL4AXCdpag2PuaJKbua+buo70
         2XhEFrjxPK7Px6buqGMJ5Rf1Homdq+vviacM4EUyEXBMAZP66tB8FlDztk4jN3ifmtqI
         oavQ==
X-Gm-Message-State: AJIora8epf/kfzktNRY+UNqexVR/AE+ygccslb7JGv5owLCpAPfpcH9v
        MRHUMDZ7il7pbfGRiUs6RlA=
X-Google-Smtp-Source: AGRyM1vIpKcu8znfIaAuab98b30cx+MGxOdEx4EL1noxFnot7kEWiugnVOzolZgpFrRvaxtMUNpB8A==
X-Received: by 2002:a63:389:0:b0:415:dde9:4507 with SMTP id 131-20020a630389000000b00415dde94507mr13441138pgd.117.1657903765385;
        Fri, 15 Jul 2022 09:49:25 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902c94300b0016c36b368d1sm3813688pla.150.2022.07.15.09.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 09:49:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3a869ecf-bd82-2e72-2ec9-7b67a20c2d63@roeck-us.net>
Date:   Fri, 15 Jul 2022 09:49:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/1] mpi3mr: Fix compilation errors observed on i386 arch
Content-Language: en-US
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <20220715150219.16875-1-sreekanth.reddy@broadcom.com>
 <20220715150219.16875-2-sreekanth.reddy@broadcom.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220715150219.16875-2-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/15/22 08:02, Sreekanth Reddy wrote:
> Fix below compilation errors observed on i386 ARCH,
> 
> cast from pointer to integer of different size
> [-Werror=pointer-to-int-cast]
> 
> Fixes: c196bc4dce ("scsi: mpi3mr: Reduce VD queue depth on detecting throttling")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 0901bc932d5c..d8013576d863 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
>   		ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
>   		return;
>   	}
> -	*(__le64 *)fwevt->event_data = (__le64)tg;
> +	memcpy(fwevt->event_data, (char *)&tg, sizeof(u64));
>   	fwevt->mrioc = mrioc;
>   	fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
>   	fwevt->send_ack = 0;
> @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>   	{
>   		struct mpi3mr_throttle_group_info *tg;
>   
> -		tg = (struct mpi3mr_throttle_group_info *)
> -		    (*(__le64 *)fwevt->event_data);
> +		memcpy((char *)&tg, fwevt->event_data, sizeof(u64));

How is this expected to work on a system with 32-bit pointers ?

Guenter

>   		dprint_event_bh(mrioc,
>   		    "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
>   		    tg->id, tg->need_qd_reduction);

