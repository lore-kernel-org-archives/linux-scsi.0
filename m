Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC18C34031
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 06:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B5124656
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 06:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="aSdz011n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgBTGeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 01:34:50 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:63074 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbgBTGeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 01:34:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582180490; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=sVo+Sl7faQqaCYyB29lBwLjWrgSdpJiLU0kKGcEC8no=;
 b=aSdz011n+VIO3gKoUSbVh5XrhuQ7VVc/spT2AkyDWGkMs1CXz0r+ELAoGCEAphJZlW93dmBx
 lr6wGjUrnoktufVZjDc+RLJ90ml9Xyhk0CCWX/RfwFWuel/H26iaCivoCciTe5t7gU4vHri+
 P6R72Dmn6umssj+fO6kTNJ8g4ls=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4e2880.7f1eea9446c0-smtp-out-n03;
 Thu, 20 Feb 2020 06:34:40 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 533B5C447AA; Thu, 20 Feb 2020 06:34:40 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A991C4479C;
        Thu, 20 Feb 2020 06:34:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Feb 2020 14:34:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Enable HOST_PA_TACTIVATE quirk for WDC UFS
 devices
In-Reply-To: <MN2PR04MB6991569990279CA1985BE92DFC130@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580977315-19321-1-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991569990279CA1985BE92DFC130@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <382c4c44e04c48ddc1682b3d3b0c6256@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-20 14:20, Avri Altman wrote:
> Hi,
> 
>> 
>>  /**
>>   * ufs_dev_fix - ufs device quirk info
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 1fe0a97..a066f00 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -239,6 +239,8 @@ struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
>>                 UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
>>         UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
>>                 UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
>> +       UFS_FIX(UFS_VENDOR_WDC, UFS_ANY_MODEL,
>> +               UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
> We are objecting to apply this quirk categorically for all SOC vendors.
> Please use a vendor-specific quirk for that.
> 
> Thanks,
> Avri

Yeah, as we discussed, I will apply it in ufshcd_vops_apply_dev_quirks()
in next version and this is agreed by Stanley as well.
