Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578212;
	b=ZY8Y24cyFnD79y4IdK2qkZCXTOCk3t1rv3xT+I1GYo/56RSYI7aqvQEAC2jC5gW/9Ac6
	 wHoRHU4c9vFfxGC9nUcGbITnkjJHDi6XqZAhErr96MCmC4G/kchpGEYVL7pK3rLQhaJ2p
	 C28dlHrUcYQvD3fkthfEKoPUIaSoS5gJGIfElb08N12nmc76GshY2oM4L6Pn/Mj9vWYJ+
	 tgrIwR0eM9UMiuuWg8XpCwVn+uMcjyN2qbylSTf5X/TfO62JdHqCLdfFMpYaNJNZpaJZQ
	 vgHkL56HudFmQy96E6yWXDnI5Wn4EjQ4FKSOYFPdKfaCNsBQcnTi/wvKW3pEGDEXFcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=r58Dxg2tgGyxD4PA+pT7yN68kQNPSN5LuMe4YebLPx4=;
	b=JMBgktKiE+7qmQBKOpBup9xjLT0cQ6jz9sGwCtaV/e14YLBWtkIL7tn6fKckI21VVUHs
	 HsIzTuuAqtKmtBfaFk+ubSk0+wb2N6l/1cAPZ0a9WrlaQdXJfOHAV8dyQA92+NhkA81h1
	 F/aeuiFctiJyiS32HPfp4L32rvUImUXoMN10sFGzvfFGR0wFpVBAjSa7ptrt8OweKyMZG
	 XGfLGDcZX6SUP0PT/Egm584f+QmQJ1tMdME/iUAQlti0G2unehsX6q6hOIeUBL2c164cL
	 TdDb7TPwbZ4dcR1eqWV8VyCgXf0Sq/6UmGyLTbpkTvBAOTSF10gmOhozQzNJS/GjkHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vtmuE2oV;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B6606A330
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:43:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E28B6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vtmuE2oV
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so41996065e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578210; x=1796183010; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=r58Dxg2tgGyxD4PA+pT7yN68kQNPSN5LuMe4YebLPx4=;
        b=vtmuE2oVGauIrw3nw//ZRqa1Bm3QZKItEoasIwcVX9zrlHG8SuDm1FNC6p/gUdoCEd
         yHcuQCJcOHFRBmJFJKXfAGas6SUgywo7/jrc2g6j8F9XTF2b/sxKqB0jEOEKU6hcamJD
         14q5wpHZOiOYBFQNK1KIDLyZtVxRvTUkoz5xbfEqORlxb8vKYDH1TeXKi/hjuairq+qA
         HTvMC4VMbQS+O6o/T+dsXXY4CLm+Y3int+QGFaVf07vXbbJ1XD+bkPcMviZ16o0nVfp6
         SJwxhNBkbj291YKuzpmUYMuCOa8IOYkLoIsbsJMwBcDS7LNdUGB5sWgmcof0KICa8jIT
         BQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578210; x=1796183010;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=r58Dxg2tgGyxD4PA+pT7yN68kQNPSN5LuMe4YebLPx4=;
        b=ZTr9XBo776GVfRAnTiterEtKalxLZDLFLsTkNidiRNsIjcKEzHvkDAvr0MXox4DAMe
         y2jYchg25lw3lsuFXB05a+9VnnMQeNTbdFNOmhgiBvpRq9zLhl64ORjxQftWdu1PopAW
         +DsodjPm6Xar361tKZQagTn1WCQ5yoSgm6O3FcXNHUZuJy83McORZ8kZ7Ce3k2U4GY0m
         xDZMMrxjkEloxj6ZqeSsxTM8jyWRsy0Zb5PgCaSCcmsZraZabW5z300dhOTLrW0JAFIc
         K1Srzcd7OpX7BG6O6RiDa+qisCEBzfOBMLEWTYz3hMmC2nvX7GGZl7LHw3q6dPALIRqU
         lI2Q==
X-Forwarded-Encrypted: i=1; AL+hErHvurpzy7Bf1sLsK9kKpOd+qtHUpVvtYsGZAC+vAfOiiOYL288uek44QQcO7feMF9V4OG3ZwKiJsT3Y@vger.kernel.org
X-Gm-Message-State: APuU4Z8SpNb66lg43OIpCtG1ouPlT386g2on6o7VkJY0LZkMI99PEB8V
	BrCCEdMIac2nT0Y/7w1i2b76m8xR07EJOvoHSqfxTc4ZoY9yxgJHwCgx
X-Gm-Gg: AZFdTZdnK7uTYBKeEevVE1WcxqJI2Mg3WTBkeFTtuL46LJ3aD1PlQnwbg+HwOSeABRS
	RjEEhb6D2JXti3FmpJuK+V7em7OKOF6uF8Zq3vJqc5NxYjIWVcgkMMKLLALtF5ueYR1zRkiUZG8
	T+slUb08yn+Hj1ahBT/9fpBF+GM2KCKjsoPBunlVp/lI3gqzVDpYvvfXVZnB72YeaxJWiWLjKoH
	ti1fFqI9VRYb7wt+QxNoDRRlbSih+U2/uiFdV3y4LCA43474QBbQMHH9O/6lSrOcomIPEqMl2BO
	xTSSCJh8wqFF38lUSZfkGPR3tVkjBUstqfMybgXK+garm8O0KWA+mFGVQCHOyYnQpNJCmS2+Ksb
	AVrKmfwfHts44Mu5LRAm1SajeUqWK5N37mUhU0lgNPHLMp3TYFu2ExzrDLFF/4Wp0eqqVtpUfhC
	zv6RLntd4n8lHs6Ccv2KGpDzwilWpR/v9ZVd5HgvBubkWDInV8XrjsdYU6xZAjuuSxE6wvTRbJQ
	p93tKywc6hun7nTh7ihxLvB1sVrN5dHKRz3oMX3vk0s96037EL9HsJ3Y6XQskDQcMhQGtcEAxC0
	5+IhNxnTTXk+v+GONnFLgDmaU50Xj+FMpJdOjA==
X-Received: by 2002:a05:600c:4f4b:b0:49f:fd2d:23c7 with SMTP id 5b1f17b1804b1-4bb888226c0mr405465545e9.27.1795578210149;
        Tue, 24 Nov 2026 19:43:30 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Subject: [PATCH v3 00/14] Add initial support for Qualcomm Halliday and
 Samsung Galaxy XR
Date: Wed, 25 Nov 2026 03:42:56 +0000
Message-Id: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEJZBmsC/4WR2W7DIBBFfyXiuUQwBgxWVeU/qj5gGBJaL41xr
 EZR/r3YsZRuUl+Qhplz7ywXknCImEi1uZABp5hi3+WgeNgQd7DdHmn0OSbAQHHOND3Yponenqk
 fE0WFvrBQS+cZycj7gCF+LHLPL7c4nepXdOOssVYMeDxln/FWdrepNr9NxqZtaQDJilLkDLJqE
 uRrb39BrnmjhQJuWBBBel9N8C8TnaNKWikE1KilWZkWU7Ir9HijoKBH17c09S52oc+pvApax87
 Hbp/oBJRRIZlw3KFWxu76lLbHk20y1G7z8zQL1zYhnX/iWG0wGIC6BG4lGlMIHRwPUjMePNYCS
 kQuEE0g804PMY39cF4uNvFlhes45vtxJp47AW04F7bW3JS7fWtjM7ewCOUJ7zBXP+B5DHAGRKG
 dckJ9ha/X6yeVRL2YOQIAAA==
X-Change-ID: 20261108-halliday-dts-e6ed3a2b5cd0
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=6234;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=azYIy7Z40yIDlSuh5Mz7oT8vPni9I9knitlR28s/doo=;
 b=c4hT+PD3H1S/NG0t/y9kGVB5kkO7YV/E1HObCKHUAhFxdB4WxSWz/1gZuM/CZn7D0I4dGm0NR
 6uXdXdBlMaYB5Q4KJ33WFtgDmbPylfAcJ2vCwPNZyO/Ahtphyi5BZfH
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

This series introduces initial Devicetree support for the Qualcomm Halliday
(SXR2250P / Snapdragon XR2+ Gen 2) and the Samsung Galaxy XR headset
(board compatible "samsung,xrvst2").

With this DT and the driver series, the headset boots to an initramfs
with a shell over USB NCM.

UFS, cpufreq and the thermal zones work too. PCIe with Wi-Fi and more
will follow.

Dependencies:
- The dts patches need v4 of the Halliday TLMM series and v2 of the
  clock series:
  https://lore.kernel.org/r/20261124-halliday-tlmm-v4-0-3e3a1d0fb4eb@gmail.com
  https://lore.kernel.org/r/20261116-halliday-clk-v2-0-28208928da36@gmail.com
- The dts patches also need the interconnect series, which is applied
  to the interconnect tree (branch icc-halliday).
- The SoC ID patch needs "soc: qcom: socinfo: Drop DT bindings with IDs":
  https://lore.kernel.org/r/20261123-qcom-socinfo-id-dt-bindings-v2-0-4504c1ce869a@oss.qualcomm.com
- The cpufreq series and the TCSR binding are applied to the cpufreq
  and MFD trees.

This work was made together with Claude, ChatGPT and Gemini.
Reviewed and tested on my Galaxy XR.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
Changes in v3:
- Drop the TCSR binding, it is applied (Lee)
- Replace the qcom,ids.h and socinfo patches with one that adds the ID
  to include/linux/soc/qcom/socinfo.h, on top of "soc: qcom: socinfo:
  Drop DT bindings with IDs" (Krzysztof). Remove Konrad's Reviewed-by,
  because it was for a different patch.
- Rebase onto qcom/for-next, where that series applies
- The cpufreq series is applied and is no longer listed as a prerequisite
- Add the Reviewed-by and Acked-by tags (Krzysztof)
- Link to v2: https://patch.msgid.link/20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com

Changes in v2:
- Order the patches by subsystem, with the SoC ones last (Krzysztof)
- Squash the "halliday" codename patch into the board binding
  (Krzysztof)
- Add the SoC ID patches, which were a separate series in v1
  (Krzysztof):
  https://patch.msgid.link/20261108-sxr2250p-socinfo-v1-0-06244862f5c6@gmail.com
- Move the OSM L3 binding to the interconnect series (Krzysztof) and
  the cpufreq-hw binding to the cpufreq series, so that each subsystem
  gets its patches in one series
- dtsi: Keep the Linaro copyright of sm8550.dtsi, which the layout
  comes from (Krzysztof)
- dtsi: Drop the empty chosen node (Krzysztof)
- dtsi: Sort the thermal trips by temperature (Krzysztof)
- dtsi: Put idle-states before domain-idle-states and
  arm,psci-suspend-param before the latencies, like glymur.dtsi
  (Konrad)
- dtsi: Use 0x0 for zeroes in reg, ranges, dma-ranges and
  redistributor-stride (Konrad)
- dtsi: Break the reg-names, interrupt-names, clocks and clock-names
  lists into one entry per line (Konrad)
- Cc Ulf Hansson for the rpmpd binding
- Link to v1: https://patch.msgid.link/20261109-halliday-dts-v1-0-289114ab8197@gmail.com

---
Stanislav Aleksandrov (14):
      dt-bindings: interrupt-controller: qcom,pdc: Document Halliday PDC
      dt-bindings: power: qcom,rpmpd: document the Halliday RPMh Power Domains
      dt-bindings: arm-smmu: Add Halliday SMMU
      dt-bindings: usb: qcom,snps-dwc3: Add Halliday
      dt-bindings: phy: qcom,usb-snps-femto-v2: Add Halliday HS PHY
      dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Halliday
      dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday UFS
      dt-bindings: crypto: qcom,inline-crypto-engine: Add Halliday
      dt-bindings: thermal: qcom-tsens: Document the Halliday Temperature Sensor
      dt-bindings: firmware: qcom,scm: Document Halliday SCM
      dt-bindings: arm: qcom: Add Samsung Galaxy XR
      soc: qcom: socinfo: Add SXR2250P SoC ID
      arm64: dts: qcom: Add initial Halliday dtsi
      arm64: dts: qcom: Add Samsung Galaxy XR

 .../devicetree/bindings/arm/qcom-soc.yaml          |    4 +-
 Documentation/devicetree/bindings/arm/qcom.yaml    |    5 +
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |    1 +
 .../devicetree/bindings/firmware/qcom,scm.yaml     |    2 +
 .../bindings/interrupt-controller/qcom,pdc.yaml    |    1 +
 .../devicetree/bindings/iommu/arm,smmu.yaml        |    2 +
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |    4 +
 .../bindings/phy/qcom,usb-snps-femto-v2.yaml       |    1 +
 .../devicetree/bindings/power/qcom,rpmpd.yaml      |    4 +
 .../devicetree/bindings/thermal/qcom-tsens.yaml    |    1 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |    2 +
 .../devicetree/bindings/usb/qcom,snps-dwc3.yaml    |    3 +
 arch/arm64/boot/dts/qcom/Makefile                  |    1 +
 .../boot/dts/qcom/halliday-samsung-xrvst2.dts      |  218 +++
 arch/arm64/boot/dts/qcom/halliday.dtsi             | 1871 ++++++++++++++++++++
 drivers/soc/qcom/socinfo.c                         |    1 +
 include/linux/soc/qcom/socinfo.h                   |    1 +
 17 files changed, 2120 insertions(+), 2 deletions(-)
---
base-commit: ef922b721a5e99348fc1f5801fdeb427ee14ee9f
change-id: 20261108-halliday-dts-e6ed3a2b5cd0
prerequisite-change-id: 20261108-halliday-tlmm-f250374110e0:v4
prerequisite-patch-id: 93f99b14fb93baf1aa68e010d29d463cfb616b9e
prerequisite-patch-id: f94f62e85a4afa1d5caf06ca16e2ea2abe1e99ed
prerequisite-change-id: 20261108-halliday-clk-362190f4f5dd:v2
prerequisite-patch-id: 765d40b7543dba6580852939a5c3d177f12d0a1e
prerequisite-patch-id: f12c958fceb125bcefd8dc9de139f30a371f85a4
prerequisite-patch-id: a6559b14fa1badec8e7752940362d68306523557
prerequisite-patch-id: ef47e531053032f65d3d600e2213c8a78e50f20b
prerequisite-patch-id: c4b2cbea76a00aeb699d706e09a899aa18e510d9
prerequisite-change-id: 20261108-halliday-icc-65a5442be859:v2
prerequisite-patch-id: 94cd5dee75e96876c6a42852cf6d1b52df1c7ace
prerequisite-patch-id: 9ad58176d603ffd84e7f1239c3b646cede4c8a3f
prerequisite-patch-id: a5df517be2541ab439d324dfe23ceb4c71a0e655
prerequisite-message-id: <20261123-qcom-socinfo-id-dt-bindings-v2-0-4504c1ce869a@oss.qualcomm.com>
prerequisite-patch-id: cba901b3668891005366e6c699866823187d2e6b
prerequisite-patch-id: 165b8370594197636821e98c434c0db01db0f953

Best regards,
--  
Stanislav Aleksandrov <lightofmysoul@gmail.com>

