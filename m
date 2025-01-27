Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADB610E3;
	Mon, 27 Jan 2025 00:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737937580; cv=none; b=IwgWUzbURX+7zVTHxCBJvyG5XIorbwvfK3rH/C76XSc41Ozg3MSYek53jfWKKHrr0Awm0L9wVZUXRXZ4+3zcNsNTcn23Bhsq3x3i/7S8dKgHNIlwE+LAtRibC67LgvHpByKwsNPQx9g/I6RHE2PWTblNXnyddg0w3611084EFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737937580; c=relaxed/simple;
	bh=sp07x5YK/Br0Ron2AUSGI/+KniTnGGcnlh/1vbXnqJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gYmmp0swf7EMkudgt2DpsNcg3pfa9SgDDj8o8a4f80m38mpj+y8I6y+/AMLgCSsRDFgF8NaJBRflpoOoTfC63Cpo2lfN/eQMueike26RScAFNaREBYTF8+9xsmEwnIavKoRwM5RYyL4SnweJSVumk5BZfYJqeluyVreT5BYsH9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=DMmeHhDv; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="DMmeHhDv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=xM1qx7/9y3dZfBk+GZBSvha489O+0pxmvwzewQVRcq0=; b=DMmeHhDvlERUaiYj
	putgXnT1yXxdKx09jn0tdPbjkauXgXulW0iTQmrTImn68tSsIYOOC7gdtJTeIkJ6MKgssMy0ImXGL
	U+DYZq+86NPQR2UPJhTRpJqwG+JEwb1D0GNE/l0J8wdeKKUIhzr66UkiNJcyBnoGAHhx+eeUx3NjS
	PQ36bMYIZatUrawXoADkY7fVqJdRrE7ktyY89WnJen6tgyerince+5cWwe5hCp2JPQ2xlEElahdPr
	cN79RvbNJccjgjWju0ec29DuGfucr1zfP+bsnJKbSJnKtzpqV2AceXFfMWELQ4xvjd7mYERLqEu+Q
	drgCQX7OattVFyv84A==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tcCx1-00CDuU-11;
	Mon, 27 Jan 2025 00:26:03 +0000
From: linux@treblig.org
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: mvsas: remove unused mvs_phys_reset
Date: Mon, 27 Jan 2025 00:26:01 +0000
Message-ID: <20250127002601.113555-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

mvs_phys_reset() was added in 2009's
commit 20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change;
bug fixes")
but hasn't been used.

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/mvsas/mv_sas.c | 10 ----------
 drivers/scsi/mvsas/mv_sas.h |  1 -
 2 files changed, 11 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 1444b1f1c4c8..c4592de4fefc 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -151,16 +151,6 @@ static inline u8 mvs_assign_reg_set(struct mvs_info *mvi,
 	return MVS_CHIP_DISP->assign_reg_set(mvi, &dev->taskfileset);
 }
 
-void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard)
-{
-	u32 no;
-	for_each_phy(phy_mask, phy_mask, no) {
-		if (!(phy_mask & 1))
-			continue;
-		MVS_CHIP_DISP->phy_reset(mvi, no, hard);
-	}
-}
-
 int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			void *funcdata)
 {
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 19b01f7c4767..09ce3f2241f2 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -425,7 +425,6 @@ struct mvs_task_exec_info {
 void mvs_get_sas_addr(void *buf, u32 buflen);
 void mvs_iounmap(void __iomem *regs);
 int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex);
-void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard);
 int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			void *funcdata);
 void mvs_set_sas_addr(struct mvs_info *mvi, int port_id, u32 off_lo,
-- 
2.48.1

