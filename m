Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2860E484257
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 06:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792391415; cv=none; b=QWvQqWtPd2RRVRMAF/wc0qiyoCTB+/oHMeP5Kkj5JNwBk+cy+jXrR569RrAFP5+ivP5cGcOVO2l21r1wAkrmnsqfdaDqNGsrHJMh6IiZzuwC1z0paLbZZ0jEQk5yoeVjUjT0WswUnI2jjFb1T1rHJGwCMjen/Fm174hyx/B3POs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792391415; c=relaxed/simple;
	bh=8HiMwBMkCeWN209vez9TuxWTIpvLE2DeOPEip0f/oko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uYsHoM5KUcHpqz774G7TsWCoHC3P7c4EvcyBcU+GqyHl75J3cjdo0uCca6dDAVxVRh6MvH94QyZuykyR/P8cMDxpf1mnsv8r2/JYRkfY8rTlWJ2rHI+SaXzkRaubLEL4wMz8wAIOSMoNrDpAJ1F/Ppe4RkV54CKuz3kLC2CkKlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WqyyJdc8; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WqyyJdc8"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ab98332238so1393846a91.3
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 23:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792391413; x=1792996213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=a7Dd0vsYqD5IFEwNvdho9EvhMNFAgwfQgTkufrZ9XbQ=;
        b=Sx6GfwyN5Fa/C90zPoEzLFXR1ChcFmP5/GlX4rjK7MR9pzFB8zFGF2wUaX3Zsc/fou
         vbzBfRyifayrWfbHyg/G9AWarK4U7y/ZGNH4HBFdV2KnaabrschTEUVTKrHvvS6uluxl
         0pP3nSBQOUxG/mIfeQXUu8JTCH0/17/ZkpO5mHN4rrGpu29YqUEgm9OLBYkst4KcZW5e
         jrCwK6XF5/GYnY6ZHkYL5jvR7vlWnj1qtmj1YnBimf/M+ULssNxNdpItVCy00fEBb8tW
         RUwJ9nppwqRUGNdljOsecHaItt7nOg6By5zrh0lHL5N8fD9yH4fJXnwux3L6136y9GWJ
         v+TQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTMRlzSAJli1vU8K7OVM8jh4CZglfV2Mhr/EQzyVk2Uuu++EImze1UCH0DVGZjpqiYWfUHqtj3iUIW@vger.kernel.org
X-Gm-Message-State: AFq9FYK4f0hNXtESMjBKXPLPHPaAfSfxDjEevvnrCJSD40q3c02mbr54
	OkE9gqIrHC+QePPKVg94vAQ+TNncQ8ZsgGCAa3470d7cHQ324WUBpodAcPYquFgGuVdQGIo+gvh
	3rfwGo400W80qHYyT5pFcbmttm8OzFDqCCwZQ801WBNl7mKfao4Hq5hhq+2q1mNkG1n5p4aisCK
	9q1TPn4iGRP/d1Lld6rHXZ5Aui5GyE3Mhp0aW2Rr869Bv0j3lrMbkxVj69eUBh2da02uVkoDCeR
	fFJRi4bsguxprA=
X-Gm-Gg: AYBFou3WmemrmoPHDpdMJvRO0pyk1syVfGZKjKLHvQy64b8TKKbfJ/9/VLWrsiAD3gN
	aSPVzjixq8q2xoyMOKOoOl6yFWb98027j5PaWwRBNpTITxIRM9tDFLu4PQ2Ae+vVLMo7jwcohf4
	m5YofNrWwKNRU6rsJsRdIf5zAR6Y7VjbRjPKWWYx4ooQ3C2TpWr/AtfnbBjnVy4TAZPU4yvAWQ8
	MhwNMD54L++kSvIfaNS4kxC0HvvnOHfuDJ2aIbfFD/qhJ9R9hvFUIgHu7IJmFQ1gAJZDkUpS8Sd
	2OdCYUX9ESoNES7ifnfdziOb8e/D2mcKNkCAIrR42ICjBpUg+Oil/9vZviFFpFYDScGR2OPdIsw
	L/6IntNnIiQkipMK0o1bkZAcCxjZCccRSGYlfPZ11Q5Un5BE/VM/RfHrl9697ZDHz7xABi8xFvP
	6WuGZnzC70RIlLoLCvVR3gcksK/QrhMfeMhA==
X-Received: by 2002:a17:90b:380b:b0:39e:59a0:46b5 with SMTP id 98e67ed59e1d1-3acef14451fmr6087328a91.24.1792391413314;
        Sun, 18 Oct 2026 23:30:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3acdd2cb7e3sm5806227a91.0.2026.10.18.23.30.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Oct 2026 23:30:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-18ab3ee4935so608201c88.1
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 23:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792391412; x=1792996212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a7Dd0vsYqD5IFEwNvdho9EvhMNFAgwfQgTkufrZ9XbQ=;
        b=WqyyJdc8pwvfLeoofWM19oFOv/6X3IcrEyEKn5u00YgIHB0JN0isSHIoFljkXgyBJZ
         w2jVCD748dBCKGHHDkeR0dhoYdNexPvbF+tWTdDI/yy1TTUzV6r9xoZ2mVIQF8mQafNB
         VJqdnAqU+iwaT/AGH7CNcdXN6adVK3nRwln+M=
X-Forwarded-Encrypted: i=1; AKwUvBx3fSzyprzlNF+j32nPQu00vwE0Ay2l3ZWfI+7cOLIUjzuOi9NZ7VnfQ1mZvQyAHh8fF+WYOWhp9VHH@vger.kernel.org
X-Received: by 2002:a05:7023:901:b0:17c:393d:a0c8 with SMTP id a92af1059eb24-1850c40d87bmr11848495c88.5.1792391411435;
        Sun, 18 Oct 2026 23:30:11 -0700 (PDT)
X-Received: by 2002:a05:7023:901:b0:17c:393d:a0c8 with SMTP id a92af1059eb24-1850c40d87bmr11848316c88.5.1792391409717;
        Sun, 18 Oct 2026 23:30:09 -0700 (PDT)
Received: from matt-workstation.dhcp.broadcom.net ([192.19.38.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831a6f5a13sm30734097c88.12.2026.10.18.23.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 23:30:09 -0700 (PDT)
From: Matt Wang <matt.wang@broadcom.com>
To: vishal.bhakta@broadcom.com,
	linux-scsi@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com
Cc: Matt Wang <matt.wang@broadcom.com>
Subject: [PATCH] scsi: vmw_pvscsi: add support for ARM64 architecture
Date: Mon, 19 Oct 2026 14:29:58 +0800
Message-ID: <20261019062959.426900-1-matt.wang@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This change adds PVSCSI support for the ARM64 architecture, restricted
to little endian and 4K memory page size. Barrier usage is updated from
compiler barriers, which were sufficient on x86, to the appropriate dma
barriers.

Signed-off-by: Matt Wang <matt.wang@broadcom.com>
---
 drivers/scsi/Kconfig      |  3 ++-
 drivers/scsi/vmw_pvscsi.c | 40 ++++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index fc8e8b0bf..4503d7ba8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -569,7 +569,8 @@ config SCSI_MYRS
 
 config VMWARE_PVSCSI
 	tristate "VMware PVSCSI driver support"
-	depends on PCI && SCSI && X86
+	depends on PCI && SCSI
+	depends on X86 || (ARM64 && !CPU_BIG_ENDIAN && PAGE_SIZE_4KB)
 	help
 	  This driver supports VMware's para virtualized SCSI HBA.
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 151cac9f9..f6098e51e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -650,12 +650,18 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 }
 
 /*
- * barrier usage : Since the PVSCSI device is emulated, there could be cases
- * where we may want to serialize some accesses between the driver and the
- * emulation layer. We use compiler barriers instead of the more expensive
- * memory barriers because PVSCSI is only supported on X86 which has strong
- * memory access ordering.
+ * The completion consumer index must be incremented only after the completion
+ * entry is read. The read memory barrier combined with READ/WRITE_ONCE
+ * ensures that all reads from the entry happen before the increment.
  */
+static void pvscsi_increment_cons_idx(u32 *cons_idx)
+{
+	u32 new_cons_idx;
+	dma_rmb();
+	new_cons_idx = READ_ONCE(*cons_idx) + 1;
+	WRITE_ONCE(*cons_idx, new_cons_idx);
+}
+
 static void pvscsi_process_completion_ring(struct pvscsi_adapter *adapter)
 {
 	struct PVSCSIRingsState *s = adapter->rings_state;
@@ -666,21 +672,14 @@ static void pvscsi_process_completion_ring(struct pvscsi_adapter *adapter)
 		struct PVSCSIRingCmpDesc *e = ring + (s->cmpConsIdx &
 						      MASK(cmp_entries));
 		/*
-		 * This barrier() ensures that *e is not dereferenced while
+		 * This barrier ensures that *e is not dereferenced while
 		 * the device emulation still writes data into the slot.
 		 * Since the device emulation advances s->cmpProdIdx only after
 		 * updating the slot we want to check it first.
 		 */
-		barrier();
+		dma_rmb();
 		pvscsi_complete_request(adapter, e);
-		/*
-		 * This barrier() ensures that compiler doesn't reorder write
-		 * to s->cmpConsIdx before the read of (*e) inside
-		 * pvscsi_complete_request. Otherwise, device emulation may
-		 * overwrite *e before we had a chance to read it.
-		 */
-		barrier();
-		s->cmpConsIdx++;
+		pvscsi_increment_cons_idx(&s->cmpConsIdx);
 	}
 }
 
@@ -764,7 +763,11 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 
 	e->context = pvscsi_map_context(adapter, ctx);
 
-	barrier();
+	/*
+	 * Ensure writes to the request entry are done before
+	 * transferring ownership.
+	 */
+	dma_wmb();
 
 	s->reqProdIdx++;
 
@@ -1105,10 +1108,9 @@ static void pvscsi_process_msg_ring(const struct pvscsi_adapter *adapter)
 		struct PVSCSIRingMsgDesc *e = ring + (s->msgConsIdx &
 						      MASK(msg_entries));
 
-		barrier();
+		dma_rmb();
 		pvscsi_process_msg(adapter, e);
-		barrier();
-		s->msgConsIdx++;
+		pvscsi_increment_cons_idx(&s->msgConsIdx);
 	}
 }
 
-- 
2.52.0

