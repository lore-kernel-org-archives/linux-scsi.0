Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA9DC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 01:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FDF42176D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 01:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Ji7Zh+7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfLQBbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 20:31:18 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:62178 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfLQBbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 20:31:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576546278; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=rtNLx7+QI8vJ9iMXYE4MF2d+y/lbnqAVplnH0gmdM2o=;
 b=Ji7Zh+7IoSEUNJVK9nBRCbaUwAATh/ilTxR/gtrobrhrzd+ouMHp25tl3WpTqEaES+bmtOo8
 B2KA65+XZZ8TNSYm2iVN6+lJizYI5RogpU2mKUuTkggil3lAokDvZM55OayduBrrd1Sd4Xz9
 9BiCaszy/avo0lqBsvqBGOmm4dQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df82fde.7f2d8aa31110-smtp-out-n03;
 Tue, 17 Dec 2019 01:31:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B1969C447A5; Tue, 17 Dec 2019 01:31:09 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B284EC447A5;
        Tue, 17 Dec 2019 01:31:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 17 Dec 2019 09:31:08 +0800
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
In-Reply-To: <ecef25b7-44c0-6b94-c429-6ee5f9508caf@acm.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <cd6dc7c90d43b8ca8254a43da48334fc@codeaurora.org>
 <cf4915df-5ae4-0dfd-5d44-1fe959d141e2@acm.org>
 <0343644f49adee06e6b2f3f631fe1637@codeaurora.org>
 <ecef25b7-44c0-6b94-c429-6ee5f9508caf@acm.org>
Message-ID: <d9d18f050ec2d2c86943fa76f73719a1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-17 09:15, Bart Van Assche wrote:
> On 12/16/19 4:46 PM, cang@codeaurora.org wrote:
>> On 2019-12-17 01:39, Bart Van Assche wrote:
>>> Apparently some UFS drivers call ufshcd_remove() only and others
>>> (PCIe) call both ufshcd_remove() and ufshcd_dealloc_host(). I think
>>> that the above change will cause trouble for the PCIe driver unless
>>> the ufshcd_dealloc_host() call is removed from ufshcd_pci_remove().
>> 
>> You may get me wrong. I mean we should do like what ufshcd-pci.c does.
>> As driver probe routine allocates SCSI host, then driver remove() 
>> should
>> de-allocate it. Meaning ufs_qcom_remove() should call both 
>> ufshcd_remove()
>> and ufshcd_dealloc_host().
>> 
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 3d4582e..ea45756 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -3239,6 +3239,7 @@ static int ufs_qcom_remove(struct 
>> platform_device *pdev)
>> 
>>            pm_runtime_get_sync(&(pdev)->dev);
>>            ufshcd_remove(hba);
>>   +       ufshcd_dealloc_host(hba);
>>            return 0;
>>     }
> 
> Hi Can,
> 
> If it is possible to move the ufshcd_dealloc_host() into
> ufshcd_remove() then I would prefer to do that. If all UFS transport
> drivers need that call then I think that call should happen from the
> UFS core instead of from the transport drivers.
> 
> Thanks,
> 
> Bart.

Yeah, that is an once for all solution, but I not sure if PCI folks are
OK if I remove the ufshcd_dealloc_host() call from their driver.
In next version, I will try to make such change and see.

Thanks,
Can Guo.
