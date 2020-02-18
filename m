Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F934C34031
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14BF324655
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VL8xspjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBRXy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 18:54:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10124 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgBRXym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 18:54:42 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200218235440epoutp014c34998a5f7a9501f078a83a52eeab80~0pFstibow2732027320epoutp01V
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 23:54:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200218235440epoutp014c34998a5f7a9501f078a83a52eeab80~0pFstibow2732027320epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582070080;
        bh=yF3JGuGdN4xhNcQhIo1FaQTWrBbwamNmfNAYDHcTrMw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=VL8xspjRUM5JYoirwWq87qEuBDXF2rFGKqowcrK7mRHp2X8ns3vakzCYBggvT63e5
         JayYEdYhlOmVLmRiSBk5qdYSdQs+ERg6390PXFZ6jhKz0+in/U6SK8Ac+Qzi3WoQNT
         N8G6FFHD5Y9dASikRJTyeZZH31PsZLusmmDMSG34=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200218235439epcas2p2de50da0ed2ce1f276a390ed16fbeb4e1~0pFsAe-h00633006330epcas2p2S;
        Tue, 18 Feb 2020 23:54:39 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 48Md4Y16P3zMqYm2; Tue, 18 Feb
        2020 23:54:37 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.1C.17124.C397C4E5; Wed, 19 Feb 2020 08:54:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200218235436epcas2p14d1dfb83b6198a8eb19c806ac7381e83~0pFoc_hNi3145031450epcas2p1d;
        Tue, 18 Feb 2020 23:54:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200218235436epsmtrp1648c08ffb0394feb3de7ba5584e92b28~0pFocYDEk1058010580epsmtrp1V;
        Tue, 18 Feb 2020 23:54:36 +0000 (GMT)
X-AuditID: b6c32a46-48fff700000142e4-a1-5e4c793c08b4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.E3.10238.B397C4E5; Wed, 19 Feb 2020 08:54:35 +0900 (KST)
Received: from KORCO002087 (unknown [180.236.228.110]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200218235434epsmtip1356fceea490f1239011b6e4cd08c2283~0pFnaqUoi3070530705epsmtip1p;
        Tue, 18 Feb 2020 23:54:34 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
In-Reply-To: <20200218233222.GA6827@infradead.org>
Subject: RE: [PATCH] ufs: add quirk to fix abnormal ocs fatal error
Date:   Wed, 19 Feb 2020 08:54:45 +0900
Message-ID: <0afa01d5e6b6$cce7b030$66b71090$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLWtATr2+I0rcQn+9BDLX+A1N6BfgJVPwaXAeVunAml/jASoA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42LZdljTXNem0ifOYMJucYvTExYxWSy6sY3J
        ovv6DjaL5cf/MTmweGxeoeUxYdEBRo+PT2+xeHzeJBfAEpVjk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJMx7XpNwSbmiuUfDzE2MF5h6mLk
        5JAQMJG4u+QucxcjF4eQwA5GiaOf9rJDOJ8YJR68v8EI4XxjlJix8C8zTMvvayfB2oUE9jJK
        nHlSCVH0mlHiybdbYEVsAtoS0x7uZgWxRQR0Jc4ufMEIYjMLhEksvP6TBcTmFDCSOHrjDFi9
        sICzRP+in2BDWQRUJb6dWglm8wpYSix+1sEGYQtKnJz5hAVijrzE9rdzoA5SkPj5dBnULieJ
        ZfduMEHUiEjM7mwD+01C4ACbxJNfS6GedpFo278dyhaWeHV8CzuELSXxsr8Nyq6X2De1gRWi
        uYdR4um+f4wQCWOJWc/agWwOoA2aEut36YOYEgLKEkduQd3GJ9Fx+C87RJhXoqNNCKJRWeLX
        pMlQQyQlZt68wz6BUWkWks9mIflsFpIPZiHsWsDIsopRLLWgODc9tdiowAg5rjcxghOjltsO
        xiXnfA4xCnAwKvHwHrjoHSfEmlhWXJl7iFGCg1lJhNdb3CtOiDclsbIqtSg/vqg0J7X4EKMp
        MOAnMkuJJucDk3ZeSbyhqZGZmYGlqYWpmZGFkjjvJu6bMUIC6YklqdmpqQWpRTB9TBycUg2M
        LIm3FgpunBvtsHylmq5HqifbqivPPBffPpVfkv6J+0PJ17AtXjmbQ5b68vEWzF72aO8kRUO1
        Lwc49p6VroxMZljZ9ftI2UGG1d83SL72l165NEHi/lHLFTu7N/xy7E69xfrEddm21Gh+NxPh
        l5efHzN7c2GBVKQLw1zzwgNbrntd7OB99NNbW4mlOCPRUIu5qDgRAHhmI/qiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSnK5NpU+cwXJDi9MTFjFZLLqxjcmi
        +/oONovlx/8xObB4bF6h5TFh0QFGj49Pb7F4fN4kF8ASxWWTkpqTWZZapG+XwJUx7XpNwSbm
        iuUfDzE2MF5h6mLk5JAQMJH4fe0kkM3FISSwm1Fi0oW1rBAJSYkTO58zQtjCEvdbjrBCFL1k
        lLg2aTVYgk1AW2Law91gDSICuhJnF74AizMLREjc6j7MAmILCWxklPjzAyzOKWAkcfTGGWYQ
        W1jAWaJ/0U+wK1gEVCW+nVoJZvMKWEosftbBBmELSpyc+QRoDgfQTD2Jto1Q4+Ultr+dwwxx
        m4LEz6fLoE5wklh27wYTRI2IxOzONuYJjMKzkEyahTBpFpJJs5B0LGBkWcUomVpQnJueW2xY
        YJiXWq5XnJhbXJqXrpecn7uJERwdWpo7GC8viT/EKMDBqMTDm3HeO06INbGsuDL3EKMEB7OS
        CK+3uFecEG9KYmVValF+fFFpTmrxIUZpDhYlcd6neccihQTSE0tSs1NTC1KLYLJMHJxSDYz8
        puc8zrTuXN23ge3HyZAdx+pZfm3vV/DU/GcjWHH7jdKTZ6LzPWfVWWfWO6e7hofm8leqFZtn
        7BBeI+v6N/CV0XNFmZAet4zDMaraNmVKsfc6Dl+yfOCSUBUt7TnBPOL/7+Sqv71WvdnX3R5e
        l+hn/11SqB+ZUvniV8B13g+bu1eu4m7SVGIpzkg01GIuKk4EAFfiTOGKAgAA
X-CMS-MailID: 20200218235436epcas2p14d1dfb83b6198a8eb19c806ac7381e83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200218224503epcas2p46cec6f56d7564ea7dca4ab600476d938
References: <CGME20200218224503epcas2p46cec6f56d7564ea7dca4ab600476d938@epcas2p4.samsung.com>
        <20200218224307.8017-1-kwmad.kim@samsung.com>
        <20200218233222.GA6827@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Wed, Feb 19, 2020 at 07:43:07AM +0900, Kiwoong Kim wrote:
> > Some architectures determines if fatal error for OCS occurrs to check
> > status in response upiu. This patch is to prevent from reporting
> > command results with that.
> 
> This seems to be missing the hunk to actually set the quirk bit..

Exynos specific driver sets and is using it but the driver is not updated
yet. I'll do upstream it in the future.

