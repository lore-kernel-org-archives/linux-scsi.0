Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B586C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 06:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA2420857
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 06:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="leuk/gZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgKXGP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 01:15:28 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:34212 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbgKXGP2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 01:15:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606198527; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=O64Bagg91WpXTQ6GYKfVVL/aHTO8730H8ll60EFv4Q0=;
 b=leuk/gZTKizDNBBtWZeiGhuae/J668Swqs/90uxl71gino1hXDUcgooFoO4ORxX3SMfMGY9Y
 B2qppXP6AiEISFtuYFP2hFJlHhhrs6D8X5o316+BJwg4SqoJHDRmclsjC4SJwz+CHaProgQC
 +2SEcMO7N9TPPm7Kp6rIpxjkIcU=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fbca4f6fa67d9becf74d05e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 06:15:18
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 10655C43460; Tue, 24 Nov 2020 06:15:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 112CDC433ED;
        Tue, 24 Nov 2020 06:15:16 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Nov 2020 14:15:15 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        kuohong.wang@mediatek.com
Subject: Re: [PATCH] scsi: ufs: Don't disable core_clk_unipro if the link is
 active
In-Reply-To: <1606195221.17338.6.camel@mtkswgap22>
References: <1606194312-25378-1-git-send-email-cang@codeaurora.org>
 <1606195221.17338.6.camel@mtkswgap22>
Message-ID: <20ae750e562d80f964045c7c44bd94d6@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-11-24 13:20, Stanley Chu wrote:
> Hi Can,
> 
> On Mon, 2020-11-23 at 21:05 -0800, Can Guo wrote:
>> If we want to disable clocks but still keep the link active, both 
>> ref_clk
>> and core_clk_unipro should be skipped.
>> 
> 
> "core_clk_unipro" seems used by ufs-qcom only and not defined in the 
> UFS
> platform binding document: ufshcd_pltfrm.txt.

Agree.

> 
> Could you please add the definition first and then it would be
> reasonable to be used in common driver?
> 
> Or, how about add a flag in struct ufs_clk_info indicating if this 
> clock
> needs be ON to keep the link active? The flag could be set properly by
> vendor initialization functions. In this way, we can also remove the
> hard-coded "ref_clk" in __ufshcd_setup_clocks().

This seems better, I will upload next version to incorporate the idea
after it is tested.

Thanks,

Can Guo.

> 
> Thanks.
> Stanley Chu
> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index a7857f6..69c2e91 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -222,7 +222,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba 
>> *hba, int tag);
>>  static void ufshcd_hba_exit(struct ufs_hba *hba);
>>  static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
>>  static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>> -				 bool skip_ref_clk);
>> +				 bool keep_link_active);
>>  static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
>>  static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
>>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba 
>> *hba);
>> @@ -1710,7 +1710,6 @@ static void ufshcd_gate_work(struct work_struct 
>> *work)
>>  	if (!ufshcd_is_link_active(hba))
>>  		ufshcd_setup_clocks(hba, false);
>>  	else
>> -		/* If link is active, device ref_clk can't be switched off */
>>  		__ufshcd_setup_clocks(hba, false, true);
>> 
>>  	/*
>> @@ -7991,7 +7990,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba 
>> *hba)
>>  }
>> 
>>  static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>> -					bool skip_ref_clk)
>> +					bool keep_link_active)
>>  {
>>  	int ret = 0;
>>  	struct ufs_clk_info *clki;
>> @@ -8009,7 +8008,13 @@ static int __ufshcd_setup_clocks(struct ufs_hba 
>> *hba, bool on,
>> 
>>  	list_for_each_entry(clki, head, list) {
>>  		if (!IS_ERR_OR_NULL(clki->clk)) {
>> -			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
>> +			/*
>> +			 * To keep link active, ref_clk and core_clk_unipro
>> +			 * should be kept ON.
>> +			 */
>> +			if (keep_link_active &&
>> +			    (!strcmp(clki->name, "ref_clk") ||
>> +			     !strcmp(clki->name, "core_clk_unipro")))
>>  				continue;
>> 
>>  			clk_state_changed = on ^ clki->enabled;
>> @@ -8580,7 +8585,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, 
>> enum ufs_pm_op pm_op)
>>  	if (!ufshcd_is_link_active(hba))
>>  		ufshcd_setup_clocks(hba, false);
>>  	else
>> -		/* If link is active, device ref_clk can't be switched off */
>>  		__ufshcd_setup_clocks(hba, false, true);
>> 
>>  	if (ufshcd_is_clkgating_allowed(hba)) {
