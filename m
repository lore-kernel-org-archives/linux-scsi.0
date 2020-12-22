Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A59FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD4742310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgLVKN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgLVKN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:58 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F216C061285
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:33 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id z21so8083046pgj.4
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hEDGwNNGHzL77UNQJm5Jj5QnJe6DrSKlaf2isSlRUzM=;
        b=NcZYdyGQxjtMKCpdNVeVQQ6eorBcsApZQdHIW94T5GJnpviY5UuEaqv595G+lHrbNv
         BCJLW9INbshJ+Vk9g8bclsSVa42mNwCwV8L7Q+XWG4gk0eVjYFIKrHFaQbCXYOaf6/Zx
         2NH0hLL2BzyAupbqniRengSv1HAWtZs+o71zA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=hEDGwNNGHzL77UNQJm5Jj5QnJe6DrSKlaf2isSlRUzM=;
        b=sUQXg08K6ThrHvQqVjJLI/O37xUBL/AdYXorZqlLk9my+ju4obBBYwbXDdwJZ2oZrX
         o9Q3PJSpQ1BPTxuWq533AIgUQUG9pKDjJqBLtMtDNIoAl/BMvX5rHBbWPb7isd103dIk
         9zKVeKy99Opk89WaoduEYA89v9YrzJ6gORena8D8KrGIo1F4TCyRt/PtWNR6ZR8Ga2or
         0LlejvKMGnTkgBhAw7Tsyp9GWKkKawsOOp7bi6rwHqDwVLc6dzT/ElGp2bjqq++UnZas
         zT6A17QzUCYWZ1FiGT9a1s8Ks6pADBfp5jn3g3MlMFyOranOPpyaUUWdkk2InG09Msim
         ewfw==
X-Gm-Message-State: AOAM530qv0PcyO4QU8KJFK3Kc3MN8or+7h0uqfxLnQHMMUnDzTnSm4k+
        Icdu5JqbrwfZLzrBApGfHu9eBtmqqtGCR3l7+I2VFJLlW1GlS3KYgRO2V6Utds1WjRgOWCwwMHz
        uwqboCbLdv4FmxmMxTRJadrWgptxs9CgeNTMmsI/AKTBguQPjI6xoJ57BZ2p/0r1b5poHUFL5rc
        jQD/xtxy6J
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJy6tIVKOnO2LvL3laY3ga9CARh3n1xsg3q5mISqiU+7zAtfyR7OrWagkoR3OmUBzZPt40VmVw==
X-Received: by 2002:a65:434c:: with SMTP id k12mr17703612pgq.373.1608632012160;
        Tue, 22 Dec 2020 02:13:32 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:13:31 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 24/24] mpi3mr: add event handling debug prints
Date:   Tue, 22 Dec 2020 15:41:56 +0530
Message-Id: <20201222101156.98308-25-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b09cc005b70ad369"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b09cc005b70ad369
Content-Type: text/plain; charset="US-ASCII"

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 119 +++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 164 ++++++++++++++++++++++++++++++++
 2 files changed, 283 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8ce715b139f2..283444901034 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -154,6 +154,124 @@ void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
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
+		ioc_info(mrioc, "SAS Discovery: (%s)",
+		    (event_data->ReasonCode == MPI3_EVENT_SAS_DISC_RC_STARTED) ?
+		    "start" : "stop");
+		if (event_data->DiscoveryStatus)
+			pr_cont("discovery_status(0x%08x)",
+			    le32_to_cpu(event_data->DiscoveryStatus));
+		pr_cont("\n");
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
@@ -161,6 +279,7 @@ static void mpi3mr_handle_events(struct mpi3mr_ioc *mrioc,
 	    (Mpi3EventNotificationReply_t *)def_reply;
 
 	mrioc->change_count = le16_to_cpu(event_reply->IOCChangeCount);
+	mpi3mr_print_event_data(mrioc, event_reply);
 	mpi3mr_os_handle_events(mrioc, event_reply);
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 425659e8f7b4..f744c4980b6e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1006,6 +1006,85 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 
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
@@ -1027,6 +1106,8 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PhyEntry[i].AttachedDevHandle);
 		if (!handle)
@@ -1053,6 +1134,87 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
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
@@ -1074,6 +1236,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_pcietopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle =
 		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
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

--000000000000b09cc005b70ad369
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgh+fdEmRA
/JJvXjaYMtgErgGscWsNqTF4Db1dU5GcQa0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMzMyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAE2h+WGiUayru0dahAQocPnyt//j
nuIAAdaL6A6glF38Rd+fSg0k7qfYnLehUWWGKtZsIEINBUHyiDhTVacRdD5OE4riltxArJOzBPPZ
q1dqZ37+qmIGpt9/uUNHKQXtIjc6M/xuE0PEiHmtu6JAFeNOReghaPrpsxgkO24m8CCNxQR2tOvp
+IbeaDunQPCH3Hu7D11tzqTqdvqdEWPdpFEsQn2eZ0bFSCus7xJvSgARt79m1mwEwvUnvXqJyDha
oVJbjvaRTHv/lfsUIEtbpEivkM1fwpKZKjoSzIpBl8nDl8+De1Yefa/nMwkWXX1yC3e1GjRwwr1e
QGMlx8C37zE=
--000000000000b09cc005b70ad369--
