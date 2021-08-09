Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F21C432BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7584561058
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhHIHqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:46:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21050 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhHIHqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 03:46:42 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210809074619epoutp0185f258b96d86b4f547af1ab70e5b990b~Zk7zKL1Hv0906009060epoutp01K
        for <linux-scsi@vger.kernel.org>; Mon,  9 Aug 2021 07:46:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210809074619epoutp0185f258b96d86b4f547af1ab70e5b990b~Zk7zKL1Hv0906009060epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628495179;
        bh=4ysh1Qqk1bJT1P7I1/f/ILVbF5iojyPx2CxbDbZD1Mc=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=QcjjmLlwpfuXiPOXSFT3m8XcMtrGHmTOC0mY7OXMd0D3cHjswLm9u3X7PBsao9oe5
         noi2rdzlioHGN+pCIb4uDdpbh3CY2MLkrnz1Ty8TPq2qgHI/Ddl4wrPxJYoZgoaFLJ
         xEhG3L+jhAxnzHMcGq67jfHJXCuWHcbROlQ0RC2E=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210809074618epcas2p30de07cce6ee9dd1ef4d85800ec15c998~Zk7yWejYk0062700627epcas2p3d;
        Mon,  9 Aug 2021 07:46:18 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Gjp6v4Y6zz4x9Q5; Mon,  9 Aug
        2021 07:46:15 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.C5.09921.74DD0116; Mon,  9 Aug 2021 16:46:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210809074615epcas2p31bf27f9463e33ced845c9767a7a42311~Zk7vJOvYb3197331973epcas2p3i;
        Mon,  9 Aug 2021 07:46:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210809074614epsmtrp1e265b2c1252a9fbe11290c31953993e2~Zk7vIOeA50573505735epsmtrp1K;
        Mon,  9 Aug 2021 07:46:14 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-4f-6110dd47cd3b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.22.08394.64DD0116; Mon,  9 Aug 2021 16:46:14 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210809074614epsmtip23c13e92ab3bc640fb908d78364f6676f~Zk7u4c5h30102201022epsmtip2E;
        Mon,  9 Aug 2021 07:46:14 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <b3c18b34-2108-abfa-54ca-096a3eb31318@acm.org>
Subject: RE: [RFC PATCH v1 0/2] scsi: ufs: introduce vendor isr
Date:   Mon, 9 Aug 2021 16:46:14 +0900
Message-ID: <000601d78cf2$a160f820$e422e860$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLpLcRe5nxssMVHyiI1GTvVMnlTYwK++sB5AU8a/RupJxVgcA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmma77XYFEg5f3FC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7K4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCMyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk/G4ZQprQRNzxYupv9gbGLcwdTFyckgImEg8av7K3sXIxSEksINR4tbrOWwQzidG
        iY4TZ5ggnG+MEt9XLGCGaTk2aQ1Uy15Gid0N66BaXjBKtBz5xAZSxSagLTHt4W5WkISIQAuz
        xJW9n8A2cgpYS2y/ug2onYNDWMBe4uU/MZAwi4CKxP5tnxlBbF4BS4mV03azQ9iCEidnPmEB
        sZkF5CW2v50DdYWCxM+ny1hBbBEBJ4mTi98zQ9SISMzubIOqucMhsfS4KYTtItF66gEjhC0s
        8er4FnYIW0riZX8blF0vsW9qA9jNEgI9jBJP9/2DajCWmPWsnRHkZmYBTYn1u/RBTAkBZYkj
        t6BO45PoOPyXHSLMK9HRJgTRqCzxa9JkqCGSEjNv3oHa5CGx6dgptgmMirOQPDkLyZOzkDwz
        C2HvAkaWVYxiqQXFuempxUYFhsiRvYkRnLC1XHcwTn77Qe8QIxMH4yFGCQ5mJRHe9TP4EoV4
        UxIrq1KL8uOLSnNSiw8xmgKDfSKzlGhyPjBn5JXEG5oamZkZWJpamJoZWSiJ82rEfU0QEkhP
        LEnNTk0tSC2C6WPi4JRqYBLyf1W9cWL9khtyZrO8BeZW1W46ri+UsGUWi8M2LYGfFn8/OC8X
        zz2uLh20+FvhquVHfrq6WaXW3pWICGBc0SVxQPMIU/8iAaFZHM8NCte5zWUXf6Ph331MNMUk
        pVf994Hc7o8Kl372xLx+vmDTxDl5zE+Tr6wy+du+3O2CT5uEnc9EtWlBAirMIbPCvyXcnHpS
        nz+gqnRRdcuLRAGbSt8Y2weOsRWCJu8dI+anf0lynBKsoVyVdn9HMqu36MYf35ZaHJu17dWH
        Jp6lTzy1fx690J0XVHtELTH1Q7nUbo/Za4wn531apblI1if7C9vEjX8E1+cfszbnF6haN/3B
        JbOtMpt2VPr/6THZccR5pRJLcUaioRZzUXEiAJnLT6phBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvK7bXYFEg4uLzCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7K4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mp43DKFtaCJueLF1F/sDYxbmLoYOTkkBEwkjk1aw97FyMUh
        JLCbUeLsiz52iISkxImdzxkhbGGJ+y1HWCGKnjFKHNjRCJZgE9CWmPZwN1hCRGAKs8Sda0fZ
        IKp2Mko8+/2KBaSKU8BaYvvVbUBjOTiEBewlXv4TAwmzCKhI7N/2GWwQr4ClxMppu9khbEGJ
        kzOfgLUyAy14evMplC0vsf3tHGaIixQkfj5dxgpiiwg4SZxc/J4ZokZEYnZnG/MERqFZSEbN
        QjJqFpJRs5C0LGBkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERylWpo7GLev+qB3
        iJGJg/EQowQHs5II7/oZfIlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0t
        SC2CyTJxcEo1MB188ibtnuCeqweYVERzHkXtLugrkdz5I81n8qqAu7JRr20mprj9L7cNnn3X
        +/xx7zudPz0cup/LhP08ZSYq/ENk37xN53p1l50MXrH89aU/Ood0Mr4aRctOmHaee9LXklUq
        dd9ntzBPv30+nmtZ0qFk5ZrCkhC9bY+8iw59Kj90IW/Ro/Wmz1RNk/T/uW6vcouS6zv1/FXG
        7meKv5+o9x54vFh/Ut2KxIwjV80m58joeddo6V581LiumevraQlVl0238ni8WvYY+96/Gtzy
        2p314Ef3JwIP1Na8WtVTealikuLOymMs/A4zAmb5SFya1hUkpxdlnlfaevSd/s7THtsZn4hM
        sEm8mJN42FyP116JpTgj0VCLuag4EQCoRxYvQQMAAA==
X-CMS-MailID: 20210809074615epcas2p31bf27f9463e33ced845c9767a7a42311
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229
References: <CGME20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229@epcas2p1.samsung.com>
        <cover.1628231581.git.kwmad.kim@samsung.com>
        <b3c18b34-2108-abfa-54ca-096a3eb31318@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> How about extending the UFS spec instead of adding a non-standard
> mechanism in a driver that is otherwise based on a standard?

It seems to be a great approach but I wonder if extending for the events
that all the SoC vendors require in the spec is recommendable.
Because I think there is quite possible that many of those things are 
originated for architectural reasons.

