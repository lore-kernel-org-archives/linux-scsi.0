Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186D5C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 13:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE42208A9
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 13:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="fOI2Yv8P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgG2NDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 09:03:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35452 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgG2NDj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 09:03:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596027818; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Z/CQ/FqDlwwW+m2QFj2+c7Hf8xIIhoH/WH49OMnQboM=;
 b=fOI2Yv8PTSazktCYfcTuAkDSsMaSOMhLhinNOyaM3PO2wkUlcF4BlQisvGLS0bTefHyyovNn
 64Qj9mm8LejqggXon1O+rZ/yb4F1rLtvzY8NUbZwcfOpMdYZuFZfWud9NJiwKOgcLY+oWiR7
 GZRYjXnsM606PyeW8GieiDAYcZE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-east-1.postgun.com with SMTP id
 5f21737236e6de324e9a1946 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 29 Jul 2020 13:02:42
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81BB4C433B1; Wed, 29 Jul 2020 13:02:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C52FC433C9;
        Wed, 29 Jul 2020 13:02:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 Jul 2020 21:02:40 +0800
From:   Can Guo <cang@codeaurora.org>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Cc:     nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, sh425.lee@samsung.com,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 7/8] scsi: ufs: Move dumps in IRQ handler to error
 handler
In-Reply-To: <7e5e942d-449b-bd52-32da-7f5beed116b7@codeaurora.org>
References: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
 <1595912460-8860-8-git-send-email-cang@codeaurora.org>
 <7e5e942d-449b-bd52-32da-7f5beed116b7@codeaurora.org>
Message-ID: <dff9541177ebf68950ca13d2f13d88ba@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Asutosh,

On 2020-07-29 02:06, Asutosh Das (asd) wrote:
> On 7/27/2020 10:00 PM, Can Guo wrote:
>> Sometime dumps in IRQ handler are heavy enough to cause system 
>> stability
>> issues, move them to error handler.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++----------------
>>   1 file changed, 15 insertions(+), 16 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c480823..b2bafa3 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -5682,6 +5682,21 @@ static void ufshcd_err_handler(struct 
>> work_struct *work)
>>   				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
>>   		needs_reset = true;
>>   +	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
>> +			      UFSHCD_UIC_HIBERN8_MASK)) {
>> +		bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
>> +
>> +		dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
>> +				__func__, hba->saved_err, hba->saved_uic_err);
>> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +		ufshcd_print_host_state(hba);
>> +		ufshcd_print_pwr_info(hba);
>> +		ufshcd_print_host_regs(hba);
>> +		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
>> +		ufshcd_print_trs(hba, hba->outstanding_reqs, pr_prdt);
>> +		spin_lock_irqsave(hba->host->host_lock, flags);
>> +	}
>> +
>>   	/*
>>   	 * if host reset is required then skip clearing the pending
>>   	 * transfers forcefully because they will get cleared during
>> @@ -5900,22 +5915,6 @@ static irqreturn_t ufshcd_check_errors(struct 
>> ufs_hba *hba)
>>     		/* block commands from scsi mid-layer */
>>   		ufshcd_scsi_block_requests(hba);
>> -
>> -		/* dump controller state before resetting */
>> -		if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
>> -			bool pr_prdt = !!(hba->saved_err &
>> -					SYSTEM_BUS_FATAL_ERROR);
>> -
>> -			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
>> -					__func__, hba->saved_err,
>> -					hba->saved_uic_err);
>> -
>> -			ufshcd_print_host_regs(hba);
>> -			ufshcd_print_pwr_info(hba);
> How about keep the above prints and move the tmrs and trs to eh?
> Sometimes in system instability, the eh may not get a chance to run
> even. Still the above prints would provide some clues.

Here is the IRQ handler, ufshcd_print_host_regs() is sometime heavy
enough to cause stability issues during my fault injection test, since
it prints host regs, reg's history, crypto debug infos plus prints
from vops_dump.

How about just printing host regs and reg history here? Most time, these
infos are enough.

Thanks,

Can Guo.

>> -			ufshcd_print_tmrs(hba, hba->outstanding_tasks);
>> -			ufshcd_print_trs(hba, hba->outstanding_reqs,
>> -					pr_prdt);
>> -		}
>>   		ufshcd_schedule_eh_work(hba);
>>   		retval |= IRQ_HANDLED;
>>   	}
>> 
