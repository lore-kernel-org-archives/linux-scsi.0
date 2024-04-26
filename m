Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36376145B0B
	for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2024 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714134012; cv=none; b=fsE29msA71TAOSXRGW1Sv8FQFmjCzz/cJi+GZhby34stU1wGDM4X4tehjMqkSK87ssJBQabULxQmfg0aujUlqVOjjc3tDwXOIWPRvf8qyxUuH4cJEvmJpUKT1lPJ35bBWbqmjgc3fhNZJxVd6moA82b6FH+92wzCrigVfZUVMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714134012; c=relaxed/simple;
	bh=14dadIAc5wD2QzNM/ZQDEQHha++iZmfZkrofpl6mL9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mm0oYPPxoO0JFuSRTpdBwn8RL5ePKgSZxxqAMemVqx7inJTNSDAtza7xOFJkqYEP5a2cILZNHZOJ8RoQ4KMIPukbCA0WOnZaxIT4U2cOtqkQvGjM778+TLW17BHUsOEOB3UPtcqnp/MVOi+FY4b79KWf1XAFi7ozR+9s0c2koT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D0llLIsH; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D0llLIsH"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-34b66f0500aso1496923f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2024 05:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714134009; x=1714738809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PRNqalgzRJP0wdqPI5aKVM4n2lOoPrcnW5MLhVms28=;
        b=D0llLIsHgZPOuwkpyCsMPY7InPU6PT1i305B+AeDSmnHYwqiRy5bUf0sL8yUTobxuM
         zrvuJnKBZquXzXQaFr9v66lHKRDxQBCEFRzP9hK0CofY4eU5HZWqLp78A+cAefvrUou6
         Nx4t+SUfqHfP31ToMAD5lwfDZ6V03IIUJN3KWzFkJVZahQSABhF4PD7BKx0sdjAg4M/N
         BUFe9J4tH8ZuFHv48wKl5GSj7+4y3tNvD/13eoIMTJawGNyU9IastZchNlPd7rjzKlFt
         oWleOnrMY3/mu/Zu+P80LrL+MswB7sVuxxXmpFfshCIPcYmzTXFCRYyr6qU6M4m3Sc38
         4O7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714134009; x=1714738809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0PRNqalgzRJP0wdqPI5aKVM4n2lOoPrcnW5MLhVms28=;
        b=RJkgo+lA8wwkKf+fOWDPajCPnu17GPqtrbRs8lM8htcclW7v3vR89BgqbEY2OEUaZu
         eFiLzwS+W2XSfNSyeRmW+7IiEzfg5TFxVbKP29kQ3FCCxU8Wt/ysEPrw4VmJPdDXqlBZ
         UyWv71ZKkttVq3k4oGv5GrW87Elw3+fYiubwVs+62DQ6t1GvRtV5aJ5pbyLfGJDzUG5M
         RBH3cHYBqvsXRjh21hT03GrYzyzAs65wem8B2v08GrjfA/wpj8NKVOQZRZagkjEpFTAy
         GmsvViTv5E33HAFHfXo6GlTYiPFMSPlYfDbtqqsaPQZrh5+Vq0oWQDTVnNjjCfV4+CNj
         Pa+g==
X-Gm-Message-State: AOJu0YykDv7yZ1V1Pbcl7imTaWNAsWOmL/DSPh+eS9uUIeA8giYybRJD
	t8PGFUcBMMSkTCyqXr0sUumbfL6048fess+n7+vNCnNm8lA4K8Qf5lpL5Tq9Ccc=
X-Google-Smtp-Source: AGHT+IFPRQzrJNRe0ZHJxJr9q7e3kdzOr5FITfDYCVcG12MFC0Y3BF+U9bOg8Rq12hVlpBymtvyZFw==
X-Received: by 2002:adf:ed84:0:b0:34a:a836:b940 with SMTP id c4-20020adfed84000000b0034aa836b940mr1795068wro.18.1714134009627;
        Fri, 26 Apr 2024 05:20:09 -0700 (PDT)
Received: from gpeter-l.lan ([2a0d:3344:2e8:8510:63cc:9bae:f542:50e4])
        by smtp.gmail.com with ESMTPSA id q2-20020adff942000000b00346bda84bf9sm22478146wrr.78.2024.04.26.05.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 05:20:09 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tudor.ambarus@linaro.org,
	andre.draszik@linaro.org,
	saravanak@google.com,
	willmcvicker@google.com,
	kernel-team@android.com,
	Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH v3 1/6] dt-bindings: ufs: exynos-ufs: Add gs101 compatible
Date: Fri, 26 Apr 2024 13:19:59 +0100
Message-ID: <20240426122004.2249178-2-peter.griffin@linaro.org>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426122004.2249178-1-peter.griffin@linaro.org>
References: <20240426122004.2249178-1-peter.griffin@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add dedicated google,gs101-ufs compatible for Google Tensor gs101
SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../bindings/ufs/samsung,exynos-ufs.yaml      | 38 +++++++++++++++++--
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index b2b509b3944d..720879820f66 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -12,12 +12,10 @@ maintainers:
 description: |
   Each Samsung UFS host controller instance should have its own node.
 
-allOf:
-  - $ref: ufs-common.yaml
-
 properties:
   compatible:
     enum:
+      - google,gs101-ufs
       - samsung,exynos7-ufs
       - samsung,exynosautov9-ufs
       - samsung,exynosautov9-ufs-vh
@@ -38,14 +36,24 @@ properties:
       - const: ufsp
 
   clocks:
+    minItems: 2
     items:
       - description: ufs link core clock
       - description: unipro main clock
+      - description: fmp clock
+      - description: ufs aclk clock
+      - description: ufs pclk clock
+      - description: sysreg clock
 
   clock-names:
+    minItems: 2
     items:
       - const: core_clk
       - const: sclk_unipro_main
+      - const: fmp
+      - const: aclk
+      - const: pclk
+      - const: sysreg
 
   phys:
     maxItems: 1
@@ -72,6 +80,30 @@ required:
   - clocks
   - clock-names
 
+allOf:
+  - $ref: ufs-common.yaml
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: google,gs101-ufs
+
+    then:
+      properties:
+        clocks:
+          minItems: 6
+
+        clock-names:
+          minItems: 6
+
+    else:
+      properties:
+        clocks:
+          maxItems: 2
+
+        clock-names:
+          maxItems: 2
+
 unevaluatedProperties: false
 
 examples:
-- 
2.44.0.769.g3c40516874-goog

