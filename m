Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFCB3770D
	for <linux-scsi@vger.kernel.org>; Fri,  9 Feb 2024 21:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707515443; cv=none; b=dzR1t8Jgwul1EcSX1i4VQJ1LwfONtytAXO02KTORlfBdLT0VBo1XwEU8W22OFqvvRX97X0SOaOujczkp8VOQ0IQfaNiOkuIgDDCHZaJMxTPO+qi+QgOemGIadmwKsqd4t+pc3TdkjtMz78ohmDaJEHGpZt5Ue0Yd4r2vN0RJhDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707515443; c=relaxed/simple;
	bh=bl2Y26bAQOrF7Fx/WmrM2EjdC+b87dw5MwVD4zAMJ9M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VFbpx5cIQEpHxa6u1bEzP4q3UYGBmugwApyV+6kmxI3LIDsKOFp9jXlo+FW0SKsaT3EsuB2LhvopgONBzu9Gkk5+/Jrd/Ifn8An0TW7mxfJ7NUCYtin+LBEJxJ9nyxte3G/3GgHeO+LDbezVCfdEAdY888k5ZQt6sNN7YLMJ+ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QhFSDrc+; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QhFSDrc+"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d0e5210151so1542921fa.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Feb 2024 13:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707515439; x=1708120239; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V26xckDyjwdJHuCgGskejffI1WpJJSP7w4OMDnjaGcI=;
        b=QhFSDrc+iRo2qz2whQSxkjalNmwlrejWirrUs61KULNL5L8gZdbX7aStBQqwr2d9Pc
         vMVLv44onta08fdV20yQ6APfP8VJFTke9eUmXNg+uuHpUqQhv3r99N1OCgEwvRTJi/fd
         K3qAj9ixxazkM7ldg5KR+HupDvQO67LGjkXbqVwDWJSQGadwHSFOclKISeFx5IwtyItr
         igif5GsZd0mnvHTZtRlUccfGElGSfcgoyoFPajltJbjtqKAYeXUUWFm4fjTRwLW/xt+0
         /b6hIUjB75Q0/N9mpSusa29i6+iKuQm9M4JQGn/8Ifj1v/dUqEvKJnbZ4bfs9ZkO0id/
         qNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707515439; x=1708120239;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V26xckDyjwdJHuCgGskejffI1WpJJSP7w4OMDnjaGcI=;
        b=hoJ/wsLnWvCYMApAmKFGyU39tEs1kWBAyMLPUa9Z8JbC93Zda6XBj8nPLbjsQaQFWT
         ogStYvGzmGmmwkCNjhKH0plxsT5wwZ8rmzrOYUp/kez+W+BD3mX1EGM/jer6Ux5EmwV+
         s/wJrTIG6Vnz8ko/XjHbPhrPEme7MwQuvL8+XaQpI3go7NOtVCcxpt+JomUxC9sKcjg6
         FhrALsn9vtubeY9EZpwGZr279oJ/gq7RPIcdVcAJ8SNHNucgPkClhuLUCjGiv0mlcl1l
         0KJ4JNZtyI3Wg5Mh6NW30Be98iZAkvRj2/Vg6ZysYpg/Xn1OdJ05H2/ubNsXqj74M/8D
         aj6A==
X-Gm-Message-State: AOJu0YzNZmHZIZqLAACr8SnTjM9Lcl6p53vGsNn2e9bGbvj2IElkJ9Fb
	/7lsbcSHrZoB19tM8nZp1xGW8kznm0NueyAjGnItTzJCX72SCu+jPcULviO9g9s=
X-Google-Smtp-Source: AGHT+IFgeZ41d3nK2nsuS4f6wEiNPwe0vgCRbvkM8yoctYC3SX5hFMUHhrMggVKWN0BYVSiC/o9CLQ==
X-Received: by 2002:a05:651c:2043:b0:2d0:d3ec:a545 with SMTP id t3-20020a05651c204300b002d0d3eca545mr154449ljo.50.1707515439680;
        Fri, 09 Feb 2024 13:50:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWs9KtyuyQVmnvoEwpuNw+wYNs5pq0wHd4rcW83LJaNGn/5pqAj09L8PNETBqKx9fspfk14+q4Wyun6mCv3315uMmv7lyMgvB3K3bR0VS8FqgBmZ1A6jQGQO4i51qhNgQav66lZKeleBi/jMyxx3CeO41f7C65bgdcMpiHMp0FdtOu1jzYj62njltrSZ3oN8EexjV1HS4pgBAGwWQsb7bts4xs2MSf+HAWbH2AFQ9uLa5qbE1MOde3+0phI/QEH4j+sTGWCtYsSFdN5rzyA4ciI0AmYmH6KdfAmEVYto3fnxGTssfHZpJJG+375bEg+6Q9YmJc7qGqjLK06LQpqNPN+trj2tVMAUoBpBKU5KrF5cTgAOasuIqobhYY20/dxXboX3MmqJqVJe/LhhwB3qEEBlf2qcjVJdLo+Dhgb0pgWom35PZLUmh5gy78egnTDDCKWKwcgViSs0f64EpEtA0PtYF3Tm2gTYteO5tHzXhnGD1p/xM56bgCI20tBJ+jIEbBHJ2K0skGgYh6mduBxkVRbU8hH3QRFXjpmf31BY7D9dRgIz0+aPF4+LXyi5atlr6zpApviqv85IH1vu1qFABFH+CTx5b6fjUU=
Received: from umbar.lan ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id t1-20020a2e2d01000000b002d0ac71862csm391162ljt.9.2024.02.09.13.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 13:50:39 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Fri, 09 Feb 2024 23:50:37 +0200
Subject: [PATCH 7/8] dt-bindings: ufs: qcom,ufs: drop source clock entries
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240209-msm8996-fix-ufs-v1-7-107b52e57420@linaro.org>
References: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
In-Reply-To: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Nitin Rawat <quic_nitirawa@quicinc.com>, Can Guo <quic_cang@quicinc.com>, 
 Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>, 
 Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, Andy Gross <andy.gross@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=1605;
 i=dmitry.baryshkov@linaro.org; h=from:subject:message-id;
 bh=bl2Y26bAQOrF7Fx/WmrM2EjdC+b87dw5MwVD4zAMJ9M=;
 b=owEBbQGS/pANAwAKAYs8ij4CKSjVAcsmYgBlxp4o6+ge7Ga9YGQOCLnWjLlEkJGho/D8fvUuQ
 Aqrb6MMCH+JATMEAAEKAB0WIQRMcISVXLJjVvC4lX+LPIo+Aiko1QUCZcaeKAAKCRCLPIo+Aiko
 1ZJLCACXqw6fod0tdRakwnJftPOdGZeXy681leZj+s6dUQsa169uzUXrRvEvFQloADwOQqIbXNk
 VUdBVkAb/XFahK6KcHkJkm/gbTgZc4eQ4+PPyI7bvq4iPG8SD8+DhwN2SVlFhQ+85/3t56b/ZuW
 Fpw5quFC1JgywN1NdxQgdmOi2679ROlQjarkbYCmS+ml5wWde61ACWpqLWYyKHBksOzCXMsPYnM
 DIzAlqdvEB9xR4jahxlZHcRzdFTvfksPFNtevMwdJLKfk4ljGg/b4Jlp9HbCKXyF2lRDpyHkdSp
 pOV/F292IMoZ62bT0+oqAS6d/IEpMpnHBrclgXSQHSe3JZul
X-Developer-Key: i=dmitry.baryshkov@linaro.org; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A

There is no need to mention and/or to touch in any way the intermediate
(source) clocks. Drop them from MSM8996 UFSHCD schema, making it follow
the example lead by all other platforms.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index f1de3244b473..e835f12c75ca 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -43,11 +43,11 @@ properties:
 
   clocks:
     minItems: 8
-    maxItems: 12
+    maxItems: 10
 
   clock-names:
     minItems: 8
-    maxItems: 12
+    maxItems: 10
 
   dma-coherent: true
 
@@ -188,16 +188,14 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 12
-          maxItems: 12
+          minItems: 10
+          maxItems: 10
         clock-names:
           items:
-            - const: core_clk_src
             - const: core_clk
             - const: bus_clk
             - const: bus_aggr_clk
             - const: iface_clk
-            - const: core_clk_unipro_src
             - const: core_clk_unipro
             - const: core_clk_ice
             - const: ref_clk
@@ -258,7 +256,7 @@ allOf:
           maxItems: 2
         clocks:
           minItems: 8
-          maxItems: 12
+          maxItems: 10
 
 unevaluatedProperties: false
 

-- 
2.39.2

