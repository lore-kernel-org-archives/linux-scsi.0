Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBD9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 00:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89758207FC
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 00:18:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WcoHXo64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgFSASG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 20:18:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43939 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgFSASF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 20:18:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200619001802epoutp048d46df04066835aaccb39be0e107934a~ZydooTB-p3179931799epoutp04K
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2020 00:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200619001802epoutp048d46df04066835aaccb39be0e107934a~ZydooTB-p3179931799epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592525882;
        bh=NOzT7vcRqkUZDzcSZQg51RrlT8m1JaJOcP0aBnou8x0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=WcoHXo64NSq1YW4xtb0aUyA9BJuG3natt6KmHANxxr5X5LRPphn0hJLCnvXqgyI5H
         DnDXQItbQVL8AMQijk2NO0tig42PMZ5zgddegilSbQ5ixAW8yB3dYbNQa5bk6tfKp4
         ykz2dKDi0jZY8DWccDu5D3Auy8vMv516Eb04cKU8=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200619001801epcas1p25d0372cb0e391f0113c090f5210ea760~ZydoOis2a1582515825epcas1p2C;
        Fri, 19 Jun 2020 00:18:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB4640B1D4FBDF68A59D993F21FC9B0@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01592525881606.JavaMail.epsvc@epcpadp2>
Date:   Fri, 19 Jun 2020 09:12:20 +0900
X-CMS-MailID: 20200619001220epcms2p8ab5f114df7a40f2694b8e87468582921
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <SN6PR04MB4640B1D4FBDF68A59D993F21FC9B0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static void ufshpb_run_active_subregion_list(struct ufshpb_lu *hpb)
> > +{
> > +       struct ufshpb_region *rgn;
> > +       struct ufshpb_subregion *srgn;
> > +       struct ufshpb_map_ctx *mctx;
> mctx  doesn't really do anything here

OK, I will delete it.

> > +       unsigned long flags;
> > +       int ret = 0;
> > +
> > +       spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> > +       while ((srgn = list_first_entry_or_null(&hpb->lh_act_srgn,
> > +                                               struct ufshpb_subregion,
> > +                                               list_act_srgn))) {
> > +               list_del_init(&srgn->list_act_srgn);
> > +               spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> > +
> > +               rgn = hpb->rgn_tbl + srgn->rgn_idx;
> > +               mctx = NULL;
> > +               ret = ufshpb_add_region(hpb, rgn);
> > +               if (ret)
> > +                       break;
> > +
> > +               ret = ufshpb_issue_map_req(hpb, rgn, srgn);
> > +               if (ret) {
> > +                       dev_notice(&hpb->hpb_lu_dev,
> > +                           "issue map_req failed. ret %d, region %d - %d\n",
> > +                           ret, rgn->rgn_idx, srgn->srgn_idx);
> > +                       break;
> > +               }
> > +               spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> > +       }
> > +
> > +       if (ret) {
> > +               dev_notice(&hpb->hpb_lu_dev, "region %d - %d, will retry\n",
> > +                          rgn->rgn_idx, srgn->srgn_idx);
> > +               spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> > +               ufshpb_add_active_list(hpb, rgn, srgn);
> > +       }
> > +       spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> > +}
> 
> 
