Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DE53C13E2;
	Tue, 15 Sep 2026 20:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789503703; cv=none; b=EcAgIatiztqkU/qWauOR9N/ywKR5IFQztKR7i8ezw53rK2H2YrU1hnSuiSFL/Q2Am15CRBU9vCOC5smR6QlL2c/6klLqwzF8z1QNMnXjYNqv4iXTOzO91xIA6RDV7RTLqK63lCXCLEmMtb69Cy+LnQkGNzXPvtBKB9+Kpfx4rVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789503703; c=relaxed/simple;
	bh=d4cHkyzBorDxdLuNHMVNJsHYLKtpnFZH9bc+H+viVzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a+Ai0T58ZYwe3JV5KSoVfO4e6GiYdm+NeT6kN5km6ITrtsqMdFcxm/tayMKZdIaDb1AIKCtRuuQDQ4mG0gJvphzoob21F8mkAC32+mgieMqaZSIUkrvLbRhoHPQHhwpqyosVfHaAH5HH9JXPYljsYhHk0j+mdUoIcvQvppi7nzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyK+rrFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyK+rrFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C4F1F000FF;
	Tue, 15 Sep 2026 20:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789503700;
	bh=jQ6Ov4wSpBtQ9Okn7Njqhb3dcRxzrW0VZPRqzr1V4xU=;
	h=From:To:Cc:Subject:Date;
	b=nyK+rrFfpCUVkg90R/LhkanjZMn1gSJrtAF6p9fJ3ONFdLR9t2E2kDeGOrMw1zWGc
	 BzCrmB6UfHa520qc+d4Kz74HdC5R5HsquEK1dKq+l9OwClJB88IzAI/O7zieiwaNYi
	 bUV2rifbqoVRFINZjQuHykSyD+6DYp1poybnEvaZDZZcagIbiYziq7kpk7zXMbjHVs
	 +9WmcNJnMf2x2DkrjdpZ5CkPToq+SQwUbVUbEqJgAEt7MBDpVJKRf+AySefhv4QXZY
	 HtEyyKBQZiO3UY8RpFYaAi3XHXGD4u6OZSWdVj238I/aSFnOlfhq7Hgx1BvLmG4cpz
	 J011OvQadr9Qg==
From: Arnd Bergmann <arnd@kernel.org>
To: Dongdong Hao <doubled@leap-io-kernel.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: leapraid: avoid -Wformat-security warning
Date: Tue, 15 Sep 2026 22:20:59 +0200
Message-ID: <20260915202134.3534708-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

When extra warnings are enabled, the alloc_ordered_workqueue() function
cannot be called with a variable name for the format string:

drivers/scsi/leapraid/leapraid_os.c: In function 'leapraid_probe':
drivers/scsi/leapraid/leapraid_os.c:2062:58: error: format not a string literal and no format arguments [-Werror=format-security]
 2062 |                 alloc_ordered_workqueue(adapter->fw_evt_s.fw_evt_name, 0);
      |                                         ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~

As the string is only assembled before the call and not used anywhere
else, just fold the earlier snprintf() into the alloc_ordered_workqueue()
call.

Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/leapraid/leapraid_func.h | 2 --
 drivers/scsi/leapraid/leapraid_os.c   | 8 +++-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/leapraid/leapraid_func.h b/drivers/scsi/leapraid/leapraid_func.h
index 4c0b9ca728d8..e8a0815bf95f 100644
--- a/drivers/scsi/leapraid/leapraid_func.h
+++ b/drivers/scsi/leapraid/leapraid_func.h
@@ -554,7 +554,6 @@ struct leapraid_fw_evt_work {
 /**
  * struct leapraid_fw_evt_struct - Firmware event handling structure
  *
- * @fw_evt_name: Name of the firmware event.
  * @fw_evt_thread: Workqueue used for processing firmware events.
  * @fw_evt_lock: Spinlock protecting access to the firmware event list.
  * @fw_evt_list: Linked list of pending firmware events.
@@ -565,7 +564,6 @@ struct leapraid_fw_evt_work {
  */
 struct leapraid_fw_evt_struct {
 	u32 leapraid_evt_masks[4];
-	char fw_evt_name[48];
 	struct workqueue_struct *fw_evt_thread;
 	spinlock_t fw_evt_lock; /* protects firmware event */
 	struct list_head fw_evt_list;
diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
index ee3242779dfd..507f11862276 100644
--- a/drivers/scsi/leapraid/leapraid_os.c
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -2054,12 +2054,10 @@ static int leapraid_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->transportt = leapraid_transport_template;
 	shost->unique_id = adapter->adapter_attr.id;
 
-	snprintf(adapter->fw_evt_s.fw_evt_name,
-		 sizeof(adapter->fw_evt_s.fw_evt_name),
-		 "fw_event_%s%d", LEAPRAID_DRIVER_NAME,
-		 adapter->adapter_attr.id);
 	adapter->fw_evt_s.fw_evt_thread =
-		alloc_ordered_workqueue(adapter->fw_evt_s.fw_evt_name, 0);
+		alloc_ordered_workqueue("fw_event_%s%d", 0,
+					LEAPRAID_DRIVER_NAME,
+					adapter->adapter_attr.id);
 	if (!adapter->fw_evt_s.fw_evt_thread) {
 		dev_err(&adapter->pdev->dev,
 			"%s: Failed to create fw event workqueue\n", __func__);
-- 
2.53.0

