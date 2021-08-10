Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74D3C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 16:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC36B60ED8
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 16:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhHJQUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 12:20:02 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:46622 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhHJQUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 12:20:01 -0400
Received: by mail-pl1-f182.google.com with SMTP id k2so21749529plk.13
        for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2021 09:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lhxaEcH6Ty8ZON9r6QN0oqfG1NpyTNolpIbj8GZBVBg=;
        b=LmQ07Dzbf1/k946SeaWovm0h9D5phI4H3lPvL2SXm/sU+EBvSX0wnyOTIC2iy8QtfG
         5sBjGzxG3SkFCQXwPGo359qSfLeNOXcz34no3TokPP/1jjEr6sWW/FiBZN2fZo4bT+J3
         1MkiTNuizpcsr33eylaDhoGPUHZSN97ppHUgauj00nwaSm5Tc/F1V73zuRe9R5DW9xc1
         yAF3GKDqfl92cA5rzuNjWFWNm0wWyJEq0qGVhKzDIf+ymDh/eysJqSkpPLxRuibkV9m4
         s9OZATEyvcxXDtVKWh2RkTxgCrx+DMAWKakWjg6Ba08Nd0ThR8slZaIFqFakk+nSb9yY
         naHw==
X-Gm-Message-State: AOAM533BZV2Rg39EphftiD8EZhVOTou1oLcYmoCld/Ko77nZhOR0gGVX
        KcnUF2b3kBxaqw1q4dwBHD5fD5mT0jye5r9/
X-Google-Smtp-Source: ABdhPJx0TTXyzho36GXe9tiaQGhlwWbi91KRt0fJAujxiUURJWruSlst584BIgh1vcJcc26xb3TuXA==
X-Received: by 2002:a63:d14c:: with SMTP id c12mr121217pgj.412.1628612378861;
        Tue, 10 Aug 2021 09:19:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:c4:6dc5:1d3:61fa])
        by smtp.gmail.com with ESMTPSA id c12sm23494090pfl.56.2021.08.10.09.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 09:19:38 -0700 (PDT)
Subject: Re: [PATCH v5 00/52] Remove the request pointer from struct scsi_cmnd
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20210809230355.8186-1-bvanassche@acm.org>
 <yq1a6lpvpk0.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a6563829-2e1e-8117-de45-876004a288ff@acm.org>
Date:   Tue, 10 Aug 2021 09:19:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <yq1a6lpvpk0.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/21 10:28 PM, Martin K. Petersen wrote:
>> This patch series implements the following two changes for all SCSI drivers:
>> - Use blk_mq_rq_from_pdu() instead of the request member of struct scsi_cmnd
>>    since adding an offset to a pointer is faster than pointer indirection.
>> - Remove the request pointer from struct scsi_cmnd.
> 
> There were failures in storvsc and ufshpb. I fixed them up.

Hmm ... the basis of this patch series is commit 40fd8845c025 ("scsi: 
target: core: Drop unnecessary se_cmd ASC/ASCQ members"). That was the 
tip of the staging branch up until about two days ago. I'm not sure what 
I missed?

> Also rebased my PI series on top and fixed scsi_logical_block_count() to
> use scsi_cmd_to_rq().

Thanks!

>> Please consider this patch series for kernel v5.14.
> 
> A bit too late for 5.14 :)

Right, that part of the cover letter should have been updated.

Bart.
