Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5485AC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 12:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3142E208C3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 12:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfLKMGR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 07:06:17 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35112 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfLKMGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 07:06:17 -0500
Received: by mail-qk1-f195.google.com with SMTP id z76so2719105qka.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2019 04:06:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8QCObTd6Fx49Qt/ObrGypJRrxHQ04jjBjaB09dYnYT8=;
        b=A2fv6Ggc2DpAM5QR7pqgf9ohRqlKZ11bLTq8QJLwSFNXxc+0+sLjSbmE8ixpjSxdRL
         Y6P09XmqQssxRgbhnTo8+T5LjEydJZEH+pr6eTY0QmKVZKW+P++gQaHNBpNaSZIKiNZP
         KpPXaawHTWd3og0GdY/hlHKYisVK+OVRVFG4jmTMXmJWJrvVJ6prf7xZ9W83DOWS2SVK
         NZUq0IumoFNbdCkiuDl5QKKV8wNL26sp6jpyykRe+SwCJ2LuEZZIDglVqiWTRb/f1Rzg
         m8Gtwfx+uIvCK+N/mwyGxCuMsOPBbsMbDEFr64Dy8g2UWDziUZq+ixtply9Fv9w0BwW/
         NLww==
X-Gm-Message-State: APjAAAV2fzshc5TVjmJ59+Qj3AVRCfY6J7zl9ebDGf13K6cnCJO4nzU9
        uqo1lEIxGc9GqwRcwa5NYWUG4d5P
X-Google-Smtp-Source: APXvYqzsNoSTyVC41oO9dni3xMMElwe0tp1A/FXrREJt1kx1v00niqrMPG1ijob1CuHbRQlmGxFstQ==
X-Received: by 2002:a05:620a:1191:: with SMTP id b17mr2410161qkk.404.1576065975540;
        Wed, 11 Dec 2019 04:06:15 -0800 (PST)
Received: from [172.20.7.93] ([162.219.216.181])
        by smtp.gmail.com with ESMTPSA id c20sm841472qtc.13.2019.12.11.04.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 04:06:14 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: qla2xxx: don't shut down firmware before
 closing sessions
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20191129202627.19624-1-martin.wilck@suse.com>
 <20191129202627.19624-2-martin.wilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5730b94d-4f9f-310b-0f6f-40ff8739e6eb@acm.org>
Date:   Wed, 11 Dec 2019 07:06:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129202627.19624-2-martin.wilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/29/19 3:26 PM, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since 45235022da99, the firmware is shut down early in the controller
> shutdown process. This causes commands sent to the firmware (such as LOGO)
> to hang forever. Eventually one or more timeouts will be triggered.
> Move the stopping of the firmware until after sessions have terminated.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 21 ++++++++++-----------
>   1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 43d0aa0..0cc127d 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3710,6 +3710,16 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   	}
>   	qla2x00_wait_for_hba_ready(base_vha);
>   
> +	qla2x00_wait_for_sess_deletion(base_vha);
> +
> +	/*
> +	 * if UNLOAD flag is already set, then continue unload,
> +	 * where it was set first.
> +	 */
> +	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> +		return;
> +
> +	set_bit(UNLOADING, &base_vha->dpc_flags);
>   	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
>   	    IS_QLA28XX(ha)) {
>   		if (ha->flags.fw_started)
> @@ -3726,17 +3736,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   		qla2x00_try_to_stop_firmware(base_vha);
>   	}
>   
> -	qla2x00_wait_for_sess_deletion(base_vha);
> -
> -	/*
> -	 * if UNLOAD flag is already set, then continue unload,
> -	 * where it was set first.
> -	 */
> -	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> -		return;
> -
> -	set_bit(UNLOADING, &base_vha->dpc_flags);
> -
>   	qla_nvme_delete(base_vha);
>   
>   	dma_free_coherent(&ha->pdev->dev,

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


