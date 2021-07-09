Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A821C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ACC8613CA
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhGIHAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19175 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhGIHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:34 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210709065749epoutp01eb62c6302da0cbaaaab1f4dabbbb6aa0~QDRnFflzA2701027010epoutp01W
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210709065749epoutp01eb62c6302da0cbaaaab1f4dabbbb6aa0~QDRnFflzA2701027010epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813869;
        bh=+NvnCRYZDuwOoP6rJbO1B9XZXcaYPfI0ehtyS82Pos4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfpRxEMijfjopiRuCva1yMCT/ioogN9cFmJr5T/yT8vlGp3EyZmTRmMxi9fSLPs8F
         jxmSHO1Z8pCV5ArGsWVSwIiv3CDNVryHFQgD4UurOoqXHbZj/bEi0v1POmSb1hecy6
         Xc0EEAATfTgmgdGZnnst+t8+KI6HyUOTo9uGQI5s=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210709065748epcas2p4aa7f5db6442eeaee46ed0ba364888dae~QDRmKOiw60617006170epcas2p4w;
        Fri,  9 Jul 2021 06:57:48 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GLkWH2kQ6z4x9Q6; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        5E.A3.09921.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p1367527fd1299b15fc339876281cb8af1~QDRkIFMJr0966009660epcas2p1T;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp1c4be962e3453f3107fed9dfa7697c353~QDRkHRwuL3179431794epsmtrp1Q;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a45-fb3ff700000026c1-94-60e7f36bb4c4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D5.63.08394.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip21bf5fcce29d6ce67a179a1331e9fdd3a~QDRj4AIIn3077030770epsmtip2P;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 06/15] scsi: ufs: ufs-exynos: add refclkout_stop control
Date:   Fri,  9 Jul 2021 15:57:02 +0900
Message-Id: <20210709065711.25195-7-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1AbVRj17obNQqVdUyrXCDZdES0aSqKBBUsfFHW1nSnKjDP2D8nA8hjy
        aja0asdapoUCkWcpz1BSUAqxThQoTZFnoCJUBoUqNqNIK9gJim14aTptMWGj8u989ztnzvm+
        ey+OCr7BhHiGWs/o1AolifnxOga2R4ozF2/LI8rv4NTwzEWMmj7XgVEO1/cYVXHXhVILliYf
        aqL3eeqjK/uoayUNCDVjqUGphh87EKrlB4q60X6VR1WN9SCUYdKKUReGHiJ7NtET1/fTE0WF
        CN3WHEY3djkQutWcj9ElDX2Ads7aeXRRuxnQi61P0af7DEiC3yHlznRGkcLoRIw6WZOSoU6L
        JfcnJu1LkkVGSMSSaCqKFKkVKiaWjD+QIH41Q+kegRQdUSiz3EcJCpYld+zaqdNk6RlRuobV
        x5KMNkWplUi04axCxWap08KTNaoYSUSEVOZmypXpP9n7+Npi/rtDTqvPCfDQpwD44pB4CU5b
        p9zYDxcQVgAv1bTxuGIBwOr7wyhXrADY+efcf5Llws8wrtENYEX9r16JE8DS32dRDwsjxLD9
        9hzwNAKIYgAv9NatsVBiGIXXTP18D2szQUOnoRx4MI94Bo4MnMI82J/YBZdujmGc31Y40tSP
        eLAvsRue+7sE4TiPweHqGZ4Ho27OyUu1a2EhMYjDqdUWHieOh9/O5XiDb4ZzQ+18DguhoziX
        zwkMAObcWvU2PgUwP/sAh3fDe5XtbjHudtgOLZ07PBAST8NBu9d3I8wbeMDnjv1hXq6AEz4L
        +y5XehMEQ4Nx0ZuAhhbTx4DbVpl7264eUAJENevGqVk3Ts3/xiaAmsHjjJZVpTGsVCtZf8mt
        YO1Zh71iBWfm74bbAIIDG4A4Sgb4S6t+kwv8UxTvvc/oNEm6LCXD2oDMvexSVLglWeP+F2p9
        kkQmjYyMiJZRskgpRQb643ybXECkKfRMJsNoGd2/OgT3FZ5A6F/yP++cN3/3l/O5gCD5NlNI
        mWtDs7HxyahjLybnJPEXlrJDQts2Oiz3yjtPXrwxbrj+4IvDiaqugkcqcL0RfugY1x+anRwZ
        bAyuO/vapHAg5g/LFflKfZboifpR+djRxL2GTbKVVcfLuQe7KVPsXqEpZrR2+XhR89vim9Yt
        dzZUnU69ipe9NV1teecIvqfL9/h8oCDoTHlItfj1paaGF+JG0xNDHcf6P6lk32ipCg4/++ZR
        uzHvoNSRmdpa+2jx5aAvl8/7dsQVHi44FWcvQslCJhs9H1A6vhU1xMtUZR8E8qai+BPdrlyT
        Kfyr+6ZeY4/852ht3dKt2NSvtTYzPxQjSB6brpCEoTpW8Q/g5+jHXwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg92fFSxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfGnVsH2Av62SuOf9zB2sD4j7WLkZNDQsBE4mvv
        WrYuRi4OIYHdjBIX9ixgh0jISjx7twPKFpa433KEFaLoPaPEoaetYAk2AV2JLc9fMYLYIgIT
        GSWW3BMDKWIWuMws8W3aFWaQhLCAh8TH7ilgRSwCqhKnDrewgdi8AnYSXx6eZ4PYIC9xatlB
        JhCbU8BeYt6PCWC2EFDNvQ372CHqBSVOznzCAmIzA9U3b53NPIFRYBaS1CwkqQWMTKsYJVML
        inPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIjSktzB+P2VR/0DjEycTAeYpTgYFYS4TWa8SxB
        iDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqY9Zt1RZVsn
        ZejNdk979SKh8crK8EnTjq16wlKjJFsz7eX0S09jWzLO9b+Ln/uoTOPfvYrjbv2XV/RnJTqm
        HhNQWKNtm8v5h/vL2n+HThn4ruKQW+S7he/j2vtLJp1q2LG3/8Pt7+9XRc+cI+sY3nam7dEe
        BdsZDlt2nKj+pB1x6fP3WpOqG26LRFJOX11yukL+sGe4drzk8S0f9s2pXhB5suuw2em1ZQdu
        L/f9PmG60fxPny4FsZ1gPVd3ZXtxlUyUaxXnqmes7+d9585IdNn26qOIZYaB7CJWA9UH/6Vn
        3ttz2GhJXfec7sp7h51MRR+yK7Tnud29fST+5IkbJu3uBzrdXdff4KurEzNdqG/FqsRSnJFo
        qMVcVJwIAGN4erkXAwAA
X-CMS-MailID: 20210709065746epcas2p1367527fd1299b15fc339876281cb8af1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p1367527fd1299b15fc339876281cb8af1
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p1367527fd1299b15fc339876281cb8af1@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds REFCLKOUT_STOP control to CLK_STOP_MASK. It can
en/disable reference clock out control for UFS device.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index da02ad3b036c..78cc5bda0a1f 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -49,10 +49,11 @@
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
2.32.0

