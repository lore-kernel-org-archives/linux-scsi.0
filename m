Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BC8C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A191D6109F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhHSSPc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:15:32 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:52951 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhHSSPc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 14:15:32 -0400
Received: by mail-pj1-f54.google.com with SMTP id nt11so5545050pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 11:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zjr5T20ya5QeQG/IgcK1RyIDaJis67nG0UElZU4fuzw=;
        b=qRci/qEvgQG9NUGztP45xDA8Etn1nQJUFB+w7msIHBZ22vMItoAn5uXnNrhwkbKGj+
         B4BMzY56bPwBtt9Z6mxYxW5BdtWa/Gq31NEcSV170pW/BlTaSm3PXxQ/2KdD4ti0odp1
         B4L7RmPM44UcoZWUtNLQ+AEku/cbp5/em4Dxk2c3ezLyMQ2dJUoxDlXp+qUOQVpsu5sM
         oERBEsi4bM0GjcccBJU3sHR8xWqhc9/fcDAY8q0sLh1V4e/N99hbiSmkmEjptI0+WiNC
         XCudz6A/w61KphZP5krHj4ltojAv0434UoJGjn10s93nJJt0XAUwoCUOqh4ABFmgwY0r
         acQQ==
X-Gm-Message-State: AOAM533/rx6hqx6vWHIZLqQvXrRbhODD6Vc77w9Ps6Plov8OKqFY6f1x
        xT6K9Vggidt4VIkpFunUJ5i+Hkc9QG0=
X-Google-Smtp-Source: ABdhPJyjqmAFgr8BAaIF/BAFX6p9fSiiJ9XCy5b197GlNKOecUtn8rUJj/TfpoPEtVRJMWpc1Tdbaw==
X-Received: by 2002:a17:90b:a12:: with SMTP id gg18mr49219pjb.78.1629396894728;
        Thu, 19 Aug 2021 11:14:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8b47:c5d7:9562:9d96])
        by smtp.gmail.com with ESMTPSA id n8sm3797056pjo.54.2021.08.19.11.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 11:14:54 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung
 KLUFG8RHDA-B2D1
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20210819093534.17507-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e495acd6-ab2c-dc07-5515-08316ac8a22d@acm.org>
Date:   Thu, 19 Aug 2021 11:14:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210819093534.17507-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 2:35 AM, Adrian Hunter wrote:
>   	 * From SPC-6: the REQUEST SENSE command with any allocation length
> -	 * clears the sense data.
> +	 * clears the sense data, but not all UFS devices behave that way.
>   	 */

How about removing the comment entirely? Comprehending the above comment 
is not possible without reviewing the git history so I think it's better 
to remove it.

> -	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, 0, 0};
> +	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
>   	struct scsi_request *rq;
>   	struct request *req;
> +	char *buffer;
> +	int ret;
> +
> +	buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
> +	if (!buffer)
> +		return -ENOMEM;
>   
> -	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, /*flags=*/0);
> +	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
> +			      /*flags=*/BLK_MQ_REQ_PM);

Why has the flags argument been changed from 0 into BLK_MQ_REQ_PM? MODE 
SENSE is not a power management command.

Thanks,

Bart.
