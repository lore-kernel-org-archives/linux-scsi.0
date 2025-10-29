Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64444261588
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761761836; cv=none; b=MCVIgAMlf4KXcsKOoY133Wv0h46zZXJle8DIT3YRFxtptM1kcyum79qSYibkKiGrq95ir7snJFhRy6vh2sYMgSe2zXufM3TjSZ4Ri9jIJxnzz5pFiLe74EO3kwJQpDuhlTgPSP0VbQKnQugTAjwVx3Orjwrj1WEpbeymidUmNyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761761836; c=relaxed/simple;
	bh=6X1fT3RxyePidTRo2qpKsolxA1IUO7Vxp8b8iBplwmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nx4d7PfTucBuZkNrWb8Z5sF/jQ473MTlGP+s5zLBfIPA8iyWftoPg1RbWq0LaTT8DchAtaz/yckI3feqpnK+6WkTPCLzEzBvb5vu9AIyaOn2ylgXPTysZOu6b1gMtTuTHEEmYaVPGBeU27OsprYxaQJzy2lCLjXubfXLY3mle5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=VtvYvWah; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VtvYvWah"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-290ac2ef203so1317175ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761833; x=1762366633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aiT6EA/v9Bb74Nmc0KEcnrvlYiDeYQoMKxE7nTskVl8=;
        b=Tl5xPNq07nQf788oSQIPU0bU+2XK2OEAiZQMNMqQa4xw2RJxH4HH9f7CaKRHIw3yM0
         3fX4M7242iCGkNc7F5o4TzaNwVrv6fN1hiX9a6/nSfPGhh3YM/17PPknvN5zo66IN/GZ
         K0EsExtBkO2BbLW4gOZ4pTSCnr0KG/0KDknvhsG3tH2yhj2dxVsB6rOV/a+avzlcRuA0
         AEIYJLPZEH8ys/sa2TLCUKVmndJXGQR48/w9GP1MsxcUo/nm5Nasg78YfjJgNL0iV/za
         pvz/CniG8Yz3GtEjlk/etjB7LkrnubfOo6+gDHh34T+TEdTQxlDKicpKysJOoEr2k1vz
         bxWA==
X-Gm-Message-State: AOJu0Yz+QSdIBHc3LfZ90HNZGMbPU0Anh2CUWxSbY2JQLZTgfCj0lc3J
	fWHQLkkDFbkhEtANRAdGmT9IhLY+QbIGk8xwmQsOdayyNPEd+gnN394feRYx7DqhRCh5+Mu135A
	xv2uIS1U+eWyK8vlqobojSliNcuyQZnNPXBQvbbFm15ucMPtT1/F0S2trvWKZhqI0mxjeZxKF2t
	iVDvCvuafThQtfhEIIiuPGI8/K1CH7JfWhrViOwslYezlsaht69UAKIW14BzLqUbTP8WaensaLC
	MgxxFFoyY+ltl5f
X-Gm-Gg: ASbGncv9JqU4RgeLhTuUg785DFiCXIl8sy+B9CVjF1OAPwmUKJtwxGjQsjfRRW1+l6T
	UJZof3ds611mjO9KXurI6pgV3HiV6r/nyqxHdI1uTUeI2NohcLuUqGA6i0pJSEhQ1VZ9nyaMiLH
	+GjMQSBZIgPZ/oRRDHQFtmcs09j3Ac2fs/KlWvlojEaMJxbhCiJcCNVpWGhsuB5Z2BdB3dzwkh4
	J/9PXrE5Qn+hl8NFlEdSso0yIs/ou6ZW+KHBCoBpjX4r/J+0CExqcdJMM1P1ppNBJfBpasaNyX/
	bDsvHeC3/c1Vqj+mDSGXj28Y0SpSoGvtAte+zfB2QXGwzaaxmalPIu6KNFtLr/oY8gC5unR1kX9
	FvnTsui+ng9E+C4lDFNK2/5efAQ5ee9ypeTmnLf61PwALr0XsqgMyi/QutrdQxsWkz2e4LT5V9u
	GdD0Y8LxR5IQ2ibiqtlwZ16/qK9f3SWREq53RN
X-Google-Smtp-Source: AGHT+IF7tePIqRc+qnwaav+Uox+R1F0aQ9fHssTeegAhQvWVnzUrWSzKOAVz2cbOvOs98lZr/xvMFD04yNVR
X-Received: by 2002:a17:902:db07:b0:28d:195a:7d79 with SMTP id d9443c01a7336-294dedf4305mr44325625ad.5.1761761833352;
        Wed, 29 Oct 2025 11:17:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-29498cf507fsm13236925ad.8.2025.10.29.11.17.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:17:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-290ab8f5af6so743845ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1761761831; x=1762366631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiT6EA/v9Bb74Nmc0KEcnrvlYiDeYQoMKxE7nTskVl8=;
        b=VtvYvWahstA6Eq+YZXqcUyF8Ly5pcsi0+fx4PCDGFFPvLLx4gyCANNvsExgyfwj/Iq
         SkDok+KBoqwuV1+OyK4ywJE7gz8pdtAZWHOlXMFIwntBHMwWNDPtNHJgvCDT82bECE7I
         +d5bajFWtgPeiq8Odi91uc6YU2iiXM6N/UggE=
X-Received: by 2002:a17:903:2f87:b0:27e:eb98:9a13 with SMTP id d9443c01a7336-294dee30b86mr44694995ad.22.1761761830631;
        Wed, 29 Oct 2025 11:17:10 -0700 (PDT)
X-Received: by 2002:a17:903:2f87:b0:27e:eb98:9a13 with SMTP id d9443c01a7336-294dee30b86mr44694625ad.22.1761761829974;
        Wed, 29 Oct 2025 11:17:09 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf341bsm157284565ad.14.2025.10.29.11.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 11:17:09 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/5] mpt3sas: Add firmware event requeue support for busy devices
Date: Wed, 29 Oct 2025 23:40:48 +0530
Message-ID: <20251029181058.39157-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
References: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
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

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 128 +++++++++++++++++++++++----
 1 file changed, 110 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 88c3fc897af0..e93610df0a32 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -89,6 +89,7 @@ _scsih_ata_pass_thru_idd(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 *is_ssd_dev
 static enum device_responsive_state
 _scsih_wait_for_device_to_become_ready(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	u8 retry_count, u8 is_pd, int lun, u8 tr_timeout, u8 tr_method);
+static void _firmware_event_work_delayed(struct work_struct *work);
 
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
@@ -272,11 +273,16 @@ struct fw_event_work {
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
@@ -3648,6 +3654,35 @@ _scsih_fw_event_del_from_list(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 }
 
+/**
+ * _scsih_fw_event_requeue - requeue an event
+ * @ioc: per adapter object
+ * @fw_event: object describing the event
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
@@ -8586,6 +8621,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 {
 	int i;
 	int rc;
+	int requeue_event;
 	u16 parent_handle, handle;
 	u16 reason_code;
 	u8 phy_number, max_phys;
@@ -8640,7 +8676,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 
 	/* handle siblings events */
-	for (i = 0; i < event_data->NumEntries; i++) {
+	for (i = 0, requeue_event = 0; i < event_data->NumEntries; i++) {
 		if (fw_event->ignore) {
 			dewtprintk(ioc,
 				   ioc_info(ioc, "ignoring expander event\n"));
@@ -8660,7 +8696,14 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
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
 
@@ -8711,7 +8754,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 			    "event to a device add\n", handle));
 			event_data->PHY[i].PhyStatus &= 0xF0;
 			event_data->PHY[i].PhyStatus |=
-			    MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED;
+						MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED;
 
 			fallthrough;
 
@@ -8728,11 +8771,13 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 
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
@@ -8747,7 +8792,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	    sas_expander)
 		mpt3sas_expander_remove(ioc, sas_address, port);
 
-	return 0;
+	return requeue_event;
 }
 
 /**
@@ -9425,7 +9470,7 @@ _scsih_pcie_topology_change_event_debug(struct MPT3SAS_ADAPTER *ioc,
  * Context: user.
  *
  */
-static void
+static int
 _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
@@ -9435,6 +9480,7 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	u8 link_rate, prev_link_rate;
 	unsigned long flags;
 	int rc;
+	int requeue_event;
 	Mpi26EventDataPCIeTopologyChangeList_t *event_data =
 		(Mpi26EventDataPCIeTopologyChangeList_t *) fw_event->event_data;
 	struct _pcie_device *pcie_device;
@@ -9444,22 +9490,22 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 
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
@@ -9515,8 +9561,8 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 
 			rc = _scsih_pcie_add_device(ioc, handle, fw_event->retries[i]);
 			if (rc) {/* retry due to busy device */
-
 				fw_event->retries[i]++;
+				requeue_event = 1;
 			} else {
 				/* mark entry vacant */
 				/* TODO This needs to be reviewed and fixed,
@@ -9532,11 +9578,12 @@ _scsih_pcie_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
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
@@ -11867,7 +11914,11 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
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
@@ -11907,7 +11958,11 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
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
@@ -11932,6 +11987,15 @@ _firmware_event_work(struct work_struct *work)
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
@@ -12112,6 +12176,34 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
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

