Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CEA4400;
	Sat,  3 May 2025 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746313582; cv=none; b=Y0U9e+wbBmivrbEcMdkarAsxp3v5YXuGA6K28ozscg4dQ6vu7Y+5sDCpkWU7TBXIWF1m4fajVjn2vdZnVU0ROGr7RpoFjO5b9st8dV99kBEciewrBlxg0U5m+BfFyoXoMJqsxVPUua3+G6t2BuiAUXlk5RT5fw7vqih2L1WIjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746313582; c=relaxed/simple;
	bh=avkmmnbkwKnFk3/3A4l2Hup57et7T9MaqDFdBBP/6E4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ki5YL8+H4a5WMeB9WeHjxGVFrghIfeIL99hXcMy8i+OgEqRrXCebrEQA0zg/jPhWG7Eeq1L+Q3KhF0BbrdoHRIGLnOx4dN0PlinqVJEs2AXhJqYsWRsYA4oILSGwYV+dHJ3wReKEnY2YwtmxCfnzdkfbZOsPUsL/uVq4g88uyXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=svRJbogy; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="svRJbogy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=X+mjigEnyGCW5I7Hm29e05FCuKbXFHKkUSHgp3w5jzo=; b=svRJbogyNwVF/FFM
	vvojn6UrSkfL4WoVjoD4V83itlhGCKjRV7rT/u+G+xdTtYgRB+zrKcxE5BB5cen+8AMbUBqaYCZK7
	shDBCDuhRp4XYLaQe/gf1c21nhNNtrbOZlR2lhe+Ye7lNmuDfxkgrSlUB2F4nByHU7SxQVMaUmhw/
	lbep2FU85voemxmzjE5WkzNdS7S5zLDC65uuiyHDP0KJ0EvUXwB0uCBLOss/JxMhRuUkmt9sXSVLs
	8FOfB13dSXZc3y/SqyI+odoqqAy4aSYw3d2mnboyJoMpub0mWhCZYkSvqyXYNet+cSzzGmI9n5RHp
	WaIAIlyVcTaez+sTTQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uBLvm-001GEx-10;
	Sat, 03 May 2025 23:06:02 +0000
From: linux@treblig.org
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: isci: Remove unused sci_remote_device_reset
Date: Sun,  4 May 2025 00:06:01 +0100
Message-ID: <20250503230601.124794-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

sci_remote_device_reset() last use was removed in 2012 by
commit 14aaa9f0a318 ("isci: Redesign device suspension, abort, cleanup.")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/isci/remote_device.c | 30 ------------------------------
 drivers/scsi/isci/remote_device.h | 15 ---------------
 2 files changed, 45 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 287e1ba8ddd7..82deb6a83a8c 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -392,36 +392,6 @@ enum sci_status sci_remote_device_stop(struct isci_remote_device *idev,
 	}
 }
 
-enum sci_status sci_remote_device_reset(struct isci_remote_device *idev)
-{
-	struct sci_base_state_machine *sm = &idev->sm;
-	enum sci_remote_device_states state = sm->current_state_id;
-
-	switch (state) {
-	case SCI_DEV_INITIAL:
-	case SCI_DEV_STOPPED:
-	case SCI_DEV_STARTING:
-	case SCI_SMP_DEV_IDLE:
-	case SCI_SMP_DEV_CMD:
-	case SCI_DEV_STOPPING:
-	case SCI_DEV_FAILED:
-	case SCI_DEV_RESETTING:
-	case SCI_DEV_FINAL:
-	default:
-		dev_warn(scirdev_to_dev(idev), "%s: in wrong state: %s\n",
-			 __func__, dev_state_name(state));
-		return SCI_FAILURE_INVALID_STATE;
-	case SCI_DEV_READY:
-	case SCI_STP_DEV_IDLE:
-	case SCI_STP_DEV_CMD:
-	case SCI_STP_DEV_NCQ:
-	case SCI_STP_DEV_NCQ_ERROR:
-	case SCI_STP_DEV_AWAIT_RESET:
-		sci_change_state(sm, SCI_DEV_RESETTING);
-		return SCI_SUCCESS;
-	}
-}
-
 enum sci_status sci_remote_device_frame_handler(struct isci_remote_device *idev,
 						     u32 frame_index)
 {
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 561ae3f2cbbd..c1fdf45751cd 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -159,21 +159,6 @@ enum sci_status sci_remote_device_stop(
 	struct isci_remote_device *idev,
 	u32 timeout);
 
-/**
- * sci_remote_device_reset() - This method will reset the device making it
- *    ready for operation. This method must be called anytime the device is
- *    reset either through a SMP phy control or a port hard reset request.
- * @remote_device: This parameter specifies the device to be reset.
- *
- * This method does not actually cause the device hardware to be reset. This
- * method resets the software object so that it will be operational after a
- * device hardware reset completes. An indication of whether the device reset
- * was accepted. SCI_SUCCESS This value is returned if the device reset is
- * started.
- */
-enum sci_status sci_remote_device_reset(
-	struct isci_remote_device *idev);
-
 /**
  * enum sci_remote_device_states - This enumeration depicts all the states
  *    for the common remote device state machine.
-- 
2.49.0

