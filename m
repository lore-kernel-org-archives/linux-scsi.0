Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C039283FE5
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 12:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753878957; cv=none; b=tCqaVGM6BEb1KwObEIcnNa1IUpbvREzX3Er4oijmfTihhUUDxL/ltyaSjSDSKDIvmVV9rXZQVCWe+xKLJUdh3T3vjLZ+XfwFVMGbf7iBTAWjICGZvFGc+GcbmgwhwZeSShJyftziv1Rt+nqeh0uAze363/CUt7DgNVGLJTT+ju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753878957; c=relaxed/simple;
	bh=TL1jslkYbGnwFQhxIVDseQLkHj1wo3EdT3LmGuFst8U=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VabRJn6Vaa5/5y+DLsNr2ThvB90eHtjGk8t0eTTvxOP4EGLXlMjW1oNqB1yos4qfWmk6SiW3Rt2OSfkRDnJFTU0hShvY8Lf//ll9Ly96dvQrIac9KI4zZRcdKygCP271Hj/2HZJ6JORTPIdBBFmFYZMWtiVqutlOrAR+0GDFOyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dK9Xc8b0; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dK9Xc8b0"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70742520205so7869846d6.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 05:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753878955; x=1754483755; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CjCcWWa4qk/EoiiwDodc2dHJ7c4wzCVNfTSg63QPfzs=;
        b=dK9Xc8b0CDWCFOc4cVm3iLvlrhsS5bi2v7X19qbRVe+Tu+Q0zNCigUeD8o5XG++JDy
         crL/1/zZxl17ICAz0v0y80So5kBTPkV6lPL9YjgOaERMKLe00s3EoJgoC6bhICPaIA70
         meLf8mfFpVA2Z5cR5hPxvqOMB7jRsfe926IRMxTJqtXGrTcnuB5YE7zTqXhUqbP5suuK
         cp5sbCjP6BrX8NfWpXVfW9oFE6UGwmLr3SJQ+PS41zm3m9+p7AcUFNqsus6dro5cSW5q
         IbgH+kTG3EMxqzUdriUOY/GyN0ZUlmedExgnFgWrjHBeBVjUcFj7D/Z56FQhRO/3viW5
         3Weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753878955; x=1754483755;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CjCcWWa4qk/EoiiwDodc2dHJ7c4wzCVNfTSg63QPfzs=;
        b=tT7pIh/QSSCclg9LQs9r4bDimJvhqhmFV+biJDo1X3tdmLQ1W11jYKO7D2bQ11jafW
         sKtiPOTUbcDXE0F5g/Rkj240YQ4PXGGl/lGwWUEYDHLtN54NaBBXMf4KPJd2o2qzpf2k
         GwcVPi/KLMmMiR6InHzTktmfjFvQWVCwO4qoA4mEIU30WvhLH15XFtiP7YS3lnMYHpyt
         vvMtNyfW1nNt8hQ4BbsSQL8KOUz88Moz+nRjZd3biDsA9q9OcdUWb1GbjlflU3XCBGno
         QOsehRC1PR1nKSGCu8fSLHo5FG+RaUffH2oUL+YhDRbPAcVI5RdfZpavL8wnn4N1cp6s
         TBsg==
X-Forwarded-Encrypted: i=1; AJvYcCX3Dyc06xizJQYYSioCwwtdsO3slbxqYcPacCoI9WDy6NgWBy91zi1dVLGzoX4/GqqImex5cJj1Z6Gr@vger.kernel.org
X-Gm-Message-State: AOJu0Yz95fBI0n5vlrGbC7K6pLlwoP9PWO6UCFJuQXf9lqVTVa2p2QnQ
	YpVbZ9TtL/SrXkmFzEnL6gvY7cvrPm39ka8QXneK0Dgnq6BjL09ox3U/hNc8KSpqXBD3eNahDWv
	OnEcY
X-Gm-Gg: ASbGncsLrYvWy2fFL90UrlB5RVVJ3P3iEmX7V4xLD3oNRw2XJhtr6vJdKlzCUv/bnhM
	dyMXGJ1v3ry8zRBnNnJkqCQZy0/QsWITyhN1YyCYx8BFR+4d23ivwstYeYcR8mLf1eXVN7c7dII
	oOGMPNJJy/Vce4dv3Gtz1+2Kd2h1J8cX6Gzt/dpEXOftQ//tvce4bEXbkDBxUu69O0AJy4hQpnB
	9ZAX4lxVjw67aGEOTGU5BBN3O4GJ/XBF1enGPewvL26XJxs9sBn+zgNaV9M4mxMyz42Zr7twbOO
	69kY0+GWZMjsZdLuVDjADGNX+IhQlbDmEoS9MnjJffL8IGN6+hOpOEBruYzfTUxJVWLJYSYd1/k
	WWBYQEiu6vmTS3dv40S321nC28rfKhHkob9+IZbc=
X-Google-Smtp-Source: AGHT+IGwmNhyLd0DJNnkCT8/jZWKIr1CBuLvQyt8ZpffWXjV7NHNiRP2B0ipuCo3xhp1GZHIOlRERQ==
X-Received: by 2002:a05:6214:cae:b0:707:4daf:62f with SMTP id 6a1803df08f44-70767230172mr19957096d6.7.1753878954791;
        Wed, 30 Jul 2025 05:35:54 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.218.223])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7076a647d47sm10105716d6.9.2025.07.30.05.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 05:35:54 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 0/2] dt-bindings: ufs: qcom: Split SC7280 and similar into
 separate file
Date: Wed, 30 Jul 2025 14:35:35 +0200
Message-Id: <20250730-dt-bindings-ufs-qcom-v1-0-4cec9ff202dc@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJcRimgC/x3MTQ5AMBBA4avIrE0yiPi5ili0OpiFooNIxN01l
 t/ivQeUg7BCmzwQ+BKV1UdkaQLDbPzEKC4acspLqgpCd6AV78RPiueouA/rgk1NVVOydWQMxHQ
 LPMr9b7v+fT+nToDBZgAAAA==
X-Change-ID: 20250730-dt-bindings-ufs-qcom-980795ebd0aa
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1146;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=TL1jslkYbGnwFQhxIVDseQLkHj1wo3EdT3LmGuFst8U=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBoihGhB/RGRzrg5Tdt3rmYaNBElttGKFnKKlPZR
 CgVwij/l3eJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaIoRoQAKCRDBN2bmhouD
 18OJD/4wpVCzAyd22DzRzFtEz75KU8fQ6hsp8mAxyM5GPjK00GuPcR+lthX4JfMXIiHGBd0n2Sb
 iHQ8uj9GGEOUlxYlNPI4BtyDqVu5K9yuF3PMjpYriQwuYacPVczW/zgEUpHg2oL8VJtTJF6kxch
 88h1ivpTvFLKdF8Q+CKKQbhbfTAy9Eixrsn9ZsZORDYbbb897TJ6a6uTqnEPXLb5octEOyihwgK
 B7EfkrHg6XhBoGh4F3ZNrPfg3moQDO23eNnSLwd0bW2VaXLPcSx0tEyU2Rjzu9y40xR/QTWtKJz
 g2QCZdj98DV3RcwW/Pc6YqoUZCN5m4bH+brGElQgCuWAM3T7hwuKvWrgshygIzXOfPFBSuwNUNr
 /ruUjfYMIJ8mT+Bw148mb8b2wg1o3ojuWvsgZ6JAPm5hv3rCOyD+Aer9FIKe6m7X3m8Dk7SLCMw
 w5X6ufiK5nz9svvavOhsEVa60kYvI6d1mXEMt5brtjONMZFG0hgCBAtUuYCV5hbrVbXYydr0qgO
 +4Fdgni0ISqZG9AlSMCcqX1UcMObmIrowhLW7qij33qA2mEHXb6fHBsupeX+ArcaSteQi4Jwkyk
 RTmE5ZX0XBpmUHWrcqVJGjfkNB1swDtzPF3Qx5mg4rQJMpPh1wbrm08M4u4xUHjC+1h9XeO5J1O
 jRaoPR+XZc8wLBQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

The binding for Qualcomm SoC UFS controllers grew and it will grow
further.  It already includes several conditionals, partially for
difference in handling encryption block (ICE, either as phandle or as IO
address space) but it will further grow for MCQ.

See also: lore.kernel.org/r/20250730082229.23475-1-quic_rdwivedi@quicinc.com

The question is whether SM8650 and SM8750 should have their own schemas,
but based on bindings above I think all devices here have MCQ?

Best regards,
Krzysztof

---
Krzysztof Kozlowski (2):
      dt-bindings: ufs: qcom: Split common part to qcom,ufs-common.yaml
      dt-bindings: ufs: qcom: Split SC7280 and similar

 .../devicetree/bindings/ufs/qcom,sc7280-ufshc.yaml | 149 +++++++++++++++++++
 .../devicetree/bindings/ufs/qcom,ufs-common.yaml   |  67 +++++++++
 .../devicetree/bindings/ufs/qcom,ufs.yaml          | 160 +++++----------------
 3 files changed, 251 insertions(+), 125 deletions(-)
---
base-commit: d7af19298454ed155f5cf67201a70f5cf836c842
change-id: 20250730-dt-bindings-ufs-qcom-980795ebd0aa

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

