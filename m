Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F45C38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 20:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiIHULj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 16:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIHULh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 16:11:37 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186129827
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 13:11:36 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d12so18992855plr.6
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 13:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tZAdcEnEI2qSyi8f6Jm/E9EQr/MYDtHHlOAvKSI5dq4=;
        b=Cum+Y1PvvNdECApUhw2O0Vm3pVcpjuZu7i38AD8pGyvdmL0LeH/Axav3ZAgcCYKf78
         hgDEibXFE/7uygJaJqCGPlj3S7Li3C4QQIZ0SNm1N4ysswtJ72RXdJbykKHgMg4iTMT2
         25goiKPh/uv8I+i5e+FepleZoxmqw2V2sGjT+QlqQla0ETHGQzupFcr96ZFpr9J5iqXJ
         RC3/ztvwXBI2Za1srahmLEqpj5K+W5wWE+onQuUiTrBEU8Lbz4zumGwRFP4Y9hJL+20U
         1WVH/cGLcHsLl6sCZdzelFvM8NaxlyHqzwoiy5s0n6UKKQ6DrtNtJbTJttj3psFEuuOd
         2R5g==
X-Gm-Message-State: ACgBeo1fA7ceeMvTVyy1ld20SVkKMo16DmmWu0crbwbTf0fP22eqEFAp
        TdqjnrlD0ECGTJfsXEhJ4zY=
X-Google-Smtp-Source: AA6agR4y7/7rnYsefnTv2QEEA2X/B2iJj5KEbLC/fqHhMJshcisJIrFAWYgO9UHL6/UFistSYdCelw==
X-Received: by 2002:a17:902:8f8a:b0:170:8df4:eebd with SMTP id z10-20020a1709028f8a00b001708df4eebdmr10562929plo.116.1662667895045;
        Thu, 08 Sep 2022 13:11:35 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:71db:3cdf:3590:2e95? ([2620:15c:211:201:71db:3cdf:3590:2e95])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ce8200b0015e8d4eb1d5sm9893993plg.31.2022.09.08.13.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 13:11:34 -0700 (PDT)
Message-ID: <2fc28d89-102c-45cb-9ddf-7b89b69871ca@acm.org>
Date:   Thu, 8 Sep 2022 13:11:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 0/2] Prepare for constifying SCSI host templates
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org
References: <20220830210509.1919493-1-bvanassche@acm.org>
 <9e9a24a0-3d04-306f-b8f6-dfe5fe03efab@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9e9a24a0-3d04-306f-b8f6-dfe5fe03efab@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/22 07:23, John Garry wrote:
> And at least we have the scsi_host_template.module issue to solve - any plan or progress for that?

Hi John,

How about the following (entirely untested) patch?


Subject: [PATCH] scsi: core: Rework the code for dropping the kernel module reference

Instead of clearing the host template module pointer if the LLD kernel
module is being unloaded, set the 'drop_module_ref' SCSI device member.
This patch prepares for constifying the SCSI host template.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/scsi_sysfs.c  | 7 +++----
  include/scsi/scsi_device.h | 1 +
  2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5d61f58399dc..822ae60a64b9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -454,7 +454,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)

  	sdev = container_of(work, struct scsi_device, ew.work);

-	mod = sdev->host->hostt->module;
+	mod = sdev->drop_module_ref ? sdev->host->hostt->module : NULL;

  	scsi_dh_release_device(sdev);

@@ -525,9 +525,8 @@ static void scsi_device_dev_release(struct device *dev)
  {
  	struct scsi_device *sdp = to_scsi_device(dev);

-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
+	if (try_module_get(sdp->host->hostt->module))
+		sdp->drop_module_ref = true;

  	execute_in_process_context(scsi_device_dev_release_usercontext,
  				   &sdp->ew);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2493bd65351a..b03176b69056 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -214,6 +214,7 @@ struct scsi_device {
  					 * creation time */
  	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
  	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
+	unsigned drop_module_ref:1;

  	unsigned int queue_stopped;	/* request queue is quiesced */
  	bool offline_already;		/* Device offline message logged */
