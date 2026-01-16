Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E979A34CFAD
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544044; cv=none; b=MfyrlPmx+4t7dJK6kfCaYc9KUfy4fraZufplDGoS+rY5o5e4US5lCTxlrL8To2TxVnGiP9qwEAKUouRTV7D4edUTsrK1r+4qg/AsyGLJo/4DgrQ5Guvyuu9oj5EltbBxdNGLDprTYcXBpS9KPrWJXl0rQriyllyQBwmYPzxPNwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544044; c=relaxed/simple;
	bh=Mq8LanackT7+DHWWCUCixX/OQl6tB/IQdY4t5heQO6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wb3uy4D9GQlU40OcysWSuz4CbUZGeuOLPp0EpD9Ms7PDODSv4dxTEtMI3uY4KoGR68XMsjglKXWmeuCWL53vC63SmbnA4eCmqP46w2rnjjOUFNSdqjIl3s9CqxRs5UlRJOs/+1AyFxhFXXRqHJNhRY6RjUcl2wwlju2RRVcVdVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=T/lLO+3M; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="T/lLO+3M"
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-c5e051a47ddso1093610a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544042; x=1769148842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZOjbKtGW+2QX+KlT0Mwe37S5YTZVW5sBtNztb5CCxk=;
        b=FA+GtPufsXn5t58ig23HhAEBen9LkCoFnkOOAQ9HaZbEa9t995PqXqDtLaWWkk+5sf
         0MphjigwHMiFfDQCWZtZ3PqKEIjK2whczlvctIQq8BcJusNpj+OGnwyRRiNMc8lTuogE
         vlPRUPk/EnXT/4BOeirWXqpWhsYLWp9sfQemXa1ez9Rkv8qwM6ufEGoMzE5e5GtYaGlV
         T5Q72nYTTrQLj6TLVRBE3xBA9sMfS26a1GLK+LzzJAnYSgOTjXfZQufDgnobOVPEXTR3
         Up7Vp5rzYA7bMNgBFVuGFhNL+79LRqGLz+qSm0O8V1Gs54fAGe4FqisD1AI05L9a9POA
         f20A==
X-Gm-Message-State: AOJu0YwovSyor8Ek3hFFL24rM8pSIXsOQ0uQncq3yDIBp8tcTHqS1V90
	7IkRKNW8DTiv8KNRBfOFbPjouiq1dxDFlkXWxbrpftgwPFIkkmmOV6VCXljTVNpwJCAfe3MutnE
	hlo6JmYvtJHcF6dv9+xjZzSpUJlPx80G7YSHi/roa0WE6EfGH9ZzP2urxIv5e82lIJDwstdiDNH
	aTlwXaPmzd7trYXTWLwrcsRW8pyXDfRoniC6TywVOJQoXtdFIbjnPCsJBkPaublf6CX+JS9ydtH
	Vi0ZdYP0mm6nzHw
X-Gm-Gg: AY/fxX4/OzVAmJIE5n01OEaH0jRbOkJPuZlhWrJxkj3IgbqLpzJB62VUhNkixWo0TAP
	SR62qLlv3dUim2THCAWmbuev5+tQ5uUw2vurrppKk1RZGfC8MEDgkKk6736c3rJfKa5YpzBzNXi
	uzQ6UIAxTHwAeDIqFg9/YKncCX9jvWhQsk0Q7be7uL/5Iy/4AzqmXlAHpKDA5hBdkp2aGQx/PJB
	SR77Zpqi266ZpRBlBwpoeSoa/a03bGkrgQSBeVJKjWQWtif3BCopXwz+f0a4PvKzF84PLjOTGnH
	++n/D+iqlbxYOA/1gyoiYjEn0D9CEvQ7dPgtu4P2OkiE3HzT5OKbK/39raEcYwX9mGYwDPT6Yfm
	rkiT2eWMiG8mpIZEAjFDg9k1GsdjmH4vuauUErzE9vL2aZyWKblVlO/V8+dzjkkGRDtVecncFlL
	rF1XNPNnWb3SEGWzkGcw6bfFL/Mrsy96725ppW7uefxvON3HE=
X-Received: by 2002:a17:902:e78b:b0:2a2:f0cb:df9e with SMTP id d9443c01a7336-2a71885740cmr15970115ad.1.1768544042214;
        Thu, 15 Jan 2026 22:14:02 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a71939c0aesm1929505ad.53.2026.01.15.22.14.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:14:02 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a377e15716so33849645ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544040; x=1769148840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZOjbKtGW+2QX+KlT0Mwe37S5YTZVW5sBtNztb5CCxk=;
        b=T/lLO+3M+ZUd778wD3w5tpn/N00nw2aphlORbcOgguzzS5sitbb5JMDFcj1/Nh0NjK
         nu2wRG6pL3IYk3iayYthdldvBaRlTDrmloxK207xXKS3jYDyXrenQz6aGs892e/YV9Fb
         YBy4K7ZsYiYY+wOwKfpWD+jzhRRXuaDQTKZyA=
X-Received: by 2002:a17:903:41d2:b0:295:62d:5004 with SMTP id d9443c01a7336-2a7188a1bb9mr18079025ad.26.1768544040244;
        Thu, 15 Jan 2026 22:14:00 -0800 (PST)
X-Received: by 2002:a17:903:41d2:b0:295:62d:5004 with SMTP id d9443c01a7336-2a7188a1bb9mr18078895ad.26.1768544039724;
        Thu, 15 Jan 2026 22:13:59 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:13:59 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 4/8] mpi3mr: Use negotiated link rate from DevicePage0
Date: Fri, 16 Jan 2026 11:37:15 +0530
Message-ID: <20260116060719.32937-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Firmware populates the negotiated SAS link rate in DevicePage0
during device discovery. Update mpi3mr to cache this value while
initializing the target device.

When available, the cached link rate is used instead of issuing
additional SAS PHY or expander PHY page reads.
If the DevicePage0 value is missing or invalid, the driver
falls back to the existing PHY-based mechanism.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h   |  2 +
 drivers/scsi/mpi3mr/mpi3mr.h           |  2 +
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 89 ++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 30 +++++----
 4 files changed, 111 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 8c8bfbbdd34e..67d72b82cbe0 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -2314,6 +2314,8 @@ struct mpi3_device0_sas_sata_format {
 	u8         attached_phy_identifier;
 	u8         max_port_connections;
 	u8         zone_group;
+	u8         reserved10[3];
+	u8         negotiated_link_rate;
 };
 
 #define MPI3_DEVICE0_SASSATA_FLAGS_WRITE_SAME_UNMAP_NCQ (0x0400)
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 711f2aa11294..eee6cb40a960 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -643,6 +643,7 @@ struct mpi3mr_enclosure_node {
  * @dev_info: Device information bits
  * @phy_id: Phy identifier provided in device page 0
  * @attached_phy_id: Attached phy identifier provided in device page 0
+ * @negotiated_link_rate: Negotiated link rate from device page 0
  * @sas_transport_attached: Is this device exposed to transport
  * @pend_sas_rphy_add: Flag to check device is in process of add
  * @hba_port: HBA port entry
@@ -654,6 +655,7 @@ struct tgt_dev_sas_sata {
 	u16 dev_info;
 	u8 phy_id;
 	u8 attached_phy_id;
+	u8 negotiated_link_rate;
 	u8 sas_transport_attached;
 	u8 pend_sas_rphy_add;
 	struct mpi3mr_hba_port *hba_port;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 028a3a1a6be0..2fce5bfb7204 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1138,6 +1138,89 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 	}
 }
 
+/**
+ * mpi3mr_debug_dump_devpg0 - Dump device page0
+ * @mrioc: Adapter instance reference
+ * @dev_pg0: Device page 0.
+ *
+ * Prints pertinent details of the device page 0.
+ *
+ * Return: Nothing.
+ */
+static void
+mpi3mr_debug_dump_devpg0(struct mpi3mr_ioc *mrioc, struct mpi3_device_page0 *dev_pg0)
+{
+	ioc_info(mrioc,
+	    "device_pg0: handle(0x%04x), perst_id(%d), wwid(0x%016llx), encl_handle(0x%04x), slot(%d)\n",
+	    le16_to_cpu(dev_pg0->dev_handle),
+	    le16_to_cpu(dev_pg0->persistent_id),
+	    le64_to_cpu(dev_pg0->wwid), le16_to_cpu(dev_pg0->enclosure_handle),
+	    le16_to_cpu(dev_pg0->slot));
+	ioc_info(mrioc, "device_pg0: access_status(0x%02x), flags(0x%04x), device_form(0x%02x), queue_depth(%d)\n",
+	    dev_pg0->access_status, le16_to_cpu(dev_pg0->flags),
+	    dev_pg0->device_form, le16_to_cpu(dev_pg0->queue_depth));
+	ioc_info(mrioc, "device_pg0: parent_handle(0x%04x), iounit_port(%d)\n",
+	    le16_to_cpu(dev_pg0->parent_dev_handle), dev_pg0->io_unit_port);
+
+	switch (dev_pg0->device_form) {
+	case MPI3_DEVICE_DEVFORM_SAS_SATA:
+	{
+
+		struct mpi3_device0_sas_sata_format *sasinf =
+		    &dev_pg0->device_specific.sas_sata_format;
+		ioc_info(mrioc,
+		    "device_pg0: sas_sata: sas_address(0x%016llx),flags(0x%04x),\n"
+		    "device_info(0x%04x), phy_num(%d), attached_phy_id(%d),negotiated_link_rate(0x%02x)\n",
+		    le64_to_cpu(sasinf->sas_address),
+		    le16_to_cpu(sasinf->flags),
+		    le16_to_cpu(sasinf->device_info), sasinf->phy_num,
+		    sasinf->attached_phy_identifier, sasinf->negotiated_link_rate);
+		break;
+	}
+	case MPI3_DEVICE_DEVFORM_PCIE:
+	{
+
+		struct mpi3_device0_pcie_format *pcieinf =
+		    &dev_pg0->device_specific.pcie_format;
+		ioc_info(mrioc,
+		    "device_pg0: pcie: port_num(%d), device_info(0x%04x), mdts(%d), page_sz(0x%02x)\n",
+		    pcieinf->port_num, le16_to_cpu(pcieinf->device_info),
+		    le32_to_cpu(pcieinf->maximum_data_transfer_size),
+		    pcieinf->page_size);
+		ioc_info(mrioc,
+		    "device_pg0: pcie: abort_timeout(%d), reset_timeout(%d) capabilities (0x%08x)\n",
+		    pcieinf->nvme_abort_to, pcieinf->controller_reset_to,
+		    le32_to_cpu(pcieinf->capabilities));
+		break;
+	}
+	case MPI3_DEVICE_DEVFORM_VD:
+	{
+
+		struct mpi3_device0_vd_format *vdinf =
+		    &dev_pg0->device_specific.vd_format;
+
+		ioc_info(mrioc,
+		    "device_pg0: vd: state(0x%02x), raid_level(%d), flags(0x%04x),\n"
+		    "device_info(0x%04x) abort_timeout(%d), reset_timeout(%d)\n",
+		    vdinf->vd_state, vdinf->raid_level,
+		    le16_to_cpu(vdinf->flags),
+		    le16_to_cpu(vdinf->device_info),
+		    vdinf->vd_abort_to, vdinf->vd_reset_to);
+		ioc_info(mrioc,
+		    "device_pg0: vd: tg_id(%d), high(%dMiB), low(%dMiB), qd_reduction_factor(%d)\n",
+		    vdinf->io_throttle_group,
+		    le16_to_cpu(vdinf->io_throttle_group_high),
+		    le16_to_cpu(vdinf->io_throttle_group_low),
+		    ((le16_to_cpu(vdinf->flags) &
+		       MPI3_DEVICE0_VD_FLAGS_IO_THROTTLE_GROUP_QD_MASK) >> 12));
+		break;
+
+	}
+	default:
+		break;
+	}
+}
+
 /**
  * mpi3mr_update_tgtdev - DevStatusChange evt bottomhalf
  * @mrioc: Adapter instance reference
@@ -1159,6 +1242,10 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_enclosure_node *enclosure_dev = NULL;
 	u8 prot_mask = 0;
 
+	if (mrioc->logging_level &
+	    (MPI3_DEBUG_EVENT | MPI3_DEBUG_EVENT_WORK_TASK))
+		mpi3mr_debug_dump_devpg0(mrioc, dev_pg0);
+
 	tgtdev->perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	tgtdev->dev_handle = le16_to_cpu(dev_pg0->dev_handle);
 	tgtdev->dev_type = dev_pg0->device_form;
@@ -1237,6 +1324,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		tgtdev->dev_spec.sas_sata_inf.phy_id = sasinf->phy_num;
 		tgtdev->dev_spec.sas_sata_inf.attached_phy_id =
 		    sasinf->attached_phy_identifier;
+		tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate =
+			sasinf->negotiated_link_rate;
 		if ((dev_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) !=
 		    MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE)
 			tgtdev->is_hidden = 1;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index d70f002d6487..101161554ef1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2284,11 +2284,11 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
  * @mrioc: Adapter instance reference
  * @tgtdev: Target device
  *
- * This function identifies whether the target device is
- * attached directly or through expander and issues sas phy
- * page0 or expander phy page1 and gets the link rate, if there
- * is any failure in reading the pages then this returns link
- * rate of 1.5.
+ * This function first tries to use the link rate from DevicePage0
+ * (populated by firmware during device discovery). If the cached
+ * value is not available or invalid, it falls back to reading from
+ * sas phy page0 or expander phy page1.
+ *
  *
  * Return: logical link rate.
  */
@@ -2301,6 +2301,14 @@ static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc *mrioc,
 	u32 phynum_handle;
 	u16 ioc_status;
 
+	/* First, try to use link rate from DevicePage0 (populated by firmware) */
+	if (tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate >=
+	    MPI3_SAS_NEG_LINK_RATE_1_5) {
+		link_rate = tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
+		goto out;
+	}
+
+	/* Fallback to reading from phy pages if DevicePage0 value not available */
 	phy_number = tgtdev->dev_spec.sas_sata_inf.phy_id;
 	if (!(tgtdev->devpg0_flag & MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED)) {
 		phynum_handle = ((phy_number<<MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT)
@@ -2318,9 +2326,7 @@ static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc *mrioc,
 			    __FILE__, __LINE__, __func__);
 			goto out;
 		}
-		link_rate = (expander_pg1.negotiated_link_rate &
-			     MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
-			MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+		link_rate = expander_pg1.negotiated_link_rate;
 		goto out;
 	}
 	if (mpi3mr_cfg_get_sas_phy_pg0(mrioc, &ioc_status, &phy_pg0,
@@ -2335,11 +2341,11 @@ static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc *mrioc,
 		    __FILE__, __LINE__, __func__);
 		goto out;
 	}
-	link_rate = (phy_pg0.negotiated_link_rate &
-		     MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
-		MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+	link_rate = phy_pg0.negotiated_link_rate;
+
 out:
-	return link_rate;
+	return ((link_rate & MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
+		MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
 }
 
 /**
-- 
2.47.3

