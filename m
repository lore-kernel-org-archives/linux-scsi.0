Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E60C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 00:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8984721D7D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 00:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lhqweLqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfLQAqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 19:46:06 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:47198 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727739AbfLQAqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 19:46:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576543565; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ykcUs/EViOpCxoK1Xh5e32ZUk+bAyurgZ958r4iU0Mc=;
 b=lhqweLqWnV+dHVJjaBUOJrpNoeg/oHfukWB+fYcKNsAGpBqm6OnR+fzM9Ke5L4Wa3imQAX8h
 0ek5yALw1gm/rbIILwHNHhAWxqAKChCQ/dLFmaERn3PPeyHp124P0KYNRDFdjxrUkDGEZyLv
 58RTu6MpM2KKNzyvVquHLDNPTCM=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df8254a.7f94a45f1dc0-smtp-out-n01;
 Tue, 17 Dec 2019 00:46:02 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D8FC0C447AC; Tue, 17 Dec 2019 00:46:01 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21BFBC433CB;
        Tue, 17 Dec 2019 00:46:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 17 Dec 2019 08:46:00 +0800
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
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
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
In-Reply-To: <cf4915df-5ae4-0dfd-5d44-1fe959d141e2@acm.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <cd6dc7c90d43b8ca8254a43da48334fc@codeaurora.org>
 <cf4915df-5ae4-0dfd-5d44-1fe959d141e2@acm.org>
Message-ID: <0343644f49adee06e6b2f3f631fe1637@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-17 01:39, Bart Van Assche wrote:
> On 12/16/19 6:31 AM, cang@codeaurora.org wrote:
>> As SCSI host is allocated in ufshcd_platform_init() during platform
>> drive probe, it is much more appropriate if platform driver calls
>> ufshcd_dealloc_host() in their own drv->remove() path. How do you
>> think if I change it as below? If it is OK to you, please ignore my
>> previous mails.
>> 
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 3d4582e..ea45756 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -3239,6 +3239,7 @@ static int ufs_qcom_remove(struct 
>> platform_device *pdev)
>> 
>>          pm_runtime_get_sync(&(pdev)->dev);
>>          ufshcd_remove(hba);
>> +       ufshcd_dealloc_host(hba);
>>          return 0;
>>   }
> 
> Hi Can,
> 
> Apparently some UFS drivers call ufshcd_remove() only and others
> (PCIe) call both ufshcd_remove() and ufshcd_dealloc_host(). I think
> that the above change will cause trouble for the PCIe driver unless
> the ufshcd_dealloc_host() call is removed from ufshcd_pci_remove().
> 
> Thanks,
> 
> Bart.

Hi Bart,

You may get me wrong. I mean we should do like what ufshcd-pci.c does.
As driver probe routine allocates SCSI host, then driver remove() should
de-allocate it. Meaning ufs_qcom_remove() should call both 
ufshcd_remove()
and ufshcd_dealloc_host().

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3d4582e..ea45756 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -3239,6 +3239,7 @@ static int ufs_qcom_remove(struct platform_device 
*pdev)

           pm_runtime_get_sync(&(pdev)->dev);
           ufshcd_remove(hba);
  +       ufshcd_dealloc_host(hba);
           return 0;
    }

Thanks,

Can Guo.
