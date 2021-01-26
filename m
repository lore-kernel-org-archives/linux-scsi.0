Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6984C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 19:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE2422EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 19:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbhAZFae (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:30:34 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:57931 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbhAZCLm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 21:11:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611627075; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=kBJZDG2tUANkOa6JriIfIEN3HbEWWrkMH6tsmb1Uudg=;
 b=XAsMDjXgDNfw0ndtQNrHZL7aS06eKoiOgHiRbrItvZ9kdGy0Vzn3+63eUy8MnX2bOCiC6YW0
 vETY1bfSHHDHU/0SI5CUFjPHba/uIxPzPYe5wBWw/hClJ1UxFFedi6A4wEmGd/xPlOshHOlj
 TBcZYp5FCvAO2BPr95io+jjxLVo=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 600f7a18ad4c9e395b687c2e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Jan 2021 02:10:32
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6FACAC43465; Tue, 26 Jan 2021 02:10:32 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92270C433CA;
        Tue, 26 Jan 2021 02:10:31 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 26 Jan 2021 10:10:31 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Fix some problems in task management
 request implementation
In-Reply-To: <DM6PR04MB65754B0CF70B9A3EB036D157FCBD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1611199388-24668-1-git-send-email-cang@codeaurora.org>
 <DM6PR04MB65754B0CF70B9A3EB036D157FCBD9@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <6362e6f2117237b934eea44f700fd13a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-25 19:36, Avri Altman wrote:
>> Current task management request send/compl implementation is broken, 
>> the
>> problems and fixes are listed as below:
>> 
>> Problem: TMR completion timeout. ufshcd_tmc_handler() calls
>>          blk_mq_tagset_busy_iter(fn == ufshcd_compl_tm()), but since
>>          blk_mq_tagset_busy_iter() only iterates over all reserved 
>> tags and
>>          started requests, so ufshcd_compl_tm() never gets a chance to 
>> run.
>> Fix:     Call blk_mq_start_request() in __ufshcd_issue_tm_cmd().
>> 
>> Problem: Race condition in send/compl paths. ufshcd_compl_tm() looks 
>> for
>>          all 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL and call 
>> complete()
>>          for each req who has the req->end_io_data set. There can be a 
>> race
>>          condition btw tmc send/compl, because req->end_io_data is 
>> set, in
>>          __ufshcd_issue_tm_cmd(), without host lock protection, so it 
>> is
>>          possible that when ufshcd_compl_tm() checks the 
>> req->end_io_data,
>>          req->end_io_data is set but the corresponding tag has not 
>> been set
>>          in the REG_UTP_TASK_REQ_DOOR_BELL. Thus, ufshcd_tmc_handler()
>> may
>>          wrongly complete TMRs which have not been sent.
>> Fix:     Protect req->end_io_data with host lock. And let 
>> ufshcd_compl_tm()
>>          only handle those tm cmds which have been completed instead 
>> of
>>          looking for 0 bits in the REG_UTP_TASK_REQ_DOOR_BELL.
>> 
>> Problem: In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs 
>> +
>>          req->tag as the Task Tag in one TMR UPIU.
>> Fix:     Directly use req->tag as Task Tag.
>> 
>> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Since you are practically reverting Bart's change (69a6c269c097),
> maybe cc him as well,
> And add a fixes tag?
> 

Hi Avri,

It is not reverting Bart's change, but making TMR work properly based
on it. I am ok with the Bart's idea of getting a tag for TMR from
blk_get_request(), and this patch respects that idea.

> Also, even though all those fixes are around the same place, but
> fixing different issues,
> You might want to consider to separate those.  Whatever you think.
> 

Thanks for the suggestion. I treat it as a whole because it is 
convenient
for me to get it ported and tested over different platforms. I may
revise it in next version after more comments come on it.

Thanks,
Can Guo.

> Thanks,
> Avri
