Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8D8C4646E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE2764EF0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447036AbhCCMrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:32 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:13118 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1449380AbhCCKU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Mar 2021 05:20:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614766808; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=NgawUiqwXp+6LkGutn5iBvxqzt510G1PCZ3d25uDEa4=;
 b=Yl2o+oO3yd1GLxmMloKbhyYbcEi85wezsPV6e71pkEcqqx6EDGgNeJlHX4dxPv0r4KY6z4Ze
 FeV+TkaJ99HiFSxsDXQW5TT7fDBjGwwrfAVawDtIWzPZmYvT7/u+7y075u2aDmKPtCrLEUtG
 TIhZ8dbM5SKrWifkhHSyPuJsnh0=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 603f62a639ef3721149d633b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 10:19:18
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 88C67C43463; Wed,  3 Mar 2021 10:19:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2974C433C6;
        Wed,  3 Mar 2021 10:19:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Mar 2021 18:19:17 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <huobean@gmail.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
In-Reply-To: <5fe97f16-406c-c279-b108-d27bb2769ed6@intel.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
 <DM6PR04MB65753E738C556F035A56F77CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
 <5fe97f16-406c-c279-b108-d27bb2769ed6@intel.com>
Message-ID: <80301bea84b7349ca9dbdcc4f2c9a744@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-02 16:14, Adrian Hunter wrote:
> On 2/03/21 9:01 am, Avri Altman wrote:
>> 
>>> If ufshcd_probe_hba() fails it sets ufshcd_state to 
>>> UFSHCD_STATE_ERROR,
>>> however, if it is called again, as it is within a loop in
>>> ufshcd_reset_and_restore(), and succeeds, then it will not set the 
>>> state
>>> back to UFSHCD_STATE_OPERATIONAL unless the state was
>>> UFSHCD_STATE_RESET.
>>> 
>>> That can result in the state being UFSHCD_STATE_ERROR even though
>>> ufshcd_reset_and_restore() is successful and returns zero.
>>> 
>>> Fix by initializing the state to UFSHCD_STATE_RESET in the start of 
>>> each
>>> loop in ufshcd_reset_and_restore().  If there is an error,
>>> ufshcd_reset_and_restore() will change the state to 
>>> UFSHCD_STATE_ERROR,
>>> otherwise ufshcd_probe_hba() will have set the state appropriately.
>>> 
>>> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and 
>>> other
>>> error recovery paths")
>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> I think that CanG recent series addressed that issue as well, can you 
>> take a look?
>> https://lore.kernel.org/lkml/1614145010-36079-2-git-send-email-cang@codeaurora.org/
> 
> Yes, there it is mixed in with other changes.  However it is probably 
> better
> as a separate patch.  Can Guo, what do you think?

Oh, I missed this one...
Sure, I will split it out as a seperate change in next version.

Thanks,
Can Guo.

> 
>> 
>> 
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>> 
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index 77161750c9fb..91a403afe038 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -7031,6 +7031,8 @@ static int ufshcd_reset_and_restore(struct 
>>> ufs_hba
>>> *hba)
>>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>>> 
>>>         do {
>>> +               hba->ufshcd_state = UFSHCD_STATE_RESET;
>>> +
>>>                 /* Reset the attached device */
>>>                 ufshcd_device_reset(hba);
>>> 
>>> --
>>> 2.17.1
>> 
