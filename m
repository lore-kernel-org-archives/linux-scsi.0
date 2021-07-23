Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6CDC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 04:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4A960E53
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 04:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhGWDXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 23:23:55 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:35509 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbhGWDXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 23:23:48 -0400
Received: by mail-pl1-f170.google.com with SMTP id e10so1834193pls.2;
        Thu, 22 Jul 2021 21:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UAWfR33VLIl1+ExtgDEUKbhH50naiTNGx3i52j7b1uA=;
        b=JmNq/uV8XW0coFhmS6yraCeKgD9u/5gmW/r55ZBnXDhEzPJhB/GSMhiuv5Y7aI14w0
         m2q7BMEI+P8VuNQxTqQdvIUuuxXVTwRNesajVuDazNgC0QfIW8lXNEAyqOGy3O2hQzkO
         IHp7IbYjANH6ve0M3c3fzNbCxZnmcL4OVy0nzHK/nelAOGzOnQ9hdorsheezGnOzt7od
         lNdQG09+R8C2IjTDWXiuYXpwt25VfxkBdK6pN0dmq50ZUKJhsXDvEHLDjZYLSqK+iYcE
         r35dTN3z8gqGM6DiVXJ7E53e0DOb2AAw+WIjY1rDUxy6WDeiw33b+oRVuAAh5Nk9/FLl
         TDYA==
X-Gm-Message-State: AOAM531fuxS+b2StCIiF4y2LvyhZSXj7vGpFeFEXhhYgKiGm5lFeU9UB
        Xty8wR6acDqVOGmSMs4v46esq2NgK14a8w==
X-Google-Smtp-Source: ABdhPJw67T3mW7SxxubJr7iYnDbVz92HpOpo62j7UDHzBrVizKSW6rWfNVqszNniGdsXeDC+Tishlw==
X-Received: by 2002:a05:6a00:ac8:b029:320:a6bb:880d with SMTP id c8-20020a056a000ac8b0290320a6bb880dmr2676447pfl.41.1627013061027;
        Thu, 22 Jul 2021 21:04:21 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:286e:6a9d:f340:dcd9? ([2601:647:4000:d7:286e:6a9d:f340:dcd9])
        by smtp.gmail.com with ESMTPSA id c83sm6898990pfb.164.2021.07.22.21.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 21:04:20 -0700 (PDT)
Subject: Re: [PATH v2] scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach
To:     Ye Bin <yebin10@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210113063103.2698953-1-yebin10@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a1113b04-e320-a12b-5a59-ec7479d5eec1@acm.org>
Date:   Thu, 22 Jul 2021 21:04:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210113063103.2698953-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/21 10:31 PM, Ye Bin wrote:
>  	sdev->handler_data = NULL;
> +	synchronize_rcu();
>  	kfree(h);

What is the purpose of the new synchronize_rcu() call? If its purpose is
to wait until *h is no longer in use, please use kfree_rcu() instead.

Thanks,

Bart.
