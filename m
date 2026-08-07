Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9686637E5D0
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 05:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786080369; cv=none; b=TKTlYB+mk8qoI/TuCtOJXxokfHaXBb2XNjTwoPKUeXYvUf1naclNI9ot74KvurvbSF2wz+DvJvdBKSLKSYJfLBfglkgt1yqpgSxcAqXYjALWV7PR/40PybYuaZeduZzdZoGnwKXxDMnV55N0DvPX9RksIXlLLzW54AseiOigAjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786080369; c=relaxed/simple;
	bh=N9kYy5vVqmVHT5b2YlTC0fstsAGvx9Fj6BH6uRPvp2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rd4G5G8vi8cOZKW3MnfC9jkEzqNXNpKE83N2Igc+tdY3S52I1oVhUGe8Xg+zZo7CxnkQpMXtlFXR0rauT/0MsTOdMJ52+sTdM92TqFDNgRwHOmAsGXWzQEAqeSDCnjFmRiWYLD1i7BjFyoPrCK0qjri2ZMKlNVeHMUUE1EtnCaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yte0/rWh; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yte0/rWh"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3811f512167so3555016a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 22:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786080364; x=1786685164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zpg2YgaZDfS9JXkJtXX3JMZ6Ihbw7Qug6CaZTA6PXXY=;
        b=Yte0/rWh4T5YvmomozsByw+mN/+UJphrAMs8zaKl494nX0pOK7muWJ7jhXs5Z+LfVE
         7u9li4LRA6nFsngoyHmXhJ6G57ChEQHObiZ3lqtLFUwQMBB2X92OzkbxsMiCAwXNQJcj
         5RWvxY5/TJAdkeAB2mBxf4wfwhUKiMTuFxV1qFPs5bW0kydvGE11+sgFVDvwlVbw5zei
         SYKlS5tFKlCi0zGHjoFwbzl2K/KT0gVOu+TXKE75gIhcWP7EBHleZVRz8MhLGUIiBpMb
         DZqLko6NHj+xb8DURKnm5L4FlpOwjxEhrnmE5lxpl+GGxgS/F7AtK/MIH01mocU0VUJP
         hyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786080364; x=1786685164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zpg2YgaZDfS9JXkJtXX3JMZ6Ihbw7Qug6CaZTA6PXXY=;
        b=QkYVCB4KxoQgpw8U2EhfhdV5j3b4UR3X9bKHPG4LyC2g3V9A9DeWl1SYVZLS75/726
         p6HvW/PG4yjVAUD1uGqVvGTfChcPChzTMG3eVCpLlW5+so+ht0/VK+bAHgQRRCn8u1Z5
         TBTIW0XBgpB7km4OEI5XMqN2/TYOvkmujJe9UrSqMm+j62RRA88WGAS0wYIoXx8qhWY7
         Dhz7Y3+6IBhMYNrRl0Bzur79dWmOyKYjtXgyHlY6KfilPLxSRqIqI+/adD6EBmKNbS8K
         Z95BRr4VYcN/SW/GoYzb6tPDBoPq0NGkllvCXyJpKqqIALnBxFwW7uXi1BJKI2otWP/t
         UMHQ==
X-Forwarded-Encrypted: i=1; AHgh+RrkBQQqdulyZT8AGDh/pJcUyDJFe/AhzwcXxe45VHFoSxrXy7qx2M0FajIVEQieJB3YWeZhmDaKyCdb@vger.kernel.org
X-Gm-Message-State: AOJu0YyoL46bwQj0wUzfbcqowmqWpZZmY3SlsZO3GzpOfYAjQ0EVU2QP
	LKHiw6PAO44evrIiq+Gd8ecYciT8EqF9ZgmOj8w1kJG+XZG8yAY+XoSA
X-Gm-Gg: AR+sD11D2Ia7roBclJ8ynPt02EcBAJqY+nWA+STze8xzvFK+5PzlA3221Ebn47WalXh
	FLRAi++Z713vTcgvR6SmhLFmgUJzs+1uv1Ko+Fq1bszunDTZGcK5sGzNG98tqGOCVxzcxu3Gpbl
	zO5qAizMlbHh99wwMUwUyRVZGzRgcAaTjTf1jj9pKL0hTWsVs6qSAISfZ3hoA8/gQf5X3ORHVIT
	KL5Xyzu2EjgwSWucCzU8JJHf+sBUQ7pjhSLS1gvUicQdNTrs99BAbgKwKlM5+WznLQCQ5utTA0c
	oNuDnwDN2SApW4F9GFrmwn4FB5D2rBYessZsXEdcuMomG6VBDIxwPELPFMKLvAlaHxCS9Yo/c4F
	7ffl9Fzdr4Ep7WAjEodTGduQgZSeV9rY9b36y66al7pEUvp9lq4DnAgZHvPu6D4Sd2KxvnmvhVb
	QiMSOexXXatwOHbJv/kQiKUDNcGFhoMtpjoqxOU0FrEHVbRZJO9hDB8folCN3t0XbS9acD/DVZY
	CFC7mL7N4wS0/kYSpY+l8/2czCmgUOAXxf9JFdQ6lABt14DQRiU3LHiv9VB
X-Received: by 2002:a17:90b:540e:b0:38e:6a30:4bbc with SMTP id 98e67ed59e1d1-3903c681346mr23457760a91.21.1786080364185;
        Thu, 06 Aug 2026 22:26:04 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085f5e33fsm3186836a91.14.2026.08.06.22.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 22:26:03 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: viro@zeniv.linux.org.uk,
	axboe@kernel.dk,
	bvanassche@acm.org,
	ching2048@areca.com.tw,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH] scsi: arcmsr: fix NULL deref on dma_alloc_coherent() failure in arcmsr_alloc_xor_buffer()
Date: Thu,  6 Aug 2026 23:25:43 -0600
Message-ID: <20260807052543.62545-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arcmsr_alloc_xor_buffer() does not check the return value of the
initial dma_alloc_coherent() call before using it. If the allocation
fails, the code performs pointer arithmetic on the NULL base
(computing pXorPhys and pXorVirt) and later unconditionally
dereferences it through pRamBuf to write hrbSignature and other
fields, causing a NULL pointer dereference.

Additionally, acb->xor_mega is set unconditionally before the
allocation attempt, based only on firmware status bits. If the
allocation fails, acb->xor_mega remains nonzero, so the later
cleanup path in arcmsr_free_ccb_pool() and the message-config code
in arcmsr_iop_confirm() will still enter their "if (acb->xor_mega)"
branches and dereference the never-set acb->xorVirt/acb->xorPhys,
a second NULL pointer dereference on the allocation failure path.

Fix this by checking the initial dma_alloc_coherent() result and, on
failure, resetting acb->xor_mega to 0 before returning -ENOMEM, so
that no code path treats the XOR buffer as present when it was never
allocated.

Found by static analysis; no hardware reproducer.

Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
Cc: ching Huang <ching2048@areca.com.tw>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 8aa948f06cac..40407b281839 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -771,6 +771,12 @@ static int arcmsr_alloc_xor_buffer(struct AdapterControlBlock *acb)
 		(sizeof(struct XorHandle) * acb->xor_mega);
 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->init2cfg_size,
 		&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent) {
+		pr_info("arcmsr%d: alloc init2cfg buffer failed\n",
+			acb->host->host_no);
+		acb->xor_mega = 0;
+		return -ENOMEM;
+	}
 	acb->xorVirt = dma_coherent;
 	acb->xorPhys = dma_coherent_handle;
 	pXorPhys = (struct Xor_sg *)((unsigned long)dma_coherent +
-- 
2.55.0

