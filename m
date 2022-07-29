Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A59C19F29
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 13:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiG2NGm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbiG2NFy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 09:05:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBFB7AC38
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:47 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p1so4535403plr.11
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=XIg6N7cPcQ4Cpo4c1LvDnkUTv1tNzU9qq01vDbie6Y8=;
        b=cKzaNeJGucEX6+clcMvu/FXtM/3h89I55oHdj8/upTttAjDPUsTWsjfrxgvWfDbS+P
         BVIFg5HWMeN/eCUxc6S9jJ2vyHttUaFV5Ir3V/fMw8MW7grUS9oITUqAOk4FNwZYHWaN
         haiDGF+pLbadrhthm8i+LZ28ruD8eU8Of7s9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=XIg6N7cPcQ4Cpo4c1LvDnkUTv1tNzU9qq01vDbie6Y8=;
        b=HHbxbV0gIMXa8iZCXDhvTTpsjRcI5oJB9rmdiqZtPiWjmnOvX4kxAjm7SF+tHHBZ3l
         Ti04BLOFL2pQlureg5XHcX6Ioo3e+Xfwc/pYog9t4nRvdUk3cFOe9azhbyWOS+uDjs7r
         0K293Ax15i81c33giMCJcF3HYDGcaMB/YXnpydao4WNcyEluOpFK6TO1OtUIO9H0Ctlt
         pji6xVoEmvKN9cOaxS8IJ6iSrG/rHiIatyzEAvDSy/0VDr8hNqiAnuuX3VA6YmBweQ4d
         D6oGBUmDo9yg7rxMLgiOMAODMloEb1U6RwESF1ThurSPncE/kKFoUrr/K/vQ6qGemDyz
         BWpA==
X-Gm-Message-State: ACgBeo2ZyWObo68r6Ad5f0bncBSL9T4dQvkvjocXXGCvoOl4xJZUJEh4
        fRldhYHhRWF4H6v4CL7K9DZUEDra29nDjUUJ7tAxD8fM/tBqsPOQXAgLWiFaPWOIqr24tZ7xlBw
        z4tCuhe7wHy5bI43+n+EhmLYkTg6wjoMWFXRj+A3COmaHapr7hkiSGLcZqwhHvqYFRBPBkjWK3M
        r7xAplcJ6p
X-Google-Smtp-Source: AA6agR6i55vzijiAunP6DRbIT5bXefZ+VdPa8AyLV+uZqo6XouBPyGXoexYwhkYWF6eO90AVVdogTQ==
X-Received: by 2002:a17:903:1250:b0:16b:9866:c2f0 with SMTP id u16-20020a170903125000b0016b9866c2f0mr3970963plh.68.1659099885428;
        Fri, 29 Jul 2022 06:04:45 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b0016dd6929af5sm1225816pls.206.2022.07.29.06.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:04:45 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 14/15] mpi3mr: Refresh sas ports during soft reset
Date:   Fri, 29 Jul 2022 18:46:26 +0530
Message-Id: <20220729131627.15019-15-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005d592a05e4f14b1b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000005d592a05e4f14b1b
Content-Transfer-Encoding: 8bit

- Update the Host's sas ports if there is change in port id
 or phys. If the port id is changed then the driver updates
 the same. If some phys are enabled/disabled during reset then
 driver updates the same in STL.

- Check for the responding expander devices and update the
 device handle if it got changed. Register the expander with
 STL if it got added during reset and unregister the
 expander device if it got removed during reset.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  11 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  50 ++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 351 +++++++++++++++++++++++++
 4 files changed, 421 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index d203167..0f47b45 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -482,6 +482,9 @@ struct mpi3mr_hba_port {
  * struct mpi3mr_sas_port - Internal SAS port information
  * @port_list: List of ports belonging to a SAS node
  * @num_phys: Number of phys associated with port
+ * @marked_responding: used while refresing the sas ports
+ * @lowest_phy: lowest phy ID of current sas port
+ * @phy_mask: phy_mask of current sas port
  * @hba_port: HBA port entry
  * @remote_identify: Attached device identification
  * @rphy: SAS transport layer rphy object
@@ -491,6 +494,9 @@ struct mpi3mr_hba_port {
 struct mpi3mr_sas_port {
 	struct list_head port_list;
 	u8 num_phys;
+	u8 marked_responding;
+	int lowest_phy;
+	u32 phy_mask;
 	struct mpi3mr_hba_port *hba_port;
 	struct sas_identify remote_identify;
 	struct sas_rphy *rphy;
@@ -939,6 +945,7 @@ struct scmd_priv {
  * @scan_started: Async scan started
  * @scan_failed: Asycn scan failed
  * @stop_drv_processing: Stop all command processing
+ * @device_refresh_on: Don't process the events until devices are refreshed
  * @max_host_ios: Maximum host I/O count
  * @chain_buf_count: Chain buffer count
  * @chain_buf_pool: Chain buffer pool
@@ -1107,6 +1114,7 @@ struct mpi3mr_ioc {
 	u8 scan_started;
 	u16 scan_failed;
 	u8 stop_drv_processing;
+	u8 device_refresh_on;
 
 	u16 max_host_ios;
 	spinlock_t tgtdev_lock;
@@ -1378,4 +1386,7 @@ struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr_and_rphy(
 	struct mpi3mr_ioc *mrioc, u64 sas_address, struct sas_rphy *rphy);
 void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
 	bool device_add);
+void mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc);
+void mpi3mr_refresh_expanders(struct mpi3mr_ioc *mrioc);
+void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 59ef373..dfb7570 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3977,6 +3977,11 @@ retry_init:
 		goto out_failed;
 	}
 
+	if (!is_resume) {
+		mrioc->device_refresh_on = 1;
+		mpi3mr_add_event_wait_for_device_refresh(mrioc);
+	}
+
 	ioc_info(mrioc, "sending port enable\n");
 	retval = mpi3mr_issue_port_enable(mrioc, 0);
 	if (retval) {
@@ -4733,6 +4738,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	ioc_info(mrioc, "controller reset is triggered by %s\n",
 	    mpi3mr_reset_rc_name(reset_reason));
 
+	mrioc->device_refresh_on = 0;
 	mrioc->reset_in_progress = 1;
 	mrioc->stop_bsgs = 1;
 	mrioc->prev_reset_result = -1;
@@ -4814,7 +4820,8 @@ out:
 			mpi3mr_pel_wait_post(mrioc, &mrioc->pel_cmds);
 		}
 
-		mpi3mr_rfresh_tgtdevs(mrioc);
+		mrioc->device_refresh_on = 0;
+
 		mrioc->ts_update_counter = 0;
 		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
 		if (mrioc->watchdog_work_q)
@@ -4828,6 +4835,7 @@ out:
 	} else {
 		mpi3mr_issue_reset(mrioc,
 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
+		mrioc->device_refresh_on = 0;
 		mrioc->unrecoverable = 1;
 		mrioc->reset_in_progress = 0;
 		retval = -1;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 139c164..d4f37b1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -40,6 +40,8 @@ static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 
 #define MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION	(0xFFFF)
 
+#define MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH	(0xFFFE)
+
 /**
  * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
  * @mrioc: Adapter instance reference
@@ -1114,6 +1116,9 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		    MPI3_DEVICE0_FLAGS_ATT_METHOD_VIRTUAL)) ||
 		    (tgtdev->parent_handle == 0xFFFF))
 			tgtdev->non_stl = 1;
+		if (tgtdev->dev_spec.sas_sata_inf.hba_port)
+			tgtdev->dev_spec.sas_sata_inf.hba_port->port_id =
+			    dev_pg0->io_unit_port;
 		break;
 	}
 	case MPI3_DEVICE_DEVFORM_PCIE:
@@ -1886,6 +1891,22 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 		}
 		break;
 	}
+	case MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH:
+	{
+		while (mrioc->device_refresh_on)
+			msleep(500);
+
+		dprint_event_bh(mrioc,
+		    "scan for non responding and newly added devices after soft reset started\n");
+		if (mrioc->sas_transport_enabled) {
+			mpi3mr_refresh_sas_ports(mrioc);
+			mpi3mr_refresh_expanders(mrioc);
+		}
+		mpi3mr_rfresh_tgtdevs(mrioc);
+		ioc_info(mrioc,
+		    "scan for non responding and newly added devices after soft reset completed\n");
+		break;
+	}
 	default:
 		break;
 	}
@@ -2655,6 +2676,35 @@ static void mpi3mr_cablemgmt_evt_th(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+/**
+ * mpi3mr_add_event_wait_for_device_refresh - Add Wait for Device Refresh Event
+ * @mrioc: Adapter instance reference
+ *
+ * Add driver specific event to make sure that the driver won't process the
+ * events until all the devices are refreshed during soft reset.
+ *
+ * Return: Nothing
+ */
+void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3mr_fwevt *fwevt = NULL;
+
+	fwevt = mpi3mr_alloc_fwevt(0);
+	if (!fwevt) {
+		dprint_event_th(mrioc,
+		    "failed to schedule bottom half handler for event(0x%02x)\n",
+		    MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH);
+		return;
+	}
+	fwevt->mrioc = mrioc;
+	fwevt->event_id = MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH;
+	fwevt->send_ack = 0;
+	fwevt->process_evt = 1;
+	fwevt->evt_ctx = 0;
+	fwevt->event_data_size = 0;
+	mpi3mr_fwevt_add_to_list(mrioc, fwevt);
+}
+
 /**
  * mpi3mr_os_handle_events - Firmware event handler
  * @mrioc: Adapter instance reference
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index e8a9a76..c1ca97c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -9,6 +9,9 @@
 
 #include "mpi3mr.h"
 
+static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *sas_expander);
+
 /**
  * mpi3mr_post_transport_req - Issue transport requests and wait
  * @mrioc: Adapter instance reference
@@ -597,6 +600,9 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 
 	list_del(&mr_sas_phy->port_siblings);
 	mr_sas_port->num_phys--;
+	mr_sas_port->phy_mask &= ~(1 << mr_sas_phy->phy_id);
+	if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
+		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 0;
 }
@@ -621,6 +627,9 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 
 	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
 	mr_sas_port->num_phys++;
+	mr_sas_port->phy_mask |= (1 << mr_sas_phy->phy_id);
+	if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
+		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 1;
 }
@@ -1356,6 +1365,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		list_add_tail(&mr_sas_node->phy[i].port_siblings,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
+		mr_sas_port->phy_mask |= (1 << i);
 	}
 
 	if (!mr_sas_port->num_phys) {
@@ -1364,6 +1374,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 		goto out_fail;
 	}
 
+	mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
 		    mr_sas_port->remote_identify.sas_address,
@@ -1565,6 +1577,345 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 	kfree(mr_sas_port);
 }
 
+/**
+ * struct host_port - host port details
+ * @sas_address: SAS Address of the attached device
+ * @phy_mask: phy mask of host port
+ * @handle: Device Handle of attached device
+ * @iounit_port_id: port ID
+ * @used: host port is already matched with sas port from sas_port_list
+ * @lowest_phy: lowest phy ID of host port
+ */
+struct host_port {
+	u64	sas_address;
+	u32	phy_mask;
+	u16	handle;
+	u8	iounit_port_id;
+	u8	used;
+	u8	lowest_phy;
+};
+
+/**
+ * mpi3mr_update_mr_sas_port - update sas port objects during reset
+ * @mrioc: Adapter instance reference
+ * @h_port: host_port object
+ * @mr_sas_port: sas_port objects which needs to be updated
+ *
+ * Update the port ID of sas port object. Also add the phys if new phys got
+ * added to current sas port and remove the phys if some phys are moved
+ * out of the current sas port.
+ *
+ * Return: Nothing.
+ */
+static void
+mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
+	struct mpi3mr_sas_port *mr_sas_port)
+{
+	struct mpi3mr_sas_phy *mr_sas_phy;
+	u32 phy_mask_xor, phys_to_be_added, phys_to_be_removed;
+	int i;
+
+	h_port->used = 1;
+	mr_sas_port->marked_responding = 1;
+
+	dev_info(&mr_sas_port->port->dev,
+	    "sas_address(0x%016llx), old: port_id %d phy_mask 0x%x, new: port_id %d phy_mask:0x%x\n",
+	    mr_sas_port->remote_identify.sas_address,
+	    mr_sas_port->hba_port->port_id, mr_sas_port->phy_mask,
+	    h_port->iounit_port_id, h_port->phy_mask);
+
+	mr_sas_port->hba_port->port_id = h_port->iounit_port_id;
+	mr_sas_port->hba_port->flags &= ~MPI3MR_HBA_PORT_FLAG_DIRTY;
+
+	/* Get the newly added phys bit map & removed phys bit map */
+	phy_mask_xor = mr_sas_port->phy_mask ^ h_port->phy_mask;
+	phys_to_be_added = h_port->phy_mask & phy_mask_xor;
+	phys_to_be_removed = mr_sas_port->phy_mask & phy_mask_xor;
+
+	/*
+	 * Register these new phys to current mr_sas_port's port.
+	 * if these phys are previously registered with another port
+	 * then delete these phys from that port first.
+	 */
+	for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u32)) {
+		mr_sas_phy = &mrioc->sas_hba.phy[i];
+		if (mr_sas_phy->phy_belongs_to_port)
+			mpi3mr_del_phy_from_an_existing_port(mrioc,
+			    &mrioc->sas_hba, mr_sas_phy);
+		mpi3mr_add_phy_to_an_existing_port(mrioc,
+		    &mrioc->sas_hba, mr_sas_phy,
+		    mr_sas_port->remote_identify.sas_address,
+		    mr_sas_port->hba_port);
+	}
+
+	/* Delete the phys which are not part of current mr_sas_port's port. */
+	for_each_set_bit(i, (ulong *) &phys_to_be_removed, BITS_PER_TYPE(u32)) {
+		mr_sas_phy = &mrioc->sas_hba.phy[i];
+		if (mr_sas_phy->phy_belongs_to_port)
+			mpi3mr_del_phy_from_an_existing_port(mrioc,
+			    &mrioc->sas_hba, mr_sas_phy);
+	}
+}
+
+/**
+ * mpi3mr_refresh_sas_ports - update host's sas ports during reset
+ * @mrioc: Adapter instance reference
+ *
+ * Update the host's sas ports during reset by checking whether
+ * sas ports are still intact or not. Add/remove phys if any hba
+ * phys are (moved in)/(moved out) of sas port. Also update
+ * io_unit_port if it got changed during reset.
+ *
+ * Return: Nothing.
+ */
+void
+mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
+{
+	struct host_port h_port[32];
+	int i, j, found, host_port_count = 0, port_idx;
+	u16 sz, attached_handle, ioc_status;
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
+	struct mpi3_device_page0 dev_pg0;
+	struct mpi3_device0_sas_sata_format *sasinf;
+	struct mpi3mr_sas_port *mr_sas_port;
+
+	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
+		(mrioc->sas_hba.num_phys *
+		 sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg0)
+		return;
+	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	/* Create a new expander port table */
+	for (i = 0; i < mrioc->sas_hba.num_phys; i++) {
+		attached_handle = le16_to_cpu(
+		    sas_io_unit_pg0->phy_data[i].attached_dev_handle);
+		if (!attached_handle)
+			continue;
+		found = 0;
+		for (j = 0; j < host_port_count; j++) {
+			if (h_port[j].handle == attached_handle) {
+				h_port[j].phy_mask |= (1 << i);
+				found = 1;
+				break;
+			}
+		}
+		if (found)
+			continue;
+		if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
+		    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
+		    attached_handle))) {
+			dprint_reset(mrioc,
+			    "failed to read dev_pg0 for handle(0x%04x) at %s:%d/%s()!\n",
+			    attached_handle, __FILE__, __LINE__, __func__);
+			continue;
+		}
+		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+			dprint_reset(mrioc,
+			    "ioc_status(0x%x) while reading dev_pg0 for handle(0x%04x) at %s:%d/%s()!\n",
+			    ioc_status, attached_handle,
+			    __FILE__, __LINE__, __func__);
+			continue;
+		}
+		sasinf = &dev_pg0.device_specific.sas_sata_format;
+
+		port_idx = host_port_count;
+		h_port[port_idx].sas_address = le64_to_cpu(sasinf->sas_address);
+		h_port[port_idx].handle = attached_handle;
+		h_port[port_idx].phy_mask = (1 << i);
+		h_port[port_idx].iounit_port_id = sas_io_unit_pg0->phy_data[i].io_unit_port;
+		h_port[port_idx].lowest_phy = sasinf->phy_num;
+		h_port[port_idx].used = 0;
+		host_port_count++;
+	}
+
+	if (!host_port_count)
+		goto out;
+
+	if (mrioc->logging_level & MPI3_DEBUG_RESET) {
+		ioc_info(mrioc, "Host port details before reset\n");
+		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
+		    port_list) {
+			ioc_info(mrioc,
+			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%x), lowest phy id:%d\n",
+			    mr_sas_port->hba_port->port_id,
+			    mr_sas_port->remote_identify.sas_address,
+			    mr_sas_port->phy_mask, mr_sas_port->lowest_phy);
+		}
+		mr_sas_port = NULL;
+		ioc_info(mrioc, "Host port details after reset\n");
+		for (i = 0; i < host_port_count; i++) {
+			ioc_info(mrioc,
+			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%x), lowest phy id:%d\n",
+			    h_port[i].iounit_port_id, h_port[i].sas_address,
+			    h_port[i].phy_mask, h_port[i].lowest_phy);
+		}
+	}
+
+	/* mark all host sas port entries as dirty */
+	list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
+	    port_list) {
+		mr_sas_port->marked_responding = 0;
+		mr_sas_port->hba_port->flags |= MPI3MR_HBA_PORT_FLAG_DIRTY;
+	}
+
+	/* First check for matching lowest phy */
+	for (i = 0; i < host_port_count; i++) {
+		mr_sas_port = NULL;
+		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
+		    port_list) {
+			if (mr_sas_port->marked_responding)
+				continue;
+			if (h_port[i].sas_address != mr_sas_port->remote_identify.sas_address)
+				continue;
+			if (h_port[i].lowest_phy == mr_sas_port->lowest_phy) {
+				mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
+				break;
+			}
+		}
+	}
+
+	/* In case if lowest phy is got enabled or disabled during reset */
+	for (i = 0; i < host_port_count; i++) {
+		if (h_port[i].used)
+			continue;
+		mr_sas_port = NULL;
+		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
+		    port_list) {
+			if (mr_sas_port->marked_responding)
+				continue;
+			if (h_port[i].sas_address != mr_sas_port->remote_identify.sas_address)
+				continue;
+			if (h_port[i].phy_mask & mr_sas_port->phy_mask) {
+				mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
+				break;
+			}
+		}
+	}
+
+	/* In case if expander cable is removed & connected to another HBA port during reset */
+	for (i = 0; i < host_port_count; i++) {
+		if (h_port[i].used)
+			continue;
+		mr_sas_port = NULL;
+		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
+		    port_list) {
+			if (mr_sas_port->marked_responding)
+				continue;
+			if (h_port[i].sas_address != mr_sas_port->remote_identify.sas_address)
+				continue;
+			mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
+			break;
+		}
+	}
+out:
+	kfree(sas_io_unit_pg0);
+}
+
+/**
+ * mpi3mr_refresh_expanders - Refresh expander device exposure
+ * @mrioc: Adapter instance reference
+ *
+ * This is executed post controller reset to identify any
+ * missing expander devices during reset and remove from the upper layers
+ * or expose any newly detected expander device to the upper layers.
+ *
+ * Return: Nothing.
+ */
+void
+mpi3mr_refresh_expanders(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
+	struct mpi3_sas_expander_page0 expander_pg0;
+	u16 ioc_status, handle;
+	u64 sas_address;
+	int i;
+	unsigned long flags;
+	struct mpi3mr_hba_port *hba_port;
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
+		sas_expander->non_responding = 1;
+	}
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+	sas_expander = NULL;
+
+	handle = 0xffff;
+
+	/* Search for responding expander devices and add them if they are newly got added */
+	while (true) {
+		if ((mpi3mr_cfg_get_sas_exp_pg0(mrioc, &ioc_status, &expander_pg0,
+		    sizeof(struct mpi3_sas_expander_page0),
+		    MPI3_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
+			dprint_reset(mrioc,
+			    "failed to read exp pg0 for handle(0x%04x) at %s:%d/%s()!\n",
+			    handle, __FILE__, __LINE__, __func__);
+			break;
+		}
+
+		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+			dprint_reset(mrioc,
+			   "ioc_status(0x%x) while reading exp pg0 for handle:(0x%04x), %s:%d/%s()!\n",
+			   ioc_status, handle, __FILE__, __LINE__, __func__);
+			break;
+		}
+
+		handle = le16_to_cpu(expander_pg0.dev_handle);
+		sas_address = le64_to_cpu(expander_pg0.sas_address);
+		hba_port = mpi3mr_get_hba_port_by_id(mrioc, expander_pg0.io_unit_port);
+
+		if (!hba_port) {
+			mpi3mr_sas_host_refresh(mrioc);
+			mpi3mr_expander_add(mrioc, handle);
+			continue;
+		}
+
+		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+		sas_expander =
+		    mpi3mr_expander_find_by_sas_address(mrioc,
+		    sas_address, hba_port);
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+		if (!sas_expander) {
+			mpi3mr_sas_host_refresh(mrioc);
+			mpi3mr_expander_add(mrioc, handle);
+			continue;
+		}
+
+		sas_expander->non_responding = 0;
+		if (sas_expander->handle == handle)
+			continue;
+
+		sas_expander->handle = handle;
+		for (i = 0 ; i < sas_expander->num_phys ; i++)
+			sas_expander->phy[i].handle = handle;
+	}
+
+	/*
+	 * Delete non responding expander devices and the corresponding
+	 * hba_port if the non responding expander device's parent device
+	 * is a host node.
+	 */
+
+	sas_expander = NULL;
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_for_each_entry_safe_reverse(sas_expander, sas_expander_next,
+	    &mrioc->sas_expander_list, list) {
+		if (sas_expander->non_responding) {
+			spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+			mpi3mr_expander_node_remove(mrioc, sas_expander);
+			spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+}
+
 /**
  * mpi3mr_expander_node_add - insert an expander to the list.
  * @mrioc: Adapter instance reference
-- 
2.27.0


--0000000000005d592a05e4f14b1b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIO7fxE72xJA0ISk2OdIL
PrW1wUU0+LbPZIdQ5GrNye96MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyOTEzMDQ0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC0keaStMhVS0/2wLd4/8acvWqX7nMs7vxJSA9N
zqF2rRy4/TGDVKeXLW3WZR+cVlmp2eaR3sJDqp4oe2WIDYdsNQR+JPR0IhGNOK5gRXaUvB7sln38
buul+JZ6aBsszINQ6riLpKzgBTFMsLNuK7na0LZoPPldqCOj64dG5c02iXM9/+abww5kT/s+/aWT
0qDkqBc5k0+U4DLW9q9UeGU3eUK7xPM13ZBmyxsDB9QeNfJHnRAk0odoYxKHxMPwtoVn9oiXwxTW
U0Eld6iMn8VACC+LVtZi2uZqB+nMlaTpWsd3bO0Cdpzd0H9N0FcRkbsWj/esIIxGgBaS/zyxmVWW
--0000000000005d592a05e4f14b1b--
