Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D40DC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264682310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgLVKNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgLVKNh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:37 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B98C061257
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:41 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id lb18so1067805pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4+wgapSUgK/5JDvs5Qwmh3OOJy4SOZlrjLJCZCFjQFU=;
        b=aCI50JB53H0+PJmbt1NfRqKyOpRwVQURtF+adAFregjWpssklnr66oOp1vHQXYqQkJ
         6UOw+2nSvdMRhc8EtoKkbmAuLavzlF3NiIi8B8EwTcRJ2Q9eZtHZkKaVmeguB3VvxAj3
         ysFGf/o1hV2heSvxo3JsQq/nvqZIupehKbmC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=4+wgapSUgK/5JDvs5Qwmh3OOJy4SOZlrjLJCZCFjQFU=;
        b=qfabC8BFhmSHXHrXs/OL/cb/5GCCNKfrzRI5pz8RUFnoKUEp0S0NvgpCv1/lIxYYo4
         11beEjEP55HwDfkkwqkjkHN4CHk/8itocEr8vnRUg3S8juZE6UzgPo6DkPrxkKXwt1Ek
         kgUlW2G9gt67HFL0/NgPGA4mNqrRMsp6jTz6kykdOwUiV6+F+vtrRVI8LK3b2FPXxUrm
         qxxoQDQ1IHL0zhVGco3by5AErt92WBK8GiXyP+qFfGLtqycIan7teX/EL0kbWSQj/5YU
         nldPVJTYuUDUgj0MnZcy3iZOSLwATSGm6rhjAHqiuybTmnBaL0JvH8X55l8GUWZ1sPME
         dsIQ==
X-Gm-Message-State: AOAM532ZZPIG5SRGVODkTPGGAMNO1EXlhTzgfGnlhUunfdnySU2eyhx5
        TOQFBad5nfLOFN035NWVl4f0ewOeS9EGqV/8up6IqaejhRvjRPR7KIDdjDTcr1Nwmi+mmjsAQjr
        wIuDsGhdt6lqEE4SCgTVB9lQq9rnTIh0+fW/uQkxBfRBi3ate+D3LEOj1+96rfPTjlCbZ0GZTGD
        +dOBVQlHlG
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJxvQcSxc6MMDcQ8gyeZDf4RdR75cQZ+nn2vZXzqonMLDN0vLB3BA+6mwrRJISkwQz21iexkMA==
X-Received: by 2002:a17:90b:197:: with SMTP id t23mr21206550pjs.26.1608631960226;
        Tue, 22 Dec 2020 02:12:40 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:12:39 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 07/24] mpi3mr: add support of event handling pcie devices part-2
Date:   Tue, 22 Dec 2020 15:41:39 +0530
Message-Id: <20201222101156.98308-8-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000098076405b70ad082"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000098076405b70ad082
Content-Type: text/plain; charset="US-ASCII"

Firmware can report various MPI Events.
Support for certain Events (as listed below) are enabled in the driver
and their processing in driver is covered in this patch.

MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST
MPI3_EVENT_PCIE_ENUMERATION

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   2 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 202 ++++++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c3933c9b73fc..c70c75fdac5c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2735,6 +2735,8 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
 
 	retval = mpi3mr_issue_event_notification(mrioc);
 	if (retval) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e0ca657bfff5..5be25fbe0e5b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -566,6 +566,40 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_update_sdev - Update SCSI device information
+ * @sdev: SCSI device reference
+ * @data: target device reference
+ *
+ * This is an iterator function called for each SCSI device in a
+ * target to update the target specific information into each
+ * SCSI device.
+ *
+ * Return: Nothing.
+ */
+static void
+mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	tgtdev = (struct mpi3mr_tgt_dev *) data;
+	if (!tgtdev)
+		return;
+
+	switch (tgtdev->dev_type) {
+	case MPI3_DEVICE_DEVFORM_PCIE:
+		/*The block layer hw sector size = 512*/
+		blk_queue_max_hw_sectors(sdev->request_queue,
+		    tgtdev->dev_spec.pcie_inf.mdts / 512);
+		blk_queue_virt_boundary(sdev->request_queue,
+		    ((1 << tgtdev->dev_spec.pcie_inf.pgsz) - 1));
+
+		break;
+	default:
+		break;
+	}
+}
+
 /**
  * mpi3mr_rfresh_tgtdevs - Refresh target device exposure
  * @mrioc: Adapter instance reference
@@ -654,6 +688,33 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 			tgtdev->is_hidden = 1;
 		break;
 	}
+	case MPI3_DEVICE_DEVFORM_PCIE:
+	{
+		Mpi3Device0PcieFormat_t *pcieinf =
+		    &dev_pg0->DeviceSpecific.PcieFormat;
+		u16 dev_info = le16_to_cpu(pcieinf->DeviceInfo);
+
+		tgtdev->dev_spec.pcie_inf.capb =
+		    le32_to_cpu(pcieinf->Capabilities);
+		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
+		/* 2^12 = 4096 */
+		tgtdev->dev_spec.pcie_inf.pgsz = 12;
+		if (dev_pg0->AccessStatus == MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
+			tgtdev->dev_spec.pcie_inf.mdts =
+			    le32_to_cpu(pcieinf->MaximumDataTransferSize);
+			tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->PageSize;
+			tgtdev->dev_spec.pcie_inf.reset_to =
+			    pcieinf->ControllerResetTO;
+			tgtdev->dev_spec.pcie_inf.abort_to =
+			    pcieinf->NVMeAbortTO;
+		}
+		if (tgtdev->dev_spec.pcie_inf.mdts > (1024 * 1024))
+			tgtdev->dev_spec.pcie_inf.mdts = (1024 * 1024);
+		if ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
+		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE)
+			tgtdev->is_hidden = 1;
+		break;
+	}
 	case MPI3_DEVICE_DEVFORM_VD:
 	{
 		Mpi3Device0VdFormat_t *vdinf =
@@ -768,6 +829,9 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
 	if (tgtdev->is_hidden && tgtdev->host_exposed)
 		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+	if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev->starget)
+		starget_for_each_device(tgtdev->starget, (void *) tgtdev,
+		    mpi3mr_update_sdev);
 out:
 	if (tgtdev)
 		mpi3mr_tgtdev_put(tgtdev);
@@ -821,6 +885,54 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+/**
+ * mpi3mr_pcietopochg_evt_bh - PCIeTopologyChange evt bottomhalf
+ * @mrioc: Adapter instance reference
+ * @fwevt: Firmware event reference
+ *
+ * Prints information about the PCIe topology change event and
+ * for "not responding" event code, removes the device from the
+ * upper layers.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_fwevt *fwevt)
+{
+	Mpi3EventDataPcieTopologyChangeList_t *event_data =
+	    (Mpi3EventDataPcieTopologyChangeList_t *)fwevt->event_data;
+	int i;
+	u16 handle;
+	u8 reason_code;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+
+	for (i = 0; i < event_data->NumEntries; i++) {
+		handle =
+		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+		if (!tgtdev)
+			continue;
+
+		reason_code = event_data->PortEntry[i].PortStatus;
+
+		switch (reason_code) {
+		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
+			if (tgtdev->host_exposed)
+				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_put(tgtdev);
+			break;
+		default:
+			break;
+		}
+		if (tgtdev)
+			mpi3mr_tgtdev_put(tgtdev);
+	}
+}
+
+
 /**
  * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
  * @mrioc: Adapter instance reference
@@ -868,6 +980,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 		mpi3mr_sastopochg_evt_bh(mrioc, fwevt);
 		break;
 	}
+	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
+	{
+		mpi3mr_pcietopochg_evt_bh(mrioc, fwevt);
+		break;
+	}
 	default:
 		break;
 	}
@@ -1174,6 +1291,72 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	clear_bit(cmd_idx, mrioc->devrem_bitmap);
 }
 
+/**
+ * mpi3mr_pcietopochg_evt_th - PCIETopologyChange evt tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: Event data
+ *
+ * Checks for the reason code and based on that either block I/O
+ * to device, or unblock I/O to the device, or start the device
+ * removal handshake with reason as remove with the firmware for
+ * PCIe devices.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
+	Mpi3EventNotificationReply_t *event_reply)
+{
+	Mpi3EventDataPcieTopologyChangeList_t *topo_evt =
+	    (Mpi3EventDataPcieTopologyChangeList_t *) event_reply->EventData;
+	int i;
+	u16 handle;
+	u8 reason_code;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
+
+	for (i = 0; i < topo_evt->NumEntries; i++) {
+		handle = le16_to_cpu(topo_evt->PortEntry[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		reason_code = topo_evt->PortEntry[i].PortStatus;
+		scsi_tgt_priv_data =  NULL;
+		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)
+			scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+			    tgtdev->starget->hostdata;
+		switch (reason_code) {
+		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
+			if (scsi_tgt_priv_data) {
+				scsi_tgt_priv_data->dev_removed = 1;
+				scsi_tgt_priv_data->dev_removedelay = 0;
+				atomic_set(&scsi_tgt_priv_data->block_io, 0);
+			}
+			mpi3mr_dev_rmhs_send_tm(mrioc, handle, NULL,
+			    MPI3_CTRL_OP_REMOVE_DEVICE);
+			break;
+		case MPI3_EVENT_PCIE_TOPO_PS_DELAY_NOT_RESPONDING:
+			if (scsi_tgt_priv_data) {
+				scsi_tgt_priv_data->dev_removedelay = 1;
+				atomic_inc(&scsi_tgt_priv_data->block_io);
+			}
+			break;
+		case MPI3_EVENT_PCIE_TOPO_PS_RESPONDING:
+			if (scsi_tgt_priv_data &&
+			    scsi_tgt_priv_data->dev_removedelay) {
+				scsi_tgt_priv_data->dev_removedelay = 0;
+				atomic_dec_if_positive
+				    (&scsi_tgt_priv_data->block_io);
+			}
+			break;
+		case MPI3_EVENT_PCIE_TOPO_PS_PORT_CHANGED:
+		default:
+			break;
+		}
+		if (tgtdev)
+			mpi3mr_tgtdev_put(tgtdev);
+	}
+}
+
 /**
  * mpi3mr_sastopochg_evt_th - SASTopologyChange evt tophalf
  * @mrioc: Adapter instance reference
@@ -1369,6 +1552,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		mpi3mr_sastopochg_evt_th(mrioc, event_reply);
 		break;
 	}
+	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
+	{
+		process_evt_bh = 1;
+		mpi3mr_pcietopochg_evt_th(mrioc, event_reply);
+		break;
+	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	{
 		process_evt_bh = 1;
@@ -1377,6 +1566,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_SAS_DISCOVERY:
 	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
+	case MPI3_EVENT_PCIE_ENUMERATION:
 		break;
 	default:
 		ioc_info(mrioc, "%s :Event 0x%02x is not handled\n",
@@ -1963,6 +2153,18 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
 	if (!tgt_dev)
 		return retval;
 
+	switch (tgt_dev->dev_type) {
+	case MPI3_DEVICE_DEVFORM_PCIE:
+		/*The block layer hw sector size = 512*/
+		blk_queue_max_hw_sectors(sdev->request_queue,
+		    tgt_dev->dev_spec.pcie_inf.mdts / 512);
+		blk_queue_virt_boundary(sdev->request_queue,
+		    ((1 << tgt_dev->dev_spec.pcie_inf.pgsz) - 1));
+		break;
+	default:
+		break;
+	}
+
 	mpi3mr_tgtdev_put(tgt_dev);
 
 	return retval;
-- 
2.18.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--00000000000098076405b70ad082
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg69m+hV+F
oWBhapFeZthHfwKiENPuO7nPpoMgdifgi68wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMjQwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABPk36sZcVZPe3kcIKo9aHfa/D9F
K5p5nTbNK2kMjy2FcTNve6FlX1e7si7qH/XLSVt1I5Jtfyxh3MNy71/1WNZYmKaY1lxgruvFiau2
h8q0lpqMlb6Wx3iz1vDsCf6FRa99cu3TVfvmPhdWyvJFqhKhl+yZE3s59D+AGD+vWFQ+oDBBGp76
OFpmt0FYiycW3+d5ABr24bIMApKkTTpBWgsmHTe7Vzz+3CdFpWCk+kzGNZH8oR05objDhsW92lfE
puHqcmaxR3Jont+1LKtSnK/EqcaPYcrwUBIIT3qVlNGMyE6bgqiGhe3ehGO3ilfCha4mXD5WAhn2
7ivxSw4tWNk=
--00000000000098076405b70ad082--
