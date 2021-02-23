Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD7CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38894614A7
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhBWIoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:44:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54021 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhBWIoO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:44:14 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210223084331epoutp032148277bf020db83d252345633c214cd~mU-E1j5aS2683226832epoutp03O
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:43:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210223084331epoutp032148277bf020db83d252345633c214cd~mU-E1j5aS2683226832epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614069811;
        bh=i/t0FHqdJlrUjo5KKe03+T6Ypr/ANYhRXZ7FtAinlKs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=GQ/C4PT4pJJbAI/0bvtZUE8dPGzWpd6UmOvdRfi7hVVlALcakA0M77VpNYUdqkwHw
         oxACvV0gX+2tDMqw5AONbkTuukz13JjOKc/tTtFbYyIFY+a+LYqHnPLVUfkst2gCxa
         SCg67CJNqVOQQarz/Ro9X03Hx6O25Dg491ubS8qE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210223084331epcas2p2a4f0bac78b812d8fc24d1fb1d2dbf8a6~mU-EEBHsi0680606806epcas2p2c;
        Tue, 23 Feb 2021 08:43:31 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DlCJ14Fp7z4x9Pw; Tue, 23 Feb
        2021 08:43:29 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-05-6034c02f9849
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.BF.52511.F20C4306; Tue, 23 Feb 2021 17:43:27 +0900 (KST)
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
In-Reply-To: <DM6PR04MB65754012DD7AC9EEF9D47D0FFC809@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223084327epcms2p5b158fa6769d3deee54796b364f0ae369@epcms2p5>
Date:   Tue, 23 Feb 2021 17:43:27 +0900
X-CMS-MailID: 20210223084327epcms2p5b158fa6769d3deee54796b364f0ae369
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xTVxzHd+8tt+VRcnm5Q9kmuWRGzIC2oXBQQRiG3QSdJJAtLHFwgTuK
        K23tLW5uMWCYAgrC4jJnhyg4HwNGQxEodI6uXaC6MKYoShEoE6YswnhsgUJga2mZZv99z+d8
        z/l9f+fBw/wncAGvQK5mVHJaRuJenA5zeGxElDE6W3hJJ4a2ug4c3jxp4cJp+30cmkdmufDL
        OTsGF7RXPeC0KRw22t6FpZe1OKztL0FhVXU7Dh8/WuTChocdKKxeL+PAwe5aHJ5+oMfhtb51
        FI7c8IJX2ocRWHGumQMb6g2cxCBq8F4qNXimCqW6NKNcqqbBiFA9F5q51Ge3ejjU/JSVQ525
        0YhQi7rXqDLjaTTN6z3ZbilD5zGqUEaeq8grkOfHk6npWclZkhihKEIUB2PJUDldyMSTe/el
        RaQUyBwdkqFHaFmRA6XRLEtGJexWKYrUTKhUwarjSUaZJ1OKRMpIli5ki+T5kbmKwp0ioVAs
        cTizZdKRfyoR5bTHx7/M6pASZBw7hXjyABENxp8ZUKf2J/QIMA2HnkJ4PD7hB9b0AU4cQGSA
        gZExxGUhgfaOhuvikcA60bzBceINcM4y7uBevEDiOgfcWbmLOwcYsYICy+M5xFWMD74qm+K4
        dAjovNa+wT2Jg2Cg/J470HawfLXKrYPAcNMMd1P/2XvRvU8gODHW7/b4AZvd4ObBoNcwh7p0
        MWh/tII4QwCiEgHmLquHayIKDJW3boTgE/vB9MXfcWfHHOJ1MK55xykBsRc0zbNOB0ZsBZ0z
        tZgTY0Q40HZHuRxh4CcrZ7OpktZV7v81RviCcvPaf1xfN+kOtg202LVoDRKmeX7QmhdqaZ7X
        uoRgjcgWRskW5jOsWBn94tXqkI23voPSI1/PzEWaEJSHmBDAw8hAPj4qzvbn59FHP2FUiixV
        kYxhTYjE0ePnmCAoV+H4LHJ1lkgijokRxkmgJEYMyZf5KqEty5/Ip9XMhwyjZFSb61Cep6AE
        /WJl1/nJkObVQ4GV/cfMtuMtP3639Ye/475Z3rdr6GcTbjt0WZqXzm2ipob/EjCtQeP65bvB
        wXRykzJFJfJ72pvU970u7Gbxt8tvGQOyH8zdevNwztnKbQ+jBG3HkjPbrMRt78jflmpyPuI/
        Pf7kyisJK4LZyRPUga6EnYaj3olJS5928rUZW5rA4friodGBPfYS/gFTj27sZN32gPCz/d1P
        9PMpr/a9lG6sH/lgraXUR3F/Mjknc/66rWFhNWJ9grHvMRxZ0AkqSHmI9tfbpdVJlgi92ceY
        GmtFibRFy5JvVeL5CkNmRl/lM33A26qDlkRfvrmFUDdme+v/aHtfuuzjS3JYKS3agalY+l8b
        lyPAdAQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB65754012DD7AC9EEF9D47D0FFC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +       err = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset, 1, &ppn);
> > +       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > +       if (unlikely(err < 0)) {
> > +               /*
> > +                * In this case, the region state is active,
> > +                * but the ppn table is not allocated.
> > +                * Make sure that ppn table must be allocated on
> > +                * active state.
> > +                */
> > +               WARN_ON(true);
> > +               dev_err(hba->dev, "get ppn failed. err %d\n", err);
> Maybe just pr_warn instead of risking crashing the machine over that?

Why it crashing the machine? WARN_ON will just print kernel message.

Thanks,
Daejun
