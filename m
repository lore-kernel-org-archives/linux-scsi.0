Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE9CC433EB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 02:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97B5F207E8
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 02:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ojCUZSmV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387786AbgGWCNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 22:13:20 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:36329 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387782AbgGWCNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jul 2020 22:13:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595470398; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=nTRfo1ty9FlsrxHz1tE6ngv0WrQA65vGKJXoS9tETQM=;
 b=ojCUZSmVFbIm7scgOz0VPQntruCTvvuj5ST6yBWPNjUTx6nM/ySJDPGaWVF4MdaZPmry/3kO
 kpZQy0udHQO5927+1oJ+ISvit4bEpTefS+kyxU/V0OSFdXlGUAYMfp8tryZnWHxBAj+cBF7E
 94O0t99e9L1zIscX69DfkSNFrp8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f18f23b65270fa595d3e392 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 23 Jul 2020 02:13:15
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 60F9EC433A1; Thu, 23 Jul 2020 02:13:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9892AC433C9;
        Thu, 23 Jul 2020 02:13:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jul 2020 10:13:12 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     Asutosh Das <asutoshd@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com,
        Mark Salyzyn <salyzyn@google.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/8] ufs: ufs-qcom: Fix a few BUGs in func
 ufs_qcom_dump_dbg_regs()
In-Reply-To: <CAOCk7NpLLV8yoWsrFKJ+OirGcQjeP4NmFYnMfXj-9=sMt7E94Q@mail.gmail.com>
References: <1595226956-7779-1-git-send-email-cang@codeaurora.org>
 <1595226956-7779-4-git-send-email-cang@codeaurora.org>
 <CAOCk7NpLLV8yoWsrFKJ+OirGcQjeP4NmFYnMfXj-9=sMt7E94Q@mail.gmail.com>
Message-ID: <a1d28140bc0c5f497462622b07833005@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-22 22:37, Jeffrey Hugo wrote:
> On Mon, Jul 20, 2020 at 12:39 AM Can Guo <cang@codeaurora.org> wrote:
>> 
>> Dumping testbus registers needs to sleep a bit intermittently as there 
>> are
>> too many of them. Skip them for those contexts where sleep is not 
>> allowed.
>> 
>> Meanwhile, if ufs_qcom_dump_dbg_regs() calls ufs_qcom_testbus_config() 
>> from
>> ufshcd_suspend/resume and/or clk gate/ungate context, 
>> pm_runtime_get_sync()
>> and ufshcd_hold() will cause racing problems. Fix it by removing the
>> unnecessary calls of pm_runtime_get_sync() and ufshcd_hold().
> 
> It sounds like this is two different changes which are clubbed
> together into the same patch and really should be two different
> patches.
> 

Will split them and give commit msgs accordingly in next version.

>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs-qcom.c | 17 +++++++----------
>>  1 file changed, 7 insertions(+), 10 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 2e6ddb5..3743c17 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -1604,9 +1604,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host 
>> *host)
>>          */
>>         }
>>         mask <<= offset;
>> -
>> -       pm_runtime_get_sync(host->hba->dev);
>> -       ufshcd_hold(host->hba, false);
>>         ufshcd_rmwl(host->hba, TEST_BUS_SEL,
>>                     (u32)host->testbus.select_major << 19,
>>                     REG_UFS_CFG1);
>> @@ -1619,8 +1616,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host 
>> *host)
>>          * committed before returning.
>>          */
>>         mb();
>> -       ufshcd_release(host->hba);
>> -       pm_runtime_put_sync(host->hba->dev);
>> 
>>         return 0;
>>  }
>> @@ -1658,11 +1653,13 @@ static void ufs_qcom_dump_dbg_regs(struct 
>> ufs_hba *hba)
>> 
>>         /* sleep a bit intermittently as we are dumping too much data 
>> */
>>         ufs_qcom_print_hw_debug_reg_all(hba, NULL, 
>> ufs_qcom_dump_regs_wrapper);
>> -       udelay(1000);
>> -       ufs_qcom_testbus_read(hba);
>> -       udelay(1000);
>> -       ufs_qcom_print_unipro_testbus(hba);
>> -       udelay(1000);
>> +       if (in_task()) {
>> +               udelay(1000);
>> +               ufs_qcom_testbus_read(hba);
>> +               udelay(1000);
>> +               ufs_qcom_print_unipro_testbus(hba);
>> +               udelay(1000);
>> +       }
> 
> Did you run into a specific issue with this?  udelay is not a "sleep"
> in the sense that it causes scheduling to occur, which is the problem
> with atomic contexts.

Here, ufs_qcom_print_unipro_testbus is actually causing the problem as 
it has
kmalloc with flag GFP_KERNEL. Even we change the kmalloc flag to ATOMIC, 
the
prints are still too heavy for atomic contexts. So we want to mute all 
test bus
prints in atomic contexts. Hence the in_task() check. But apprently I 
should move
the check up to have all the testbus prints inside the check. I will 
modify the
change and  the commit msg to tell the true story.

Thanks,

Can Guo.
