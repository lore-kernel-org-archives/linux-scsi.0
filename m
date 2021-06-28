Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C989C11F64
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 23:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C44761C23
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 23:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbhF1XBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 19:01:13 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:42660 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbhF1XBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 19:01:13 -0400
Received: by mail-pl1-f177.google.com with SMTP id v13so9807212ple.9;
        Mon, 28 Jun 2021 15:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rQuHayracZCE5AuUCtlx0qvA9ABrKm6B8angLYVYEb8=;
        b=KWU+v1IaGOGkY4Kr/HqG8Y2F+Xc+XQOSL7iU5CddfOUO7b/IIpXTxGbnL1NZ4HY7Ae
         rI02XbCJQ1ht2bp8i+SOGcNSzirU6SzTOMGKrdcxAtdFINouhjEAUPcJjQtZNnu44q4r
         wKa0YN52Day9L8TVRXK9UDBCOtXKBYQmLYaSLjl0BASL7p0fGm9vtJfbROYpZB6wHmfK
         oVeRLmTZLsXmVZPB64/W25l8QTQHYB3T66ckKBjqU8qAW4WXz+kP1oYQFXAKByeUKzpC
         YlNyoyN3LJLcpSqSOWR27Kgghxds6ccjbOmsl5MOMODHKgSbdXZm7XJe0BwDORl6rqqr
         zStQ==
X-Gm-Message-State: AOAM530CMYEbwwB9nsCiQLRglW3WeN+yKdAUbpKwnDcHhxfcZl9AS/pk
        Ap5+m13fu3XII2VFnMKl2AY=
X-Google-Smtp-Source: ABdhPJz773sQaKjTR5hTU6DS1WBDs3TNuXe56ia4TXreDfc9a6mue8ULUPDkwYnIqfXr3zNFkEc4Vg==
X-Received: by 2002:a17:90b:11d1:: with SMTP id gv17mr9094474pjb.230.1624921098509;
        Mon, 28 Jun 2021 15:58:18 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s79sm8460998pfc.87.2021.06.28.15.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 15:58:17 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c31185f5-e816-937d-25ac-1657b6111ff8@acm.org>
Date:   Mon, 28 Jun 2021 15:58:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1621845419-14194-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 1:36 AM, Can Guo wrote:
> Current UFS IRQ handler is completely wrapped by host lock, and because
> ufshcd_send_command() is also protected by host lock, when IRQ handler
> fires, not only the CPU running the IRQ handler cannot send new requests,
> the rest CPUs can neither. Move the host lock wrapping the IRQ handler into
> specific branches, i.e., ufshcd_uic_cmd_compl(), ufshcd_check_errors(),
> ufshcd_tmc_handler() and ufshcd_transfer_req_compl(). Meanwhile, to further
> reduce occpuation of host lock in ufshcd_transfer_req_compl(), host lock is
> no longer required to call __ufshcd_transfer_req_compl(). As per test, the
> optimization can bring considerable gain to random read/write performance.

Hi Can,

Since this patch has been applied on the AOSP kernel we see 100%
reproducible lockups appearing on multiple test setups. Examples of call
traces:

blk_execute_rq()
__scsi_execute()
sd_sync_cache()
sd_suspend_common()
sd_suspend_system()
scsi_bus_suspend()
__device_suspend()

blk_execute_rq()
__scsi_execute()
ufshcd_clear_ua_wlun()
ufshcd_err_handling_unprepare()
ufshcd_err_handler()
process_one_work()

Reverting this patch and the next patch from this series solved the
lockups. Do you prefer to revert this patch or do you perhaps want us to
test a potential fix?

Thanks,

Bart.

