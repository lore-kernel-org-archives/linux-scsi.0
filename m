Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51312C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 20:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3491620738
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 20:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHUUzU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 16:55:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44911 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUUzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2020 16:55:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id m34so1540604pgl.11
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2020 13:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yrp+gvs/kShj3ujxtPnet+0MiqC3Msqh3JpyH53uiu4=;
        b=gMpOWENJOZ+EMlip24/MRrafL8TOLPUpHUSLiZ9FAlA9OGLfMavt6R8OAiM04EdbJY
         fneJlB59KuRmm3bA1XBouBhcF8a+B2/sRiUMVQIDCQDTgqb+NL5BSoT+2mdKr9q0DoCJ
         s59lEG7kZzTZrYqI1Y+7Nbmn9L34RquDrKYs+e4PNBSut8n4u/gGYSEGZtn6G1/X0ufR
         6steJ3t9OSmbiCC+BAKJdPHKyOxJ8I8cnKbPVgl+S1ftdAXNtXA2mASSjeqnTKeiOqiW
         o0BSJmjTRbBWidzkHiFwzio4sznD+RyaQGprxFCuJLnIdMAGBpbuuYBqVVSTIpUC44pA
         Tg3A==
X-Gm-Message-State: AOAM533FQv26diFQpqGvIhN0Zp3B6QV7wTi+Tchidzoo1YLvyb0PkW0j
        MVmIXXDnI749feNZSaRDNygTmAn9aEs=
X-Google-Smtp-Source: ABdhPJzzUXgM3pUX84Nkg5jcHNOT6+mPPOlfAbdd7E5uYX7rNTn0ybEnI0gFQYjW4xG1YYzPaUs3Mg==
X-Received: by 2002:a63:cd54:: with SMTP id a20mr3473488pgj.228.1598043318019;
        Fri, 21 Aug 2020 13:55:18 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i14sm3635372pfu.50.2020.08.21.13.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 13:55:17 -0700 (PDT)
Subject: Re: [PATCH] fix qla2xxx regression on sparc64
To:     Rene Rebe <rene@exactcode.com>, linux-scsi@vger.kernel.org
References: <20200821.142814.268140009249624430.rene@exactcode.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <baa99ce7-7bea-95ac-34c5-d0d36a0a3f6d@acm.org>
Date:   Fri, 21 Aug 2020 13:55:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821.142814.268140009249624430.rene@exactcode.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/21/20 5:28 AM, Rene Rebe wrote:
> 
> Commit 9a50aaefc1b896e734bf7faf3d085f71a360ce97 in 2014 broke
> qla2xxx on sparc64, e.g. as in the Sun Blade 1000 / 2000.
> Unbreak by fixing endianess in nvram firmware defaults
> initialization.
> 
> Signed-off-by: René Rebe <rene@exactcode.de>
> 
> --- linux-5.8/drivers/scsi/qla2xxx/qla_init.c.vanilla	2020-08-21 09:55:18.600926737 +0200
> +++ linux-5.8/drivers/scsi/qla2xxx/qla_init.c	2020-08-21 09:57:35.992926885 +0200
> @@ -4603,18 +4603,18 @@
>   			nv->firmware_options[1] = BIT_7 | BIT_5;
>   			nv->add_firmware_options[0] = BIT_5;
>   			nv->add_firmware_options[1] = BIT_5 | BIT_4;
> -			nv->frame_payload_size = 2048;
> +			nv->frame_payload_size = cpu_to_le16(2048);
>   			nv->special_options[1] = BIT_7;
>   		} else if (IS_QLA2200(ha)) {
>   			nv->firmware_options[0] = BIT_2 | BIT_1;
>   			nv->firmware_options[1] = BIT_7 | BIT_5;
>   			nv->add_firmware_options[0] = BIT_5;
>   			nv->add_firmware_options[1] = BIT_5 | BIT_4;
> -			nv->frame_payload_size = 1024;
> +			nv->frame_payload_size = cpu_to_le16(1024);
>   		} else if (IS_QLA2100(ha)) {
>   			nv->firmware_options[0] = BIT_3 | BIT_1;
>   			nv->firmware_options[1] = BIT_5;
> -			nv->frame_payload_size = 1024;
> +			nv->frame_payload_size = cpu_to_le16(1024);
>   		}
>   
>   		nv->max_iocb_allocation = cpu_to_le16(256);

Hi Rene,

Please keep the qla2xxx driver endianness-clean and include the following in your patch:

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8c92af5e4390..2182b2da43ed 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1626,7 +1626,7 @@ typedef struct {
  	 */
  	uint8_t	 firmware_options[2];

-	uint16_t frame_payload_size;
+	__le16	frame_payload_size;
  	__le16	max_iocb_allocation;
  	__le16	execution_throttle;
  	uint8_t	 retry_count;

Thanks,

Bart.
