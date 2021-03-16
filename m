Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D2AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3305064F7B
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCPU3Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 16:29:16 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:41063 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhCPU2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 16:28:46 -0400
Received: by mail-pg1-f171.google.com with SMTP id w34so22329344pga.8
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 13:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TcBuObS32usn2dUK0Mn6FgzQGmvyWoxIfWdl8WEuBbc=;
        b=R0mE/w8/s7srlfUyZbDroLhzmvOobaNmYmFFyEpAr6d8AH9fsC+uKXwT3qFvMz6vQH
         n+hDVLWWfkVffPDtQn0jielym4tsO14YDtMCXSSgRkrWr0IM5yBs/H64hN4/DysUca34
         4B8FMKbRWyVAKnG2rYm1XKTGxUtOZs7NiXqw8Ypee2GiZzlgkUDOCVnt9TENB1MMjUtF
         N1V2tNyynLLX3ZiFYt9nM3mNesjqt6+TVpcuX5rUSFRwqVsKySN17zf/1VAYYv2DrGDL
         wsE1ehhCNB+sXb9F8G8pWPwYGNiTUjgdj6XDnNaz/ZGhsNtSVMFDuXQMjVhgeL6um/ZJ
         Kp+A==
X-Gm-Message-State: AOAM532zzgBRcAMFTEXEHCfpBMJyaoEbm/PWMhwqTx5wotd78gYkJ2+F
        hLsVMVi0wzxQ1JbiKOT6ktg=
X-Google-Smtp-Source: ABdhPJy1q8A0cxfWqcyLUjxBzdBJIaYE0lFQmQE0wvJkgVzEZ75QaPGZhNwWLCeH6suJ2PrQBaWYAA==
X-Received: by 2002:a62:1ad5:0:b029:1fa:c667:2776 with SMTP id a204-20020a621ad50000b02901fac6672776mr1114658pfa.6.1615926525746;
        Tue, 16 Mar 2021 13:28:45 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b6b5:afbd:6ae4:8f83? ([2601:647:4000:d7:b6b5:afbd:6ae4:8f83])
        by smtp.gmail.com with ESMTPSA id 186sm18979568pfb.143.2021.03.16.13.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 13:28:45 -0700 (PDT)
Subject: Re: [PATCH 1/7] Revert "qla2xxx: Make sure that aborted commands are
 freed"
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-2-bvanassche@acm.org>
 <8EE7F726-C6BA-417B-BD68-5B2FDE5F74FC@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b39b0088-6cc6-36b3-8ca7-b4d49209ffbb@acm.org>
Date:   Tue, 16 Mar 2021 13:28:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <8EE7F726-C6BA-417B-BD68-5B2FDE5F74FC@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/21 9:25 AM, Himanshu Madhani wrote:
> Curious …. What triggered this revert? Can you share your motivation for this revert.

Hi Himanshu,

It has been observed that the following scenario triggers a kernel crash:
- qlt_xmit_response() calls qlt_check_reserve_free_req().
- qlt_check_reserve_free_req() returns -EAGAIN.
- qlt_xmit_response() calls vha->hw->tgt.tgt_ops->free_cmd(cmd).
- transport_handle_queue_full() tries to retransmit the response.

I will add this information to the patch description.

Bart.
