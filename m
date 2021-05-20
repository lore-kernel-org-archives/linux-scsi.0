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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1688AC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD6761355
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhETPYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243790AbhETPX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 11:23:56 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C508EC06138B
        for <linux-scsi@vger.kernel.org>; Thu, 20 May 2021 08:22:34 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m190so12101697pga.2
        for <linux-scsi@vger.kernel.org>; Thu, 20 May 2021 08:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ORvIgcfwv13oV5ifJFKf30zp/d5Ttav6uAnai8ucgtk=;
        b=DKPCeuMaVa6UbKKJXnmPxNiMLlWlwIQQpoqZUXbNyC96+FqffZQ7q2FCdEeZbEcotB
         UnoGqPprPx81xH7Sw6XYPFroSZHc1jfcjTQKPJ0ZRpgIvqMW6IsaWAsBcg6Oad/eMVqp
         SudUtjyMW5JeSTUgja5keQprjqWed1ASM7/Hg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ORvIgcfwv13oV5ifJFKf30zp/d5Ttav6uAnai8ucgtk=;
        b=C2kSdOKkbkQJBU46Zp5akVr3+GTPMN2qO+LE7AF6A4UAaihs14QdVJRZp9rG7xCYzM
         yVothH3XftSUlCN4MO28Z1r7cp9UHISRTwmqzHXXoFcN61M9dT49qmMQO1ubntbgDTnY
         YO8X2T/qFUcvGL/gMw4OSrNNy+UqAtjW0+CyDY8z6zPbzgrIIlkULijJVgTkjbUDDdn7
         dO7Zz1VwnMBYRJ3nEAvPDxsAnJ8Y0oseo0buypIpN68rI2kpoCsPYVYmBI9zrf76+OT2
         EFV2p+cOGqqK/ajEkQhJ6GkYVbBXs+J33GClw6WRomVs0tvHjRQLNR0+Y/OOFK1d1REa
         UqPA==
X-Gm-Message-State: AOAM531JAqDD82feo7ztOaTmQl5hI3S4EqoYD068BLFv/V60DJ0xd1qX
        RRXG3TQ3gNV7lKlR0L87XdGF/FVDK4o9BJTllWDyETlLHDLMQONxeuPDhsBdukyRppEgemDYbMc
        bW1mZpLFFe2Nap6M+qCmBuEczQo8y0Ob4iW/eSsBkGxZOBFL4ffi7ynayWzNofDxtZeFFdenfzw
        scIhDzkQ==
X-Google-Smtp-Source: ABdhPJwEx611thdfLI0ClPsLuPC+deQ8HOl6kVKsIa6nynWn7vctBSpOrzv6UPK+hpMsWyoViI7Qyg==
X-Received: by 2002:a63:104a:: with SMTP id 10mr5150186pgq.66.1621524153631;
        Thu, 20 May 2021 08:22:33 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id s8sm2250557pfe.112.2021.05.20.08.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 08:22:33 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v6 24/24] mpi3mr: add event handling debug prints
Date:   Thu, 20 May 2021 20:55:45 +0530
Message-Id: <20210520152545.2710479-25-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
References: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000034b15605c2c48350"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000034b15605c2c48350

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 115 ++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 166 +++++++++++++++++++++++++++++++-
 2 files changed, 280 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4b4b811..acb2be6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -154,6 +154,120 @@ void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
 	spin_unlock(&mrioc->sbq_lock);
 }
 
+static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
+	struct mpi3_event_notification_reply *event_reply)
+{
+	char *desc = NULL;
+	u16 event;
+
+	event = event_reply->event;
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
+		struct mpi3_device_page0 *event_data =
+		    (struct mpi3_device_page0 *)event_reply->event_data;
+		ioc_info(mrioc, "Device Added: dev=0x%04x Form=0x%x\n",
+		    event_data->dev_handle, event_data->device_form);
+		return;
+	}
+	case MPI3_EVENT_DEVICE_INFO_CHANGED:
+	{
+		struct mpi3_device_page0 *event_data =
+		    (struct mpi3_device_page0 *)event_reply->event_data;
+		ioc_info(mrioc, "Device Info Changed: dev=0x%04x Form=0x%x\n",
+		    event_data->dev_handle, event_data->device_form);
+		return;
+	}
+	case MPI3_EVENT_DEVICE_STATUS_CHANGE:
+	{
+		struct mpi3_event_data_device_status_change *event_data =
+		    (struct mpi3_event_data_device_status_change *)event_reply->event_data;
+		ioc_info(mrioc, "Device status Change: dev=0x%04x RC=0x%x\n",
+		    event_data->dev_handle, event_data->reason_code);
+		return;
+	}
+	case MPI3_EVENT_SAS_DISCOVERY:
+	{
+		struct mpi3_event_data_sas_discovery *event_data =
+		    (struct mpi3_event_data_sas_discovery *)event_reply->event_data;
+		ioc_info(mrioc, "SAS Discovery: (%s) status (0x%08x)\n",
+		    (event_data->reason_code == MPI3_EVENT_SAS_DISC_RC_STARTED) ?
+		    "start" : "stop",
+		    le32_to_cpu(event_data->discovery_status));
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
+		struct mpi3_event_data_pcie_enumeration *event_data =
+		    (struct mpi3_event_data_pcie_enumeration *)event_reply->event_data;
+		ioc_info(mrioc, "PCIE Enumeration: (%s)",
+		    (event_data->reason_code ==
+		    MPI3_EVENT_PCIE_ENUM_RC_STARTED) ? "start" : "stop");
+		if (event_data->enumeration_status)
+			ioc_info(mrioc, "enumeration_status(0x%08x)\n",
+			    le32_to_cpu(event_data->enumeration_status));
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
 	struct mpi3_default_reply *def_reply)
 {
@@ -161,6 +275,7 @@ static void mpi3mr_handle_events(struct mpi3mr_ioc *mrioc,
 	    (struct mpi3_event_notification_reply *)def_reply;
 
 	mrioc->change_count = le16_to_cpu(event_reply->ioc_change_count);
+	mpi3mr_print_event_data(mrioc, event_reply);
 	mpi3mr_os_handle_events(mrioc, event_reply);
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 9969780..836a27c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -995,6 +995,85 @@ out:
 		mpi3mr_tgtdev_put(tgtdev);
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
+	struct mpi3_event_data_sas_topology_change_list *event_data)
+{
+	int i;
+	u16 handle;
+	u8 reason_code, phy_number;
+	char *status_str = NULL;
+	u8 link_rate, prev_link_rate;
+
+	switch (event_data->exp_status) {
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
+	    __func__, le16_to_cpu(event_data->expander_dev_handle),
+	    le16_to_cpu(event_data->enclosure_handle),
+	    event_data->start_phy_num, event_data->num_entries);
+	for (i = 0; i < event_data->num_entries; i++) {
+		handle = le16_to_cpu(event_data->phy_entry[i].attached_dev_handle);
+		if (!handle)
+			continue;
+		phy_number = event_data->start_phy_num + i;
+		reason_code = event_data->phy_entry[i].status &
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
+		link_rate = event_data->phy_entry[i].link_rate >> 4;
+		prev_link_rate = event_data->phy_entry[i].link_rate & 0xF;
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
@@ -1016,6 +1095,8 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->num_entries; i++) {
 		handle = le16_to_cpu(event_data->phy_entry[i].attached_dev_handle);
 		if (!handle)
@@ -1042,6 +1123,88 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
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
+	struct mpi3_event_data_pcie_topology_change_list *event_data)
+{
+	int i;
+	u16 handle;
+	u16 reason_code;
+	u8 port_number;
+	char *status_str = NULL;
+	u8 link_rate, prev_link_rate;
+
+	switch (event_data->switch_status) {
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
+	    __func__, le16_to_cpu(event_data->switch_dev_handle),
+	    le16_to_cpu(event_data->enclosure_handle),
+	    event_data->start_port_num, event_data->num_entries);
+	for (i = 0; i < event_data->num_entries; i++) {
+		handle =
+		    le16_to_cpu(event_data->port_entry[i].attached_dev_handle);
+		if (!handle)
+			continue;
+		port_number = event_data->start_port_num + i;
+		reason_code = event_data->port_entry[i].port_status;
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
+		link_rate = event_data->port_entry[i].current_port_info &
+		    MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK;
+		prev_link_rate = event_data->port_entry[i].previous_port_info &
+		    MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK;
+		ioc_info(mrioc,
+		    "%s :\tport(%02d), attached_handle(0x%04x): %s: link rate: new(0x%02x), old(0x%02x)\n",
+		    __func__, port_number, handle, status_str, link_rate,
+		    prev_link_rate);
+	}
+}
+
 /**
  * mpi3mr_pcietopochg_evt_bh - PCIeTopologyChange evt bottomhalf
  * @mrioc: Adapter instance reference
@@ -1063,6 +1226,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	u8 reason_code;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 
+	mpi3mr_pcietopochg_evt_debug(mrioc, event_data);
+
 	for (i = 0; i < event_data->num_entries; i++) {
 		handle =
 		    le16_to_cpu(event_data->port_entry[i].attached_dev_handle);
@@ -1899,7 +2064,6 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
 	scsiio_req->sgl[0].eedp.flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_EXTENDED;
 }
 
-
 /**
  * mpi3mr_build_sense_buffer - Map sense information
  * @desc: Sense type
-- 
2.18.1


--00000000000034b15605c2c48350
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOh//VrLM49tYArB4GP0Ybc9i0z1
rJDTFjGnuJ9o5yYMMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUyMDE1MjIzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAgOz8esbKLkd/jNoRO9hyaZy42asLSnrOfl/nCUsO5fYW+
segvjDxwCPuDYrLEvgsHYNn5VW9t0COZshPoGIo8V+bScOJa1skddlOSkjPuncvkxfOq9dKykI2D
E3Dn3xi0yftwcdWV4RlcCSEDti1eNQezlRRl7oINeZE36lBOPhdtDWhHC1mgNAn3YpjnjdpqzOZG
yQrlBFFc0UkLKS8hn4K0L3kk3WKf/VbgPPkYoCGzIrpC157EBJk3HHW2DzR0V39C7nJlcKFVb9bn
mLTY4+Tmmbsyzq0Y8IskOufGXdVodzXZUojyEbBGQYIM3JlNeohOgRHKj/w5H+7se/WL
--00000000000034b15605c2c48350--
