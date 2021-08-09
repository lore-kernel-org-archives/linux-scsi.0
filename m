Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A924DC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FA8061055
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 07:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhHIH1Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbhHIH1O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 03:27:14 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34532C0613CF
        for <linux-scsi@vger.kernel.org>; Mon,  9 Aug 2021 00:26:54 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id l11so3776622plk.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 00:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=gHpv4WRJNobWcGtTKEutBOJUmntnYN4sU4YY1Ojfa24=;
        b=N0R7w7J51hXKqP+xBz/Ze6iZiWDaJPLBqOGts72YiNK+MjiOadVWENygYwQ3grHmak
         HWTSkSraVo6K4uCQurSpvDop3IDIOSFAT8eMQ5LuZWfq++VjYl0p8TNxWKOfRs7brGrw
         lWwoDUwQ96ELFk92XFq6D4IOssmGab5RGnZ6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=gHpv4WRJNobWcGtTKEutBOJUmntnYN4sU4YY1Ojfa24=;
        b=V2HuJvUoEDv7oM2iLm2plXgFdgTpgLf3++KsXgs1/GJul21zw5+BZ/iSmgj79/U0N+
         1L778SHqi0yRb2B4l9+d0YNwA66HcRt5F0dDxeEHBxcaYDjQcmKvmEtBCcXcLm4k8s7p
         zVwvEj3SAKix1oMXQdWdm325IGyapFy9pq9F6JSF0xKRBbiIOZhrmm9Mg/vZetnqLIKZ
         lbjzQJvd3c7OGMvVZJXCzAxV/U7mFKkd62UQgDhfLZen5MNH3sxBVGpV7djQLeDCqz/h
         IRgMkTdr4I944j5K7CHwsbD0POrjhI+XnuPQZQQ80C+YbQeP7PpT2ytI9qH2VsvBeGhY
         //OQ==
X-Gm-Message-State: AOAM532WXq7Rune0wx6q6DFrUYbFrK7vm5QMR7HKtjLRt/skopqAzF6B
        nrVuXl6/5XwG4C6I9fQLHweKBeoGqSHsbLS8Dwb8b16y0NL5BCxHgvA3XcACmXz4ia5BkmSv9Sx
        AtZPDe4PL3LDZIovBGyiciIYwMkusCPzeps/AQ8sHXWJP872gOhHZEwZi9YaB2C5cKBGn5Oz/kf
        9iwbXIjY5Xa+DON5PXUEIVsTg=
X-Google-Smtp-Source: ABdhPJxvUPSU3r2v72SdfDUOY4773qY4EOep98XjM/lyUBzqjUD42CHD4RFaGgCHmabVC7BIyjEkOg==
X-Received: by 2002:a65:5186:: with SMTP id h6mr413636pgq.62.1628494013074;
        Mon, 09 Aug 2021 00:26:53 -0700 (PDT)
Received: from prabu-it-vms-server.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id l13sm17291901pjh.15.2021.08.09.00.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 00:26:52 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 1/2] mpt3sas: Use FW recommended device QD
Date:   Mon,  9 Aug 2021 12:56:38 +0530
Message-Id: <20210809072639.21228-2-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210809072639.21228-1-suganath-prabu.subramani@broadcom.com>
References: <20210809072639.21228-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000348e5605c91b4f4f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000348e5605c91b4f4f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently mpt3sas driver sets below predefined queue depth for the
SAS/SATA/NVMe drives.
SAS     -  254
SATA    -  32
NVME    -  128
IOC Firmware provides the queue depth for each device types through SAS
IO Unit Page1 for SAS/SATA and PCIe IO Unit Page1 for NVMe devices. If
the host sets the queue depth greater than the firmware recommended
queue depth, then IOC places the IO’s above the recommended queue depth
in an internal pending queue (consuming outstanding
host-credit/resources and thereby leading to potential starvation to
other devices) and sends them to the device once IO count drops below
the recommended queue depth. So, it is better for the driver to set
the device queue depth provided by the IOC firmware.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c   | 70 +++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  8 +++
 drivers/scsi/mpt3sas/mpt3sas_config.c | 37 ++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    |  5 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 51 +++++++++++++++++--
 5 files changed, 165 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c399552..fad72fb 100755
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5168,6 +5168,73 @@ _base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
 		    &ioc->diag_trigger_mpi, 1);
 }
 
+/**
+ * _base_assign_fw_reported_qd	- Get FW reported QD for SAS/SATA devices.
+ *				- On failure set default QD values.
+ * @ioc : per adapter object
+ *
+ * Returns 0 for success, non-zero for failure.
+ *
+ */
+static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
+	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
+	int sz;
+	int rc = 0;
+
+	ioc->max_wideport_qd = MPT3SAS_SAS_QUEUE_DEPTH;
+	ioc->max_narrowport_qd = MPT3SAS_SAS_QUEUE_DEPTH;
+	ioc->max_sata_qd = MPT3SAS_SATA_QUEUE_DEPTH;
+	ioc->max_nvme_qd = MPT3SAS_NVME_QUEUE_DEPTH;
+	if (!ioc->is_gen35_ioc)
+		goto out;
+	/* sas iounit page 1 */
+	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData);
+	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg1) {
+		pr_err("%s: failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return rc;
+	}
+	rc = mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
+	    sas_iounit_pg1, sz);
+	if (rc) {
+		pr_err("%s: failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc->max_wideport_qd =
+	    (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
+	    le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth) :
+	    MPT3SAS_SAS_QUEUE_DEPTH;
+	ioc->max_narrowport_qd =
+	    (le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth)) ?
+	    le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth) :
+	    MPT3SAS_SAS_QUEUE_DEPTH;
+	ioc->max_sata_qd = (sas_iounit_pg1->SATAMaxQDepth) ?
+	    sas_iounit_pg1->SATAMaxQDepth : MPT3SAS_SATA_QUEUE_DEPTH;
+	/* pcie iounit page 1 */
+	rc = mpt3sas_config_get_pcie_iounit_pg1(ioc, &mpi_reply,
+	    &pcie_iounit_pg1, sizeof(Mpi26PCIeIOUnitPage1_t));
+	if (rc) {
+		pr_err("%s: failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc->max_nvme_qd = (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) ?
+	    (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) :
+	    MPT3SAS_NVME_QUEUE_DEPTH;
+out:
+	dinitprintk(ioc, pr_err(
+	    "MaxWidePortQD: 0x%x MaxNarrowPortQD: 0x%x MaxSataQD: 0x%x MaxNvmeQD: 0x%x\n",
+	    ioc->max_wideport_qd, ioc->max_narrowport_qd,
+	    ioc->max_sata_qd, ioc->max_nvme_qd));
+	kfree(sas_iounit_pg1);
+	return rc;
+}
+
 /**
  * _base_static_config_pages - static start of day config pages
  * @ioc: per adapter object
@@ -5237,6 +5304,9 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 			ioc_warn(ioc,
 			    "TimeSync Interval in Manuf page-11 is not enabled. Periodic Time-Sync will be disabled\n");
 	}
+	rc = _base_assign_fw_reported_qd(ioc);
+	if (rc)
+		return rc;
 	rc = mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
 	if (rc)
 		return rc;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 785da9f..d226754 100755
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -575,6 +575,7 @@ struct _sas_device {
 	u8	is_chassis_slot_valid;
 	u8	connector_name[5];
 	struct kref refcount;
+	u8	port_type;
 	struct hba_port *port;
 	struct sas_rphy *rphy;
 };
@@ -1423,6 +1424,10 @@ struct MPT3SAS_ADAPTER {
 	u8		tm_custom_handling;
 	u8		nvme_abort_timeout;
 	u16		max_shutdown_latency;
+	u16		max_wideport_qd;
+	u16		max_narrowport_qd;
+	u16		max_nvme_qd;
+	u8		max_sata_qd;
 
 	/* static config pages */
 	struct mpt3sas_facts facts;
@@ -1825,6 +1830,9 @@ int mpt3sas_config_get_pcie_device_pg0(struct MPT3SAS_ADAPTER *ioc,
 int mpt3sas_config_get_pcie_device_pg2(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi26PCIeDevicePage2_t *config_page,
 	u32 form, u32 handle);
+int mpt3sas_config_get_pcie_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26PCIeIOUnitPage1_t *config_page,
+	u16 sz);
 int mpt3sas_config_get_sas_iounit_pg0(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2SasIOUnitPage0_t *config_page,
 	u16 sz);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 83a5c21..0563078 100755
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -1168,6 +1168,43 @@ out:
 	return r;
 }
 
+/**
+ * mpt3sas_config_get_pcie_iounit_pg1 - obtain pcie iounit page 1
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * @sz: size of buffer passed in config_page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_pcie_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26PCIeIOUnitPage1_t *config_page,
+	u16 sz)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_EXTENDED;
+	mpi_request.ExtPageType = MPI2_CONFIG_EXTPAGETYPE_PCIE_IO_UNIT;
+	mpi_request.Header.PageVersion = MPI26_PCIEIOUNITPAGE1_PAGEVERSION;
+	mpi_request.Header.PageNumber = 1;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
+out:
+	return r;
+}
+
 /**
  * mpt3sas_config_get_pcie_device_pg2 - obtain pcie device page 2
  * @ioc: per adapter object
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index b66140e..db95cda 100755
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3820,9 +3820,10 @@ enable_sdev_max_qd_store(struct device *cdev,
 				}
 			} else if (sas_target_priv_data->flags &
 			    MPT_TARGET_FLAGS_PCIE_DEVICE)
-				qdepth = MPT3SAS_NVME_QUEUE_DEPTH;
+				qdepth = ioc->max_nvme_qd;
 			else
-				qdepth = MPT3SAS_SAS_QUEUE_DEPTH;
+				qdepth = (sas_target_priv_data->sas_dev->port_type > 1) ?
+				    ioc->max_wideport_qd : ioc->max_narrowport_qd;
 
 			mpt3sas_scsih_change_queue_depth(sdev, qdepth);
 		}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 866d118..84603ac 100755
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1803,7 +1803,7 @@ scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	 * limit max device queue for SATA to 32 if enable_sdev_max_qd
 	 * is disabled.
 	 */
-	if (ioc->enable_sdev_max_qd)
+	if (ioc->enable_sdev_max_qd || ioc->is_gen35_ioc)
 		goto not_sata;
 
 	sas_device_priv_data = sdev->hostdata;
@@ -2657,7 +2657,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 			return 1;
 		}
 
-		qdepth = MPT3SAS_NVME_QUEUE_DEPTH;
+		qdepth = ioc->max_nvme_qd;
 		ds = "NVMe";
 		sdev_printk(KERN_INFO, sdev,
 			"%s: handle(0x%04x), wwid(0x%016llx), port(%d)\n",
@@ -2709,7 +2709,8 @@ scsih_slave_configure(struct scsi_device *sdev)
 	sas_device->volume_handle = volume_handle;
 	sas_device->volume_wwid = volume_wwid;
 	if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_SSP_TARGET) {
-		qdepth = MPT3SAS_SAS_QUEUE_DEPTH;
+		qdepth = (sas_device->port_type > 1) ?
+			ioc->max_wideport_qd : ioc->max_narrowport_qd;
 		ssp_target = 1;
 		if (sas_device->device_info &
 				MPI2_SAS_DEVICE_INFO_SEP) {
@@ -2721,7 +2722,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 		} else
 			ds = "SSP";
 	} else {
-		qdepth = MPT3SAS_SATA_QUEUE_DEPTH;
+		qdepth = ioc->max_sata_qd;
 		if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_STP_TARGET)
 			ds = "STP";
 		else if (sas_device->device_info &
@@ -7371,6 +7372,10 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 
 	/* get device name */
 	sas_device->device_name = le64_to_cpu(sas_device_pg0.DeviceName);
+	sas_device->port_type = sas_device_pg0.MaxPortConnections;
+	ioc_info(ioc,
+	    "handle(0x%0x) sas_address(0x%016llx) port_type(0x%0x)\n",
+	    handle, sas_device->sas_address, sas_device->port_type);
 
 	if (ioc->wait_for_discovery_to_complete)
 		_scsih_sas_device_init_add(ioc, sas_device);
@@ -9603,6 +9608,42 @@ _scsih_prep_device_scan(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/**
+ * _scsih_update_device_qdepth - Update QD during Reset.
+ * @ioc: per adapter object
+ *
+ */
+static void
+_scsih_update_device_qdepth(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct _sas_device *sas_device;
+	struct scsi_device *sdev;
+	u16 qdepth;
+
+	ioc_info(ioc, "Updated Devices with FW Reported QD\n");
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (sas_device_priv_data && sas_device_priv_data->sas_target) {
+			sas_target_priv_data = sas_device_priv_data->sas_target;
+			sas_device = sas_device_priv_data->sas_target->sas_dev;
+			if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_PCIE_DEVICE)
+				qdepth = ioc->max_nvme_qd;
+			else if (sas_device &&
+			    sas_device->device_info & MPI2_SAS_DEVICE_INFO_SSP_TARGET)
+				qdepth = (sas_device->port_type > 1) ?
+				    ioc->max_wideport_qd : ioc->max_narrowport_qd;
+			else if (sas_device &&
+			    sas_device->device_info & MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
+				qdepth = ioc->max_sata_qd;
+			else
+				continue;
+			mpt3sas_scsih_change_queue_depth(sdev, qdepth);
+		}
+	}
+}
+
 /**
  * _scsih_mark_responding_sas_device - mark a sas_devices as responding
  * @ioc: per adapter object
@@ -10654,6 +10695,8 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 		_scsih_remove_unresponding_devices(ioc);
 		_scsih_del_dirty_vphy(ioc);
 		_scsih_del_dirty_port_entries(ioc);
+		if (ioc->is_gen35_ioc)
+			_scsih_update_device_qdepth(ioc);
 		_scsih_scan_for_devices_after_reset(ioc);
 		/*
 		 * If diag reset has occurred during the driver load
-- 
2.27.0


--000000000000348e5605c91b4f4f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQkQYJKoZIhvcNAQcCoIIQgjCCEH4CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3oMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBXAwggRYoAMCAQICDCAc2j96+IoHW5040jANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjQzNTVaFw0yMjA5MTUxMTMwMjdaMIGm
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xITAfBgNVBAMTGFN1Z2FuYXRoIFByYWJ1IFN1YnJhbWFuaTE0
MDIGCSqGSIb3DQEJARYlc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJp3W6i+yVqwmKTbucNHNrAD35AKBa4GklrnUcWS
As4Yz62jxfJOu+dcysfahgpi3JcAhTe/eRMLc5on8ReYZAYCMNJ+jpNKRuf1Abgh6nfhcNf+cuGb
S83CJlqxdJjbnimwwbueitA/edWTFjcULNUDZZEmAPJkbHXmlTlJD8TMdR0ezem/d4niexc4RCyt
YMUhnlcyFg+2OR0MKuT2Q714Ka0IamXFyyXhX5wD9B+ITo5hu+ZtXV2RuOXy0U2bIEQzFPVJ7QA9
hUD4z7+jEN/0xIbuF8EJZMsb6XAT+CFOjnizM5yvGFfmupDlyQ4JuVb86R8v2AEDpXmbdnS1tDkC
AwEAAaOCAeYwggHiMA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUH
MAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNydDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3Nn
Y2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
SQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29u
YWxzaWduMmNhMjAyMC5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJy
b2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk
1b5I3qGPzzAdBgNVHQ4EFgQURmgYmHXuw9VrKqnEjPBuviQS0CEwDQYJKoZIhvcNAQELBQADggEB
AAp1Yt9kkxViI/9B/AQxLFmuC9wWruix0ajjegaJ/HZ6C1ky/V9QvI1MwweIhBiuk2jttOzO4h87
rADIQnEI3bf5ccaw61CJNqc6Cb4LiEIjPF7py8f6+rHL928xCUnKqeCO2sC0A+k39bCiyHaGo432
eXxWNXxGrLg6/2TuwgOtvbil0hWwK/Wf5ql2YiZXy8wRo9IhHoY/4cJLS/Fay8yKX8IdhEc3pNbu
dDLaJg39U0ikF3NHtNMaXXHgh6TMs3OsWhH4+zlvkC0eSC6dvasGxmpPQPQe/0huBB8gDbzGrRg/
cRn2ctMmNHxZO4EBJ5SzsV/lHimTk+5K39lzkzYxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQ
ZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwgHNo/eviKB1udONIwDQYJYIZIAWUDBAIBBQCggdQwLwYJ
KoZIhvcNAQkEMSIEIJRmz2XoAmgoTcT9dmC7xSUUR2bplMpXrHduM6KMoqopMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgwOTA3MjY1M1owaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAQ
MlvZBRhq5Pe/ijHU3sUOXdfjmVv2KYE/TFiGJbRDW+5N8rpJk9W/V4/jZPIfCzuJXVd4cbyXrZKo
sjvDbO884jCDNZ7iGrwBlq69va0tXV7Cyx0Md1/negP+kxvs7SJRO/pcISQsMxpPbDdn3whL13B3
H8m/aT8I4S7VoV3mpilyC7yQ7AKayyh9VDGxILUXp3+WBebW9Q19ChcK3N3eX8PUWvsUiOXOhSUv
RHpjeeLlGnGrhyMhnp3MmyTvVQUcaqSfwtF2fPtQEjQNRon1sqXCMRPW+HAYOSVQ1WhyTLb3Ia2g
XLGnFubpXnT+Mu6OL5FbehKtYhJr6N8WTuR6
--000000000000348e5605c91b4f4f--
