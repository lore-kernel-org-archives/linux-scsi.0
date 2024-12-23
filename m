Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AF3383;
	Mon, 23 Dec 2024 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734976947; cv=none; b=ibGe9gWM4QUHYf9f0+18aaO7Ez1myObbb1CrYawratmE6O0lnsj74w1PfHPlmhgYXRiH/u1SVTwZ4VSAHXIbqX3+fBM+I38RmnsSJCfm/b/0kAECKtRvjQUKUgTWyoji+QCCI+DWivL0pPzSAaGcZZsXDJiqfuaA860tnU1WhpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734976947; c=relaxed/simple;
	bh=na9wOzSW9tyu1Z50w4SPbOyxFQ9tLbEOICTi9NJ33H4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=efUxAfqW5TtX6ojN6I67B5JMF+f7+7vxuKfT1y52g/wzFzfQfo/hd5SEQqwIh5ZkLHj5C2O/UCbfJMaqkdeXFfjHaACsvu2HnIsnC14z5JMc6PKpOwKmMViHSRcFiPfzbq5HCFc9KaI4zeb2jCRxwKFUjA2qYbY+pLjCox74AdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Lo9gT0zQ; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Lo9gT0zQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=mYLR/nRGp3vsWfYF7ZNHDlKfDT7umynGc7DcJRFwp2s=; b=Lo9gT0zQfgDddwBA
	ZB8fIrgiyQkShxlYBkgIGscFbziQkkhTMpB+fgwEPQYy1sZfCDzGTr0rsViI/H5+5c7wLwoF4iWwY
	WNHs8egBhsSqwY1N7oCxUqN6GKHS2ymLXNJ2UkjfKHKsSrJ1e+T4Fkw3fAqSXFUrSg8yZF2umBNVN
	x+KfFZ9U0nYkzgUcHXEdw/llNJ1lI1BcLQzLUxyjf3va2xDHj3n+CfNrhkw6a2MnwfF2glfhjl7Rp
	xAkrKzr9QovbRjUkkfqx4Kc/PG2btFb2Xcz44dFwpdQRCp7/rSVPkch9M4+I+yy71UwB8H8uqSGid
	HmNtf+uyTiptGUaFuw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tPml1-006uHQ-1c;
	Mon, 23 Dec 2024 18:02:19 +0000
From: linux@treblig.org
To: artur.paszkiewicz@intel.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: isci: remote_device: Remove unused isci_remote_device_reset_complete
Date: Mon, 23 Dec 2024 18:02:18 +0000
Message-ID: <20241223180218.50426-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

isci_remote_device_reset_complete() last use was removed in 2012 by
commit 14aaa9f0a318 ("isci: Redesign device suspension, abort, cleanup.")

Remove it.

It was the last user of sci_remote_device_reset_complete().

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/isci/remote_device.c | 29 -----------------------------
 drivers/scsi/isci/remote_device.h | 17 -----------------
 2 files changed, 46 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 866950a02965..287e1ba8ddd7 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -422,21 +422,6 @@ enum sci_status sci_remote_device_reset(struct isci_remote_device *idev)
 	}
 }
 
-enum sci_status sci_remote_device_reset_complete(struct isci_remote_device *idev)
-{
-	struct sci_base_state_machine *sm = &idev->sm;
-	enum sci_remote_device_states state = sm->current_state_id;
-
-	if (state != SCI_DEV_RESETTING) {
-		dev_warn(scirdev_to_dev(idev), "%s: in wrong state: %s\n",
-			 __func__, dev_state_name(state));
-		return SCI_FAILURE_INVALID_STATE;
-	}
-
-	sci_change_state(sm, SCI_DEV_READY);
-	return SCI_SUCCESS;
-}
-
 enum sci_status sci_remote_device_frame_handler(struct isci_remote_device *idev,
 						     u32 frame_index)
 {
@@ -1694,20 +1679,6 @@ enum sci_status sci_remote_device_abort_requests_pending_abort(
 	return sci_remote_device_terminate_reqs_checkabort(idev, 1);
 }
 
-enum sci_status isci_remote_device_reset_complete(
-	struct isci_host *ihost,
-	struct isci_remote_device *idev)
-{
-	unsigned long flags;
-	enum sci_status status;
-
-	spin_lock_irqsave(&ihost->scic_lock, flags);
-	status = sci_remote_device_reset_complete(idev);
-	spin_unlock_irqrestore(&ihost->scic_lock, flags);
-
-	return status;
-}
-
 void isci_dev_set_hang_detection_timeout(
 	struct isci_remote_device *idev,
 	u32 timeout)
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 3ad681c4c20a..27ae45332704 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -174,19 +174,6 @@ enum sci_status sci_remote_device_stop(
 enum sci_status sci_remote_device_reset(
 	struct isci_remote_device *idev);
 
-/**
- * sci_remote_device_reset_complete() - This method informs the device object
- *    that the reset operation is complete and the device can resume operation
- *    again.
- * @remote_device: This parameter specifies the device which is to be informed
- *    of the reset complete operation.
- *
- * An indication that the device is resuming operation. SCI_SUCCESS the device
- * is resuming operation.
- */
-enum sci_status sci_remote_device_reset_complete(
-	struct isci_remote_device *idev);
-
 /**
  * enum sci_remote_device_states - This enumeration depicts all the states
  *    for the common remote device state machine.
@@ -364,10 +351,6 @@ enum sci_status isci_remote_device_reset(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev);
 
-enum sci_status isci_remote_device_reset_complete(
-	struct isci_host *ihost,
-	struct isci_remote_device *idev);
-
 enum sci_status isci_remote_device_suspend_terminate(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev,
-- 
2.47.1

