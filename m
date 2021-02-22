Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6903FC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1757B64E77
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBVIV0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 03:21:26 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50181 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBVIVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 03:21:25 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210222082041epoutp04500bb7ad0bc497ad519f15f8d509602e~mBB2lLwDB3140931409epoutp04W
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2021 08:20:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210222082041epoutp04500bb7ad0bc497ad519f15f8d509602e~mBB2lLwDB3140931409epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613982041;
        bh=R5xDEdqN/Z+6JVp7dPFjmzNfrjc/8QgieY2kBvhAJR0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=llXShFnXh9Y8ZOTk357yU5dKLmb6Jv6jriNMGlgsYYBRVPTafQiIH7xh+aiSETNdJ
         w5YNkflWK/4WRXL5JoocQLCTPqZih0stqEdF0OMo/pRS++eaTIUFh2jYESLOKruviC
         KoG1/V1CdT6wM7caH9ke19W8pXo6TAliE2bmh10M=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210222082040epcas2p4cb09bb3b84ea5605414e5c03400b7499~mBB1dhjU50301703017epcas2p47;
        Mon, 22 Feb 2021 08:20:40 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DkZr674W6z4x9Q1; Mon, 22 Feb
        2021 08:20:38 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-fb-6033695623fd
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.90.10621.65963306; Mon, 22 Feb 2021 17:20:38 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v21 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
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
In-Reply-To: <DM6PR04MB6575834A026CD5194E7A2EFAFC829@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210222082038epcms2p761e3c08ed3ec77854a693d48dc9f1357@epcms2p7>
Date:   Mon, 22 Feb 2021 17:20:38 +0900
X-CMS-MailID: 20210222082038epcms2p761e3c08ed3ec77854a693d48dc9f1357
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmuW5YpnGCwYe9MhYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWTy+85ndYtGN
        bUwW/f/aWSwu75rDZtF9fQebxfLj/5gsbm/hsli69SajRef0NSwWixbuZnEQ9bh8xdvjcl8v
        k8fOWXfZPSYsOsDosX/uGnaPlpP7WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgD5UUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbkZDyf9Iyx4AVX
        RdPCrewNjO3sXYycHBICJhLP5vQxdTFycQgJ7GCUmHJ+DlCCg4NXQFDi7w5hkBphgRCJi5N+
        M4LYQgJKEusvzmKHiOtJ3Hq4BizOJqAjMf3EfXaQOSICv5klLr6dxgriMAssZZZY/bSBGWIb
        r8SM9qcsELa0xPblW8G6OQViJba9eApVoyHxY1kvlC0qcXP1W3YY+/2x+YwQtohE672zUDWC
        Eg9+7oaKS0oc2/2BCcKul9h65xcjyBESAj2MEod33mKFSOhLXOvYCHYEr4CvxL4J28AaWARU
        JS6c74SqcZE4fucUmM0sIC+x/e0cZlCoMAtoSqzfpQ9iSggoSxy5xQLzVsPG3+zobGYBPomO
        w3/h4jvmPYE6TU1i3c/1TBMYlWchgnoWkl2zEHYtYGRexSiWWlCcm55abFRgiBy7mxjByV3L
        dQfj5Lcf9A4xMnEwHmKU4GBWEuFlu2uUIMSbklhZlVqUH19UmpNafIjRFOjLicxSosn5wPyS
        VxJvaGpkZmZgaWphamZkoSTOW2zwIF5IID2xJDU7NbUgtQimj4mDU6qByTJw+oo8QXdNrRlb
        6i7qpXV7ZCxf5TwhxNLQZDvr6ehXy++Z7jFQXheZ/nytw6TJZ3p/T/Rzu7Cx4ed7I9PjfJJd
        pesZVqSEiHilPZxfWW2sF/80MTLu6A82/Z2HOTxVuw4o1Ly4M2Xxq402kU9rQr9sfHF2+Wvv
        i30reE46KUoclb2kvKReYpbsR4+rK+7EqbN9kW30dRFZtJFnae/Gwx+O+921Nyx/aqXNp+nw
        Y9KjjXunPfx97+niMzxRX4s4GW+ZHIutecp0/eMN6aq4wgSP7gVHtm2ZePOXzoIzO9Zufci3
        c1ewcK1J3hbx13oZ/5hmegQ1/itqd+08Iiq5aLGk45WNTEEyd3ffrts1e7sSS3FGoqEWc1Fx
        IgCVcJcBdwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210218090627epcms2p639c216ccebed773120121b1d53641d94
References: <DM6PR04MB6575834A026CD5194E7A2EFAFC829@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <20210218090824epcms2p2d7edc0c79f0503033c1baf0ebd5e1a23@epcms2p2>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
> > +                         struct ufshpb_map_ctx *mctx, int pos, int *error)
> > +{
> > +       u64 *ppn_table;
> > +       struct page *page;
> > +       int index, offset;
> > +
> > +       index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
> > +       offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
> > +
> > +       page = mctx->m_page[index];
> > +       if (unlikely(!page)) {
> > +               *error = -ENOMEM;
> > +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> > +                       "error. cannot find page in mctx\n");
> > +               return 0;
> > +       }
> > +
> > +       ppn_table = page_address(page);
> > +       if (unlikely(!ppn_table)) {
> > +               *error = -ENOMEM;
> > +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> > +                       "error. cannot get ppn_table\n");
> > +               return 0;
> > +       }
> > +
> > +       return ppn_table[offset];
> How about memcpy here as well?
> This way it is clear that the host is not manipulating the physical addresses in any way,
> And you won't need to invent the new ufshpb_fill_ppn_from_page.
>  
I changed the code to use ufshpb_fill_ppn_from_page() because it is more
genenal for use than ufshpb_get_ppn(). And I fixed to use memcpy for
setting cdb of HPB read.

Thanks,
Daejun
