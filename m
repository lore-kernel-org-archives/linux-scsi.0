Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8530EC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 01:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678AF611CB
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 01:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhHWBiq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Aug 2021 21:38:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63947 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbhHWBip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Aug 2021 21:38:45 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210823013802epoutp01223fadd4d2bc2449266ba34eb1ba47a9~dy8Pxey7C2885028850epoutp01J
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 01:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210823013802epoutp01223fadd4d2bc2449266ba34eb1ba47a9~dy8Pxey7C2885028850epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629682682;
        bh=q+J/BDN8g7YL5QAH0PemEbR6v4KIUjl5qmAlnayWP8s=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=OVhQJofW8QJifNHqVSHOm1kvML5fy/06ikqN//FqClaaoXkA3+IdY7R5IkHc7xCqi
         bW7me2OcA1F3H9BP/D42rCJK2x9ZJL94RoBxDBIwP5zZote7pkLwI92ihbc5d/PQhI
         E2q9v//Ukw7JrjDPRYl4Ceg73NJ0cnOx+SC8WBtU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210823013802epcas3p3ad1c51ead38448ce9b637b67d33fcee0~dy8POXfF22802628026epcas3p3I;
        Mon, 23 Aug 2021 01:38:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4GtFHY6zvGz4x9Qb; Mon, 23 Aug 2021 01:38:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH] scsi: ufs: ufshpb: Fix possible memory leak
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <ca6e8507-743b-005a-faec-375d88d8aaf6@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01629682681949.JavaMail.epsvc@epcpadp4>
Date:   Mon, 23 Aug 2021 10:09:12 +0900
X-CMS-MailID: 20210823010912epcms2p38bc3176b6e11f2e9d9494ae668d479fc
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210820014624epcms2p6724e146ca1f93ba6eac5e7cf95d4cfd2
References: <ca6e8507-743b-005a-faec-375d88d8aaf6@acm.org>
        <1891546521.01629427801384.JavaMail.epsvc@epcpadp3>
        <CGME20210820014624epcms2p6724e146ca1f93ba6eac5e7cf95d4cfd2@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> On 8/19/21 6:46 PM, Keoseong Park wrote:
>> When HPB pinned region exists and mctx allocation for this region fails,
>> memory leak is possible because memory is not released for the subregion
>> table of the current region.
>> 
>> So, change to free memory for the subregion table of the current region.
>> 
>> Signed-off-by: Keoseong Park <keosung.park@samsung.com>
>> ---
>>   drivers/scsi/ufs/ufshpb.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>> index 9acce92a356b..052f584c789a 100644
>> --- a/drivers/scsi/ufs/ufshpb.c
>> +++ b/drivers/scsi/ufs/ufshpb.c
>> @@ -1933,7 +1933,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>>   		if (ufshpb_is_pinned_region(hpb, rgn_idx)) {
>>   			ret = ufshpb_init_pinned_active_region(hba, hpb, rgn);
>>   			if (ret)
>> -				goto release_srgn_table;
>> +				goto release_current_srgn_table;
>>   		} else {
>>   			rgn->rgn_state = HPB_RGN_INACTIVE;
>>   		}
>> @@ -1944,6 +1944,9 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>>   
>>   	return 0;
>>   
>> +release_current_srgn_table:
>> +	kvfree(rgn_table[rgn_idx].srgn_tbl);
>> +
>>   release_srgn_table:
>>   	for (i = 0; i < rgn_idx; i++)
>>   		kvfree(rgn_table[i].srgn_tbl);
>
>'rgn_table' is allocated with kvcalloc() so please merge the new kvfree() statement
>with the for-loop below it.
>
>There is another improvement that can be made in this function: hpb->rgn_tbl
>is not cleared in the error path. I propose to move the "hpb->rgn_tbl = rgn_table"
>assignment from the start of the function to just above the "return 0" statement.
>
>Thanks,
>
>Bart.
>

Thank you for your feedback.
I will fix it.

Best Regards,
Keoseong

