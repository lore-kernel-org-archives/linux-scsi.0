Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5D5C33C9E
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 06:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3B7720658
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 06:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="crvGvA8p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgBCGXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 01:23:21 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:36045 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727133AbgBCGXV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 01:23:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580711000; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=B884mIi1FderXMyOjaDduMnL5Xg3XoTXVNT7DKdrpYA=;
 b=crvGvA8p2Y/UmTWq7Evw8xcxk9oNfS9M255GTERB7VqLarf6BN15vYUTk/vdM2c6ah0sBPBH
 COIvLRiDCwuxYjs+DtER99a7fvuNIBoNMc2hOeqLmwy5sebkeXpFupmsiUqXuVr3kDotMSe1
 JSbcf84orUPkB52Yahsu+1iPTDE=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e37bc56.7effc1b02928-smtp-out-n02;
 Mon, 03 Feb 2020 06:23:18 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8BC7BC447A9; Mon,  3 Feb 2020 06:23:16 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92D0CC433CB;
        Mon,  3 Feb 2020 06:23:15 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 03 Feb 2020 14:23:15 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Sayali Lokhande <sayalil@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/8] scsi: ufs: Flush exception event before suspend
In-Reply-To: <525e4f67-f471-54a6-aaea-b3772a550af1@acm.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-2-git-send-email-cang@codeaurora.org>
 <525e4f67-f471-54a6-aaea-b3772a550af1@acm.org>
Message-ID: <82723efc44714e8677505cb7999d3fd5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-26 11:29, Bart Van Assche wrote:
> On 2020-01-22 23:25, Can Guo wrote:
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 1201578..c2de29f 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -4760,8 +4760,15 @@ static void ufshcd_slave_destroy(struct 
>> scsi_device *sdev)
>>  			 * UFS device needs urgent BKOPs.
>>  			 */
>>  			if (!hba->pm_op_in_progress &&
>> -			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
>> -				schedule_work(&hba->eeh_work);
>> +			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr)) {
>> +				/*
>> +				 * Prevent suspend once eeh_work is scheduled
>> +				 * to avoid deadlock between ufshcd_suspend
>> +				 * and exception event handler.
>> +				 */
>> +				if (schedule_work(&hba->eeh_work))
>> +					pm_runtime_get_noresume(hba->dev);
>> +			}
> 
> Please combine the two logical tests with "&&" instead of nesting two
> if-statements inside each other.
> 
>>  			break;
>>  		case UPIU_TRANSACTION_REJECT_UPIU:
>>  			/* TODO: handle Reject UPIU Response */
>> @@ -5215,7 +5222,14 @@ static void 
>> ufshcd_exception_event_handler(struct work_struct *work)
>> 
>>  out:
>>  	scsi_unblock_requests(hba->host);
>> -	pm_runtime_put_sync(hba->dev);
>> +	/*
>> +	 * pm_runtime_get_noresume is called while scheduling
>> +	 * eeh_work to avoid suspend racing with exception work.
>> +	 * Hence decrement usage counter using pm_runtime_put_noidle
>> +	 * to allow suspend on completion of exception event handler.
>> +	 */
>> +	pm_runtime_put_noidle(hba->dev);
>> +	pm_runtime_put(hba->dev);
>>  	return;
>>  }
>> 
>> @@ -7901,6 +7915,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  			goto enable_gating;
>>  	}
>> 
>> +	flush_work(&hba->eeh_work);
>>  	ret = ufshcd_link_state_transition(hba, req_link_state, 1);
>>  	if (ret)
>>  		goto set_dev_active;
> 
> I think this patch introduces a new race condition, namely the 
> following:
> - ufshcd_slave_destroy() tests pm_op_in_progress and reads the value
>   zero from that variable.
> - ufshcd_suspend() sets hba->pm_op_in_progress to one.
> - ufshcd_slave_destroy() calls schedule_work().
> 
> How about fixing this race condition by calling
> pm_runtime_get_noresume() before checking pm_op_in_progress and by
> reallowing resume if no work is scheduled?
> 
> Thanks,
> 
> Bart.

Hi Bart,

If you apply this patch, you will find the change is not in
ufshcd_slave_destroy(), but in ufshcd_transfer_rsp_status().
So the racing you mentioned above does not exist.

Thanks,

Can Guo.
