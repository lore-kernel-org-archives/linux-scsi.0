Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF37C2D0F2
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E081C20838
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DyXo4t7S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgC0ROX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:14:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36665 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbgC0ROX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:14:23 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200327171419epoutp02165dbd482392ae55fd02f117636c7fa1~AOI-vBzGU0261402614epoutp02c
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2020 17:14:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200327171419epoutp02165dbd482392ae55fd02f117636c7fa1~AOI-vBzGU0261402614epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585329259;
        bh=0ogGbMGNWOHu+IsRUj8FqJ93r0JgndC1MhFG6E6RBAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyXo4t7S8Vsa1bFQWujjuF6nCQXpduASFTv/Dfn+2xv8zDxLFauCbykZ7R67XwfFM
         IDCWNuXFM1+wT7JI+TiKbje+DO6aBBirMDCF9UJJSx4Cq7R4XdQA1olWw2q98bJaEL
         naI8HM+mHn5LHwl9HQgmJ++mLAuvtyIx2WDUQ+ro=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200327171419epcas5p4556c8c663ee03f8891b0bb72040f70c9~AOI-Mk4pW2894828948epcas5p4d;
        Fri, 27 Mar 2020 17:14:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.4F.04778.A643E7E5; Sat, 28 Mar 2020 02:14:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200327171418epcas5p4b85bea273e17c05a7edca58f528c435a~AOI_v4oSU2894828948epcas5p4c;
        Fri, 27 Mar 2020 17:14:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200327171418epsmtrp2a732b41db40c7cb380b3a88fd0604d20~AOI_vHpCt2787527875epsmtrp2T;
        Fri, 27 Mar 2020 17:14:18 +0000 (GMT)
X-AuditID: b6c32a4a-33bff700000012aa-bd-5e7e346ac875
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.2C.04024.A643E7E5; Sat, 28 Mar 2020 02:14:18 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200327171416epsmtip1226681493d2d08f0fe317b8fe471f1bf~AOI81zBvF3081730817epsmtip1E;
        Fri, 27 Mar 2020 17:14:16 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v4 3/5] Documentation: devicetree: ufs: Add DT bindings for
 exynos UFS host controller
Date:   Fri, 27 Mar 2020 22:36:36 +0530
Message-Id: <20200327170638.17670-4-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327170638.17670-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSa0hTYRzGec/NM3FympJvWhYHBG9ppsL5oCUYcbpgfgqSsJYedOimbNOy
        vFXeN2VaaYrXUjNL1LnMFtO5aSLSBG1OAyFbg24oaqUiSM2j9O35/5/f87wvLy+JijS4NymR
        KTm5TJxOE67YoDnA/3haRH7iiXYl86l5kGC+bVkJZq23E2daxiw4Mz3d58Is6MYxRmufw5lZ
        fSPBPJ4eRhiVbYhgnk3sIEyxYcyF6Xi1AGKE7GxVJcJqu8sJdqC9gC2aHMHYVcdHjK3SdQN2
        XevLlhpVSDyZ4BqVzKVLsjl56KnrrqmVSyNYpi7o1oPNKbwQ1NEVQEBCKgLOaGrxCuBKiqi3
        ADbde4jwwxqAOtswwQ9/ANxqnQf7kb7q5y68YQDQaqrZo4oQ2DU6iTgpggqCi3W6Xe1JxcOZ
        ldFdCKWaEfjks3rX8KBS4eBA/z9NkhjlB9//uuFcC6koWGJYxPnTjsIXfUbUqQVUNJx/U4s6
        eyBlJ+BcUxvKQ2dgeXMDwWsP+H1C58Jrb7i+bCCc/ZBKg2p9OL/OhR3N7zBen4bGD42YE0Gp
        ANirD3WuUcodVm5/QfikEJaViHjaD95ftu4lfWC1SrV3SxaqLQ7AP4MGwNflLYgGHGn439oK
        QDc4xGUqpCmcIjLzpIy7GaIQSxVZspSQpAypFuz+k8DzQ6DTctEEKBLQbsIua16iCBdnK3Kk
        JgBJlPYUOq7kJoqEyeKc25w845o8K51TmIAPidFewhrcelVEpYiVXBrHZXLyfRchBd6FoKrA
        cQddGggbl8UGu/kp1cOp9tG8C/SBzbLwqbMHmpRIwUHb9OHIbVazM1O/XSyQm+sv2X9b4rye
        mksfXe75KelyZPSG+a8eU2dsRDf4tk3G9RsFcy+RcytG24+cuxsxsSN696/5of3BVf6bXm5E
        kl+I2SOKTuiKltBF2T2FNKZIFYcFonKF+C8BDo1jIwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnG6WSV2cwbQLchYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFq17j7Bb
        LN16k9GB1+NyXy+Tx6ZVnWwem5fUe7Sc3M/i8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CV0ftwP0vBFu2KyT9OszYwTlfqYuTkkBAwkdgwcSV7FyMXh5DAbkaJPz8esUAk
        pCWub5zADmELS6z89xzMFhJoYpLonRYMYrMJaEvcnb6FCcQWEQiSuLdmLSvIIGaBVUwSnb1n
        GUESwgJpEicf/AYq4uBgEVCVOPslCSTMK2Aj0bb3LivEfHmJ1RsOMIPYnAK2Ejd2TmOG2GUj
        8aHpAPMERr4FjAyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCg1lLcwfj5SXxhxgF
        OBiVeHhXXK2NE2JNLCuuzD3EKMHBrCTC+zSyJk6INyWxsiq1KD++qDQntfgQozQHi5I479O8
        Y5FCAumJJanZqakFqUUwWSYOTqkGxp6Dotu2v7vgIVzQ/EvXfM9J/XSbktvTdUOnFx1aL6+v
        5XCi2bizMuZnv7nPZumDH+1NqziiV3v0mPxQZwvZPXF1baTuuacTdBhbpC7uYe7bN7nioUwk
        85wg1i++557LB7dNuKnJ7a28Y7GExmLV/TxJLxmViwL6FtSfVJH6d3TL9aV80Z//KbEUZyQa
        ajEXFScCAI4wTuliAgAA
X-CMS-MailID: 20200327171418epcas5p4b85bea273e17c05a7edca58f528c435a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200327171418epcas5p4b85bea273e17c05a7edca58f528c435a
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
        <CGME20200327171418epcas5p4b85bea273e17c05a7edca58f528c435a@epcas5p4.samsung.com>
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

