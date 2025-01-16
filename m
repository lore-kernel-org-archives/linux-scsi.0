Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53D722B8BD
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737038971; cv=none; b=Shs5KR/TgY9f3Rm43dcqP8dm0CoTvb3HnUwi2hlLb4ITgZh4cfb0BuTMM08aIqCk0hTFjWUPM18d5fOFXtJxBdQvNbzxDNYx4PU0IO5qJ4xFjU+koCcyuzDjBRxHe29YQdaEMwKevnvjRLEbZr11xe/nq0N/Yd1yXGuQ3tqSFMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737038971; c=relaxed/simple;
	bh=Wje1BciONDqQrKQyhp/R22j+9s7pjT1C1mQYS4XxTmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HUY3O79xLCnFVqxGJrK7+di2kRNhLFPXg+s2GD0pjrJ6w2rAwBtzBLYpb/vgT92uQTRW9G9r8Euin5Hp2VZsfFkI9k9Xh9UVmshnv3Xom3lTrWmJVwFMH7QF2+t+/ylwpWjticMAdBcqj28FGJAsb6Ran9wouCzeD9VwD5xPcJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cj4BxhIO; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cj4BxhIO"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-38a8b17d7a7so550188f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 06:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737038968; x=1737643768; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rbb6Ezfzp9O8O/V6bl6D5LDxeK+r+UlRD6ckNgY/1gU=;
        b=cj4BxhIOazRcHCNPKjsyeoxRxz3FuQ4Ok7sBqmWmD1tVSWnG27HKkfrR/NoN8ftx2I
         VEsUNWMd6b8voWUmiayk67a6BwE6ZAuE7BLfM+cLRX5WUTiB2o5I6CKQIv1MhopaLRoC
         MbFd3V/x5dGnX6EqIcbFKwDV9pKahE+HZAyFHgsWmGDJO/esypA1uxFBJcqvJyKK0fyS
         o510CMK33n9WCSv6mOZBx7P5/vALGzjjUF1l1nHVARra/93O7A3uAQYoUxDNpiHmI+jP
         y4uE6Jb54xEwxChGoUvFhn4IbFLt1eWx5J5my2duEQmmgdzOuX6I1nV9VjwtwTeLFoOQ
         2p/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737038968; x=1737643768;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbb6Ezfzp9O8O/V6bl6D5LDxeK+r+UlRD6ckNgY/1gU=;
        b=vKGny3aY+NJY91VkLMg+T8HyHe3zpQftClhkV+PSIdpzrb+HivJoQ7O4L0UpJboXfz
         UnLtKijUz/y12RDTFfkEB//TOdDYhl2AGPG/FxbSZHPWaR+NWdEiWid1fzTRedIiP6ZO
         mLujChkVpC23jKq4J/nhiHwZdJRlujmqP1WeN1qPnisVeMuYLg1pPVewcHBp0R3VpdTA
         pzg3s5e24Iy4wHeF5IHhDTqxvP1s2HJuKRCyM6EACOaVFWuOgSVnxMZQFXGfFlZXijsc
         tyqKIVUIgJUoWV+ZaybkHRbJCJP4P5dF6aS1EUXWjRgyosLD2EMQ8lDU4Dpq9CVXOchD
         FFrw==
X-Forwarded-Encrypted: i=1; AJvYcCXZMxYvBEN7YDEfclRADs57lGO0eDwQFU5JSCVDYt8BKwOV06Dk/3o9q7oGJ5nRH1LXcy/P98jA1J4i@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm7KVJY8EK1WEdzPsDa/KHyAHecNDkW1JiWhuns3h2kc/MHoZ2
	1/+HukTe9dH+3D8t2tWcHBebIkknbjyKKe7TW+5ACzzvHUH/FohAU5t03wa2Vmg=
X-Gm-Gg: ASbGnctgDnt2bU/78qTKmnZMPz0q8Lb41v0i9ZBRFMp8+Vl0kknAI5oDOUys6CVi/yn
	jC+ZVDkkk0V/1THGL5An7wNbRmx+zV7svvyEZb62iWkU/+SsiTzguaJRltwUGzoO039HgUd+0s/
	gjFNrmrzS9gyjfYAxvA2PxuPp58Z2WKMvmYBfki4OryaRODOvRdizZn6oNSJH4bs0/lJ8JUr3Tc
	O30KjhWA0s3oU9z3bDiToSnF3OxOQR7afeAx6scmU1OkQDebc6ZfyTV5fW1jLrwm1iRNrWqRc0S
	UCeqhAXEZKHbDYX7FnNVsENJdo6EfKaz7+Rc
X-Google-Smtp-Source: AGHT+IH9TQuJ8S6VwCv/DsUwUueSrMwmdIaON0G+tCnVqhp1ubDleE7CO0HW5JVWQ93mm1BDZ5rH1g==
X-Received: by 2002:a05:6000:18a4:b0:38a:a043:eacc with SMTP id ffacd0b85a97d-38aa043ee63mr16034591f8f.1.1737038967915;
        Thu, 16 Jan 2025 06:49:27 -0800 (PST)
Received: from ta2.c.googlers.com (169.178.77.34.bc.googleusercontent.com. [34.77.178.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf321508esm70310f8f.10.2025.01.16.06.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:49:27 -0800 (PST)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Thu, 16 Jan 2025 14:49:06 +0000
Subject: [PATCH 2/4] mmc: sdhci-msm: fix dev reference leaked through
 of_qcom_ice_get
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250116-qcom-ice-fix-dev-leak-v1-2-84d937683790@linaro.org>
References: <20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org>
In-Reply-To: <20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org>
To: Krzysztof Kozlowski <krzk@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Abel Vesa <abel.vesa@linaro.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@google.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 andre.draszik@linaro.org, peter.griffin@linaro.org, willmcvicker@google.com, 
 kernel-team@android.com, Tudor Ambarus <tudor.ambarus@linaro.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737038965; l=939;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=Wje1BciONDqQrKQyhp/R22j+9s7pjT1C1mQYS4XxTmo=;
 b=aMMD3l+fSYmaasELHSb630GvEIX81VeJMVo3eY8nHViIArWh5G7STBR9Qc3WZpAaFDvitRjk8
 m9LNmbtOIdmDxHTkSnPmHvYOH/JFRZpvuMIE8UrP0vRAQpXFltqIOPi
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

The driver leaks the device reference taken with
of_find_device_by_node(). Fix the leak by using devm_of_qcom_ice_get().

Fixes: c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 drivers/mmc/host/sdhci-msm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 4610f067faca..559ea5af27f2 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1824,7 +1824,7 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	if (!(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
 		return 0;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;

-- 
2.48.0.rc2.279.g1de40edade-goog

