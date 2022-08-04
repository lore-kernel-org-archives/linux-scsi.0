Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854CFC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiHDNAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239384AbiHDNAd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:33 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748566339
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q19so9933903pfg.8
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=8jy35WE5Hk4LH8nfPwFlIQdVU0zeHXgyddqNg/ZG7U0=;
        b=cSVUWN3+PxnaQqNnj8cwpjFXTTOaYxGoW42Y2d33zpd5F5QNysN9C5lLa3hcXLBYJk
         gy7IquERTZqP3Wit6YRlnan6eYJxHpzuDvAf7a47XFnsnPMTklxKZwqkFVwGpN/kxJGN
         9oVcWUIKHTW0IDNEot1bkfhHC8ygT5WGUuo4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=8jy35WE5Hk4LH8nfPwFlIQdVU0zeHXgyddqNg/ZG7U0=;
        b=M4u0YuuKYUVgCj7KklZdf5G3r7kR6ZyywC713gvj1fZuZK9Tx3ZHkmb+r757zsOLat
         CKa7o25erWH+e1x57PXCCYB4p3xTYn001MLw6+MS6qDyflUfE7vOva2Nswyux2LNoEu8
         HA+mJUiV88dYzHWl8Em8VrvjkMKv2Ms1XE2O4bty3qwRPifnano6Qst4KjrOtDcftoU9
         V10K+suI0FKr5vAfxV61Dwofg/zo+NWw2SAeXY0+kMiFPERczWTegS0sGrQMDg76SU4C
         V3bZpMg49fb8OwZ0eW6t4cbaJCBhlt80ZNlNcPTUumPkktFAyyYuq/sSUvHM1IYA9fah
         ssYw==
X-Gm-Message-State: ACgBeo2L68d+3EkK9XOUUAkTYbqISkzF5p4Tp9Tzc8QbJEkgYtcEMyfT
        C2BHIFvMv4JHkH081HOEM0LSo0/PHk7t9Sv27fOgdsoJFigA+G+U7xlXmXDjZQyS+TNVBJO729u
        1guE8ye9hmVZ7zMbmalZeKbzs1fo1RCgcYQ1K4ADDoU9cGnFxDb5ryp4Yj5e6lyi2JftH2xSKsn
        6caccmAvK3
X-Google-Smtp-Source: AA6agR6hM/h5XCoAbMKDHukUMpMe0Wk/fHZ7wXLd9Syks5RcoqOvwPLgBE4fI3BzkedOrZ6+3gHluQ==
X-Received: by 2002:a65:6d9a:0:b0:41c:c77:7b6 with SMTP id bc26-20020a656d9a000000b0041c0c7707b6mr1607998pgb.139.1659618025907;
        Thu, 04 Aug 2022 06:00:25 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:25 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 03/15] mpi3mr: Added helper functions to retrieve cnfg pages
Date:   Thu,  4 Aug 2022 18:42:14 +0530
Message-Id: <20220804131226.16653-4-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f3402205e569eed6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f3402205e569eed6
Content-Transfer-Encoding: 8bit

Added helper functions to retrieve below controller's
config pages,
- SAS IOUnit Page0
- SAS IOUnit Page1
- Driver Page1
- Device Page0
- SAS Phy Page0
- SAS Phy Page1
- SAS Expander Page0
- SAS Expander Page1
- Enclosure Page0

Also added the helper function to set the SAS IOUnit Page1.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  26 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 595 ++++++++++++++++++++++++++++++++
 2 files changed, 621 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index e15ad0e..8af94d3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1179,4 +1179,30 @@ void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
 extern const struct attribute_group *mpi3mr_host_groups[];
 extern const struct attribute_group *mpi3mr_dev_groups[];
+
+int mpi3mr_cfg_get_dev_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_device_page0 *dev_pg0, u16 pg_sz, u32 form, u32 form_spec);
+int mpi3mr_cfg_get_sas_phy_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_phy_page0 *phy_pg0, u16 pg_sz, u32 form,
+	u32 form_spec);
+int mpi3mr_cfg_get_sas_phy_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_phy_page1 *phy_pg1, u16 pg_sz, u32 form,
+	u32 form_spec);
+int mpi3mr_cfg_get_sas_exp_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_expander_page0 *exp_pg0, u16 pg_sz, u32 form,
+	u32 form_spec);
+int mpi3mr_cfg_get_sas_exp_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_expander_page1 *exp_pg1, u16 pg_sz, u32 form,
+	u32 form_spec);
+int mpi3mr_cfg_get_enclosure_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_enclosure_page0 *encl_pg0, u16 pg_sz, u32 form,
+	u32 form_spec);
+int mpi3mr_cfg_get_sas_io_unit_pg0(struct mpi3mr_ioc *mrioc,
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0, u16 pg_sz);
+int mpi3mr_cfg_get_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
+	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
+int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
+	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
+int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
+	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 99d8df6..bfc4244 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -5039,3 +5039,598 @@ out:
 	mpi3mr_free_config_dma_memory(mrioc, &mem_desc);
 	return retval;
 }
+
+/**
+ * mpi3mr_cfg_get_dev_pg0 - Read current device page0
+ * @mrioc: Adapter instance reference
+ * @ioc_status: Pointer to return ioc status
+ * @dev_pg0: Pointer to return device page 0
+ * @pg_sz: Size of the memory allocated to the page pointer
+ * @form: The form to be used for addressing the page
+ * @form_spec: Form specific information like device handle
+ *
+ * This is handler for config page read for a specific device
+ * page0. The ioc_status has the controller returned ioc_status.
+ * This routine doesn't check ioc_status to decide whether the
+ * page read is success or not and it is the callers
+ * responsibility.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_dev_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_device_page0 *dev_pg0, u16 pg_sz, u32 form, u32 form_spec)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u32 page_address;
+
+	memset(dev_pg0, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_DEVICE;
+	cfg_req.page_number = 0;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "device page0 header read failed\n");
+		goto out_failed;
+	}
+	if (*ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "device page0 header read failed with ioc_status(0x%04x)\n",
+		    *ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+	page_address = ((form & MPI3_DEVICE_PGAD_FORM_MASK) |
+	    (form_spec & MPI3_DEVICE_PGAD_HANDLE_MASK));
+	cfg_req.page_address = cpu_to_le32(page_address);
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, dev_pg0, pg_sz)) {
+		ioc_err(mrioc, "device page0 read failed\n");
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+
+/**
+ * mpi3mr_cfg_get_sas_phy_pg0 - Read current SAS Phy page0
+ * @mrioc: Adapter instance reference
+ * @ioc_status: Pointer to return ioc status
+ * @phy_pg0: Pointer to return SAS Phy page 0
+ * @pg_sz: Size of the memory allocated to the page pointer
+ * @form: The form to be used for addressing the page
+ * @form_spec: Form specific information like phy number
+ *
+ * This is handler for config page read for a specific SAS Phy
+ * page0. The ioc_status has the controller returned ioc_status.
+ * This routine doesn't check ioc_status to decide whether the
+ * page read is success or not and it is the callers
+ * responsibility.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_sas_phy_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_phy_page0 *phy_pg0, u16 pg_sz, u32 form,
+	u32 form_spec)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u32 page_address;
+
+	memset(phy_pg0, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_SAS_PHY;
+	cfg_req.page_number = 0;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "sas phy page0 header read failed\n");
+		goto out_failed;
+	}
+	if (*ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas phy page0 header read failed with ioc_status(0x%04x)\n",
+		    *ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+	page_address = ((form & MPI3_SAS_PHY_PGAD_FORM_MASK) |
+	    (form_spec & MPI3_SAS_PHY_PGAD_PHY_NUMBER_MASK));
+	cfg_req.page_address = cpu_to_le32(page_address);
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, phy_pg0, pg_sz)) {
+		ioc_err(mrioc, "sas phy page0 read failed\n");
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_get_sas_phy_pg1 - Read current SAS Phy page1
+ * @mrioc: Adapter instance reference
+ * @ioc_status: Pointer to return ioc status
+ * @phy_pg1: Pointer to return SAS Phy page 1
+ * @pg_sz: Size of the memory allocated to the page pointer
+ * @form: The form to be used for addressing the page
+ * @form_spec: Form specific information like phy number
+ *
+ * This is handler for config page read for a specific SAS Phy
+ * page1. The ioc_status has the controller returned ioc_status.
+ * This routine doesn't check ioc_status to decide whether the
+ * page read is success or not and it is the callers
+ * responsibility.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_sas_phy_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_phy_page1 *phy_pg1, u16 pg_sz, u32 form,
+	u32 form_spec)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u32 page_address;
+
+	memset(phy_pg1, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_SAS_PHY;
+	cfg_req.page_number = 1;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "sas phy page1 header read failed\n");
+		goto out_failed;
+	}
+	if (*ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas phy page1 header read failed with ioc_status(0x%04x)\n",
+		    *ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+	page_address = ((form & MPI3_SAS_PHY_PGAD_FORM_MASK) |
+	    (form_spec & MPI3_SAS_PHY_PGAD_PHY_NUMBER_MASK));
+	cfg_req.page_address = cpu_to_le32(page_address);
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, phy_pg1, pg_sz)) {
+		ioc_err(mrioc, "sas phy page1 read failed\n");
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+
+/**
+ * mpi3mr_cfg_get_sas_exp_pg0 - Read current SAS Expander page0
+ * @mrioc: Adapter instance reference
+ * @ioc_status: Pointer to return ioc status
+ * @exp_pg0: Pointer to return SAS Expander page 0
+ * @pg_sz: Size of the memory allocated to the page pointer
+ * @form: The form to be used for addressing the page
+ * @form_spec: Form specific information like device handle
+ *
+ * This is handler for config page read for a specific SAS
+ * Expander page0. The ioc_status has the controller returned
+ * ioc_status. This routine doesn't check ioc_status to decide
+ * whether the page read is success or not and it is the callers
+ * responsibility.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_sas_exp_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_expander_page0 *exp_pg0, u16 pg_sz, u32 form,
+	u32 form_spec)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u32 page_address;
+
+	memset(exp_pg0, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_SAS_EXPANDER;
+	cfg_req.page_number = 0;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "expander page0 header read failed\n");
+		goto out_failed;
+	}
+	if (*ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "expander page0 header read failed with ioc_status(0x%04x)\n",
+		    *ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+	page_address = ((form & MPI3_SAS_EXPAND_PGAD_FORM_MASK) |
+	    (form_spec & (MPI3_SAS_EXPAND_PGAD_PHYNUM_MASK |
+	    MPI3_SAS_EXPAND_PGAD_HANDLE_MASK)));
+	cfg_req.page_address = cpu_to_le32(page_address);
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, exp_pg0, pg_sz)) {
+		ioc_err(mrioc, "expander page0 read failed\n");
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_get_sas_exp_pg1 - Read current SAS Expander page1
+ * @mrioc: Adapter instance reference
+ * @ioc_status: Pointer to return ioc status
+ * @exp_pg1: Pointer to return SAS Expander page 1
+ * @pg_sz: Size of the memory allocated to the page pointer
+ * @form: The form to be used for addressing the page
+ * @form_spec: Form specific information like phy number
+ *
+ * This is handler for config page read for a specific SAS
+ * Expander page1. The ioc_status has the controller returned
+ * ioc_status. This routine doesn't check ioc_status to decide
+ * whether the page read is success or not and it is the callers
+ * responsibility.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_sas_exp_pg1(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_sas_expander_page1 *exp_pg1, u16 pg_sz, u32 form,
+	u32 form_spec)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u32 page_address;
+
+	memset(exp_pg1, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_SAS_EXPANDER;
+	cfg_req.page_number = 1;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "expander page1 header read failed\n");
+		goto out_failed;
+	}
+	if (*ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "expander page1 header read failed with ioc_status(0x%04x)\n",
+		    *ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+	page_address = ((form & MPI3_SAS_EXPAND_PGAD_FORM_MASK) |
+	    (form_spec & (MPI3_SAS_EXPAND_PGAD_PHYNUM_MASK |
+	    MPI3_SAS_EXPAND_PGAD_HANDLE_MASK)));
+	cfg_req.page_address = cpu_to_le32(page_address);
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, exp_pg1, pg_sz)) {
+		ioc_err(mrioc, "expander page1 read failed\n");
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_get_enclosure_pg0 - Read current Enclosure page0
+ * @mrioc: Adapter instance reference
+ * @ioc_status: Pointer to return ioc status
+ * @encl_pg0: Pointer to return Enclosure page 0
+ * @pg_sz: Size of the memory allocated to the page pointer
+ * @form: The form to be used for addressing the page
+ * @form_spec: Form specific information like device handle
+ *
+ * This is handler for config page read for a specific Enclosure
+ * page0. The ioc_status has the controller returned ioc_status.
+ * This routine doesn't check ioc_status to decide whether the
+ * page read is success or not and it is the callers
+ * responsibility.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_enclosure_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
+	struct mpi3_enclosure_page0 *encl_pg0, u16 pg_sz, u32 form,
+	u32 form_spec)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u32 page_address;
+
+	memset(encl_pg0, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_ENCLOSURE;
+	cfg_req.page_number = 0;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "enclosure page0 header read failed\n");
+		goto out_failed;
+	}
+	if (*ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "enclosure page0 header read failed with ioc_status(0x%04x)\n",
+		    *ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+	page_address = ((form & MPI3_ENCLOS_PGAD_FORM_MASK) |
+	    (form_spec & MPI3_ENCLOS_PGAD_HANDLE_MASK));
+	cfg_req.page_address = cpu_to_le32(page_address);
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, ioc_status, encl_pg0, pg_sz)) {
+		ioc_err(mrioc, "enclosure page0 read failed\n");
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+
+/**
+ * mpi3mr_cfg_get_sas_io_unit_pg0 - Read current SASIOUnit page0
+ * @mrioc: Adapter instance reference
+ * @sas_io_unit_pg0: Pointer to return SAS IO Unit page 0
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page read for the SAS IO Unit
+ * page0. This routine checks ioc_status to decide whether the
+ * page read is success or not.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_sas_io_unit_pg0(struct mpi3mr_ioc *mrioc,
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(sas_io_unit_pg0, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT;
+	cfg_req.page_number = 0;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "sas io unit page0 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas io unit page0 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg0, pg_sz)) {
+		ioc_err(mrioc, "sas io unit page0 read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas io unit page0 read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_get_sas_io_unit_pg1 - Read current SASIOUnit page1
+ * @mrioc: Adapter instance reference
+ * @sas_io_unit_pg1: Pointer to return SAS IO Unit page 1
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page read for the SAS IO Unit
+ * page1. This routine checks ioc_status to decide whether the
+ * page read is success or not.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
+	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(sas_io_unit_pg1, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT;
+	cfg_req.page_number = 1;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "sas io unit page1 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas io unit page1 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg1, pg_sz)) {
+		ioc_err(mrioc, "sas io unit page1 read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas io unit page1 read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_set_sas_io_unit_pg1 - Write SASIOUnit page1
+ * @mrioc: Adapter instance reference
+ * @sas_io_unit_pg1: Pointer to the SAS IO Unit page 1 to write
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page write for the SAS IO Unit
+ * page1. This routine checks ioc_status to decide whether the
+ * page read is success or not. This will modify both current
+ * and persistent page.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
+	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT;
+	cfg_req.page_number = 1;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "sas io unit page1 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas io unit page1 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_WRITE_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg1, pg_sz)) {
+		ioc_err(mrioc, "sas io unit page1 write current failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas io unit page1 write current failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+
+	cfg_req.action = MPI3_CONFIG_ACTION_WRITE_PERSISTENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, sas_io_unit_pg1, pg_sz)) {
+		ioc_err(mrioc, "sas io unit page1 write persistent failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "sas io unit page1 write persistent failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
+
+/**
+ * mpi3mr_cfg_get_driver_pg1 - Read current Driver page1
+ * @mrioc: Adapter instance reference
+ * @driver_pg1: Pointer to return Driver page 1
+ * @pg_sz: Size of the memory allocated to the page pointer
+ *
+ * This is handler for config page read for the Driver page1.
+ * This routine checks ioc_status to decide whether the page
+ * read is success or not.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
+	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz)
+{
+	struct mpi3_config_page_header cfg_hdr;
+	struct mpi3_config_request cfg_req;
+	u16 ioc_status = 0;
+
+	memset(driver_pg1, 0, pg_sz);
+	memset(&cfg_hdr, 0, sizeof(cfg_hdr));
+	memset(&cfg_req, 0, sizeof(cfg_req));
+
+	cfg_req.function = MPI3_FUNCTION_CONFIG;
+	cfg_req.action = MPI3_CONFIG_ACTION_PAGE_HEADER;
+	cfg_req.page_type = MPI3_CONFIG_PAGETYPE_DRIVER;
+	cfg_req.page_number = 1;
+	cfg_req.page_address = 0;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, NULL,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, &cfg_hdr, sizeof(cfg_hdr))) {
+		ioc_err(mrioc, "driver page1 header read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "driver page1 header read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	cfg_req.action = MPI3_CONFIG_ACTION_READ_CURRENT;
+
+	if (mpi3mr_process_cfg_req(mrioc, &cfg_req, &cfg_hdr,
+	    MPI3MR_INTADMCMD_TIMEOUT, &ioc_status, driver_pg1, pg_sz)) {
+		ioc_err(mrioc, "driver page1 read failed\n");
+		goto out_failed;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "driver page1 read failed with ioc_status(0x%04x)\n",
+		    ioc_status);
+		goto out_failed;
+	}
+	return 0;
+out_failed:
+	return -1;
+}
-- 
2.27.0


--000000000000f3402205e569eed6
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJuPN+xS0WPHP3GidVD7
eyMy9EonKeh1NJyYpNDnZWJPMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDAyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDELTsTgzO6h0YTRKmH8of3Nw5bV7Abi3PBBA9Q
yEs3AI/8XJzMDRntB62/AKpMj/4Yznc4WI6cFzvcy0S3NRz8wwEeEHbip/95JetZbRbXxQvDLKod
v38BdwPcj9H6VoK7jR4PzzWjmgjivq2vIOcRGkNd/oyvKT5vdnWz9SgW1oMgy4vNVwu1BuS0YHlZ
ZE37bnOIFq6EKnb5G68VVxskPyIaBsl+19/kqYkfnbxRIdhDckpV+ipyWk/BwBb4Le/VLlaNYhKD
hpess+3piG3hEvDa3y6pVKpymdpEN8N5AcFrdCFttiBd3l1Eg2l4hqj9TwjaxJUanFpxv7AN1zVk
--000000000000f3402205e569eed6--
