Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89051C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 12:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9B261056
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 12:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbhJOMPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:15:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28519 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbhJOMPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 08:15:54 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211015121346epoutp01449f54c6e08afb75d5617437b72f9160~uMzcTOMmb0186101861epoutp01L
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 12:13:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211015121346epoutp01449f54c6e08afb75d5617437b72f9160~uMzcTOMmb0186101861epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634300026;
        bh=oa3DyicMOOuSUPvppfQ1Z8EEGzaSalyYJt+N1g+t0Qc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=S2JV+b02F10RtyGN+2LA0vsSmZzn0Hhmj5MWaBTXIx4LmI3EXWBM9OXA18fNmdqIJ
         gEpNwRpD+DexEKaK77vLWlkSjnJi7JX1CSImqXWs8pifWjLAG7pWcrQ+rVxvTKAKD8
         WvlGFpGrQ4mRdWI8z2QykTD0ThTsXd/Ortl6JCFk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20211015121345epcas2p30cfbef5b45b09064ef5d5b07b17ba2f4~uMzbkHVuB0351603516epcas2p3Z;
        Fri, 15 Oct 2021 12:13:45 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.102]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HW4tX483tz4x9Py; Fri, 15 Oct
        2021 12:13:40 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.2D.09749.47079616; Fri, 15 Oct 2021 21:13:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211015121339epcas2p28599cd8a13d7ce3420d356574d54bb59~uMzViJhjq0406104061epcas2p2l;
        Fri, 15 Oct 2021 12:13:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211015121339epsmtrp16e9c539110c53ccb1f370dc4fa1d2a8c~uMzVdQWKi0342603426epsmtrp1l;
        Fri, 15 Oct 2021 12:13:39 +0000 (GMT)
X-AuditID: b6c32a47-d13ff70000002615-54-61697074dddb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.52.08750.27079616; Fri, 15 Oct 2021 21:13:38 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211015121338epsmtip1cdd539d2160242aa0d804f00172c9e1a~uMzVI2GRb0465404654epsmtip1Z;
        Fri, 15 Oct 2021 12:13:38 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>, <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        "'Sowon Na'" <sowon.na@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <DM6PR04MB6575717817EDD8C549F2D539FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH v4 15/16] scsi: ufs: ufs-exynos: introduce exynosauto v9
 virtual host
Date:   Fri, 15 Oct 2021 21:13:38 +0900
Message-ID: <001c01d7c1be$16180960$42481c20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL83TaU2gFk6OcLuUCqdNaZ93XEzwJK4w65AQMLwUMB/rPM6KlfXE3g
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJsWRmVeSWpSXmKPExsWy7bCmmW5JQWaiwf/3khYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLXp2OlucnrCIyeLJ+lnMFotubGOyuPGrjdVi49sfTBY3
        txxlsZhxfh+TRff1HWwWy4//Y7L4/fMQk4Ogx+Ur3h6zGnrZPC739TJ5bF6h5bF4z0smj02r
        Otk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAE9Utk1GamJKapFCal5yfkpmXrqt
        kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0GNKCmWJOaVAoYDE4mIlfTubovzSklSF
        jPziElul1IKUnALzAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM22smMxbc4qjomXyVsYHxCmsX
        IyeHhICJxKZJv9m6GLk4hAR2MErsat3ODuF8YpS48vcYM4TzmVHi3NdJLF2MHGAtW6/qQMR3
        MUpsWfKTFcJ5wSgxcVcXG8hcNgF9iZcd28ASIgL/gRI9L5hBEswCl5glNt1kBLE5BWIlZs/+
        CNYgLBAtseD9ZHYQm0VAVWLbpnNgcV4BS4n7yx+yQ9iCEidnPmGBmCMvsf3tHGaIJxQkfj5d
        BvaQiICbxM1VzewQNSISszvboGqmc0pMvghlu0jsb9kJZQtLvDq+hR3ClpJ42d8G9r+EQDej
        ROuj/1CJ1YwSnY0+ELa9xK/pW1hBQcEsoCmxfpc+JFSUJY7cgjqNT6Lj8F92iDCvREebEESj
        usSB7dNZIGxZie45n1knMCrNQvLYLCSPzULywCyEXQsYWVYxiqUWFOempxYbFRjDIzs5P3cT
        IzjNa7nvYJzx9oPeIUYmDsZDjBIczEoivO8OpCcK8aYkVlalFuXHF5XmpBYfYjQFBvVEZinR
        5HxgpskriTc0sTQwMTMzNDcyNTBXEufNd85MFBJITyxJzU5NLUgtgulj4uCUamBiec2fdc4n
        g+dVjemn9mUmRTIy1mzdWQtCHZxKGS4uYFovtlcm9e7J8ycVJcJceV5wcH/9rL/NIULs3c0/
        S+Wa2+2PPvjyL98gy3Ch9df8MO3QtTOuWQV3ndlpvOTxJH+O1zu7BP5tOZohkjvlZuac5681
        jIN8HBXqTZyuNynvL+LeVl206+j3tauPcfjcPe/PZTZn2rKa3fOLejQqprRz+2b2N05dI/ys
        L2x7yAzn9dtT156deXL9d9GggyqnXWbPXhWS/uXr9ptLdyd2vwqbuW6ObexeduVPzYqLE/9v
        rOzNmygjW2qsdTn7SLW1fev5bY9m7zw/xXXJhM8HQhS2WG7/us5OSCRyWbPUlDsZSizFGYmG
        WsxFxYkAnv5Z5XwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWy7bCSnG5RQWaiwfkfxhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLXp2OlucnrCIyeLJ+lnMFotubGOyuPGrjdVi49sfTBY3
        txxlsZhxfh+TRff1HWwWy4//Y7L4/fMQk4Ogx+Ur3h6zGnrZPC739TJ5bF6h5bF4z0smj02r
        Otk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAE8Ul01Kak5mWWqRvl0CV8btNZMZ
        C25xVPRMvsrYwHiFtYuRg0NCwERi61WdLkYuDiGBHYwSX+YsYO5i5ASKy0o8e7eDHcIWlrjf
        coQVougZo8SqOZ8YQRJsAvoSLzu2gSVEBBqZJM41N7GAOMwCd5glFpw8ywLRMp1JonPWbCaQ
        Fk6BWInZsz+ygewWFoiUuL27EiTMIqAqsW3TOTYQm1fAUuL+8ofsELagxMmZT1hAbGYBbYmn
        N59C2fIS29/OgTpVQeLn02WsILaIgJvEzVXN7BA1IhKzO9uYJzAKz0IyahaSUbOQjJqFpGUB
        I8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgqNfS2sG4Z9UHvUOMTByMhxglOJiV
        RHjfHUhPFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoGp
        9N2K2x7pT9SOKTp4nV27uLJmasGcFrtpt5Y1WzLyZmqELmfx6OVwfxtTbL33evNE1X3fVpuu
        WRAh3n9Gvv3xuQlXP+65MnP/ptDY14/CXy7klsxZ2xO04YD42rAzE8VDjxhN3qL4Tn2Tkz7b
        /Dtdk9vWRT6VqN7KMefckevn9xU8U1bu1na6WVYqwz81JuDfzgVeq4W2Bs1cvXuPWNES+acb
        ig8EMHjd1a32fnYl+K1zci7vkxksNw1ei74/85HzuN1Uq4qHO1hPbi0QYTUz/us2y/tg2qPN
        Sz1+33cyb3d2m3dmZ2LymeOezlNSQoz2ujQkR/ddEE678+7PTh35c+vn7nHRm5y52WESM7+m
        lxJLcUaioRZzUXEiAKcMEPlpAwAA
X-CMS-MailID: 20211015121339epcas2p28599cd8a13d7ce3420d356574d54bb59
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p372f122a0f601f0108bdd593ca0105f3c
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p372f122a0f601f0108bdd593ca0105f3c@epcas2p3.samsung.com>
        <20211007080934.108804-16-chanho61.park@samsung.com>
        <DM6PR04MB6575717817EDD8C549F2D539FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static int exynosauto_ufs_vh_link_startup_notify(struct ufs_hba *hba,
> > +                                                enum
> > +ufs_notify_change_status status) {
> > +       if (status == POST_CHANGE) {
> > +               ufshcd_set_link_active(hba);
> > +               ufshcd_set_ufs_dev_active(hba);
> > +               hba->wlun_dev_clr_ua = true;
> wlun_dev_clr_ua no longer exists - needs rebase

I found the commit. I'll remove this next patch.

> 
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int exynosauto_ufs_vh_wait_ph_ready(struct ufs_hba *hba) {
> > +       u32 mbox;
> > +       ktime_t start, stop;
> > +
> > +       start = ktime_get();
> > +       stop = ktime_add(start, ms_to_ktime(PH_READY_TIMEOUT_MS));
> > +
> > +       do {
> > +               mbox = ufshcd_readl(hba, PH2VH_MBOX);
> > +               if ((mbox & MH_MSG_MASK) == MH_MSG_PH_READY)
> > +                       return 0;
> Maybe add a comment here that the mbox protocol will be defined later.

Put some comments with TODO: tag.

Best Regards,
Chanho Park

