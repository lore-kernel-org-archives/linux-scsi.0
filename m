Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E060C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 06:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6AD2076E
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 06:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="UzoJ74Px"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgHTGfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 02:35:20 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:61177 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgHTGfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Aug 2020 02:35:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597905318; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BsHP/VsghrgKGhgGXDoD+p7gF9YWU7QmO4EwsQlb5U0=;
 b=UzoJ74PxHmm+XfmxjupkBkrXNmeVNYat91X7K5o4uT4I7EVcVDGQ4F2DoxDKbTH0RU4i9LfH
 tQmuJJ+V7jx+LqPKXVlaT0qRFPcwVtcrU8Pn4tVQz5P9zB/UR50WgfH07fxosvwwS+a4yqi/
 9qT9FyHaY6Pye+S1diViEiBJ66g=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f3e199e4db56de6f024a729 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 20 Aug 2020 06:35:10
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39DD7C433A1; Thu, 20 Aug 2020 06:35:09 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6C85EC433CA;
        Thu, 20 Aug 2020 06:35:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Aug 2020 14:35:08 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Remove an unpaired
 ufshcd_scsi_unblock_requests() in err_handler()
In-Reply-To: <BY5PR04MB67057E61AB1866ADD61A3748FC5A0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <1597728047-39936-1-git-send-email-cang@codeaurora.org>
 <BY5PR04MB67057E61AB1866ADD61A3748FC5A0@BY5PR04MB6705.namprd04.prod.outlook.com>
Message-ID: <85f3004ef2869db77522d0e501982b9d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-20 14:24, Avri Altman wrote:
>> 
>> Commit 5586dd8ea250a ("scsi: ufs: Fix a race condition between error
>> handler and runtime PM ops") moves the ufshcd_scsi_block_requests() 
>> inside
>> err_handler(), but forgets to remove the 
>> ufshcd_scsi_unblock_requests() in
>> the early return path. Correct the coding mistake.
> 
> "fixes" tag please, for those who don't read the commit message.
> Thanks,
> Avri

Already added one in the V2 of it.

Thanks,

Can Guo.

>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 2b55c2e..b8441ad 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -5670,7 +5670,6 @@ static void ufshcd_err_handler(struct 
>> work_struct
>> *work)
>>                 if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
>>                         hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -               ufshcd_scsi_unblock_requests(hba);
>>                 return;
>>         }
>>         ufshcd_set_eh_in_progress(hba);
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
>> Linux
>> Foundation Collaborative Project.
