Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10B3C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCD62080C
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="v0Sqfgv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgKCN21 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:28:27 -0500
Received: from z5.mailgun.us ([104.130.96.5]:62151 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbgKCN2Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 08:28:24 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604410103; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Hoz/9n79EsI+6gaixvqKXML4PaGEpjr6mGkwMpWyi2o=;
 b=v0Sqfgv3pJ3bTA/cesWphdtVzVtbbAm3d3JAM5e1LWdXDRcmrmlMiS2pvncXTGU1tFJ/u8JF
 DI8o5s4plxW5gDhFGeeSBrk/T5O6VEajj436l3LC7/5y4RH5Tu40OTHDzE57VwG7t/95YrqY
 3AlGRnVHNTxKNdYeLpOMVua8c0c=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fa15af71037425ce11641da (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 03 Nov 2020 13:28:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 87044C3852B; Tue,  3 Nov 2020 08:01:43 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30920C384FE;
        Tue,  3 Nov 2020 08:01:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 03 Nov 2020 16:01:42 +0800
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
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: Try to save power mode change and UIC
 cmd completion timeout
In-Reply-To: <1604388023.13152.4.camel@mtkswgap22>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
 <1604384682-15837-3-git-send-email-cang@codeaurora.org>
 <1604388023.13152.4.camel@mtkswgap22>
Message-ID: <1a557cffd04632875f6d52d43a036ad9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-11-03 15:20, Stanley Chu wrote:
> Hi Can,
> 
> Except for below nit, otherwise looks good to me.
> 
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> 
> On Mon, 2020-11-02 at 22:24 -0800, Can Guo wrote:
>> Use the uic_cmd->cmd_active as a flag to track the lifecycle of an UIC 
>> cmd.
>> The flag is set before send the UIC cmd and cleared in IRQ handler. 
>> When a
>> PMC or UIC cmd completion timeout happens, if the flag is not set, 
>> instead
>> of returning timeout error, we still treat it as a successful 
>> operation.
>> This is to deal with the scenario in which completion has been raised 
>> but
>> the one waiting for the completion cannot be awaken in time due to 
>> kernel
>> scheduling problem.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++++++--
>>  drivers/scsi/ufs/ufshcd.h |  2 ++
>>  2 files changed, 26 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index efa7d86..7f33310 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2122,10 +2122,20 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, 
>> struct uic_command *uic_cmd)
>>  	unsigned long flags;
>> 
>>  	if (wait_for_completion_timeout(&uic_cmd->done,
>> -					msecs_to_jiffies(UIC_CMD_TIMEOUT)))
>> +					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
>>  		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
>> -	else
>> +	} else {
>>  		ret = -ETIMEDOUT;
>> +		dev_err(hba->dev,
>> +			"uic cmd 0x%x with arg3 0x%x completion timeout\n",
>> +			uic_cmd->command, uic_cmd->argument3);
>> +
>> +		if (!uic_cmd->cmd_active) {
>> +			dev_err(hba->dev, "%s: UIC cmd has been completed, return the 
>> result\n",
>> +				__func__);
>> +			ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
>> +		}
>> +	}
>> 
>>  	spin_lock_irqsave(hba->host->host_lock, flags);
>>  	hba->active_uic_cmd = NULL;
>> @@ -2157,6 +2167,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, 
>> struct uic_command *uic_cmd,
>>  	if (completion)
>>  		init_completion(&uic_cmd->done);
>> 
>> +	uic_cmd->cmd_active = 1;
>>  	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
>> 
>>  	return 0;
>> @@ -3828,10 +3839,18 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba 
>> *hba, struct uic_command *cmd)
>>  		dev_err(hba->dev,
>>  			"pwr ctrl cmd 0x%x with mode 0x%x completion timeout\n",
>>  			cmd->command, cmd->argument3);
>> +
>> +		if (!cmd->cmd_active) {
>> +			dev_err(hba->dev, "%s: Power Mode Change operation has been 
>> completed, go check UPMCRS\n",
>> +				__func__);
>> +			goto check_upmcrs;
>> +		}
>> +
>>  		ret = -ETIMEDOUT;
>>  		goto out;
>>  	}
>> 
>> +check_upmcrs:
>>  	status = ufshcd_get_upmcrs(hba);
>>  	if (status != PWR_LOCAL) {
>>  		dev_err(hba->dev,
>> @@ -4923,11 +4942,14 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct 
>> ufs_hba *hba, u32 intr_status)
>>  			ufshcd_get_uic_cmd_result(hba);
>>  		hba->active_uic_cmd->argument3 =
>>  			ufshcd_get_dme_attr_val(hba);
>> +		if (!hba->uic_async_done)
> 
> Is this check necessary?
> 

Thanks for your quick response.

In the case of PMC, UIC cmd completion IRQ comes first, then power
status change IRQ comes next. In this case, an UIC cmd's lifecyle
ends only after the power status change IRQ comes [1].

I guess you may want to say that in current code since we have
masked UIC cmd completion IRQ in the case of a PMC operation, so
no need to check it here since we won't be here anyways before
power status change IRQ comes. So, removing the check here
definitely works, and then we won't even need below line as well.

	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
+		hba->active_uic_cmd->cmd_active = 0;
		complete(hba->uic_async_done);
		retval = IRQ_HANDLED;

If my guess is right, my opinion is that the current change may
be more readable and comprehensive as it strictly follows my
description in [1]. What do you think?

Thanks,

Can Guo.

>> +			hba->active_uic_cmd->cmd_active = 0;
>>  		complete(&hba->active_uic_cmd->done);
>>  		retval = IRQ_HANDLED;
>>  	}
>> 
>>  	if ((intr_status & UFSHCD_UIC_PWR_MASK) && hba->uic_async_done) {
>> +		hba->active_uic_cmd->cmd_active = 0;
>>  		complete(hba->uic_async_done);
>>  		retval = IRQ_HANDLED;
>>  	}
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 66e5338..be982ed 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -64,6 +64,7 @@ enum dev_cmd_type {
>>   * @argument1: UIC command argument 1
>>   * @argument2: UIC command argument 2
>>   * @argument3: UIC command argument 3
>> + * @cmd_active: Indicate if UIC command is outstanding
>>   * @done: UIC command completion
>>   */
>>  struct uic_command {
>> @@ -71,6 +72,7 @@ struct uic_command {
>>  	u32 argument1;
>>  	u32 argument2;
>>  	u32 argument3;
>> +	int cmd_active;
>>  	struct completion done;
>>  };
>> 
> 
> 
> 
> Thanks,
> Stanley Chu
