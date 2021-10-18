Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7419EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BAA60F8F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhJRMr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52710 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbhJRMrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:25 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211018124509epoutp027ceacb962883642369855e03bf18639f~vIKs9XCmd0581205812epoutp02C
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211018124509epoutp027ceacb962883642369855e03bf18639f~vIKs9XCmd0581205812epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561109;
        bh=8dvnhWSaJ+9vjb8lIZYUcv+yQGobrg6XUCfwveMvo1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtDB6yWhP4KHTeRcjG/uLs7u1OKHz9E1t5p2PH5ir0afge7JDZ3V6FtBTZDM1qQTx
         0ZQljqHBrMam+jheEdKmlJBeM3c5HTqalJckh0JJvdy8ty03rUcPj+4B1pwAPIyu7R
         /jgZ1TwKMoMoPvnFb6c4GJU8EwY3yxp4iEUEgpYk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211018124508epcas2p4f9763b1bcf68f8eeacf90293f9b2336e~vIKr_Xdn52534425344epcas2p4x;
        Mon, 18 Oct 2021 12:45:08 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.92]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HXxRQ5LN0z4x9Q8; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.2C.10014.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epcas2p25100e2163029de4ee8b8b87e7ff0f2a3~vIKp0MopA2095320953epcas2p2F;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124506epsmtrp122fa173750b7b54e954f13994c97e9bc~vIKpzU7US1588315883epsmtrp1E;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
X-AuditID: b6c32a47-489ff7000000271e-8f-616d6c52cc00
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.50.08902.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip249dd087dfefdf6cc81d95a82b08fb408~vIKpik-5U0378903789epsmtip2e;
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
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v5 12/15] dt-bindings: ufs: exynos-ufs: add io-coherency
 property
Date:   Mon, 18 Oct 2021 21:42:13 +0900
Message-Id: <20211018124216.153072-13-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJsWRmVeSWpSXmKPExsWy7bCmhW5QTm6iwdtmNYuTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFpf3a1vMP3KO1aJnp7PF6QmLmCyerJ/FbLHoxjYmixu/
        2lgtNr79wWQx4/w+Jovu6zvYLJYf/8dk0br3CLvF75+HmByEPS5f8faY1dDL5nG5r5fJY/MK
        LY/Fe14yeWxa1cnmMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniism0yUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgD5UUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRnfDwxj73gPGfF
        kU9pDYyf2LsYOTkkBEwkbp88zNzFyMUhJLCDUeLNswMsEM4nRomNX9cyQjjfGCVWbp7NAtPy
        +chTqMReRonG791QzkdGiU9zv7OBVLEJ6Epsef4KLCEi8J5R4snjKewgDrNAA4vE61sdjCBV
        wgLBEotmrGQGsVkEVCU2/F8HtoNXwEHiy8IzbBD75CWO/OoEq+EEivcsOsIEUSMocXLmE7B6
        ZqCa5q2zwd6QEHjDIfH6XR9Us4tEw58ZzBC2sMSr41ug/paSeNnfxg7R0M0o0froP1RiNaNE
        Z6MPhG0v8Wv6FtYuRg6gDZoS63fpg5gSAsoSR25B7eWT6Dj8lx0izCvR0SYE0agucWD7dGhw
        yUp0z/nMCmF7SPx99BYaWpMZJR5sa2WawKgwC8k7s5C8Mwth8QJG5lWMYqkFxbnpqcVGBcbw
        OE7Oz93ECE7zWu47GGe8/aB3iJGJg/EQowQHs5IIb5JrbqIQb0piZVVqUX58UWlOavEhRlNg
        YE9klhJNzgdmmrySeEMTSwMTMzNDcyNTA3MlcV5L0exEIYH0xJLU7NTUgtQimD4mDk6pBiaT
        /X7qKxsmzJSfYrnS78O3W31z5Kers6qWTp85rd77gUPwPY7yLWrXVMT2zN2al6qrojmtR9Os
        LeJtQlvxuiMvW9bMumSkOT2wqvCJ4EXNlivZv3u69j+L+77wd6Z2pQW7SfOBxRktL37wiJw7
        s8vwWuGsbWXh9om6iq3a3YvX2kZd6vL8fI3LchcbS+aaJbYHPx4Q9YwxvcrSH9Z39Kumy/JF
        ywX2ZQfd/3J+6dGyG18Oejl8CVaS8v7rHfhm75wLG97F2ymHf/mmx7R96XSbau2TWtFt+s9P
        V/hLTjuw4R/XyoCFTyWfBwgW3byyQL1uqfGbdJuWxu+Cfg43L5xeGxk75bYeg4Bynf3s5ElK
        LMUZiYZazEXFiQC2WsZFfAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSvG5QTm6iwax9bBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17aYf+Qcq0XPTmeL0xMWMVk8WT+L2WLRjW1MFjd+
        tbFabHz7g8lixvl9TBbd13ewWSw//o/JonXvEXaL3z8PMTkIe1y+4u0xq6GXzeNyXy+Tx+YV
        Wh6L97xk8ti0qpPNY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5DzaD3QzBfBEcdmkpOZklqUW
        6dslcGV8PDGPveA8Z8WRT2kNjJ/Yuxg5OSQETCQ+H3nK2MXIxSEksJtRYs/mt1AJWYln73ZA
        2cIS91uOsEIUvWeUmNWzHizBJqArseX5K0YQW0TgI6PEnG9aIEXMAj0sEk+7W8ESwgKBEo2v
        9jOD2CwCqhIb/q9jAbF5BRwkviw8wwaxQV7iyK9OsBpOoHjPoiNMILaQgL3E4pezmSHqBSVO
        znwC1ssMVN+8dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93E
        CI5GLc0djNtXfdA7xMjEwXiIUYKDWUmEN8k1N1GINyWxsiq1KD++qDQntfgQozQHi5I474Wu
        k/FCAumJJanZqakFqUUwWSYOTqkGpobFv3/0HLrwcm3t80VyS+c+evx99doa6c8HGJgj4nZl
        hE3VPsbvfjxNyNs4p12I40fst+8zY5+fvzC55Foi74RFC9JuWDx9Y/ruXOl9zQA3A46V6g+E
        jere7v4kc2hm9vS51/bs/ybhwlTzJnW6JafC8ifCxxbF3vtpdnatc3ec2r3bNcFbv3+9v2MD
        p3/JxH2eqVyLT/LqHFofsL1hS8Qvj7dT3/U3CovN/vRfX3OST+erI0dPlf+c9XHulUV8NTKF
        K459iTT27WCtfqt9/NRrS/b1X+PqqqVCcvX+8ZnMdqqW+PVBQzXKOmVi2jNDN7bdp6Nj8yd3
        WFaoVrxi8XKVTgizfb333OQPzCluTh+VWIozEg21mIuKEwHCKx6LNQMAAA==
X-CMS-MailID: 20211018124506epcas2p25100e2163029de4ee8b8b87e7ff0f2a3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124506epcas2p25100e2163029de4ee8b8b87e7ff0f2a3
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124506epcas2p25100e2163029de4ee8b8b87e7ff0f2a3@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add "samsung,sysreg" regmap and the offset to the ufs shareability
register for setting io coherency of the samsung ufs. "dma-coherent"
property is also required because the driver code needs to know.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml       | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index b9ca8ef4f2be..691741f9d6c0 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -54,6 +54,14 @@ properties:
   phy-names:
     const: ufs-phy
 
+  samsung,sysreg:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    description: Should be phandle/offset pair. The phandle to the syscon node
+                 which indicates the FSYSx sysreg interface and the offset of
+                 the control register for UFS io coherency setting.
+
+  dma-coherent: true
+
 required:
   - compatible
   - reg
-- 
2.33.0

