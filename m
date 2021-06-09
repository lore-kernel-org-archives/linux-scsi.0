Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696BDC48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C1B4613D4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhFIUAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 16:00:24 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:39533 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFIUAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 16:00:23 -0400
Received: by mail-pj1-f49.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so2197501pjp.4
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 12:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1sTbRxOL9kZIW7JkmXwGsF7OEyoUmdildXS5iLH5CyU=;
        b=H/DOOqjMvgK2nH9JvpH2b3WuoFm8lPhgj9e4cC4qaiExblB8Wye+aD7GMWQPGcZmBO
         dQZI2nDDk+NvN7XlVRYzDSEibQmJIJZ33d4HG+eeaLklDKEY/IaOfol0n3GSfh1+Z1bN
         cUv+qp5MWCS3DICtmg5d9rcAK8dKsjgxDrjLNlLYj6TvTsf5oW7b7V5dwqgNvq8SzNGo
         fjWy98QuS6waaGhP6ZtVhx3mkewmz7esZ/GKyLIaoBMkvaC8Ig+iQHvTkvCyKoZFeHef
         qNVoV3sYASg8VkABFbUETI3ffxjdpiHy8GuQSjn8IbxQJtCluE0V3lntw8S+ZYpT5jXE
         Nmiw==
X-Gm-Message-State: AOAM532zyeKnAaSoCNoLGYmXnY5CHe4HHey5S7JPSdPmvF4STD6eOz/1
        hZEF5M1GaJjhUYviOkTQvMlEX3NOGBk=
X-Google-Smtp-Source: ABdhPJy8gUsu1PBmX9DA6DCrAbc4T/GjC8lIlrxW6h0owVPS2i/6j8EL01K3X5WhxQ1myGLTUPu74A==
X-Received: by 2002:a17:902:548:b029:10f:30af:7d5f with SMTP id 66-20020a1709020548b029010f30af7d5fmr1192251plf.22.1623268708148;
        Wed, 09 Jun 2021 12:58:28 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id gk21sm5493416pjb.20.2021.06.09.12.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 12:58:27 -0700 (PDT)
Subject: Re: [PATCH 13/15] scsi: core: Add helper to return number of logical
 blocks in a request
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-14-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a3687cac-dcc9-5579-5767-d211be505625@acm.org>
Date:   Wed, 9 Jun 2021 12:58:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210609033929.3815-14-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/21 8:39 PM, Martin K. Petersen wrote:
> +static inline unsigned int scsi_get_block_count(struct scsi_cmnd *scmd)
> +{
> +	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
> +
> +	return blk_rq_bytes(scmd->request) >> shift;
> +}

I think we either need a comment above this function that explains that
the return value is a number of logical blocks or to change the function
name to make the meaning of the return value clear.

Thanks,

Bart.
