Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D1135B14C
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226001; cv=none; b=hcpOC50vLffS3HJgkEs6mvCbL2BUQDIR5eThihGIRBRg8mLakLeyy5ZL8k98YTcTZdtWibLR7a2rVCMNFWg1I0njCqPtjDJ0TbTat2AZcMWr8RliMM9o96N1FzZ9rqxoeKHxYp7F2EHm9A8Z1m8AWh0L8mET/JjgvK7/AYSPIgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226001; c=relaxed/simple;
	bh=qxN/7SFXQgGYehqBL9aUXI1J2mEyleNlSfDJOc+cUfo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hbilkZSrTAreU6MwaUWJzMhvD+/PWyuPldk+S/Cxl+sY9RKAcpwOGaSr1UUQqH8k9+/d9nEubCi+Z0HBPvhHEe0d0In7/6GFCnb6F8hl1422iKRjq/l0SrDI0mD1WfXwb6LeXa6MP0P2jE439Xf/6XyB+gZ6zkadTeUPkf+zCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Ci5jx4i4; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Ci5jx4i4"
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso13391567a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 05:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768225997; x=1768830797; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p6GBn7KiZoLHRbB+eXZ1LBCN30jAII3dIqXdIjZE+DM=;
        b=Ci5jx4i4kBvNw4Um7TQF5M4EvSRjawQQMfERBEl/Hozpiw2R51VjDR68WDTw6MKTYh
         wf35WKtTih69BRNEOJXrGdpO8NLdOgsWQSeW0hDs2GENoeJnhjRVczN+fGyJ9XiejK0x
         XrWMaWQV/wuNX1lKPgT2fBGbZJSqAF+e4YTdGpCOTdp/gzoqTkQYhbwTOtHTK45t7GCM
         PMEpzwWZ4i/7xo+AlxNd6BzV9HoEJAJjP2eubryW9H8H7sRVfVNl6DIG+UVjY1/+c1OJ
         okZfo5ftkT5sPmH7r3knud0XWnYp9qkCEkg8rrW2iGRTWij/EC59VVn9BNaUgjKY9cy6
         sEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225997; x=1768830797;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p6GBn7KiZoLHRbB+eXZ1LBCN30jAII3dIqXdIjZE+DM=;
        b=f4nZLq1BizXbXVeX4LvRKWziRohVHWweCWzZKJb1YGgCN8K66ap/4b8+qAh274xLNf
         O1Av4J8tpwqvByBSG8xL3OjG1XHfIlh/eiggKEX7ZCKd4CfXaoQ4RHW0DEj+l1kox+hI
         W04n5xBgZzkTjnaQBo04ZFPZorREXQJHRTaTuaxtaXNbxlS+M2ehRMPdhBiVB6BZWl+8
         UbTlL7PckQWIPNP/A7RZNFnhee+w1ZE6NsXOYwTwy8CynYJm0jsmWQyrJ5jhZ6+FcHsg
         sX9a5cNx1JY5besyZXIV8upSRenxTOFhLRG9E+s82Agyhq6PIz8HOHOJv8HOkjV87I34
         NlZg==
X-Forwarded-Encrypted: i=1; AJvYcCX8J0akO61xakVYqgYkk2Kp9k1mzPNKvoE01wuvmZBsaJsKeJdie6TsQn3wIyGHMZ3TuAvv0oOVSNAU@vger.kernel.org
X-Gm-Message-State: AOJu0YxK2f/W7IDo0qZc567xiqA3XHDetn3JU/gIFe1J8arQYn275Q1U
	pGjErGdZj9pBZbdhHqPxha4nEcn0fKFG7er5bWm0QM17hmtS2n/cJQKDNNqJztMV6aU=
X-Gm-Gg: AY/fxX5But5wxPyqKll5OsWRIQ/RGbzAqwO0Tk5dKD9K3xOi/L/UO2vm6+/WNjvXEFF
	UzkBAt60smzdM2pe3cgOdwIo6mw7iivv4EXfTaNNwnlDMh1OzV79RmjWznz+kqB8X7mHnEGWTpP
	HJGukMG5lu9iMhkW87c81mC+ymXIN6R4e/RyMHdUOvsS+KL5MV70e2pvHsVA7hALSX9aLw7DTHk
	e5ogn/q19fHfX8yHGdsZfQ7k4KDh7YoM+i7Mh+6p/E9EwR1Vz+yybuae9zXfsS5utKUCzwVb0mj
	ot1Hwsxj2W3kIEhYNUbANc9kTMaTdvJBEYLHgbM9mvxuMvUiK7M/8zLU/CANbNt5l4BxgXveHCF
	0joNg4KMS8eEiRTXUbiZsJcnv9cIGYQdn5nXAuYW9dmequ7dAnfkZvkNzHoftSOyK1RvZ3t0XOG
	gQtIo9apzqRogiAlLLAgFb9s2icl3RiddTPjYUnJBfUvv6XjICExO9db5S1/S3J0ne
X-Google-Smtp-Source: AGHT+IEd+nXuoyJH7y+5irMovJmQYLD5UodxDOlxMBwAbUiTSj+cIGE3y+/oEJNpNUV3FWxwU1bJFA==
X-Received: by 2002:a17:907:3e83:b0:b7a:32:3d60 with SMTP id a640c23a62f3a-b844518a88dmr1900919266b.11.1768225997580;
        Mon, 12 Jan 2026 05:53:17 -0800 (PST)
Received: from [172.16.240.99] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8731f071e4sm25700466b.66.2026.01.12.05.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:53:17 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Mon, 12 Jan 2026 14:53:14 +0100
Subject: [PATCH v2 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 document the Milos ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-milos-ufs-v2-1-d3ce4f61f030@fairphone.com>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
In-Reply-To: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
 Luca Weiss <luca.weiss@fairphone.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768225995; l=978;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=qxN/7SFXQgGYehqBL9aUXI1J2mEyleNlSfDJOc+cUfo=;
 b=+6y4wusQhtRueAHKb3ZVs4ptUD/5lU0HvbI8iylXgKJDlb89tUPOMEzoqIO5WEYaPfvbSmSYp
 Pq9sp8tM9qrDpSD5sTGW1dElYTST04D3dJj3ez+bzIGdUXXzHTuaQbM
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Inline Crypto Engine (ICE) on the Milos SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d20..061ff718b23d 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,kaanapali-inline-crypto-engine
+          - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine

-- 
2.52.0

