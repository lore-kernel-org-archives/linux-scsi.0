Received: from mail-oi1-f226.google.com (mail-oi1-f226.google.com [209.85.167.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B848A2F6582
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 15:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048603; cv=none; b=BTo168Q6N93nksi2s4F0CowHpryFJ18NcxwtA1A+SKWA4f01Lx8cO2UaRI/Z1mZykj9kYpc2Vb8JoIcJbYLFTNEDJE6be4Yo9VbwaCbWpvYP3bZvhpjvo7X9nJPf18Isvc2lMuKY8xfE7cg0Wk0xzaEHz5i0lB8BGxe4wa+ODdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048603; c=relaxed/simple;
	bh=0lZxGig/u4aDAAxeS1gzyLbxUtemR//Z/cbVCDEeyhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvqq/qbCtxEfdyQ2UuRO1cCGrIxQrK/P3RZ9a+DPCqh3w3MioVKgwgjCkFT+wmkemqVfBOUKMK+wswHlFyKCeiJ9wWlUHX52MwdJkp0ZgHkpCPgVcPwBoG/fDG/cBTgNfen8lCkmFS87kQZhpHZvwlEucluUifXGWap800jmERs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=IbmDluUW; arc=none smtp.client-ip=209.85.167.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IbmDluUW"
Received: by mail-oi1-f226.google.com with SMTP id 5614622812f47-44fe903c1d6so146387b6e.0
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048601; x=1763653401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9ZyuE00BmfqIDnv0pbQWYQskMU/drRf8dla4Ypggvo=;
        b=Tw0rlbX+70JOnzOWih3XiLKKGdYtcqDRIBOx8Q4SGN0POSw3Ktob4xPmbZ2mFItRm1
         tnUYvf6W47K8ipNL6AMUPiXI1ZwPd4C+RjGp/RftdPwF1+eq4b4c7dS8n3eAkcuLv6+z
         sE9+Q4o/bVK8OVFmncJuhsO/OLBO6tspCGi0eH/W6w4VavnE+NS+z+lBqNv4RzuKtBFm
         tSv6B8QnFSbOycqKJNDvQdTsJuL5VR+5tHiL9uqrGR5ZDo1nEXeVSaayhmDOU8J5enOX
         l3+hDHQl1NFOPwtXVB8EYAWoHZgD/1rwQ+FgRfBv9PrbpHcaNwaDBKUHn6xsx9GHHKRO
         Xc5A==
X-Gm-Message-State: AOJu0YwxrTJx9B5BEbm8asUxgdI+j8TyrbtMUOxhsDyZNFFk5Y5BNRqZ
	yTWacQiB6oTkeBFbZqY/K2uSY5VovgiDSxqiKmb6e8LI6bq+BG61FZ2484VOjPXU8Tj83WKbRim
	9yUJJVsnDYnS8IXyfYbz9MTHgaV3jGkfjrWV0u2fS2u6esNOBGzJ0v75PWAzGbooOk6eefwBcIh
	Dr9k1FweyJu5S9qQlf5pdYPOVdF4HrZSlc77R+W13zhz+54z8AQreJP69wmlHIsuVSNtU/p3tqP
	rRp39j6hkhjgfcu
X-Gm-Gg: ASbGnctJfyqVCDc6bO4FyvSMQ8fpAwXJD2rQ25O3Zh4OtNRF/iu2fcAdp43mLdhvMHo
	EpKLxkVQsadnUe1ONXBcITbHdmjgD8FwBOYk83AwjNEjUMaGIKhbMWcQabBuA8/xl3ukB1VfUjV
	c0JH/QlXD94SlL9k4P0gIsNREOTklR94aNw59JJZaQY7gvN4Jv5E86CzMXxND2XMuu4S8wlsjUv
	sQ8Nytom5az7oZ7dm+4nACRvkgGFFVwJcaU70zwDrtgKcVxmFbNfm0mFJWCXez6dePxRp/9iYzo
	A65NaXncKMBts0YC0CiD08uJrM/UotjtqxQ7//PWdCWnwmgGVRDPv3Hvss0ygLpi8XDQadW539J
	3MTnmWBiZQLEn8PmAF7dMZsmEnreXlHgiq9B30gY5v/xVEQaCKH8oKzyMRzPkdPoyxYJWC9lT0r
	yu7mvIDrbgnuQj3Qj+xC2jyAYL2Qyma4poFA==
X-Google-Smtp-Source: AGHT+IE41PCqrV/P48ZQuAnlgbVAYdtF/MY5pElRIokXeVhxWVZMnLNOvmXy5NcHzz3vw01fHY/XqOr/uFaN
X-Received: by 2002:a05:6808:1508:b0:441:896c:fab7 with SMTP id 5614622812f47-45074409f29mr3508783b6e.9.1763048600526;
        Thu, 13 Nov 2025 07:43:20 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-14.dlp.protect.broadcom.com. [144.49.247.14])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-3e8522f7a2esm185844fac.21.2025.11.13.07.43.20
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2025 07:43:20 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-297f3710070so26460225ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1763048598; x=1763653398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9ZyuE00BmfqIDnv0pbQWYQskMU/drRf8dla4Ypggvo=;
        b=IbmDluUW6tjgEaMJhhZv04SFLBBb0wKYdnvZWETq0oy3/UrJl4PdVcSodVTeicWADT
         x2PZjD8pY9CJD9xpyT8MeI8HKk2fGB2TZJGhhd5op1YJlJRseK7ApI9FgIYCszGo6OfC
         tJgiRLAVTU75pTXty07WsN7UdM3QblI8j+eQI=
X-Received: by 2002:a17:902:fc87:b0:293:e5f:85b7 with SMTP id d9443c01a7336-2984ed34013mr110058805ad.11.1763048598295;
        Thu, 13 Nov 2025 07:43:18 -0800 (PST)
X-Received: by 2002:a17:902:fc87:b0:293:e5f:85b7 with SMTP id d9443c01a7336-2984ed34013mr110058385ad.11.1763048597538;
        Thu, 13 Nov 2025 07:43:17 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2cca66sm29100085ad.99.2025.11.13.07.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:43:16 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2 4/6] mpt3sas: Add firmware event requeue support for busy devices
Date: Thu, 13 Nov 2025 21:07:08 +0530
Message-ID: <20251113153712.31850-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
References: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add support to requeue SAS/PCIe topology change events when devices
are busy or not ready. Introduce delayed work with retry counters so
events are retried instead of dropped, improving device discovery by
retrying transient failures instead of dropping events.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510311720.NiDwRLwp-lkp@intel.com/
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 130 +++++++++++++++++++++++----
 1 file changed, 112 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 3eb6c51ac91e..eb04ca5e0043 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -89,6 +89,7 @@ _scsih_ata_pass_thru_idd(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 *is_ssd_dev
 static enum device_responsive_state
 _scsih_wait_for_device_to_become_ready(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	u8 retry_count, u8 is_pd, int lun, u8 tr_timeout, u8 tr_method);
+static void _firmware_event_work_delayed(struct work_struct *work);
 
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
@@ -275,11 +276,16 @@ struct fw_event_work {
 	u16			event;
 	struct kref		refcount;
 	char			event_data[] __aligned(4);
+
 };
 
 static void fw_event_work_free(struct kref *r)
 {
-	kfree(container_of(r, struct fw_event_work, refcount));
+	struct fw_event_work *fw_work;
+
+	fw_work = container_of(r, struct fw_event_work, refcount);
+	kfree(fw_work->retries);
+	kfree(fw_work);
 }
 
 static void fw_event_work_get(struct fw_event_work *fw_work)
@@ -3651,6 +3657,37 @@ _scsih_fw_event_del_from_list(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
+/**
+ * _scsih_fw_event_requeue - requeue an event
+ * @ioc: per adapter object
+ * @fw_event: object describing the event
+ * @delay: time in milliseconds to wait before retrying the event
+ *
+ * Context: This function will acquire ioc->fw_event_lock.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_fw_event_requeue(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
+	*fw_event, unsigned long delay)
+{
+	unsigned long flags;
+
+	if (ioc->firmware_event_thread == NULL)
+		return;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	fw_event_work_get(fw_event);
+	list_add_tail(&fw_event->list, &ioc->fw_event_list);
+	if (!fw_event->delayed_work_active) {
+		fw_event->delayed_work_active = 1;
+		INIT_DELAYED_WORK(&fw_event->delayed_work,
+		    _firmware_event_work_delayed);
+	}
+	queue_delayed_work(ioc->firmware_event_thread, &fw_event->delayed_work,
+	    msecs_to_jiffies(delay));
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
 
  /**
  * mpt3sas_send_trigger_data_event - send event for processing trigger data
@@ -8589,6 +8626,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 {
 	int i;
 	int rc;
+	int requeue_event;
 	u16 parent_handle, handle;
 	u16 reason_code;
 	u8 phy_number, max_phys;
@@ -8643,7 +8681,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 
 	/* handle siblings events */
-	for (i = 0; i < event_data->NumEntries; i++) {
+	for (i = 0, requeue_event = 0; i < event_data->NumEntries; i++) {
 		if (fw_event->ignore) {
 			dewtprintk(ioc,
 				   ioc_info(ioc, "ignoring expander event\n"));
@@ -8663,7 +8701,14 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 		if (fw_event->delayed_work_active && (reason_code ==
 		    MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING)) {
 			dewtprintk(ioc, ioc_info(ioc, "ignoring\n"
-			    "Targ not responding event phy in re-queued event processing\n"));
+			    "Target not responding event phy in re-queued event processing\n"));
+			continue;
+		}
+
+		if (fw_event->delayed_work_active && (reason_code ==
+		    MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING)) {
+			dewtprintk(ioc, ioc_info(ioc, "ignoring Target not responding\n"
+						"event phy in re-queued event processing\n"));
 			continue;
 		}
 
@@ -8714,7 +8759,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 			    "event to a device add\n", handle));
 			event_data->PHY[i].PhyStatus &= 0xF0;
 			event_data->PHY[i].PhyStatus |=
-			    MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED;
+						MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED;
 
 			fallthrough;
 
@@ -8731,11 +8776,13 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 
 			rc = _scsih_add_device(ioc, handle,
 			    fw_event->retries[i], 0);
-			if (rc) /* retry due to busy device */
+			if (rc) {/* retry due to busy device */
 				fw_event->retries[i]++;
-			else  /* mark entry vacant */
+				requeue_event = 1;
+			} else {/* mark entry vacant */
 				event_data->PHY[i].PhyStatus |=
-						MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT;
+			    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT;
+			}
 
 			break;
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING:
@@ -8750,7 +8797,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	    sas_expander)
 		mpt3sas_expander_remove(ioc, sas_address, port);
 
-	return 0;
+	return requeue_event;
 }
 
 /**
@@ -9428,7 +9475,7 @@ _scsih_pcie_topology_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
  * Context: user.
  *
  */
-static void
+static int
 _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
@@ -9438,6 +9485,7 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	u8 link_rate, prev_link_rate;
 	unsigned long flags;
 	int rc;
+	int requeue_event;
 	Mpi26EventDataPCIeTopologyChangeList_t *event_data =
 		(Mpi26EventDataPCIeTopologyChangeList_t *) fw_event->event_data;
 	struct _pcie_device *pcie_device;
@@ -9447,22 +9495,22 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 
 	if (ioc->shost_recovery || ioc->remove_host ||
 		ioc->pci_error_recovery)
-		return;
+		return 0;
 
 	if (fw_event->ignore) {
 		dewtprintk(ioc, ioc_info(ioc, "ignoring switch event\n"));
-		return;
+		return 0;
 	}
 
 	/* handle siblings events */
-	for (i = 0 ; i < event_data->NumEntries; i++) {
+	for (i = 0, requeue_event = 0; i < event_data->NumEntries; i++) {
 		if (fw_event->ignore) {
 			dewtprintk(ioc,
 				   ioc_info(ioc, "ignoring switch event\n"));
-			return;
+			return 0;
 		}
 		if (ioc->remove_host || ioc->pci_error_recovery)
-			return;
+			return 0;
 		reason_code = event_data->PortEntry[i].PortStatus;
 		handle =
 			le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
@@ -9518,8 +9566,8 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 
 			rc = _scsih_pcie_add_device(ioc, handle, fw_event->retries[i]);
 			if (rc) {/* retry due to busy device */
-
 				fw_event->retries[i]++;
+				requeue_event = 1;
 			} else {
 				/* mark entry vacant */
 				/* TODO This needs to be reviewed and fixed,
@@ -9535,11 +9583,12 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 			break;
 		}
 	}
+	return requeue_event;
 }
 
 /**
  * _scsih_pcie_device_status_change_event_debug - debug for device event
- * @ioc: ?
+ * @ioc: per adapter object
  * @event_data: event data payload
  * Context: user.
  */
@@ -11870,7 +11919,11 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		_scsih_turn_on_pfa_led(ioc, fw_event->device_handle);
 		break;
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
-		_scsih_sas_topology_change_event(ioc, fw_event);
+		if (_scsih_sas_topology_change_event(ioc, fw_event)) {
+			_scsih_fw_event_requeue(ioc, fw_event, 1000);
+			ioc->current_event = NULL;
+			return;
+		}
 		break;
 	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
 		if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
@@ -11910,7 +11963,11 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		_scsih_pcie_enumeration_event(ioc, fw_event);
 		break;
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
-		_scsih_pcie_topology_change_event(ioc, fw_event);
+		if (_scsih_pcie_topology_change_event(ioc, fw_event)) {
+			_scsih_fw_event_requeue(ioc, fw_event, 1000);
+			ioc->current_event = NULL;
+			return;
+		}
 		break;
 	}
 out:
@@ -11935,6 +11992,15 @@ _firmware_event_work(struct work_struct *work)
 	_mpt3sas_fw_work(fw_event->ioc, fw_event);
 }
 
+static void
+_firmware_event_work_delayed(struct work_struct *work)
+{
+	struct fw_event_work *fw_event = container_of(work,
+	    struct fw_event_work, delayed_work.work);
+
+	_mpt3sas_fw_work(fw_event->ioc, fw_event);
+}
+
 /**
  * mpt3sas_scsih_event_callback - firmware event handler (called at ISR time)
  * @ioc: per adapter object
@@ -12115,6 +12181,34 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		return 1;
 	}
 
+	if (event == MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST) {
+		Mpi2EventDataSasTopologyChangeList_t *topo_event_data =
+		    (Mpi2EventDataSasTopologyChangeList_t *)
+		    mpi_reply->EventData;
+		fw_event->retries = kzalloc(topo_event_data->NumEntries,
+		    GFP_ATOMIC);
+		if (!fw_event->retries) {
+
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",  __FILE__, __LINE__, __func__);
+			kfree(fw_event->event_data);
+			fw_event_work_put(fw_event);
+			return 1;
+		}
+	}
+
+	if (event == MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST) {
+		Mpi26EventDataPCIeTopologyChangeList_t *topo_event_data =
+			(Mpi26EventDataPCIeTopologyChangeList_t *) mpi_reply->EventData;
+		fw_event->retries = kzalloc(topo_event_data->NumEntries,
+			GFP_ATOMIC);
+		if (!fw_event->retries) {
+
+			ioc_err(ioc, "failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__);
+			fw_event_work_put(fw_event);
+			return 1;
+		}
+	}
+
 	memcpy(fw_event->event_data, mpi_reply->EventData, sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
-- 
2.47.3

