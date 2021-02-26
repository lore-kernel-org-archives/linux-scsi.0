Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375EDC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 04:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBFFE64ECE
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 04:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBZEuK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:50:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24583 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhBZEuJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 23:50:09 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210226044926epoutp030894ec1384645286d3e64a7f0cd6f596~nMuia1F750399303993epoutp03O
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2021 04:49:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210226044926epoutp030894ec1384645286d3e64a7f0cd6f596~nMuia1F750399303993epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614314966;
        bh=tsfvXmtuiZ1/GT/n6PV0+9VfvhaOw8nxp2MALJ8W0P4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=GxVwhlsp5pF1elxg+1Hsw9H+qyAvp5DSstUQcf+YSOM+TodiB9O9NWS0GzJzdirUJ
         Y1M1TXppkRWAjdk7nFNgbykBOGQXuyTDYR5EXtCitx8HeoOw8oAhaoetQMbFGTZ8t8
         MDp7uTL6Zlvoo69RKRbUOh2WbNx28Xmbwo9snRDM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210226044925epcas2p2d8333adda2ed421d90fc60c5cee6a633~nMuhr8sYT1660116601epcas2p2a;
        Fri, 26 Feb 2021 04:49:25 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DmxyW73Ncz4x9Q8; Fri, 26 Feb
        2021 04:49:23 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-1f-60387dd355da
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.15.52511.3DD78306; Fri, 26 Feb 2021 13:49:23 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v24 1/4] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
In-Reply-To: <50f8a0963e887542a467e690b6d406675279a4e5.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210226044923epcms2p1fa387ff8d1eaac09a8cce146d63ea205@epcms2p1>
Date:   Fri, 26 Feb 2021 13:49:23 +0900
X-CMS-MailID: 20210226044923epcms2p1fa387ff8d1eaac09a8cce146d63ea205
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmue7lWosEg+3fjS0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIydhwcwVLwS2W
        inNPxRoYFzJ3MXJySAiYSFzYto+9i5GLQ0hgB6PE1R/HgBIcHLwCghJ/dwiD1AgLOErM3XaQ
        EcQWElCSWH9xFjtEXE/i1sM1YHE2AR2J6Sfug80REfjFLLHr4XImEIdZYCmzxOqnDVDbeCVm
        tD9lgbClJbYv3wrWzSngLnFq3womiLiGxI9lvVD1ohI3V79lh7HfH5vPCGGLSLTeOwtVIyjx
        4OduqLikxLHdH6Dm1EtsvfOLEeQICYEeRonDO2+xQiT0Ja51bAQ7glfAV2LL5s9MIB+zCKhK
        XF+sAVHiIvHrYDdYObOAvMT2t3PAgcIsoCmxfpc+iCkhoCxx5BYLzFcNG3+zo7OZBfgkOg7/
        hYvvmPcE6jI1iXU/1zNNYFSehQjpWUh2zULYtYCReRWjWGpBcW56arFRgQly3G5iBCd2LY8d
        jLPfftA7xMjEwXiIUYKDWUmEd/M/0wQh3pTEyqrUovz4otKc1OJDjKZAT05klhJNzgfmlryS
        eENTIzMzA0tTC1MzIwslcd4igwfxQgLpiSWp2ampBalFMH1MHJxSDUx6Gdf553v6aXOt2CB9
        OcI4INuaX2HtJKU1E5bmf+6eG33Nt8/G9FLdvcYV9/Zd4Tx5qejUNua5S8NPW6yRrbTefXB1
        yMSj9303bnt441l4eU7DQrmb/YHtz2N4tcRNNAoXZmQrLF6hWm63e8WuN588fJR/J1yKWaZh
        k6i+tHzFtEkv7pt94IoJePz6vWi0wq9zZaF/tvndbhZezrnwtOmxc/8nqTFN6N+6uObDnV+/
        FT0jT0y71rTzn5JAQWWs6Nc85uvKy+qVd05mOPvixH/vSW3nJwlMjpfQsX/nf5yvuzilyUBo
        8pt3BVcqTj1kZzdzY++eZMd6k3HlO8FQZ68Vlkf3VLxW39pR/1zdTrBDiaU4I9FQi7moOBEA
        3KNLFXUEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0
References: <50f8a0963e887542a467e690b6d406675279a4e5.camel@gmail.com>
        <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
        <20210224045405epcms2p2d05f8563b1f121d2c2cc79b343e5af77@epcms2p2>
        <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > 
> > +void ufshpb_init(struct ufs_hba *hba)
> > +{
> > +        struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
> > +        int try;
> > +        int ret;
> > +
> > +        if (!ufshpb_is_allowed(hba))
> > +                return;
> > +
>  
> Here it is better to check "dev_info->hpb_enable", if HPB is not
> enabled from UFS device level,  doesn't need to create mempool and take
> other memory resource.

I will add checking dev_info->hpb_enable value.
if (!ufshpb_is_allowed(hba) || !dev_info->hpb_enable)

Thanks,
Daejun

> Bean
>  
>  
>  
>  
>  
>   
