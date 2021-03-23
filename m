Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7DFC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AC2D619BB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhCWQbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:31:42 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:43573 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhCWQbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 12:31:36 -0400
Received: by mail-pf1-f170.google.com with SMTP id q5so14848914pfh.10
        for <linux-scsi@vger.kernel.org>; Tue, 23 Mar 2021 09:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+yqXAwQGOhjIyV/EAtk3pSoKQSj/1xtU/s6SOgr8Twc=;
        b=bmlPvxP1ob4jZOuIjoT4eZN6vHh2SAJUtk1Y7j8Y6SqRJWz6/NJZyzNxCwrgFDe/wN
         N0a71L+fD4Q10DnDoCB7obpJPnZCYlE+dWGLsmmyUDyduCpXgs9cwXmBg4y4gbsuO1J3
         Pv1GfX6O8tX8kzHFRaDC4EG1ObPGJUmsPdxzEthTLdtjCZq3SPR1D+JMcxknR/FwoCSv
         faG5bWvOSB/bl/YNBLt0Tq/991xrsoIcGcoJyKbLsCU8rUZrz1O5K4asBCwccqGOXFN1
         kPLLiD0d8clWwDCyesRpeadlwpOel8KIVVIGAiGwTMz8ui0yLBPQqQ7owR3Nzby7S2nn
         nlcQ==
X-Gm-Message-State: AOAM531UNoaQO/gSdB1Coc2e6ATKXbuYu/i9hE0szMmPYVhiVx2+GOdP
        v2sXsmN4skiMR2R3OgP6vuE/MKggcVM=
X-Google-Smtp-Source: ABdhPJyFxdyDMlTaSgE4qSn7jnWka+WADCa3qfusQCIFnd+7IaZKNoLsY2s2KA5c8g/nXUyN3NvokQ==
X-Received: by 2002:a17:902:7c0d:b029:e6:f006:fd02 with SMTP id x13-20020a1709027c0db02900e6f006fd02mr5320526pll.46.1616517096278;
        Tue, 23 Mar 2021 09:31:36 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:817a:e98d:7315:e25f? ([2601:647:4000:d7:817a:e98d:7315:e25f])
        by smtp.gmail.com with ESMTPSA id l20sm17984910pfd.82.2021.03.23.09.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:31:35 -0700 (PDT)
Subject: Re: [PATCH 03/11] qla2xxx: fix stuck session
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-4-njavali@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bd9dd526-776b-87a4-9b81-634ce687e393@acm.org>
Date:   Tue, 23 Mar 2021 09:31:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323044257.26664-4-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 9:42 PM, Nilesh Javali wrote:
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index c48daf52725d..fa8c4dae8dce 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1029,7 +1029,7 @@ void qlt_free_session_done(struct work_struct *work)
>  			}
>  			msleep(100);
>  			cnt++;
> -			if (cnt > 200)
> +			if (cnt > 230)
>  				break;
>  		}

One magic constant is changed into another magic constant and that is
sufficient to fix a bug? Please add a comment that explains the meaning
of that constant.

Thanks,

Bart.

