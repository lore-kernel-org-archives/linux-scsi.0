Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4F1C4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1F42083B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:23:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PW2bhkkv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgJ3HXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 03:23:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33223 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3HXG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 03:23:06 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201030072304epoutp04424bc73e673ca3de3e788297044a3f0f~CtDtMwrO70393503935epoutp04R
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 07:23:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201030072304epoutp04424bc73e673ca3de3e788297044a3f0f~CtDtMwrO70393503935epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604042584;
        bh=zIa/iAQyUWRdLL248i5rBcR+7OjxdKqM8e03d3lBWdg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=PW2bhkkvNw3abopm/9ylHbob9VMjLD7IApjSrK2p0Tl52wJyV1eDx6bNBA2cZeUw6
         bFiSI33zFtF0qBJdBFfzLTF+e19Ya8g/299mq51uhqPUAKbmq6fAPfx1jmt6jSg3iB
         2Hw8zeOQ/6hSxWhR5Z4phwvHfiBD7VSnL4AUdofU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20201030072303epcas3p37bda4b0e72a1b108186275c79fecf857~CtDsfMimt2348123481epcas3p3K;
        Fri, 30 Oct 2020 07:23:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4CMv0l1zz2zMqYlx; Fri, 30 Oct 2020 07:23:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v2 1/1] scsi: ufs: Fix unexpected values get from
 ufshcd_read_desc_param()
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <da29783bdd6eb1326e3ff8fd50921c54@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1796371666.41604042583278.JavaMail.epsvc@epcpadp4>
Date:   Fri, 30 Oct 2020 16:19:52 +0900
X-CMS-MailID: 20201030071952epcms2p323893cc8af6782093860228dde7424b8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20201023063528epcms2p11b57d929a926d582539ce4e1a57caf80
References: <da29783bdd6eb1326e3ff8fd50921c54@codeaurora.org>
        <963815509.21603435202191.JavaMail.epsvc@epcpadp1>
        <CGME20201023063528epcms2p11b57d929a926d582539ce4e1a57caf80@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> Hi, Can Guo
>> 
>>> Since WB feature has been added, WB related sysfs entries can be 
>>> accessed
>>> even when an UFS device does not support WB feature. In that case, the
>>> descriptors which are not supported by the UFS device may be wrongly
>>> reported when they are accessed from their corrsponding sysfs entries.
>>> Fix it by adding a sanity check of parameter offset against the actual
>>> decriptor length.
>>> 
>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>> ---
>>> drivers/scsi/ufs/ufshcd.c | 24 +++++++++++++++---------
>>> 1 file changed, 15 insertions(+), 9 deletions(-)
>>> 
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index a2ebcc8..aeec10d 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -3184,13 +3184,19 @@ int ufshcd_read_desc_param(struct ufs_hba 
>>> *hba,
>>> 	/* Get the length of descriptor */
>>> 	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
>>> 	if (!buff_len) {
>>> -		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
>>> +		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (param_offset >= buff_len) {
>>> +		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN 0x%x, 
>>> length 0x%x\n",
>>> +			__func__, param_offset, desc_id, buff_len);
>> 
>> In my understanding, this code seems to check incorrect access to not
>> supportted features (e.g. WB) via buff_len value from
>> ufshcd_map_desc_id_to_length().
>> However, since buff_len is initialized as QUERY_DESC_MAX_SIZE and is
>> updated later by ufshcd_update_desc_length(), So it is impossible to 
>> find
>> incorrect access by checking buff_len at first time.
>> 
>> Thanks,
>> Daejun
>
>Yes, I considered that during bootup time, but the current driver won't 
>even
>access WB related stuffs it is not supported (there are checks against 
>UFS version
>and feature supports in ufshcd_wb_probe()). So this change is only 
>proecting illegal
>access from sysfs entries after bootup is done. Do you see real error 
>during bootup
>time? If yes, please let me know.
>
>Thanks,
>
>Can Guo.

Can Guo,
I haven't seen any real errors. If it's meant to prevent erroneous access
from sysfs, it seems good enough.

Acked-by: Daejun Park <daejun7.park@samsung.com>

Avri,
ufshcd_is_wb_attrs or ufshcd_is_wb_flag is used to match appropriate lun
in case of shared lu WB. I think Can Guo's code is suitable to prevent
wrong access to descriptors.

Thanks,
Daejun
