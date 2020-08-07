Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7D8C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 23:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 053EA2075A
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 23:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="dAYg0dk7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgHGXvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 19:51:07 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15035 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgHGXvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Aug 2020 19:51:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596844266; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: To:
 Subject: Sender; bh=/wOK4MvxcpZbK21ac4Gn0EAHD/IEcIttoKtPO34+rps=; b=dAYg0dk76YJ92qLOoSZcfM63c7O+DlfTx/v69zYWu05zY1nlnDz0PobWF9z55s88wKEy5t8w
 WoU5lexKRpFkb/egfZoW488vTta8+vTCamlRmmZzm4sUpA7zYwjZqxhZTRa7WA0jUmPy443e
 dwF/MwA/3xhuIXFJPNTnkbPiP00=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5f2de8cad96d28d61e8e6ca8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 Aug 2020 23:50:34
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 927A3C433CB; Fri,  7 Aug 2020 23:50:34 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A5BDC433C6;
        Fri,  7 Aug 2020 23:50:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A5BDC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v9 0/9] Fix up and simplify error recovery mechanism
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
References: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <ac862463-7009-719d-7373-7b5f308ed45b@codeaurora.org>
Date:   Fri, 7 Aug 2020 16:50:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/2020 2:04 AM, Can Guo wrote:
> The changes have been tested with error injections of multiple error types (and
> all kinds of mixture of them) during runtime, e.g. hibern8 enter/ exit error,
> power mode change error and fatal/non-fatal error from IRQ context. During the
> test, error injections happen randomly across all contexts, e.g. clk scaling,
> clk gate/ungate, runtime suspend/resume and IRQ.
> 
> There are a few more fixes to resolve other minor problems based on the main
> change, such as LINERESET handling and racing btw error handler and system
> suspend/resume/shutdown, but they will be pushed after this series is taken,
> due to there are already too many lines in these changes.
> 
> Change since v8:
> - Added one more fix to ufshcd_abort as requested by Stanley Chu
> 
> Change since v7:
> - Incorporated Asutosh's comments
> - Refined patch "scsi: ufs: Recover hba runtime PM error in error handler"
> 
> Change since v6:
> - Modified change "scsi: ufs-qcom: Fix schedule while atomic error in ufs_qcom_dump_dbg_regs" to "scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs"
> 
> Change since v5:
> - Dropped change "scsi: ufs: Fix imbalanced scsi_block_reqs_cnt caused by ufshcd_hold()" as it is not quite related with this series
> - Refined func ufshcd_err_handling_prepare in change "scsi: ufs: Recover hba runtime PM error in error handler"
> 
> Change since v4:
> - Split the original change "ufs: ufs-qcom: Fix a few BUGs in func ufs_qcom_dump_dbg_regs()" to 2 small changes
> 
> Change since v3:
> - Split the original change "scsi: ufs: Fix up and simplify error recovery mechanism" into 5 changes
> 
> Change since v2:
> - Incorporate Bart's comment to change "scsi: ufs: Add checks before setting clk-gating states"
> - Revised the commit msg of change "scsi: ufs: Fix up and simplify error recovery mechanism"
> 
> Change since v1:
> - Fixed a compilation error in case that CONFIG_PM is N
> 
> Can Guo (9):
>    scsi: ufs: Add checks before setting clk-gating states
>    ufs: ufs-qcom: Fix race conditions caused by func
>      ufs_qcom_testbus_config
>    scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs
>    scsi: ufs: Add some debug infos to ufshcd_print_host_state
>    scsi: ufs: Fix concurrency of error handler and other error recovery
>      paths
>    scsi: ufs: Recover hba runtime PM error in error handler
>    scsi: ufs: Move dumps in IRQ handler to error handler
>    scsi: ufs: Fix a racing problem btw error handler and runtime PM ops
>    scsi: ufs: Properly release resources if a task is aborted
>      successfully
> 
>   drivers/scsi/ufs/ufs-qcom.c  |  37 ----
>   drivers/scsi/ufs/ufs-sysfs.c |   1 +
>   drivers/scsi/ufs/ufshcd.c    | 508 +++++++++++++++++++++++++++----------------
>   drivers/scsi/ufs/ufshcd.h    |  14 ++
>   4 files changed, 338 insertions(+), 222 deletions(-)
> 

Please add my ack to the series.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
