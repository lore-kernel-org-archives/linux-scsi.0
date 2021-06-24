Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD43C48BC2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A4D2613A9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFXCOV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 22:14:21 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:55643 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229826AbhFXCOU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 22:14:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624500722; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Ibr7ATXXDdGRj26ITAaHjj7gFL18k0W8orTknu55oeI=;
 b=GbHa/3//Cn5/ACV4Il7lFw5M9DaLR1Abf98A3sitdqDUiOFKVk954zLYIPm2kGyWeGyp0SZt
 l+Ek8lboKhA2Bbn2Lyna1u6ypBbaUlJrsRPzkQAINt3bi4/zh+OSoGbIY9fw3M2uEjN2ZbvS
 Wcv4tLck1FRXS3RglYoc9eeiXgw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60d3e9e32a2a9a9761ffb9b8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 02:11:47
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB1AAC43143; Thu, 24 Jun 2021 02:11:46 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DA17DC433F1;
        Thu, 24 Jun 2021 02:11:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Jun 2021 10:11:45 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/10] scsi: ufs: Update the return value of supplier
 pm ops
In-Reply-To: <59b0c04a-298a-4eae-7938-8170835c00b7@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-4-git-send-email-cang@codeaurora.org>
 <59b0c04a-298a-4eae-7938-8170835c00b7@acm.org>
Message-ID: <1b9c53737fbd4a93ced02abe1441f12b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-24 05:08, Bart Van Assche wrote:
> On 6/23/21 12:35 AM, Can Guo wrote:
>> rpm_get_suppliers() is returning an error only if the error is 
>> negative.
>> However, ufshcd_wl_resume() may return a positive error code, e.g., 
>> when
>> hibern8 or SSU cmd fails. Make the positive return value a negative 
>> error
>> code so that consumers are aware of any resume failure from their 
>> supplier.
>> Make the same change to ufshcd_wl_suspend() just to keep symmetry.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index abe5f2d..ee70522 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8922,7 +8922,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba 
>> *hba, enum ufs_pm_op pm_op)
>>  		ufshcd_release(hba);
>>  	}
>>  	hba->wlu_pm_op_in_progress = false;
>> -	return ret;
>> +	return ret <= 0 ? ret : -EINVAL;
>>  }
>> 
>>  static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op 
>> pm_op)
>> @@ -9009,7 +9009,7 @@ static int __ufshcd_wl_resume(struct ufs_hba 
>> *hba, enum ufs_pm_op pm_op)
>>  	hba->clk_gating.is_suspended = false;
>>  	ufshcd_release(hba);
>>  	hba->wlu_pm_op_in_progress = false;
>> -	return ret;
>> +	return ret <= 0 ? ret : -EINVAL;
>>  }
> 
> I think the above patch shows that indicating failure by either
> returning a positive or a negative value is a booby trap. Please modify
> ufshcd_send_request_sense() and ufshcd_set_dev_pwr_mode() such that
> these return a value that is either zero or negative. Are there any
> other functions than that need to be modified?

Yes, there are more of them - both enter/exit_hibern8() and 
reset_and_restore()
can return positive values. I will modify all of them in next ver.

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
