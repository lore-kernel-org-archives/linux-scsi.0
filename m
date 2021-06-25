Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B713DC2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 17:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB6961962
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 17:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFYSAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 14:00:47 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:35834 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYSAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2021 14:00:46 -0400
Received: by mail-pj1-f48.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so8444545pjb.0;
        Fri, 25 Jun 2021 10:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A8lzyNP92yQOj05rtJwPYcsUcTXO2TeyGOg3/Sz2qAA=;
        b=br4+PAVU9Dzoii6k3WiHKIWZMUSZ08eqBV3wr8t29LBx8Q9HE57biug8SxYQJw1HPf
         8OAU0UU+aSvi9qm1VwRgd24fnc78oBWZ34eK/seyJuz0154K+9x60dlPoa9dgoC2TWAY
         uxMU1IlJryf/9c+boTeUlOy5v2ayTVAa6wLO9CPgPq1PrudJRHHc9L8L2ZqwuUBgxDUa
         BW8KN71Xqxqh9Rin6t89UaMtoj6mX7LgKt5TQ9vVA6EseYajdkUJWqfCtQS2Ex2PuCMc
         aB9bRxMkL1yaEqt/UPrE9nmxtCfcAB3E5td5446EDemAUqW0AaJ54UOHtg4Vjy7uMBrv
         rHdQ==
X-Gm-Message-State: AOAM532toLcqN17ErWBPnDbWLbAFlf9jbiYxWgxVOD6S6Yx0AtzPsm+X
        oi+rb0ghPjxVbc+r/cvdFOQ=
X-Google-Smtp-Source: ABdhPJyYQ1n98hAMKI0uVr+taxoOii2LJBzlAr08gmpaXwER0Wz4Yh3b+ykSZyJkiBJonCxXZ/pelg==
X-Received: by 2002:a17:90a:ae15:: with SMTP id t21mr22657448pjq.55.1624643904506;
        Fri, 25 Jun 2021 10:58:24 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p1sm6162352pfp.137.2021.06.25.10.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 10:58:23 -0700 (PDT)
Subject: Re: [PATCH] scsi: Delete scsi_{get,free}_host_dev()
To:     John Garry <john.garry@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@lst.de, hare@suse.de, ming.lei@redhat.com
References: <1624640314-93055-1-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d6a49a67-b1b9-a6eb-b322-ef1f168a94c1@acm.org>
Date:   Fri, 25 Jun 2021 10:58:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624640314-93055-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/25/21 9:58 AM, John Garry wrote:
> Functions scsi_{get,free}_host_dev() no longer have any in-tree users, so
> delete them.

It may be a good idea to add a reference to commit 0653c358d2dc ("scsi:
Drop gdth driver") since the gdth driver was the only driver that ever
used these functions. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
