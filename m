Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D54C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A60F61164
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238584AbhIQG45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:56:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53808 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp011820cc6198cece0aa7d5dfd9fe31307b~liZgYBPQF0674406744epoutp01g
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210917065526epoutp011820cc6198cece0aa7d5dfd9fe31307b~liZgYBPQF0674406744epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=tc0uZzq7xcvc4vhtgqkHflrQXkhw5OzNX5MhWBfkhxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZB1sBBceJtAAHpTdoj2E8TBFWpUyTclk2mPUkP7E281mzoYDdyGXjMjU8pp+9gu/
         AdH+OiXytXbE5Sd+PrWVaYN5PrrFTWVeOoBb4+F4WzYTgpYSJV0aHCLsNdKyj+t4Mz
         8DLzhph31IC4FaGzzOc4i4KjI1FBEdJgT0k5hTyk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210917065525epcas2p28bc73291141f535486227643f0f56ccf~liZfiUsPY0927909279epcas2p2S;
        Fri, 17 Sep 2021 06:55:25 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H9l8C6MlPz4x9QT; Fri, 17 Sep
        2021 06:55:23 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.43.09816.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210917065523epcas2p3ff66daa15c8c782f839422756c388d93~liZdXvjxE1851718517epcas2p3Z;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065523epsmtrp2db8f0512223859b5c94d1fdde9bbe5e0~liZdWsgtF1373513735epsmtrp2B;
        Fri, 17 Sep 2021 06:55:23 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-11-61443bdb7845
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.91.08750.ADB34416; Fri, 17 Sep 2021 15:55:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epsmtip21a92d287d448f061178b09cc039ba8a8~liZdHXhrv2199021990epsmtip2s;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
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
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 05/17] dt-bindings: ufs: exynos-ufs: add sysreg regmap
 property
Date:   Fri, 17 Sep 2021 15:54:24 +0900
Message-Id: <20210917065436.145629-6-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxjfube9XAzMS+vkhGVaLw4HBqRlrUfHwyFrboAlLLrEmMV6gWsh
        lLa2wAarrmbgqDzCgoirY0xgk4Gz4/0YDAZ16vAVoZF1bhNW42BxKM3CIyJruZjx3+873++R
        7zvnkLjodyKIzNTmcAYtq6GJdYLO4VAU/usbCWykwxKFrrkuEuj+F50EmlpwEOjHCYsAnXm8
        gKNZ29dCNDqwHdXabwpRac9eNFJRhyGXzYqjuvFODLU8msfQ2Vs/YKjkbjeBLlx5hqGifrvP
        ngBmdCyJsZrLCGa0vAxj2hrDmPq+KYxpbbIQTEXdIGDmbMUE8+SBU8CUtzcBxt26iflksARL
        8Tuoic7g2HTOIOG0abr0TK06hk7ap9qrkisipeHSXWgnLdGy2VwMnZCcEq7M1HjmoiV5rCbX
        c5TCGo30jthogy43h5Nk6Iw5MTSnT9fopVJ9hJHNNuZq1RFpuuzd0shImdzDPKzJmHRWYvp+
        nw+KG2aAGViJU8CXhNTrsPH8JHYKrCNFVDeA5tpxwBezAC71FK4WbgCrF8fAc8miq2K10Qvg
        hYElH29DRD0BcHou1YsJKhy2P5xeIW2gZgB0/Xnax1vgVAcOy844VqzE1H5o7u0ReLGAehX+
        4r6MebE/FQcdtSeEfNxmaF+04F7sS+2Bzt5lwHMC4LXPXCta3MP5uOMc7g2A1H0SdtQ88JBI
        T5EAJ2tI3kcMp6+0+/A4CLr/6Sd4fgmARZPLq41mAC0nknkcBxer24VeH5wKhbbeHbxlMLQ7
        V2NfhMXD3uG9x/6w+KSIF26Dg13VAh6/Aks+dwt5CgOLGhT83ioBbBm5BCqAxLpmGOuaYaz/
        534J8CawkdMbs9WcUaaXrb3hVrDy0MOU3eD0o8cRQwAjwRCAJE5v8L9tepMV+aez+QWcQacy
        5Go44xCQe1b9KR70UprO81O0OSqpXKZQRO6SI7lChuhA/5pn8ayIUrM5XBbH6TnDcx1G+gaZ
        MXZL1iGrMrAoO8DcJjhalTugH1yvMIG3Q+MFX938XndLlX+o0/f2lrf6jv/100epHW41O/PC
        pS5p/PRvV+ud77Rs050li1ITS0biziVHvHzsW3vBnHKJuhjSUr4Qda+KFOPbjwQ7KoQHFT8X
        vL91a8LovvNtKctZsTPDzUtaJfnUoPLrFu//sGtzYWPHeuvRGw0hSeOBNzRz6miXfWJmOKTB
        LzhKPN+Tv3OhPpH8TlZl+/u1h9bG9+4khqfudplpy1RC7LGxvOnCf4+nfHMy/670aQZn662q
        DLp+Z2Ppu+WmTc2zdLIq7/If830Hmg9cvTcCD5u015exIxNWcWmwZslhSqMFxgxWGoYbjOx/
        Ac6Nj3EEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSvO4ta5dEg/4zNhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17aYf+Qcq0XPTmeL0xMWMVk8WT+L2WLRjW1MFhvf
        /mCymHF+H5NF9/UdbBbLj/9jsmjde4TdQdDj8hVvj1kNvWwel/t6mTw2r9DyWLznJZPHplWd
        bB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAJ4rLJiU1J7MstUjfLoEr49GtyUwF
        e9krOpa8Z2xgnMXWxcjJISFgIvHryQTGLkYuDiGBHYwSP/c3MUMkZCWevdvBDmELS9xvOcIK
        UfSeUaJzzmoWkASbgK7EluevGEFsEYGPjBJzvmmBFDEL7GeW+Nd6kwkkISwQJDHx2BWwBhYB
        VYmbn4+CxXkF7CWuzm9khdggL3HkVyfYZk4BB4lbu/6DDRUCqpk4eREjRL2gxMmZT8DmMAPV
        N2+dzTyBUWAWktQsJKkFjEyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCY09Lawfj
        nlUf9A4xMnEwHmKU4GBWEuG9UOOYKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS
        1OzU1ILUIpgsEwenVAPT6Zdcpx65f2c7wbno9c4fpiw1GwpVEs/VuXx63vB404+901nWfm6p
        Ti/dvCa76cOZ8IkrHzI9s9+c3OffUmNSV7D/f3z0yYnepaueGFvGHj3xTrAlJuJHvembE//X
        WisHp1550hGslZ6nt/KZ6xvtk4oPpXmNHuVzRd89kRli9u9Vo3HZ4RrebLut58/ktjm4RX31
        fMt3W7g4izd506+4eelqzp6N70UEMrjWT2Ktn9Vw4tK58ncmJbc8DBasMD1iHMdUcMF7/2mT
        pamb+33f/Nz/Vq9ttZ+zPpdk/+Sni7956XkwuPPZbeyZ8yfUqsOhjOsvT+KZGd9z3X256813
        XOg86b8wk3nFGvG4yT+UWIozEg21mIuKEwH5prIYLAMAAA==
X-CMS-MailID: 20210917065523epcas2p3ff66daa15c8c782f839422756c388d93
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p3ff66daa15c8c782f839422756c388d93
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p3ff66daa15c8c782f839422756c388d93@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add "sysreg" regmap phandle property to control io coherency setting.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml          | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index b9ca8ef4f2be..c3f14f81d4b7 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -54,6 +54,11 @@ properties:
   phy-names:
     const: ufs-phy
 
+  sysreg:
+    $ref: '/schemas/types.yaml#/definitions/phandle'
+    description: phandle for FSYS sysreg interface, used to control
+                 sysreg register bit for UFS IO Coherency
+
 required:
   - compatible
   - reg
-- 
2.33.0

