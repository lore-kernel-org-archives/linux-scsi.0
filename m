Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043416;
	b=GCmQfZjiUo3KBXnyuCYYfAv9zOl9Q39UeVMBzNf8veCI/24/IwLh+IdeywfVLNCPfMpe
	 7P8Mn7wHKjlT7rMJCIsztdVvIExPFpsIsA0PKD9dQC0a89lV/ty0Iu1vBIip45/MF4a4a
	 TRLfMQGgo3xakZjASDA/+Q+zCKn7yTsHPzKfnRjI6RJ4/64ea2V5r3Gw6uvmQHfS8cj0q
	 jzbPAgLM9HkizMSQ8Afo4TCHgDOZlsQKf+qLMNA/cr8Dt2/kSkQqH8HKS5jCDNGntHeEC
	 s1LwWFxnAu3yVa5ga0BCcSgcPvLdE2Gb1G07W18dn67a2ImNLPGyTJs22dkchmgoWlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043416;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=boO5d5s77FV+dvaykV27mt5dWo5+B7+6f5sJELJvj70=;
	b=wG0U2yyVkEpGhJcSguuv6xnI+n4rOXp9DU62CR9xYfdrbTlIAE5ixd8Hyr/uF7HGsYBu
	 YfT1vQ2B1kUAhaUcUP9a28hhKmjF0TQxCiPVR9ugURE7ZcBCakWfBJLlidPY5Gs8sNwk/
	 0NyO+6JYXe+jK/yc2iUAuu9S7Rl4FxNZMaZzv/GSEZUKMvNojb3lHwzLF7fy5oANAtXJz
	 cjrUv4lvbR5GFsmxOuB/4aqNsaXLklsZiD/L42AAaNl9vhpWGow+pS1v+l8encFT2XdI/
	 Sy3J17D6g6hM4y3fdbDP6+7k6iybePHD7c59RLqLNVZffOfMq+oj6DpPk5drSh5vY4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAKtQZ8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A4F606A33E;
	Wed, 18 Nov 2026 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAKtQZ8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4401F0092C;
	Wed, 18 Nov 2026 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043416;
	bh=boO5d5s77FV+dvaykV27mt5dWo5+B7+6f5sJELJvj70=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aAKtQZ8oW+rsiGebDQhpKuzKud7rcxbKCd3v8uCgueYAsvq2WrTCwi4Dj+ISCsIAC
	 9BltMKRMuTZTPQe7BBwWN6W8tptGAcPB6OC3ukuk4hT+p9YzVpAamMoHs3QaY17S66
	 lWNC+WIJYk2QQ/45jLtSXFiUggs1CxXWYukD+TtgEfw/qg8rghqJyzbbGjuOj5cC7o
	 Ehl1ZiVUH5Aa8n3C2XIzC2FTR1tRA4Bjv8WCFyegcDXhpk10cSJbKV6QVveJG1Syox
	 UHHwtMnaO8Kpoi1GsggMkUUsieH24Gc5cIrwrvbS74hXHy08kv7TjvNqUk5gVqt0xX
	 9vdEQUXJfKq8Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:07 -0800
Subject: [PATCH v3 10/11] scsi: mpt3sas: Don't use freed hostdata while
 polling devices
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-sas-abba-v3-10-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=15745; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=bNN806C8kzm7diKztjqnc3gkBTfWLLQfPvgUG95Fs6Y=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBS+uGTKWyl9HosKkjNgDJcYK92Lmx7SijdO
 7Hg8Hr1T46JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUgAKCRAADmhBGVaC
 FSBBEAC4shN2KURmf9MntxgTGov8UteAWJiIvslCpLkLbX6IN+Rn/H5ZEXvxgshZAtCMVyEJX0P
 Zz+Nj61hvpF5JTN2je6wwvRhrGuh4QhKLLs0eXAF4/JxMHdsRCowAsxrvXf1SsRkwZhAFFKzA39
 4xVwe/Egyna4OxiNaFDD5MUP/ilKPTSNuiK7QW7iRch4FiRsZORyDQjuhHoL4D4p/F9NMMJg3y4
 dC8zLJ5imDFi4e+GWkx4o2q8A7xCAtXftVGdKbKvLN9SOMi26WbvrT7u/2fWnRWq9OcQtQSLThv
 9F4mwX52t0CVCI1diaNd9vyzyXHWh5dYh9aWb4Uo5FZwIw1W/AQoXBBlhe+eeBXTRcuQ3jx+7tN
 u1ojLOYODCpHmN+xKWio7a0nB+mJWy1x/L24ZWijE4Lf4H19r2E1dd7We41o1GuJwMq2xwJZ4l9
 bw1cC3qX0uCwgSWY5zXEQz5Q8sw2+NsbW99FHog0ZvPtAazE8ZXz8vvW4Y+A8ttPyjlZf6Fottb
 MgG8nJYhDOlcHE9AR1xBXpJNM3/T1NzZKRg08dl+PCeC7b6u9V8DZkIpx8Wn1agoEzt7ygTV02j
 HsFPR9EiJv1M6xVQ3yZP7eF/ZkHavvj/IJGcRVHde/Ujod9dnFp9oaAKZCx52ICNNmuv9B4btPO
 Zj9jZVAedZVPu5A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

_scsih_ublock_io_all_device() and _scsih_ublock_io_device_wait() send
TURs to each blocked sdev until it is ready, for up to
command_retry_count rounds. They sleep between retries. They read
sdev->hostdata and its sas_target once. Then they use both during
polling and after it.

The sdev reference pins only the scsi_device. __scsi_remove_device()
can call ->sdev_destroy() during this time. For example, this occurs
when a scan fails to probe a new LUN, or when the device is deleted
through sysfs. ->sdev_destroy() frees the hostdata. If the sdev was the
last LUN, scsi_target_reap() then frees the hostdata of the target.
Thus the worker reads and writes freed memory.

Before each TUR, read the handle and the target flags under block_lock.
If the hostdata is gone, stop polling. Do the final unblock under the
lock, and only if the hostdata is unchanged. Copy the target fields
that the offline logging needs. Take block_lock in the other
worker-side walkers that block or unblock sdevs too.

Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and readiness handling for slow devices")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 210 ++++++++++++++++++++++++++++-------
 2 files changed, 173 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 419fdf164fc6..f5e1edf1a280 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1249,7 +1249,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @pcie_device_list: pcie device object list
  * @pcie_device_init_list: pcie device object list (used only at init time)
  * @pcie_device_lock:
- * @block_lock: serializes sdev blocking against sdev hostdata teardown
+ * @block_lock: serializes sdev blocking and unblocking against sdev
+ *	hostdata teardown
  * @io_missing_delay: time for IO completed by fw when PDR enabled
  * @device_missing_delay: time for device missing by fw when PDR enabled
  * @sas_id : used for setting volume target IDs
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 09dfa3124ebf..814c18289cf1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4066,6 +4066,99 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	}
 }
 
+/*
+ * Target fields the firmware event worker uses while it polls a device
+ * without holding block_lock.
+ */
+struct _scsih_target_ids {
+	u64 sas_address;
+	struct hba_port *port;
+	u16 handle;
+	u8 raid_component;
+};
+
+/*
+ * Copy the target fields of @sdev into @ids, if @sas_device_priv_data is
+ * still its hostdata.  The caller holds block_lock.
+ */
+static bool
+__scsih_get_target_ids(struct scsi_device *sdev,
+		       struct MPT3SAS_DEVICE *sas_device_priv_data,
+		       struct _scsih_target_ids *ids)
+{
+	struct MPT3SAS_TARGET *sas_target;
+
+	if (sdev->hostdata != sas_device_priv_data)
+		return false;
+	sas_target = sas_device_priv_data->sas_target;
+	ids->sas_address = sas_target->sas_address;
+	ids->port = sas_target->port;
+	ids->handle = sas_target->handle;
+	ids->raid_component =
+	    !!(sas_target->flags & MPT_TARGET_FLAGS_RAID_COMPONENT);
+	return true;
+}
+
+/**
+ * _scsih_get_target_ids - read the target fields of a polled device
+ * @ioc: per adapter object
+ * @sdev: scsi device struct
+ * @sas_device_priv_data: hostdata of @sdev when polling began
+ * @ids: filled in with the target fields
+ *
+ * A host reset can change the handle while the device is polled, so
+ * the handle is read again before each command.
+ *
+ * Return: false if @sdev lost its hostdata, true otherwise.
+ */
+static bool
+_scsih_get_target_ids(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
+		      struct MPT3SAS_DEVICE *sas_device_priv_data,
+		      struct _scsih_target_ids *ids)
+{
+	unsigned long flags;
+	bool live;
+
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	live = __scsih_get_target_ids(sdev, sas_device_priv_data, ids);
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+	return live;
+}
+
+/**
+ * _scsih_end_poll - unblock a device after polling it
+ * @ioc: per adapter object
+ * @sdev: scsi device struct
+ * @sas_device_priv_data: hostdata of @sdev when polling began
+ * @ready: the device passed the readiness check
+ * @ids: filled in with the target fields, if true is returned
+ *
+ * Unblock @sdev, and mark it deleted if it is not @ready.  Nothing is
+ * done if @sdev lost its hostdata while it was polled.
+ *
+ * Return: true if the caller should act on @ready, false otherwise.
+ */
+static bool
+_scsih_end_poll(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
+		struct MPT3SAS_DEVICE *sas_device_priv_data,
+		bool ready, struct _scsih_target_ids *ids)
+{
+	unsigned long flags;
+	bool ret = false;
+
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	if (!__scsih_get_target_ids(sdev, sas_device_priv_data, ids))
+		goto out;
+	if (!ready)
+		sas_device_priv_data->deleted = 1;
+	if (sas_device_priv_data->block)
+		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+	ret = true;
+out:
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+	return ret;
+}
+
 /**
  * _scsih_unresponding_scan_cancelled - should polling devices stop
  * @ioc: per adapter object
@@ -4098,10 +4191,11 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 	enum device_responsive_state rc;
 	struct _sas_device *sas_device = NULL;
 	struct _pcie_device *pcie_device = NULL;
+	struct _scsih_target_ids ids;
 	int count;
 	u8 tr_method = 0;
 	u8 tr_timeout = 30;
-
+	unsigned long flags;
 
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
@@ -4116,23 +4210,40 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 			continue;
 
 		if ((no_turs) || (!issue_scsi_cmd_to_bringup_drive)) {
-			sdev_printk(KERN_WARNING, sdev, "device_unblocked handle(0x%04x)\n",
-				sas_device_priv_data->sas_target->handle);
-			_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+			spin_lock_irqsave(&ioc->block_lock, flags);
+			if (sdev->hostdata != sas_device_priv_data)
+				goto next;
+			if (sas_device_priv_data->block) {
+				sdev_printk(KERN_WARNING, sdev,
+				    "device_unblocked handle(0x%04x)\n",
+				    sas_target->handle);
+				_scsih_internal_device_unblock(sdev,
+				    sas_device_priv_data);
+			}
+next:
+			spin_unlock_irqrestore(&ioc->block_lock, flags);
 			continue;
 		}
 
+		/*
+		 * Polling can take minutes, and sdev_destroy() and
+		 * scsi_target_reap() can free the hostdata meanwhile.
+		 */
+		rc = DEVICE_ERROR;
 		count = 0;
 		do {
-			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
+			if (!_scsih_get_target_ids(ioc, sdev,
+			    sas_device_priv_data, &ids))
+				break;
+			pcie_device = mpt3sas_get_pdev_by_handle(ioc, ids.handle);
 			if (pcie_device && (!ioc->tm_custom_handling) &&
 				(!(mpt3sas_scsih_is_pcie_scsi_device(pcie_device->device_info)))) {
 				tr_timeout = pcie_device->reset_timeout;
 				tr_method = MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE;
 			}
 			rc = _scsih_wait_for_device_to_become_ready(ioc,
-			    sas_target->handle, 0, (sas_target->flags &
-			    MPT_TARGET_FLAGS_RAID_COMPONENT), sdev->lun, tr_timeout, tr_method);
+			    ids.handle, 0, ids.raid_component, sdev->lun,
+			    tr_timeout, tr_method);
 			if (rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
 			    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
 				ssleep(1);
@@ -4147,26 +4258,23 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 			scsi_device_put(sdev);
 			return;
 		}
-		sas_device_priv_data->block = 0;
-		if (rc != DEVICE_READY)
-			sas_device_priv_data->deleted = 1;
-
-		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+		if (!_scsih_end_poll(ioc, sdev, sas_device_priv_data,
+		    rc == DEVICE_READY, &ids))
+			continue;
 
 		if (rc != DEVICE_READY) {
 			sdev_printk(KERN_WARNING, sdev, "%s: device_offlined,\n"
 			    "handle(0x%04x)\n",
-			    __func__, sas_device_priv_data->sas_target->handle);
+			    __func__, ids.handle);
 			scsi_device_set_state(sdev, SDEV_OFFLINE);
 			sas_device = mpt3sas_get_sdev_by_addr(ioc,
-					sas_device_priv_data->sas_target->sas_address,
-					sas_device_priv_data->sas_target->port);
+					ids.sas_address, ids.port);
 			if (sas_device) {
 				_scsih_display_enclosure_chassis_info(NULL, sas_device, sdev, NULL);
 				sas_device_put(sas_device);
 			} else {
 				pcie_device = mpt3sas_get_pdev_by_wwid(ioc,
-						    sas_device_priv_data->sas_target->sas_address);
+						    ids.sas_address);
 				if (pcie_device) {
 					if (pcie_device->enclosure_handle != 0)
 						sdev_printk(KERN_INFO, sdev, "enclosure logical id\n"
@@ -4184,7 +4292,7 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 		} else
 			sdev_printk(KERN_WARNING, sdev, "device_unblocked,\n"
 			    "handle(0x%04x)\n",
-			    sas_device_priv_data->sas_target->handle);
+			    ids.handle);
 	}
 }
 
@@ -4207,27 +4315,32 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	int host_reset_completion_count;
 	struct _sas_device *sas_device;
 	struct _pcie_device *pcie_device;
+	struct _scsih_target_ids ids;
 	u8 tr_timeout = 30;
 	u8 tr_method = 0;
 	int count;
+	unsigned long flags;
 
 	/* moving devices from SDEV_OFFLINE to SDEV_BLOCK */
 	shost_for_each_device(sdev, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
-			continue;
+			goto next;
 		sas_target = sas_device_priv_data->sas_target;
 		if (!sas_target)
-			continue;
+			goto next;
 		if (sas_target->sas_address != sas_address ||
 		    sas_target->port != port)
-			continue;
+			goto next;
 		if (sdev->sdev_state == SDEV_OFFLINE) {
 			sas_device_priv_data->block = 1;
 			sas_device_priv_data->deleted = 0;
 			scsi_device_set_state(sdev, SDEV_RUNNING);
 			scsi_internal_device_block_nowait(sdev);
 		}
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 
 	/* moving devices from SDEV_BLOCK to SDEV_RUNNING state */
@@ -4244,10 +4357,18 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		if (!sas_device_priv_data->block)
 			continue;
 
+		/*
+		 * Polling can take minutes, and sdev_destroy() and
+		 * scsi_target_reap() can free the hostdata meanwhile.
+		 */
+		rc = DEVICE_ERROR;
 		count = 0;
 		do {
 			host_reset_completion_count = 0;
-			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
+			if (!_scsih_get_target_ids(ioc, sdev,
+			    sas_device_priv_data, &ids))
+				break;
+			pcie_device = mpt3sas_get_pdev_by_handle(ioc, ids.handle);
 			if (pcie_device && (!ioc->tm_custom_handling) &&
 				(!(mpt3sas_scsih_is_pcie_scsi_device(pcie_device->device_info)))) {
 				tr_timeout = pcie_device->reset_timeout;
@@ -4256,8 +4377,8 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 			if (pcie_device)
 				pcie_device_put(pcie_device);
 			rc = _scsih_wait_for_device_to_become_ready(ioc,
-			      sas_target->handle, 0, (sas_target->flags &
-			      MPT_TARGET_FLAGS_RAID_COMPONENT), sdev->lun, tr_timeout, tr_method);
+			      ids.handle, 0, ids.raid_component, sdev->lun,
+			      tr_timeout, tr_method);
 			if (rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
 			    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA) {
 				do {
@@ -4266,10 +4387,13 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 				} while (rc == DEVICE_RETRY &&
 							ioc->shost_recovery);
 				if (host_reset_completion_count > 1) {
+					/* the reset may have changed the handle */
+					if (!_scsih_get_target_ids(ioc, sdev,
+					    sas_device_priv_data, &ids))
+						break;
 					rc = _scsih_wait_for_device_to_become_ready(ioc,
-						sas_target->handle, 0, (sas_target->flags &
-						MPT_TARGET_FLAGS_RAID_COMPONENT), sdev->lun,
-						tr_timeout, tr_method);
+						ids.handle, 0, ids.raid_component,
+						sdev->lun, tr_timeout, tr_method);
 					if (rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
 					    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
 						msleep(500);
@@ -4280,23 +4404,23 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
 			&& count++ <= command_retry_count);
 
-		if (rc != DEVICE_READY)
-			sas_device_priv_data->deleted = 1;
-		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+		if (!_scsih_end_poll(ioc, sdev, sas_device_priv_data,
+		    rc == DEVICE_READY, &ids))
+			continue;
 
 		if (rc != DEVICE_READY) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "%s: device_offlined, handle(0x%04x)\n",
-			    __func__, sas_device_priv_data->sas_target->handle);
+			    __func__, ids.handle);
 
 			sas_device = mpt3sas_get_sdev_by_handle(ioc,
-				sas_device_priv_data->sas_target->handle);
+				ids.handle);
 			if (sas_device) {
 				_scsih_display_enclosure_chassis_info(NULL, sas_device, sdev, NULL);
 				sas_device_put(sas_device);
 			} else {
 				pcie_device = mpt3sas_get_pdev_by_handle(ioc,
-							sas_device_priv_data->sas_target->handle);
+							ids.handle);
 				if (pcie_device) {
 					if (pcie_device->enclosure_handle != 0)
 						sdev_printk(KERN_INFO, sdev,
@@ -4317,7 +4441,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		} else {
 			sdev_printk(KERN_WARNING, sdev,
 				"device_unblocked, handle(0x%04x)\n",
-				sas_device_priv_data->sas_target->handle);
+				ids.handle);
 		}
 	}
 }
@@ -4336,19 +4460,23 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
+	unsigned long flags;
 
 	shost_for_each_device(sdev, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
-			continue;
+			goto next;
 		if (sas_device_priv_data->sas_target->sas_address
 		    != sas_address)
-			continue;
+			goto next;
 		if (sas_device_priv_data->sas_target->port != port)
-			continue;
+			goto next;
 		if (sas_device_priv_data->block)
 			_scsih_internal_device_unblock(sdev,
 				sas_device_priv_data);
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 }
 
@@ -4363,20 +4491,24 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
+	unsigned long flags;
 
 	shost_for_each_device(sdev, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
-			continue;
+			goto next;
 		if (sas_device_priv_data->block)
-			continue;
+			goto next;
 		if (sas_device_priv_data->ignore_delay_remove) {
 			sdev_printk(KERN_INFO, sdev,
 			"%s skip device_block for SES handle(0x%04x)\n",
 			__func__, sas_device_priv_data->sas_target->handle);
-			continue;
+			goto next;
 		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 }
 

-- 
2.56.1

