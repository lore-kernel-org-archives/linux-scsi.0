Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155B3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B5C60FD9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhJRMrd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25004 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhJRMrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:25 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211018124511epoutp032938a3aa878c247ff093997c28148a18~vIKu-cvdW2301523015epoutp03Z
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211018124511epoutp032938a3aa878c247ff093997c28148a18~vIKu-cvdW2301523015epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561111;
        bh=60fMYH33nH83Uo43de5jlx3g814dw/4ZZLG06EJftwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1xMvqvKMf2/ttELD3z6DqRSONgrdfwmoW54LmpAZGONtheS+5H/v5iaqVF+Zeu+S
         fX43P8wI1gKcErhuYdxV2NxK9u0syLTfht0cnw+Bnv/NSWF1eRwZvhcMA1kru6rRny
         wPggrE/gPR4QmyP3xB7kHgPr31m/4tI3DZh1zeFM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211018124510epcas2p26fbf07c026084c096bf362a334a56187~vIKtzowH92095320953epcas2p2K;
        Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.90]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HXxRP6XxDz4x9Ps; Mon, 18 Oct
        2021 12:45:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.2C.10014.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p32c65e409d95954c4995f8a1c22842509~vIKpHL9L52766327663epcas2p3J;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp2964beef852d2704e165423693b6d7293~vIKpGPEHk2052720527epsmtrp2K;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a47-473ff7000000271e-88-616d6c5148b4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0C.40.08738.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip23a49048def72e86f318cd7b06c1adf97~vIKo3oSsR0235402354epsmtip2r;
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
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v5 05/15] scsi: ufs: ufs-exynos: add refclkout_stop control
Date:   Mon, 18 Oct 2021 21:42:06 +0900
Message-Id: <20211018124216.153072-6-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxbVRj23FtuLx8lF7axM5IhKXETFmgLLb0YGMyx7WKJQYVo+INXuFLS
        z/W2TsRolY/B+BAYSldhCmaKzNlZOsoGAgILQbNsCxILGgIDJls2xscIXzJsuUz37znv+zzv
        877vOQdHA//EgvE8rZExaGm1EPPhtfeHx0a+ptbQ4rmWGHJo+geMnDjfjpH31kYw8pfJMh75
        xfwaSi7avvUih3sOkRVXj5K/VTcj5LTNipLNrnaEdK2XeJE/PVxFSMvNboQs/6MDI78bfIKQ
        G2t9SFIANfy7grKaKzFquKoSodpaIqhvuu4hlL21DKOqm3sBtWIrxaiFmTEeVeVoBdSSPYQ6
        3VuOpPllquKVDJ3DGEIZbbYuJ0+bmyBUvJF1NEsWK5ZESuJIuTBUS2uYBGFyalrk8Ty1ey5h
        6Hu02uQOpdEsKxQdjjfoTEYmVKljjQlCRp+j1sv1USytYU3a3CgtY3xJIhZHy9zEt1XK5idK
        fT///dkrZswMLmFngDcOCSlcKO328uBAogPAoc9kHF4E0FHpewb4uPESgBOrTt5TQUlTPZ9L
        XANwo7N357AAYHFP3XZZjIiEjr/vA09iN/EIwOmpum0WSvSicOrqmtsQx3cRCug6h3sEPOIF
        WHjWCTxYQCTC8ZsdgLN7Hg6sl6Ee7E0kwYrmAYTjBMChc9PbLaFuTuGVL1FPfUhM4PD2yKd8
        TpwMuxq/Qjm8C94fdOzEg+HS3M8YJyh3t31naydxEcCyT1I5nAjX6x3bjaJEOLRdE3kgJMLg
        wNiOrz8s7d/kc2EBLC0J5IQHYa+zfmdb+2F5w5IXR6HghgtyuzoL4IXaNX41CLU+M431mWms
        //t+DdBWEMToWU0uw0brY/6732ydxg62X3nEiQ5geTgf1QcQHPQBiKPC3YJ3jmnoQEEOnf8B
        Y9BlGUxqhu0DMveua9DgPdk69zfRGrMk0jixNDZWIo+WieXCvYK4PSo6kMiljYyKYfSM4akO
        wb2DzYj/1ukRUcrjQeVsEt6wfCrzoMKSWlCf0s1Lv+u/l333VpCmwXe1qtYn/SPlcw/G0cNl
        +TOXH5mL2oIujdvKe1ZuD9k/RhB2pTF1OMkyGNO19OqBcH1+wPytSj94pJSyb+Wp3jIonKqp
        UVdnUnV8zYv22fPSB6aiI+NbInlQmLFFYBjlWy87RvFXTPtOLt+orfkcbw+bzHAdKPAVOb6/
        iPkX3i16ear15JiY/ZW5bh2iRMu5IXUFdzbDPuyKeLNSkvFXov9kmHwuoxFR2KeTJcXhtvT+
        7NdlP4Yc0t/ILG7MbmKOnbIUVlzvpPyOF4TPbO6bf2xvki7sX2xzpvxzYUXIY5W0JAI1sPS/
        AG+P224EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwcRrYhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZzDi/j8mi+/oONovlx/8xWfz+eYjJQdDj8hVvj1kNvWwel/t6mTw2r9DyWLznJZPHplWd
        bB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAJ4rLJiU1J7MstUjfLoErY9G/jILD
        7BUvtjawNTCuZeti5OSQEDCRaFs4nb2LkYtDSGAHo0TXqQZmiISsxLN3O9ghbGGJ+y1HWEFs
        IYH3jBKf/lqB2GwCuhJbnr9iBLFFBD4ySsz5pgUyiFngFLPE2nWbWLoYOTiEBbwlbszkAKlh
        EVCVaJ68HayeV8Be4t75HYwQ8+UljvzqBNvLKeAg0bPoCBPELnuJxS9nM0PUC0qcnPmEBcRm
        Bqpv3jqbeQKjwCwkqVlIUgsYmVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgRHnZbW
        DsY9qz7oHWJk4mA8xCjBwawkwpvkmpsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0
        xJLU7NTUgtQimCwTB6dUA5P0N/fnkmymswrXPr/qktd6OP/FkdczmSv/L5q64XMWo8jC5YUT
        16l6WX+4EKdXs0R037fVPXsqrti/ai7ysTTz+FPQfntOs7KMxc78in03AianfDs+K21BQTez
        tN27gI5NbnJRKfZsGxesf9LsZDN1ceWZXUYV+2X5VOJfO3R/45n50i5YdfsHsfv9h5Si7CaG
        fZebE5jR3auU/lN92ZelF1y2iHdf5mhhilMU545TrQ/X09D6oLX7m8OMIOGp01gfML1veMzJ
        UjZxcuE+t5plx1KK97O+494syN98YcP86YHnN1cH7haIZvK8zHH4pkroZvWpKcnzW2bMypBs
        u/JCeEf7pHb1wBjHlxvqkpVYijMSDbWYi4oTAV3Ug5MpAwAA
X-CMS-MailID: 20211018124505epcas2p32c65e409d95954c4995f8a1c22842509
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p32c65e409d95954c4995f8a1c22842509
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p32c65e409d95954c4995f8a1c22842509@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds REFCLKOUT_STOP control to CLK_STOP_MASK. It can
en/disable reference clock out control for UFS device.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 57210114ca0a..e75736ce1534 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -48,10 +48,11 @@
 #define HCI_ERR_EN_T_LAYER	0x84
 #define HCI_ERR_EN_DME_LAYER	0x88
 #define HCI_CLKSTOP_CTRL	0xB0
+#define REFCLKOUT_STOP		BIT(4)
 #define REFCLK_STOP		BIT(2)
 #define UNIPRO_MCLK_STOP	BIT(1)
 #define UNIPRO_PCLK_STOP	BIT(0)
-#define CLK_STOP_MASK		(REFCLK_STOP |\
+#define CLK_STOP_MASK		(REFCLKOUT_STOP | REFCLK_STOP |\
 				 UNIPRO_MCLK_STOP |\
 				 UNIPRO_PCLK_STOP)
 #define HCI_MISC		0xB4
-- 
2.33.0

