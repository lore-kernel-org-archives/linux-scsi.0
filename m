Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD6EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C59660F21
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbhINFPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 01:15:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14044 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbhINFPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 01:15:05 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210914051346epoutp01cf5f3e1d68b72b472bd571db64670b35~kmE4wRcw10411104111epoutp019
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 05:13:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210914051346epoutp01cf5f3e1d68b72b472bd571db64670b35~kmE4wRcw10411104111epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631596426;
        bh=R25NOvnUBSkJT6aqilTCPohjpfRCYDrv5wDWT17K454=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=giGp+jlpPaXPnHlwCQIXyasWm2NtL/qQ34954mBHYr+uQtEIwFyW7TbQU/Hda5Ejp
         tmdBS5HctjA6lBkoawI+PkjTF+V1jy783pxLbMU4x/KOfY1L/qlrhC3oMrMcSYrJnS
         N63neom3EGcbANNSHYsWztBqoCzGDKTwfXHdoF/I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210914051345epcas2p4486b7a86a267105dcfe5be23214ec66a~kmE4F4RPB3180531805epcas2p4a;
        Tue, 14 Sep 2021 05:13:45 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4H7s2H1sK8z4x9Qg; Tue, 14 Sep
        2021 05:13:43 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        DC.62.09472.68F20416; Tue, 14 Sep 2021 14:13:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210914051340epcas2p2a3d6facb33cd92f4e4a8361aa63e0be1~kmEzRrhZ52453424534epcas2p2C;
        Tue, 14 Sep 2021 05:13:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210914051340epsmtrp1f89e46370feb63ddeed686e58bef3c87~kmEzQv__M1932419324epsmtrp1e;
        Tue, 14 Sep 2021 05:13:40 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-f8-61402f86fc11
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.AC.09091.48F20416; Tue, 14 Sep 2021 14:13:40 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210914051340epsmtip1a27dbf05cf501de47c5f0cb1e169cc05~kmEy-zp7R1965319653epsmtip1g;
        Tue, 14 Sep 2021 05:13:40 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <c6b2007b-155b-18b2-e45d-06f600c98797@acm.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: introduce vendor isr
Date:   Tue, 14 Sep 2021 14:13:40 +0900
Message-ID: <000101d7a927$47dc7d50$d79577f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFyn/7MkbxYHt33UvraYb1f3WYrLgJsxD2CAe3deC0BytsbgKw74pYw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJsWRmVeSWpSXmKPExsWy7bCmmW6bvkOiwe8TPBYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8ZqsXrxAxaLRTe2MVlc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeSze85LJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBG5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyTjwfwVzwTWmim0fr7M0ME5n6mLk5JAQMJG4cmI1cxcjF4eQwA5GiRtXtrFDOJ8Y
        Jb7cf8oC4XxjlHiw6BgzTMu084+gqvYCVTU1M0I4LxglZlw4CzaYTUBbYtrD3awgCRGBFmaJ
        K3s/gSU4Bawlbrx6zQpiCwPZex7vZwexWQRUJW6tmAW0j4ODV8BSouGPGUiYV0BQ4uTMJywg
        NrOAvMT2t3OgrlCQ+Pl0GdgYEQE3iYmbjzNB1IhIzO5sA3tIQuAOh8Tqq4ehPnWROHZzJiOE
        LSzx6vgWdghbSuJlfxuUXS+xb2oDK0RzD6PE033/oBqMJWY9a2cEOY5ZQFNi/S59EFNCQFni
        yC2o2/gkOg7/ZYcI80p0tAlBNCpL/Jo0GWqIpMTMm3egNnlITHjSxjiBUXEWki9nIflyFpJv
        ZiHsXcDIsopRLLWgODc9tdiowAQ5tjcxglO2lscOxtlvP+gdYmTiYDzEKMHBrCTCu+2NbaIQ
        b0piZVVqUX58UWlOavEhRlNgsE9klhJNzgdmjbySeENTIzMzA0tTC1MzIwslcd7zry0ThQTS
        E0tSs1NTC1KLYPqYODilGphy51kGvm3ZyB/+sc/Ae3FqH793bmrvt239xcaBh6zuKgi69p0/
        ZsfetMR1TlY2w4nOe3JNpatN/x1wWF64IHna8Xly/6/sexJ9yKt+W/Le/+vz/GRvr/hcqhIT
        9Pf3x9pVgj8kBUQjo5n++bH5he+oue/qtHg3p+uVBKnNEyVfnvEX9VI83KNcs/jRGnaTj3qz
        OHZ+e8dZJdOdxJ7BJSy8NTzhw/Zln1j0OTeIhiz7IPZ+wrq2qXXSQTcNdy6ON53Rsi0ptmXj
        BOauD/tXPrrUxXsrmeNyVe3FnA3H1B7dVP0zU4310wHzRmnOcIHrvu8OrFpa+k6F4Ua+9YW7
        G7NZp/y4qBW15KVUuNCzVjMlluKMREMt5qLiRABFP4itYgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSnG6LvkOiwYkeZYuTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1WL34AYvFohvbmCwu75rDZtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPBbvecnkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjijuGxSUnMyy1KL9O0SuDIO/F/BXHCNqWLbx+ssDYzTmboYOTkkBEwkpp1/xN7FyMEh
        JLCbUWIND0RYUuLEzueMELawxP2WI6xdjFxAJc8YJbonrgFLsAloS0x7uBssISIwhVnizrWj
        bBBVnUwSC9/fYwOp4hSwlrjx6jUriC0MZO95vJ8dxGYRUJW4tWIWC8hmXgFLiYY/ZiBhXgFB
        iZMzn7CA2MxAC57efAply0tsfzuHGeIiBYmfT5eBjRQRcJOYuPk4E0SNiMTszjbmCYxCs5CM
        moVk1Cwko2YhaVnAyLKKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4QrU0dzBuX/VB
        7xAjEwfjIUYJDmYlEd5tb2wThXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2a
        WpBaBJNl4uCUamCK53/KKGFY/yfjQFvo0qkzFm59PFXM4GpYKe9WLWU3a7O0LYu2pK8oFrrO
        4JAvqXM5R1n5LNPd+GhlvywVld+OIRf/+B0M41i94EdkqEqX5opKdafiB182PWMvack00Hzw
        5FyG+5y3Nbzdhq8+PrUMkbzvOy+y4kDI61WMG7ftebYo5ficqudLNO7erb2trfhvxxFf6WlL
        mBM2RDyKunZjh4OojRbvBYnKTfqzF29IyXwVMympWaGnsIPXzk1HRFbHeP7FV9b+tTsZe7vF
        5y/5oDGNbRGn0wxmdhcHjwVVd86+ETlT8Yn9vK6ClPknm4+/JrMki+jeOvqBQ8EyPSJhWhyT
        XclUk2eimyanaSqxFGckGmoxFxUnAgDuh1CfPwMAAA==
X-CMS-MailID: 20210914051340epcas2p2a3d6facb33cd92f4e4a8361aa63e0be1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059
References: <cover.1631519695.git.kwmad.kim@samsung.com>
        <CGME20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059@epcas2p1.samsung.com>
        <6801341a6c4d533597050eb1aaa5bf18214fc47f.1631519695.git.kwmad.kim@samsung.com>
        <c6b2007b-155b-18b2-e45d-06f600c98797@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Since "static inline irqreturn_t ufshcd_vendor_isr_def(struct ufs_hba
> *hba)" occupies less than 80 columns please use a single line for the
> declaration of this function. Additionally, please leave out the "inline"
> keyword since modern compilers are good at deciding when to inline a
> function and when not.

Got it. Thanks.

