Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD39CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 01:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 326D4208CB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 01:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gLSX1PZf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pB6wHCTM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfKABSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 21:18:09 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfKABSJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 21:18:09 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B62CB60B10; Fri,  1 Nov 2019 01:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572571087;
        bh=y9zMopn20pWyqd0dZAi6MdBEcZVwhsf/FKrrzC2v+nc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gLSX1PZfWinw39KqYpe7dn5LELvTP3vyfXmd0MSUFFiLT8hftYycjs5QEXIeYP50g
         jI5r6azQ+z12+2WdunRNOpUDxdBNxAM4j+U6CCr6StU1BZxsooGv13ZGgPHRffL12E
         NX6HTWFzSdTPpC3LnqdIPuFv7xeU9nXY3lPAvsTI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3C1F760913;
        Fri,  1 Nov 2019 01:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572571086;
        bh=y9zMopn20pWyqd0dZAi6MdBEcZVwhsf/FKrrzC2v+nc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pB6wHCTMNwQeSdopYeN0dThzcYnAz2cCO2YnbCR9/j4HD06nQ5ZqAm0IusbOBIcOB
         xh9U69ZoofNSa8G39UYEBpYLp2OVrXC5CTCLbbyCWdmN+xhA6m5nM+z4uu+kNd+8cJ
         EkHRQxnY7nASLD6oiKXoI2GgogTXZ/LtWa8L6y68=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 01 Nov 2019 09:18:06 +0800
From:   cang@codeaurora.org
To:     Mark Salyzyn <salyzyn@android.com>
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
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting host
 controller
In-Reply-To: <61b83149-e89b-bb4c-d747-a4c596c8eede@android.com>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
 <1571804009-29787-2-git-send-email-cang@codeaurora.org>
 <61b83149-e89b-bb4c-d747-a4c596c8eede@android.com>
Message-ID: <8b7e86d09cde1ea45c1ad979d88dc022@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-31 22:44, Mark Salyzyn wrote:
> On 10/22/19 9:13 PM, Can Guo wrote:
>> Some UFS host controllers need their specific implementations of 
>> resetting
>> to get them into a good state. Provide a new vops to allow the 
>> platform
>> driver to implement this own reset operation.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++
>>   drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
>>   2 files changed, 26 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c28c144..161e3c4 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -3859,6 +3859,14 @@ static int ufshcd_link_recovery(struct ufs_hba 
>> *hba)
>>   	ufshcd_set_eh_in_progress(hba);
>>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>   +	ret = ufshcd_vops_full_reset(hba);
>> +	if (ret)
>> +		dev_warn(hba->dev, "%s: full reset returned %d\n",
>> +				  __func__, ret);
>> +
>> +	/* Reset the attached device */
>> +	ufshcd_vops_device_reset(hba);
>> +
>>   	ret = ufshcd_host_reset_and_restore(hba);
>>     	spin_lock_irqsave(hba->host->host_lock, flags);
> 
> In all your cases, especially after this adjustment,
> ufshcd_vops_full_reset is called blindly (+error checking message)
> before ufshcd_vops_device_reset. What about dropping the .full_reset
> (should really have been called .hw_reset or .host_reset) addition to
> the vops, just adding ufshcd_vops_device_reset call here before
> ufshcd_host_reset_and_restore, and in the driver folding the
> ufshcd_vops_full_reset code into the .device_reset handler?
> 
> Would that be workable? It would be simpler if so.
> 
> I can see a desire for the heads up
> (ufshcd_vops_full_reset+)ufshcd_vops_device_reset calls before
> ufshcd_host_reset_and_restore because that function will spin 10
> seconds waiting for a response from a standardized register, that
> itself could be hardware locked up requiring product specific reset
> procedures. But if that is the case, then what about all the other
> calls to ufshcd_host_reset_and_restore in this file that are not
> provided the heads up? My guess is that the host device only
> demonstrated issues in the ufshcd_link_recovery handling path? Are you
> sure this is the only path that tickles the controller into a hardware
> lockup state?
> 
> Sincerely -- Mark Salyzyn

Hi Mark Salyzyn,

Folding the "full_reset" vops inito "device_reset" vops is one choice 
for now. Shall do that.
Your guess is correct. the head up is needed in ufshcd_link_recovery() 
path because
link is already in bad state when we are here, expeically after hibern8 
exit fails.
So we need a full reset to PHY and host controller here before 
host_reset_and_restore.
But other calls to host_reset_and_restore are under good conditions.

Regards,
Can Guo.
