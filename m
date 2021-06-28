Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0B2C2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 07:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF5F5613EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 07:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhF1HO1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 03:14:27 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:63559 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhF1HOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 03:14:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624864320; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=9HKLPt6UmZAYVg6hKZ4VhL+vXXYRIrBvxsOr/NJnZ2g=;
 b=PYX7Opwi7NtL5oXmyl2rrDe/nWWKJ009KMYEPbGGpppBMZ5sZr7EZdZCQxrnIyGozoyA7dlA
 BOC0ZQs9NA+OVUzIq9dVC3X5fO6XMM7oN/h8dvwpvJdaxR9sWAJLlS4ZoOPtQX6+R65MXoqT
 Jht7NROHwpCMJdesAS0kJuZOz9k=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60d97633d2559fe3925f0a1b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Jun 2021 07:11:47
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7242AC43146; Mon, 28 Jun 2021 07:11:46 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8AD33C433D3;
        Mon, 28 Jun 2021 07:11:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Jun 2021 15:11:45 +0800
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Satya Tangirala <satyat@google.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/10] scsi: ufs: Add flags pm_op_in_progress and
 is_sys_suspended
In-Reply-To: <77b92c6e-2e1c-c799-f6ac-04467175f96a@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-3-git-send-email-cang@codeaurora.org>
 <77b92c6e-2e1c-c799-f6ac-04467175f96a@acm.org>
Message-ID: <aa01ddf1b91cb06a989bb47e001134ce@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-25 01:35, Bart Van Assche wrote:
> On 6/23/21 12:35 AM, Can Guo wrote:
>> @@ -9141,6 +9143,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>> 
>>  	if (!hba->is_powered)
>>  		return 0;
>> +
>> +	hba->pm_op_in_progress = true;
>>  	/*
>>  	 * Disable the host irq as host controller as there won't be any
>>  	 * host controller transaction expected till resume.
>> @@ -9160,6 +9164,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>>  	ufshcd_vreg_set_lpm(hba);
>>  	/* Put the host controller in low power mode if possible */
>>  	ufshcd_hba_vreg_set_lpm(hba);
>> +	hba->pm_op_in_progress = false;
>>  	return ret;
>>  }
>> 
>> @@ -9179,6 +9184,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>>  	if (!hba->is_powered)
>>  		return 0;
>> 
>> +	hba->pm_op_in_progress = true;
>>  	ufshcd_hba_vreg_set_hpm(hba);
>>  	ret = ufshcd_vreg_set_hpm(hba);
>>  	if (ret)
>> @@ -9198,6 +9204,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>>  out:
>>  	if (ret)
>>  		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
>> +	hba->pm_op_in_progress = false;
>>  	return ret;
>>  }
> 
> Has it been considered to check dev->power.runtime_status instead of
> introducing the pm_op_in_progress variable?

ufshcd_resume() is also used by system resume, while runtime_status only
tells about runtime resume. So does ufshcd_suspend().

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
