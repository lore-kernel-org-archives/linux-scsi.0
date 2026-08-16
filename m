Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8C13AFD06
	for <linux-scsi@vger.kernel.org>; Sun, 16 Aug 2026 00:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786839434; cv=none; b=crslW4nSUJf4H4lKWQ+Brv24nFingHnrqxkOu5hz8XgVpRW8jHCHSco/jPD8oAHnLYUIeTH8B4N4AvunFQQ6v2rX3QN5gcD0ymJlze8A9v37HXlZXfKRgMZfXIb3uckV27YQ++4NE5PwSTLzXKG3WpR8T7ZhbFUO6sQfRoO46k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786839434; c=relaxed/simple;
	bh=w8XQKrhNvSVyxO3o8Br0CYUHQxuFuFqjVy9UC/Rwn9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=spwx4z5Z4Y44EIZ34f1qENV28YbAZg8qg8X/79xGoXdv2NYmcJaD2l67IKs1j+4f/CQGNEKZq0ZyCjrk1By8t7mmiGjYjFUZEQIfDD3rUBnxKADzL+j6x8T36s9xMFjMVGgi/W6EHvsudF1XlSLULXNI17Du+5UpcVqYkhdx9MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h6NhRl9J; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h6NhRl9J"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso3430695a91.1
        for <linux-scsi@vger.kernel.org>; Sat, 15 Aug 2026 17:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786839432; x=1787444232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rSdgV6y42DYjUopMs0+QFmae89ZdyX+OlLBZ6Fbamf4=;
        b=h6NhRl9J+ODBaHMcEnV20HhjBrI9p0eXJaliluNpQ8YzYiL7XTuUg0FGOJq4C6DJfP
         mJEcknKztMvOWr/hc1Vc2KV9oCeQI3gJuVFM1VGbdqdahYKYbzSoRRHQghFDx4Ny94gr
         yHkgwAHSthd93xs1TAwUeZ8XRo/nWboj2D/kHGxshfjwcBdhjeTpP+AqOdGPk4Q4L62/
         z5cOrJ487D3t64CyF+spg3AmWnJ7ZJnbf+amBcRPwe/jXIGkW5LayHAWTSWQIGT7oPuV
         Fp6+jagL7EOKYtjtvlqNBHcmJ2xIIIpyJPW8kuQcIYhNpFe8xZvuoFySnCLOOzUGDJ3P
         HsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786839432; x=1787444232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rSdgV6y42DYjUopMs0+QFmae89ZdyX+OlLBZ6Fbamf4=;
        b=VdA4I3zjdOSFo/OXoPDHpVWvi/O++c+9TkwI/GKAS7bXZ3t4Yx8CUa6fCzli7yg/+p
         Vj1YAP7GCN48hReLOJi02/Rb//ui8ZC8DsFHA4dUolzfzS/hd/XagtEEys/MKxYP/Vv6
         CIWsgWG2d6/diLeiOmeAtK9NsmtKbR8o88xW8MVfwU4GAHgiu/1ivKmxrQ1xXZw9aAtj
         NaNJyVn8fLL3kSeHpl2Xb8+/A/KsL6IOzBHyPQniY3AJleM1MKpJpqEzJNmwh9bGQGqG
         A9OVpH31PwO3cCMiSRwTnvWbcOivSelDxsI5fTzYyJf9MAOwOKPIpqp8gfKcXiTPHCHT
         M49A==
X-Forwarded-Encrypted: i=1; AHgh+Rq9JGDAGyVEw+ghU7PSZ0dehORuRnnV1bwYtol/6LirUo3FwetbcaVXJfvbkFYTJT+IMZG8bWHKxSNh@vger.kernel.org
X-Gm-Message-State: AOJu0YyNKnRjZIAN3b62KrFStJ1/9S8j8Win8yxXl6AQrhmcHyqR0UGL
	ZZQ8FCLy5kbmq/eQxWNen+g1NornTFkRjxs3FQcpTZM047CTgjaooh0A
X-Gm-Gg: AR+sD13ntDD/ZQqEdZdZuGR1rLRCOlcEmWSfghpL4S1psu3OKkaDDRHSydFEhgZBDCk
	aADvXSld3WHKmmwqQT0L2C0ui1m3ofqqyf6jkcFwecfGSBuyaJtKluXF4i34W6xhgihqiQpAJvD
	SQQg8dxJEgroXM7CXz+GIU9gPML08wPyIn73JA7acBDts+oRJ+2fKMhrDyNthW8vzDaOoa9l53E
	uEBCm1nG+id+QUHs2UafOBSy27EzZI1q8nEqTsqCFVtSRJbrktbhSx+NpkpFuXT2CNcQTCX+FXN
	DJruwzxbnr9Oqy/s+wytNrTcTssTut/26+Z4j51/5+3SWeyQXqk3aZEKIVC4I1G2P1n9v1pi0xM
	7W35cSYXuii8o5pqkjgZSRgq2sH0Z2J/37kNo6CKHRkVC0eAR8nHlSSBzzS6QP040BNolSHj9KS
	RZgL245TPRA+HqbNA4wzILYII7beMh0myGZY5FPAiFhy84J7HqK/xGPg==
X-Received: by 2002:a17:90b:3910:b0:38d:f096:a1dc with SMTP id 98e67ed59e1d1-3933b872257mr16984203a91.11.1786839432357;
        Sat, 15 Aug 2026 17:17:12 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea96c7fcsm7660649a91.3.2026.08.15.17.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 17:17:11 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH] scsi: mpt3sas: add device ID 0x009f for SAS9300-4i4e
Date: Sat, 15 Aug 2026 18:16:54 -0600
Message-ID: <20260816001654.12003-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add PCI device ID 0x009f (MPI25_MFGPAGE_DEVID_SAS3008_1) to the
supported device table. This is a Fury/3008-family variant found
on some SAS9300-4i4e cards sourced from the resale market, distinct
from the more common 0x0097 ID used by most 4i4e cards.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219330
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 02bf26ca976e..6d7c5bc13377 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -563,6 +563,7 @@ typedef struct _MPI2_CONFIG_REPLY {
 /*MPI v2.5 SAS products */
 #define MPI25_MFGPAGE_DEVID_SAS3004                 (0x0096)
 #define MPI25_MFGPAGE_DEVID_SAS3008                 (0x0097)
+#define MPI25_MFGPAGE_DEVID_SAS3008_1				(0x009F)
 #define MPI25_MFGPAGE_DEVID_SAS3108_1               (0x0090)
 #define MPI25_MFGPAGE_DEVID_SAS3108_2               (0x0091)
 #define MPI25_MFGPAGE_DEVID_SAS3108_5               (0x0094)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12caffeed3a0..9122ee86446c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -13303,6 +13303,7 @@ _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
 		return MPI2_VERSION;
 	case MPI25_MFGPAGE_DEVID_SAS3004:
 	case MPI25_MFGPAGE_DEVID_SAS3008:
+	case MPI25_MFGPAGE_DEVID_SAS3008_1:
 	case MPI25_MFGPAGE_DEVID_SAS3108_1:
 	case MPI25_MFGPAGE_DEVID_SAS3108_2:
 	case MPI25_MFGPAGE_DEVID_SAS3108_5:
@@ -13907,6 +13908,8 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3008,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3008_1,
+		PCI_ANY_ID, PCI_ANY_ID },
 	/* Invader ~ 3108 */
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_1,
 		PCI_ANY_ID, PCI_ANY_ID },
-- 
2.55.0

