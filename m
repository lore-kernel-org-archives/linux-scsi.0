Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E12C49EA7
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 06:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE321613E7
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 06:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhFXGuX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 02:50:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33010 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhFXGuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 02:50:23 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210624064803epoutp02a19b15b7381dc4c1bf9f8c7a90e9ae45~LcdylJNPR1067410674epoutp02H
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 06:48:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210624064803epoutp02a19b15b7381dc4c1bf9f8c7a90e9ae45~LcdylJNPR1067410674epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624517283;
        bh=QIcr6Oc41EqkBdEds/yY4VF9Nkh1nPuSWQc5lqgGKhg=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=P14oXzdb6twjGMxlqz/GQTv+cUHzwf4XAex+DHlY9gHZ2Hsi6ohWWZwhBKYOgdiqx
         a/ZPCPpNsB1Yj16eVTggZw7T0RL3AlWAU8BsrvIeQbaztq61M4z+8WKSkR6z1Gdkdm
         de6k1yXspgh9tbW5nfr/A3YqO33asWKN+BwTOSCo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210624064802epcas3p3d8d9feae68fc3877e0c93c5ce8b03ab0~Lcdx_PYFp1683716837epcas3p3Z;
        Thu, 24 Jun 2021 06:48:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4G9W0y2l05z4x9QR; Thu, 24 Jun 2021 06:48:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "joe@perches.com" <joe@perches.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <ed6d8c44-295e-aaa7-4b5f-7929c1c797d1@intel.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <37380050.31624517282371.JavaMail.epsvc@epcpadp4>
Date:   Thu, 24 Jun 2021 15:41:08 +0900
X-CMS-MailID: 20210624064108epcms2p11f1f3c58d9fbcecf9d3fec5b4ae01d71
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210621085158epcms2p46170ba48174547df00b9720dbc843110
References: <ed6d8c44-295e-aaa7-4b5f-7929c1c797d1@intel.com>
        <1891546521.01624267081897.JavaMail.epsvc@epcpadp4>
        <CGME20210621085158epcms2p46170ba48174547df00b9720dbc843110@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 21/06/21 11:51 am, Keoseong Park wrote:
>> Change conditional compilation to IS_ENABLED macro,
>> and simplify if else statement to return statement.
>> No functional change.
>> 
>> Signed-off-by: Keoseong Park <keosung.park@samsung.com>
>> ---
>>  drivers/scsi/ufs/ufshcd.h | 17 ++++++++---------
>>  1 file changed, 8 insertions(+), 9 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index c98d540ac044..6d239a855753 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -893,16 +893,15 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
>>  
>>  static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
>>  {
>> -/* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
>> -#ifndef CONFIG_SCSI_UFS_DWC
>> -	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
>> -	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
>> +	/*
>> +	 * DWC UFS Core has the Interrupt aggregation feature
>> +	 * but is not detectable.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_SCSI_UFS_DWC))
>
>Why is this needed?  It seems like you could just set UFSHCD_CAP_INTR_AGGR
>and clear UFSHCD_QUIRK_BROKEN_INTR_AGGR instead?

Hello Adrian,
Sorry for late reply.

The code that returns true when CONFIG_SCSI_UFS_DWC is set in the original code 
is only changed using the IS_ENABLED macro.
(Linux kernel coding style, 21) Conditional Compilation)

When CONFIG_SCSI_UFS_DWC is not defined, the code for checking quirk 
and caps has been moved to the newly added return statement below.

Thanks,
Keoseong

>
>>  		return true;
>> -	else
>> -		return false;
>> -#else
>> -return true;
>> -#endif
>> +
>> +	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
>> +		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
>>  }
>>  
>>  static inline bool ufshcd_can_aggressive_pc(struct ufs_hba *hba)
>> 
>
