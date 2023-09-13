Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8A1EE020D
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 20:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjIMUvG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjIMUvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 16:51:05 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522881BCA;
        Wed, 13 Sep 2023 13:51:01 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-573ccec985dso158396a12.2;
        Wed, 13 Sep 2023 13:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694638261; x=1695243061;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Msn0U1VWh9oVe5foHqcoipC16WJL8JKILJwhgE7Qyeg=;
        b=xMSRypzujqFclDSPLDgogZpvrWst25qwSxw2eA3JOByoOiZ7kHUQ4pfM66lr1An/du
         6xYDorVGrCuZuQpAwNH0e1ejWfWP3Rzop4uONd8mS9+efVuIMqdnX/kcOxS11R0YWmwz
         YapZleqr0hTNuL+qd4dAjxle9SDwPYZqREmgRZQtc+p0DLcmVC9prZ4W8HEf8cWe6b0n
         mKdT4Eix5CMTzKa2ALdbmxte3TPZUeBV3qD3n2V+ijicmg1E5XzWAbmx2uPm3pnEqfiA
         hs4lKjsuRvFa3tb6go5/PdMzmyIVelUnCwlerHXyQEaNQjHh0S2zeSfqZwHvtrgCzNyy
         1UYQ==
X-Gm-Message-State: AOJu0YxkqCjuqMBMGyw+45sOngrMB/eeGgz+JONA7vIaBb12mBbSpj2S
        kTla43Of84OkF4Imyx4h114=
X-Google-Smtp-Source: AGHT+IGFHd0+C0PoovBNU3xq0ujnBaeYDlUnoPQzNgO39uRyeE6Rfne9TmubdDoci25R6qjsB029Mw==
X-Received: by 2002:a17:90a:e7d0:b0:273:f229:a479 with SMTP id kb16-20020a17090ae7d000b00273f229a479mr3366975pjb.34.1694638260505;
        Wed, 13 Sep 2023 13:51:00 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id gp2-20020a17090adf0200b002680dfd368dsm36605pjb.51.2023.09.13.13.50.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 13:51:00 -0700 (PDT)
Message-ID: <c3a4ccb9-2e4d-906c-3c8f-1985a2d444a8@acm.org>
Date:   Wed, 13 Sep 2023 13:50:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 07/19] scsi: sd: Do not issue commands to suspended disks
 on remove
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-8-dlemoal@kernel.org>
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230911040217.253905-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/10/23 21:02, Damien Le Moal wrote:
> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. However, since this function calls sd_shutdown(),
> a synchronize cache command and a start stop unit may be issued with the
> drive still sleeping and the HBA non-functional. This causes PM resume
> to hang, forcing a reset of the machine to recover.
> 
> Fix this by checking a device host state in sd_shutdown() and by
> returning early doing nothing if the host state is not SHOST_RUNNING.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c92a317ba547..a415abb721d3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3763,7 +3763,8 @@ static void sd_shutdown(struct device *dev)
>   	if (!sdkp)
>   		return;         /* this can happen */
>   
> -	if (pm_runtime_suspended(dev))
> +	if (pm_runtime_suspended(dev) ||
> +	    sdkp->device->host->shost_state != SHOST_RUNNING)
>   		return;
>   
>   	if (sdkp->WCE && sdkp->media_present) {

Why to test the host state instead of dev->power.runtime_status? I don't
think that it is safe to skip shutdown if the error handler is active.
If the error handler can recover the device a SYNCHRONIZE CACHE command
should be submitted.

Thanks,

Bart.
