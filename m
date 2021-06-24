Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092E6C48BC2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA70D6137D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFXCKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 22:10:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12477 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhFXCKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 22:10:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624500474; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6atE1ASy+KdwLOEiHKmOOplUQomy6HEtQ2ed88jbMqY=;
 b=q3F3tz5eLEGvRDoFLMNgRCE/8NvS8NdzcZ9Y3oi9bvN9fLBHYCpBPvluftFWYiWtTNty/E7/
 5pfHa1jOtrvxvG/G90J6rYVWpWmiiybjNJoulfkCTM0G/Op34W4l2bl4zvlqUMNv7L0GfV5c
 0LV/Yu4x7lwcSfMaJeNYUwcLhik=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60d3e8f3638039e997e45ace (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 02:07:47
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D7335C43144; Thu, 24 Jun 2021 02:07:46 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0BE80C433F1;
        Thu, 24 Jun 2021 02:07:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Jun 2021 10:07:45 +0800
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
In-Reply-To: <e728719d-8e43-0e5a-af7a-14196dafa2a9@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-3-git-send-email-cang@codeaurora.org>
 <e728719d-8e43-0e5a-af7a-14196dafa2a9@acm.org>
Message-ID: <fba43980b0a50bd09e70eaa8a4fea49d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-24 04:59, Bart Van Assche wrote:
> On 6/23/21 12:35 AM, Can Guo wrote:
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 93aeeb3..1e7fe73 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -754,6 +754,8 @@ struct ufs_hba {
>>  	struct device_attribute spm_lvl_attr;
>>  	/* A flag to tell whether __ufshcd_wl_suspend/resume() is in 
>> progress */
>>  	bool wlu_pm_op_in_progress;
>> +	/* A flag to tell whether ufshcd_suspend/resume() is in progress */
>> +	bool pm_op_in_progress;
>> 
>>  	/* Auto-Hibernate Idle Timer register value */
>>  	u32 ahit;
>> @@ -841,6 +843,8 @@ struct ufs_hba {
>>  	struct ufs_clk_scaling clk_scaling;
>>  	/* A flag to tell whether the UFS device W-LU is system suspended */
>>  	bool is_wlu_sys_suspended;
>> +	/* A flag to tell whether hba is system suspended */
>> +	bool is_sys_suspended;
>> 
>>  	enum bkops_status urgent_bkops_lvl;
>>  	bool is_urgent_bkops_lvl_checked;
> 
> It is not yet clear to me whether we really need these new member
> variables. If these are retained, please rename pm_op_in_progress into
> platform_pm_op_in_progress and is_sys_suspended into
> platform_is_sys_suspended.

Hi Bart,

These flags are informative when we debug some UFS issues and they
are used by later changes. Sure, I will modify the namings.

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
