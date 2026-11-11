Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794386938;
	b=kSK+kj5a69Y1xUAU9F305I1apGQZv/47DShwXEUwHbol6fY/bucWCuk6JyWrqD4wT89C
	 nSBmZlpmN2wjRCZKxrpD4h1MtYN5YAyvMRClwHKnkdjLd0CmzpNzGG+WakOX5LKoNQHZ2
	 vX6ceVyOiUNrpWKAO3aBfdk7URuhjoOlqYSHXEl/rmyfqogJaSLmdCQcWpYObg9EFUBU1
	 oV7Eec+jGSmjMHD6z/OsQIxbwRNQOJH39isliCm77inKj+AIudu9QL7eDc6c9x9UjkdDR
	 T2CtJRjFJcCzof3v2FtqYh/2E209gTkO7ifwxjHlfm/S8usZfVmCfrMh+IuFtbhf/sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794386938;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=XP4Wu7nT+ir3/JSpOzG3VpzBBZM0vfK9214Nh0VjCjQ=;
	b=sHv3ugYSQTcsuCrxdjesOJPMH1TE48OLn22JqFrjjG4QwB0lPwE69xyenIr2yLLEd9pk
	 3p+17lHH1flQKfsm7BgPhEnli3oBC0XctDwGTBBeIpxFU7G3QftWVT7IHQAJY9TvUHcnP
	 VG4FL7++rBnWqADQl0iZmDn0EWXWG9XWOqxvP1GCzqbyKOfcDt2BRVVoPI+toTz8NVstx
	 GH769RUZUuwD/TaLCGckBpHUod+DEBAv0XCv7rKVz4Ku+o51lLSkr5qJNaKSih5YF83pc
	 w704weqdsn/gvMglNi6gqFBbeb4CbbZv7FAh4c/LOMb741Gd09T+hu4vqAS1KeEqbBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lkXxAzOL;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7675B606A32E
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 08:48:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7675B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lkXxAzOL
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdd97f89731so767549a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 00:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794386937; x=1794991737; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XP4Wu7nT+ir3/JSpOzG3VpzBBZM0vfK9214Nh0VjCjQ=;
        b=lkXxAzOLGDcJQOYArOxY0/H4cx1atoR09E0e4P1pDXqIWRlrNlSMsw+R269b2d6aMS
         16AfD0Bn1upsZYShZ+3FkTBKAWiA69+AA9xs5F9C1PqLoD2LQqHdGvvME3CzgYTAT+9B
         7U1xyDYpowZAxIVwBftdRX4o58zWVA6CoYMCWF06UEnGY6M/MMqIywSxrbrnTjuk5NEE
         UDJKImRpLM7WRiuztp7MfK4KRHDxVVyxpttnzQKSS0u9L7kwNwaBrPIoY/YKWw0l1eFM
         Ie5mMldX3Qi2EBa5qT9FlnSueX0gSxUm+5ZDjyFXTrfhKamMtRXwUgVOhy7S0E7HGTni
         u4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794386937; x=1794991737;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XP4Wu7nT+ir3/JSpOzG3VpzBBZM0vfK9214Nh0VjCjQ=;
        b=ggC51Ep+kTryIKNT/Xg4n6qSF/Q1iYjl7mTUMHrzaUcMz41iDfgVdYt8eTaL1h9pzh
         kbSvd5JqCrXmxih/iRl7JU2Cy2gVs8GmRF72f+3/z37zBr/IPZ/CS4qsaAB7aip7eLBH
         nvGR4ois9WDqGyV6UBXNooVrNUp8hbuJdjdf3Mtt5sz0XAIrAu2bJe+L0XziPlV36wsx
         j5femERx5VPMF7AYSQ9G4oNGzVgSpQvdMVKZ7RtfoytFmx3EFJ3ZnmL7U86l3QhvbRJK
         JNGpbcrS1i2Ld8s6YlQjVarMpMkrnlABMzKgwiJ8YJNwiSySQpBM8EltOK2RdyEvCPV4
         gybg==
X-Forwarded-Encrypted: i=1; AL+hErH+L9gyj30p5x891w3Xq4VFW62DYENUK+1c35wmbBQcdvjai5EW0Uf9AEOrIEUu6kxDl79H10yE/y4y@vger.kernel.org
X-Gm-Message-State: APuU4Z+cvsAJ8D+buGbWBkyT6c4cuF1Inywl/AdVyni/gUdvbUHd6RRg
	1/VI6NiuoIfW8w3n9tGEIVsf3hE+S8CI+wJjDBK1iY+d5pO7iVMc+4QClltRNnBkk/PxBpjMbNi
	EHYcBK0RQYyrDQsoanIQ2zQ==
X-Received: from pfn18.prod.google.com ([2002:a05:6a00:a212:b0:89f:afc:76b5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9cc8:b0:3e1:6f0a:cf2f with SMTP id adf61e73a8af0-3f2febde39amr1339727637.28.1794386936537;
 Wed, 11 Nov 2026 00:48:56 -0800 (PST)
Date: Wed, 11 Nov 2026 16:48:53 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111084853.3530107-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: ufs-pci: Check hba->vops in system PM callbacks
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	sangram kumar yerra <sangram.k.y@intel.com>, 
	Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>, Stanley Jhu <stanleyjhu@google.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufshcd_pci_tbl[] defines the Samsung 0xC00C and AMD 0x1B29 PCI IDs
with .driver_data set to 0, so ufshcd_pci_probe() leaves hba->vops
NULL. Both ufshcd_pci_suspend_prepare() and
ufshcd_pci_resume_complete() dereference hba->vops->name without
checking hba->vops:

1. System suspend on an AMD 0x1B29 or Samsung 0xC00C host enters the
   PM prepare phase and calls ufshcd_pci_suspend_prepare().
2. ufshcd_pci_suspend_prepare() evaluates
   strcmp(hba->vops->name, "intel-pci"), dereferences NULL, and
   triggers a kernel oops in the suspending task.

Check that hba->vops is non-NULL before reading hba->vops->name in
both callbacks so hosts without variant operations use the generic
ufshcd_suspend_prepare() and ufshcd_resume_complete() paths.

Fixes: bb44826c3bdb ("scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/host/ufshcd-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 668b57403e62..f9abbbc436f4 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -644,7 +644,7 @@ static int ufshcd_pci_suspend_prepare(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	if (!strcmp(hba->vops->name, "intel-pci"))
+	if (hba->vops && !strcmp(hba->vops->name, "intel-pci"))
 		return ufs_intel_suspend_prepare(dev);
 
 	return ufshcd_suspend_prepare(dev);
@@ -654,7 +654,7 @@ static void ufshcd_pci_resume_complete(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	if (!strcmp(hba->vops->name, "intel-pci")) {
+	if (hba->vops && !strcmp(hba->vops->name, "intel-pci")) {
 		ufs_intel_resume_complete(dev);
 		return;
 	}
-- 
2.56.0.506.g506a7eabc5-goog

