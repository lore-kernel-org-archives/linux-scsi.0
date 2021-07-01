Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA89C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 22:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B1561410
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 22:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhGAWzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 18:55:35 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:56032 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhGAWzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 18:55:33 -0400
Received: by mail-pj1-f48.google.com with SMTP id l11so5234394pji.5
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 15:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3PvQ8uDfh3RZA7xQhzCGMMTILq5begAT2nzaXNjbWgs=;
        b=EPl2caBWXsFNCq+Z6fO04EyJ9usOWTXAoUsiZaENYfp9eDZtOinHyFR7gUowHiHZiZ
         hL5P3ZfYJmhJvks0n1fZugaKQPFm0UdevTT6RD5uDlimoJf/HJKMd9xlz07m/nX2E2IT
         ELq/UMBrqv+AeRdm2llaw1A9jUUWIo43gIj4bAx16OKF/i6QYU5Iknm37I9oEPRWR2PC
         ywJdxNS3+KRGmPg0TsLWNVdYkIyDfz+LHok6EOUfks7G96iKQWcQYdzMX9BOgS63VvmI
         9hBNHvDr8B5Fbybg4prJ8RaiO7jddfwFOU4cpU2Bv/GhkPWrVM2+Awyc/xeX0bY6/z9L
         RcUA==
X-Gm-Message-State: AOAM533+pvPG5nGNjQqJjCJdEox406iXMsHLZVimaSN2Z/futikzUrzF
        AtjZJCuOxZeiJcUKxdf4aKM=
X-Google-Smtp-Source: ABdhPJwEbv8rW68Ke/gfHz5xgjlHK3mZK2VqA2RSWq9UfJDWRRAxDIOXpMxNzyZeKyj4pTj86CrtOQ==
X-Received: by 2002:a17:902:ab95:b029:126:351c:e6ba with SMTP id f21-20020a170902ab95b0290126351ce6bamr1709185plr.16.1625179980853;
        Thu, 01 Jul 2021 15:53:00 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6a75:b07:a0d:8bd5? ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id em8sm9996997pjb.39.2021.07.01.15.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 15:53:00 -0700 (PDT)
Subject: Re: [PATCH 13/21] ufs: Remove several wmb() calls
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-14-bvanassche@acm.org>
 <a5770fbe-9bdc-444e-2093-aa3fd58d5638@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <93382037-8694-1647-db32-0dd42f1f8e2f@acm.org>
Date:   Thu, 1 Jul 2021 15:52:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a5770fbe-9bdc-444e-2093-aa3fd58d5638@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/21 3:26 PM, Asutosh Das (asd) wrote:
> Did you verify this change? I think we've seen OCS errors which were
> fixed with the wmb() in queuecommand.

Hi Asutosh,

Thanks for having taken a look. This patch has been verified against an
Exynos UFS controller.

Bart.
