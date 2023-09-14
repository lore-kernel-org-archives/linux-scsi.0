Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61330EEAA50
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 14:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbjINOtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Sep 2023 10:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240457AbjINOtJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2023 10:49:09 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA9F2D4F;
        Thu, 14 Sep 2023 07:48:52 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1bf6ea270b2so7955575ad.0;
        Thu, 14 Sep 2023 07:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694702931; x=1695307731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MUVkVGd2/O30yuMMSc55V+qBaodFy5pKsA3QVk7wARk=;
        b=imJ4p9vpbPnQB9QkKA4Mq4IRg/R8rs3GkZIPqWKYxAnEHSjGA0zEPhJM8wyFJDqYhn
         vYMzyM0TxQcW527tgq8hUo2MUvcvk+7dbbr2v1aa7PzS3pOSE9h3s1UlmyRni+zjLWKB
         Rq1IaiTdYrO11uyZjuOZs4WoGPsEKjp/DISDHAe/iHdCSsSyuaKrW3ciuAspHWpCvDQf
         FQofcHqF4/LKcs8eGUgHEPiUukTI5AGanB1MBITChQunf5LKud7+aPWdPrid895OAB1y
         9bB1/dva+eEeKyanAE92CbkBGCQHKBinLXsuyv9Hs84Gw87RRo4J21sy3S+YtTbRfjxE
         zEvA==
X-Gm-Message-State: AOJu0YxJ5IjJk53Jor96hVcBgTOZSfMsWPdegQwFzx8kZsxFdQGW6ZDZ
        nfEb6S3wC/+bpYzn3lDhBHRpnSxXZyo=
X-Google-Smtp-Source: AGHT+IGpaI4gfXp4LnO69V/jyJ0hmZsCzM4emofgB4hjbQSpfjLZKfuVxVxxTFgsGjhG+OewRwlOCA==
X-Received: by 2002:a17:902:c20d:b0:1bb:1523:b311 with SMTP id 13-20020a170902c20d00b001bb1523b311mr5909518pll.41.1694702931465;
        Thu, 14 Sep 2023 07:48:51 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b001b896d0eb3dsm1691650plb.8.2023.09.14.07.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 07:48:50 -0700 (PDT)
Message-ID: <b706672c-5f43-4a78-a976-0a47093ec612@acm.org>
Date:   Thu, 14 Sep 2023 07:48:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/21] scsi: sd: Do not issue commands to suspended
 disks on remove
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230912005655.368075-1-dlemoal@kernel.org>
 <20230912005655.368075-8-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230912005655.368075-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 17:56, Damien Le Moal wrote:
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
> Reviewed-by: Hannes Reinecke <hare@suse.de>
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

The above seems wrong to me because no SYNCHRONIZE CACHE command will be
sent even if the device is still present, if the SCSI error handler is
active and if it will succeed at a later time. How about replacing the
above patch with something like the untested patch below?

Thanks,

Bart.


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4cd281368826..c0e069d9d58e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3689,12 +3689,14 @@ static int sd_probe(struct device *dev)
  static int sd_remove(struct device *dev)
  {
  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	int rpm_get_res;

-	scsi_autopm_get_device(sdkp->device);
+	rpm_get_res = scsi_autopm_get_device(sdkp->device);

  	device_del(&sdkp->disk_dev);
  	del_gendisk(sdkp->disk);
-	sd_shutdown(dev);
+	if (rpm_get_res >= 0)
+		sd_shutdown(dev);

  	put_disk(sdkp->disk);
  	return 0;

