Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08061C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 03:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D9364E15
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 03:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBKDgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 22:36:14 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:55457 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhBKDgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 22:36:08 -0500
Received: by mail-pj1-f50.google.com with SMTP id cv23so2552332pjb.5;
        Wed, 10 Feb 2021 19:35:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JK5ZFfSHXoOOi8G6GwtZewu3hGx5BYnS6z+5kmBTBJw=;
        b=kFt66vdfKWk11641GdL7T3HXOSUTXKnp4mv/v2VPVUGFqFc+e+elfLH6zgDJ760GAw
         B4qjL7QfYGy0z3WbKQs0nZE8zbw6LMEga9BZ3PGa5Rs3KnUsDwCi0RsS8ieMm2xZgt8i
         5KQKhNIQhVHoPX90Ckjnq6ytJTfSF8hh5d7vsM7s7InSJzLfZboQvxrGZ694AYW3MvIz
         HTb+jpTf35nUN5m/LxzosHrvflfIRnGcescWVLJ+HiZpc4nI0aCpO2FNaR7p9+sd2YI6
         PZAM0SLESj33kAXlaykfo0h+0ZsWW/2AB2IRRGmO0gLYyxFMsZKRx6X3Qnr4OAHFnS+P
         8GKg==
X-Gm-Message-State: AOAM530dRlTW+uNwyTpLhXyKIYV6rXo9V7oH0BFHwVcUtOPITWlfve4J
        nRRWhHQP4oYtiOc38X0HGhw=
X-Google-Smtp-Source: ABdhPJwtA8mGO2eVkRliipdUd3pvjJh654zz8FT6gSw3lVVM4+oLAR5GEeTAe/AzomjKBTjt/P8Twg==
X-Received: by 2002:a17:90a:9a4:: with SMTP id 33mr2030837pjo.147.1613014528220;
        Wed, 10 Feb 2021 19:35:28 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:3ee1:3bad:6322:19be? ([2601:647:4000:d7:3ee1:3bad:6322:19be])
        by smtp.gmail.com with ESMTPSA id i7sm3363078pjx.13.2021.02.10.19.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 19:35:27 -0800 (PST)
Subject: Re: [PATCH] scsi: ufs: sysfs: add is_ascii_output entry
To:     Arthur Simchaev <Arthur.Simchaev@sandisk.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>
References: <1612954425-6705-1-git-send-email-Arthur.Simchaev@sandisk.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4bba4245-df01-f23d-65ba-4ff133cae0bc@acm.org>
Date:   Wed, 10 Feb 2021 19:35:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1612954425-6705-1-git-send-email-Arthur.Simchaev@sandisk.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/21 2:53 AM, Arthur Simchaev wrote:
> +static bool is_ascii_output = true;

[ ... ]

>  static const char *ufschd_uic_link_state_to_string(
>  			enum uic_link_state state)
>  {
> @@ -693,7 +695,15 @@ static ssize_t _name##_show(struct device *dev,				\
>  				      SD_ASCII_STD);			\
>  	if (ret < 0)							\
>  		goto out;						\
> -	ret = sysfs_emit(buf, "%s\n", desc_buf);			\
> +	if (is_ascii_output) {						\
> +		ret = sysfs_emit(buf, "%s\n", desc_buf);		\
> +	} else {							\
> +		int i;							\
> +									\
> +		for (i = 0; i < desc_buf[0]; i++)			\
> +			hex_byte_pack(buf + i * 2, desc_buf[i]);	\
> +		ret = sysfs_emit(buf, "%s\n", buf);			\
> +	}								\
>  out:									\
>  	pm_runtime_put_sync(hba->dev);					\
>  	kfree(desc_buf);						\

Please do not introduce a mode variable but instead introduce a new
attribute such that there is one attribute for the unicode output and
one attribute for the ASCII output. Mode variables are troublesome when
e.g. two scripts try to set the mode attribute concurrently.

Thanks,

Bart.
