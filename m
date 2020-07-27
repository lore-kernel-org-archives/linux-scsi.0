Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5B7C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D7A20672
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NlaQKc2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG0KCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:02:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23927 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0KCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 06:02:05 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200727100202epoutp01da45f9a694e9565ebc1069c0e5036ae6~lk8YgHU7V1041710417epoutp01f
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 10:02:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200727100202epoutp01da45f9a694e9565ebc1069c0e5036ae6~lk8YgHU7V1041710417epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595844122;
        bh=+em7/DZRZwFlu9EgF7wiFFdw0IX3nurMIFe5dPpF/TA=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=NlaQKc2oQYgCh4jmjI5OatLjYyY61KXbGSuTrlZ7IZi5wqEGDwH081Nd3lXTpZ2QI
         SZaVZpDt9V3VgqulM7fzjNva/Rn0khcxUijhwY+te9VY13LfZYhOLAn5nbvf9+KtvR
         ScxHVNr6qIK1GP1cTApfQ8+MZ0tG+ENcinrje9Ys=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200727100201epcas2p40c201323c9151b24f6dd25d679f680ed~lk8YHUdde3156831568epcas2p4c;
        Mon, 27 Jul 2020 10:02:01 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BFb1y4vSszMqYm0; Mon, 27 Jul
        2020 10:01:58 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.F0.27441.616AE1F5; Mon, 27 Jul 2020 19:01:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200727100157epcas2p10c4a73894a510e6bb8011b86b9acb8be~lk8UhriG20670106701epcas2p1H;
        Mon, 27 Jul 2020 10:01:57 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200727100157epsmtrp27e575c4e06fc68044b9ccfbd8ebf4136~lk8Ug6V-30840008400epsmtrp2N;
        Mon, 27 Jul 2020 10:01:57 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-5f-5f1ea616a5b0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.83.08382.516AE1F5; Mon, 27 Jul 2020 19:01:57 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200727100157epsmtip2febd12fc0bbab437785e239f8a5d82f4~lk8URv-Q11745317453epsmtip2f;
        Mon, 27 Jul 2020 10:01:57 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <SN6PR04MB4640E7CB5A7F2E406323CFBAFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When
 ufs reset and restore, need to disable write booster
Date:   Mon, 27 Jul 2020 19:01:57 +0900
Message-ID: <071e01d663fc$f6bce010$e436a030$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHLP/cB05Q6MF8BaP7+redz0q/FGgLfFFEPASU1gksBdMSJPKkFsOPg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmma7YMrl4g429ShYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WHRjG5NF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpRSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk3H+9x3Wgm08FS/u3mFrYDzL2cXI
        ySEhYCKxruE+axcjF4eQwA5GiRtHXrFBOJ8YJWb8/MUI4XxjlOiduZkNpuXlxddQib2MEo/b
        vrKAJIQEXjJK9DxJBLHZBEwl+ratAJsrIjCNSWL3r0VMIAlOgViJd/NOsIPYwgINjBKnn9uA
        2CwCqhLr3x5nBrF5BSwlvh24yg5hC0qcnPkEbAGzgLzE9rdzmCGuUJDYcRbkCk6gBW4SW5/N
        Y4SoEZGY3dkGVbOFQ2JHpw+E7SIxbfIbVghbWOLV8S3sELaUxOd3e6E+q5eYcm8VC8jREgI9
        jBJ7VpxggkgYS8x61g60gANogabE+l36IKaEgLLEkVtQp/FJdBz+yw4R5pXoaBOCaFSSODP3
        NlRYQuLg7ByIsIfE/2WvWSYwKs5C8uMsJD/OQvLLLIS1CxhZVjGKpRYU56anFhsVGCPH9SZG
        cPLVct/BOOPtB71DjEwcjIcYJTiYlUR4uUVl4oV4UxIrq1KL8uOLSnNSiw8xmgJDfSKzlGhy
        PjD955XEG5oamZkZWJpamJoZWSiJ8xZbXYgTEkhPLEnNTk0tSC2C6WPi4JRqYOrfbrn5vvPS
        Up6Jl/3/tf5J0X3zRcnxyyXfddKn0o8dP7Zp85MYfZcKtqJ+yxa3uZ8T2rjYd+/cwBZjytf6
        WZzPSO/qHbPfe9i5XRf5LSm84fen5p7ZvMSihtLJXw5Nevc//dOWlJ4AdcfF804d1WP9/F3v
        3JyYKqW8OKkJ/F/rH+/UL2y68P5elIQGu/05BqPsm375e2R3TQxpmSfD8jfk04tvn+9u4wnR
        ncvRa+J6JIhRL2bBde8El21r6o/HZ56W3vn459EZ4Xp7tcUP/OK8UVfFEKPzRPiE7kJee2PO
        83/LPI6zndx4fa1ktWX6/Zk6MqH2W88uemJ59WWhxZ4rghXCWwQvChg6fb3XbKPEUpyRaKjF
        XFScCABpMUVTRwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvK7oMrl4gzUftSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJVx/vcd1oJt
        PBUv7t5ha2A8y9nFyMkhIWAi8fLia8YuRi4OIYHdjBLN8z4zQiQkJP4vbmKCsIUl7rccYYUo
        es4o0fmyAayITcBUom/bCrCEiMACJolHq/czQVStZJK4+/wfC0gVp0CsxLt5J9hBbGGBOomu
        X81gcRYBVYn1b48zg9i8ApYS3w5cZYewBSVOznwCVsMsoC3R+7CVEcKWl9j+dg4zxEkKEjvO
        vgaLiwi4SWx9Ng+qRkRidmcb8wRGoVlIRs1CMmoWklGzkLQsYGRZxSiZWlCcm55bbFhgmJda
        rlecmFtcmpeul5yfu4kRHHVamjsYt6/6oHeIkYmD8RCjBAezkggvt6hMvBBvSmJlVWpRfnxR
        aU5q8SFGaQ4WJXHeG4UL44QE0hNLUrNTUwtSi2CyTBycUg1Mc/ZfntehJHkqxI+ZMVYsJe72
        bGt39/afG2qfLj974shekY774aff7b+3wqF6hXLoYZeSuT92LfqrtEKt+G+12kvbhAALkZ9C
        vZnJS9wenfHUm5l6663Zyl8n1hU3mBz0b2c+81tcsTyroj7/y4zd3zL41jr/qLH669s0fdbv
        rQwPV+zNYFeaHybcefxu0tnH3nPtK6Vm7ePbaskpFst/UKpavnLv6QXPrl9k+5S90c2m6LBY
        1sVFQVt7Bd9/mPBxy7Vjm0v+NLYJbeZdLsX3bXuZUoT4g5KEv5uXTfnrkvCsYQXH7N773+Zq
        /lgpLz5F+kbiywCF4lVWy79dBCYN58M3DS++5Li4zf0cL0ddlBJLcUaioRZzUXEiAKJ0PdYp
        AwAA
X-CMS-MailID: 20200727100157epcas2p10c4a73894a510e6bb8011b86b9acb8be
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095653epcas2p4575db5cbcd8897662ad19465339128b2
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095653epcas2p4575db5cbcd8897662ad19465339128b2@epcas2p4.samsung.com>
        <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB4640E7CB5A7F2E406323CFBAFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> This patch is not really needed - just squash it to the previous one.
Why you said this patch is not really needed?
I don't understand
Our WB device need to disable WB when called ufshcd_reset_and_restore() func.
Please explain reason.
> 
> >
> >
> > Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 2 +-
> >  drivers/scsi/ufs/ufshcd.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 9261519e7e9a..3eb139406a7c 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6615,7 +6615,7 @@ static int ufshcd_reset_and_restore(struct
> > ufs_hba
> > *hba)
> >         int err = 0;
> >         int retries = MAX_HOST_RESET_RETRIES;
> >
> > -       ufshcd_reset_vendor(hba);
> > +       ufshcd_wb_reset_vendor(hba);
> >
> >         do {
> >                 /* Reset the attached device */ diff --git
> > a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> > deb9577e0eaa..61ae5259c62a 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -1217,7 +1217,7 @@ static int ufshcd_wb_ctrl_vendor(struct ufs_hba
> > *hba, bool enable)
> >         return hba->wb_ops->wb_ctrl_vendor(hba, enable);  }
> >
> > -static int ufshcd_reset_vendor(struct ufs_hba *hba)
> > +static int ufshcd_wb_reset_vendor(struct ufs_hba *hba)
> >  {
> >         if (!hba->wb_ops || !hba->wb_ops->wb_reset_vendor)
> >                 return -1;
> > --
> > 2.26.0


