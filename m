Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EB7C38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 12:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F102206B8
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 12:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lqNDBm3i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgEGMjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 08:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 08:39:10 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A52C05BD43
        for <linux-scsi@vger.kernel.org>; Thu,  7 May 2020 05:39:10 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h26so4475603qtu.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2020 05:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h23ycIj0Es66LOs2qTkk9E+KQi7x2oserJGLWTJrvVs=;
        b=lqNDBm3iJvpBS7JbdzL2kyxWt16dNLnkmoXkQ9q1RSN8riPLMYPTfnVNAT0eD5UPxD
         JCCcaQjA+sq7cnHg05LL+f+lJbSMRaebFXdAfGCy7AbQsk1nh5PfgLS/roGlL4RPQ7X3
         2DY/LAqPbXOwc5L4bSrr82ySipb2EmqMq584wYJW2o4knXZTSxseA2MzOic/kwYCuBPu
         msG261z5w5Om4CoQFyurnNxAvAkmSMSNbTOJk+kCt9jWuzoD9Dhqc8IAkl/Z2L0GJ019
         SybDo/nS6ASTH+krIlYdTwrgoYoHvy6yEL0zDdhDJ9Nj/RgzTgotwWHwVLJ3tcEmLoyR
         dLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h23ycIj0Es66LOs2qTkk9E+KQi7x2oserJGLWTJrvVs=;
        b=gVqZS1ItVoJe+xzf1o/i1gGyC8d5tvkdJNYNMCFQRGx67E4kUb74EB9qLTOvvI2pyt
         q1jU8WA8rERVvEC4B+iLr5frE+uoiB/nscwAVxLkK2TP5PHXoaZhHsM0RgyRRH9bf1qn
         UX01RN5z1CbezuwUWqy9aYxWhP+3ZpM6P8EwVv46J4VkdijJEyvmwxMrAdj3OUSBANHl
         wYseDyKcf10Y/IXOWj4A9Irlm9z8N1mBgPNqulJE+WJEjVuw1t9QT5pnJt9gfTelemY7
         VkqrTZS/UIJQB3T3FptuHDIITcO1giKBVYHfGxLU87VsdptrTqf8FdfqYDksAZ2zk5cQ
         KQaA==
X-Gm-Message-State: AGi0PuaKU9Jw9e7MKDRA4xH0DFMyELKObBskOpCmejgvGZEzyXKSv6Jq
        J2p7E0VZI370FubOD/eaS+LI+Q==
X-Google-Smtp-Source: APiQypLqMCs4Ou9WuCc1DEOntHd98ywpKjuDtL9vbFoEhoaJNfH1CgWFIpa6YJj2+txulaqSqErA7g==
X-Received: by 2002:ac8:5204:: with SMTP id r4mr13832288qtn.39.1588855149700;
        Thu, 07 May 2020 05:39:09 -0700 (PDT)
Received: from [192.168.1.92] (pool-71-255-246-27.washdc.fios.verizon.net. [71.255.246.27])
        by smtp.gmail.com with ESMTPSA id e16sm4315010qtc.92.2020.05.07.05.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 05:39:09 -0700 (PDT)
Subject: Re: [RFC PATCH v4 1/4] firmware: qcom_scm: Add support for
 programming inline crypto keys
To:     Eric Biggers <ebiggers@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-2-ebiggers@kernel.org>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <1dc13593-9ee9-aa61-978e-1e6a1d9cec0f@linaro.org>
Date:   Thu, 7 May 2020 08:39:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501045111.665881-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/1/20 12:51 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add support for the Inline Crypto Engine (ICE) key programming interface
> that's needed for the ufs-qcom driver to use inline encryption on
> Snapdragon SoCs.  This interface consists of two SCM calls: one to
> program a key into a keyslot, and one to invalidate a keyslot.
> 
> Although the UFS specification defines a standard way to do this, on
> these SoCs the Linux kernel isn't permitted to access the needed crypto
> configuration registers directly; these SCM calls must be used instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   drivers/firmware/qcom_scm.c | 101 ++++++++++++++++++++++++++++++++++++
>   drivers/firmware/qcom_scm.h |   4 ++
>   include/linux/qcom_scm.h    |  19 +++++++
>   3 files changed, 124 insertions(+)
> 
> diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> index 059bb0fbae9e5b..646f9613393612 100644
> --- a/drivers/firmware/qcom_scm.c
> +++ b/drivers/firmware/qcom_scm.c
> @@ -926,6 +926,107 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
>   }
>   EXPORT_SYMBOL(qcom_scm_ocmem_unlock);
>   
> +/**
> + * qcom_scm_ice_available() - Is the ICE key programming interface available?
> + *
> + * Return: true iff the SCM calls wrapped by qcom_scm_ice_invalidate_key() and/s/iff/if



-- 
Warm Regards
Thara
