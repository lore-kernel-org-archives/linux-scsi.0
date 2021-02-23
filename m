Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF7CC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE4C64E31
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 09:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhBWJyq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 04:54:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29404 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbhBWJwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 04:52:36 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210223095149epoutp047116dc7e43b758539c4caa4fd54d1b84~mV6tJeJw21311913119epoutp04u
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 09:51:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210223095149epoutp047116dc7e43b758539c4caa4fd54d1b84~mV6tJeJw21311913119epoutp04u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614073909;
        bh=tJscn9zXXXvBOEaGL6PR+i/6TO96E2Nj3u5CLuZI3Tw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=MTnKrzNzGw9csDQO9yz/eAFhH5NQKaTt90ZmH9xDZvSDWQenTB44iY1Nth4Gx5tBs
         gqH9RbxvR9cykC9NN7I7Tg9kby+p6KX2VAYeJEUeT4F0VQAjcg5ehE5SHOfvriHTBW
         0Sh626MBybUCPVAwN8J2nEuAWkmF78SBWSFyXVLw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210223095148epcas2p30697b146afda9bc25b44785964b700c6~mV6sSJBZN1885918859epcas2p3J;
        Tue, 23 Feb 2021 09:51:48 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DlDpq3y2zz4x9Q3; Tue, 23 Feb
        2021 09:51:47 +0000 (GMT)
X-AuditID: b6c32a48-a9948a800000cd1f-2b-6034d033349e
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.AE.52511.330D4306; Tue, 23 Feb 2021 18:51:47 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: RE: [PATCH v22 3/4] scsi: ufs: Prepare HPB read for cached
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
In-Reply-To: <DM6PR04MB6575E9C2150DE55566E62D47FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223095147epcms2p827cd2ccfc6ad25e4ff8590cca8856e27@epcms2p8>
Date:   Tue, 23 Feb 2021 18:51:47 +0900
X-CMS-MailID: 20210223095147epcms2p827cd2ccfc6ad25e4ff8590cca8856e27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmha7xBZMEg2nzZSwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyZjz9D1jwU/2
        iitbG9kaGGexdjFyckgImEjcP/OepYuRi0NIYAejxIUdJxm7GDk4eAUEJf7uEAapERaIkGh9
        t5gZxBYSUJJYf3EWO0RcT+LWwzWMIDabgI7E9BP32UHmiAisYJG4+OsSG4jDLPCLSeLE4w+M
        ENt4JWa0P2WBsKUlti/fChbnFIiVuHPnNNRFGhI/lvUyQ9iiEjdXv2WHsd8fmw81R0Si9d5Z
        qBpBiQc/d0PFJSWO7f7ABGHXS2y984sR5AgJgR5GicM7b0Et0Je41rER7AheAV+g4+aANbAI
        qEp86dwKNdRF4vCG9WBDmQXkJba/ncMMChVmAU2J9bv0QUwJAWWJI7dYYN5q2PibHZ3NLMAn
        0XH4L1x8x7wnUKepSaz7uZ5pAqPyLERQz0KyaxbCrgWMzKsYxVILinPTU4uNCkyQY3cTIzi5
        a3nsYJz99oPeIUYmDsZDjBIczEoivGx3jRKEeFMSK6tSi/Lji0pzUosPMZoCfTmRWUo0OR+Y
        X/JK4g1NjczMDCxNLUzNjCyUxHmLDB7ECwmkJ5akZqemFqQWwfQxcXBKNTDtYl0/6ZXzzWdf
        diTfkWw8f9OvYkWc5XaZKzZPOeyS6uvlXtxff076jYBHvMe7vUevzjhZ0fQ4TY8/6Ua7lC/T
        mn1+01fdvMLwvqlxgXB799YVSULxO82+nCqKfdk0QzPh/saoI5r1J/Ybr7ZZ9e6V1vne5Z+2
        LQ1yVd/91TqjTCD0uPDNyIbip3Yuv3rtxXrND+e3KTuHfWe7dDG6qrrDZ02fxYGyf0dTRdKF
        j9j+qZx8W8wlImXLKZZnaRL73+udnFB31l/vSvnbOm+pT0e9Z5p4nS6Z5ZPLWmGnVrBpvjDH
        KSZj1qAzJvxlcjtVwoT7t+4U3u4ef/qt4Pfc8n96sgVtB1M8fTbtXqudK6/EUpyRaKjFXFSc
        CADfHUaJdwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB6575E9C2150DE55566E62D47FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <DM6PR04MB65754012DD7AC9EEF9D47D0FFC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093117epcms2p80c6904ac3ac7b10349265ed27e83eea4@epcms2p8>
        <20210223084327epcms2p5b158fa6769d3deee54796b364f0ae369@epcms2p5>
        <DM6PR04MB6575F87694FB14ECF068F681FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > > > +       err = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset, 1,
> > > &ppn);
> > > > > +       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > > > > +       if (unlikely(err < 0)) {
> > > > > +               /*
> > > > > +                * In this case, the region state is active,
> > > > > +                * but the ppn table is not allocated.
> > > > > +                * Make sure that ppn table must be allocated on
> > > > > +                * active state.
> > > > > +                */
> > > > > +               WARN_ON(true);
> > > > > +               dev_err(hba->dev, "get ppn failed. err %d\n", err);
> > > > Maybe just pr_warn instead of risking crashing the machine over that?
> > >
> > > Why it crashing the machine? WARN_ON will just print kernel message.
> > I think that it can be configured, but I am not sure.
> I think it can be configured via the parameter panic_on_warn

OK, I will change WARN_ON to dev_err for print message.

Thanks,
Daejun
