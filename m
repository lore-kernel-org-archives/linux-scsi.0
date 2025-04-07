Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A14021D3D9
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2025 10:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021030; cv=none; b=qx7gqvN9b36w5qgAwX27rxM96ydeuJj98FOxOUe+rRcCvjJTlNYeyl594KkPD7tADCDJLTrANRlBIP+nmyTkFyyfMSX25siKCmNlYgh/9yk2NWPZxb+rxe/0FDLzhQtOa9YQPbz7gMQVXESll+wXeUNqIOQ6tUF0dkb1MpQMjbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021030; c=relaxed/simple;
	bh=7LcrE9PwjMxM+D3p0ZWZWb1pO8745bswAP5vgVdnDak=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=onIjYOenSAx82DeacjaGiHIXT1A9vv5YnaYp01TEzuwswdJdQQXv6Y5OGoliOD9u/v7I2TEomRU/sizvp5tqwwe4ePqS0MBZP8WWa+/WfsFjYKrTeL4vLKeg4kmdb//jyNk33ZNA8Z97S/3nhEZT9OB9JpTaueoI3VtVhTOCMGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TLzVVEaJ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TLzVVEaJ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3913b539aabso2358376f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2025 03:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744021026; x=1744625826; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jOALBW8cVNbdK6yJWB3znuwD8zL8Vv3OQVACGyCjItQ=;
        b=TLzVVEaJ9dx5xyfEreiAUyEfli4lzO8J5ljn+/mLEhJu6JMMO6IZ2biqKgnx6B6cf/
         FLnMRH7rPuSORg0RroX4tOhDInf4xXRhbFp+ON5NDYZwEgjAg3zttXPpDydlPBscAmDr
         ybKSg0igoXR5e3zyLDc7NLAMEYJKh+EKqkG5Gp/P51tHYaiQ3L/luuv6AIsLmw39As1y
         Fazy3gdzbIK4UdKUf8jsOA1t+2WkVd1tWcV/mQoRx1hvsWKapDabXUrvGoWmPLXGOHHy
         DlfnHnOMLrXm9DdTp7IOg1x5hy8fOtD1r3vctonyDW3m0wkMgTD8FTCnLvR5f/v16dak
         Itxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744021026; x=1744625826;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jOALBW8cVNbdK6yJWB3znuwD8zL8Vv3OQVACGyCjItQ=;
        b=hCuNCDfDSqKS5IV91cQiaT/LQBaKVqJNUSXEekG+pVVdqkFQUnttuFiUJp1QLkUKXc
         6R1neiYAPiTJDoksvxO5Lf3Q+YSuokAAcqTge7XzXH7EgGOFystcNtee1XHG9oYwmpsi
         MG6STHcoEql/DwBMIgEyEOIdadqHRWQFBkzKqgvBbSWTQPB0dV8QSnYQXuNqstHdj5Ok
         0v6Uv7fNNbW0pZWPdxyJ2r2wx0vR9R6/CQ3rZT9+QE4s16TGNbteJxjsmiLmXU+ANLKk
         6LwzpSzrbLUhbMhtJY7X0GLaof/wMXVilK0R66I0jf/VMjVmN2Jr3ZoTZA+ncXVbll13
         uTCA==
X-Forwarded-Encrypted: i=1; AJvYcCVChtIAZ8YfpO0ktY6wE/HMms7AYkVzp3ZYtXDKjT1zKnC4mQol39VFcPJYXzVZOQR+WhIOuDcAhLlk@vger.kernel.org
X-Gm-Message-State: AOJu0Yyki9Yme+4rFhN0Lpq2ImXJXzKuCNDvxHFKSjeWAHSZ5PAvJF1g
	1J4BvX2IkJtsM/x9cTQqplP6kEIsoJPQRuKvtjXqdBSwgrmMoeidGjEwV/ht3ns=
X-Gm-Gg: ASbGncuC3J1VUjOG6tAOUcrOE8ZjSRg/ATLbHJ8WspJzfmKv2pt/JUooeFewXXqOnaB
	S7QyfZrQnV4KrZixqVyrf4w22XU3eh3nsMXyfUWQCMzCjKd8VA28tHeqbbIMpDp/8WYwRHeBrp8
	6UGXsw3+R3IFyTdiC3iWbCashjf8AwN9vGWO27Ty3FRm1sFTaH5pHYWctPetYX1uabEke+GqSxM
	/vxkkJda3nd1uNsVnGTyVlAGYdZShLKS9zNbbdqCXZHWGwKPD8iISd7WNUmdos7Yd6uRRJWNRYo
	mAcBhK/jOkgJ5j/fAMQD+toZSMk7u7AGPJIyRiBxw6sDI7uhraCDJyOML+hZBYUWsA==
X-Google-Smtp-Source: AGHT+IEOTdDrswC+bFQxvJR3r92l4tdMlGA69d9j7tDpjaVWhpTf9J82Z0r72AKsbAAQfXkVTzAl0w==
X-Received: by 2002:a5d:64ce:0:b0:39c:1257:c7a2 with SMTP id ffacd0b85a97d-39cba93d0aemr9456431f8f.58.1744021026472;
        Mon, 07 Apr 2025 03:17:06 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:3d9:2080:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a67a1sm11476831f8f.24.2025.04.07.03.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 03:17:06 -0700 (PDT)
From: Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH RFT v3 0/3] ufs: core: cleanup and threaded irq handler
Date: Mon, 07 Apr 2025 12:17:02 +0200
Message-Id: <20250407-topic-ufs-use-threaded-irq-v3-0-08bee980f71e@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB6m82cC/43NTQ6CMBAF4KuQrh3THwvoypUHMO6MiwJTmMRQb
 KHREO5uw0o3xuWbN/nezAJ6wsAO2cw8Rgrk+hTUJmN1Z/oWgZqUmeRScyUFjG6gGiYbYAoIY+f
 RNNgA+QdoZaziVmq5tywBg0dLzxW/svPpwm7p2FEYnX+tg1Gs1T92FCCgMFqXIje7SjTHO/XGu
 63z7epG+WnlPy0JHIpKYWnSb4H5l7Usyxtkx+U1FgEAAA==
X-Change-ID: 20250321-topic-ufs-use-threaded-irq-53af30f2529f
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2023;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=7LcrE9PwjMxM+D3p0ZWZWb1pO8745bswAP5vgVdnDak=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBn86YgoDLSti2lmmUtACENDXd6NyTizG7mG9a0B2Mf
 Z74YodqJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZ/OmIAAKCRB33NvayMhJ0YGnEA
 CrNUiuXHhHUDtvqQlIMfsIZiHsCjOIeQh9iv43GFFtv0aHYfAVEIn91buuRhQDPdg1MegIa/SI74wg
 4SfNcenuMRFex8vt6T8qRqdis8WgwJkTCcm8Gb8/txeec7uTe53lMx7+yQn5BbuOfthDX9pMUeF4go
 M11QCtlXflTSO7EtdCGU8fzcdMtuyl7aev5MhnZNlk3YxujS4FA8V3JnqQn2IshdsX4HY1gfXzbJGA
 YBUsGvWBaEc7c+40FUAcdq5IcbB6i6GyAQnFTjTlhAjWm3PSJyIh91wh8xWa4FXgW1qLJkOsdNGdL3
 H42SzVlVocCg94nQHklY3iOgRtNAO9kCrB3aBzfRSBoeieNXAdF048+tPstIM8vROF1aax3zNLfR6Y
 hRzRWMYr9ICmdFUHRXOfUyo5O0JV2T+qa83ZTfSvDFPt0PfptUYdE9FNxnH3MxrZARve01HJcwGQk9
 XcIroSnKLtYLXeI//x3rYbW1XfuwbMMSLfoy/FjvBU30gqGBC6cvvzeu/6b7Skw/3DCoQNp0+qYEKw
 qV8RyK3+DvUQReM4JOFHhz7hJN1LDOehPFbVkOzNuF7gGh1yKlYbhUbLmKirEa57/RSV6H1dYJUN3o
 jgppfYpkgiLQVEdg26OeHjeOgxXhlOqIMgksVaXXrBbrMhouNTIQESPsRs1Q==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE

On systems with a large number request slots and unavailable MCQ,
the current design of the interrupt handler can delay handling of
other subsystems interrupts causing display artifacts, GPU stalls
or system firmware requests timeouts.

Example of errors reported on a loaded system:
 [drm:dpu_encoder_frame_done_timeout:2706] [dpu error]enc32 frame done timeout
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1: hangcheck detected gpu lockup rb 2!
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1:     completed fence: 74285
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1:     submitted fence: 74286
 Error sending AMC RPMH requests (-110)

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
Changes in v3:
- reword patch 1 commit message, add review tag
- add intermediate patch to track the ESI state
- use the ESI state instead of ufshcd_is_intr_aggr_allowed()
- reword commit message to explain why in mcq + esi mode we bypass threaded irq
- Link to v2: https://lore.kernel.org/r/20250326-topic-ufs-use-threaded-irq-v2-0-7b3e8a5037e6@linaro.org

Changes in v2:
- Removed last_intr_status/last_intr_ts stats
- Handle irq in prinmary handler for MCQ case
- Stop touching REG_INTERRUPT_ENABLE register
- Link to v1: https://lore.kernel.org/r/20250321-topic-ufs-use-threaded-irq-v1-1-7a55816a4b1d@linaro.org

---
Neil Armstrong (3):
      ufs: core: drop last_intr_status/ts stats
      ufs: core: track when MCQ ESI is enabled
      ufs: core: delegate the interrupt service routine to a threaded irq handler

 drivers/ufs/core/ufshcd.c | 42 +++++++++++++++++++++++++++++++-----------
 include/ufs/ufshcd.h      |  7 ++-----
 2 files changed, 33 insertions(+), 16 deletions(-)
---
base-commit: ff7f9b199e3f4cc7d61df5a9a26a7cbb5c1492e6
change-id: 20250321-topic-ufs-use-threaded-irq-53af30f2529f

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>

