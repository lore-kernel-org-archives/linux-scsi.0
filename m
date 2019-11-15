Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47BDC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 03:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DEE120729
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 03:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ptf+3Nfw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kpO+Mkza"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfKODdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 22:33:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfKODdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 22:33:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4EAB261153; Fri, 15 Nov 2019 03:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573788801;
        bh=M0PfnJ+R31tNx+ad34Ku4jNtjSQmja8N1yTqQQxDrNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ptf+3Nfwx4ueEidN6riRqYHTWuMS07aAknQPQX9rPKOq0SB3H5pOiDW85e5PyYshO
         jpKGfVD4+x5hurxurNTQNX4q7vjxmHiWMi/nL78nuxvAD/+0nC8qk7eqjD1ETpiGQp
         eTHJb297Iry1kWjD6HAvBF0HKIjVjXgaH+wpC+c8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D95C760FD0;
        Fri, 15 Nov 2019 03:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573788799;
        bh=M0PfnJ+R31tNx+ad34Ku4jNtjSQmja8N1yTqQQxDrNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kpO+MkzaLzbupShdE/NIxsI3++dEqdfJ751Om5WHeVVFl/5EViZQNrWoAN/Qrbpdt
         IDiNfbmNEwUFC2CXSsXkF/S/gATg+iPlKpJAG8xt1ZF0DklaDAarpZfypAnf94JM8Q
         ITjJ2X87QPH94BvtoOYsUyVOcqoez9gSNY1VEEyA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 15 Nov 2019 11:33:19 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/7] scsi: ufs: Fix up auto hibern8 enablement
In-Reply-To: <MN2PR04MB69913B9DBCEE72322A741F14FC710@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
 <1573627552-12615-4-git-send-email-cang@codeaurora.org>
 <MN2PR04MB69913B9DBCEE72322A741F14FC710@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <9870aa032748587b65ea54f420f1f080@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-14 17:23, Avri Altman wrote:
>> 
>> 
>> Fix up possible unclocked register access to auto hibern8 register in 
>> resume path
>> and through sysfs entry. Meanwhile, enable auto hibern8 only after 
>> device is
>> fully initialized in probe path.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> Acked-by: Avri Altman <avri.altman@wdc.com>
> 
>> ---
>>  drivers/scsi/ufs/ufs-sysfs.c | 17 +++++++++++------
>>  drivers/scsi/ufs/ufshcd.c    | 12 ++++++------
>>  2 files changed, 17 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
>> b/drivers/scsi/ufs/ufs-sysfs.c index
>> 969a36b..6c2f19e 100644
>> --- a/drivers/scsi/ufs/ufs-sysfs.c
>> +++ b/drivers/scsi/ufs/ufs-sysfs.c
>> @@ -126,13 +126,18 @@ static void ufshcd_auto_hibern8_update(struct
>> ufs_hba *hba, u32 ahit)
>>                 return;
>> 
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> -       if (hba->ahit == ahit)
>> -               goto out_unlock;
>> -       hba->ahit = ahit;
>> -       if (!pm_runtime_suspended(hba->dev))
>> -               ufshcd_writel(hba, hba->ahit, 
>> REG_AUTO_HIBERNATE_IDLE_TIMER);
>> -out_unlock:
>> +       if (hba->ahit != ahit)
>> +               hba->ahit = ahit;
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +       if (!pm_runtime_suspended(hba->dev)) {
>> +               pm_runtime_get_sync(hba->dev);
>> +               ufshcd_hold(hba, false);
>> +               spin_lock_irqsave(hba->host->host_lock, flags);
>> +               ufshcd_writel(hba, hba->ahit, 
>> REG_AUTO_HIBERNATE_IDLE_TIMER);
>> +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> Call ufshcd_auto_hibern8_enable instead of open coding?
> 

In that case, we would have to export ufshcd_auto_hibern8_enable() as it 
is static for now.
Shall do that.

Thanks,

Can Guo.

>> +               ufshcd_release(hba);
>> +               pm_runtime_put(hba->dev);
>> +       }
>>  }
>> 
>>  /* Convert Auto-Hibernate Idle Timer register value to microseconds 
>> */ diff --git
>> a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index 
>> 525f8e6..f12f5a7
>> 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6892,9 +6892,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>>         /* UniPro link is active now */
>>         ufshcd_set_link_active(hba);
>> 
>> -       /* Enable Auto-Hibernate if configured */
>> -       ufshcd_auto_hibern8_enable(hba);
>> -
>>         ret = ufshcd_verify_dev_init(hba);
>>         if (ret)
>>                 goto out;
>> @@ -6945,6 +6942,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>>         /* set the state as operational after switching to desired 
>> gear */
>>         hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>> 
>> +       /* Enable Auto-Hibernate if configured */
>> +       ufshcd_auto_hibern8_enable(hba);
>> +
>>         /*
>>          * If we are in error handling context or in power management 
>> callbacks
>>          * context, no need to scan the host @@ -7962,12 +7962,12 @@ 
>> static int
>> ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>>         if (hba->clk_scaling.is_allowed)
>>                 ufshcd_resume_clkscaling(hba);
>> 
>> -       /* Schedule clock gating in case of no access to UFS device 
>> yet */
>> -       ufshcd_release(hba);
>> -
>>         /* Enable Auto-Hibernate if configured */
>>         ufshcd_auto_hibern8_enable(hba);
>> 
>> +       /* Schedule clock gating in case of no access to UFS device 
>> yet */
>> +       ufshcd_release(hba);
>> +
>>         goto out;
>> 
>>  set_old_link_state:
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
