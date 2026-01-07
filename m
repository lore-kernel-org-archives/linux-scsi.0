Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52A4285C91
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 08:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773185; cv=none; b=Rrr8bXoONDb6ML8zFWBjF2SKfQhH+OCJgmn+6C1mXg2Y1Xu24pobgtgwIOACAn2QEWnJZRpwPtAqdRwR4v4qaMEVyqmx6LT9y5ABGNdxI7S8XzpCe6nuoLZWp6ZjywrN0YAV1LWRQSPBsjNDrqApyb4BCCtoMitsYidA7M/2LUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773185; c=relaxed/simple;
	bh=L7zFGJrpp7R/1SPywgnVmhsEuokhe1Ahx7lfge1c7Lo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s6iFaHqtewBCw+Tt6kZip1qJoYp3D7y741isGEAGDGeebmwSOYSxUc5bdT+s0XYdebvUewPYewuxdARCpjsVvmJ05RvLVFIKFJVSR0P29nvBhL/MqeMGOxXU07dsZ7N1SIYO4SBN2T6l/kUyJqOtC9X2crnNIX5Kd8ehUlpmP3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=yOUquAeM; arc=none smtp.client-ip=209.85.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="yOUquAeM"
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-64ba9a00b5aso2490345a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 00:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1767773174; x=1768377974; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UL8Q3N/uuYGWCPQc/j4tS88zUzpRBU6RKL22PZGfA+c=;
        b=yOUquAeMLkJU6uZY0YiZ34jH0yuh/C6Zw6cOkDeHep9aB4S6ONvm3ntE4MsenvHf//
         eWAAipHCFEUecfM6GQ7KccmGJT/i+S3SZB2ORrr0MrzRLamvqRhCMOYfl5SC/spxYPIb
         bjuEAumSmu4PUBVtcblX+DB2+QQbbUDbbkkheXTOHS85B+Bum3MGSBdPV4rDEs4UNqL+
         Nyb3TaepcMTp0+XnM/2yL0EATTYa7spQCflMjfhLn9mp8XYceVqWNkGKBoto635yJqxf
         it3Yrd7wOz0W/+chFFPNVKEI+2Gd6suS9cVe0emF2I8YnnrJhLvQ5i50L4d5qCtfTHwH
         1Ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773174; x=1768377974;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UL8Q3N/uuYGWCPQc/j4tS88zUzpRBU6RKL22PZGfA+c=;
        b=kG4ln2Q1J+S+S9wRyq3wZGbp+MXyCkEh8vsbS/mn690kRIL6e88BismCXA66hJVH2P
         YmN1RNUIXsJXKO4W0pKHzVU7zTsk1EEbIWsqa2vq0bPuVer9ORqgIo9QX2AU7iX/ZAzY
         ySNbu2l+BlZ4TmStErFYH5BhsDFZBXUrEARwATaNgdmhwTcybewnokKxlolp03gHTSb5
         VZ8pfxyt/jPDSz8en8ushO0rOC9f6zDNYepXxYN3xmC/CjVIF5WtzjY1OA6cazTHQF0K
         G4Li2tYcZmTZSsrzRI51A0g2B23puGSGusDnx3Te2TktGwyKDd88pB3A+BQn2qjeOew+
         nNrA==
X-Forwarded-Encrypted: i=1; AJvYcCVpafy/0syXyCwSd3aUXD9I4fQRc9pWgj0YuSvqD6rT7j4LaEHzsgLdCZBd66p9jEucay8QKgj4cVd8@vger.kernel.org
X-Gm-Message-State: AOJu0YzeCChUteaLMood8dB072E/yo1FfJVqRDmXgNjPErrdMYhoMsB3
	hy0Xv3w0Yy1IODdDHN9t+zhSfTEvukXbMQW1l2c00PkN+eAB8ZyrdFV8XmUjl+0kYJE=
X-Gm-Gg: AY/fxX631c6Ft/KBkC2BBlzJIBOlU2E+sJEFIBjzB447lCEAC96GhHIGcp1BsDIQKSu
	5jxhmIv6gnIsH3kcJktlGCz+NfX+PB8L2s956dgv7TTYW2EizxceH/8ibGageZZ4I7VIugkOi8I
	DVux3nUtVkIT+sL0qsDdnXgAh7njWf3h3bNx0y/0xHVYft2eSkIqgXzMHSI6q1fM+1WYPyetu1P
	7k/TWthqRNNTE527i/zZLuTiPoK4mktWOLW42ezIoyAvubyLkTAr/gjU9eL7OEA5M9kKHwHZziY
	cM5i+kgPKAjiSClFFbvGnOKmhKz8wBmVxI/zzmtZmMVA9HvMiJe9SPv9jLuvcXvZm2KbgYcF94h
	KJ137cr5z71+vN9OEqVQHXOyPqL08joYTONyEOaEhO4hqKTxNvm52CVMRnIOceIEziuc8SDmLKd
	6gkur0RkQsW3hm5W9jI933eRWMwg==
X-Google-Smtp-Source: AGHT+IGoNwL2Ad4Wf5/kMZtYwloqDC2nclTMDNUXOI6+OkN3PNK9lgubRfkIS9pWfU3l7el4uXNpgA==
X-Received: by 2002:a05:6402:1461:b0:64b:63f3:d9ac with SMTP id 4fb4d7f45d1cf-65097e50cf1mr1240312a12.21.1767773173934;
        Wed, 07 Jan 2026 00:06:13 -0800 (PST)
Received: from [192.168.224.78] ([213.208.157.247])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5absm3941299a12.33.2026.01.07.00.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:06:13 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 07 Jan 2026 09:05:53 +0100
Subject: [PATCH 3/6] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: document
 the Milos QMP UFS PHY
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-milos-ufs-v1-3-6982ab20d0ac@fairphone.com>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
In-Reply-To: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
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
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767773155; l=1131;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=L7zFGJrpp7R/1SPywgnVmhsEuokhe1Ahx7lfge1c7Lo=;
 b=Fe5DRXgl1tVzMTAcH+EEUjx+bRFHCdB8IT+CJt8zvyJkZSSz/OKPkBx4UBM89cvHuO6GsOvMZ
 RcQEkaJMVezCF+L8auF0yI4aw/Rt9ht6yq2/Dx/32t723EUyu9KDJbr
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the QMP UFS PHY on the Milos SoC.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index fba7b2549dde..0b59b21b024c 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -29,6 +29,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
           - qcom,sa8775p-qmp-ufs-phy
@@ -98,6 +99,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy
               - qcom,sa8775p-qmp-ufs-phy
               - qcom,sc7180-qmp-ufs-phy

-- 
2.52.0

