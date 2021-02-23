Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3799C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CBDC64DE7
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhBWICv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:02:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19032 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbhBWICZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:02:25 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210223080142epoutp01d8f0915892968c325bdecf0c098c75ff~mUajrpLrP1505815058epoutp01b
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:01:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210223080142epoutp01d8f0915892968c325bdecf0c098c75ff~mUajrpLrP1505815058epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614067302;
        bh=BLM36x8dvCNr4CWXv/S8Fx4FBYxrQSVgZltEo2o1V+Q=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=LBfheKyodtWOBxnM2ySZN5FH9esuyNkdP1EKiXgXxl+f1EaT0d9mhMZtECM40xM1e
         oF7pOlbFBW7FL90jYvplWBjv/DOERG7HjS8G/g7T0U3vZ1AOdJVnqF1dDKj5hslkYc
         i3bxK+MS9qfVBe2+aStcIlk+6wrfHPOGGgsxi+tQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210223080138epcas2p2b11c5609ea8fcb9d7135bd9a6c6412c9~mUagdlAf43168131681epcas2p2r;
        Tue, 23 Feb 2021 08:01:38 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DlBMj5hhYz4x9Q2; Tue, 23 Feb
        2021 08:01:37 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-50-6034b66014fd
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.C8.52511.066B4306; Tue, 23 Feb 2021 17:01:36 +0900 (KST)
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
In-Reply-To: <DM6PR04MB65754213307A31CE51C829D0FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223080133epcms2p47e1585978cb3a2eb39e060272f8e8a1f@epcms2p4>
Date:   Tue, 23 Feb 2021 17:01:33 +0900
X-CMS-MailID: 20210223080133epcms2p47e1585978cb3a2eb39e060272f8e8a1f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmhW7CNpMEg2XbtS0ezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyXjQo1bwnqni
        Q+dD5gbGZ4xdjJwcEgImEqsmXwCzhQR2MEo8nCHXxcjBwSsgKPF3hzBIWFjAW+LluTksECVK
        EusvzmKHiOtJ3Hq4BqyVTUBHYvqJ+0BxLg4RgRUsEhd/XWIDcZgFfjFJnHj8AWoZr8SM9qcs
        ELa0xPblW8HinAKxEkd3/GGGiGtI/FjWC2WLStxc/ZYdxn5/bD7UHBGJ1ntnoWoEJR783A0V
        l5Q4tvsDE4RdL7H1zi9GkCMkBHoYJQ7vvMUKkdCXuNaxEewIXgFfiRfn+8AWsAioSvyfcg/q
        OBeJtWeawWxmAXmJ7W/nMINChVlAU2L9Ln0QU0JAWeLILRaYtxo2/mZHZzML8El0HP4LF98x
        7wnUaWoS636uZ5rAqDwLEdSzkOyahbBrASPzKkax1ILi3PTUYqMCE+S43cQITuxaHjsYZ7/9
        oHeIkYmD8RCjBAezkggv212jBCHelMTKqtSi/Pii0pzU4kOMpkBfTmSWEk3OB+aWvJJ4Q1Mj
        MzMDS1MLUzMjCyVx3iKDB/FCAumJJanZqakFqUUwfUwcnFINTDy/jiguvxd/yl/1/ZZ7U0oC
        e3tM5HIWfdNZ6HToTG9bbYfCee+XxndPtFjoVTBv/LN09f9gETM+pbc+Vt/OPEzZ96iCm/X5
        9+enOFMrLh+0EdrnzVBQISi41fLmHkmt098sWrbdr36Tu/4kQ9mTqdtXeyjV/Z98hSdJSE2/
        L+m0C4ekC8/VqS+0vggeP7hKe5mdctGVxSHGd5i6xHMiV72esvzS0XiDFI91szlz+/UcVm2p
        e7FRfEOYhPXZKaXzkuyui3/gsgrUe3f8jJCPYKz3m7OXmb/PYijL2Kw0Nz523bzdN999/Cax
        5M+Jz/X35T6pPLmtZJLC15Sg+HqCdvmRDUd7Ln7bFT6v/JG/jacSS3FGoqEWc1FxIgCmZsqO
        dQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB65754213307A31CE51C829D0FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +       if (!ufshpb_is_hpb_rsp_valid(hba, lrbp, rsp_field))
> > +               return;
> > +
> > +       hpb->stats.rb_noti_cnt++;
>  
> > +       switch (rsp_field->hpb_op) {
> > +       case HPB_RSP_NONE:
> > +               /* nothing to do */
> > +               break;
> Maybe checks this too in ufshpb_is_hpb_rsp_valid

Sure

Thanks,
Daejun
