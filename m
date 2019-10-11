Return-Path: <SRS0=6PDV=YE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BBDC47404
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Oct 2019 17:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F410A214E0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Oct 2019 17:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbfJKRR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Oct 2019 13:17:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38249 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbfJKRR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Oct 2019 13:17:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so6155064pgi.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Oct 2019 10:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BpYjJAysBfdD7ReRuQY0PVLzfXvEgqlPIMtEmvnMFJE=;
        b=gDSHHqmrtDeaF+rcetCwPUw2ZENnejFPKtp3xIqcp+9/pXUwhQbBRyKHvS0PSONiXW
         YchGWstASOIJaWCC+EOGqr1xC+wzj06qaaPuXaOomxBJVqMxPW2Tq42sTh2yM/f0xgy3
         7eNOYCgjym+dwnpgLrD3s4NAC16/iL287edMGlURo4zpsPPHOCRt/bqBv8rygNUsB723
         ogAjBKLiD0edunYcBE5qJ9RCeSpQV55xwFoI6PgCJb/8lvXPZ8UaR3VxDqIhmOtDokN1
         4SeG70d/Q2B4X0SB2/t09T4xL/+aJAXXm6RayU5dZ9kO7KI8nQeUhAeE+Npgsf1oaAFV
         cN1A==
X-Gm-Message-State: APjAAAX80BiNNSMYKqIYBsZ65LtAgFif+qCZeTg6c+yguxZj4IF9lCBu
        JtdPBkfWvJWOncrd7ojjy3QMzmMV
X-Google-Smtp-Source: APXvYqxiHQsASH2cPf0DQlZ0y9rE5ovMDlrj4WziO43NSUwri8C1F0hq2zNuYvUzAaUWV3elg1gvew==
X-Received: by 2002:a63:4756:: with SMTP id w22mr5829111pgk.106.1570814276653;
        Fri, 11 Oct 2019 10:17:56 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q36sm9466262pgb.34.2019.10.11.10.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2019 10:17:55 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: fix uninit-value access of variable sshdr
To:     zhengbin <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <1570709143-147364-1-git-send-email-zhengbin13@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8be12c02-9055-0129-8f40-5030d6c31fd6@acm.org>
Date:   Fri, 11 Oct 2019 10:17:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570709143-147364-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/19 5:05 AM, zhengbin wrote:
> +	/*
> +	 * need to initial sshdr to avoid uninit-value access
> +	 */
> +	if (sshdr)
> +		memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
> +

I think the above comment is slightly confusing because it is correct 
for some callers but not for all callers of scsi_execute(). How about 
changing the comment into something like the following: "Zero-initialize 
sshdr for those callers that check the *sshdr contents even if no sense 
data is available"?

Thanks,

Bart.
