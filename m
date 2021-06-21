Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C603C49361
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 05:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 227D760FE9
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 05:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhFUFRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:17:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16178 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhFUFRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 01:17:19 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210621051503epoutp02e360fa52977218222625953046ad3699~KgQvqnjjW3215832158epoutp02_
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 05:15:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210621051503epoutp02e360fa52977218222625953046ad3699~KgQvqnjjW3215832158epoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624252503;
        bh=uD2xgijxF20/e8EVumPCrz2Akskz7eMKDXgfZx/8/2Y=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=TVCU1PiYZJfybdeZWAjw1ma2fO1vPfgyJf6+zMy3RCfdjR33QNjSCnQz6IZWyeWES
         LpicTNlGq/aYMpVkMed482M79kWccpB7Ek1P4er2wKalpYSwS5wt/gJu2XoPvMJEVp
         HPJ4KZ70JKKYtiJDLFGMUqRk9vtxH+7v9K0rwSwA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210621051502epcas3p3d7db52aae5faddf082c536938bcb1297~KgQuleu1Y0704507045epcas3p34;
        Mon, 21 Jun 2021 05:15:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4G7d52499bz4x9Q7; Mon, 21 Jun 2021 05:15:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v11 12/12] scsi: ufshpb: Make host mode parameters
 configurable
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210616112800.52963-13-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21624252502579.JavaMail.epsvc@epcpadp3>
Date:   Mon, 21 Jun 2021 14:12:31 +0900
X-CMS-MailID: 20210621051231epcms2p8f48a5f2c5b39d8d72544188131d99740
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210616113004epcas2p41cf111449e118965ae71aaaee1d3bd5c
References: <20210616112800.52963-13-avri.altman@wdc.com>
        <20210616112800.52963-1-avri.altman@wdc.com>
        <CGME20210616113004epcas2p41cf111449e118965ae71aaaee1d3bd5c@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

>diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
>index d001f008312b..b10cecb286df 100644
>--- a/Documentation/ABI/testing/sysfs-driver-ufs
>+++ b/Documentation/ABI/testing/sysfs-driver-ufs
>@@ -1449,7 +1449,7 @@ Description:        This entry shows the maximum HPB data size for using single HPB
> 
>                 The file is read only.
> 
>-What:                /sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
>+What:                /sys/bus/platform/drivers/ufshcd/*/flags/hpb_enable

This part seems to be the problem with my patch. I will correct it.

...

>diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>index ab66919f4065..6f2ded8c63b0 100644
>--- a/drivers/scsi/ufs/ufshpb.c
>+++ b/drivers/scsi/ufs/ufshpb.c

...

>@@ -1697,6 +1704,7 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
>         struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
>                                              ufshpb_normalization_work);
>         int rgn_idx;
>+        u8 factor = hpb->params.normalization_factor;
> 
>         for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
>                 struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
>@@ -1707,7 +1715,7 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
>                 for (srgn_idx = 0; srgn_idx < hpb->srgns_per_rgn; srgn_idx++) {
>                         struct ufshpb_subregion *srgn = rgn->srgn_tbl + srgn_idx;
> 
>-                        srgn->reads >>= 1;
>+                        srgn->reads >>= factor;
>                         rgn->reads += srgn->reads;

How about changing it to "rgn->read >>=factor" and placing it outside the for statement?


Thanks,
Daejun
