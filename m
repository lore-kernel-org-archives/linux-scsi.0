Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E27C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05AFC64EA6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhBIRcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbhBIRbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 12:31:42 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AB3C06174A;
        Tue,  9 Feb 2021 09:31:02 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id q2so24865196edi.4;
        Tue, 09 Feb 2021 09:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uOQ0u5OwO/LQk2rbXYm8dg5ieQvoa4+hcyEIgwT8fxg=;
        b=YUXWe2I2AOq11PxX1nGFJ/32bsMcZ28D2xAS0xqzRRTsecR2TZvzDXj9fKk07K1hnU
         zEf8oM5rNqvO6U/Bo1msRj8hiFEvfOR3DWXQiChqD2a5lcZDJC7DWHrfd4C2HKzu+dkx
         7e4YQRMnuNGF2PqqFlFsB1WlwA4rZ1T/RnCXd2Uy4zL5BWKMNv+LQU7ANvkuhJJzZd1i
         kwJ97xzy4Kd/YmUnZvUxdUZb1Hgh4bc8D+6z5nH3ty8h9mcmMYcD2VNeBeUCEWt2R6dj
         ZHHZoMknTxfE2iWbYTZuH8hUdSOL+N6M7YA2uBBDtSZKrCGBejdt34Awl7VXpc9sYfLh
         OIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uOQ0u5OwO/LQk2rbXYm8dg5ieQvoa4+hcyEIgwT8fxg=;
        b=h/Uq2gjPhJGcChuQDdf3Yso7MFH2VtG72pLL862TEhmwIc3zN+qqS+WIRzpYy3PuKS
         UjU+fLqR2FzVrxIDZmn6pyQH7W7POHVonceuSrmL0f9V14VfLSw2E0BrRtXplWmZJSuT
         9Rnzuam03mU9AXeicGp8tVUPxrt/KupcDOGKSKbSTQ/pQfp3Z8yBOqEgxdRTrmE+NTTs
         AEYeNg1SvNFJwnliTx1t1XzCw5cFmJ50HOc/rhjHNE9GRtg5TEENXYMAPyg0Mjv5hlIF
         JSuxXeeWkqsyygak3RSl9jjKCFv6zZ+rm+RhOXKKvpIAbX1uEbKWlhp7Zu8YOf5diOEl
         APUA==
X-Gm-Message-State: AOAM5300EDXgfkMF+g0iVrHDKpNDB1sKvb6WIMV+D2EFgJ2YLH3fWd6K
        b7PqM7q+4PrNakrjzSQ/kMc=
X-Google-Smtp-Source: ABdhPJy73jPSwuaUbNtmnHUskem1vWQG6AkQnK7gGWuWxvYi2LXa26LePWKQ8WERYzuBMNF+nfX4ww==
X-Received: by 2002:aa7:c94a:: with SMTP id h10mr24903296edt.41.1612891860815;
        Tue, 09 Feb 2021 09:31:00 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id z16sm10751355ejx.73.2021.02.09.09.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 09:31:00 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: target: core: Add cmd length set before cmd
 complete
To:     a.miloserdov@yadro.com, target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        r.bolshakov@yadro.com
References: <20210209072202.41154-1-a.miloserdov@yadro.com>
 <20210209072202.41154-2-a.miloserdov@yadro.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <e1cc56b8-bdbb-b2fd-91ef-a7bd24fbb465@gmail.com>
Date:   Tue, 9 Feb 2021 18:30:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209072202.41154-2-a.miloserdov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 09.02.21 08:22, Aleksandr Miloserdov wrote:
> TCM doesn't properly handle underflow case for service actions. One way to
> prevent it is to always complete command with
> target_complete_cmd_with_length, however it requires access to data_sg,
> which is not always available.
> 
> This change introduces target_set_cmd_data_length function which allows to
> set command data length before completing it.
> 
> Signed-off-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>   drivers/target/target_core_transport.c | 15 +++++++++++----
>   include/target/target_core_backend.h   |  1 +
>   2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index fca4bd079d02..c98540355512 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -879,11 +879,9 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
>   }
>   EXPORT_SYMBOL(target_complete_cmd);
>   
> -void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
> +void target_set_cmd_data_length(struct se_cmd *cmd, int length)
>   {
> -	if ((scsi_status == SAM_STAT_GOOD ||
> -	     cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) &&
> -	    length < cmd->data_length) {
> +	if (length < cmd->data_length) {
>   		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
>   			cmd->residual_count += cmd->data_length - length;
>   		} else {
> @@ -893,6 +891,15 @@ void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int len
>   
>   		cmd->data_length = length;
>   	}
> +}
> +EXPORT_SYMBOL(target_set_cmd_data_length);
> +
> +void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
> +{
> +	if (scsi_status == SAM_STAT_GOOD ||
> +	    cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) {
> +		target_set_cmd_data_length(cmd, length);
> +	}
>   
>   	target_complete_cmd(cmd, scsi_status);
>   }
> diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
> index 6336780d83a7..ce2fba49c95d 100644
> --- a/include/target/target_core_backend.h
> +++ b/include/target/target_core_backend.h
> @@ -72,6 +72,7 @@ int	transport_backend_register(const struct target_backend_ops *);
>   void	target_backend_unregister(const struct target_backend_ops *);
>   
>   void	target_complete_cmd(struct se_cmd *, u8);
> +void	target_set_cmd_data_length(struct se_cmd *, int);
>   void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
>   
>   void	transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
> 

Looks ok to me.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
