Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A364DC5ACDD
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70A652076C
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 11:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o90j8zvM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCRLSP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 07:18:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33645 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgCRLSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 07:18:13 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200318111811epoutp04dd7630832c19455140c989509b18f0fa~9Yeebm-eE3076230762epoutp04a
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2020 11:18:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200318111811epoutp04dd7630832c19455140c989509b18f0fa~9Yeebm-eE3076230762epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584530291;
        bh=0ogGbMGNWOHu+IsRUj8FqJ93r0JgndC1MhFG6E6RBAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o90j8zvM7NAp0p4s7fkQgMqs/DF5a2qVRg7zkqotsTsdKgY8tx9VhjySKLm5hDp0e
         akrh2VH+T4Aak+JEotg3Zs7UdIHubBiHXPP9wYAES+V2nzOJalhCBOOMQOBnqUiHgh
         fk5RD3WE4hPHyiS7vC0lInyCs37GeJ4FQmoUNFhA=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200318111810epcas5p14db4eb88a0aa8b43f734e5f1402626ee~9YedyOSmT3102031020epcas5p1q;
        Wed, 18 Mar 2020 11:18:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8B.4E.04736.273027E5; Wed, 18 Mar 2020 20:18:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200318111809epcas5p37b33e3038ede4797c83682314afc683b~9YedBB80I1474914749epcas5p3B;
        Wed, 18 Mar 2020 11:18:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200318111809epsmtrp25a6b32c6251ca3e7a7138524a3fd2fdb~9Yec_ZN3U3128231282epsmtrp2z;
        Wed, 18 Mar 2020 11:18:09 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-12-5e72037237d4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.3D.04024.173027E5; Wed, 18 Mar 2020 20:18:09 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200318111807epsmtip22fe9d1251e5e09e6c20cf7158dfa803a~9YebNpFXa0257602576epsmtip2f;
        Wed, 18 Mar 2020 11:18:07 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 3/5] Documentation: devicetree: ufs: Add DT bindings for
 exynos UFS host controller
Date:   Wed, 18 Mar 2020 16:41:42 +0530
Message-Id: <20200318111144.39525-4-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318111144.39525-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsWy7bCmpm4Rc1GcwccmBYsH87axWbz8eZXN
        4tP6ZawW84+cY7U4f34Du8XNLUdZLDY9vsZqcXnXHDaLGef3MVl0X9/BZrH8+D8mi9a9R9gt
        lm69yejA63G5r5fJY9OqTjaPzUvqPVpO7mfx+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DK6H24n6Vgi3bF5B+nWRsYpyt1MXJySAiYSHxf8IWxi5GLQ0hgN6PEwZ+foZxP
        jBInL1xignC+MUqsmzWXDaZl8geYxF5GibZXG6FaWpgkNv9czwxSxSagLXF3+hYmEFtEIEDi
        0vuDbCBFzALzmCQWPeoBSwgLZEjc/nYBrIFFQFViwdobLCA2r4CNxPOPl6DWyUus3nAArIZT
        wFbi791WsG0SAvfZJPZvfwBV5CKx+eMMFghbWOLV8S3sELaUxOd3e4FqOIDsbImeXcYQ4RqJ
        pfOOQZXbSxy4MocFpIRZQFNi/S59kDCzAJ9E7+8nTBCdvBIdbUIQ1aoSze+uQnVKS0zs7maF
        sD0kTu18xgIJhwmMEgt/vGKdwCg7C2HqAkbGVYySqQXFuempxaYFxnmp5XrFibnFpXnpesn5
        uZsYwSlFy3sH46ZzPocYBTgYlXh4OTYUxAmxJpYVV+YeYpTgYFYS4V1cmB8nxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnHcS69UYIYH0xJLU7NTUgtQimCwTB6dUA2OCC+fyxwe1NSe9XXnpg5Z+
        h3OxuLzI1XanbJ/fmW4zdr4s7BcPq23zUou48i4iPEwp1X+Dyrs+6cIZr7h+f1GVif3YJ2yR
        4nBv04ej784+7ZbcntK9UuT03K/6u1calL4zi9Pz/bz04LGT67e5/bD6u7C2JVNFpEqI/82P
        g+ezHmxkeXNh+xIlluKMREMt5qLiRAC2OfcvJQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSvG4hc1GcwYnpKhYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFq17j7Bb
        LN16k9GB1+NyXy+Tx6ZVnWwem5fUe7Sc3M/i8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CV0ftwP0vBFu2KyT9OszYwTlfqYuTkkBAwkZj84RITiC0ksJtR4tRaT4i4tMT1
        jRPYIWxhiZX/ngPZXEA1TUwSS579ZANJsAloS9ydvgWsWUQgSOLemrWsIEXMAquYJDp7zzKC
        JIQF0iQOfrnIDGKzCKhKLFh7gwXE5hWwkXj+8RIbxAZ5idUbDoDVcArYSvy928oIcZGNxLHJ
        v1gmMPItYGRYxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHM5amjsYLy+JP8QowMGo
        xMObsKkgTog1say4MvcQowQHs5II7+LC/Dgh3pTEyqrUovz4otKc1OJDjNIcLErivE/zjkUK
        CaQnlqRmp6YWpBbBZJk4OKUaGOeXdtzUNijfXVb5ZdO6I1fcVS43hdrI8a5KmL/Xk32XRWBB
        7e3FqluN/rzZ2rFCTO/Wt48tCbK9XyO5V69P1uKvfCCd6jXPabWxykfZ9Ap/x4UyN8WvKH1d
        uezPRpaMqMscJnvV1+6vP+kceG2zSmqVqcMnHtv/XJppqz+lKmqun+sZzSEXpsRSnJFoqMVc
        VJwIACwJcshjAgAA
X-CMS-MailID: 20200318111809epcas5p37b33e3038ede4797c83682314afc683b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200318111809epcas5p37b33e3038ede4797c83682314afc683b
References: <20200318111144.39525-1-alim.akhtar@samsung.com>
        <CGME20200318111809epcas5p37b33e3038ede4797c83682314afc683b@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds Exynos Universal Flash Storage (UFS) Host Controller DT bindings.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../devicetree/bindings/ufs/ufs-exynos.txt    | 104 ++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt

diff --git a/Documentation/devicetree/bindings/ufs/ufs-exynos.txt b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
new file mode 100644
index 000000000000..08e2d1497b1b
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
@@ -0,0 +1,104 @@
+* Exynos Universal Flash Storage (UFS) Host Controller
+
+UFSHC nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible        : compatible name, contains "samsung,exynos7-ufs"
+- interrupts        : <interrupt mapping for UFS host controller IRQ>
+- reg               : Should contain HCI, vendor specific, UNIPRO and
+		      UFS protector address space
+- reg-names	    : "hci", "vs_hci", "unipro", "ufsp";
+
+Optional properties:
+- vdd-hba-supply        : phandle to UFS host controller supply regulator node
+- vcc-supply            : phandle to VCC supply regulator node
+- vccq-supply           : phandle to VCCQ supply regulator node
+- vccq2-supply          : phandle to VCCQ2 supply regulator node
+- vcc-supply-1p8        : For embedded UFS devices, valid VCC range is 1.7-1.95V
+                          or 2.7-3.6V. This boolean property when set, specifies
+			  to use low voltage range of 1.7-1.95V. Note for external
+			  UFS cards this property is invalid and valid VCC range is
+			  always 2.7-3.6V.
+- vcc-max-microamp      : specifies max. load that can be drawn from vcc supply
+- vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
+- vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply
+- <name>-fixed-regulator : boolean property specifying that <name>-supply is a fixed regulator
+
+- clocks                : List of phandle and clock specifier pairs
+- clock-names           : List of clock input name strings sorted in the same
+                          order as the clocks property.
+			  "core", "sclk_unipro_main", "ref" and ref_parent
+
+- freq-table-hz		: Array of <min max> operating frequencies stored in the same
+			  order as the clocks property. If this property is not
+			  defined or a value in the array is "0" then it is assumed
+			  that the frequency is set by the parent clock or a
+			  fixed rate clock source.
+- pclk-freq-avail-range : specifies available frequency range(min/max) for APB clock
+- ufs,pwr-attr-mode : specifies mode value for power mode change, possible values are
+			"FAST", "SLOW", "FAST_auto" and "SLOW_auto"
+- ufs,pwr-attr-lane : specifies lane count value for power mode change
+		      allowed values are 1 or 2
+- ufs,pwr-attr-gear : specifies gear count value for power mode change
+		      allowed values are 1 or 2
+- ufs,pwr-attr-hs-series : specifies HS rate series for power mode change
+			   can be one of "HS_rate_b" or "HS_rate_a"
+- ufs,pwr-local-l2-timer : specifies array of local UNIPRO L2 timer values
+			   3 timers supported
+			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
+- ufs,pwr-remote-l2-timer : specifies array of remote UNIPRO L2 timer values
+			   3 timers supported
+			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
+- ufs-rx-adv-fine-gran-sup_en : specifies support of fine granularity of MPHY,
+			      this is a boolean property.
+- ufs-rx-adv-fine-gran-step : specifies granularity steps of MPHY,
+			      allowed step size is 0 to 3
+- ufs-rx-adv-min-activate-time-cap : specifies rx advanced minimum activate time of MPHY
+				     range is 1 to 9
+- ufs-pa-granularity : specifies Granularity for PA_TActivate and PA_Hibern8Time
+- ufs-pa-tacctivate : specifies time to wake-up remote M-RX
+- ufs-pa-hibern8time : specifies minimum time to wait in HIBERN8 state
+
+Note: If above properties are not defined it can be assumed that the supply
+regulators or clocks are always on.
+
+Example:
+	ufshc@0x15570000 {
+		compatible = "samsung,exynos7-ufs";
+		reg = <0x15570000 0x100>,
+		      <0x15570100 0x100>,
+		      <0x15571000 0x200>,
+		      <0x15572000 0x300>;
+		reg-names = "hci", "vs_hci", "unipro", "ufsp";
+		interrupts = <0 200 0>;
+
+		vdd-hba-supply = <&xxx_reg0>;
+		vdd-hba-fixed-regulator;
+		vcc-supply = <&xxx_reg1>;
+		vcc-supply-1p8;
+		vccq-supply = <&xxx_reg2>;
+		vccq2-supply = <&xxx_reg3>;
+		vcc-max-microamp = 500000;
+		vccq-max-microamp = 200000;
+		vccq2-max-microamp = 200000;
+
+		clocks = <&core 0>, <&ref 0>, <&iface 0>;
+		clock-names = "core", "sclk_unipro_main", "ref", "ref_parent";
+		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>, <0 0>;
+
+		pclk-freq-avail-range = <70000000 133000000>;
+
+		ufs,pwr-attr-mode = "FAST";
+		ufs,pwr-attr-lane = <2>;
+		ufs,pwr-attr-gear = <2>;
+		ufs,pwr-attr-hs-series = "HS_rate_b";
+		ufs,pwr-local-l2-timer = <8000 28000 20000>;
+		ufs,pwr-remote-l2-timer = <12000 32000 16000>;
+		ufs-rx-adv-fine-gran-sup_en = <1>;
+		ufs-rx-adv-fine-gran-step = <3>;
+		ufs-rx-adv-min-activate-time-cap = <9>;
+		ufs-pa-granularity = <6>;
+		ufs-pa-tacctivate = <6>;
+		ufs-pa-hibern8time = <20>;
+	};
-- 
2.17.1

