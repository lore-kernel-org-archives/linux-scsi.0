Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A136BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 23:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FE3F64E02
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 23:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhBWXrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 18:47:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50958 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhBWXjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 18:39:25 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210223233812epoutp043bfcb8f6f694c2ba76ee8faceda6a0d6~mhMOmxWu11756717567epoutp049
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 23:38:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210223233812epoutp043bfcb8f6f694c2ba76ee8faceda6a0d6~mhMOmxWu11756717567epoutp049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614123492;
        bh=Cmg8gly31DwYa1wINVEhhyx2jlgSoA5nhTLbBh5scmY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=u9bfjbHW2USj2S0G+unbzAmcDFCVmMqpgBpcw3rT11HY8fSulY4SwzecFUJWRV34y
         ovn4m70OQwfRsw6Oqrbyf7Fql9Z/0DddYhWTqfBqJTeVx/Lss2xuZ29DWqjQ0F5txn
         TknM4Lj7/FPdfxgcqjpFrGHFYkFAIIITeT7RyLs4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210223233811epcas2p4ed57f4c92f00d7d09ed707e6caaa8e01~mhMNvmyfY2813528135epcas2p4Q;
        Tue, 23 Feb 2021 23:38:11 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Dlb8L20t5z4x9Q5; Tue, 23 Feb
        2021 23:38:10 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-dc-603591e2f1a2
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.91.05262.2E195306; Wed, 24 Feb 2021 08:38:10 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
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
In-Reply-To: <DM6PR04MB6575E664773FFD81FB16EBF4FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223233809epcms2p1482aac5e531d692f00cf0fc5ee8c7f4a@epcms2p1>
Date:   Wed, 24 Feb 2021 08:38:09 +0900
X-CMS-MailID: 20210223233809epcms2p1482aac5e531d692f00cf0fc5ee8c7f4a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA51Te0xbZRT3u7f0Qex2KeC+odF6CTLmKKVQ+NBVSdhck0WdC7qXC23KDSVC
        291bCMMwGpmD8Z5mAzvGgCnTDqkjUB5VykseJgsgMqQMhhtgMGN2YsboHEofuMU//e/3/c7v
        nN8558vh4oJOThA3VaOnaI0yjWT7siy9YSj81hmpQtzU5Ytmqy1s9N2pQQ5aXB1no96puxx0
        zrGKoz/M9T5osScMmWYPoLxLZjaqumbAUElZCxvdvrHMQXU/WzBUtpbPQmMdVWxUNNHGRpcH
        1jA01eyLvmiZBOh0RQML1dVaWfGB8rGf9srHSkswebtxmiMvr+sCctuFBo785JCNJb83b2fJ
        S5tNQL7c9Lw8v6sI2+d72AB2KmmVOjWTElIalTY5VZMiI99NfCMckUK1ltHLyCORSCKKjJOK
        ouNEktijr0SKxRIpKdQo0ykZmRXuzSaFtEq3rtZTjJ6mVNQ6RcczemUKJWKU6UyGJkWk0qaT
        wkxlWsZ6Hhnx2k41pUymaKFiDqhHau0c3Tgvq9lWCQzAwC4EPC4koqH5wRCnEPhyBUQbgPed
        03gh4HL5hB981Obv0vgTiXB4aga4sIAgoXnUyPHwImj/pcHNs4kdsGLwprtOAPElC446f2S7
        HjjhxODgbQfwuPFhZf48y4Ofha2XW4DLjEcchb2TsR56G3xQX4J7cCCcvLLE2cC/91/0lgmA
        H89c82r84Oyq1ctvhf1WB+bBubDlhhO4eoBEMYC97XYfTyACXi+46u6BT7wJu88Vuw1YRAg8
        1THhTd4F8+x/ufU48QJsXapyLwUnwqC5I8IFIREM++ysjakMVx9y/otxYhMs6H30L99WPeet
        /hJsXDVj5SDY+HjTxie8jI+9agBuAs9QOiY9hWIkuqgnP7oJuG9g+542ULnkEPUAjAt6AOTi
        ZACfPS1RCPjJyuPZFK1NojPSKKYHZK9PeQYPClRp149Io0+KjBFLYqRR0VFR0mjp/6alkpgY
        cZwUSWMkiNzCZ8SzSQIiRamnPqAoHUVvmGNcXpAB05WCSVNT447zCSOyfW+bsOOUoj+gI+Or
        0N0RffA9A0/1iZ//BZxxpA07tJtz8g4W1nwb8nSBiAmZOjize+3u9YVtFvHor0V/atKf0tbf
        v3TTyaO1dFBq2THzFTzs0Mlye2pnzsMTKwfqHd2KgMMjuXts1tk7C+VnP3MqxO9bu7vxhT5j
        fMUxE2vv6RNS1eb9b4WaSs82HsloKf4evaj9OzhhOsGn+uss4LBYcmz0eay9XbQsIHf9MDG3
        GLo/ufJiYI2t9vN3hl/Ojv9wq6Pk1qulnV0DDZ/2lSVSv82Pv34vTNu3ZVOCbEhd9Nwde07X
        yoqPKXYgU5Zr/eibVknuWOYhksWolZHbcZpR/gM2cpbX0QQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB6575E664773FFD81FB16EBF4FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
> > +                                    struct ufshpb_map_ctx *mctx, int pos,
> > +                                    int len, u64 *ppn_buf)
> > +{
> > +       struct page *page;
> > +       int index, offset;
> > +       int copied;
> > +
> > +       index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
> > +       offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
> Maybe cache hpb->entries_per_page in ufshpb_lu_parameter_init as well?

They are just defined constants and complier will optimize them.

Thanks,
Daejun

> > +
> > +       if ((offset + len) <= (PAGE_SIZE / HPB_ENTRY_SIZE))
> > +               copied = len;
> > +       else
> > +               copied = (PAGE_SIZE / HPB_ENTRY_SIZE) - offset;
> > +
> > +       page = mctx->m_page[index];
> > +       if (unlikely(!page)) {
> > +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> > +                       "error. cannot find page in mctx\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       memcpy(ppn_buf, page_address(page) + (offset * HPB_ENTRY_SIZE),
> > +              copied * HPB_ENTRY_SIZE);
> > +
> > +       return copied;
> > +}
>  
>  
>   
