Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB314C2BB1D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E24720678
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ftTFbNUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405664AbgDNF4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 01:56:15 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:23701 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729230AbgDNF4O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 01:56:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586843773; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=CqAf2Ohv1uR0GQYvhTerEQ9ipmvFhuy30G923bb4KLk=;
 b=ftTFbNUgI1zL4n5AGkZzZCzfhhSeGYLWg7J1XibFIc9OziS0Gg+Adt4R5czR12wzhDh9MXs+
 3qD1lskvtcNU2IU0D21fkHvx5w/9+yRBpapW22WP6hkqDcnYiSorCMron8jgN1GVa7VHEv2x
 Dx9c+aslhhhj2MjM6gAiO02QDxQ=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e955075.7f8890cd8260-smtp-out-n01;
 Tue, 14 Apr 2020 05:56:05 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AE003C432C2; Tue, 14 Apr 2020 05:56:05 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0693FC433CB;
        Tue, 14 Apr 2020 05:56:04 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Apr 2020 13:56:03 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        'Avri Altman' <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Stanley Chu' <stanley.chu@mediatek.com>,
        'Bean Huo' <beanhuo@micron.com>,
        'Bart Van Assche' <bvanassche@acm.org>,
        'Venkat Gopalakrishnan' <venkatg@codeaurora.org>,
        'Tomas@codeaurora.org, Winkler' <tomas.winkler@intel.com>,
        'open list' <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was off
In-Reply-To: <019601d61204$b303ace0$190b06a0$@samsung.com>
References: <CGME20200328022740epcas5p1e97777d3e2dacfbee89fed75d6b36e99@epcas5p1.samsung.com>
 <1585362454-5413-1-git-send-email-cang@codeaurora.org>
 <019601d61204$b303ace0$190b06a0$@samsung.com>
Message-ID: <98c11950db39f63fa7f6959b223e7372@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Alim,

On 2020-04-14 10:30, Alim Akhtar wrote:
> Hi Can,
> 
>> -----Original Message-----
>> From: Can Guo <cang@codeaurora.org>
>> Sent: 28 March 2020 07:58
>> To: asutoshd@codeaurora.org; nguyenb@codeaurora.org;
>> hongwus@codeaurora.org; rnayak@codeaurora.org; linux-
>> scsi@vger.kernel.org; kernel-team@android.com; saravanak@google.com;
>> salyzyn@google.com; cang@codeaurora.org
>> Cc: Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman
>> <avri.altman@wdc.com>; James E.J. Bottomley <jejb@linux.ibm.com>; 
>> Martin
>> K. Petersen <martin.petersen@oracle.com>; Stanley Chu
>> <stanley.chu@mediatek.com>; Bean Huo <beanhuo@micron.com>; Bart Van
>> Assche <bvanassche@acm.org>; Venkat Gopalakrishnan
>> <venkatg@codeaurora.org>; Tomas Winkler <tomas.winkler@intel.com>; 
>> open
>> list <linux-kernel@vger.kernel.org>
>> Subject: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was 
>> off
>> 
>> From: Asutosh Das <asutoshd@codeaurora.org>
>> 
>> During suspend, if the link is put to off, it would require a full
> initialization during

Good catch.

>> resume. This patch resets and restores both the hba and the card 
>> during
>> initialization.
>> 
> In case you have faced issues by not doing what this patch does, it is 
> worth
> mentioning that in the commit mesg.
> 

OK.

>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
> I don't have a way to test this path as of now, changes looks ok 
> though.
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
>>  drivers/scsi/ufs/ufshcd.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c 
>> index
>> f19a11e..21e41e5 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8007,9 +8007,13 @@ static int ufshcd_resume(struct ufs_hba *hba, 
>> enum
>> ufs_pm_op pm_op)
>>  		else
>>  			goto vendor_suspend;
>>  	} else if (ufshcd_is_link_off(hba)) {
>> -		ret = ufshcd_host_reset_and_restore(hba);
>>  		/*
>> -		 * ufshcd_host_reset_and_restore() should have already
>> +		 * A full initialization of the host and the device is
> required

Shall fix.

>> +		 * since the link was put to off during suspend.
>> +		 */
>> +		ret = ufshcd_reset_and_restore(hba);
>> +		/*
>> +		 * ufshcd_reset_and_restore() should have already
>>  		 * set the link state as active
>>  		 */
>>  		if (ret || !ufshcd_is_link_active(hba))
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
>> Linux
>> Foundation Collaborative Project.

Thanks.
Can Guo.
