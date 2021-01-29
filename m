Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEAEC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 06:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878F764DFF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 06:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhA2Gc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 01:32:29 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:18434 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232237AbhA2GbC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Jan 2021 01:31:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611901840; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=k99FP1SFldOePaUcEFCtxlpJY4Jhko9U7KZE8IRb3Ss=;
 b=a5p/UGZYQPm9Gv6VWBmUO/4WdaC4xCjaReDrCBoRyo1V+XyNchLpcyPtmr1uF9NrAF9IqXOg
 cX57J9WGgeL3P3sNaPI9OtU2p348lJj17xdmLLxQKRL87+MfoUv0hr9GyKlUIck+niUUlsVO
 4EPMjzoW1Jf1+qxragCFxxTzE2E=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6013ab66589a8a2d5ad363f7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 Jan 2021 06:29:58
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 55FAAC43467; Fri, 29 Jan 2021 06:29:58 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5FAF2C433CA;
        Fri, 29 Jan 2021 06:29:57 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 Jan 2021 14:29:57 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] scsi: ufs: Fix a race condition btw task
 management request send and compl
In-Reply-To: <5f77542d66732003f0154a4e8a6ae13b@codeaurora.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-3-git-send-email-cang@codeaurora.org>
 <73362ca9-93be-c38f-a881-4b7cf690fbc1@acm.org>
 <5f77542d66732003f0154a4e8a6ae13b@codeaurora.org>
Message-ID: <56b26318de92eb88d663bbdc7096edcf@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-29 14:06, Can Guo wrote:
> On 2021-01-29 11:20, Bart Van Assche wrote:
>> On 1/27/21 8:16 PM, Can Guo wrote:
>>> ufshcd_compl_tm() looks for all 0 bits in the 
>>> REG_UTP_TASK_REQ_DOOR_BELL
>>> and call complete() for each req who has the req->end_io_data set. 
>>> There
>>> can be a race condition btw tmc send/compl, because the 
>>> req->end_io_data is
>>> set, in __ufshcd_issue_tm_cmd(), without host lock protection, so it 
>>> is
>>> possible that when ufshcd_compl_tm() checks the req->end_io_data, it 
>>> is set
>>> but the corresponding tag has not been set in 
>>> REG_UTP_TASK_REQ_DOOR_BELL.
>>> Thus, ufshcd_tmc_handler() may wrongly complete TMRs which have not 
>>> been
>>> sent out. Fix it by protecting req->end_io_data with host lock, and 
>>> let
>>> ufshcd_compl_tm() only handle those tm cmds which have been completed
>>> instead of looking for 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL.
>> 
>> I don't know any other block driver that needs locking to protect 
>> races
>> between submission and completion context. Can the block layer timeout
>> mechanism be used instead of the mechanism introduced by this patch,
>> e.g. by using blk_execute_rq_nowait() to submit requests? That would
>> allow to reuse the existing mechanism in the block layer core to 
>> handle
>> races between request completion and timeout handling.
> 
> This patch is not introducing any new mechanism, it is fixing the
> usage of completion (req->end_io_data = c) introduced by commit
> 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate
> and free TMFs"). If you have better idea to get it fixed once for
> all, we are glad to take your change to get it fixed asap.
> 
> Regards,
> 
> Can Guo.
> 

On second thought, actually the 1st fix alone is enough to eliminate the
race condition. Because blk_mq_tagset_busy_iter() only iterates over all
requests which are not in IDLE state, if blk_mq_start_request() is 
called
within the protection of host spin lock, ufshcd_compl_tm() shall not run
into the scenario where req->end_io_data is set but 
REG_UTP_TASK_REQ_DOOR_BELL
has not been set. What do you think?

Thanks,

Can Guo.

>> 
>> Thanks,
>> 
>> Bart.
