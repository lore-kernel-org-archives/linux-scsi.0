Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D80C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72C2460EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhJRMr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63950 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhJRMrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:25 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211018124510epoutp04d96a3a3582848c51a8a06ecfdce805cc~vIKuPawhR3052930529epoutp04D
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211018124510epoutp04d96a3a3582848c51a8a06ecfdce805cc~vIKuPawhR3052930529epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561111;
        bh=7BL2AWr6+0k7oxNShoCpcCYD/b8/ltLEIlEjR8sYOls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5Bp7ti+N5cWfAXjU/18l8/yelODsLP1eUQ5GMmBjELPXFpogISGkELF1xc7WSUas
         ZbeNWnufMmGvpvC8AmcHK5QKcdGKUms8eOGlGiIOM4YtJG3NtqOBHUWRb8RNm1gcjO
         KcvGCzj8UcV/XMaxm82tTKXfOO9O6srviJPiRX7U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211018124510epcas2p41245c8ca2ed1d3f63050472f5d280612~vIKtyJP-z2534425344epcas2p4z;
        Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.98]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HXxRQ11Wdz4x9Q5; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.14.09868.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p4f96cd4d9ea01a030d07fdf25c5a3d163~vIKo9t3kv2534425344epcas2p4t;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp1ae9f772a792b7a8865e85aad609c959d~vIKo5OH-R1588315883epsmtrp1A;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a45-9a3ff7000000268c-7a-616d6c51f00a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.50.08902.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip271bd4b3b0a232dc2494d00fa867a706f~vIKortQeN0235402354epsmtip2q;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v5 03/15] scsi: ufs: ufs-exynos: change pclk available max
 value
Date:   Mon, 18 Oct 2021 21:42:04 +0900
Message-Id: <20211018124216.153072-4-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbVRzHc+4ttxcC7lKGHkGk69wMFVhLKL0YngPmnSMdmWEzZMIu9Fqg
        T9tiHCYGdLzkVYYRVyZDzHTBRyfrGDPAugIhg0XimKMjujEoko4QxyNqIUxvuUz33+f8zu97
        vr/f75yDo4I5LAwv0ZkZo47WiLAAXu9QFBlzRKOlJf33UPKG+1uMnOnoxUiP9xeMvP6gjkd+
        +siLkiu2r/zIyWuvkA1XM8hxSxdCnr5v4ZFumxUlu1y9COlar/Yjf1j6GyE/mxhEyPqpPoz8
        evQxQm54nUiagJq8fYiyVjRi1GRTI0JduiCmvuz3IFRPdx1GWbocgPrLVotRy/PTPKrJ3g2o
        1Z4XqRpHPZITmKdOKmZoJWMUMroivbJEp0oWHXqjIKNAliCRxkgTSblIqKO1TLIoMzsn5kCJ
        hm1OJHyX1pSxoRzaZBLtS0ky6svMjLBYbzInixiDUmOQG2JNtNZUplPF6hjzq1KJJE7GJp5Q
        F9/yNKOGFb/3zrvW/CpApd/HwB+HRDycnXEgPhYQfQBOLLPxAJZXAHTe7txe/Ang48a7yBOF
        paYD4TYGAKw7dwvl5MsADriNPsaIGGhfeAh8STuJPwB0z33C9y1Q4gEKqy5Wbx0VQhyBA6c/
        5PuYR+yBZ6+2bxUVRKTC1ZtVgLOLhMPrdVsO/kQabOgaRricYHjjjJvnY5TN+ehyO+ozgIQb
        h9N3f8I4cSbsHLuDchwCH47a+RyHQU9zNZ8T1ANYNfvP9sY3bEOV2RynwvU2O1sRzjpEQduP
        +3wIid1weHrb9xlYO7TJ58JBsLZawAlfho4rbTyOI2D92dXtWVOw5pSNz02uFcDKK/2YBQit
        T7Vjfaod6//GnQDtBs8yBpNWxZjiDNL/rrhIr+0BW69dnNUHWpcexToBggMngDgq2hlUmKWl
        BUFK+mQ5Y9QXGMs0jMkJZOywW9Cw0CI9+1105gJpfKIkPiFBKo+TSeSi54ISQ9W0gFDRZkbN
        MAbG+ESH4P5hFUhk5Kqlrff7KC0VcdnVShcdG93EjGs0ruifP6HOEwwG71CMb1wfM6+0tyz2
        8+Pz8d8u7R/0DuIjF0pT0gUBwc8HjnSkvfa2N9wxNSh/oWF38KnWa9Lz9OGS4Wjxrx8cHC8N
        UYS//3tYZ7ogrXZsbTF6ajYvta8+05EhzqXMc69/rmjeKBUGLqWE5q7vzR+i33R5ugyqoejw
        2kKLRXP8qHtk1BHR8/PN8rdeWrCORayXyr8IvzdTyuyKNig0anQqHZutDG2ZyCjEHTv2WhOK
        1gru55xcPJfEHG2aT84vz9bLjinX9jTNecr3jx4/IHC+s5mlPNwoK/zO3pB78U51xYKIZyqm
        pWLUaKL/BRDLh1l2BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwZVjXBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLSfcnsFg8WT+L2WLRjW1MFjd+
        tbFabHz7g8lixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        l172Mxd8Yq1YeuMLawNjI2sXIyeHhICJxIT2eUwgtpDAbkaJDRPMIeKyEs/e7WCHsIUl7rcc
        AarnAqp5zyhx9PpCNpAEm4CuxJbnrxhBbBGBj4wSc75pgRQxC7xlljh/8A1YQlggQGJT53aw
        SSwCqhJzds4G28wrYC/x+UwrI8QGeYkjvzqZQWxOAQeJnkVHoC6yl1j8cjYzRL2gxMmZT1hA
        bGag+uats5knMArMQpKahSS1gJFpFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcAxq
        ae5g3L7qg94hRiYOxkOMEhzMSiK8Sa65iUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcS
        SE8sSc1OTS1ILYLJMnFwSjUwJaY3NZXdFtTepN9xbfoi7te6k/mdjA8nZpUmHLi3+irTn/3m
        u3OMvmj055YqudW8MJb+J33yyceXbI8mfVPn5j24pZur58QsyxkCy11m3Pg937Ews5RX+ETb
        8pdvmUtOJzRve3nLo+TbFR22DTWzTMv+ZW4MLjf1FHeeUSKps9vla4xTp5Zd56y1Ufv7Cu+7
        LHN/VZ5wp6RkVf4Cq8DGxyb37U4rqURlVXC9bK32M51Z7rS+b6Vuj+ebD1d7WNmuqH2f1SY+
        7+Sr4CvSuTs5QuVcZO9N9liysejqtN+mV5PtTdNbi1sDd65SsDpy605J8tKZmjwFEnw/Nx4T
        jNoXHLs/bt9V4SN/uB6d27JRiaU4I9FQi7moOBEA4NMKXTADAAA=
X-CMS-MailID: 20211018124505epcas2p4f96cd4d9ea01a030d07fdf25c5a3d163
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p4f96cd4d9ea01a030d07fdf25c5a3d163
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p4f96cd4d9ea01a030d07fdf25c5a3d163@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To support 167MHz PCLK, we need to adjust the maximum value.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index dadf4fd10dd8..0a31f77a5f48 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -99,7 +99,7 @@ struct exynos_ufs;
 #define PA_HIBERN8TIME_VAL	0x20
 
 #define PCLK_AVAIL_MIN	70000000
-#define PCLK_AVAIL_MAX	133000000
+#define PCLK_AVAIL_MAX	167000000
 
 struct exynos_ufs_uic_attr {
 	/* TX Attributes */
-- 
2.33.0

