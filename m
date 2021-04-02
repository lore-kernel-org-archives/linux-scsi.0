Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1262C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 00:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92715610D2
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 00:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhDBAJ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:09:59 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:46687 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhDBAJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 20:09:59 -0400
Received: by mail-pl1-f179.google.com with SMTP id t20so1769780plr.13;
        Thu, 01 Apr 2021 17:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MmXSX3r+wvQMj8foV/QqbIV9PRwi4FyQdgVU8qfNSDk=;
        b=YB9mL4RwTYGHLGEoAa+emsln/qeKjE0s5U0zOWbHob6j5LkS4C7QALxPUkWodDQw5B
         ZlYWO26RzPHFw7SiNkphMRLYL6FkOGcP5CeOHunff5jUM55urqf7Sm714GkDmpkp+hEX
         tKH4s1jwD9/HKwsLRLCn+/eGB6xDKTFxMZXk/PSwVQaGcRfhkkRdHHXj8926ZFtive0H
         Diq72ONUCZLMJIG77irxIJc9/kSbMucI02QsYSQwdc8i6STyIioNF8Gv/KPYvg6GvEJn
         2z4oDbCtXTMfxNO9Nib7U7GXlRkx+dXxz+5OdOrdI5th22KskOQSw7k72h7AO79upJo0
         ov5w==
X-Gm-Message-State: AOAM5310VuTMCSXXBxO6ixqEeYy2R57aAbkLStizDc9swYp9jcp+sIYq
        b92qsmNQx4BjNBtaR1861IHEwpOwYHk=
X-Google-Smtp-Source: ABdhPJwreWyhmHwe03JI420GnTPwNWMTm7YigigOLZex/25ztT8gtiQI3HRqtX0mNYqyvW+1U7gEww==
X-Received: by 2002:a17:90a:598e:: with SMTP id l14mr10948451pji.187.1617322197046;
        Thu, 01 Apr 2021 17:09:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:2046:e611:bcdf:eb50? ([2601:647:4000:d7:2046:e611:bcdf:eb50])
        by smtp.gmail.com with ESMTPSA id fr23sm6476339pjb.22.2021.04.01.17.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 17:09:56 -0700 (PDT)
Subject: Re: [PATCH v5 1/2] scsi: ufs: Fix task management request completion
 timeout
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1617262750-4864-1-git-send-email-cang@codeaurora.org>
 <1617262750-4864-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b63858c5-8cc3-da27-01b0-7aec869c46c9@acm.org>
Date:   Thu, 1 Apr 2021 17:09:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1617262750-4864-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/21 12:39 AM, Can Guo wrote:
> ufshcd_tmc_handler() calls blk_mq_tagset_busy_iter(fn = ufshcd_compl_tm()),
> but since blk_mq_tagset_busy_iter() only iterates over all reserved tags
> and requests which are not in IDLE state, ufshcd_compl_tm() never gets a
> chance to run. Thus, TMR always ends up with completion timeout. Fix it by
> calling blk_mq_start_request() in  __ufshcd_issue_tm_cmd().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
