Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7F8C10F25
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8F6520848
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 15:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qFmS+w6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgCFPK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:10:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29510 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgCFPK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2020 10:10:28 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200306151026epoutp046d29b858ccc1de2576037613bcb041bf~5v50_S5Me2389923899epoutp04a
        for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2020 15:10:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200306151026epoutp046d29b858ccc1de2576037613bcb041bf~5v50_S5Me2389923899epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1583507426;
        bh=0ogGbMGNWOHu+IsRUj8FqJ93r0JgndC1MhFG6E6RBAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFmS+w6Hkb4qQHLj9MshPwF7zHir2kvNgbPkfoMNvFAlpt7MG6z3ZZnZ+LCeGVbGD
         Ywmok/iNklWa8qS5Z9jg7m7tF4aF+GENJFft4wrUvf4gprPbqv8A2ImVwugVn4JPDK
         J3EqbJ3vGQ893vBDcgay53W3xzStX80oC6wwfCSw=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200306151025epcas5p32dc1ab8dffc322c12c9640a1bba20e3c~5v50P6e4G2035720357epcas5p3z;
        Fri,  6 Mar 2020 15:10:25 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.14.20197.1E7626E5; Sat,  7 Mar 2020 00:10:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200306151024epcas5p491fdbd529fee8ed788de9cd318a80def~5v5z6l3uQ0468404684epcas5p4f;
        Fri,  6 Mar 2020 15:10:24 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200306151024epsmtrp182a30e4addcb08620c2b6f1dafbfbc4d~5v5z535Yb0147001470epsmtrp1j;
        Fri,  6 Mar 2020 15:10:24 +0000 (GMT)
X-AuditID: b6c32a4a-769ff70000014ee5-05-5e6267e147ef
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.04.06569.0E7626E5; Sat,  7 Mar 2020 00:10:24 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200306151023epsmtip18a7c33bb365b8a2219f91a65de9de5e8~5v5yeB2_I0035300353epsmtip1c;
        Fri,  6 Mar 2020 15:10:23 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 3/5] Documentation: devicetree: ufs: Add DT bindings for
 exynos UFS host controller
Date:   Fri,  6 Mar 2020 20:35:27 +0530
Message-Id: <20200306150529.3370-4-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306150529.3370-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWy7bCmuu7D9KQ4g/+9vBYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWHRf38Fmsfz4PyaL1r1H2C2Wbr3J6MDlcbmvl8lj06pO
        No+Wk/tZPD4+vcXi0bdlFaPH501yHu0HupkC2KO4bFJSczLLUov07RK4Mnof7mcp2KJdMfnH
        adYGxulKXYycHBICJhLP5q9hA7GFBHYzSvQu0YKwPzFKfF3p0MXIBWR/Y5RY1DuXEaZhXuMa
        JojEXkaJ+Q1fGSGcFiaJtR23WEGq2AS0Je5O38IEYosIBEhcen+QDaSIWWAro0TrtSXsIAlh
        gVSJzkPfwRpYBFQl7j0+AtbAK2AtcXnbPWaIdfISqzccALM5BWwkfiy6xQwySELgCJvEx+X7
        mCCKXCTuP+9ig7CFJV4d38IOYUtJvOxvA7I5gOxsiZ5dxhDhGoml846xQNj2EgeuzGEBKWEW
        0JRYv0sfJMwswCfR+/sJE0Qnr0RHmxBEtapE87urUJ3SEhO7u1khbA+Jvq4NzJBw6GeU2LPj
        HNMERtlZCFMXMDKuYpRMLSjOTU8tNi0wykst1ytOzC0uzUvXS87P3cQIThRaXjsYl53zOcQo
        wMGoxMPrYJ0UJ8SaWFZcmXuIUYKDWUmEV9g0Pk6INyWxsiq1KD++qDQntfgQozQHi5I47yTW
        qzFCAumJJanZqakFqUUwWSYOTqkGxgXP0uZubW7g6ZjO7KAwUSfBXXb3JR62/hKGdYtqD8iL
        npr76MijJaa17qEuz/oe5fXVuNUlTM7kCjV+mjv7w38/YQG1eovco8EP7fexVF6yafh+d+HG
        kqkaBRzsz/Nuu795s//FqXo9tWeTPibMi58YlfNV/u7SA6eyo3Vec+/lXB/ZELrimRJLcUai
        oRZzUXEiAJChfBgQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSnO6D9KQ4g+ftphYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWHRf38Fmsfz4PyaL1r1H2C2Wbr3J6MDlcbmvl8lj06pO
        No+Wk/tZPD4+vcXi0bdlFaPH501yHu0HupkC2KO4bFJSczLLUov07RK4Mnof7mcp2KJdMfnH
        adYGxulKXYycHBICJhLzGtcwdTFycQgJ7GaUeHx8LztEQlri+sYJULawxMp/z9khipqYJBbf
        O8oCkmAT0Ja4O30LE4gtIhAkcW/NWlaQImaBvYwSm48eYwVJCAskSzy5sp8ZxGYRUJW49/gI
        WAOvgLXE5W33mCE2yEus3nAAzOYUsJH4segWmC0EVHN+1gb2CYx8CxgZVjFKphYU56bnFhsW
        GOWllusVJ+YWl+al6yXn525iBIeqltYOxhMn4g8xCnAwKvHwOlgnxQmxJpYVV+YeYpTgYFYS
        4RU2jY8T4k1JrKxKLcqPLyrNSS0+xCjNwaIkziuffyxSSCA9sSQ1OzW1ILUIJsvEwSnVwJg5
        e9rU55NfblmveeV61vsrDKuEpKM+uHFFlp3PWZ5fVpubJBwka7FTvnVdbG/3owKZwPOcu1/y
        Hr5gvmH97NatVhdjP6+Mu9N7aeV2we+OvpaHllvfqw21fP+YTWv2il5vFwX38HtSu6OZ1KtY
        5vz++uH05IZm95WfZs/XDMgSEpvx7Gj7gkYlluKMREMt5qLiRAB+AE/ZUQIAAA==
X-CMS-MailID: 20200306151024epcas5p491fdbd529fee8ed788de9cd318a80def
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151024epcas5p491fdbd529fee8ed788de9cd318a80def
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CGME20200306151024epcas5p491fdbd529fee8ed788de9cd318a80def@epcas5p4.samsung.com>
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

