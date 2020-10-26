Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DF7C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 02:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 085D82224A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 02:56:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="nj4W8vyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421582AbgJZC4N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 22:56:13 -0400
Received: from z5.mailgun.us ([104.130.96.5]:11567 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1420359AbgJZC4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 22:56:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603680973; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=dmmHuWWgOo1QDrCXwIDI2BrJabygSJGIfGYBwwYjSjU=;
 b=nj4W8vyQgUKE2SEBwFJYMPtfKwHTZpaaOM3jnNx4VY7OKySlx3X/PSb0UihE+94Nn0zI2D/u
 /Snn555KXfIz9/aujD3B6p1n9ru2ti2TTB/nnr1WW2CntBXJkljilCidMMjjRi2Y0LEuF8UD
 Us4ddsNDm075nR6BwnfKPj6UZaY=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f963accbb5ba27f031fc37d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Oct 2020 02:56:12
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6A55C43387; Mon, 26 Oct 2020 02:56:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF191C433C9;
        Mon, 26 Oct 2020 02:56:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Oct 2020 10:56:10 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>, asutoshd@codeaurora.org,
        avri.altman@wdc.com, beanhuo@micron.com, bvanassche@acm.org,
        hongwus@codeaurora.org, jejb@linux.ibm.com,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        nguyenb@codeaurora.org, rnayak@codeaurora.org, salyzyn@google.com,
        saravanak@google.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
In-Reply-To: <963815509.21603435202191.JavaMail.epsvc@epcpadp1>
References: <CGME20201023063528epcms2p11b57d929a926d582539ce4e1a57caf80@epcms2p1>
 <963815509.21603435202191.JavaMail.epsvc@epcpadp1>
Message-ID: <da29783bdd6eb1326e3ff8fd50921c54@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-23 14:35, Daejun Park wrote:
> Hi, Can Guo
> 
>> Since WB feature has been added, WB related sysfs entries can be 
>> accessed
>> even when an UFS device does not support WB feature. In that case, the
>> descriptors which are not supported by the UFS device may be wrongly
>> reported when they are accessed from their corrsponding sysfs entries.
>> Fix it by adding a sanity check of parameter offset against the actual
>> decriptor length.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>> drivers/scsi/ufs/ufshcd.c | 24 +++++++++++++++---------
>> 1 file changed, 15 insertions(+), 9 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index a2ebcc8..aeec10d 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -3184,13 +3184,19 @@ int ufshcd_read_desc_param(struct ufs_hba 
>> *hba,
>> 	/* Get the length of descriptor */
>> 	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
>> 	if (!buff_len) {
>> -		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
>> +		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (param_offset >= buff_len) {
>> +		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN 0x%x, 
>> length 0x%x\n",
>> +			__func__, param_offset, desc_id, buff_len);
> 
> In my understanding, this code seems to check incorrect access to not
> supportted features (e.g. WB) via buff_len value from
> ufshcd_map_desc_id_to_length().
> However, since buff_len is initialized as QUERY_DESC_MAX_SIZE and is
> updated later by ufshcd_update_desc_length(), So it is impossible to 
> find
> incorrect access by checking buff_len at first time.
> 
> Thanks,
> Daejun

Yes, I considered that during bootup time, but the current driver won't 
even
access WB related stuffs it is not supported (there are checks against 
UFS version
and feature supports in ufshcd_wb_probe()). So this change is only 
proecting illegal
access from sysfs entries after bootup is done. Do you see real error 
during bootup
time? If yes, please let me know.

Thanks,

Can Guo.
