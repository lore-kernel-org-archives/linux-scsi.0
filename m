Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA6AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A9422ADC
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLVCS1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 21:18:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26958 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVCS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 21:18:27 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201222021743epoutp0435a4e1605a2eadb52b4e43a6a324d731~S6FPZqmxP2227622276epoutp04B
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:17:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201222021743epoutp0435a4e1605a2eadb52b4e43a6a324d731~S6FPZqmxP2227622276epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608603463;
        bh=meghjGCzFWRirtyEtM1vEEYNZ8hDVaoWHxiCHcpVicU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Nb1OAkgpqQDolBGgN5QeR+fxd9XfUyFRbJhJ71kf/AZk2HsBUaNp7PBAB92IB0q49
         NI43eL26uF09UiY8+PT14FsoxqjXYYY8tw2Y8I8eIMqFLWc/ZVhncC7nAuhVafW19B
         C6HNqdSmJvT/HnVejT/f/ayQCPa55R9Hau+HTW+c=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201222021743epcas2p3baa69d02c78028154afd3970413bf22c~S6FO1_m8R2888228882epcas2p39;
        Tue, 22 Dec 2020 02:17:43 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4D0Kjw5Hssz4x9QC; Tue, 22 Dec
        2020 02:17:40 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.E9.56312.24751EF5; Tue, 22 Dec 2020 11:17:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201222021737epcas2p2340d32346f02456c6a715fd2c7c0b389~S6FJ7UuTl0152401524epcas2p2Z;
        Tue, 22 Dec 2020 02:17:37 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201222021737epsmtrp2ae551643cca28f487133e7c337578a4a~S6FJ6My9y0835008350epsmtrp2L;
        Tue, 22 Dec 2020 02:17:37 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-88-5fe157420e65
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.73.08745.14751EF5; Tue, 22 Dec 2020 11:17:37 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201222021737epsmtip134813f227fe06a87eaf47dcf78d8aebd~S6FJoD7110718407184epsmtip1U;
        Tue, 22 Dec 2020 02:17:37 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 0/2] permit to set block parameters per vendor
Date:   Tue, 22 Dec 2020 11:06:45 +0900
Message-Id: <cover.1608602725.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTTNcp/GG8wbn7OhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZHzq/cRa8JClomX2F7YGxnvMXYycHBICJhJT5z8Asrk4hAR2MEp82fAayvnEKLHl
        2mFGCOczo8SRBS+AHA6wlkdrNEC6hQR2MUocW1kOEhYS+MEo0eMDEmYT0JR4enMqE0iriMAZ
        JolrrWdZQRLMAuoSuyacYAKxhQUcJTqPfQQbySKgKvFloi1ImFfAQmLZyTVQx8lJ3DzXCXaP
        hEArh8Thh0dZIRIuEiseNUIVCUu8Or6FHcKWkvj8bi8bhF0vsW9qAytEcw+jxNN9/xghEsYS
        s561gy1mBrp0/S59iLeUJY7cYoE4k0+i4/Bfdogwr0RHmxBEo7LEr0mToYZISsy8eQdqq4fE
        xjWfWSAhEivxa2436wRG2VkI8xcwMq5iFEstKM5NTy02KjBCjqFNjODUqOW2g3HK2w96hxiZ
        OBgPMUpwMCuJ8JpJ3Y8X4k1JrKxKLcqPLyrNSS0+xGgKDK6JzFKiyfnA5JxXEm9oamRmZmBp
        amFqZmShJM5bbPAgXkggPbEkNTs1tSC1CKaPiYNTqoFJSHZfke3LrfPnVb6x6V9XlCBZJd5V
        7rHrn+zWrYXc21/PPLV+ygaFvaXH2jaLpyhuu+w2Ja1NaOcpmRcJKd9s73CqLJnz4nd58jST
        8tWnUg1aV9g07GSq0lz0NatIfeKWnpNvlgQ8/nT9KeP2A8ekj057Y/i120rAcvqsZvO3c/qX
        erwwX6ckYcPk0Pm7387gApvDuftHNI7vEV/1aHreucPLdxdekDDLPvch1P3FtVtFp44bV3VP
        tEg8P0vwWUHIoXnXm00EQ5QEkzyLE6dG12z7cDv+zdc9afOil+Y8igl6pyWrMS3b4ePkRXfq
        G8+1RPbFXZR+b7qqien339et7xxNeQuOxn61mzBlW6/vUiWW4oxEQy3mouJEAJDZN+sWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSnK5j+MN4g1MrdSwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGV86v3EWvCQpaJl9he2BsZ7zF2MHBwSAiYSj9ZodDFycQgJ
        7GCUeLV3L1MXIydQXFLixM7njBC2sMT9liOsEEXfGCX+fJrBApJgE9CUeHpzKhNIQkTgHpPE
        pQlzmUESzALqErsmnACbJCzgKNF57CMjyDYWAVWJLxNtQcK8AhYSy06uYYZYICdx81wn8wRG
        ngWMDKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYIDVktrB+OeVR/0DjEycTAeYpTg
        YFYS4TWTuh8vxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dU
        AxN7a94prcTdcQUZgXxS2c9/GH2Z1qG3L1dTruhxb0JyqOKXeTbZ+s9XWz168X13pszDzyHX
        dX8IPDnwq+OL55cF/zMXSH7OTJyckGVlM+HoD+WMQnPpb4XLGf7t6r+/JeyKc5uwxlmrHbV9
        HEnW7z7fnvnSefOD2YVy4rK9f73SXfbeENx/cGLGxllK7YdeCN6w09vYeb9Dau3LiqhQ3Xp1
        58NMb913b3vtXP3U9Tbzz6ezpzdfv2JS9qCz+tTUwM2TtVddUe1vTJ79mvEy/8ZlScnFOaWf
        9/G9/SG/Tm7xn5cCfd2PZc+0yUocsvdrexp0xGgaZ/baOYlXfi9yWn1JTX1/9jar/hVFEw3f
        /lJVYinOSDTUYi4qTgQAQOL57ccCAAA=
X-CMS-MailID: 20201222021737epcas2p2340d32346f02456c6a715fd2c7c0b389
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222021737epcas2p2340d32346f02456c6a715fd2c7c0b389
References: <CGME20201222021737epcas2p2340d32346f02456c6a715fd2c7c0b389@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2: rename the vops and fix some typos

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

