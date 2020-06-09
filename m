Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846ACC433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62CAB20760
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W1kn2UwW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgFIA6T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:58:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46322 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729945AbgFIA6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 20:58:07 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200609005804epoutp01d1bed061b14fd1bdc74d2aa0fbec3d6c~WujvGaXX-0766107661epoutp01D
        for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2020 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200609005804epoutp01d1bed061b14fd1bdc74d2aa0fbec3d6c~WujvGaXX-0766107661epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591664284;
        bh=xQIM7MZu5rkVLLuLjtH34XJl9WWZWOuTSNhekNgHTIs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=W1kn2UwWvaMdtAt/NaV8GBzKD+oFvbXxquXQswrjk/uPv5VjuoprSYuRpIuJQuEK4
         8LLkwHPDJxk5As5rZy0IBr811Ep0aJnc7YT6GNmVs2iihT5Kyhc5fzlTTGp2YbhkY5
         MjZRkGybZxvh7pWWoZ6gxbhiHT3GMUYRGECraBXU=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200609005803epcas1p3732150bf2f70194f0f2b77ba8be08e68~WujufXFER1119911199epcas1p3f;
        Tue,  9 Jun 2020 00:58:03 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH 5/5] scsi: ufs: Prepare HPB read for cached
 sub-region
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
In-Reply-To: <SN6PR04MB4640E4699B88CB43AF62B6DFFC870@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1402433372.121591664283543.JavaMail.epsvc@epcpadp2>
Date:   Tue, 09 Jun 2020 09:53:23 +0900
X-CMS-MailID: 20200609005323epcms2p2e91ce8525a6a5ca7b9f71cbaab2d25a2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <SN6PR04MB4640E4699B88CB43AF62B6DFFC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <336371513.41591323603173.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
> > +                                  int srgn_idx, int srgn_offset, int cnt)

> > +
> > +       for (i = 0; i < bit_len; i++) {
> > +               if (test_bit(srgn_offset + i, srgn->mctx->ppn_dirty))
> Maybe use a mask or hweight instead of testing bit by bit?
There is no problem in this HPB vesion because it only supports 4KB sized read IO.
However, this code is not as efficient as you pointed out. So I will change this in HPB version 2.0.

> > +static void
> > +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb
> > *lrbp,
> > +                                 u32 lpn, u64 ppn,  unsigned int transfer_len)
> > +{
> > +       unsigned char *cdb = lrbp->ucd_req_ptr->sc.cdb;
> > +
> > +       cdb[0] = UFSHPB_READ;
> > +
> > +       put_unaligned_be32(lpn, &cdb[2]);
> Is this needed? The lba is already occupying bytes 2..5
The needless code will be deleted on next patch.

Thanks,
Daejun
