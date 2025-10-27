Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6686B2FA0CC
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 11:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761564692; cv=none; b=hMFmbt5DzFXUKIr89D9eBWn/AFS1QkxMkJ0l4IeXy/2gst1dCP4cAmzbCB1RJ6nn8ksDmPu6xQLx1WDetxY5vX04eUk85EfEbZBNe2SDToZZRCjNbzMQkpJYboJyivuzewyQbz7csUyp/Im18LeBl8G0yN3bkGeb5UaooC3XjRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761564692; c=relaxed/simple;
	bh=LHPhOV0gpy6e0X3PqYPMlaEtQLXlGi+UHQ9Bc94bXXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JvENRX3Oc8ZABM3JSh0NCxVytfNrG7oP9qzLEI3RuuaZKsRzkGvBJiXgH038yila8rVtTUbx6QMgWoeq1f5LgdR91IyIF/9M6kfSwVp6ahHUXYIQDXlD4qY5MTjoX8Tno8x9F3/vX2m7bs6sDWJ0+Q9UM0S68qa1msKvYGnUJB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aSg3R5sA; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aSg3R5sA"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-427087ee59cso668884f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 04:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761564689; x=1762169489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gkdBVE0BY9SVhHYsmymJ7t9CcB8wdxkdpKo/Zx6qBfk=;
        b=aSg3R5sAo6Gr7VQQbGOTTJz6FAZIhiQ9prZGGoeuV9ELd4fuJqDKSzuH3Mq741Ta53
         1N/L74M+W2UGdZiTyt7DQv4pf80BeVWnKNZGnIVxRzkykpIFamY4ntE/8usF5OP9+zit
         zTPndRNME7lhUYkbZ5e8c+WCnVJB4AAAaFXu2GdeqZCztn6wlf+I7pectQ8/rmL1y3W/
         8NxdEoRBYirL0/Su5MwX5hhHqK8QcFRrrQGupK2vYfaMLab+Fn9R30Q8layQrXL31mZ8
         AxP95kZ0xDraV4AjITG8Z9mul57OwtiBKIqS7gKpknF8FIKxlucYFVcGYf/vRScjPGlP
         zDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761564689; x=1762169489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gkdBVE0BY9SVhHYsmymJ7t9CcB8wdxkdpKo/Zx6qBfk=;
        b=YHvd8651IaRpVub24runw+8ZpX13wiE3BqNNS9n5QuX3MCA8DC2RpO1YIql6aJVgEr
         F6h6A1EFEzmIPm5+DBKadSbG2nR3a3fKdkA/01AdFEWagOW2GYp0uLlPtmfmoGp0OVVq
         3cH4ksKXHz6k1G15xAS9oYdwecgTj3IlM1o0+uJpZr5EofFRF2Vh0sN3nHlHxm07fLsL
         3gwOiPAe1Kc1cAZP8qxnihfnZlbqnW4uN0kXxIPICGp8IPVEGxYLw+WZxt/7JbJxJNys
         uxdZ2XtojNpJGbrgKCiuHcYJ9g6IR5EEg4KVhqRfmu/19H8k1z3imTXGXBq5TDFm5Iiz
         x18Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgd058O5VgHhs1ZQjJY/a7HvWsaPdLHat70CqJROKyE0Uo8ZGmHm5J5fvX6VLNZGQjT1QbZGusHGSh@vger.kernel.org
X-Gm-Message-State: AOJu0YwYPHAutz35NifrBTCF1vuqZF0O470l5zeMK9H2k/w3VrW0a9T3
	SNLIy1MKQyNn2Byok3MjjexDhxIBfNef+gW2sRlSepNbagEdygrP6aPzDIp+zIIjj30=
X-Gm-Gg: ASbGncvKeWlTQIOy+5Hdr0pd1NbNy681ewRBT8fSC5orbmKwt1gJK5tr7Tq8CwupiNW
	hKeNPMSyhyZuaCJ5TWR9iXAj+eWry1t+DiiKKxEvUFCUk64L0AzevuWFRbjo4TwWOyCYQb3ZFlM
	G2L/HMYTedp1oTgcMxGaUqJd+IIK6dcPdw1eO7d6NoMHmzLUjBQ4i/17SougYMa52YavgLys2rJ
	Is53Flod+yxiHr2YIk6ziT+Bl6nvRFdEHhzN4puS++PzFVUZkBZDgeh2t5h03kmNV4KrBW3ZcTt
	5xzVdGUQLIOqi8PZdc1IOEFNC4slwyUoXzOGVxkm+g6ijXWaq1U+RyhZJXOMTaLknp2HiH1i48E
	rr6yiRR0xE0D35p9RIur61Ob2kNa56qvMvGKdS2SJ/dSpM4r0KRnj6wrpbqBwfviRBkkPnANaQJ
	PUBcKNplkhB5iwuVKdWPrJOg==
X-Google-Smtp-Source: AGHT+IGz6GD3y6+cDG8Os4GrrgdKI9eH0xfE/xqR67GYStPwZccvbqYVtGigldNSOQfDk9DvMczWPg==
X-Received: by 2002:a5d:55d1:0:b0:426:fff3:5d0c with SMTP id ffacd0b85a97d-4284e531afamr8104494f8f.1.1761564688605;
        Mon, 27 Oct 2025 04:31:28 -0700 (PDT)
Received: from kuoka.. ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952e3201sm13885403f8f.47.2025.10.27.04.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 04:31:28 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Andy Gross <agross@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] dt-bindings: ufs: qcom: Drop redundant "reg" constraints
Date: Mon, 27 Oct 2025 12:31:08 +0100
Message-ID: <20251027113107.75835-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "reg" in top-level has maxItems:2, thus repeating this in "if:then:"
blocks is redundant.  Similarly number of items cannot be less than 1.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 1dd41f6d5258..516bb61a4624 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -88,7 +88,6 @@ allOf:
             - const: ice_core_clk
         reg:
           minItems: 2
-          maxItems: 2
         reg-names:
           minItems: 2
       required:
@@ -117,7 +116,6 @@ allOf:
             - const: tx_lane0_sync_clk
             - const: rx_lane0_sync_clk
         reg:
-          minItems: 1
           maxItems: 1
         reg-names:
           maxItems: 1
@@ -147,7 +145,6 @@ allOf:
             - const: ice_core_clk
         reg:
           minItems: 2
-          maxItems: 2
         reg-names:
           minItems: 2
       required:
-- 
2.48.1

