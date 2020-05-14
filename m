Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0A0C433E7
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA7B20659
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fQdMBxEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgENAxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:53:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46136 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731138AbgENAxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:53:08 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200514005306epoutp04a06b3c750ea0f14ec0cffb8f7f08d658~Ovt_f-w8k0825508255epoutp041
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:53:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200514005306epoutp04a06b3c750ea0f14ec0cffb8f7f08d658~Ovt_f-w8k0825508255epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417586;
        bh=DDMCtAVCNOenQhQBx8fCmPqcdSKUIHqMO34BELtm7U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQdMBxEc3L2+WffDjQ9ZV56VN5301Z5utWItEqJgRyaQciGK1BcJXcZU+7SUBVBRM
         8U3VWtRlNrNMKU84V6bbAv+VdrIXrEBCsZspqCow5ER7PXE5u+EBjF7wquXBHtx20x
         Kd3txFE3WnIChBjbWqtUL34qMUmRXFyq964iUq50=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200514005305epcas5p46fe6ee93d80fa03efeb41a2d276f382a~Ovt9mHVCY0660506605epcas5p4K;
        Thu, 14 May 2020 00:53:05 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.7E.23389.1769CBE5; Thu, 14 May 2020 09:53:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200514005304epcas5p37a311f813416383b6de8af6e809b350d~Ovt9REbwM0461904619epcas5p3S;
        Thu, 14 May 2020 00:53:04 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200514005304epsmtrp2db26465d2d8f3551167e82cf61e517fc~Ovt9QTndV1522815228epsmtrp2S;
        Thu, 14 May 2020 00:53:04 +0000 (GMT)
X-AuditID: b6c32a4b-7adff70000005b5d-f9-5ebc9671d30c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.82.25866.0769CBE5; Thu, 14 May 2020 09:53:04 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005302epsmtip2dbb136258d86cd9c3268230721ddeb37~Ovt7TwN1T0066900669epsmtip25;
        Thu, 14 May 2020 00:53:02 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v9 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Date:   Thu, 14 May 2020 06:09:10 +0530
Message-Id: <20200514003914.26052-7-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514003914.26052-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsWy7bCmum7htD1xBqtesVs8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujF99+xkLLohWtMw6z97AeE2gi5GDQ0LAROLBj5IuRi4OIYHdjBL/m34xQTif
        GCXeH+sFcjiBnM+MEpdOeYHYIA2Nq64yQxTtYpTYs6aREaKohUnixpM0EJtNQFvi7vQtYM0i
        AsISR761gdUwC9xgkniw0gVks7CAv8SRdg8Qk0VAVeLQnXyQCl4BG4kt638wQ6ySl1i94QCY
        zSlgK7HlyzFWiBpBiZMzn7BATJSXaN46G+wcCYEDHBJTtp5hh2h2kZjZ0QtlC0u8Or4FypaS
        +PxuLxvE89kSPbuMIcI1EkvnHWOBsO0lDlyZwwJSwiygKbF+lz7EKj6J3t9PmCA6eSU62oQg
        qlUlmt9dheqUlpjY3c0KYXtI7L0+iR0SUBMYJTpenWCbwCg/C8kHs5B8MAth2wJG5lWMkqkF
        xbnpqcWmBcZ5qeV6xYm5xaV56XrJ+bmbGMFpSst7B+OjBx/0DjEycTAeYpTgYFYS4fVbvztO
        iDclsbIqtSg/vqg0J7X4EKM0B4uSOO/jxi1xQgLpiSWp2ampBalFMFkmDk6pBqaqKivHzeev
        L3lw/S3L5qfO2azVN71LL7IqKr3yucbat5fpXsLrY0tP753clm5boDOrmYv5YerrDRFGz0t+
        JD2blDNZvzrA8s3CZYlMu6Im2M8JOyNx9sE+3X2Trb5++Xx/9Y3k7Bonlv5Ftl+l9S4tvf7z
        Je+zKwHbo5zsuOQeb9s+s1Y2+9ou7rynd8WCjmqwzNyyp+fZpWcXDpg8vs/ZfGLV7C3uczyf
        qC+//fnJ1fP1h45yPAg7Vz/5p8VKtWSz+Ye2Xe7ep25RoW6/qWbmPNHisB2/bndOKnp3e/YF
        BhfO1OnuK4x+J86Kr3Sa+9LxXtjamJa7DXwLni7e9UBi8uNWacc9p3dc2evnmLE6/Z8SS3FG
        oqEWc1FxIgCLmpb/wgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJXrdg2p44gxmHtSwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxq++/YwFF0QrWmadZ29gvCbQxcjJISFgItG46ipzFyMXh5DADkaJOTc/sEIk
        pCWub5zADmELS6z895wdoqiJSeLGisdsIAk2AW2Ju9O3MIHYIkBFR761MYLYzALPmCROPSwF
        sYUFfCVu7t7E0sXIwcEioCpx6E4+SJhXwEZiy/ofzBDz5SVWbzgAZnMK2Eps+XIM7AYhoJpl
        a5YxQtQLSpyc+QRsDLOAusT6eUIQm+QlmrfOZp7AKDgLSdUshKpZSKoWMDKvYpRMLSjOTc8t
        Niwwykst1ytOzC0uzUvXS87P3cQIjiwtrR2Me1Z90DvEyMTBeIhRgoNZSYTXb/3uOCHelMTK
        qtSi/Pii0pzU4kOM0hwsSuK8X2ctjBMSSE8sSc1OTS1ILYLJMnFwSjUwnSzbtp0r+FGlzVz+
        qOTk0MlXW18tO9iofMzqR3yPzdvnj78/svd/suCzcMqKQ25n2f4emzm96GaX9NUF+gyquzj3
        bmhtlYjZnVE1YV3vs5Vrlwhs0v59PnvngvY83skKgpvPrXvifeHDpGmWbRovQ+5O2H5TmTf+
        ++ablTW5O1m73mut/ekasdhVxOSQrODp8vj9GjwXJt5itF6edujDnWn/n83wtJy2S5xpWXNy
        x0SmtLio1Or2fcKOsoYtZjtbfWYKTepQXHMo3b0nceO7CU139/9aHKhzlFHoXv/On9JT08xZ
        /zK+eVlyrvtZ2KJ9k86em7Hx57fcrv3ty5aJfc+bHVa10meiWdnUk68XH7+qxFKckWioxVxU
        nAgAMQZ56xsDAAA=
X-CMS-MailID: 20200514005304epcas5p37a311f813416383b6de8af6e809b350d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005304epcas5p37a311f813416383b6de8af6e809b350d
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005304epcas5p37a311f813416383b6de8af6e809b350d@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch documents Samsung UFS PHY device tree bindings

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 .../bindings/phy/samsung,ufs-phy.yaml         | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
new file mode 100644
index 000000000000..636cc501b54f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
@@ -0,0 +1,75 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/samsung,ufs-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Samsung SoC series UFS PHY Device Tree Bindings
+
+maintainers:
+  - Alim Akhtar <alim.akhtar@samsung.com>
+
+properties:
+  "#phy-cells":
+    const: 0
+
+  compatible:
+    enum:
+      - samsung,exynos7-ufs-phy
+
+  reg:
+    maxItems: 1
+
+  reg-names:
+    items:
+      - const: phy-pma
+
+  clocks:
+    items:
+      - description: PLL reference clock
+      - description: symbol clock for input symbol ( rx0-ch0 symbol clock)
+      - description: symbol clock for input symbol ( rx1-ch1 symbol clock)
+      - description: symbol clock for output symbol ( tx0 symbol clock)
+
+  clock-names:
+    items:
+      - const: ref_clk
+      - const: rx1_symbol_clk
+      - const: rx0_symbol_clk
+      - const: tx0_symbol_clk
+
+  samsung,pmu-syscon:
+    $ref: '/schemas/types.yaml#/definitions/phandle'
+    description: phandle for PMU system controller interface, used to
+                 control pmu registers bits for ufs m-phy
+
+required:
+  - "#phy-cells"
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+  - samsung,pmu-syscon
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/exynos7-clk.h>
+
+    ufs_phy: ufs-phy@15571800 {
+        compatible = "samsung,exynos7-ufs-phy";
+        reg = <0x15571800 0x240>;
+        reg-names = "phy-pma";
+        samsung,pmu-syscon = <&pmu_system_controller>;
+        #phy-cells = <0>;
+        clocks = <&clock_fsys1 SCLK_COMBO_PHY_EMBEDDED_26M>,
+                 <&clock_fsys1 PHYCLK_UFS20_RX1_SYMBOL_USER>,
+                 <&clock_fsys1 PHYCLK_UFS20_RX0_SYMBOL_USER>,
+                 <&clock_fsys1 PHYCLK_UFS20_TX0_SYMBOL_USER>;
+        clock-names = "ref_clk", "rx1_symbol_clk",
+                      "rx0_symbol_clk", "tx0_symbol_clk";
+
+    };
+...
-- 
2.17.1

