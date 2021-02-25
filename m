Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014FEC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 03:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA75764ED1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 03:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhBYD02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:26:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13125 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhBYD0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 22:26:23 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210225032537epoutp03ca53368fa42c9651b96aca64c74d3b3d~m38ExS_vX0310603106epoutp03y
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 03:25:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210225032537epoutp03ca53368fa42c9651b96aca64c74d3b3d~m38ExS_vX0310603106epoutp03y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614223537;
        bh=vdHMQ9cj5fSLY+qawb39ZN8USKDpHdE2wqUvWNmLv2c=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=DH0gMXidt+oO794iVHGDXA5XzzutrDuhBrHEA40jqlDFFdKWtcqGitGVElaCyttV/
         QaZ1ENsjOIVFJYN/F5HZGsjH/m98ux60qm4CQoRIOT7YMM8yPTCv5b9nabyefHVa7K
         LRMBCHoKgrlrgx1no9N0fpFuupO2ys5aMYrrN1bo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210225032536epcas2p40bab6d28a9c2026a68e68c9a6cd7d3b4~m38D8LEoh0953709537epcas2p4E;
        Thu, 25 Feb 2021 03:25:36 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DmJ8H2Hzbz4x9QK; Thu, 25 Feb
        2021 03:25:35 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-5b-603718af009e
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.D3.10621.FA817306; Thu, 25 Feb 2021 12:25:35 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v24 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575ECC05596740425EC948EFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210225032534epcms2p5cf03d488df6c16923eb1ddfaa50c1266@epcms2p5>
Date:   Thu, 25 Feb 2021 12:25:34 +0900
X-CMS-MailID: 20210225032534epcms2p5cf03d488df6c16923eb1ddfaa50c1266
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te1BUVRzH5+y97F222bzy0MOSSpcgYNoXuXBgIJsR4xbRUM7kjE6zrHDd
        JffF3qWUalqFQnkJoyO4wUawwIjoisCyQCRCGRKWSokCJiRMs9OsUTjlSjCxLKTTf9/zOd/z
        e51zeFjANFfIy9GZGKNOqaG4fNwxGB0nssP4TOlQjwBNWR1c1PfpEIFcnp+4aHDiPoFOznkw
        9Ke9yQ+5BqJRy9QuVNBg56Kaq2YOKjvWyUX3JucJVH/LwUHHlopwNNpTw0UlY04uav52iYMm
        OviosfM2QEerWnFU/0Uv/nIwPfpjGj1aXsahuy13CLqivh/QF2tbCbrwykWc/mN2HKfLO1oA
        PX9hM13UX8LJ4O/WJKkZZTZjDGN0WfrsHJ0qmUrbqdiukMdJZSJZAoqnwnRKLZNMpbyeIXol
        R7PcIRX2nlKTt4wylCxLSV5KMurzTEyYWs+akinGkK0xyGQGMavUsnk6lThLr02USaWx8mVn
        pkZ945KVMNznHShsrMXN4HtuMeDxILkVVrk3FgM+L4B0AnjjyxHcywXkerjoDCwG/rxAchus
        /3sY9+oAkoL26xbCx8VwfLoVeDWXfAFWDd0lvHGCyAUMXnef9PMuMLIRg2dmzZjXBUkBrC6a
        xX06FHY1dwJvMn/yHbg4ssWHo+DDprJVezC8fcZNrOnfL38OfDoIfvLz1VXPejjl6V3lIfBy
        7xzHpz+GnZOPgLcGSJYCONg97ufbkMCbR9pWahCQ6fD8g/MrgXAyAt4rLMN9Q0mB/9hCvBgj
        t8Audw3mxRgZDe09Ep8jHH49jq81ZW5bIP6vMfJpeGRw8T/utM6sVhYJz3nsnAoQbnk8aMsT
        uSyPc9UBrAVsYAysVsWwsQbZk1d7Aay89ZgdTnDcPSceABweGACQh1FBgvYleWaAIFt5MJ8x
        6hXGPA3DDgD5cpOVmDA4S7/8WXQmhUweGxcnTZAjeVwsojYKWOmUIoBUKU3MfoYxMMa1cxye
        v9DM2f3cw4IFZ47RZrt2J7RS3tg+F12ZvznFLL674aDHVn1o0wnrb1rPXzNvrhv+aqwvsieh
        VLhn5Nyz4RGmOkmmpjzl0SV1Wdq1U00FqZENQ/hh5+mzEdIsXft0ktXPLXIC/vvq+Fvf5Oe9
        GuU4lSh6vv2j0X3iiX7Xd3sn6naGbrfxj77YIPnBsYdwuvcNllSoCp6ZIjBdc/a6A7mHs6KE
        qYrP3vqFTsUSXfOyvl7LmOrB291nhenHt+W+W/pBYKfmKe1MmGQTdqI+5rRgJNdvqTby5hul
        Wla5y9agnix9TX+oMmTrQp2jyxjsyshvY0VF+zv2ourCYdmvLaHpVz4ssLocFM6qlbIYzMgq
        /wWHp5yjdAQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0
References: <DM6PR04MB6575ECC05596740425EC948EFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
        <20210224045532epcms2p2215025506b062e2fdbad73e51563dca6@epcms2p2>
        <DM6PR04MB65759C2968CDEFF32A0A95FDFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > 
> > > +static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
> > Maybe ufshpb_issue_umap_all_req is just a wrapper for
> > ufshpb_issue_umap_req?
> > e.g it calls ufshpb_issue_umap_req(hpb, int read_buferr_id = 0x3) ?
> > Then on host mode inactivation:
> > static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb)
> > {
> >         return ufshpb_issue_umap_req(hpb, 0x1);
> > }
> Better yet, ufshpb_execute_umap_req can get *rgn as an extra argument.
> ufshpb_issue_umap_all_req will call it with NULL, while
> ufshpb_issue_umap_single_req will call it with the rgn to inactivate.
> 
> Then,  ufshpb_set_unmap_cmd takes the form:
> static void ufshpb_set_unmap_cmd(unsigned char *cdb, struct ufshpb_region *rgn)
> {
>         cdb[0] = UFSHPB_WRITE_BUFFER;
> 
>         if (rgn) {
>                 cdb[1] = UFSHPB_WRITE_BUFFER_INACT_SINGLE_ID;
>                 put_unaligned_be16(rgn->rgn_idx, &cdb[2]);
>         } else {
>                 cdb[1] = UFSHPB_WRITE_BUFFER_INACT_ALL_ID;
>         }
> 
>         cdb[9] = 0x00;
> }
> 
> Does it make sense?

I got it.

Thanks,
Daejun
