Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E164C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63BCF64DE7
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhBWIB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:01:58 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58832 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhBWIBs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:01:48 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210223080104epoutp0351432cfed97d600fec06d058abdd8a90~mUaAG7jg22619126191epoutp03n
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:01:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210223080104epoutp0351432cfed97d600fec06d058abdd8a90~mUaAG7jg22619126191epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614067264;
        bh=iFl192zw7aIW1gOO4DWG4A2+m39kuiBmNdE5zInd9SQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=UeP0hOTN+50IMoZ2gb9zSJH2Ty5zIMIXDONRbRTmMjGd6WM7IVbWmCmoW//aaoDOx
         c1cilSlsxy10Yras+eP0ip921p4dgMM5UZ/1hFkfL6YZ6jgj0v4jB73bgPELugPhE4
         7E8j68YLr4ndoCBJqoOGABWgciRSNPwGhCrypyBI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210223080053epcas2p3f347d14509ea5bf51b41512b97aa3a79~mUZ2bl1BV0968809688epcas2p3a;
        Tue, 23 Feb 2021 08:00:53 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DlBLq4MXFz4x9Ps; Tue, 23 Feb
        2021 08:00:51 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-67-6034b631cbe1
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.90.05262.136B4306; Tue, 23 Feb 2021 17:00:49 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v22 2/4] scsi: ufs: L2P map management for HPB read
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
In-Reply-To: <DM6PR04MB657508BC3F0D0240FDCBB043FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223080043epcms2p83f813841174ade50ef97481b3f4cdef7@epcms2p8>
Date:   Tue, 23 Feb 2021 17:00:43 +0900
X-CMS-MailID: 20210223080043epcms2p83f813841174ade50ef97481b3f4cdef7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmha7hNpMEg493VSwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyTh4ZwFbwXXR
        iqM7T7E1MC7i62Lk4JAQMJG43m3XxcjFISSwg1Hi9YtLTCBxXgFBib87hLsYOTmEBbwlXp6b
        wwJiCwkoSay/OIsdIq4ncevhGkYQm01AR2L6ifvsIHNEBFawSFz8dYkNxGEW+MUkceLxB7Aq
        CQFeiRntT1kgbGmJ7cu3gsU5BWIlrh07ARXXkPixrJcZwhaVuLn6LTuM/f7YfKg5IhKt985C
        1QhKPPi5GyouKXFs9wcmCLteYuudX4wgR0gI9DBKHN55ixUioS9xrWMj2DJeAV+JmbvvgjWz
        CKhK7Lh4AWqZi8SmV//B4swC8hLb385hBoUKs4CmxPpd+pCAU5Y4cosF5q2Gjb/Z0dnMAnwS
        HYf/wsV3zHsCdZqaxLqf65kmMCrPQgT1LCS7ZiHsWsDIvIpRLLWgODc9tdiowBg5cjcxglO7
        lvsOxhlvP+gdYmTiYDzEKMHBrCTCy3bXKEGINyWxsiq1KD++qDQntfgQoynQlxOZpUST84HZ
        Ja8k3tDUyMzMwNLUwtTMyEJJnLfY4EG8kEB6YklqdmpqQWoRTB8TB6dUA1PM1yY5U2WGJl6t
        tvoeyb7+g/ZFva93L0pZ7KDBW6P04Skn835JppaZYc93bOIOKtza8ETNTPTRT4f52+//5dsq
        u+FWxKvMBgNunaXcixJV1itHmiU37tvLHKLxzPTUwxgT9u83qxhSv87jd37ce3CzFcuuqN7A
        OTvephiaayiZp8z5/rD33Q+t3NMbNR6fNcjn+8yjzbJXx+EMd5KjvuazNYlX0i2PL//UPsnG
        8eA93iy7FeJHrsR2/jaYE3J4v2n5/P99+w7q3zjz6nZ+qITCquOfrgedrLL/IP+yu+TtfSax
        KxM9i09W3arYvULzwh2bJ+yOHOmcs2d8rWWQDPq1auXtGxc/ftw08c65lCtKLMUZiYZazEXF
        iQDc8/W2dgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB657508BC3F0D0240FDCBB043FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +/*
> > + * This function will parse recommended active subregion information in
> > sense
> > + * data field of response UPIU with SAM_STAT_GOOD state.
> > + */
> > +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +{
> > +       struct ufshpb_lu *hpb;
> > +       struct scsi_device *sdev;
> > +       struct utp_hpb_rsp *rsp_field = &lrbp->ucd_rsp_ptr->hr;
> > +       int data_seg_len;
> > +       bool found = false;
> > +
> > +       __shost_for_each_device(sdev, hba->host) {
> > +               hpb = ufshpb_get_hpb_data(sdev);
> > +
> > +               if (!hpb)
> > +                       continue;
> > +
> > +               if (rsp_field->lun == hpb->lun) {
> > +                       found = true;
> > +                       break;
> This piece of code looks awkward, although it is probably working.
> Why not just having a reference to the hpb luns, e.g. something like:
> struct ufshpb_lu *hpb_luns[8] in struct ufs_hba.
> Less elegant - but much more effective than iterating the scsi host on every completion interrupt.

OK,

> > +               }
> > +       }
> > +
> > +       if (!found)
> > +               return;
> > +
> > +       if ((ufshpb_get_state(hpb) != HPB_PRESENT) &&
> > +           (ufshpb_get_state(hpb) != HPB_SUSPEND)) {
> > +               dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> > +                          "%s: ufshpb state is not PRESENT/SUSPEND\n",
> > +                          __func__);
> > +               return;
> > +       }
> > +
> > +       data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
> > +               & MASK_RSP_UPIU_DATA_SEG_LEN;
> > +
> > +       /* To flush remained rsp_list, we queue the map_work task */
> > +       if (!data_seg_len) {
> data_seg_len should be 0x14

It is checking non-HPB hint UPIU. It is used for kicking map work.

> > +               if (!ufshpb_is_general_lun(hpb->lun))
> > +                       return;
> > +
> > +               ufshpb_kick_map_work(hpb);
> > +               return;
> > +       }
> > +
> > +       /* Check HPB_UPDATE_ALERT */
> > +       if (!(lrbp->ucd_rsp_ptr->header.dword_2 &
> > +             UPIU_HEADER_DWORD(0, 2, 0, 0)))
> > +               return;
> > +
> > +       BUILD_BUG_ON(sizeof(struct utp_hpb_rsp) != UTP_HPB_RSP_SIZE);
> > +
> > +       if (!ufshpb_is_hpb_rsp_valid(hba, lrbp, rsp_field))
> > +               return;
> How about moving both the data_seg_len and alert bit checks into ufshpb_is_hpb_rsp_valid,
> And moving ufshpb_is_hpb_rsp_valid to the beginning of the function?
> This way you would save redundant stuff if not a valid response. 

I will move alert bit check into ufshpb_is_hpb_rsp_valid.

Thanks,
Daejun
