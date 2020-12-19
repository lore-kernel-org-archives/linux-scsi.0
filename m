Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839F8C0018C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 04:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F4C23BEC
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 04:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgLSEuC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 23:50:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46506 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgLSEuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 23:50:01 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201219044918epoutp040b72bb138776c39836c2503373dd349c~SBNum7bc32720527205epoutp04r
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 04:49:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201219044918epoutp040b72bb138776c39836c2503373dd349c~SBNum7bc32720527205epoutp04r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608353358;
        bh=MptiXlwqlot76SF2HC32AHFmoZuudHVseMbvF9audu8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=XyuzNwl09ylWaK0cyidcilF94oAde79CXUZ52ViiZ6/9LWC+0VNvNJhXJ84Pi/un3
         T5KNnM7PmAJ2nbctwIpDl/4yl3eYIJ9LguYTmUsWmZLTFVLHqE1IRm6CtGJA1Ccdcp
         tngf3Y75I/wAgHsG9e5xV0mEiAdCRkkk8Mi6rwz4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201219044917epcas2p252eb14f4e372c150af6ad684b55d5355~SBNtxDXhw0447604476epcas2p2I;
        Sat, 19 Dec 2020 04:49:17 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CyYDC36gVzMqYkY; Sat, 19 Dec
        2020 04:49:15 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.9B.52511.B468DDF5; Sat, 19 Dec 2020 13:49:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201219044914epcas2p45c64d96a9a9097cc100f6d477c0c36ce~SBNrLNQ7-0440204402epcas2p4b;
        Sat, 19 Dec 2020 04:49:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201219044914epsmtrp1586abadd9f7f6874c7be3c4cc8cef2c5~SBNrKRaHc2302523025epsmtrp1Y;
        Sat, 19 Dec 2020 04:49:14 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-6f-5fdd864bc04a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8B.81.08745.A468DDF5; Sat, 19 Dec 2020 13:49:14 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201219044914epsmtip1f49a140db5e45782fdf059edc552e288~SBNq6HdRJ0674406744epsmtip1Q;
        Sat, 19 Dec 2020 04:49:14 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 0/2] permit to set block parameters per vendor
Date:   Sat, 19 Dec 2020 13:38:24 +0900
Message-Id: <cover.1608352548.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdljTXNe77W68wfclghYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZPy8eou9YCNLRXf/GuYGxt3MXYycHBICJhKdVzezdDFycQgJ7GCUOPhhApTziVHi
        0cHpTBDOZ0aJnc0r2WFavn++BJXYxShx6OoTZgjnB6PEkil7WEGq2AQ0JZ7enApWJSJwhkni
        WutZsASzgLrErgknmEBsYQFXiVPbJ4GNZRFQlbj1ZRsLiM0rYCEx//h0Foh1chI3z3WCbZAQ
        aOSQmPt0G1TCReLcjctsELawxKvjW6Duk5J42d8GZddL7JvawArR3MMo8XTfP0aIhLHErGft
        QDYH0EWaEut36YOYEgLKEkdusUDcySfRcfgvO0SYV6KjTQiiUVni16TJUEMkJWbevAO1yUPi
        /5G5YK1CArESq9ZOZZ7AKDsLYf4CRsZVjGKpBcW56anFRgUmyNG0iRGcJLU8djDOfvtB7xAj
        EwfjIUYJDmYlEd7QB7fjhXhTEiurUovy44tKc1KLDzGaAsNrIrOUaHI+ME3nlcQbmhqZmRlY
        mlqYmhlZKInzhq7sixcSSE8sSc1OTS1ILYLpY+LglGpg8i0SNg8K3GrLxL6T453ps7dCJ0Sk
        6z5vm9roXTdNJS2z58tO89VLxKyXhj4VuDJ3YfLM/01PGqSeB3Q9PxPqMJPPRGjLPp/pe9vn
        ad7Yk2Y3Z93Dte6Vj38/t3/BN6O4Ykt3PqfScY5six1Hfd/+/FYo/ZGJOf7q3O9xmlJOOukH
        RZ9uq59a0ah1g/ld/4lHEr91XWfwzD/gpDl7V3nqVqvpV4McLvOULFL3/5Hu6CT4743t0dQZ
        dhYiYlvU1vG9kq/3tAphlXt1t1f1+EffxkDPa4fsAxQnlrJ6fTnRV3FudXOCCNf9O66lZ43N
        F96LNdeocRcP1DE9LOU5e7IlixL7Eqlw26vXbAKv/3RVYinOSDTUYi4qTgQAoYKxsRsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnK5X2914g6n/FC0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGX8vHqLvWAjS0V3/xrmBsbdzF2MnBwSAiYS3z9fYupi5OIQ
        EtjBKNGwbwMjREJS4sTO51C2sMT9liOsEEXfGCUu9h1nBUmwCWhKPL05FaxbROAek8SlCXPB
        xjILqEvsmnCCCcQWFnCVOLV9EjuIzSKgKnHryzYWEJtXwEJi/vHpLBAb5CRunutknsDIs4CR
        YRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnDQamntYNyz6oPeIUYmDsZDjBIczEoi
        vKEPbscL8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwFTC
        GyBZoXLC8174lsdLZGUSdVjKtxyI+P76z7/5v/87x8bPdz/JuUo096GX7eTDj7/M6SxfMKXw
        YhTL7f/rlq+/8MvkUsbD7RsPR+v9yo10ysywcg207oyXWOXz5NehqcUKku2t985f+xaxuW+C
        GdezvadPvAlfcK5t/UfLdWs/1Wz+sExj467NdxX6ZGTuMRwTmrBo6vziuiVz1QJn6z7SvnSk
        XW1zwjT15BVvCh7ZMV1lOpTGJG5/xKE4ZPrlGyX/9y6wvtwa5ysk+8afY8aadysu8UXwMFW8
        zo0oK3svqVm/+zRzSo20QPTT+dMWnLio1JpivVF7r4I+65U4v5nlmiLvjVc9tL7ybO6FnjVX
        lFiKMxINtZiLihMB0RzLQskCAAA=
X-CMS-MailID: 20201219044914epcas2p45c64d96a9a9097cc100f6d477c0c36ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219044914epcas2p45c64d96a9a9097cc100f6d477c0c36ce
References: <CGME20201219044914epcas2p45c64d96a9a9097cc100f6d477c0c36ce@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are some cases of dispatching a command with more than
one scatterlist entry and under 4KB size. Device sends just one DATA IN
but some SoCs transfer could tranfer data to a physically continuous
area, which should have done per each scatterlist entry.

Kiwoong Kim (2):
  ufs: add a vops to configure block parameter
  ufs: ufs-exynos: set dma_alignment to 4095

 drivers/scsi/ufs/ufs-exynos.c | 9 +++++++++
 drivers/scsi/ufs/ufshcd.c     | 2 ++
 drivers/scsi/ufs/ufshcd.h     | 8 ++++++++
 3 files changed, 19 insertions(+)

-- 
2.7.4

