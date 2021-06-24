Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FAEC48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 06:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C882F613EA
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 06:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhFXGnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 02:43:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24034 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhFXGnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 02:43:13 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210624064053epoutp02dfb733a845536bd60b96d2d2b950d1b8~LcXibYkgb0410704107epoutp02t
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 06:40:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210624064053epoutp02dfb733a845536bd60b96d2d2b950d1b8~LcXibYkgb0410704107epoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624516853;
        bh=3T0GJIMynYztIVXFlBI2b3nEFFeRZ5MCdswkq3B7b5s=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=XpYIjBrS51jepBSn9+nP9tn1Jw2cPi+coG3YNeZKrtw6gktsuayI1xaeSoMVMadAQ
         jmVK996c9FqfGMC2ZQuc947Tf/iH659FLZn5V2LfIH/mUBeYVp1tfH86HzoK4AYEHg
         MX5blCj3eJC701QOlLk+4OY4wsDuV6vRANYZTU9Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210624064048epcas2p2bc7f25582994c0e08a935768f4cadcba~LcXds2yeE2961829618epcas2p2a;
        Thu, 24 Jun 2021 06:40:48 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4G9Vrb0MKnz4x9Q9; Thu, 24 Jun
        2021 06:40:47 +0000 (GMT)
X-AuditID: b6c32a48-1f5ff70000002563-38-60d428ee6e50
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.ED.09571.EE824D06; Thu, 24 Jun 2021 15:40:46 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v38 1/4] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <5a71d4c3-2f1f-3c85-eb90-381775e7030e@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210624064044epcms2p3dc2e0fcb8c8e61e6899b5cf6876b2103@epcms2p3>
Date:   Thu, 24 Jun 2021 15:40:44 +0900
X-CMS-MailID: 20210624064044epcms2p3dc2e0fcb8c8e61e6899b5cf6876b2103
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA11TaUxcVRjNW3jzIB3zGBZvaVLII1QgZRY6M95aMK0QfUo1JDXYugSe8Byg
        szkzqPVPEdqyla3abUqhoSwyRaalZRjAShmQJRUF6cYI7WhLEJSyJUbUIc6Gbfx3cu75zved
        795LYoJfiTAyR23gdGpWSRMBuKU/BsY9jr6VIa57JIWOWgsBrx8b5sG5tdsEPLW0hsEVc5Mf
        nLPFwO6+PgKaHG/BwotmAtaM5qOwvLKDgFf7LmPw4dQqD9bfs6Cwcr0Ih5bVQDg08hiBE901
        BCy7ayVg89A6Chs7JhFYcroV3x3KTNxKYSYqylGmyzjNY6rqbyBM7/lWHnNkpBdnlmfsOFNx
        zYQwq+1bmaIbZWhqwNvKhGyOzeJ0EZw6U5OVo1Yk0in70pPSZXKxJE6yEz5PR6hZFZdIJ+9N
        jXs5R+mKSUd8xCrzXFQqq9fTohcTdJo8AxeRrdEbEmlOm6XUSiRaoZ5V6fPUCmGmRvWCRCyO
        l7mUGcrsxct+Wgv5ycjxciIfmfIrRfxJQEmBrbAdL0UCSAFlRYCzpM11QJJ8KhA4rUFuTRC1
        B1Qsl6BuLKBoYB438ry8ENh/bkXcmKC2g9PDD3hun2CqAAdd/QseU4z6AQNf3ytCvN344EzR
        DO7FW0Bnc4eH96d2gRMtUzwvHw3+bCrHvDgETF5a4G3gxcE6n08wOHp/1KcJBI61Hh+/GQz2
        LKFefBh0TP2FuIcA1HEE9HfZfZFF4E7xFc8QfOp10GD9zFOMU1Hgpv0B4dUkA8v3X3iMMCoc
        dC7UYO6tYFQMMHeL3BBQkWDAjm/Eyr/yN+//GKOeAcX9zv94a+0j32jbQNuaGa1CIo1PVm18
        qpfxSa8LCGZCQjmtXqXg9PFa6dOX2454nnwsY0XOLSwJbQhKIjYEkBgdzP/lyI8ZAn4We+hT
        TqdJ1+UpOb0NkblSVmNhIZka159RG9Ilsni5XLxTBmXyeEg/yyd5tgwBpWAN3EGO03K6jTqU
        9A/LR587WVhqCvmuwqEYE4VWidOYk0mzjvW27eEXndxsSUF4yoXYsz2a+WmwqZGcjjrYnWcc
        S+9NK/zN+VLzeGfjQMvuY/xO54Fx+aa5Lag9GZWzwjNnv2nf/NAoUg6/0zohFTX+E53Em7x5
        deB9fCUmeWt+3BsC/F2TqWY0Yla1PK87px/8qbhgxpginQfV7a3ZDRJFtGBsbsdytbnOz29E
        t7Jfqrz98VHt3rLPB+rf3KHalTH85VxLWdr1bwcWa7868eHQ+UsHch05RPehPdfem2jYZ4sM
        C7xTJXxtf8IrjqbZP/ytH+Qejso0LHLaU5V3Xw3adl8yAuO43M6GMMGQ43cDTeP6bFYSi+n0
        7L8DMj8wewQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f
References: <5a71d4c3-2f1f-3c85-eb90-381775e7030e@acm.org>
        <20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f@epcms2p7>
        <20210616070812epcms2p4650ce5cd78056dce9162482e59bb74dd@epcms2p4>
        <CGME20210616070700epcms2p734db9b60e13229696fb3cda5f69e210f@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> On 6/16/21 12:08 AM, Daejun Park wrote:
> > +What:                /sys/class/scsi_device/*/device/unit_descriptor/hpb_pinned_region_start_offset
> > +Date:                June 2021
> > +Contact:        Daejun Park <daejun7.park@samsung.com>
> > +Description:        This entry shows the start offset of HPB pinned region.
> > +
> > +                The file is read only.
> > +
> > +What:                /June/class/scsi_device/*/device/unit_descriptor/hpb_number_pinned_regions
> > +Date:                March 2021
>  
> Please change /June into /sys and "March 2021" into "June 2021".

OK.

>  
> > @@ -7094,6 +7119,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
> >  {
> >          int err;
> >  
> > +        ufshpb_reset_host(hba);
> >          /*
> >           * Stop the host controller and complete the requests
> >           * cleared by h/w
>  
> Shouldn't the ufshpb_reset_host() call occur under the comment instead
> of above?

OK, I will.

Thanks,
Daejun

> Thanks,
>  
> Bart.
>  
>  
>   
