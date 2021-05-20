Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385F8C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B9361057
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243163AbhETPXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 11:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241363AbhETPXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 11:23:04 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABF9C06138A
        for <linux-scsi@vger.kernel.org>; Thu, 20 May 2021 08:21:42 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t30so12079061pgl.8
        for <linux-scsi@vger.kernel.org>; Thu, 20 May 2021 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6RZj3WGjul0XK0jnoV1rZ+8EtbCoDIgxgrr3hg8B1N4=;
        b=RBZedbU4gM6DWKU09eVRDGKkcFZc3nHO3etGokxkXqRTvoeVu82aCh5QgtTZ8Lvlj3
         yDLysrY+1tOJFynYlCeCV/AdjlJWhqPS+2CHnhYJubqaDnjcICD6stHRlPreryKNESTq
         8Q6LIK/qKl731MUKbgyGCdKcW0IhRV6BZBkjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6RZj3WGjul0XK0jnoV1rZ+8EtbCoDIgxgrr3hg8B1N4=;
        b=g+L/GadJgD1N8tEwjLtydlLc13ZctAKvw8tj6Ro1R7GMyT8c1OpmqbB0QwRM1CynNl
         ERQjW7gM4GjvpUrpT3BjhJCXsy7pG+5YZiFGzayr4aZv9JizDFEVEx48vC3NTX5l4Sgx
         RP8BEWSX9NytwbrA+qDC63ZX4/MrDK7HtNoYmxU5kVMsBD/1apZ3jGq0fQK7+q6beajJ
         zX+VXxAZ5rDh1A1CO7GscX0nPg3rrFj+7HdaASH+pUPzjUhKs5a5n6ju71nzhgR5kxYS
         A5EWBN95f+95WbGsSI+KSWhDv41432HU+2K1h+eAURGSrwf/MopPiiv/eQAAASaPCQ/q
         617w==
X-Gm-Message-State: AOAM532nM5o6UH6lyAtUAX9fD8nynFoETJsg48AY0opSzdvzFrA/8+jl
        LkdOTOHqTrjXPOwI2vF1eZp/9dyylOap46t3QwTsGtuAfBSOSYvMr0xQ7cqyGzjXrJCrZIDQ08m
        BCiWXmcsgrUcjiCZL8Db5krvMth1nBeU5Qkaex9qVZxxrcLRYYs9I/Dciifx1HKoare/8t4PGQM
        3XeRDHkQ==
X-Google-Smtp-Source: ABdhPJyZaphHktD86DDElkZnWWAd/kVuE5g9elKGhhI+RSyDL8JLdRTOu7yNnuyUYFKvIDIqNhQt5Q==
X-Received: by 2002:a62:81c5:0:b029:2d9:367b:b84a with SMTP id t188-20020a6281c50000b02902d9367bb84amr5291681pfd.32.1621524101938;
        Thu, 20 May 2021 08:21:41 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id s8sm2250557pfe.112.2021.05.20.08.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 08:21:41 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v6 07/24] mpi3mr: add support of event handling pcie devices part-2
Date:   Thu, 20 May 2021 20:55:28 +0530
Message-Id: <20210520152545.2710479-8-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
References: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001ea5d005c2c480d5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001ea5d005c2c480d5

Firmware can report various MPI Events.
Support for certain Events (as listed below) are enabled in the driver
and their processing in driver is covered in this patch.

MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST
MPI3_EVENT_PCIE_ENUMERATION

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   2 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 201 ++++++++++++++++++++++++++++++++
 2 files changed, 203 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0158a7b..6dd0869 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2728,6 +2728,8 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
 
 	retval = mpi3mr_issue_event_notification(mrioc);
 	if (retval) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8c299e8..47f179d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -562,6 +562,40 @@ out:
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
+	tgtdev = (struct mpi3mr_tgt_dev *)data;
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
@@ -650,6 +684,33 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 			tgtdev->is_hidden = 1;
 		break;
 	}
+	case MPI3_DEVICE_DEVFORM_PCIE:
+	{
+		struct mpi3_device0_pcie_format *pcieinf =
+		    &dev_pg0->device_specific.pcie_format;
+		u16 dev_info = le16_to_cpu(pcieinf->device_info);
+
+		tgtdev->dev_spec.pcie_inf.capb =
+		    le32_to_cpu(pcieinf->capabilities);
+		tgtdev->dev_spec.pcie_inf.mdts = MPI3MR_DEFAULT_MDTS;
+		/* 2^12 = 4096 */
+		tgtdev->dev_spec.pcie_inf.pgsz = 12;
+		if (dev_pg0->access_status == MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
+			tgtdev->dev_spec.pcie_inf.mdts =
+			    le32_to_cpu(pcieinf->maximum_data_transfer_size);
+			tgtdev->dev_spec.pcie_inf.pgsz = pcieinf->page_size;
+			tgtdev->dev_spec.pcie_inf.reset_to =
+			    pcieinf->controller_reset_to;
+			tgtdev->dev_spec.pcie_inf.abort_to =
+			    pcieinf->nv_me_abort_to;
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
 		struct mpi3_device0_vd_format *vdinf =
@@ -759,6 +820,9 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
 	if (tgtdev->is_hidden && tgtdev->host_exposed)
 		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+	if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev->starget)
+		starget_for_each_device(tgtdev->starget, (void *)tgtdev,
+		    mpi3mr_update_sdev);
 out:
 	if (tgtdev)
 		mpi3mr_tgtdev_put(tgtdev);
@@ -811,6 +875,53 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
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
+	struct mpi3_event_data_pcie_topology_change_list *event_data =
+	    (struct mpi3_event_data_pcie_topology_change_list *)fwevt->event_data;
+	int i;
+	u16 handle;
+	u8 reason_code;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+
+	for (i = 0; i < event_data->num_entries; i++) {
+		handle =
+		    le16_to_cpu(event_data->port_entry[i].attached_dev_handle);
+		if (!handle)
+			continue;
+		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+		if (!tgtdev)
+			continue;
+
+		reason_code = event_data->port_entry[i].port_status;
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
 /**
  * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
  * @mrioc: Adapter instance reference
@@ -858,6 +969,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -1161,6 +1277,72 @@ out_failed:
 	clear_bit(cmd_idx, mrioc->devrem_bitmap);
 }
 
+/**
+ * mpi3mr_pcietopochg_evt_th - PCIETopologyChange evt tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: event data
+ *
+ * Checks for the reason code and based on that either block I/O
+ * to device, or unblock I/O to the device, or start the device
+ * removal handshake with reason as remove with the firmware for
+ * PCIe devices.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
+	struct mpi3_event_notification_reply *event_reply)
+{
+	struct mpi3_event_data_pcie_topology_change_list *topo_evt =
+	    (struct mpi3_event_data_pcie_topology_change_list *)event_reply->event_data;
+	int i;
+	u16 handle;
+	u8 reason_code;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
+
+	for (i = 0; i < topo_evt->num_entries; i++) {
+		handle = le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
+		if (!handle)
+			continue;
+		reason_code = topo_evt->port_entry[i].port_status;
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
@@ -1354,6 +1536,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
@@ -1362,6 +1550,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_SAS_DISCOVERY:
 	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
+	case MPI3_EVENT_PCIE_ENUMERATION:
 		break;
 	default:
 		ioc_info(mrioc, "%s :event 0x%02x is not handled\n",
@@ -1934,6 +2123,18 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
 	if (!tgt_dev)
 		return -ENXIO;
 
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


--0000000000001ea5d005c2c480d5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIc/GU4RZU35V0FrHQxKWLbym8jO
clx21ideM34bl2kUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUyMDE1MjE0MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQC/It0LlnqEKhSdIHl25RIDQdokKp8YGNwHa/zRIbm95ITH
NV6HorDGy1klpp/nSff3rVaJCqBvrcd15CTUbci8K48UDzl0obXcBNX+C2sixdfDDmDi4Lmz82JK
0Xfopvhf8ws9xlAQ3dn5rsF+nmSCZ/Is0TbI2TooSFYZPgkmPAzwA29XTXE8EHcnTTCQrDm20GDB
Vdo6NvYKbjwhbP1ad+pFD2YVzj/wxF9sJWSmcDTvKQRjkej+MY6vfdZoJeUwr+5wbGD+embvzDz5
N2HyXjiNHDwxg/+D1LMNnsoTDIBn9VJXif9WB6vFSSoidVAZ/l+eNVXkkAlU/UOyVTvI
--0000000000001ea5d005c2c480d5--
