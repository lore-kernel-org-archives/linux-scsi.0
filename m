Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED35AC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA8B61279
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbhDSLDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238615AbhDSLDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 07:03:42 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B413BC06174A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:03:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s22so2893871pgk.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bHAd3oBacbrmBLm20k3r2//p3Vu4GiJRJqPRSCI537U=;
        b=UXCUo0OICo1GgKzxKDawZqeoR6z+nCn2dyKLoDUidQQbG7rMOkXBWXjErg2cPesiys
         AwSrhNElbiDBzT//GMpD7JJom05nUUdOxCt+JtmP76pgaBSst/gY9+SortlzBUU0WV7W
         eRbdBP6AO4AMw4GMKHhP2Dw1vtSmfmjiAsLNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bHAd3oBacbrmBLm20k3r2//p3Vu4GiJRJqPRSCI537U=;
        b=aT+K6ZO7lWVmYuGoGYLNK7/xWqCP/MzPo+McP1+b+FdvkEl0/RRPL+QOlOQl877gMN
         stza99H2rUbK9WqOMf3PZQbbV84cKJDVg2zd8EAuEovNi2B/kdRNIgOErf4Wy1fSZTd0
         lTcsKdAUoAIUhBX94AT89weIwtbgLIaFUMmAEau5LFrJUyYDStzMGTvB9fYdcVBwym2v
         bFhtGO+oAsRzBwRBrtj0+sBeL7ggryJzw+DvDGms5okguOCx6J9GBB3Qt5crHh3n7uJ5
         qJec2gv0MX4WKmacTKayy5gKDquU1AO2sR3Qz4WzEiVNUytLDpEOzLtOIdtDF7iMYLw4
         aToQ==
X-Gm-Message-State: AOAM5320eMcraTIPLB5RUw05+pRmm5wnULbVRTfH7VwVxzR5mwYdnARG
        gkoKWZbnwjKxIWd+VNLAPc5fNTyy9PlQmT3Px5tHtFwNm47+YeS+H5T4dt2wAxQI4njNdL6v0ED
        jeDwC+KFlYoM/kgMkmcYsZS/Q5J2jaGusUwyk8hnIi8BEqFbQDdaGqe03gE2JuOrQ9lFCOOnKIt
        xdZ1X4SN8P
X-Google-Smtp-Source: ABdhPJye+Esymo14Z2xwtGHNQ9n1CSkYLNGj2wYijLkcNEdUBaXei502gYKCHEcHsVQ+nVTZlIKJDA==
X-Received: by 2002:a62:808b:0:b029:252:eddc:afb0 with SMTP id j133-20020a62808b0000b0290252eddcafb0mr19993691pfd.41.1618830190797;
        Mon, 19 Apr 2021 04:03:10 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k13sm11825736pfc.50.2021.04.19.04.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 04:03:09 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v3 24/24] mpi3mr: add event handling debug prints
Date:   Mon, 19 Apr 2021 16:31:56 +0530
Message-Id: <20210419110156.1786882-25-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000806d3c05c051467a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000806d3c05c051467a

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 116 ++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 164 ++++++++++++++++++++++++++++++++
 2 files changed, 280 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index ee20d63f6061..b8c3ae98e5f3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -155,6 +155,121 @@ void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
 	spin_unlock(&mrioc->sbq_lock);
 }
 
+
+static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
+	Mpi3EventNotificationReply_t *event_reply)
+{
+	char *desc = NULL;
+	u16 event;
+
+	event = event_reply->Event;
+
+	switch (event) {
+	case MPI3_EVENT_LOG_DATA:
+		desc = "Log Data";
+		break;
+	case MPI3_EVENT_CHANGE:
+		desc = "Event Change";
+		break;
+	case MPI3_EVENT_GPIO_INTERRUPT:
+		desc = "GPIO Interrupt";
+		break;
+	case MPI3_EVENT_TEMP_THRESHOLD:
+		desc = "Temperature Threshold";
+		break;
+	case MPI3_EVENT_CABLE_MGMT:
+		desc = "Cable Management";
+		break;
+	case MPI3_EVENT_ENERGY_PACK_CHANGE:
+		desc = "Energy Pack Change";
+		break;
+	case MPI3_EVENT_DEVICE_ADDED:
+	{
+		Mpi3DevicePage0_t *event_data =
+		    (Mpi3DevicePage0_t *)event_reply->EventData;
+		ioc_info(mrioc, "Device Added: Dev=0x%04x Form=0x%x\n",
+		    event_data->DevHandle, event_data->DeviceForm);
+		return;
+	}
+	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	{
+		Mpi3DevicePage0_t *event_data =
+		    (Mpi3DevicePage0_t *)event_reply->EventData;
+		ioc_info(mrioc, "Device Info Changed: Dev=0x%04x Form=0x%x\n",
+		    event_data->DevHandle, event_data->DeviceForm);
+		return;
+	}
+	case MPI3_EVENT_DEVICE_STATUS_CHANGE:
+	{
+		Mpi3EventDataDeviceStatusChange_t *event_data =
+		    (Mpi3EventDataDeviceStatusChange_t *)event_reply->EventData;
+		ioc_info(mrioc, "Device Status Change: Dev=0x%04x RC=0x%x\n",
+		    event_data->DevHandle, event_data->ReasonCode);
+		return;
+	}
+	case MPI3_EVENT_SAS_DISCOVERY:
+	{
+		Mpi3EventDataSasDiscovery_t *event_data =
+		    (Mpi3EventDataSasDiscovery_t *)event_reply->EventData;
+		ioc_info(mrioc, "SAS Discovery: (%s) status (0x%08x)\n",
+		    (event_data->ReasonCode == MPI3_EVENT_SAS_DISC_RC_STARTED) ?
+		    "start" : "stop",
+		    le32_to_cpu(event_data->DiscoveryStatus));
+		return;
+	}
+	case MPI3_EVENT_SAS_BROADCAST_PRIMITIVE:
+		desc = "SAS Broadcast Primitive";
+		break;
+	case MPI3_EVENT_SAS_NOTIFY_PRIMITIVE:
+		desc = "SAS Notify Primitive";
+		break;
+	case MPI3_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE:
+		desc = "SAS Init Device Status Change";
+		break;
+	case MPI3_EVENT_SAS_INIT_TABLE_OVERFLOW:
+		desc = "SAS Init Table Overflow";
+		break;
+	case MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
+		desc = "SAS Topology Change List";
+		break;
+	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
+		desc = "Enclosure Device Status Change";
+		break;
+	case MPI3_EVENT_HARD_RESET_RECEIVED:
+		desc = "Hard Reset Received";
+		break;
+	case MPI3_EVENT_SAS_PHY_COUNTER:
+		desc = "SAS PHY Counter";
+		break;
+	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
+		desc = "SAS Device Discovery Error";
+		break;
+	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
+		desc = "PCIE Topology Change List";
+		break;
+	case MPI3_EVENT_PCIE_ENUMERATION:
+	{
+		Mpi3EventDataPcieEnumeration_t *event_data =
+		    (Mpi3EventDataPcieEnumeration_t *)event_reply->EventData;
+		ioc_info(mrioc, "PCIE Enumeration: (%s)",
+		    (event_data->ReasonCode ==
+		    MPI3_EVENT_PCIE_ENUM_RC_STARTED) ? "start" : "stop");
+		if (event_data->EnumerationStatus)
+			ioc_info(mrioc, "enumeration_status(0x%08x)\n",
+			    le32_to_cpu(event_data->EnumerationStatus));
+		return;
+	}
+	case MPI3_EVENT_PREPARE_FOR_RESET:
+		desc = "Prepare For Reset";
+		break;
+	}
+
+	if (!desc)
+		return;
+
+	ioc_info(mrioc, "%s\n", desc);
+}
+
 static void mpi3mr_handle_events(struct mpi3mr_ioc *mrioc,
 	Mpi3DefaultReply_t *def_reply)
 {
@@ -162,6 +277,7 @@ static void mpi3mr_handle_events(struct mpi3mr_ioc *mrioc,
 	    (Mpi3EventNotificationReply_t *)def_reply;
 
 	mrioc->change_count = le16_to_cpu(event_reply->IOCChangeCount);
+	mpi3mr_print_event_data(mrioc, event_reply);
 	mpi3mr_os_handle_events(mrioc, event_reply);
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 9a189fb32ab0..2cef7403f941 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1005,6 +1005,85 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 
 }
 
+/**
+ * mpi3mr_sastopochg_evt_debug - SASTopoChange details
+ * @mrioc: Adapter instance reference
+ * @event_data: SAS topology change list event data
+ *
+ * Prints information about the SAS topology change event.
+ *
+ * Return: Nothing.
+ */
+static void
+mpi3mr_sastopochg_evt_debug(struct mpi3mr_ioc *mrioc,
+	Mpi3EventDataSasTopologyChangeList_t *event_data)
+{
+	int i;
+	u16 handle;
+	u8 reason_code, phy_number;
+	char *status_str = NULL;
+	u8 link_rate, prev_link_rate;
+
+	switch (event_data->ExpStatus) {
+	case MPI3_EVENT_SAS_TOPO_ES_NOT_RESPONDING:
+		status_str = "remove";
+		break;
+	case MPI3_EVENT_SAS_TOPO_ES_RESPONDING:
+		status_str =  "responding";
+		break;
+	case MPI3_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING:
+		status_str = "remove delay";
+		break;
+	case MPI3_EVENT_SAS_TOPO_ES_NO_EXPANDER:
+		status_str = "direct attached";
+		break;
+	default:
+		status_str = "unknown status";
+		break;
+	}
+	ioc_info(mrioc, "%s :sas topology change: (%s)\n",
+	    __func__, status_str);
+	ioc_info(mrioc,
+	    "%s :\texpander_handle(0x%04x), enclosure_handle(0x%04x) start_phy(%02d), num_entries(%d)\n",
+	    __func__, le16_to_cpu(event_data->ExpanderDevHandle),
+	    le16_to_cpu(event_data->EnclosureHandle),
+	    event_data->StartPhyNum, event_data->NumEntries);
+	for (i = 0; i < event_data->NumEntries; i++) {
+		handle = le16_to_cpu(event_data->PhyEntry[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		phy_number = event_data->StartPhyNum + i;
+		reason_code = event_data->PhyEntry[i].Status &
+		    MPI3_EVENT_SAS_TOPO_PHY_RC_MASK;
+		switch (reason_code) {
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
+			status_str = "target remove";
+			break;
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_DELAY_NOT_RESPONDING:
+			status_str = "delay target remove";
+			break;
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED:
+			status_str = "link status change";
+			break;
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_NO_CHANGE:
+			status_str = "link status no change";
+			break;
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
+			status_str = "target responding";
+			break;
+		default:
+			status_str = "unknown";
+			break;
+		}
+		link_rate = event_data->PhyEntry[i].LinkRate >> 4;
+		prev_link_rate = event_data->PhyEntry[i].LinkRate & 0xF;
+		ioc_info(mrioc,
+		    "%s :\tphy(%02d), attached_handle(0x%04x): %s: link rate: new(0x%02x), old(0x%02x)\n",
+		    __func__, phy_number, handle, status_str, link_rate,
+		    prev_link_rate);
+	}
+}
+
 /**
  * mpi3mr_sastopochg_evt_bh - SASTopologyChange evt bottomhalf
  * @mrioc: Adapter instance reference
@@ -1026,6 +1105,8 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PhyEntry[i].AttachedDevHandle);
 		if (!handle)
@@ -1052,6 +1133,87 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+/**
+ * mpi3mr_pcietopochg_evt_debug - PCIeTopoChange details
+ * @mrioc: Adapter instance reference
+ * @event_data: PCIe topology change list event data
+ *
+ * Prints information about the PCIe topology change event.
+ *
+ * Return: Nothing.
+ */
+static void
+mpi3mr_pcietopochg_evt_debug(struct mpi3mr_ioc *mrioc,
+	Mpi3EventDataPcieTopologyChangeList_t *event_data)
+{
+	int i;
+	u16 handle;
+	u16 reason_code;
+	u8 port_number;
+	char *status_str = NULL;
+	u8 link_rate, prev_link_rate;
+
+	switch (event_data->SwitchStatus) {
+	case MPI3_EVENT_PCIE_TOPO_SS_NOT_RESPONDING:
+		status_str = "remove";
+		break;
+	case MPI3_EVENT_PCIE_TOPO_SS_RESPONDING:
+		status_str =  "responding";
+		break;
+	case MPI3_EVENT_PCIE_TOPO_SS_DELAY_NOT_RESPONDING:
+		status_str = "remove delay";
+		break;
+	case MPI3_EVENT_PCIE_TOPO_SS_NO_PCIE_SWITCH:
+		status_str = "direct attached";
+		break;
+	default:
+		status_str = "unknown status";
+		break;
+	}
+	ioc_info(mrioc, "%s :pcie topology change: (%s)\n",
+	    __func__, status_str);
+	ioc_info(mrioc,
+	    "%s :\tswitch_handle(0x%04x), enclosure_handle(0x%04x) start_port(%02d), num_entries(%d)\n",
+	    __func__, le16_to_cpu(event_data->SwitchDevHandle),
+	    le16_to_cpu(event_data->EnclosureHandle),
+	    event_data->StartPortNum, event_data->NumEntries);
+	for (i = 0; i < event_data->NumEntries; i++) {
+		handle =
+		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		port_number = event_data->StartPortNum + i;
+		reason_code = event_data->PortEntry[i].PortStatus;
+		switch (reason_code) {
+		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
+			status_str = "target remove";
+			break;
+		case MPI3_EVENT_PCIE_TOPO_PS_DELAY_NOT_RESPONDING:
+			status_str = "delay target remove";
+			break;
+		case MPI3_EVENT_PCIE_TOPO_PS_PORT_CHANGED:
+			status_str = "link status change";
+			break;
+		case MPI3_EVENT_PCIE_TOPO_PS_NO_CHANGE:
+			status_str = "link status no change";
+			break;
+		case MPI3_EVENT_PCIE_TOPO_PS_RESPONDING:
+			status_str = "target responding";
+			break;
+		default:
+			status_str = "unknown";
+			break;
+		}
+		link_rate = event_data->PortEntry[i].CurrentPortInfo &
+		    MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK;
+		prev_link_rate = event_data->PortEntry[i].PreviousPortInfo &
+		    MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK;
+		ioc_info(mrioc,
+		    "%s :\tport(%02d), attached_handle(0x%04x): %s: link rate: new(0x%02x), old(0x%02x)\n",
+		    __func__, port_number, handle, status_str, link_rate,
+		    prev_link_rate);
+	}
+}
 /**
  * mpi3mr_pcietopochg_evt_bh - PCIeTopologyChange evt bottomhalf
  * @mrioc: Adapter instance reference
@@ -1073,6 +1235,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_pcietopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle =
 		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
-- 
2.18.1


--000000000000806d3c05c051467a
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHEoNZLNruWDksGBY4ok8CIMymGR
TAILT8V75XfqFdmHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTExMDMxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQB1N4QBB84FHZB2Bl6PFfxkd6SqnyYR01XtGTT9Q1jjN6I0
utfFATyNPta1kjHYQXmH3vaDbOhlFf1g+dwzfV/rJFBBI9WhmOhm2xDq9nyGqFGGy/3dF+FGhCPz
luDa5YStMbPMoIRNARPzLrVdPeMZwbRs1GHMmG9Ye4tHxhK439d/I7n6h5YB5g705pJgIup26INh
+DvzfRRt3U0FKzvftJt2d7JAAVhJt7PNoHu64gIC4TqxYwCVSO+BXLpYjVx3ReWQIQHmbhgCh73c
5eApXKUMdR1aDqGT5zPkhDcWbSnvsgRlRhUY1JtdjZvw4jHNiR/KmV6v9gjWAGo+WZYb
--000000000000806d3c05c051467a--
