Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52741C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 03:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234EE64ED1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 03:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhBYD1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:27:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34182 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbhBYD1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 22:27:01 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210225032617epoutp01afade107a46b575df384cedcb3d72e0f~m38qRH3f-0103801038epoutp01S
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 03:26:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210225032617epoutp01afade107a46b575df384cedcb3d72e0f~m38qRH3f-0103801038epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614223577;
        bh=PUJ1RF9kKOIw3H5CgMQFMHd7cpsNDg6/7ze9waNJ49M=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=TTj87//7gGbOd+qTlHOlbzvE1S0SD4tPfppyMLTFpDLRsHZGHKxzkmh7yqxd4QWgz
         zRtrq1b2rd82U025rzSxrfG7U1q/IH5v8n/NiXw2YOG1PRnKfr5qmzYiMh9/yw70Z/
         y12qc3PKFIMyr/AT8eN//TmvPoM24Eb8kLgq/0MM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210225032617epcas2p3e32cdfd18f2f2507076571b056bbc287~m38pw7Zai2214722147epcas2p3t;
        Thu, 25 Feb 2021 03:26:17 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DmJ934XRPz4x9Q8; Thu, 25 Feb
        2021 03:26:15 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-70-603718d711c6
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.C9.56312.7D817306; Thu, 25 Feb 2021 12:26:15 +0900 (KST)
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
In-Reply-To: <DM6PR04MB6575BBF6F89002222EA5FC1DFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210225032615epcms2p6679f3571205dc7a9c222f07398a9726c@epcms2p6>
Date:   Thu, 25 Feb 2021 12:26:15 +0900
X-CMS-MailID: 20210225032615epcms2p6679f3571205dc7a9c222f07398a9726c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA51TbUxbVRj23HtpC1py+RrHbrp6hwpTSiltOYwxcU7SuIgmblk2XaCWG4rQ
        D3sLzCVkzcDB2BiYKbAOqoOUKZA12/goFPkoisBClLEPvtS6lWzIuiHMOMZAKS1u8af/nvOc
        5z3P874nLwcP7GDzOBlqPa1Ty7Molh/R0hshjbwOY1OFVyZeQA5TCwt9e6SfjaYXrrJQ78Rd
        NiqfXcDRnKXOB03bI1C9Yw/Kr7WwUNWQAUMlpc0sdHNyno1qRlswVLpcSKCR9ioWOnbdykJn
        f1jG0ESTHzI3jwF0tKKRQDVnbERiiGzkyk7ZyIkSTNZm/JktK6vpBrKu6ka2rGCgi5D9MTVO
        yE401QPZ/IXnZYXdx7B3/fYZwFa5TqHMyKH5tFqhSctQpydQu3clRSKKr9Qw+gTq/WgkEkTH
        SQTiOIEodv+WaKFQJKH4armKTqAORHqrKb5OoV1R62lGr6MV9AqlS2T08nRawMhVTLY6XaDQ
        qCh+jjwre6WOitq2VUnL02gdP9UJlIOT67Xn2AcuHr+LGcAcUQw4HEiK4QPbzmLgxwkkrQAW
        HLnh4+a5ZABcsgYVA19OEPkarPlrkHDjQJKClmEj28ML4PhvjcCNWeSrsKL/V7b7nWByEYfD
        rnIf9wEnzThsmDLgbhUkubCycIrw4PWw9WwzcJv5kvthqZ3nocPhg7oSrzwEjjW42Gv4Xt+X
        wIOD4ae/DHk1AdCxYPPyz8I+2yzmwYdg8+RD4M4AyeMA9raN+3guouC1ovOrGbjk27BjfmC1
        mCBfhK6KL7xmO6Dj9tiqBic3wlZXFe7OiZMR0NIe5ZnbJvjdOLHWleH8Ivu/GCf9YVHv0r+8
        1eT0RnsJnluwYGVgk/HxpI1PeBkfe30F8HqwjtYyqnSaEWlFT37zBbC6AZuTrOBz16zADjAO
        sAPIwalg7sVlSWogN03+yUFap0nRZWfRjB0cXOnyM5wXotCsrJBanxItFYqkkhhxTIxELPnf
        tEQklQrjJEgiFSEqlMsIHSmBZLpcT2fStJbWrZljHF+eAcuMTSoWb2jt7F6SzbT3F9w7HYa3
        kpPV4jz1yafum0f37fGvxeqyxeaHVvJGWYA5yJ7X80ZahLDJ77Qzd1fkN8nl1T9+fId6J7yT
        V/tmqT/I/bD70kejucO2yg2irmnhmb4e1u+VA90Db+X68jrNUzOJ88qQyx98zTs8H/7TgG9P
        6PI1Z8shU5zJVPQyJ3726e3fb4+fbDALdxw/vO4UK9O0V7UY/Ddzykf8imWL1uV/+6rI6Qq7
        JQ64/7pxUIcejfZdCr2cmG+bKbOYOjJ3l2iki3dgA7zpFM9ti3cQ1tGNt6xBXclDZCvRlpyf
        tffPZ8ijBhrkPVKF5Tx3smV28L1aimCU8ujNuI6R/wPhmILGzwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0
References: <DM6PR04MB6575BBF6F89002222EA5FC1DFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
        <20210224045532epcms2p2215025506b062e2fdbad73e51563dca6@epcms2p2>
        <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >         if (dev_info->wspecversion >= UFS_DEV_HPB_SUPPORT_VERSION &&
> >             (b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT)) {
> > -               dev_info->hpb_enabled = true;
> > +               bool hpb_en = false;
> > +
> >                 ufshpb_get_dev_info(hba, desc_buf);
> > +
> > +               err = ufshcd_query_flag_retry(hba,
> > UPIU_QUERY_OPCODE_READ_FLAG,
> > +                                             QUERY_FLAG_IDN_HPB_EN, 0, &hpb_en);
> > +               if (ufshpb_is_legacy(hba) || (!err && hpb_en))
> If is_legacy you shouldn't send fHPBen in the first place, not ignoring its failure.
OK,

> Also, using a Boolean is limiting you to HPB2.0 vs. HPB1.0.
> What would you do in new flags/attributes/descriptors that HPB3.0 will introduce?
It can be managed as enum. but it is enough now, I think.

> > +                       dev_info->hpb_enabled = true;
> >         }

Thanks,
Daejun
