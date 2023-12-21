Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8F078E8C
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 19:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iv0nbZfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703185885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4cSBdvbxI8LSVPr25rTyKCoUJu91IkN+EuBnNL3WBh0=;
	b=iv0nbZfy0ZEieAaEjrSPFPvS69EvGrq62HUFasTVSSAxIMie6FzowdeouvcalG3gfdUJ4k
	XTaDb7hyoKnbidxHy458qMr88OtQSPapdjyRkepDpM4srcqD+BvKMplOEb+S7XnwvQs1P5
	QdDoxbi3o+rzqZEr1JEDhsp2fvI748o=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-IMeaVg03Pgm3eeJINcjklg-1; Thu, 21 Dec 2023 14:11:23 -0500
X-MC-Unique: IMeaVg03Pgm3eeJINcjklg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-67f6f90587aso15247396d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:11:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703185881; x=1703790681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4cSBdvbxI8LSVPr25rTyKCoUJu91IkN+EuBnNL3WBh0=;
        b=Y1Fg9bK4rydmQTFGMeh/bb4/MgvTygVlRR3wEuGStkdufxtLaWAH3Qwydk4wsvjEIA
         KdkyjFN6UotcZExZGVRH+M8/vr+KXfJdMM/gBYLvSsbbqE4pAoUY7CO7ps6dXu8fvA6f
         gViGyoiN04GBIU2ppKQ1Qk30YyLsm0diN2YaqEtW0Cp9eH3HcSorSmEE7SqIYb1p/Coz
         kxNYr70Aif0G2g084xw3BPfQgekhDtNaloplLCynQfcxwBEu6MX/fwwvKBMvKDKzhOdd
         7qJEYl2RQjTmXtLLoJtIUpsJa0QEWIrqbjw0PdOxSjKBLypZxIiJCLg7UtWmyCMNOuUg
         YMNA==
X-Gm-Message-State: AOJu0YyrgaQyGLPH/bsm6jqnkuoBfedo0frTaW1lm+e86TdnvHFFZKYE
	fgIuyFUGYJiXM01ohD+DesYMbbyfMfRhw2n4ClygewofRhtyyeNN+4c0AMptNSKTG5Ax07IqcSl
	gqQfN0BDbiy/MTtrE1M74N0pxeANcpjMc2qJKhQ==
X-Received: by 2002:ad4:5e8c:0:b0:67f:2201:81e1 with SMTP id jl12-20020ad45e8c000000b0067f220181e1mr222526qvb.13.1703185881311;
        Thu, 21 Dec 2023 11:11:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGf7+G9N49GFMXR/htbqQ1Lb5/TJZIyMXTWcnIiiUlAQ5o6qGsg7peSQ1lv4VxWTuFlkzHUAg==
X-Received: by 2002:ad4:5e8c:0:b0:67f:2201:81e1 with SMTP id jl12-20020ad45e8c000000b0067f220181e1mr222500qvb.13.1703185881066;
        Thu, 21 Dec 2023 11:11:21 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id 25-20020a05620a04d900b0077f0a4bd3c6sm846370qks.77.2023.12.21.11.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 11:11:19 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Janek Kotas <jank@cadence.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>
Cc: Andrew Halaney <ahalaney@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC v3 11/11] scsi: ufs: core: Perform read back before writing run/stop regs
Date: Thu, 21 Dec 2023 13:09:57 -0600
Message-ID: <20231221-ufs-reset-ensure-effect-before-delay-v3-11-2195a1b66d2e@redhat.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
References: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.3
Content-Transfer-Encoding: 8bit

Currently a wmb() is used to ensure that writes to the
UTP_TASK_REQ_LIST_BASE* regs are completed prior to following writes to
the run/stop registers.

wmb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring the bits have taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bits hit the device. Because the wmb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed
by writel()/readl()), it can safely be removed.

Fixes: 897efe628d7e ("scsi: ufs: add missing memory barriers")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index caebd589e08c..7c1975a1181f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4726,7 +4726,7 @@ int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	 * Make sure base address and interrupt setup are updated before
 	 * enabling the run/stop registers below.
 	 */
-	wmb();
+	ufshcd_readl(hba, REG_UTP_TASK_REQ_LIST_BASE_H);
 
 	/*
 	 * UCRDY, UTMRLDY and UTRLRDY bits must be 1

-- 
2.43.0

