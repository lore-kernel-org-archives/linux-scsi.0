Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076AFC4741F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 08:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1192221E5
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 08:40:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAjmp//N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgIZIkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 04:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgIZIkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Sep 2020 04:40:07 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC97C0613CE;
        Sat, 26 Sep 2020 01:40:07 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m5so5429826lfp.7;
        Sat, 26 Sep 2020 01:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pPUPKOAJ7Ev2nJbdIQQ6RKeN+shYKl1n/l4jnQBOK44=;
        b=XAjmp//NmcL1D27RAZkZiGabBTVQHMVxsgqq8SKmjOuZsrT53Nhxv9s2wTTmEdupzM
         n0e8xzR25e+V4cXKmKnyBb7FAtW93zvkEwrQ0qprir9XVTzkr3cb9fr4ZxiYLFLwnP+S
         buiYmdVozTTlVcFSGsDJ3dVx/ZS46k7Ko/A4gsYIVJHWXMYGNgLpdsUb4/Ykcas3c5dc
         koA7SeyPSfcJpAKfmclD674ExY1rCU1qbcs5qyVmYluCmKAVv8eaIVDmJkWJBILSsXPG
         Fldqydq+AI81soT6AxI9XDe02irGTk10GKcQV7X30dvBNNZlaTPraxEWI6LNrJjIHVYs
         tJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pPUPKOAJ7Ev2nJbdIQQ6RKeN+shYKl1n/l4jnQBOK44=;
        b=TnxrwN5QPL3RHApg/tK8x1Vdpcad+LSx26xwVKLLEUwor6VzCvKovXgult3bxvcHCn
         EoC8E51xfXALiOqOamqIBPUQt7d0rgrj6gYHJvlKqbeComp89uvHYMBX+InCRArIcdXX
         +dGHBNPl91aGG7sjzXh85hp6vVGjmn9Xwt4jyoUpIveacHVEMYxOTiMdldaGxuaHGHUR
         R/5/d8OOr8zxlcbn7B/Qm/+jTZEJZFrYSAUHGJvb7+XNpkzBqP1ZhBCEvsh0HZLS1Igq
         ltdPLYrTfzCF+kAMOuQAo4JbmfNiL0jz/ll8ei/XCnJn3i0CvxlEJia6Fh5tf9X94isu
         f8Dg==
X-Gm-Message-State: AOAM532Gu8/0MLpxL4D7X3RsVENmcJs/YCPyBHjMeyljd+ES+65JJqdv
        T1MN4aod2uDF1aVtvanZMIvUb0m8kEM=
X-Google-Smtp-Source: ABdhPJw39c4l34BMEWXp5xkK60eUXP/tQEvQQ0VYmLMWQ1eTvtTNq95/HUiqia+X5RLHNx7m/Vtqzg==
X-Received: by 2002:ac2:4d10:: with SMTP id r16mr813784lfi.58.1601109605622;
        Sat, 26 Sep 2020 01:40:05 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4850:6d74:c94:bdc6:ff06:f208? ([2a00:1fa0:4850:6d74:c94:bdc6:ff06:f208])
        by smtp.gmail.com with ESMTPSA id n3sm1174267lfq.274.2020.09.26.01.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 01:40:05 -0700 (PDT)
Subject: Re: [v5 07/12] libata: Make ata_scsi_durable_name static
To:     Tony Asleson <tasleson@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-8-tasleson@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <ec0479bf-e5ac-58f1-248a-2d4c29ae3efa@gmail.com>
Date:   Sat, 26 Sep 2020 11:40:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925161929.1136806-8-tasleson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 25.09.2020 19:19, Tony Asleson wrote:

> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
> ---
>   drivers/ata/libata-scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 194dac7dbdca..13a58ed7184c 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1086,7 +1086,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>   	return 0;
>   }
>   
> -int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)
> +static int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)

    Why not do it in patch #6 -- when introducing the function?

[...]

MBR, Sergei
