Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CFDC43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 22:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 521D7205C9
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 22:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="jNbdJKZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfLNWYs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 17:24:48 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:25204 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbfLNWYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Dec 2019 17:24:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576362287; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Y5yEn+ClqcrfpLwbDUFf91viLP/3PPAwp482cettCXw=;
 b=jNbdJKZLT0+Jfb39yiaymi4LPnzQnoaM43NxZ8oHlzJGvvMqBp6U1KwNvyVLjuHOzSlcXWGI
 XNskQNjPn5tdyVIwsMqYeFQzr9TcJListaSvpQXbEibnCAHwDEjiB3GXGvaBIGeOkSqvS/+o
 DOP55DwDWPbctgTP8DHks9Zpvms=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df5612e.7fee1ed14030-smtp-out-n01;
 Sat, 14 Dec 2019 22:24:46 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 86026C4479C; Sat, 14 Dec 2019 22:24:44 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4572BC43383;
        Sat, 14 Dec 2019 22:24:43 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 15 Dec 2019 06:24:43 +0800
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
In-Reply-To: <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
Message-ID: <5aa3a266e3db3403e663b36ddfdc4d60@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-15 02:32, Bart Van Assche wrote:
> On 12/14/19 8:03 AM, Can Guo wrote:
>> In ufshcd_remove(), after SCSI host is removed, put it once so that 
>> its
>> resources can be released.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b5966fa..a86b0fd 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>>   	ufs_bsg_remove(hba);
>>   	ufs_sysfs_remove_nodes(hba->dev);
>>   	scsi_remove_host(hba->host);
>> +	scsi_host_put(hba->host);
>>   	/* disable interrupts */
>>   	ufshcd_disable_intr(hba, hba->intr_mask);
>>   	ufshcd_hba_stop(hba, true);
> 
> Hi Can,
> 
> The UFS driver may queue work asynchronously and that asynchronous
> work may refer to the SCSI host, e.g. ufshcd_err_handler(). Is it
> guaranteed that all that asynchronous work has finished before
> scsi_host_put() is called?
> 
> Thanks,
> 
> Bart.

Hi Bart,

Thanks for pointing it out. I noticed that you are changing this
path too in below 2 changes.
https://marc.info/?l=linux-scsi&m=157591520015924&w=2
https://marc.info/?l=linux-scsi&m=157591519915923&w=2

Actually the async works you pointed may also affect your change,
because you may tear down the hba->cmd_queue too early, as there can be
devm commands sent by clock gating, eeh_work and eh_work after that 
point,
meaning when blk_get_request is called in exec_dev_cmd(), hba->cmd_queue
may have been released already.

@@ -8263,6 +8232,7 @@ void ufshcd_remove(struct ufs_hba *hba)
  {
      ufs_bsg_remove(hba);
      ufs_sysfs_remove_nodes(hba->dev);
+    blk_cleanup_queue(hba->cmd_queue);
      scsi_remove_host(hba->host);
      /* disable interrupts */
      ufshcd_disable_intr(hba, hba->intr_mask);

How do you think if I replace my patch with below one?
In this way, you can also move blk_cleanup_queue() behind
cancel_work_sync(eh_work).

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b5966fa..bd4ae75 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8251,15 +8251,17 @@ void ufshcd_remove(struct ufs_hba *hba)
         ufs_bsg_remove(hba);
         ufs_sysfs_remove_nodes(hba->dev);
         scsi_remove_host(hba->host);
-       /* disable interrupts */
-       ufshcd_disable_intr(hba, hba->intr_mask);
-       ufshcd_hba_stop(hba, true);
-
         ufshcd_exit_clk_scaling(hba);
         ufshcd_exit_clk_gating(hba);
         if (ufshcd_is_clkscaling_supported(hba))
                 device_remove_file(hba->dev, 
&hba->clk_scaling.enable_attr);
+       cancel_work_sync(&hba->eeh_work);
+       cancel_work_sync(&hba->eh_work);
+       /* disable interrupts */
+       ufshcd_disable_intr(hba, hba->intr_mask);
+       ufshcd_hba_stop(hba, true);
         ufshcd_hba_exit(hba);
+       ufshcd_dealloc_host(hba);
  }
  EXPORT_SYMBOL_GPL(ufshcd_remove);

-- 

Thanks,

Can Guo.
