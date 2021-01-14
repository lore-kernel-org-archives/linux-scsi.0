Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FA7C43332
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 01:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F402343E
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 01:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbhANBoX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:44:23 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:26711 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbhANBTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 20:19:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610587132; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=kslj8Wj8U87VV6ybtvsgQSgYNIBVEXh0ztirzXBMiJ0=;
 b=jQn9ZBvT5v57TrMgjFxJDhglSZbDcPEfRPR/rNUu9nM0l1oz5EDNbG+PO+vHWETGlZsE3PFc
 1pa1oS0erE1DMwJbhm+E1FS08HgV90dZxBPO1HygEwrDrs0xa9Ypg8wD8/fNdnOl/6l6daWo
 rh9mooEpFTwjYx+OXNIwetfOfWM=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fff94c9c88af061078450de (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 00:48:09
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 01AD9C43467; Thu, 14 Jan 2021 00:48:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3C32BC433C6;
        Thu, 14 Jan 2021 00:48:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Jan 2021 08:48:06 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v4 2/2] scsi: ufs: Protect PM ops and err_handler from
 user access through sysfs
In-Reply-To: <b32a2064-4ff9-509c-cdaf-434264837917@intel.com>
References: <1610546230-14732-1-git-send-email-cang@codeaurora.org>
 <1610546230-14732-3-git-send-email-cang@codeaurora.org>
 <b32a2064-4ff9-509c-cdaf-434264837917@intel.com>
Message-ID: <6908e7103529d12fd6ca0e5fa696b4bc@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-13 22:53, Adrian Hunter wrote:
> On 13/01/21 3:57 pm, Can Guo wrote:
>> User layer may access sysfs nodes when system PM ops or error handling
>> is running, which can cause various problems. Rename eh_sem to 
>> host_sem
>> and use it to protect PM ops and error handling from user layer 
>> intervene.
>> 
>> Acked-by: Avri Altman <avri.altman@wdc.com>
>> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs-sysfs.c | 106 
>> ++++++++++++++++++++++++++++++++++++-------
>>  drivers/scsi/ufs/ufshcd.c    |  42 ++++++++++-------
>>  drivers/scsi/ufs/ufshcd.h    |  10 +++-
>>  3 files changed, 125 insertions(+), 33 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
>> b/drivers/scsi/ufs/ufs-sysfs.c
>> index 0e14384..7cafffc 100644
>> --- a/drivers/scsi/ufs/ufs-sysfs.c
>> +++ b/drivers/scsi/ufs/ufs-sysfs.c
>> @@ -154,18 +154,29 @@ static ssize_t auto_hibern8_show(struct device 
>> *dev,
>>  				 struct device_attribute *attr, char *buf)
>>  {
>>  	u32 ahit;
>> +	int ret;
>>  	struct ufs_hba *hba = dev_get_drvdata(dev);
>> 
>>  	if (!ufshcd_is_auto_hibern8_supported(hba))
>>  		return -EOPNOTSUPP;
>> 
>> +	down(&hba->host_sem);
>> +	if (!ufshcd_is_sysfs_allowed(hba)) {
> 
> I expect debugfs has the same potential problem, so maybe
> ufshcd_is_sysfs_allowed() is not quite the right name.

I noticed your debugfs change - currently it is only printing
error counts recorded in hba struct, which is fine.
Even in this patch, the check is only added for those entries
which need to talk with HW. Sysfs nodes like show/store rpm/spm_lvl
does not need this check.

Thanks,
Can Guo.

> 
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +
