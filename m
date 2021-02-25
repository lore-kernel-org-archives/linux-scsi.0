Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8EEC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 02:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02F664ED1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 02:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhBYCvG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 21:51:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:47617 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbhBYCvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 21:51:05 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210225025021epoutp04e2b377f8e44eb95b3086086c56ece1ae~m3dR0Xuly1246712467epoutp040
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 02:50:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210225025021epoutp04e2b377f8e44eb95b3086086c56ece1ae~m3dR0Xuly1246712467epoutp040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614221421;
        bh=GaoKJV6C1G1zOhLB/M69cIirhSIXhZlBN2bp6HL8PQ0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=gaHhEmm5zy0WE75rupinDbKnVnm2M7gJlGO98vQ3ry9eoQcHxOWmpRKWK9mgzt+nB
         O1gO3+rvya1wSDERv06Ay07LsstaqEd1MKpKK5K/53FpcYcIVhccHU3maqcHGK7frh
         qtvnf5ZwsnzuubvNAHcDNUaqlBQHEDdzomtyOG70=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210225025019epcas2p35298be36c863d1d6df95eadc1a5c2e9a~m3dQ0_NVK2950129501epcas2p36;
        Thu, 25 Feb 2021 02:50:19 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DmHMZ5wTSz4x9Q6; Thu, 25 Feb
        2021 02:50:18 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-47-6037106a2fdd
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.E6.56312.A6017306; Thu, 25 Feb 2021 11:50:18 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
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
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB65752D7DA8F8CFAF06FFE213FC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210225025018epcms2p5cd812ad20a9c6d4f168c4bc8a957c60f@epcms2p5>
Date:   Thu, 25 Feb 2021 11:50:18 +0900
X-CMS-MailID: 20210225025018epcms2p5cd812ad20a9c6d4f168c4bc8a957c60f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmqW6WgHmCwZ1HehYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWTy+85ndYtGN
        bUwW/f/aWSwu75rDZtF9fQebxfLj/5gsbm/hsli69SajRef0NSwWixbuZnEQ9bh8xdvjcl8v
        k8fOWXfZPSYsOsDosX/uGnaPlpP7WTw+Pr3F4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgD5UUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbkZHROPMVasJq7
        4t6Jp2wNjAvZuxg5OSQETCTO7d/H3MXIxSEksINRYt/c2UxdjBwcvAKCEn93CIPUCAvYS7xp
        WcwEYgsJKEmsvziLHSKuJ3Hr4RpGEJtNQEdi+on77CBzRARWsEhc/HWJDcRhFvjFJHHi8QdG
        iG28EjPan7JA2NIS25dvZQRZxikQK9F7ORcirCHxY1kvM4QtKnFz9Vt2GPv9sflQY0QkWu+d
        haoRlHjwczdUXFLi2O4PTBB2vcTWO78YQW6QEOhhlDi88xYrREJf4lrHRrAbeAV8JS58O8cG
        YrMIqEo0/T4CNdRFYs2jLrDFzALyEtvfzmEGuZNZQFNi/S59EFNCQFniyC0WmK8aNv5mR2cz
        C/BJdBz+CxffMe8J1GlqEut+rmeawKg8CxHSs5DsmoWwawEj8ypGsdSC4tz01GKjAiPkyN3E
        CE7tWm47GKe8/aB3iJGJg/EQowQHs5II7+Z/pglCvCmJlVWpRfnxRaU5qcWHGE2BvpzILCWa
        nA/MLnkl8YamRmZmBpamFqZmRhZK4rzFBg/ihQTSE0tSs1NTC1KLYPqYODilGpgM4oNYV5id
        DtxluNA6ItByQXq0W2XopILWP/2XI2sP3HLJU1DbqPFggf88C96nqy+XpXcuCNE5sHfRm8DO
        jLsXVBcaeSx9q/RUsWLqwniu/2LT/Hdr9Udyh/5O+P9HpC/4/G2P+ew2M85ynnBR4GjO8Thi
        HHJVMPBi2lzp0KWHRJMKPn5g8JGYfOG4iGGgVk0JC8PuBsaJQc9zXwp2rAme8mpSdM6UA7Mz
        Ez+UZB9Z/+76EmX+97KH1hg4vFTrXHR0wnORCrmn3pv0+3ojVyxX+/hwz+/jvq3PGTxF0x9t
        vT2vhXeKGM+xS9Wng1hcDh1es2Xls8bnj610leW2dmskrG9qTg95de2qTvky3QolluKMREMt
        5qLiRAAz9Z+ZdgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB65752D7DA8F8CFAF06FFE213FC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +       copied = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset,
> > +                                          pre_req->wb.len - offset,
> > +                                          &addr[offset]);
> > +
> > +       if (copied < 0)
> > +               goto mctx_error;
> > +
> > +       offset += copied;
> > +       srgn_offset += offset;
> This seems wrong.
> How come the region offset is affected from the offset inside the pages?

I will change as : srgn_offset += copied
> 
> > +
> > +       if (srgn_offset == hpb->entries_per_srgn) {
> > +               srgn_offset = 0;
> > +
> > +               if (++srgn_idx == hpb->srgns_per_rgn) {
> > +                       srgn_idx = 0;
> > +                       rgn_idx++;
> > +               }
> > +       }
> > +
> > +       if (offset < pre_req->wb.len)
> > +               goto next_offset;
> If the 512k resides in a single subregion, and span across pages, fill_ppn should take care of that.
> If the 512k spans across subregion regions, than it spans across 2 subregions at most,
> and maybe you can use it.

I think it can be support span across pages.
 
The following is about the case of HPB entries are span to two page of
the mctx. fill_ppn() fills HPB entries in the first page of the mctx.
srgn_offset will be updated to check next page. In the next round,
fill_ppn() fills the entries in the second page of mctx.

Thanks,
Daejun
