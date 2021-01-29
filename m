Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CF3C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 03:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109A864DFB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 03:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhA2DUx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 22:20:53 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:36311 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2DUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 22:20:52 -0500
Received: by mail-pf1-f170.google.com with SMTP id u67so5353923pfb.3;
        Thu, 28 Jan 2021 19:20:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k2eSUgHidFs5mI64ptOb1kBsjfbzmQtjnKsaMen99WQ=;
        b=X7g88s6BQWtmFpQpYMN4wBhiPHM4+Xw+U6/YbCJnfvQ6kV6VTQ88D3idCEVbieykjM
         F8sam+o0IhMcB6IsP63DUlTnis6K29Z0uz3ywmejhZl6Lo05Dt+G4L5D/pb/vd9QHoEW
         jLXSRjPPsKUlHYClaR1vl2LnKCFhR7fXNtxgR+mZKgA27MBGazE5imoEzg5f0GTcyzWU
         PKVuVFw9kdsIwX5aoJOw6HdyuidwVupo2iZ1neYWYVgscorXMjq11/IWpg1xPiRwSU3s
         b5t/+TkiIY78vUKbHYR/jlKEn7Ba6VsDX5eC6E0pSZ73T//cQcXxQKSX7bzJRAX/X/IJ
         C6/w==
X-Gm-Message-State: AOAM532U33kR4sr2ooveybYsK4PNNNUN/NRv1zrkCIEDJOd0JUKD5eQn
        zfqCMLAlqEgxLJ7SAK5u88flwV0/JNA=
X-Google-Smtp-Source: ABdhPJwhdpdT6o2rQxn83GPB+elPa/+HuvEURG121ojql9enB8mYPaVD32mET9hVFi8IHKfA265l2Q==
X-Received: by 2002:a63:a312:: with SMTP id s18mr2448224pge.229.1611890411306;
        Thu, 28 Jan 2021 19:20:11 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:fd12:a590:9797:4acb? ([2601:647:4000:d7:fd12:a590:9797:4acb])
        by smtp.gmail.com with ESMTPSA id x8sm7255515pfn.27.2021.01.28.19.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:20:10 -0800 (PST)
Subject: Re: [PATCH v3 2/3] scsi: ufs: Fix a race condition btw task
 management request send and compl
To:     Can Guo <cang@codeaurora.org>, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-3-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <73362ca9-93be-c38f-a881-4b7cf690fbc1@acm.org>
Date:   Thu, 28 Jan 2021 19:20:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611807365-35513-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 8:16 PM, Can Guo wrote:
> ufshcd_compl_tm() looks for all 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL
> and call complete() for each req who has the req->end_io_data set. There
> can be a race condition btw tmc send/compl, because the req->end_io_data is
> set, in __ufshcd_issue_tm_cmd(), without host lock protection, so it is
> possible that when ufshcd_compl_tm() checks the req->end_io_data, it is set
> but the corresponding tag has not been set in REG_UTP_TASK_REQ_DOOR_BELL.
> Thus, ufshcd_tmc_handler() may wrongly complete TMRs which have not been
> sent out. Fix it by protecting req->end_io_data with host lock, and let
> ufshcd_compl_tm() only handle those tm cmds which have been completed
> instead of looking for 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL.

I don't know any other block driver that needs locking to protect races
between submission and completion context. Can the block layer timeout
mechanism be used instead of the mechanism introduced by this patch,
e.g. by using blk_execute_rq_nowait() to submit requests? That would
allow to reuse the existing mechanism in the block layer core to handle
races between request completion and timeout handling.

Thanks,

Bart.
