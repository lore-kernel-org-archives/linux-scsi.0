Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D35C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA441216C4
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="tsC0FgZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgKCN21 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:28:27 -0500
Received: from z5.mailgun.us ([104.130.96.5]:22061 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgKCN2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 08:28:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604410105; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=JLjIZJZw1u9HJgVMWdn4LPLwRFKRMpegIpRTqok6leY=;
 b=tsC0FgZjitOhS94IAN0g4cU5Row3+l55vWSI4f5SBUgA2A3HjdTp+Bw0OLHZRHcdcH8fiiD0
 DYlQCC8qzbZ3BHB40+Ay848Wq84pmWWfdxBgz9na74inxizPpwrIMOJ5RDZOVEJR33PwnD3v
 Y9g8qcQbI504wdvzdr68ZHckDvc=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fa15af7875877e3edaa822f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 03 Nov 2020 13:28:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0073C38591; Tue,  3 Nov 2020 10:01:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69B04C38586;
        Tue,  3 Nov 2020 10:01:02 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 03 Nov 2020 18:01:01 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Fix unbalanced scsi_block_reqs_cnt
 caused by ufshcd_hold()
In-Reply-To: <1604387262.13152.2.camel@mtkswgap22>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
 <1604384682-15837-2-git-send-email-cang@codeaurora.org>
 <1604387262.13152.2.camel@mtkswgap22>
Message-ID: <09c5d4d31a0bd9bed99815cfbf51aaad@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-03 15:07, Stanley Chu wrote:
> Hi Can,
> 
> On Mon, 2020-11-02 at 22:24 -0800, Can Guo wrote:
>> The scsi_block_reqs_cnt increased in ufshcd_hold() is supposed to be
>> decreased back in ufshcd_ungate_work() in a paired way. However, if
>> specific ufshcd_hold/release sequences are met, it is possible that
>> scsi_block_reqs_cnt is increased twice but only one ungate work is
>> queued. To make sure scsi_block_reqs_cnt is handled by ufshcd_hold() 
>> and
> 
> Just curious that how could this be possible? Would you have some 
> failed
> examples?
> 

[1] One gate_work() is in the workqueue, not yet executed, now clk state 
== REQ_CLKS_OFF.
[2] ufshcd_queuecommand() calls ufshcd_hold(async == ture) -> 
active_req++ -> scsi_block_reqs_cnt++ -> REQ_CLKS_ON -> queue ungate 
work -> active_req-- -> return -EAGAIN.
[3] Now gate_work() starts to run, but since the clk state is 
REQ_CLKS_ON, gate_work() just sets clk state to CLKS_ON and bail.
[3] Someone calls ufshcd_hold(async == false) -> do something -> 
ufshcd_release() -> clk state is changed to REQ_CLKS_OFF. Note that, 
till now, ungate_work() is still in the work queue, not executed yet.
[4] Now, if someone calls ufshcd_hold(), we will hit the issue.

Above sequence is a very common clk gate/ungate sequence. The issue
is because ungate_work is queued but cannot be executed in time. In my
case, I see the ungate_work is somehow delayed for about 150ms. This
change has been tested by customers on multiple platforms. And you
can tell from the code that it won't break anything. :)

Thanks,

Can Guo.

>> ufshcd_ungate_work() in a paired way, increase it only if queue_work()
>> returns true.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 847f355..efa7d86 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1634,12 +1634,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool 
>> async)
>>  		 */
>>  		/* fallthrough */
>>  	case CLKS_OFF:
>> -		ufshcd_scsi_block_requests(hba);
>>  		hba->clk_gating.state = REQ_CLKS_ON;
>>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>>  					hba->clk_gating.state);
>> -		queue_work(hba->clk_gating.clk_gating_workq,
>> -			   &hba->clk_gating.ungate_work);
>> +		if (queue_work(hba->clk_gating.clk_gating_workq,
>> +			       &hba->clk_gating.ungate_work))
>> +			ufshcd_scsi_block_requests(hba);
>>  		/*
>>  		 * fall through to check if we should wait for this
>>  		 * work to be done or not.
> 
> Thanks,
> Stanley Chu
