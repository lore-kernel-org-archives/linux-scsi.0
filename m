Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795857998;
	b=sBho+SDSC81+FGiIrwItxFNo9hLiNi8ch7FdtlwGPdvLMQ7AnGLKWcXe8TcDY2Kr5wdD
	 TKznVVGTjZEDYmMCFL8BqculckCqc80TvL679IX190Xdt45WZthUbtwkV3Fl959eND3je
	 B0En5VSviBkItM5dD2wk/Vt1MGX8yNdqCh9E4JBvTW6QSGAY5Y9qKLbuKCLBH+DGGA8TS
	 dRUN6/JYM3ZWoWlfjlHKcQFri+cBC+hKhFlprwGj/OB8jQx8vAYvaHVG1BDrgE1eFPwcT
	 plrTa1RIr+Ay+vuVfvV0mw3X/m5YGt/ZaQigmqPbpmmusUgU4Wl9MkTBdUfKtHXMbLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795857998;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=SRnTEN/kcUWjL11zSBmx07TepipqRFHHEqCMVO7V/zY=;
	b=s0ybOFITx9Xd9Axtcam6qsn1LE72y9V01KCCc9X4n4FQOK14hqSAZT+VS1eZOg9oP4/u
	 6G+Kp9CWzs1Os8H5RhpWvm1Q1f5WFW6QLzyza+8gHE0RG4Q5adTCqYS7QcV1Ppgptl2ls
	 G10Y0wcNkCQuM7esxVztbRdGtk8OCPczzRNtBKRSPP28kppKmbT4zU/oihQrRbCaO/WTX
	 06LKxguRx5oguDNKR5M6nPPzYiustRP38Q4O3qJlaL6aNyAwBJ3/DCGoyB4nyqR1f2fqI
	 5Zbd9KFodYvzH3kg9RB6jYGPIk+l2OD3esmNSsWQXJenuh4KRR/5KGCk/bm7CACPmXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Or+gTXzj;
	arc=none smtp.remote-ip=74.125.224.46
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58945606A692
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58945606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Or+gTXzj
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-67583c777abso9132890d50.1
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 01:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857997; x=1796462797; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SRnTEN/kcUWjL11zSBmx07TepipqRFHHEqCMVO7V/zY=;
        b=Or+gTXzjT4nqjdVHx/a6e82Cq1ehtAeBkDyRimr3f+2xGfmX/TcgwmTR0qimfeZlYO
         8XY4aaadLr94Rylzx/bW4ouADzyfuouJT0F/eIb2Rln9lnHPEhro8i8FflOmmDzhgAI0
         Ng0KSfk1ZuYqs9fTCl8InkYaDMvExvnOTSDgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857997; x=1796462797;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SRnTEN/kcUWjL11zSBmx07TepipqRFHHEqCMVO7V/zY=;
        b=B0cnR4pygNG/ReTd59bk6tJWmWG9VK2kuO3OfpvRqTSZdMiP0sZ4zel61v15pxkoqm
         WcaJ4c2GeZwnFb9VMg7lqnB/m4hCqJy/yNZPwOLnjf39G3hpkNcsXJlNiDXX/2ZJM2qK
         WLuj800jkSpmY9SnnBh8x489U0JSIH4hABzZqdOG3Vy92hHFFk3KiPo0t9jFnvNGMORd
         FG7thk5d8G3OKUAOmLfYBMgHmqChf4+V9IROp013SOwTXTFV5R3oo1425MdtfV/Kk+wf
         POtB2WI6VaW/lrFkz6Ly5z1Tewf/3wGy8MvxAw2duZWFQNw+bQMiBUVy01Lb1JTHQFcN
         1hEQ==
X-Forwarded-Encrypted: i=1; AL+hErH8qAsJHmxepe9OZN+xd6WwZ0XR021ol4KieYhbN+zqm4zIcdgazJTn71ZPxJfhC0K5Ic08sjyNle7Q@vger.kernel.org
X-Gm-Message-State: APuU4Z88f1oKFzkEqmzLQaHP1oAOc2c18y7TxfAB30kBcnoQR8Py8jt4
	f0qRlVHBkVXyDjsgrx2WaePEFn3rinZnZTh7MkJFu09BSW3B/c1jtGodL+Umql01eak=
X-Gm-Gg: AZFdTZfRWWMNwpeTsNoVPcYZ5VEtELaC2OUMTuKo8mVOaNYE4cZeheKYeP+0pl7+QDS
	scawE+JK/3bRNnFW3ckClW1NKxmg7B4iohVo5aJwiUp6Ge9fmAENururXYNjBtynF7w48WYzzex
	BjY4Sfg0jiHHgMIxJBkszWCFnhlA9q4kMNQF0Q3m0a+zwXKZ0PV/Z3vuLvh23Di/USpOARiXB3d
	t7IMyNzdo6PqdjrwyeaaAj5Bi7xQ6HWorhbf8aoT/CdA2ytULVMqEvINH/4Byw9KrHzo5gofOGm
	Ys/2jiAH8XbeMsUgLgs7U3lcPjN0O+Ck8NGdgy8NmK+fL62CQaQIVTEC/oVUC4cZduDrKdZlW1N
	ChlzwrUY1hqwflx6kQ7HCsk2QJNvB4uWsBtw9shPIc9faqBfK0sx1+iHrKSCr0648Eyik0bZNf7
	5fQ0P8vnz54KsZ1Jx/j5rjJrcyq1WENgRIK39XwWSIWQyaALpTmjFM8ERe+TSM51lMhdP7Vq3pt
	IoISEOtJz6wfDPxsjdoDoBmN8o2HcWcifoOKtaKV3Y6vsVYSJ26cv4ahad/wNPMtAb/Vq7H1+Ji
	TIIwwTxjcTSRk04nlI9R/vb+l0WP2fe7JmVNQIBBIjnIQetesZWt0CfLr/sk7SifVePOVo79dfq
	ODq+fdTkspy+Y4KLo0LJ4axLPphmuUs507xNr01bDKuKdeA5Z7dJzmCMLsJVnNehwXx6j6tb4ti
	ijNWNM/jhv7dykdNLlNwrHMV0PIVD+ZUpxRXaCCePvg2Vf1ARBOZXCVKbxolTcCUBRIHoreRpL6
	rwQD4hhQMGEI/Y2tzJtF5E=
X-Received: by 2002:a05:690e:4814:b0:67d:d7ec:565 with SMTP id 956f58d0204a3-67dec420419mr8266871d50.13.1795857997565;
        Sat, 28 Nov 2026 01:26:37 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df31fa7afsm12223319d50.1.2026.11.28.01.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:26:36 -0800 (PST)
Date: Sat, 28 Nov 2026 01:26:35 -0800
Message-ID: <8b760dc9733401f8fb5161877a705f4d746e1d32.1795842371.git.chris@chrisdown.name>
In-Reply-To: <cover.1795842371.git.chris@chrisdown.name>
References: <cover.1795842371.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 3/5] scsi: sd: Fix data corruption in WRITE SAME(10)
 discards
To: "Martin K. Petersen" <mkp@kernel.org>,
    "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

We already cap the discard length in writesame_10 and writesame_zero
mode, but we still truncate the starting LBA to 32 bits. A discard at
or above block 2^32 can corrupt live data near the start of the disk
and still report success.

The reason is that both modes send WRITE SAME(10), which only has a
32-bit LBA. Given this, let's only select writesame_10 when a 32-bit
LBA can address the whole disk, and not accept either of them in
provisioning_mode for a bigger disk. This means that a bigger disk that
only reports LBPWS10 ends up with discard disabled.

Fixes: c98a0eb0e90d ("[SCSI] sd: Logical Block Provisioning update")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 drivers/scsi/sd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 88b1c1d56d2f..d995650bc8a1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -597,6 +597,12 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	lim = queue_limits_start_update(sdkp->disk->queue);
+	/* A revalidate updates the capacity under the limits lock. */
+	if ((mode == SD_LBP_WS10 || mode == SD_LBP_ZERO) &&
+	    !sd_can_use_ws10(sdkp)) {
+		queue_limits_cancel_update(sdkp->disk->queue);
+		return -EINVAL;
+	}
 	sd_config_discard(sdkp, &lim, mode);
 	err = queue_limits_commit_update_frozen(sdkp->disk->queue, &lim);
 	if (err)
@@ -3431,7 +3437,7 @@ static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
 		return SD_LBP_UNMAP;
 	if (sdkp->lbpws)
 		return SD_LBP_WS16;
-	if (sdkp->lbpws10)
+	if (sdkp->lbpws10 && sd_can_use_ws10(sdkp))
 		return SD_LBP_WS10;
 	return SD_LBP_DISABLE;
 }
-- 
2.56.1

