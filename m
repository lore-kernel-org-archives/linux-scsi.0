Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B791C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 410E261028
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhEXBea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 21:34:30 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:43690 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhEXBe3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 21:34:29 -0400
Received: by mail-pg1-f175.google.com with SMTP id e22so3174465pgv.10;
        Sun, 23 May 2021 18:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GLzR8V6SvDeIsyAstNkq2gTzI23jfFfIEag6VtEV2NE=;
        b=tPjWM3wJM12ctM2TRAO2AJIzGopgWSHkfhblZR/aXs/uJ6jaKsUaTlGoa7au47mi5Q
         qA8ys504mFOf1oafWuaXE504ms6YOi6uPghZFSaxtRmCdAbLZmmpX1c7KggiDG+3HPpn
         ya2VLbLLUGXFa9XsrCw/UUoJYJxjNFjgf6XhErmuhVM0dAadE2rRRAPXAtHHYUJ9iRSu
         rnn+1snKRXsLj0iiV1Dzcvh2WwaRgZdr+cf7Xh1YqVVEstK5Mv44fuwUa2f2XiTRQIzL
         96ofhEi0I9Umnignat88YdPku1GZ2YEeo6pF+svggJ5PK8oQVvBqoc0BBuVG0kdb6OSh
         tX/Q==
X-Gm-Message-State: AOAM5310DsIoIlmQDeyb7PNvf05nUowH0TvOl91kMLKDMVQiEOgsEnZ1
        wylXoS0DZIw5dYC9NXW3P6Cs6HHdR5U=
X-Google-Smtp-Source: ABdhPJwY1rfRhWwwW7EJJpJ4CD3uMjSP1bGZxUrs+ZultUgkkfZg20r8kSEzyejfXEVvGn44tq5V8g==
X-Received: by 2002:a63:3704:: with SMTP id e4mr10721891pga.125.1621819980580;
        Sun, 23 May 2021 18:33:00 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y190sm10168536pgd.24.2021.05.23.18.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 18:33:00 -0700 (PDT)
Subject: Re: [PATCH v1 3/3] scsi: ufs: Use UPIU query trace in devman_upiu_cmd
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210523211409.210304-1-huobean@gmail.com>
 <20210523211409.210304-4-huobean@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <74d9b6e5-489d-9267-1c6f-c59f9164136d@acm.org>
Date:   Sun, 23 May 2021 18:32:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210523211409.210304-4-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 2:14 PM, Bean Huo wrote:
> +	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
> +				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);

Why is there a cast in the above code from a response pointer to a
request pointer type?

Thanks,

Bart.
