Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE88C4CEC8
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC5620856
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732245AbfILNoT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 09:44:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37631 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732239AbfILNoT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 09:44:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id c17so5768084pgg.4
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 06:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ceNPWcWTipfAfeKAaiTT4udHgEwkImit4TBFNaxXyew=;
        b=lNQe42uWsK1+IEwGyghM/3rXiRxbcJkDuVTG9g+2E9RJg0tgPmJkgREYbFiyREYKPJ
         XBekPNhewiv7UcZrgB8g71xiCoZIBRILoCPupSSVmw2zypG63+S39BHBAa53Fp+ol7Rz
         Ioh62YRTLbU7637AYh1Z1DqRIU8WLDsvuUvLBnJj2HoRrktfgUi6wOJRbiYMheh4QLy7
         vpVUx75G0u1Jc1WZD7IoXxfLSrHPz6Vvv53uKKcpxA/N4/nThPPdu2FDvBa2aYtpvyyv
         h3vyWFxTlZUz9D9uyxLegwzUD30N/myGK5LYsVvu3RVScwfjJFY4tveeI3asQERyaM2h
         +Z2w==
X-Gm-Message-State: APjAAAW1uAhvNx69BAEK5hRe6cseoUSk6KD6k3aQqYi2+fFvld+q7+Nz
        LkeNXrBcSo9XfhlTvKD3HB6dh7OSJ/rjfQ==
X-Google-Smtp-Source: APXvYqzB9SsBEHXbRoDazbOUKTlPNiidOJt/lTTfbHQKmD4OVAcRrfttF0ZrGy/78yadGVxkdsVRGA==
X-Received: by 2002:a65:430a:: with SMTP id j10mr39157233pgq.374.1568295858937;
        Thu, 12 Sep 2019 06:44:18 -0700 (PDT)
Received: from [172.19.249.100] ([38.98.37.138])
        by smtp.gmail.com with ESMTPSA id s18sm32320324pfh.0.2019.09.12.06.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2019 06:44:18 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] scsi: core: allow auto suspend override by
 low-level driver
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, pedrom.sousa@synopsys.com,
        sthumma@codeaurora.org, jejb@linux.ibm.com
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        evgreen@chromium.org, beanhuo@micron.com, marc.w.gonzalez@free.fr,
        subhashj@codeaurora.org, vivek.gautam@codeaurora.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <1568270135-32442-1-git-send-email-stanley.chu@mediatek.com>
 <1568270135-32442-2-git-send-email-stanley.chu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <485731ed-d455-dbb2-0cd5-3110ff14f6b7@acm.org>
Date:   Thu, 12 Sep 2019 14:43:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568270135-32442-2-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/19 7:35 AM, Stanley Chu wrote:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 64c96c7828ee..461aafadd208 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1300,7 +1300,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	device_enable_async_suspend(&sdev->sdev_gendev);
>  	scsi_autopm_get_target(starget);
>  	pm_runtime_set_active(&sdev->sdev_gendev);
> -	pm_runtime_forbid(&sdev->sdev_gendev);
> +	if (sdev->rpm_autosuspend_delay < 0)
> +		pm_runtime_forbid(&sdev->sdev_gendev);
>  	pm_runtime_enable(&sdev->sdev_gendev);
>  	scsi_autopm_put_target(starget);

So we have a single new struct member, rpm_autosuspend_delay, that
controls two different behaviors: (a) whether or not runtime suspend is
enabled at device creation time and (b) the power management autosuspend
delay. I don't like this. Should two separate variables be introduced
instead of using a single variable to control both behaviors?

> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 202f4d6a4342..133b282fae5a 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -199,7 +199,7 @@ struct scsi_device {
>  	unsigned broken_fua:1;		/* Don't set FUA bit */
>  	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
>  	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
> -
> +	int rpm_autosuspend_delay;
>  	atomic_t disk_events_disable_depth; /* disable depth for disk events */
>  
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
> 

Since the default value for the autosuspend delay is the same for all
SCSI devices attached to a SCSI host is the same, please add a variable
with the same name in the SCSI host template and use that value as the
default value for SCSI devices. If the rpm_autosuspend_delay variable
only occurs in struct scsi_device then LLD authors are forced to
introduce a slave_configure function. Introducing such a function can be
avoided if the default autosuspend delay can be specified in the host
template.

Bart.

