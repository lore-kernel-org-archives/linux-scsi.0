Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A2ECD4840
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 16:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjIVQGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjIVQGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 12:06:14 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8D6100
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 09:06:08 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1c47309a8ccso27049125ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 09:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695398768; x=1696003568;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sc770OlaE49GZgWY9dRnFqPa0lUiVYKCPXxKFeWKJIU=;
        b=kbpaqo4YXvw3kzG9mGYxmIMR8jNdbiQCAYlbvw6We6bA1GxFubqyCilPYFufhgfCE/
         UHQdJtuGk4kARgET4kGNpQKcfcmXbopc/fVTlnufwX2DnQJMSbezIqHQKvGnwtHhuMoW
         4W/eUz28w+CsZ2Jpk+dPz6/Zf1LFdQwj5E6LVS4tAdu3ZSNTPwgaZYxM5N8Mc97bmOtY
         E/d291CKSZAtd7VMIC+bWH2enDXda21SgkZqrpweTn5RlYihrZn1fd+BoR1GckmM+Ta4
         bJJeqxAavGZ4FZKOtWbOcjsfk1im99t4a1lptJ9X+z4Eeytf9nbHjuy+8yOQnrzLnUKe
         kDkA==
X-Gm-Message-State: AOJu0YyXGljhmB5FALb6KA1FwMQHrUQNP0TiaBD+El0NXTbiPi0GIlxl
        95qEU8d1QJaZasgTLERoYyM=
X-Google-Smtp-Source: AGHT+IErCCNZlUzb+d9FfxnEF0XfSXKa1nmUOyrJsc00193Xh0fis9J535wTTRwmZlisTvJzTHWT+g==
X-Received: by 2002:a17:902:ced2:b0:1bc:2fe1:1821 with SMTP id d18-20020a170902ced200b001bc2fe11821mr4638920plg.17.1695398768094;
        Fri, 22 Sep 2023 09:06:08 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:70e9:c86f:4352:fcc? ([2620:15c:211:201:70e9:c86f:4352:fcc])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b001b7fd27144dsm3678150plj.40.2023.09.22.09.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 09:06:07 -0700 (PDT)
Message-ID: <10bf17cf-8a92-469b-bc5c-1f0dba0ed5ed@acm.org>
Date:   Fri, 22 Sep 2023 09:06:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4] ufs: core: wlun send SSU timeout recovery
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20230922090925.16339-1-peter.wang@mediatek.com>
Content-Language: en-US
In-Reply-To: <20230922090925.16339-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 02:09, peter.wang@mediatek.com wrote:
> When runtime pm send SSU times out, the SCSI core invokes
> eh_host_reset_handler, which hooks function ufshcd_eh_host_reset_handler
> schedule eh_work and stuck at wait flush_work(&hba->eh_work).
> However, ufshcd_err_handler hangs in wait rpm resume.
> Do link recovery only in this case.
> Below is IO hang stack dump in kernel-6.1

What does kernel-6.1 mean? Has commit 7029e2151a7c ("scsi: ufs: Fix a
deadlock between PM and the SCSI error handler") been backported to
that kernel?

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c2df07545f96..7608d75bb4fe 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7713,9 +7713,29 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
>   	int err = SUCCESS;
>   	unsigned long flags;
>   	struct ufs_hba *hba;
> +	struct device *dev;
>   
>   	hba = shost_priv(cmd->device->host);
>   
> +	/*
> +	 * If runtime pm send SSU and got timeout, scsi_error_handler
> +	 * stuck at this function to wait flush_work(&hba->eh_work).
> +	 * And ufshcd_err_handler(eh_work) stuck at wait runtime pm active.
> +	 * Do ufshcd_link_recovery instead shedule eh_work can prevent
> +	 * dead lock happen.
> +	 */
> +	dev = &hba->ufs_device_wlun->sdev_gendev;
> +	if ((dev->power.runtime_status == RPM_RESUMING) ||
> +		(dev->power.runtime_status == RPM_SUSPENDING)) {
> +		err = ufshcd_link_recovery(hba);
> +		if (err) {
> +			dev_err(hba->dev, "WL Device PM: status:%d, err:%d\n",
> +				dev->power.runtime_status,
> +				dev->power.runtime_error);
> +		}
> +		return err;
> +	}
> +
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	hba->force_reset = true;
>   	ufshcd_schedule_eh_work(hba);

I think this change is racy because the runtime power management status
may change after the above checks have been performed and before
ufshcd_err_handling_prepare() is called. If commit 7029e2151a7c is
included in your kernel, does applying the untested patch below help?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d45a7dd80ab8..656dabea678e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -123,8 +123,7 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long msecs)
  	}

  	blk_mq_requeue_request(rq, false);
-	if (!scsi_host_in_recovery(cmd->device->host))
-		blk_mq_delay_kick_requeue_list(rq->q, msecs);
+	blk_mq_delay_kick_requeue_list(rq->q, msecs);
  }

  /**
@@ -163,8 +162,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
  	 */
  	cmd->result = 0;

-	blk_mq_requeue_request(scsi_cmd_to_rq(cmd),
-			       !scsi_host_in_recovery(cmd->device->host));
+	blk_mq_requeue_request(scsi_cmd_to_rq(cmd), true);
  }

  /**
@@ -495,9 +493,6 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)

  static void scsi_run_queue_async(struct scsi_device *sdev)
  {
-	if (scsi_host_in_recovery(sdev->host))
-		return;
-
  	if (scsi_target(sdev)->single_lun ||
  	    !list_empty(&sdev->host->starved_list)) {
  		kblockd_schedule_work(&sdev->requeue_work);

Thanks,

Bart.
