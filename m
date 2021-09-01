Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBD1C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 16:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F2D61058
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 16:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbhIAQgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 12:36:21 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:37833 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhIAQgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 12:36:19 -0400
Received: by mail-pf1-f176.google.com with SMTP id x19so255335pfu.4;
        Wed, 01 Sep 2021 09:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L4cp4spbjMOWms2EMsEDHOEtmv1pugtKNYnVTnJEoIo=;
        b=UsArGU2RKA3mJQTxEqCAPhjGkw8eL2xpURNXLA+lAXf5II9ejOU0xYFqzNy48BO3hI
         FFLAZNMakrcOXqONpI9bxLdIYbFmzL8nK+KMDFtujPpQqlKID6xKuXUPQS9uf+aWx8vY
         pRbFS3WA3tSmW4ID8Qaxa3vhU2Gwknl7ihQvXmxTgQQAdl9t3fo7IrZivqMI0kY9bK/5
         pdHhBlj59/CBIyYxqYNC0NFVac95m+3igcbX2brauYAEIBNuUjIdXdpI5AC+ughw0cnm
         OSwfi0ylECoiSePOfuXeHAyzxcY5XUj6v3anle9TG/aYKcphRNN9DB+MrmJL9Lz9YhqN
         4rxA==
X-Gm-Message-State: AOAM530KCZLYHLZ1hZZjc7PypPHdVOXHWLnXxZ4RNJsxSmXOY7I7xJzZ
        4ZQv1JPI4Qxqg9sBhMzpIvw=
X-Google-Smtp-Source: ABdhPJyZiUXTip33BIXPUZOE0OpZTw0c93Sy93oD2TXCrTiWfwJaqQXZLLaVI2OjyR34cGKa9Zhslg==
X-Received: by 2002:a62:1c96:0:b0:3f5:e01a:e47 with SMTP id c144-20020a621c96000000b003f5e01a0e47mr269695pfc.76.1630514122348;
        Wed, 01 Sep 2021 09:35:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8a3b:44ab:b62:3ce2])
        by smtp.gmail.com with ESMTPSA id y9sm20555pfc.193.2021.09.01.09.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:35:21 -0700 (PDT)
Subject: Re: [PATCH 1/3] scsi: ufs: Probe for temperature notification support
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-2-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <035fad25-1b0d-c8ba-896f-eae2bd2144e3@acm.org>
Date:   Wed, 1 Sep 2021 09:35:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210901123707.5014-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/21 5:37 AM, Avri Altman wrote:
> +static inline bool ufshcd_is_high_temp_notif_allowed(struct ufs_hba *hba)
> +{
> +	return hba->dev_info.high_temp_notif;
> +}
> +
> +static inline bool ufshcd_is_low_temp_notif_allowed(struct ufs_hba *hba)
> +{
> +	return hba->dev_info.low_temp_notif;
> +}

Please do not introduce single line inline functions.

> +static inline bool ufshcd_is_temp_notif_allowed(struct ufs_hba *hba)
> +{
> +	return ufshcd_is_high_temp_notif_allowed(hba) ||
> +	       ufshcd_is_high_temp_notif_allowed(hba);
> +}

Since this function is not in any hot path (command processing), 
shouldn't it be moved into ufshcd.c?

Thanks,

Bart.
