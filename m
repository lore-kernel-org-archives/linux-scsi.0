Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6D5C64E75
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AFC6206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SfocThZi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbgKZJpt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgKZJps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 04:45:48 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EA6C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:45:48 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f17so1272398pge.6
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=bak5hbDrfxiQrMnlfDzVdNuTJg7EEN5CyAselbRnRks=;
        b=SfocThZiEYkFhNlQ+ZbAOlm79zssCh1U2/JIrgu54/+TSzq28+KsaFekd9y1PKIg5d
         XQk+Z4/d6PFtnvMHoxxTEJhnUFguXcDnYitjACqz2L/k6+rTp1Oes8kcnFKN8SeYQ2Bp
         D3/MVLXwnVUA4D3qHrPrg2yCGKIwZB4wGHzp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=bak5hbDrfxiQrMnlfDzVdNuTJg7EEN5CyAselbRnRks=;
        b=c5VYdqqcc2BgBU/QGBGOAz+1vnGIX18me76PSAdpo6+YI1Rncq0lLepKgLu7JU/Koe
         6Z9L5vABQRDU5TCkaR684247N1PoMNhDDFIWJCAKX9pHszBBEayuflSs5C1V3TccZmoo
         G507GxQYHGPVpYZLXR/wCj8z2CirXRLUQVeUO1GxWMZQAU137Z4pc8JXdLid2k4+J5QG
         iuClsmBYSjpOkSG/Fyu9aFbWX5Fn0C2yGKCPri+Phpb8jamua5E5wRybUGBRUckSJBAo
         O9Z1kn6uExCnPeTMkGFjgBg9bLffzG2d7rKKpMIsqZ3BoBGhY6fRNSH+XqEGEKG1kOIW
         LU+A==
X-Gm-Message-State: AOAM530IznnyyLTRKZzNH7p1sy+A0+teNsfdYaBQ0Tpt4Ps/p3I2ntUr
        tVk6RG15gWeZgdJ58IoNbvlKVxDWqYlxZKigcXyoj5NCNYH6muXFY5haPQsD/NWQHgGlxhd0gl4
        2rKby/pZQ2CDZepZje5vSfuKaIJ9PWK3mF6fCMiKX0oP7XpYMbnSfCMPOsFwZafdHAqfkvZtuO0
        3YQF/WELJH9vrFkyJU0OpcAe4=
X-Google-Smtp-Source: ABdhPJzHS+09rL2L4x12Y0YNKyfqTeZp9TH0P6e6fGY1vrIwV7aCGIvHVcpEFv6Br+8daVbzcO8sqw==
X-Received: by 2002:a17:90a:c90b:: with SMTP id v11mr2714306pjt.181.1606383946943;
        Thu, 26 Nov 2020 01:45:46 -0800 (PST)
Received: from dhcp-10-123-20-14.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i10sm4343220pfk.206.2020.11.26.01.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 01:45:46 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v1 2/8] mpt3sas: Add persistent trigger pages support
Date:   Thu, 26 Nov 2020 15:13:05 +0530
Message-Id: <20201126094311.8686-3-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
References: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000091b9c205b4ff68c9"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000091b9c205b4ff68c9
Content-Transfer-Encoding: 8bit

Problem statement:
User sets the tigger value inorder to collect the IOC's
Host tace buffer automicatically upon detecting the trigger
condition. But the tigger values that the user has set are not
persistent across the system reboot or reload of driver. User
has to set them eveytime upon rebooting, realoding the driver
or when HBA is moved to another system.

Solution:
Inorder to make the user trigger settings persistant, these trigger
values needs to be saved in IOC's pages and IOC provides below pages
to save them,

* Driver Persistent Trigger Page 0 :
    This page is used to know list of trigger types that are enabled
* Driver Persistent Trigger Page 1 :
    This page stores the list of Mater triggers that are enabled
* Driver Persistent Trigger Page 2 :
    This page stores the list of MPI Event Triggers that are enabled
* Driver Persistent Trigger Page 3 :
    This page stores the list of SCSI Sense Triggers that are enabled
* Driver Persistent Trigger Page 4 :
    This page stores the list of IOCStatus-LogInfo Triggers that are
    enabled.

* Whenever user configure the trigger values then driver writes the
  configured trigger values in the corresponding trigger pages.
* During next driver load time, driver reads the trigger values
  from these pages and configures the trigger values accordingly.
* During firmware upload operation,
  * if the newer firmware supports these driver trigger pages
    then driver write backs the configured diag trigger values
    on driver trigger pages of IOC.
  * if the newer firmware doesn't supports these driver trigger
    pages then driver clear the supporting trigger flag so that
    whenever user modifies the trigger values then driver
    won't do any config write operations to driver trigger pages.

Current patch change set:
* During driver load, driver will first read Persistent Trigger Page0.
  - If this page's read operation fails then it means that IOC
    firmware doesn't support these Persistent Trigger Pages, i.e.
    current feature of saving/restoring the tigger values is not
    enabled in the IOC. So, driver can't read/store user trigger values
    from/to Persistent triggers pages.
  - If this Page's read opearation is successful then it means that
    IOC firmware supports storing the trigger values on persistent
    trigger pages. So, driver sets the supports_trigger_pages ioc
    variable to one. On reading this page, driver will get to know
    which are all the trigger types that are enabled before the
    driver load.

* And added below helper functions to read & modify
  Persistent Trigger Page0.
  - mpt3sas_config_get_driver_trigger_pg0 : reads the page,
  - mpt3sas_config_set_driver_trigger_pg0 : writes the page,
  - mpt3sas_config_update_driver_trigger_pg0 :
    When user adds any new trigger values then driver enable
    the corresponding trigger type bit in 'TriggerFlags' field of
    Persistent Trigger Page0 (if it was not enabled before)
    before adding these trigger values to corresponding
    Persistent Trigger type pages.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reported-by: kernel test robot <lkp@intel.com>
---
v1 Changes:
Fixed sparse warnings and warnings with W=1 build.

 drivers/scsi/mpt3sas/mpt3sas_base.c          |  70 ++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h          |   5 +
 drivers/scsi/mpt3sas/mpt3sas_config.c        | 134 +++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h |  94 +++++++++++++
 4 files changed, 303 insertions(+)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8538c2d..4ccfcb3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -975,6 +975,20 @@ _base_sas_ioc_info(struct MPT3SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
 
 	if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 		return;
+	/*
+	 * Older Firmware version doesn't support driver trigger pages.
+	 * So, skip displaying 'config invalid type' type
+	 * of error message.
+	 */
+	if (request_hdr->Function == MPI2_FUNCTION_CONFIG) {
+		Mpi2ConfigRequest_t *rqst = (Mpi2ConfigRequest_t *)request_hdr;
+
+		if ((rqst->ExtPageType ==
+		    MPI2_CONFIG_EXTPAGETYPE_DRIVER_PERSISTENT_TRIGGER) &&
+		    !(ioc->logging_level & MPT_DEBUG_CONFIG)) {
+			return;
+		}
+	}
 
 	switch (ioc_status) {
 
@@ -4783,6 +4797,58 @@ _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/**
+ * _base_check_for_trigger_pages_support - checks whether HBA FW supports
+ *					driver trigger pages or not
+ * @ioc : per adapter object
+ *
+ * Returns trigger flags mask if HBA FW supports driver trigger pages,
+ * otherwise returns EFAULT.
+ */
+static int
+_base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi26DriverTriggerPage0_t trigger_pg0;
+	int r = 0;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 ioc_status;
+
+	r = mpt3sas_config_get_driver_trigger_pg0(ioc, &mpi_reply,
+	    &trigger_pg0);
+	if (r)
+		return -EFAULT;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
+		return -EFAULT;
+
+	return le16_to_cpu(trigger_pg0.TriggerFlags);
+}
+
+/**
+ * _base_get_diag_triggers - Retrieve diag trigger values from
+ *				persistent pages.
+ * @ioc : per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
+{
+	u16 trigger_flags;
+
+	/*
+	 * Default setting of master trigger.
+	 */
+	ioc->diag_trigger_master.MasterData =
+	    (MASTER_TRIGGER_FW_FAULT + MASTER_TRIGGER_ADAPTER_RESET);
+	trigger_flags = _base_check_for_trigger_pages_support(ioc);
+	if (trigger_flags < 0)
+		return;
+	ioc->supports_trigger_pages = 1;
+}
+
 /**
  * _base_static_config_pages - static start of day config pages
  * @ioc: per adapter object
@@ -4869,6 +4935,10 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 		ioc->temp_sensors_count = ioc->iounit_pg8.NumSensors;
 	if (ioc->is_aero_ioc)
 		_base_update_ioc_page1_inlinewith_perf_mode(ioc);
+	if (ioc->is_gen35_ioc) {
+		if (ioc->is_driver_loading)
+			_base_get_diag_triggers(ioc);
+	}
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index cc4815c..83b6308 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -71,6 +71,7 @@
 
 #include "mpt3sas_debug.h"
 #include "mpt3sas_trigger_diag.h"
+#include "mpt3sas_trigger_pages.h"
 
 /* driver versioning info */
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
@@ -1541,6 +1542,7 @@ struct MPT3SAS_ADAPTER {
 	struct SL_WH_EVENT_TRIGGERS_T diag_trigger_event;
 	struct SL_WH_SCSI_TRIGGERS_T diag_trigger_scsi;
 	struct SL_WH_MPI_TRIGGERS_T diag_trigger_mpi;
+	u8		supports_trigger_pages;
 	void		*device_remove_in_progress;
 	u16		device_remove_in_progress_sz;
 	u8		is_gen35_ioc;
@@ -1817,6 +1819,9 @@ int mpt3sas_config_get_volume_handle(struct MPT3SAS_ADAPTER *ioc, u16 pd_handle,
 	u16 *volume_handle);
 int mpt3sas_config_get_volume_wwid(struct MPT3SAS_ADAPTER *ioc,
 	u16 volume_handle, u64 *wwid);
+int
+mpt3sas_config_get_driver_trigger_pg0(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage0_t *config_page);
 
 /* ctl shared API */
 extern struct device_attribute *mpt3sas_host_attrs[];
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 4a0ddc7..2fa60c2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -1742,6 +1742,140 @@ mpt3sas_config_get_phys_disk_pg0(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	return r;
 }
 
+/**
+ * mpt3sas_config_get_driver_trigger_pg0 - obtain driver trigger page 0
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_driver_trigger_pg0(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage0_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_EXTENDED;
+	mpi_request.ExtPageType =
+	    MPI2_CONFIG_EXTPAGETYPE_DRIVER_PERSISTENT_TRIGGER;
+	mpi_request.Header.PageNumber = 0;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE0_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+ out:
+	return r;
+}
+
+/**
+ * mpt3sas_config_set_driver_trigger_pg0 - write driver trigger page 0
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_config_set_driver_trigger_pg0(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage0_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_EXTENDED;
+	mpi_request.ExtPageType =
+	    MPI2_CONFIG_EXTPAGETYPE_DRIVER_PERSISTENT_TRIGGER;
+	mpi_request.Header.PageNumber = 0;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE0_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	_config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+ out:
+	return r;
+}
+
+/**
+ * mpt3sas_config_update_driver_trigger_pg0 - update driver trigger page 0
+ * @ioc: per adapter object
+ * @trigger_flag: trigger type bit map
+ * @set: set ot clear trigger values
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+mpt3sas_config_update_driver_trigger_pg0(struct MPT3SAS_ADAPTER *ioc,
+	u16 trigger_flag, bool set)
+{
+	Mpi26DriverTriggerPage0_t tg_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	int rc;
+	u16 flags, ioc_status;
+
+	rc = mpt3sas_config_get_driver_trigger_pg0(ioc, &mpi_reply, &tg_pg0);
+	if (rc)
+		return rc;
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg0, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		return -EFAULT;
+	}
+
+	if (set)
+		flags = le16_to_cpu(tg_pg0.TriggerFlags) | trigger_flag;
+	else
+		flags = le16_to_cpu(tg_pg0.TriggerFlags) & ~trigger_flag;
+
+	tg_pg0.TriggerFlags = cpu_to_le16(flags);
+
+	rc = _config_set_driver_trigger_pg0(ioc, &mpi_reply, &tg_pg0);
+	if (rc)
+		return rc;
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to update trigger pg0, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 /**
  * mpt3sas_config_get_volume_handle - returns volume handle for give hidden
  * raid components
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h b/drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h
new file mode 100644
index 0000000..5f3328f
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/*
+ * This is the Fusion MPT base driver providing common API layer interface
+ * to store diag trigger values into persistent driver triggers pages
+ * for MPT (Message Passing Technology) based controllers.
+ *
+ * Copyright (C) 2020  Broadcom Inc.
+ *
+ * Authors: Broadcom Inc.
+ * Sreekanth Reddy  <sreekanth.reddy@broadcom.com>
+ *
+ * Send feedback to : MPT-FusionLinux.pdl@broadcom.com)
+ */
+
+#include "mpi/mpi2_cnfg.h"
+
+#ifndef MPI2_TRIGGER_PAGES_H
+#define MPI2_TRIGGER_PAGES_H
+
+#define MPI2_CONFIG_EXTPAGETYPE_DRIVER_PERSISTENT_TRIGGER    (0xE0)
+#define MPI26_DRIVER_TRIGGER_PAGE0_PAGEVERSION               (0x01)
+typedef struct _MPI26_CONFIG_PAGE_DRIVER_TIGGER_0 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER	Header;	/* 0x00  */
+	U16	TriggerFlags;		/* 0x08  */
+	U16	Reserved0xA;		/* 0x0A */
+	U32	Reserved0xC[61];	/* 0x0C */
+} _MPI26_CONFIG_PAGE_DRIVER_TIGGER_0, Mpi26DriverTriggerPage0_t;
+
+/* Trigger Flags */
+#define  MPI26_DRIVER_TRIGGER0_FLAG_MASTER_TRIGGER_VALID       (0x0001)
+#define  MPI26_DRIVER_TRIGGER0_FLAG_MPI_EVENT_TRIGGER_VALID    (0x0002)
+#define  MPI26_DRIVER_TRIGGER0_FLAG_SCSI_SENSE_TRIGGER_VALID   (0x0004)
+#define  MPI26_DRIVER_TRIGGER0_FLAG_LOGINFO_TRIGGER_VALID      (0x0008)
+
+#define MPI26_DRIVER_TRIGGER_PAGE1_PAGEVERSION               (0x01)
+typedef struct _MPI26_DRIVER_MASTER_TIGGER_ENTRY {
+	U32	MasterTriggerFlags;
+} MPI26_DRIVER_MASTER_TIGGER_ENTRY;
+
+#define MPI26_MAX_MASTER_TRIGGERS                                   (1)
+typedef struct _MPI26_CONFIG_PAGE_DRIVER_TIGGER_1 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER	Header;	/* 0x00 */
+	U16	NumMasterTrigger;	/* 0x08 */
+	U16	Reserved0xA;		/* 0x0A */
+	MPI26_DRIVER_MASTER_TIGGER_ENTRY MasterTriggers[MPI26_MAX_MASTER_TRIGGERS];	/* 0x0C */
+} MPI26_CONFIG_PAGE_DRIVER_TIGGER_1, Mpi26DriverTriggerPage1_t;
+
+#define MPI26_DRIVER_TRIGGER_PAGE2_PAGEVERSION               (0x01)
+typedef struct _MPI26_DRIVER_MPI_EVENT_TIGGER_ENTRY {
+	U16	MPIEventCode;		/* 0x00 */
+	U16	MPIEventCodeSpecific;	/* 0x02 */
+} MPI26_DRIVER_MPI_EVENT_TIGGER_ENTRY;
+
+#define MPI26_MAX_MPI_EVENT_TRIGGERS                            (20)
+typedef struct _MPI26_CONFIG_PAGE_DRIVER_TIGGER_2 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER        Header;	/* 0x00  */
+	U16	NumMPIEventTrigger;     /* 0x08  */
+	U16	Reserved0xA;		/* 0x0A */
+	MPI26_DRIVER_MPI_EVENT_TIGGER_ENTRY MPIEventTriggers[MPI26_MAX_MPI_EVENT_TRIGGERS]; /* 0x0C */
+} MPI26_CONFIG_PAGE_DRIVER_TIGGER_2, Mpi26DriverTriggerPage2_t;
+
+#define MPI26_DRIVER_TRIGGER_PAGE3_PAGEVERSION               (0x01)
+typedef struct _MPI26_DRIVER_SCSI_SENSE_TIGGER_ENTRY {
+	U8     ASCQ;		/* 0x00 */
+	U8     ASC;		/* 0x01 */
+	U8     SenseKey;	/* 0x02 */
+	U8     Reserved;	/* 0x03 */
+} MPI26_DRIVER_SCSI_SENSE_TIGGER_ENTRY;
+
+#define MPI26_MAX_SCSI_SENSE_TRIGGERS                            (20)
+typedef struct _MPI26_CONFIG_PAGE_DRIVER_TIGGER_3 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER	Header;	/* 0x00  */
+	U16	NumSCSISenseTrigger;			/* 0x08  */
+	U16	Reserved0xA;				/* 0x0A */
+	MPI26_DRIVER_SCSI_SENSE_TIGGER_ENTRY SCSISenseTriggers[MPI26_MAX_SCSI_SENSE_TRIGGERS];	/* 0x0C */
+} MPI26_CONFIG_PAGE_DRIVER_TIGGER_3, Mpi26DriverTriggerPage3_t;
+
+#define MPI26_DRIVER_TRIGGER_PAGE4_PAGEVERSION               (0x01)
+typedef struct _MPI26_DRIVER_IOCSTATUS_LOGINFO_TIGGER_ENTRY {
+	U16        IOCStatus;      /* 0x00 */
+	U16        Reserved;       /* 0x02 */
+	U32        LogInfo;        /* 0x04 */
+} MPI26_DRIVER_IOCSTATUS_LOGINFO_TIGGER_ENTRY;
+
+#define MPI26_MAX_LOGINFO_TRIGGERS                            (20)
+typedef struct _MPI26_CONFIG_PAGE_DRIVER_TIGGER_4 {
+	MPI2_CONFIG_EXTENDED_PAGE_HEADER	Header;	/* 0x00  */
+	U16	NumIOCStatusLogInfoTrigger;		/* 0x08  */
+	U16	Reserved0xA;				/* 0x0A */
+	MPI26_DRIVER_IOCSTATUS_LOGINFO_TIGGER_ENTRY IOCStatusLoginfoTriggers[MPI26_MAX_LOGINFO_TRIGGERS];	/* 0x0C */
+} MPI26_CONFIG_PAGE_DRIVER_TIGGER_4, Mpi26DriverTriggerPage4_t;
+
+#endif
-- 
2.27.0


--00000000000091b9c205b4ff68c9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgnN9yqqfJJ50jsnV1hwss4l3SUl8fGRw1OL2JusRK
hbgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMTI2MDk0NTQ3
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAI+pRU6CRib2we908tiAnUUHbvq9PMjOwvNm2jm7mnU8r22l4Dw5XLf3FuWq
QK/Eq7UI+1vsfY30PuZK+cWzm54uSFRaIzRu1WeySjSTOBwDLOQY4U5CgsQEN9vqM/6VFd8QXzfK
GQWmdtxvyWUYrqE0TleDcBUmcvaQScGtq85yB4fmisYQTSCsok2avdDfWcbQYDTJeY+w0YlUoAfq
dyi12Tc+bAj3MHPZwg6SUb3fPpjJNFLASrAd2rQPhCfoljQsF7mFCJy234UW2VifoYZCE4DS9B+Z
NrFqX5emeiNmB4UyjGt6kks1q8KK2DPO+DSQi7Wm92eIyTg1FhkUsv4=
--00000000000091b9c205b4ff68c9--
