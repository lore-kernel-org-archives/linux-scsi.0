Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4122BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 04:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C35E61073
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 04:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhJ1ETU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 00:19:20 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:53060 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhJ1ETT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 00:19:19 -0400
Received: by mail-pj1-f43.google.com with SMTP id oa4so3716426pjb.2;
        Wed, 27 Oct 2021 21:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PimhfkEa200WJrsL4Ry5s8UMkaRd73hZA9e3wSPrObc=;
        b=p+h2p/jnQywOdR9J1rCuFggA+Sb01V9ou1ChnVjsxZXkrdQyNIki+zNoyn2KDGy8x+
         93ql7ePL6BhfLKtpJLYm3J8QdTB9O3dt/XC949/+ohiv4hvs+FvQd39/Km0+8ho7I5lm
         1+Au5W7lp2sQImv3vX58f7pjc8qz1zEM2l2iWTs/Uf+EvvjNqjAckBM3/FgCg84u0f0s
         rsodL4NCAqWlI/H78bd5Ian//E/ouGiIADz6IhKxj6OcYEXZeI2RNUM/UPDEjHuV6dye
         woxopCM5hlMzpIWuwWYbAn6PMYvCvpfv+sTtfz2ukwcyFjjxItNINjIhYS5C1Z2EfOo5
         POGQ==
X-Gm-Message-State: AOAM530mA3tWwyHrrow1L/K0fQ3snuprQqPfdY3J0qaU564RkfQOkjCM
        PXPeV0WjKOlusrdF3CjmKajchZFoDGE=
X-Google-Smtp-Source: ABdhPJxWbF0hCk0F5LY+oMdaIyptXMMkDRGKWw7yeEQMupt6NkuLOARPnwWrxlBWF6frtmlo+p7X/g==
X-Received: by 2002:a17:902:ba8e:b0:13e:c690:5acb with SMTP id k14-20020a170902ba8e00b0013ec6905acbmr1719282pls.63.1635394612869;
        Wed, 27 Oct 2021 21:16:52 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:2d89:191d:a064:aa4a? ([2601:647:4000:d7:2d89:191d:a064:aa4a])
        by smtp.gmail.com with ESMTPSA id g25sm1458475pfh.216.2021.10.27.21.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 21:16:52 -0700 (PDT)
Message-ID: <550eb8d6-2f9f-a7f1-e6b0-75380784d725@acm.org>
Date:   Wed, 27 Oct 2021 21:16:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Content-Language: en-US
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/21 15:36, Daejun Park wrote:
> This patch addresses the issue of using the wrong API to create a
> pre_request for HPB READ.
> HPB READ candidate that require a pre-request will try to allocate a
> pre-request only during request_timeout_ms (default: 0). Otherwise, it is
> passed as normal READ, so deadlock problem can be resolved.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
