Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578248;
	b=bF3+pwTsE0enGG+BQhs3BoltoqUF0x3oQtvGAGSdofHO+Upy2doOdHYj0RURBLS7LopC
	 6Pzx0ym881SoovXgArPTkf7+g0pWw1l1CO0UvKgrxJTa6fPcfamHd4bQ72FIYL8Ycd1rq
	 IQWT1NxUTRN/gcPkSRyNWIDpzFsryFtz2SuIJm0K3tpQPDjzwG+VmV1UugAO7T6eikznC
	 Z9ZHvqd9zvGPoddY8wo7JqdBnSM9W8mAuq1TV9Aet5pe9ws0XLomvzWU3fdO878h7RhYn
	 tY6LgZJKy5gMWjVYRIzikPyzlpU9PR7o0BV0Pulk6tpjoTgl97/NjuttFqAGjUbXQLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578248;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=4KIqWeS+3qt6MqJuGRe1uG41SLx0XRfx3eXbs/xUTl8=;
	b=SbKxjmktvDuhB7vIRIf1rQNxLpl3TYXHMvbf9Tk978quUrlCQ91U+QNpD8dn/gHgo9tU
	 bYUMxZouQb3mRyFy3tkUqdPdTFA9Ohg3XVA86Fjh6GBI++O74zZSAKsSontpyOqdhcMqk
	 DlsW+45t/FLvuFAIE92+sDnxDr+b9OPDaVuUY0geB5HRTRlcc826/lRTTRPqjJszJn8iE
	 U5gGT3+GLSyQ4EjqN03Uj4Qckd+bQv03iopCtZ4LDbZON2t6KuDGqogwyt2RMXA+3pZ9M
	 rboVANd8YB3BO4TxLo3BoMHD+30wsBUMXNKg5epVkh9zrXv/F3hKREVuf19x2iuHQtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yYJnCPDC;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB464606A32C
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB464606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yYJnCPDC
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bba60271d7so1446765e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578246; x=1796183046; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4KIqWeS+3qt6MqJuGRe1uG41SLx0XRfx3eXbs/xUTl8=;
        b=yYJnCPDCwX2z7GW0KEzZrs4pq2lhpcKSCvfZ7Jxb5FFkSXbRD/DKL3imKFKjuozlx0
         PjoGDpUiZBJMXXrwVVv65xOZtRHEQr7Mp03mrKt/vzdLw8MJ+WFu49aJ+T/d37cNt9+0
         iyyRKW9IcXrsAWM7+n7HO24S6uBagb+7QbJE1odzSFgeGL6gzPo32tZiTXSkOPZdF8SQ
         lZXlXY9dCMKGWuXQqoNmMXGhc5CIK0sJZ4AfyM/TJgjzKVwfBbHcTRqrhathFIflxn4I
         m8Ek+pAdgoCuX2AZC4asCQrNaa4et/XMHCzHRzgNV/fFDwwF//9V/YDf75TCkIiiiCiD
         PQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578246; x=1796183046;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4KIqWeS+3qt6MqJuGRe1uG41SLx0XRfx3eXbs/xUTl8=;
        b=JgTCUJb/gTjHYYZvBOnhDsdGATtuepS6r8Hl3MrzDlCwlcoyfn8IVoITU1BzGu7wdi
         4B5UD/goNm4KH/VNod9AvluL68O9S11V/lY8L2dHPCxQ4DMc4n3cx9wnoD3RaerYGG7r
         +aHjcB+tg1EpA3A0/XsWP59mjJPmJqfzMUa+txZGgYs8qM5UDwstSprmhT0G+jhYea9p
         5PsU+Ps0pHCdAauVgvMuPFSshD/EycA21dR3EbJfEjw4fwgQ/QgIx4VVvmfDprroqCVs
         BM5lLsI+QIGTm5wawBfG2MUQsYUmLxErf02ANbetRwnmSAd8kByzRlsEccVMaAUC/xn9
         dF+Q==
X-Forwarded-Encrypted: i=1; AL+hErGjt+ZLaS6CedY0jPe4yQ66ovXVTh5u6F9Lqg5SNoAQ/wrOKBUrmaMN2wC1xK5nQpVxwljmgMqvIQIN@vger.kernel.org
X-Gm-Message-State: APuU4Z93GwKth63oZpvYrZzqC1JbgXOeWlwjjzjQQPVd6dlXFb7awJ+2
	cVjlnYu+vLKK24APp/ZmGqWelpjAzR+aEvcs8AoK3E8M1lp0sKm83VUL
X-Gm-Gg: AZFdTZdmHlWTOVhNzcMRlVN3gHYaqearxNSODZZ36kfL+qSPzh1u4tloyCP/3icCled
	85AE2qhEotFSqIpyYhzILXTDEGAlI8HQYbOO71HvrK8QIlh4eHsGkW5V7lstiSGhR8d7s+wjSgx
	myfGQNEB/tx3hneHOF8RJ/5BoM3egoBwsg4Jc+mfXgydGVboVQkoNYCHYbI4LAAr1H9wBE3x/1H
	bZxx6wY54YmgkO62rniAjv3SKe3OXrewyga0AzgyyT4BfoMCYssKWA0Ag/Yx7DZcDZa6GXd2oAb
	0L2KBLcP2lvoZ31f8kD1RlpLBeyTDAmK3DAadtjPN8bGeu53doHMtHKW8EH1yp7eKxfxsxe8iTE
	cspKD5wnfr4C4RxkI9Lb1GGb+wothGLXAD29ecUqiwpCi+Nu4PpF9FLc3SSIWm0HD1XLkr2tlva
	27KjAxvWQBkLdxjUfWLh7TYoZ0SNNinPHN6OlaWZpk7nl+4Bo7foaJbjsP0Ew7h6l6o30Hms0c0
	JIZIPPo+UKU7HaLPnzb9M85jsK/JlyjaATvrLDc/R+c/qhN/B4Llmk/lJBOH2vxUTJRI1N9GmMC
	Q+XpSa/Se1OoC4JIjUNgsTzLVjUWcbDsdwvJ6A==
X-Received: by 2002:a05:600c:4e0b:b0:49f:e772:6ddf with SMTP id 5b1f17b1804b1-4bb8881ae90mr345180345e9.32.1795578246276;
        Tue, 24 Nov 2026 19:44:06 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:05 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:03 +0000
Subject: [PATCH v3 07/14] dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday
 UFS
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
Message-Id: <20261125-halliday-dts-v3-7-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1101;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=QhWGZ2nDLik/AVSmlPnUVJyIcZFTcrhPWPSMCAukIeM=;
 b=6AJhs5Z6f/n9pNkfdd62Z4MaOrVcciMknCqzjBkVEi354abH/HUGDZk9PowwAyDuxfg/8VsUi
 qlXYQzCUXxLD5rZQ1VTRb8Bh7LUtJE1bI5xcjBVOagvzX82tdchlf+N
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the UFS host controller on the Qualcomm Halliday SoC.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index 3c407426d697..5d1784baddd7 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -15,6 +15,7 @@ select:
     compatible:
       contains:
         enum:
+          - qcom,halliday-ufshc
           - qcom,milos-ufshc
           - qcom,msm8998-ufshc
           - qcom,qcs8300-ufshc
@@ -40,6 +41,7 @@ properties:
           - const: qcom,ufshc
       - items:
           - enum:
+              - qcom,halliday-ufshc
               - qcom,milos-ufshc
               - qcom,msm8998-ufshc
               - qcom,qcs8300-ufshc

-- 
2.55.0

