Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1A0C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 01:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE795206D8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 01:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="NXzdexAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLPBeh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 20:34:37 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:52728 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbfLPBeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Dec 2019 20:34:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576460076; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=hXp5Pym+ifAP29LPG9ZfYu5ZCPAzDqcCF4V7G9r94xg=;
 b=NXzdexADBBhPkHJFiCO9jLVKL+/2lXx6g+RSX7OMfX7kUDSlIb3da3DxzHUo+1KQKMPBac5X
 NfKjzer3rQV03xr0xFHhF6gH8HAwvl8D/bkki9rnpDfH4Sl9JNli8aMT8pDtMMfifnU+Rwqw
 1ejZrT2Qu9vDWqCuIzlMIGDsung=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df6df26.7fe751a7c650-smtp-out-n01;
 Mon, 16 Dec 2019 01:34:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A5C21C447A9; Mon, 16 Dec 2019 01:34:28 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 979EFC43383;
        Mon, 16 Dec 2019 01:34:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 16 Dec 2019 09:34:27 +0800
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
In-Reply-To: <2956b9c7-b019-e2b3-7a1b-7b796b724add@acm.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <5aa3a266e3db3403e663b36ddfdc4d60@codeaurora.org>
 <2956b9c7-b019-e2b3-7a1b-7b796b724add@acm.org>
Message-ID: <3afbe71cc9f0626edf66f7bc13b331f4@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-16 05:55, Bart Van Assche wrote:
> On 2019-12-14 14:24, cang@codeaurora.org wrote:
>> How do you think if I replace my patch with below one?
>> In this way, you can also move blk_cleanup_queue() behind
>> cancel_work_sync(eh_work).
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b5966fa..bd4ae75 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8251,15 +8251,17 @@ void ufshcd_remove(struct ufs_hba *hba)
>>         ufs_bsg_remove(hba);
>>         ufs_sysfs_remove_nodes(hba->dev);
>>         scsi_remove_host(hba->host);
>> -       /* disable interrupts */
>> -       ufshcd_disable_intr(hba, hba->intr_mask);
>> -       ufshcd_hba_stop(hba, true);
>> -
>>         ufshcd_exit_clk_scaling(hba);
>>         ufshcd_exit_clk_gating(hba);
>>         if (ufshcd_is_clkscaling_supported(hba))
>>                 device_remove_file(hba->dev,
>> &hba->clk_scaling.enable_attr);
>> +       cancel_work_sync(&hba->eeh_work);
>> +       cancel_work_sync(&hba->eh_work);
>> +       /* disable interrupts */
>> +       ufshcd_disable_intr(hba, hba->intr_mask);
>> +       ufshcd_hba_stop(hba, true);
>>         ufshcd_hba_exit(hba);
>> +       ufshcd_dealloc_host(hba);
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_remove);
> 
> Hi Can,
> 
> To which kernel tree does the above patch apply? I'm asking this 
> because
> I don't see the recently added blk_cleanup_queue() calls in the above
> patch. Please start from Martin's latest scsi-queue branch when
> preparing SCSI patches.
> 
> Additionally, is it on purpose that there is no scsi_host_put() call in
> the above code? I'd like to keep that call because without that call a
> memory leak will occur when unloading the ufshcd-core kernel driver.
> 
> Thanks,
> 
> Bart.


Hi Bart,

This is applied to 5.5/scsi-queue. The two changes I patsed from you are
not merged yet, I am still doing code review to them, so there is no
blk_cleanup_queue() calls in my code base. I am just saying you may move
your blk_cleanup_queue() calls below cancel_work_sync(&hba->eh_work) if
my change applies. How do you think?

scsi_host_put() was there before but explicitly removed by
afa3dfd42d205b106787476647735aa1de1a5d02. I agree with you, without this
change, there is memory leak.

Thanks,

Can Guo.
