Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC1C14A09E;
	Tue, 15 Apr 2025 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676895; cv=none; b=a4KrjPe/fm4BN98MqHgZoAdhi2tdbZNGmoHHwEmC4RQI3kOh6jmXnLjbM5tjI3RNv3Yi7bDnVxt/u8gy9mWIgwZ7hLOjaPIvdZzbEek7wT75vqMxBQx1i24VqPyc5KKC9hQgXYJG2rHYrs8roAFOcIwXMm47hcWEBhhgiKdvMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676895; c=relaxed/simple;
	bh=ZeShHr8tVZKPg71XR95ertYuyXkqDwJ50Bc+xq/6+a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSjHzzRuYZk9PJJQ8TtcQFq3GilvsCwlsxLL6v7Uc1hyB9urF5V4mvYvUFS2y/agIt/R4qn35rrnxA5kppuMEsSGOUhXNYF7eJhC4N2k+HDp1X4v7lhJVY+6hDwogkmX34FPWjiJ9qZqfInfnvySYkjJmb2V7Rs7bXiVhYmgNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Tl8h7MzY; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Tl8h7MzY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=8/ZZbVr4lqL8Td/j0X5Tyoi0ONfVB87bZftpxp57CzE=; b=Tl8h7MzYtPLLvM3M
	gnLp62tlxE4vCVNQypKuesMBumgG8EJTfeJTu094h6UXeXUZNzKDvwgfoy+XazPAhuTt3980Y17Hp
	tbeQ0UWMAER5+j3QlxHafErb6kiv1XeYAFe10nUXJ1hqXyhl+eouVlsIiae+Pm45OcwwUZfvsdk+A
	If7in+BD/DgyLJdzd/y7ShYUlovP76Frs0Q2qQXyPT52SZ1I3s5lWFX63h8eIhb1AcNxBbvX6N+lV
	YaeGb/m5T5eHPCuNNsFerOSaCDeAt1KfyqgWstOGe+wCg2ZGz6eybI6S63JXJ1BDbfa5hHooNxnLw
	lHJhqsKlguSzjwJQzA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9n-00BSPG-0b;
	Tue, 15 Apr 2025 00:28:07 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 5/8] scsi: qla2xxx: Remove unused qla82xx_wait_for_state_change
Date: Tue, 15 Apr 2025 01:28:00 +0100
Message-ID: <20250415002803.135909-6-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qla82xx_wait_for_state_change() was added in 2010 as part of
commit 579d12b58abb ("[SCSI] qla2xxx: Added support for quiescence mode for
ISP82xx.")
but has remained unused.

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  1 -
 drivers/scsi/qla2xxx/qla_nx.c  | 26 --------------------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ad76cf8e123d..73bccd514791 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -865,7 +865,6 @@ extern int qla82xx_rd_32(struct qla_hw_data *, ulong);
 
 /* ISP 8021 IDC */
 extern void qla82xx_clear_drv_active(struct qla_hw_data *);
-extern uint32_t  qla82xx_wait_for_state_change(scsi_qla_host_t *, uint32_t);
 extern int qla82xx_idc_lock(struct qla_hw_data *);
 extern void qla82xx_idc_unlock(struct qla_hw_data *);
 extern int qla82xx_device_state_handler(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 1da954f446f6..78725bda3714 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2915,32 +2915,6 @@ qla82xx_need_qsnt_handler(scsi_qla_host_t *vha)
 	}
 }
 
-/*
-* qla82xx_wait_for_state_change
-*    Wait for device state to change from given current state
-*
-* Note:
-*     IDC lock must not be held upon entry
-*
-* Return:
-*    Changed device state.
-*/
-uint32_t
-qla82xx_wait_for_state_change(scsi_qla_host_t *vha, uint32_t curr_state)
-{
-	struct qla_hw_data *ha = vha->hw;
-	uint32_t dev_state;
-
-	do {
-		msleep(1000);
-		qla82xx_idc_lock(ha);
-		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-		qla82xx_idc_unlock(ha);
-	} while (dev_state == curr_state);
-
-	return dev_state;
-}
-
 void
 qla8xxx_dev_failed_handler(scsi_qla_host_t *vha)
 {
-- 
2.49.0

