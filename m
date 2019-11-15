Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9815C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 01:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78E7F20723
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 01:33:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MOPBtNtj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TSccu8B1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKOBdZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 20:33:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfKOBdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 20:33:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3900961067; Fri, 15 Nov 2019 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573781604;
        bh=VTBzwwJodLYvkUFlF5wil68XysauCwqW0WsHUJpxbKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MOPBtNtjoP1TlyKvikj8jIMxAwLTij7v4JnLqyR0vG1hUlAGhirMKmHErtU+ad8aC
         Msi4yb6ULOHwJfGSzc4ewOn10tKTPDmma1Zr+f9qe7R2VfNMl7sqXEJcRrpsfv0Snb
         qCYyIX3i+UFxGiiIkp8SB+CCvDC/0ulSikjIdmvk=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id ED7F660A37;
        Fri, 15 Nov 2019 01:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573781603;
        bh=VTBzwwJodLYvkUFlF5wil68XysauCwqW0WsHUJpxbKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSccu8B15kPEbE0ljTxC+PMD9UjwyawQdv7yUHUePL6kbh5aZdh/QE8rSWcqB22zt
         rhFWQszFVdqhiP8V4rBC6pDI5V/6K8lLR39JcqICLP0UVhErBcmkPotfV33eBxFkEK
         oHVN6ge7/wNg7zl4GPsvhOhRfntC9EW42ffx2h/w=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 15 Nov 2019 09:33:22 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/7] scsi: ufs: Fix error handing during hibern8 enter
In-Reply-To: <MN2PR04MB699130F410CDE9BFB5815CC0FC710@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573627552-12615-1-git-send-email-cang@codeaurora.org>
 <1573627552-12615-8-git-send-email-cang@codeaurora.org>
 <MN2PR04MB699130F410CDE9BFB5815CC0FC710@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <258c6c088cafb4c0b89e8e9439cfa06e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-14 19:06, Avri Altman wrote:
>> 
>> 
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>> 
>> During clock gating (ufshcd_gate_work()), we first put the link 
>> hibern8 by
>> calling ufshcd_uic_hibern8_enter() and if ufshcd_uic_hibern8_enter() 
>> returns
>> success (0) then we gate all the clocks.
>> Now let’s zoom in to what ufshcd_uic_hibern8_enter() does internally:
>> It calls __ufshcd_uic_hibern8_enter() which on detecting the 
>> LINERESET,
>> initiates the full recovery and puts the link back to highest HS gear 
>> and returns
>> success (0) to ufshcd_uic_hibern8_enter() which is the issue as link 
>> is still in
>> active state due to recovery!
>> Now ufshcd_uic_hibern8_enter() returns success to ufshcd_gate_work() 
>> and
>> hence it goes ahead with gating the UFS clock while link is still in 
>> active state
>> hence I believe controller would raise UIC error interrupts. But when 
>> we service
>> the interrupt, clocks might have already been disabled!
>> 
>> This change fixes for this by returning failure from
>> __ufshcd_uic_hibern8_enter() if recovery succeeds as link is still not 
>> in hibern8,
>> upon receiving the error ufshcd_hibern8_enter() would initiate retry 
>> to put the
>> link state back into hibern8.
>> 
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c 
>> index
>> 7a5a904..934c27a 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -3891,15 +3891,24 @@ static int __ufshcd_uic_hibern8_enter(struct
>> ufs_hba *hba)
>>                              ktime_to_us(ktime_sub(ktime_get(), 
>> start)), ret);
>> 
>>         if (ret) {
>> +               int err;
>> +
>>                 dev_err(hba->dev, "%s: hibern8 enter failed. ret = 
>> %d\n",
>>                         __func__, ret);
>> 
>>                 /*
>> -                * If link recovery fails then return error so that 
>> caller
>> -                * don't retry the hibern8 enter again.
>> +                * If link recovery fails then return error code 
>> (-ENOLINK)
>> +                * returned ufshcd_link_recovery().
>> +                * If link recovery succeeds then return -EAGAIN to 
>> attempt
>> +                * hibern8 enter retry again.
> You no longer returning -ENOLINK, and either way retrying, regardless
> of the error code.
> Better check that the commit log is still telling the correct story,
> taking into consideration all those recent fixes and all.
> 

Thanks for pointing this.

Best Regards,
Can Guo.

>>                  */
>> -               if (ufshcd_link_recovery(hba))
>> -                       ret = -ENOLINK;
>> +               err = ufshcd_link_recovery(hba);
>> +               if (err) {
>> +                       dev_err(hba->dev, "%s: link recovery failed", 
>> __func__);
>> +                       ret = err;
>> +               } else {
>> +                       ret = -EAGAIN;
>> +               }
>>         } else
>>                 ufshcd_vops_hibern8_notify(hba, 
>> UIC_CMD_DME_HIBER_ENTER,
>>                                                                 
>> POST_CHANGE); @@ -3913,7 +3922,7 @@
>> static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>> 
>>         for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; 
>> retries--) {
>>                 ret = __ufshcd_uic_hibern8_enter(hba);
>> -               if (!ret || ret == -ENOLINK)
>> +               if (!ret)
>>                         goto out;
>>         }
>>  out:
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
