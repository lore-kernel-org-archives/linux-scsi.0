Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F632C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 11:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E0442464E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 11:20:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nR3TRGOG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773504AbgJZLU3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 07:20:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10238 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773496AbgJZLU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 07:20:27 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201026112023epoutp032f69d4df4419d7558e59aece5a7f6c20~BhtxYI_c_2774227742epoutp03C
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2020 11:20:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201026112023epoutp032f69d4df4419d7558e59aece5a7f6c20~BhtxYI_c_2774227742epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603711223;
        bh=ALX/VBBXrkRH/vT6zy53USetMpfx3KI6mcBk5YrA8Ms=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=nR3TRGOGVsHRxfn6w5voF8epkeK2fgQ8GZ/BGHkJM+v2lO3Mvg/Dp4LTyLjArOghP
         6sdiW4cyeiFqLNrUufjRiaCjYLKsV9jrLYwD0ZmZSAd8nHbZy+6W/vdeDDtqECdn3Q
         87V2fcnhO5VABO8cJncrC4h+XWKENantMCGMOO0A=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201026112022epcas2p17227a5af5e7ea602458ce2f5ec4ce61a~BhtxIuSQy1745817458epcas2p1L;
        Mon, 26 Oct 2020 11:20:22 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4CKXSP5zV0zMqYkZ; Mon, 26 Oct
        2020 11:20:21 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.3A.09908.5F0B69F5; Mon, 26 Oct 2020 20:20:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201026112021epcas2p2d13afa6c1d4628450fd0ff4f72aaad29~BhtvYuddq2412524125epcas2p2O;
        Mon, 26 Oct 2020 11:20:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201026112021epsmtrp1462c59765217977039173c0948ad8d96~BhtvYHMnw3012030120epsmtrp17;
        Mon, 26 Oct 2020 11:20:21 +0000 (GMT)
X-AuditID: b6c32a48-123ff700000026b4-bd-5f96b0f5bd93
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.21.08604.4F0B69F5; Mon, 26 Oct 2020 20:20:21 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201026112020epsmtip10bd185a8c3808bd3808aea54c1d94c77~BhtvOdb7Z2005120051epsmtip1V;
        Mon, 26 Oct 2020 11:20:20 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Cc:     <alim.akhtar@samsung.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <BY5PR04MB6705B7357AFEDF3AB07E1560FC1D0@BY5PR04MB6705.namprd04.prod.outlook.com>
Subject: RE: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
Date:   Mon, 26 Oct 2020 20:20:20 +0900
Message-ID: <000001d6ab89$fdc00f20$f9402d60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE8rU9GG02+1hbAo1p5qXUnN9CPVgF+Wj0dAilh/bkB8/KS2gLgSNF8ASmcOSMBggPOgaqEe5Ow
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmme7XDdPiDd4v17V4MG8bm8XLn1fZ
        LKZ9+MlssejGNiaLy7vmsFl0X9/BZrH8+D8mB3aPy1e8PSYsOsDo8fHpLRaPvi2rGD0+b5Lz
        aD/QzRTAFpVjk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
        mQN0ipJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQ
        wMDIFKgyISfj2sZLzAVnmSrePjzI2sDYwtTFyMEhIWAisXa/UxcjF4eQwA5GidPHWlghnE+M
        ErduP2GDcL4xSkz9c4mxi5ETrOPiyausILaQwF5Gibmz7SCKXjBK3N19iBkkwSagL/GyYxvY
        KBGBTkaJRw3fWEH2MQvEStzdIg9Swwlkzvp1lhkkLCzgJdHw1BEkzCKgKrHu1gyw+bwClhK/
        dzYxQdiCEidnPmEBsZkFtCWWLXzNDHGPgsTPp8vA6kUEoiT2rLjPDFEjIjG7s40Z5AQJgZkc
        EpffHWCBaHCRWPvyJZQtLPHq+BZ2CFtK4mV/G5RdL7HiURNUcw+jxMtp/6C22UvMfLqUCeIX
        TYn1u/QhwagsceQW1G18Eh2H/7JDhHklOtqEIBrVJQ5snw61VVaie85n1gmMSrOQfDYLyWez
        kHwwC2HXAkaWVYxiqQXFuempxUYFJshRvYkRnEi1PHYwzn77Qe8QIxMH4yFGCQ5mJRHeOTJT
        44V4UxIrq1KL8uOLSnNSiw8xmgLDeiKzlGhyPjCV55XEG5oamZkZWJpamJoZWSiJ84au7IsX
        EkhPLEnNTk0tSC2C6WPi4JRqYEphOMXfb+zs4jhh892GRcFlgn+Vu5y5J2UnKkvq3jtW38+d
        mm6Ra13/ZY4SO9uEDa27BQpdmWVVX9T+4Tt267Pohf5OI235vY/Zbn1VWh3MfsTHlj036UdD
        23QZ6Y9/HX8JLm//EvFMKWjWlKQvi799CudYu6m0oXDpZ42Q6wl5H/X7L7wzX/pBi19/1UIe
        XtvtancXpfLUiC5fKvW74uVstfs7jNs3diRkWD1JDaw8kLjuQM201xJsjw6XFnI521TGT78b
        Jlm5epNv1KMT71idvS4KJD7TO+D7+r6s30PXFoGeO0YWCUrbhO69l5nPVXP0hgX39z7+Xy6V
        NV+6ujOvFfzLiK7LtvJxnyqjxFKckWioxVxUnAgAegdN9i0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJTvfrhmnxBt13mSwezNvGZvHy51U2
        i2kffjJbLLqxjcni8q45bBbd13ewWSw//o/Jgd3j8hVvjwmLDjB6fHx6i8Wjb8sqRo/Pm+Q8
        2g90MwWwRXHZpKTmZJalFunbJXBlvF99iKXgLFNF16pHjA2MLUxdjJwcEgImEhdPXmXtYuTi
        EBLYzSjx5dAtNoiErMSzdzvYIWxhifstR6CKnjFKtGw+BZZgE9CXeNmxDSwhItDLKLH2ykRW
        kASzQLzEmYUT2SA65jBLzFo+iQUkwSkQKzHr11nmLkYODmEBL4mGp44gYRYBVYl1t2aA9fIK
        WEr83tnEBGELSpyc+YQFYqa2xNObT+HsZQtfM0NcpyDx8+kysF4RgSiJPSvuM0PUiEjM7mxj
        nsAoPAvJqFlIRs1CMmoWkpYFjCyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCI0tL
        cwfj9lUf9A4xMnEwHmKU4GBWEuGdIzM1Xog3JbGyKrUoP76oNCe1+BCjNAeLkjjvjcKFcUIC
        6YklqdmpqQWpRTBZJg5OqQamzNtRG1hVWX3FY48//Jqjwlpop9mdUrzLq4u3av+JxU6fQzeu
        NH7fmX+vIrHo0lO+x6pKXAfPLzwtaKZcwnpAkVc9x2ltZtbZfTf+TCl56rB0hfrzCS7sr1Rt
        jWR2lV/m8NbJO/LjhbvtOZ+KvRbv3nzb76q989CLPE7HuJZ5UQ/WrE145jZ5WuL8SLlVfJde
        9gntlKtnvXXBtuSF4NXtc5ZebPmjsFaqwmVOhq2S/c8L2SvP/PZ/b7j67nqbChWdBx/mv9p4
        R9l+0eL0w4w39Hef+2e06GfpXWce9YMspzVSlh8wvOKjWPSnuKHHa/qmbXc27VzgpN0tHjdh
        gVnmk2eXJXtOem3ZWsC9ueaUhhJLcUaioRZzUXEiALEGqq8bAwAA
X-CMS-MailID: 20201026112021epcas2p2d13afa6c1d4628450fd0ff4f72aaad29
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
        <20201020070516.129273-1-chanho61.park@samsung.com>
        <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
        <000a01d6a761$efafcaf0$cf0f60d0$@samsung.com>
        <0a5eb555-af2a-196a-2376-01dc4a92ae0c@acm.org>
        <008a01d6a830$1a109800$4e31c800$@samsung.com>
        <BY5PR04MB6705B7357AFEDF3AB07E1560FC1D0@BY5PR04MB6705.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> In case you'll convince Bart that this code is needed, maybe use a IDA
> handle for that?

Thanks for your suggestion.
IDA is useful to maintain unique IDs with bitmap structure but the patch as=
sumes host_no is the unique number and can be used in the bitmap for making=
 sequential order.

Best Regards,
Chanho Park

