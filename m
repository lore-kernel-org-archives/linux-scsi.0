Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578238;
	b=splVD4hQjQKrqTcSIJsm0Ojt5cKHHuH6hHPc+rXu3sb9WDtj7bgfgNI4pQUPZyZ5Teij
	 2PflwpmjXzdi/fSqLBt0nHjJ5Ijj5cFVaO/TSfHEOWfLH4mWWIEnVzBkn91DrWUhE6Ace
	 E1VE9HJHAlsoPg8NJ8AMBw/dDw+suuGqMpIO9YEsP0zXWwchzrYPx9CdFS/Uy+aw9lTwQ
	 1GK4W9CBtNQZiP6UlXe1XN7bln1T6BCbiDfU1WUDcctLKVIcxN63TO01bgNTRC/7OhiuQ
	 NqFrTtAnic34f74vjioAyXwaoeXt0a7y3+u8pfghpecJud30ThECtL8C5H9BEjwRFyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=oXtG7unj8KPVo5ZHcswWaKsEJQuS7Y5YiwYYtQMu/f4=;
	b=dTG6xgpoUye8x8JdCE5HP5EYvaPXcF4EbQtJVIjkQ5gAtKeCIVi8mEVh3HXny67TCnkm
	 FTGE+D3mv31r4rnwQzmmYXjUAndhRUSDev/0mY6KqW+ztSeRx8oNhdloBPDBi60nOzvPr
	 Rtb1GWyymkvOB1fAoqL+L+2AfdG3PHcXcG2wQSBf5sG1485UrLIYEJtJ/T0HQs1ZOme9W
	 vSL+oPFWk4iJOOBep4rv5XQ/mgo85bhD9wTx0AjIcqbk833asyzYk9cAY6oljhZY9U4ci
	 FlcCki2ajBFAzrJjWRjyhSr+Ju8eNdHv9gfTsEpNZJ3DmeCLMc4T8M33Z4mNLN+0jzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dEBczsA7;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CFE606A321
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9CFE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dEBczsA7
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bba60271d7so1445615e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578236; x=1796183036; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oXtG7unj8KPVo5ZHcswWaKsEJQuS7Y5YiwYYtQMu/f4=;
        b=dEBczsA7Csa4wYdE9zU2ZWCuv3c+lNyP1g6pcCOAtEbnMrJGhamzSdETIVfCY7ZagR
         kX09bl2bERUvo5yj+3/MV0BjBkSARjKlcB2IH+M8y1FiELtNsF7OrcBNCuj9GZ92sJUi
         Ool/Njo35MxX8MCXscU5+lEkX0wMN0iAE1HgqVRhGboodpHuVjgFtUR4qggu1dQycR3d
         L/JwWOYt+d4dZNxOcOHnHLEvjr49y4nklFPyI4Ia30AuczVcHnVqCD+J1JCrA6pb1nSw
         SknxbrCq9BsEdkeakbZLckjVjTdpyHmCg4R6qiYzmIYtSqlHBgi77W5p/Q+PWI0CCX4j
         TS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578236; x=1796183036;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXtG7unj8KPVo5ZHcswWaKsEJQuS7Y5YiwYYtQMu/f4=;
        b=YvWglix1YvMPSRH6klwRKzNOak3KqBX1B726xrhZ4tsErySE6gXulH4bknWYbcw8fu
         nMGxL4xqorJwaywWcRgTLcy3f8CtAUW2VQX7DIcRFVMQEEo9wUjhjJNsXvad4ttB+1I+
         UMKTiOGWPoSSuA/vgRi/WonHCjwb7XLw+wrsfABZoyZxNN1LsFTg3b3QHq0SRWYUvYT5
         CCx747B1BmMDjXSdhk0UA4HNW3/q2x7yiC4Dsm83+XVm4ea7x5vle3FvTKpM6TAuX+fh
         8TW3uBeuWhktxoiZ8gmS7Ds8o+31vWhL/2KsthpREHZwWvUtO3j0mU3pNQCIfyhLxV5M
         lEBw==
X-Forwarded-Encrypted: i=1; AL+hErHz+OjUsHqXvGUnlz8sAz8zcPIj89Cug6U5V7lxcZ5nPmcqOYyiMf+F7/xKOrMJJ4TvmgpOyDIgmC3V@vger.kernel.org
X-Gm-Message-State: APuU4Z8CqQedUI6T3wzeGbEmkSUh+H0K5Bv/IUKB3+/gjL73WmFxzDuC
	sSFUsSOPl6m5dhD+QT6QQkA5QFNzA8QVW4o93Rp9d8i5n78ep5Z/8GUf
X-Gm-Gg: AZFdTZeSEKhGVEPxke0iEqaJU2LTbXKpEmvh5gRIZkHfj/8MMKCNo3CIj28P9GiFDyV
	TdG3vuyTm9783VXS/xkA8zr/XpRiJ6f1+jWBrnM3yXRK+Yvkcvm+ByYJzckmL5WMJjWtdaCqaxg
	Yto02GT0KrJuADv92KoL81esCxaLWtag0MthcKhUsxxFlON0bwsK0IIbgNpKGY4G5JjtBBYEi3z
	SU+HfycH2l0EkhaWo3uZO6exJ4pr2WvFlRnPq83mtq2OKLYwNZOjCsnh6nUfR0m9PzIzpP/f3sL
	y2KX6yw6EG/LXZ32rM21VFtHQ+9UxdxJrvQKX4ix1DNqDartXpFMp9KTPepQmyFnXe+yXF4bxPW
	YZonvwjEEnzl+xki7VClFLORZQlWGwJiNu5Zut9TqWhWsIJouKN3xCe14hEylWAQDcdy9grUj6M
	1kWyVmtSm4hAq8++tdo7TwlOtJbHK7pqXokfZZg2ifxFYEDxoQG3g7P+hayq4J8exTW/n04ksjG
	wFE9mMs4RU3ib0neA6u3nk4lvq4sNISpG4cbAAlU3oJRI+cPruFghhM2VGiM2zAMamATLl0I/+q
	oJWl2n5zLNsJRcJCi2pEokZI76miJIoZ4BDBnA==
X-Received: by 2002:a05:600c:848d:b0:4bb:6687:5386 with SMTP id 5b1f17b1804b1-4bb8880c7f1mr352610575e9.19.1795578236299;
        Tue, 24 Nov 2026 19:43:56 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:55 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:01 +0000
Subject: [PATCH v3 05/14] dt-bindings: phy: qcom,usb-snps-femto-v2: Add
 Halliday HS PHY
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
Message-Id: <20261125-halliday-dts-v3-5-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=961;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=vc+yCVm63yJiTEyLJCU/ghFkRJa2TidHkMEEWzw/3Gc=;
 b=Yg/VSr0scUN51i9KpRAWHfU1hj3WxUg4RAt781FW4PuuF2y193VAPyf14yap65FpsWKVde5Xo
 6se4dVNbdKnCzQeUFO8eyXXWtGTKy5TyIr8La1GZjrp2oxL2C8sTpHU
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Synopsys femto USB high-speed PHY on the Qualcomm Halliday
SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
index 661759b25064..8ff1db4a1d79 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
@@ -22,6 +22,7 @@ properties:
           - const: qcom,usb-snps-hs-5nm-phy
       - items:
           - enum:
+              - qcom,halliday-usb-hs-phy
               - qcom,qcs8300-usb-hs-phy
               - qcom,qdu1000-usb-hs-phy
               - qcom,sc7280-usb-hs-phy

-- 
2.55.0

