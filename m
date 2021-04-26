Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCBBC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4EC6128B
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhDZDW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:22:29 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:43683 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZDW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:22:29 -0400
Received: by mail-pf1-f178.google.com with SMTP id e15so1230220pfv.10
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=87Ri39txb5WYYjyzvmdxyoLdcp9Yok3lodVb79SmJq8=;
        b=hnzkyOl3eGYNLlFhegFwbrq1KiHdqhH5EqGxzaBpsuuF2G0HnZVBJmQHqHPQTJrdqj
         ZKPrtjl8iarv0D016kGO2C+ZLU43er10MOwc33K9Wx8TrJvr/39Oet2Bky1rxIYgM5la
         TXQQaiX8f1ukR52KDPt/S5SF2OM9II7WDAhvGVKyiSEem96IQ9w53qJagIixLY0s+Cyg
         qlCRSqJB8TaDSF7ZNXgNG4HRkwKeyEP5jZ6l7dA9afpl0YJ3SBFY4seayAAQ5+5n5nc6
         IbNaLVMMeRHI05+MxUKNR2i77wRz9Mba1p+svkvLJR4caOx3HKI8GBcu7TuVu7rNzELn
         xSag==
X-Gm-Message-State: AOAM531d2TEpFYwbuoRvHHMwSgqA/SFGH2ApihHMT4defNBzpvyBS5Ho
        qx0QiKmk5CXB/lVx+/09NApGEp6g0o8c5w==
X-Google-Smtp-Source: ABdhPJySB1jbwpnpoFugMuboOi8/KKxuWVsyTmCxR3mms8kHaKvaKML+vKXIoP6Y3BQDP+Wxatl2cA==
X-Received: by 2002:a05:6a00:2389:b029:261:abe:184 with SMTP id f9-20020a056a002389b02902610abe0184mr16019528pfc.52.1619407306617;
        Sun, 25 Apr 2021 20:21:46 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n20sm9568723pgv.15.2021.04.25.20.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:21:46 -0700 (PDT)
Subject: Re: [PATCH 04/39] scsi: Fixup calling convention for
 scsi_mode_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-5-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <07a43c3e-af31-6585-60bd-ac2d2d215dd9@acm.org>
Date:   Sun, 25 Apr 2021 20:21:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-5-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> The description for scsi_mode_sense() claims to return the number
> of valid bytes on success, which is not what the code does.
> Additionally there is no gain in returning the scsi status, as
> everything the callers do is to check against scsi_result_is_good(),
> which is what scsi_mode_sense() does already.
> So change the calling convention to return a standard error code
> on failure, and 0 on success, and adapt the description and all
> callers.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
