Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3CCC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6F52078B
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dev+K1dN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgGAAsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 20:48:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28154 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgGAAsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 20:48:06 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200701004802epoutp04f4afafe98470a76aa41af3d9e524f66c~denQmn7Ks0253002530epoutp04I
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2020 00:48:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200701004802epoutp04f4afafe98470a76aa41af3d9e524f66c~denQmn7Ks0253002530epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593564482;
        bh=p9VUtG0Pl4OAt33Q8oqrQYwJIVcPUptVSmvz8dDBKP4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=dev+K1dN86XDSXmAJA+j6jTzZIa5ONQtLz1/BzGmafeUgOpDJyYDZV1NrDLyTjjXs
         5BNmzbO7oRYL93/2TwJ0bm8bNxZkiAPqVSQM/tp9mylyviT59jzdX44hDAP0wFQR2/
         jLTRZcLG0+N3lJc/Jk4PnIrtyUhdzmat4AcRR0HY=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200701004801epcas1p42eded001b132633c434c069a35b775bf~denQJsVTe0428504285epcas1p4B;
        Wed,  1 Jul 2020 00:48:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
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
In-Reply-To: <SN6PR04MB4640BCE167B108B74D5042E5FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01593564481923.JavaMail.epsvc@epcpadp2>
Date:   Wed, 01 Jul 2020 09:11:09 +0900
X-CMS-MailID: 20200701001109epcms2p30f3a97297ba6c56fe12c68978af952fe
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200629064323epcms2p787baba58a416fef7fdd3927f8da701da
References: <SN6PR04MB4640BCE167B108B74D5042E5FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <1239183618.61593413882377.JavaMail.epsvc@epcpadp2>
        <963815509.21593413582881.JavaMail.epsvc@epcpadp2>
        <1239183618.61593413402991.JavaMail.epsvc@epcpadp1>
        <231786897.01593413281727.JavaMail.epsvc@epcpadp2>
        <963815509.21593415684555.JavaMail.epsvc@epcpadp2>
        <CGME20200629064323epcms2p787baba58a416fef7fdd3927f8da701da@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
> > +                               struct ufshpb_region *rgn,
> > +                               struct ufshpb_subregion *srgn)
> > +{
> 
> 
> > +
> > +       ret = ufshpb_lu_get(hpb);
> > +       if (unlikely(ret)) {
> > +               dev_notice(&hpb->hpb_lu_dev,
> > +                          "%s: ufshpb_lu_get failed: %d", __func__, ret);
> > +               goto free_map_req;
> > +       }
> > +
> > +       ret = ufshpb_execute_map_req(hpb, map_req);
> > +       if (ret) {
> > +               dev_notice(&hpb->hpb_lu_dev,
> > +                          "%s: issue map_req failed: %d, region %d - %d\n",
> > +                          __func__, ret, srgn->rgn_idx, srgn->srgn_idx);
> > +               ufshpb_lu_put(hpb);
> > +               goto free_map_req;
> > +       }
> Missing closing ufshpb_lu_put?

ufshpb_lu_put() is called at ufshpb_map_req_compl_fn() which is completed
callback function. Callilng ufshpb_lu_put() in ufshpb_issue_map_req() is
used for error handling.

Thanks,
Daejun
