Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2ADFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7803B64F1D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581382AbhCBSvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:51:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29578 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378826AbhCBJAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 04:00:55 -0500
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210302090003epoutp03ff8b608dd3b9e70c8ed681a5557f0ff6~oeufyf99I1317413174epoutp037
        for <linux-scsi@vger.kernel.org>; Tue,  2 Mar 2021 09:00:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210302090003epoutp03ff8b608dd3b9e70c8ed681a5557f0ff6~oeufyf99I1317413174epoutp037
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614675603;
        bh=0lpjwPgu5Hj4CVMTV/29n5W4CRheI+0IpyiHnQi3AU4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=lbnrIekrYDQ051mHqoq9W++fCu//Sl0I1eI3q8GqwIez49Qkmgpn/+RTPZFxoqNPb
         UR4ZjvhEZdY/KhCyGVaZ3b6ixfNK5jl/ykQkeBjYuveXj1E/b0r4VbTByIxMpZBl6v
         v05YeFtk8FlcC6ufEUc1tUGVGK+y1UKcfQv0JqAo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210302090001epcas3p41b991dc965986cbbc7fd1b797fec4111~oeuesNSlR0891708917epcas3p4O;
        Tue,  2 Mar 2021 09:00:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4DqWKs5q5qz4x9Pq; Tue,  2 Mar 2021 09:00:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4 3/9] scsi: ufshpb: Add region's reads counter
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
In-Reply-To: <20210226083300.30934-4-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01614675601803.JavaMail.epsvc@epcpadp3>
Date:   Tue, 02 Mar 2021 17:31:10 +0900
X-CMS-MailID: 20210302083110epcms2p5551cd399aef0217d7cd9b58ae9834bcb
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210226083422epcas2p2d39acff666e2cb9ed97bc2d5c7a8df6f
References: <20210226083300.30934-4-avri.altman@wdc.com>
        <20210226083300.30934-1-avri.altman@wdc.com>
        <CGME20210226083422epcas2p2d39acff666e2cb9ed97bc2d5c7a8df6f@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> +static void ufshpb_normalization_work_handler(struct work_struct *work)
> +{
> +        struct ufshpb_lu *hpb;
> +        int rgn_idx;
> +
> +        hpb = container_of(work, struct ufshpb_lu, ufshpb_normalization_work);
> +
> +        for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
> +                struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;

*HERE*
> +                if (rgn->reads) {
> +                        unsigned long flags;
> +
> +                        spin_lock_irqsave(&rgn->rgn_lock, flags);

I thinks this lock should protect rgn->reads when it is accessed.

> +                        rgn->reads = (rgn->reads >> 1);
> +                        spin_unlock_irqrestore(&rgn->rgn_lock, flags);
> +                }
*HERE*

> +
> +                if (rgn->rgn_state != HPB_RGN_ACTIVE || rgn->reads)
> +                        continue;
> +
> +                /* if region is active but has no reads - inactivate it */
> +                spin_lock(&hpb->rsp_list_lock);
> +                ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
> +                spin_unlock(&hpb->rsp_list_lock);
> +        }
> +
> +        clear_bit(WORK_PENDING, &hpb->work_data_bits);

Why we use work_data_bits? It may be checked by worker API.

Thanks,
Daejun
