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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E90AC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE62613BE
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347834AbhDGCFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344345AbhDGCFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:05:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA8DC06175F
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:05:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m11so9155952pfc.11
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0suUwaOll8wA4PeLu7cKdrq5OsiusWBLl59bIDjLcAU=;
        b=ApZB39pHimzg5gxz96XmyGi3LEeZYYSfp8pmbGbwbXwRKjTUttPDj9DXPmEoc/V7RD
         lUuUGd5Bs/WEUy5ui2wp/9fNZwnykvmfFQqAZfOrfmTjPZRuJXprG9nb4QHkxKmzleNc
         PZxGNr5svKSLYe2bK+5dnLzt8BhYdGir2BOL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0suUwaOll8wA4PeLu7cKdrq5OsiusWBLl59bIDjLcAU=;
        b=WI7YTNl7XU+A0MTTiXGm5XG5TGMj1l6JGrtXOD3PrtVugiPVMC3XG3rjZhsrt+wCFs
         pBeWRiLugv1dlrZZNQcEPIaKSYsIdNl0uGDdBuVWCIBZ6toCMS5cnJ45rEF0/9uvxBQU
         OPlpmhhLmJc6Kl+xPJbKhT0BnS0tMcgI7AYg/YTfnt/VgLy9UPNH7xlLMS1/RmL/dMhR
         FOEzrGMPZIg2QigkDzBhntgdDZw36QDAN6YFka3cOjUSWsSEe41/bJRQKa+8EFt81ebK
         4ij3T2NcLXog75s4boHK5CmKerQW7DLCd4GHVpOUzsv7gZs5iIpNkF1j6OE3eyNrm37r
         83Iw==
X-Gm-Message-State: AOAM532Rc5DYvpn/wZkayPaOr9oj1LkZNCXK7/6z/sVYAglecisjj7VW
        OvJydawaAEeaSjWtF0OxYwnSJ28JFu7PyxSejwGon0XgnYabk3YSpKeCWkr60n+kR0UNAghxZxj
        n05wg+ID0VnsaBH9qhCV7HnSID8iHVj9uuMbMlwkDBurfS2CUHduo4vwcuO46vnTN35Ve216S7B
        l2vdQQbA==
X-Google-Smtp-Source: ABdhPJzrJCyqbvPHKs41NcUf766UmHxUAmlsjoOxaOtffipLc4xokOlI9Ppo/fQmt0t8bVJZPbxYig==
X-Received: by 2002:a63:1a47:: with SMTP id a7mr1009376pgm.437.1617761106397;
        Tue, 06 Apr 2021 19:05:06 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:05:05 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 24/24] mpi3mr: add event handling debug prints
Date:   Wed,  7 Apr 2021 07:34:51 +0530
Message-Id: <20210407020451.924822-25-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001b5b4305bf585c59"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001b5b4305bf585c59

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 116 ++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 164 ++++++++++++++++++++++++++++++++
 2 files changed, 280 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 88069fbfa2bf..4c92c258ed69 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -154,6 +154,121 @@ void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
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
+		ioc_info(mrioc, "SAS Discovery: (%s) status (0x%08x) \n",
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
@@ -161,6 +276,7 @@ static void mpi3mr_handle_events(struct mpi3mr_ioc *mrioc,
 	    (Mpi3EventNotificationReply_t *)def_reply;
 
 	mrioc->change_count = le16_to_cpu(event_reply->IOCChangeCount);
+	mpi3mr_print_event_data(mrioc, event_reply);
 	mpi3mr_os_handle_events(mrioc, event_reply);
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a3610d22f67d..8df058be4d20 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1003,6 +1003,85 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 
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
@@ -1024,6 +1103,8 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PhyEntry[i].AttachedDevHandle);
 		if (!handle)
@@ -1050,6 +1131,87 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -1071,6 +1233,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_pcietopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle =
 		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
-- 
2.18.1


--0000000000001b5b4305bf585c59
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIK6zstBRi+c0wocsgG8xj6ONClAc
zhlKns/QPcqt6lQHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDUwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQC8+vgKDmsSeUYJf6SZK+HA1diweYqeQLwe0yqQE3nHn59T
x5gg3rv0swnACqvAoRq17vtimR4WJGUww0svefdPn4OxW3BpyTaw/t9Y7kFbZrgWN5bhsD4VYeqr
ueXiIj4Potds27MJh0hvnpJh02QJt8ZitMb8VttYKCBp2WUvSRPBi7KKk+Jqe0kDjhgD8/FRW9YC
KIeirJnt11UKLk/k0Vw9IlPpLlKAptplf3JVtJBEp2hAPxM3GD1G3RpGNe8zQ+h/1jdxc5aAJOAd
XaSEtsMn0liXX+DI4mShBFfAganEnXYr1kme6k6Ata1kga5sG8C2G6tyhSJI3Oez3JEI
--0000000000001b5b4305bf585c59--
