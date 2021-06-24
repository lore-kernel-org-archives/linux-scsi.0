Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55D6C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE621613CE
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 04:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFXETb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 00:19:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:29364 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFXETb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 00:19:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624508232; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6xloiwpG87/uJvUK4exXuYaUArkN/R59tp9MRa1/bhg=;
 b=pOCQnKDgWySWYmKp7ixtFgAsEeKTCgHTIgTccZjAktBcI5WQSfH0ioGGVxqzQRPE9SgLJ6Dq
 k19K7SI3dKQDHasH3ZDdd6/atqPluxovLuRuITpSB1s6FRyNoyuhelPwCh4DqGZscrdZPHtQ
 vMLYXQty6YfM8hS7eTvVTi6cdVk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60d40733d2559fe3928a49fb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 04:16:51
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 832CDC43144; Thu, 24 Jun 2021 04:16:51 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AAC89C433D3;
        Thu, 24 Jun 2021 04:16:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Jun 2021 12:16:50 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
In-Reply-To: <b28d71a7-3839-2c07-2630-6196ea10951f@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-11-git-send-email-cang@codeaurora.org>
 <b28d71a7-3839-2c07-2630-6196ea10951f@acm.org>
Message-ID: <5ff72cfab707b571ef395d52931edd0f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-24 05:33, Bart Van Assche wrote:
> On 6/23/21 12:35 AM, Can Guo wrote:
>> @@ -2737,7 +2737,7 @@ static int ufshcd_queuecommand(struct Scsi_Host 
>> *host, struct scsi_cmnd *cmd)
>>  		 * err handler blocked for too long. So, just fail the scsi cmd
>>  		 * sent from PM ops, err handler can recover PM error anyways.
>>  		 */
>> -		if (hba->wlu_pm_op_in_progress) {
>> +		if (cmd->request->rq_flags & RQF_PM) {
>>  			hba->force_reset = true;
>>  			set_host_byte(cmd, DID_BAD_TARGET);
>>  			cmd->scsi_done(cmd);
> 
> I'm still concerned that the above code may trigger data corruption. I
> prefer that the above code is removed instead of being modified.

Removing the change will lead to deadlock when error handling prepare
calls pm_runtime_get_sync().

RQF_PM is only given to requests sent from power management operations,
during which the specific device/LU is suspending/resuming, meaning no
data transaction is ongoing. How can fast failing a PM request trigger
data corruption?

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
