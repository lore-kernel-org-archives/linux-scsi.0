Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C3CEE645F
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 14:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbjIOObi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 10:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbjIOObh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 10:31:37 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3CD1FC9;
        Fri, 15 Sep 2023 07:31:31 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-56a8794b5adso1793725a12.2;
        Fri, 15 Sep 2023 07:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694788291; x=1695393091;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fXS8yoMLLny75WhuNl56XAbrqF23kLgKHPb5MO6rD3M=;
        b=vunD2JrO8JXwWYuI/iMDkvqSGwArNReUqckOu9OY6xSboBVejr1H/7ogowsoNAc6FZ
         M1CHOA/2ayvknK4IKZYD9oIpsiCjlLbCct4tegT/TAaZ8Se61jwVrfHecNwEXSiNWWlK
         V7c+kRH0UGfYOSK8U4XPKneij5zA1+ZlQJTc12QPpjkSnGakV4gsRFlWYMLxUBsCutRE
         evpQmXWRKGPNcUiByPCrNIRAg5UrWkHI2DFYeH0ddSqZjp8J3Yby5A1aOEjf4L9ZHWA5
         sufN1k+TcTURq09PyDBCzZeiynKRxytPKK6O5ysIXfvXQkKFxqUpwVd9HUrEaXIBYLAb
         n+XQ==
X-Gm-Message-State: AOJu0YxQ0mrGAs4X2SbGb617TxbQbbn8rFUvuZVilvPAnxkL9gKAt1Hv
        qFp5wGr0pbQY8+Yu9FcpQ2Q=
X-Google-Smtp-Source: AGHT+IFpQkyiCfFmjcI8MPN8UMdALykMkY0Xdk9HkHqlx2reopXkqEkW2XGV81TAaTbSS9wldsgkeQ==
X-Received: by 2002:a17:90b:2343:b0:274:4161:b9dc with SMTP id ms3-20020a17090b234300b002744161b9dcmr1734828pjb.31.1694788290697;
        Fri, 15 Sep 2023 07:31:30 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id 24-20020a17090a001800b002681bda127esm3345890pja.35.2023.09.15.07.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 07:31:30 -0700 (PDT)
Message-ID: <efdb3536-f7f5-4182-a9f3-b3080b4c0975@acm.org>
Date:   Fri, 15 Sep 2023 07:31:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-10-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230915081507.761711-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 01:14, Damien Le Moal wrote:
> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. This in turn results in a call to sd_shutdown() which
> will issue a synchronize cache command and a start stop unit command to
> spindown the disk. sd_shutdown() issues the commands only if the device
> is not already suspended but does not check the power state for
> system-wide suspend/resume. That is, the commands may be issued with the
> device in a suspended state, which causes PM resume to hang, forcing a
> reset of the machine to recover.
> 
> Fix this by not calling sd_shutdown() in sd_remove() if the device
> is not running.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1d106c8ad5af..d86306d42445 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3727,7 +3727,8 @@ static int sd_remove(struct device *dev)
>   
>   	device_del(&sdkp->disk_dev);
>   	del_gendisk(sdkp->disk);
> -	sd_shutdown(dev);
> +	if (sdkp->device->sdev_state == SDEV_RUNNING)
> +		sd_shutdown(dev);
>   
>   	put_disk(sdkp->disk);
>   	return 0;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
