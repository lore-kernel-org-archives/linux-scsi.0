Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE041C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 09:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 586CF64E06
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 09:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhBAJDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 04:03:44 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:56184 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232593AbhBAJDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 04:03:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612170209; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ToLwJRD4UxZjNpGfb3cboR+GWoPA2k1KGynQOg7+1Xg=;
 b=RoE/fNvJbLxvI+vHEpd0vE7UPG5CaGzWwTpGTiAd23VDUdMdURPwkYS4KFGTz0+JFeBZgTjy
 Hw05BQ4lEB5k7S1ED7GvMXFMGKkd8pcp5ps7BjreC8RSir+D9NQm6Ouj7l4bt0dSm9VubY/U
 ZadrK18bF/YGx0q8l2OWhj5rIO4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6017c3a3ab96aecb9f83a663 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Feb 2021 09:02:27
 GMT
Sender: nitirawa=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 91DC9C43461; Mon,  1 Feb 2021 09:02:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nitirawa)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF2F2C433C6;
        Mon,  1 Feb 2021 09:02:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 14:32:26 +0530
From:   nitirawa@codeaurora.org
To:     Bean Huo <huobean@gmail.com>
Cc:     cang@codeaurora.org, asutoshd@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitirawa@codeaurora.org
Subject: Re: [PATCH V2] scsi: ufs: Add UFS3.0 in ufs HCI version check
In-Reply-To: <63f00f514f1e912b8fb1d0c183e9167b60b3a5dc.camel@gmail.com>
References: <1611058021-18611-1-git-send-email-nitirawa@codeaurora.org>
 <63f00f514f1e912b8fb1d0c183e9167b60b3a5dc.camel@gmail.com>
Message-ID: <d1b23943b6b3ae6c1f6af041cc592932@codeaurora.org>
X-Sender: nitirawa@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-30 00:55, Bean Huo wrote:
> On Tue, 2021-01-19 at 17:37 +0530, Nitin Rawat wrote:
>> As per JESD223D UFS HCI v3.0 spec, HCI version 3.0
>> is also supported. Hence Adding UFS3.0 in UFS HCI
>> version check to avoid logging of the error message.
>> 
>> Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 5 +++--
>>  drivers/scsi/ufs/ufshci.h | 1 +
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 82ad317..54ca765 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -9255,8 +9255,9 @@ int ufshcd_init(struct ufs_hba *hba, void
>> __iomem *mmio_base, unsigned int irq)
>>         if ((hba->ufs_version != UFSHCI_VERSION_10) &&
>>             (hba->ufs_version != UFSHCI_VERSION_11) &&
>>             (hba->ufs_version != UFSHCI_VERSION_20) &&
>> -           (hba->ufs_version != UFSHCI_VERSION_21))
>> -               dev_err(hba->dev, "invalid UFS version 0x%x\n",
>> +           (hba->ufs_version != UFSHCI_VERSION_21) &&
>> +           (hba->ufs_version != UFSHCI_VERSION_30))
>> +               dev_err(hba->dev, "invalid UFS HCI version 0x%x\n",
>>                         hba->ufs_version);
> 
> Hi Nitin
> Except HCI 1.0 / 1.1 / 2.0 / 2.1 / 3.0, do you have the other UFS HCI
> version? if no, current driver supports all of them,  instead of
> scaling these check, and avoid logging of the error message, I suggest
> you can directly delete these redundant checkup.
> 
> If there is a weird HCI version that not supported by the current
> driver, you can only add an unsupported checkup list. thus, you don't
> need to scale this useless checkup.
> 
> Bean

Hi Bean,
That's a good suggestion. If nobody has any concern, i will
post new patchset by removing these redundant check.

Regards,
Nitin
