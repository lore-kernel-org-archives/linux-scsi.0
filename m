Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6772C3E451B
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094603; cv=none; b=CXzwDb94loF5Tj6LASN72klP9T02HgWZsUxSBUKZcQEnX4fksrMngKF4mLt5UIqExTuqzX1Rfvs7yRoi2JSdTExXGlgvYMXSD93XgRQRNDktvp+1x1SAKFVxgCIvAIoaphsH87TVYKytZKrEARPSmkrsBkXPYzVW6KwJleMtQ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094603; c=relaxed/simple;
	bh=/j8zxAOgXfwVIkihoKCWYxsy6SGLDEogI8QwPoIgXAM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ECcIIEwlCs0a+nOUx5/IdDGRXw5z0PAckfFreo3m0z9KM1vbvLOdZaNZHEM3LxVyhBQH/4G35mrvHrewN+ybszNYZalt4FwXLU13IMXd67PdmZmv7JGM/GTQwsIpxD+Bn6z0+58NFCQIP0sMq2vgAaIGg9xYIEKA1bWuYcrYBDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pmpxDsGM; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pmpxDsGM"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-855315ccb64so385729b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 19:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789094602; x=1789699402; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VIFobB/49RKC10K8JbhHdKLcDdcT1zlJJkKF9fMl4pE=;
        b=pmpxDsGMsOqSpB4xZ/25bkVMQ9O4vIfjCF2z/uuxGjU5KfZ4kdXlzLaipDvpl3Izec
         57agIqWu4NLIjU/MjVBMNWkX21eSz+qklIKEaiZpwqTPxLFcfR//0jIcfPetImZqTaIS
         R5Y5LAzqx41foOvFwcR0/Q4PgxYOaLOWoFYZ5bIa9WMqEdoQAV281zGPUsTai44EIK2G
         88OZGejnb3io7WS/umarHrO/5PZZYHSHVPO6FdLCoLkczRG+JiuOvtWl0VzmxO9kSJEx
         dI9eyeFD2omU54XoW08lMTs8zsnZHxc/mTxlPpicOD16X2SEFP7cSmT5sR/Neg9fxSMX
         VJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789094602; x=1789699402;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VIFobB/49RKC10K8JbhHdKLcDdcT1zlJJkKF9fMl4pE=;
        b=BwdE7sGBBVNPiaHeHxEORpz9wCa6QLXB3Uk59HPiTNOsssFEvnmDi3VfZj6Ztu1fqB
         KETWN5SNqQKcNS5W9+8HvQuA0KXb2vrTCxaZTfbVadj0keYWGFVVXE9x4+xUS6r5uCoY
         Rtly7Gt+nDjD1t1fU0jGB2B22n0LkPMQoIIJoun3m9WCWiMHj5UFeZbpJ8zifYpeRNu5
         7I5erggx2qsH8kjlr6EMnYzOdZ01dd5MtJwGzNHntSwfk3k0bZU1WwuXdELoxgYnWv9x
         Wjoj8OCUb8eAnpon3G55Kwmlmh5aEbZ6tgeJY6tIoRcDK6DtwthhAoQqMHKEfYbEfqlB
         Gzzg==
X-Gm-Message-State: AFuF++kn+7TVr+FygsQ66pW/5z+rGUG9F4Epo2E2Y+7ADWc8X4ZHNFra
	mH54VAKvS4aqsBvq2qS5iLo6H4NYDbWI74i+Z8OF8r0Uskkxy8EZZYTFAsnaWre4gmMs/xBAoZk
	LvkkIUWjaI+Wa1u/TOXpq4Q==
X-Received: from pfbdr7.prod.google.com ([2002:a05:6a00:4a87:b0:863:66b8:b7d])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:8882:0:b0:847:9aa8:d3ce with SMTP id d2e1a72fcca58-86b2dd00270mr3038046b3a.2.1789094601474;
 Thu, 10 Sep 2026 19:43:21 -0700 (PDT)
Date: Fri, 11 Sep 2026 10:43:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911024319.1346706-1-stanleyjhu@google.com>
Subject: [PATCH 0/2] scsi: ufs: core: Handle devices declining optional Query IDNs
From: Stanley Jhu <stanleyjhu@google.com>
To: mkp@kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bvanassche@acm.org, avri.altman@sandisk.com, alim.akhtar@samsung.com, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

JEDEC JESD220F specifies that a device which does not support an
optional Query IDN returns QUERY_RESULT_INVALID_IDN (0xFD) in the
Query Response UPIU.

The driver maps every non-zero Query response to -EINVAL and logs
dev_err(). A device declining an optional IDN is spec-compliant, so
this reports a failure that did not happen and keeps the retry loops
resending a request the device will never accept. On UFS 4.0 parts
that omit the Timestamp attribute it repeats on every boot and every
resume.

A third model was recently proposed for
UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT; recognising the rejection at
runtime avoids growing that table further.

Patch 1 decodes 0xFD as -EOPNOTSUPP across the query layer. Patch 2
uses that to stop reissuing the Timestamp write on devices that
reject it.

Compile tested on arm64 (defconfig + SCSI_UFSHCD).

Stanley Jhu (2):
  scsi: ufs: core: Fast-abort unsupported Query IDNs
  scsi: ufs: core: Dynamically disable timestamp on unsupported devices

 drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++++++++++++++---------
 include/ufs/ufs.h         |  1 +
 2 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.55.0.1007.g17ff1f9808-goog

