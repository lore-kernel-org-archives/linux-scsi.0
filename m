Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCE0C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbiHDNBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiHDNA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EDC635D
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:53 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d20so11862654pfq.5
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=VbvyEbJ6UdzKaqyMuuf1VQO5DoDtRIqCQKkiAYDH6MU=;
        b=OcQp+WLR47X+dd8ESLS47QOZ6faXXsjuBCDfP4IEygQnbZKw7e24tzpuvGFjgewyPB
         bZLSIUxiYkcLCkpiirXoYe/OrR0dwKMsOYu2EmJMiBiAy92ENdSnaBtmtdTFLW/NtYMR
         tIDGOZG8uiqgdjXwfHbztVZd4iyosA0xIJmVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=VbvyEbJ6UdzKaqyMuuf1VQO5DoDtRIqCQKkiAYDH6MU=;
        b=x+O5h+jDI6Q2eej4HqkPjLZYSWUuF4Woz0uY0XAXYE3WZtS3xUxU05Q/sBJHpaBUyy
         aSCjUpzk+8bbeHuMH2XaXYgnFyNEUoV0z6x0h3HAAmny9xBNxzrmvI2S85LmaOoT4Frk
         IhH5Og7nokOE3HChZLg2vkUh+/jq8BfhzIEe2g53mh85NtctQBEFSYhiARxAHouXd7FG
         BuFPp88w3LUTPXJ3gnYUWN7mjuSmtAVFIIR31wP6N00rTLeaFttyNCjRE6N3QwH/+Pff
         uzwGv2asQcSHh1n2XlrRRnAM6Fsz1bzOoh5jaFdwO47OBm/I8OGEmcp1Vi+Y7ifYC2jv
         +Y6g==
X-Gm-Message-State: ACgBeo2wTFTomj3uzJvM3OaRA0mCO1qBOt5trM+i4YA6y+rDfyeLzHgF
        ipr/VO/f+HFvJf5+Z+Pzd80UhTyw8HYFEQUhF9EzCWicOdI3DLMRygv64mf0NhiUcd5pt9xpFwW
        fQusiQfKbxDPRD4HjT3ZEUumtR7mIYE5aHCUqfoJF8gVdkqz4eGNYphbWA/kNOI/iv9bMvJ+QTy
        I+SRdovQ9W
X-Google-Smtp-Source: AA6agR63erpRSDAkSPY+QtjxF5zFhahr6HXINhE/D0hk6xTEjChykXRwzGC62Bx1UtC9xwVJkBpwCQ==
X-Received: by 2002:aa7:8317:0:b0:52d:640e:322e with SMTP id bk23-20020aa78317000000b0052d640e322emr1880185pfb.4.1659618051569;
        Thu, 04 Aug 2022 06:00:51 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:51 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 13/15] mpi3mr: Support sas transport class callbacks
Date:   Thu,  4 Aug 2022 18:42:24 +0530
Message-Id: <20220804131226.16653-14-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007f958505e569f039"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000007f958505e569f039
Content-Transfer-Encoding: 8bit

Added support for below sas transport class callbacks,
- get_linkerrors
- get_enclosure_identifier
- get_bay_identifier
- phy_reset
- phy_enable
- set_phy_speed
- smp_handler

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |   3 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |   1 +
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  20 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 893 +++++++++++++++++++++++++
 4 files changed, 915 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index a6c880c..d203167 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1326,6 +1326,9 @@ struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
 extern const struct attribute_group *mpi3mr_host_groups[];
 extern const struct attribute_group *mpi3mr_dev_groups[];
 
+extern struct sas_function_template mpi3mr_transport_functions;
+extern struct scsi_transport_template *mpi3mr_transport_template;
+
 int mpi3mr_cfg_get_dev_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
 	struct mpi3_device_page0 *dev_pg0, u16 pg_sz, u32 form, u32 form_spec);
 int mpi3mr_cfg_get_sas_phy_pg0(struct mpi3mr_ioc *mrioc, u16 *ioc_status,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index cbc346d..866ad22 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3754,6 +3754,7 @@ retry_init:
 		mrioc->sas_transport_enabled = 1;
 		mrioc->scsi_device_channel = 1;
 		mrioc->shost->max_channel = 1;
+		mrioc->shost->transportt = mpi3mr_transport_template;
 	}
 
 	mrioc->reply_sz = mrioc->facts.reply_sz;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 048c9dd..71f1cef 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5169,18 +5169,33 @@ static int __init mpi3mr_init(void)
 	pr_info("Loading %s version %s\n", MPI3MR_DRIVER_NAME,
 	    MPI3MR_DRIVER_VERSION);
 
+	mpi3mr_transport_template =
+	    sas_attach_transport(&mpi3mr_transport_functions);
+	if (!mpi3mr_transport_template) {
+		pr_err("%s failed to load due to sas transport attach failure\n",
+		    MPI3MR_DRIVER_NAME);
+		return -ENODEV;
+	}
+
 	ret_val = pci_register_driver(&mpi3mr_pci_driver);
 	if (ret_val) {
 		pr_err("%s failed to load due to pci register driver failure\n",
 		    MPI3MR_DRIVER_NAME);
-		return ret_val;
+		goto err_pci_reg_fail;
 	}
 
 	ret_val = driver_create_file(&mpi3mr_pci_driver.driver,
 				     &driver_attr_event_counter);
 	if (ret_val)
-		pci_unregister_driver(&mpi3mr_pci_driver);
+		goto err_event_counter;
+
+	return ret_val;
+
+err_event_counter:
+	pci_unregister_driver(&mpi3mr_pci_driver);
 
+err_pci_reg_fail:
+	sas_release_transport(mpi3mr_transport_template);
 	return ret_val;
 }
 
@@ -5197,6 +5212,7 @@ static void __exit mpi3mr_exit(void)
 	driver_remove_file(&mpi3mr_pci_driver.driver,
 			   &driver_attr_event_counter);
 	pci_unregister_driver(&mpi3mr_pci_driver);
+	sas_release_transport(mpi3mr_transport_template);
 }
 
 module_init(mpi3mr_init);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 22da497..b7fcfb3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2038,3 +2038,895 @@ void mpi3mr_remove_tgtdev_from_sas_transport(struct mpi3mr_ioc *mrioc,
 	    hba_port);
 	tgtdev->host_exposed = 0;
 }
+
+/**
+ * mpi3mr_get_port_id_by_sas_phy -  Get port ID of the given phy
+ * @phy: SAS transport layer phy object
+ *
+ * Return: Port number for valid ID else 0xFFFF
+ */
+static inline u8 mpi3mr_get_port_id_by_sas_phy(struct sas_phy *phy)
+{
+	u8 port_id = 0xFF;
+	struct mpi3mr_hba_port *hba_port = phy->hostdata;
+
+	if (hba_port)
+		port_id = hba_port->port_id;
+
+	return port_id;
+}
+
+/**
+ * mpi3mr_get_port_id_by_rphy - Get Port number from SAS rphy
+ *
+ * @mrioc: Adapter instance reference
+ * @rphy: SAS transport layer remote phy object
+ *
+ * Retrieves HBA port number in which the device pointed by the
+ * rphy object is attached with.
+ *
+ * Return: Valid port number on success else OxFFFF.
+ */
+static u8 mpi3mr_get_port_id_by_rphy(struct mpi3mr_ioc *mrioc, struct sas_rphy *rphy)
+{
+	struct mpi3mr_sas_node *sas_expander;
+	struct mpi3mr_tgt_dev *tgtdev;
+	unsigned long flags;
+	u8 port_id = 0xFF;
+
+	if (!rphy)
+		return port_id;
+
+	if (rphy->identify.device_type == SAS_EDGE_EXPANDER_DEVICE ||
+	    rphy->identify.device_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+		list_for_each_entry(sas_expander, &mrioc->sas_expander_list,
+		    list) {
+			if (sas_expander->rphy == rphy) {
+				port_id = sas_expander->hba_port->port_id;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+	} else if (rphy->identify.device_type == SAS_END_DEVICE) {
+		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+
+		tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
+			    rphy->identify.sas_address, rphy);
+		if (tgtdev) {
+			port_id =
+				tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
+			mpi3mr_tgtdev_put(tgtdev);
+		}
+		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+	}
+	return port_id;
+}
+
+static inline struct mpi3mr_ioc *phy_to_mrioc(struct sas_phy *phy)
+{
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+
+	return shost_priv(shost);
+}
+
+static inline struct mpi3mr_ioc *rphy_to_mrioc(struct sas_rphy *rphy)
+{
+	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent->parent);
+
+	return shost_priv(shost);
+}
+
+/* report phy error log structure */
+struct phy_error_log_request {
+	u8 smp_frame_type; /* 0x40 */
+	u8 function; /* 0x11 */
+	u8 allocated_response_length;
+	u8 request_length; /* 02 */
+	u8 reserved_1[5];
+	u8 phy_identifier;
+	u8 reserved_2[2];
+};
+
+/* report phy error log reply structure */
+struct phy_error_log_reply {
+	u8 smp_frame_type; /* 0x41 */
+	u8 function; /* 0x11 */
+	u8 function_result;
+	u8 response_length;
+	__be16 expander_change_count;
+	u8 reserved_1[3];
+	u8 phy_identifier;
+	u8 reserved_2[2];
+	__be32 invalid_dword;
+	__be32 running_disparity_error;
+	__be32 loss_of_dword_sync;
+	__be32 phy_reset_problem;
+};
+
+
+/**
+ * mpi3mr_get_expander_phy_error_log - return expander counters:
+ * @mrioc: Adapter instance reference
+ * @phy: The SAS transport layer phy object
+ *
+ * Return: 0 for success, non-zero for failure.
+ *
+ */
+static int mpi3mr_get_expander_phy_error_log(struct mpi3mr_ioc *mrioc,
+	struct sas_phy *phy)
+{
+	struct mpi3_smp_passthrough_request mpi_request;
+	struct mpi3_smp_passthrough_reply mpi_reply;
+	struct phy_error_log_request *phy_error_log_request;
+	struct phy_error_log_reply *phy_error_log_reply;
+	int rc;
+	void *psge;
+	void *data_out = NULL;
+	dma_addr_t data_out_dma, data_in_dma;
+	u32 data_out_sz, data_in_sz, sz;
+	u8 sgl_flags = MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
+	u16 request_sz = sizeof(struct mpi3_smp_passthrough_request);
+	u16 reply_sz = sizeof(struct mpi3_smp_passthrough_reply);
+	u16 ioc_status;
+
+	if (mrioc->reset_in_progress) {
+		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
+		return -EFAULT;
+	}
+
+	data_out_sz = sizeof(struct phy_error_log_request);
+	data_in_sz = sizeof(struct phy_error_log_reply);
+	sz = data_out_sz + data_in_sz;
+	data_out = dma_alloc_coherent(&mrioc->pdev->dev, sz, &data_out_dma,
+	    GFP_KERNEL);
+	if (!data_out) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	data_in_dma = data_out_dma + data_out_sz;
+	phy_error_log_reply = data_out + data_out_sz;
+
+	rc = -EINVAL;
+	memset(data_out, 0, sz);
+	phy_error_log_request = data_out;
+	phy_error_log_request->smp_frame_type = 0x40;
+	phy_error_log_request->function = 0x11;
+	phy_error_log_request->request_length = 2;
+	phy_error_log_request->allocated_response_length = 0;
+	phy_error_log_request->phy_identifier = phy->number;
+
+	memset(&mpi_request, 0, request_sz);
+	memset(&mpi_reply, 0, reply_sz);
+	mpi_request.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
+	mpi_request.function = MPI3_FUNCTION_SMP_PASSTHROUGH;
+	mpi_request.io_unit_port = (u8) mpi3mr_get_port_id_by_sas_phy(phy);
+	mpi_request.sas_address = cpu_to_le64(phy->identify.sas_address);
+
+	psge = &mpi_request.request_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, data_out_sz, data_out_dma);
+
+	psge = &mpi_request.response_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, data_in_sz, data_in_dma);
+
+	dprint_transport_info(mrioc,
+	    "sending phy error log SMP request to sas_address(0x%016llx), phy_id(%d)\n",
+	    (unsigned long long)phy->identify.sas_address, phy->number);
+
+	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
+	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
+		goto out;
+
+	dprint_transport_info(mrioc,
+	    "phy error log SMP request completed with ioc_status(0x%04x)\n",
+	    ioc_status);
+
+	if (ioc_status == MPI3_IOCSTATUS_SUCCESS) {
+		dprint_transport_info(mrioc,
+		    "phy error log - reply data transfer size(%d)\n",
+		    le16_to_cpu(mpi_reply.response_data_length));
+
+		if (le16_to_cpu(mpi_reply.response_data_length) !=
+		    sizeof(struct phy_error_log_reply))
+			goto out;
+
+		dprint_transport_info(mrioc,
+		    "phy error log - function_result(%d)\n",
+		    phy_error_log_reply->function_result);
+
+		phy->invalid_dword_count =
+		    be32_to_cpu(phy_error_log_reply->invalid_dword);
+		phy->running_disparity_error_count =
+		    be32_to_cpu(phy_error_log_reply->running_disparity_error);
+		phy->loss_of_dword_sync_count =
+		    be32_to_cpu(phy_error_log_reply->loss_of_dword_sync);
+		phy->phy_reset_problem_count =
+		    be32_to_cpu(phy_error_log_reply->phy_reset_problem);
+		rc = 0;
+	}
+
+out:
+	if (data_out)
+		dma_free_coherent(&mrioc->pdev->dev, sz, data_out,
+		    data_out_dma);
+
+	return rc;
+}
+
+/**
+ * mpi3mr_transport_get_linkerrors - return phy error counters
+ * @phy: The SAS transport layer phy object
+ *
+ * This function retrieves the phy error log information of the
+ * HBA or expander for which the phy belongs to
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_transport_get_linkerrors(struct sas_phy *phy)
+{
+	struct mpi3mr_ioc *mrioc = phy_to_mrioc(phy);
+	struct mpi3_sas_phy_page1 phy_pg1;
+	int rc = 0;
+	u16 ioc_status;
+
+	rc = mpi3mr_parent_present(mrioc, phy);
+	if (rc)
+		return rc;
+
+	if (phy->identify.sas_address != mrioc->sas_hba.sas_address)
+		return mpi3mr_get_expander_phy_error_log(mrioc, phy);
+
+	memset(&phy_pg1, 0, sizeof(struct mpi3_sas_phy_page1));
+	/* get hba phy error logs */
+	if ((mpi3mr_cfg_get_sas_phy_pg1(mrioc, &ioc_status, &phy_pg1,
+	    sizeof(struct mpi3_sas_phy_page1),
+	    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, phy->number))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -ENXIO;
+	}
+
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -ENXIO;
+	}
+	phy->invalid_dword_count = le32_to_cpu(phy_pg1.invalid_dword_count);
+	phy->running_disparity_error_count =
+		le32_to_cpu(phy_pg1.running_disparity_error_count);
+	phy->loss_of_dword_sync_count =
+		le32_to_cpu(phy_pg1.loss_dword_synch_count);
+	phy->phy_reset_problem_count =
+		le32_to_cpu(phy_pg1.phy_reset_problem_count);
+	return 0;
+}
+
+/**
+ * mpi3mr_transport_get_enclosure_identifier - Get Enclosure ID
+ * @rphy: The SAS transport layer remote phy object
+ * @identifier: Enclosure identifier to be returned
+ *
+ * Returns the enclosure id for the device pointed by the remote
+ * phy object.
+ *
+ * Return: 0 on success or -ENXIO
+ */
+static int
+mpi3mr_transport_get_enclosure_identifier(struct sas_rphy *rphy,
+	u64 *identifier)
+{
+	struct mpi3mr_ioc *mrioc = rphy_to_mrioc(rphy);
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
+	    rphy->identify.sas_address, rphy);
+	if (tgtdev) {
+		*identifier =
+			tgtdev->enclosure_logical_id;
+		rc = 0;
+		mpi3mr_tgtdev_put(tgtdev);
+	} else {
+		*identifier = 0;
+		rc = -ENXIO;
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
+	return rc;
+}
+
+/**
+ * mpi3mr_transport_get_bay_identifier - Get bay ID
+ * @rphy: The SAS transport layer remote phy object
+ *
+ * Returns the slot id for the device pointed by the remote phy
+ * object.
+ *
+ * Return: Valid slot ID on success or -ENXIO
+ */
+static int
+mpi3mr_transport_get_bay_identifier(struct sas_rphy *rphy)
+{
+	struct mpi3mr_ioc *mrioc = rphy_to_mrioc(rphy);
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
+	    rphy->identify.sas_address, rphy);
+	if (tgtdev) {
+		rc = tgtdev->slot;
+		mpi3mr_tgtdev_put(tgtdev);
+	} else
+		rc = -ENXIO;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
+	return rc;
+}
+
+/* phy control request structure */
+struct phy_control_request {
+	u8 smp_frame_type; /* 0x40 */
+	u8 function; /* 0x91 */
+	u8 allocated_response_length;
+	u8 request_length; /* 0x09 */
+	u16 expander_change_count;
+	u8 reserved_1[3];
+	u8 phy_identifier;
+	u8 phy_operation;
+	u8 reserved_2[13];
+	u64 attached_device_name;
+	u8 programmed_min_physical_link_rate;
+	u8 programmed_max_physical_link_rate;
+	u8 reserved_3[6];
+};
+
+/* phy control reply structure */
+struct phy_control_reply {
+	u8 smp_frame_type; /* 0x41 */
+	u8 function; /* 0x11 */
+	u8 function_result;
+	u8 response_length;
+};
+
+#define SMP_PHY_CONTROL_LINK_RESET	(0x01)
+#define SMP_PHY_CONTROL_HARD_RESET	(0x02)
+#define SMP_PHY_CONTROL_DISABLE		(0x03)
+
+/**
+ * mpi3mr_expander_phy_control - expander phy control
+ * @mrioc: Adapter instance reference
+ * @phy: The SAS transport layer phy object
+ * @phy_operation: The phy operation to be executed
+ *
+ * Issues SMP passthru phy control request to execute a specific
+ * phy operation for a given expander device.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+mpi3mr_expander_phy_control(struct mpi3mr_ioc *mrioc,
+	struct sas_phy *phy, u8 phy_operation)
+{
+	struct mpi3_smp_passthrough_request mpi_request;
+	struct mpi3_smp_passthrough_reply mpi_reply;
+	struct phy_control_request *phy_control_request;
+	struct phy_control_reply *phy_control_reply;
+	int rc;
+	void *psge;
+	void *data_out = NULL;
+	dma_addr_t data_out_dma;
+	dma_addr_t data_in_dma;
+	size_t data_in_sz;
+	size_t data_out_sz;
+	u8 sgl_flags = MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
+	u16 request_sz = sizeof(struct mpi3_smp_passthrough_request);
+	u16 reply_sz = sizeof(struct mpi3_smp_passthrough_reply);
+	u16 ioc_status;
+	u16 sz;
+
+	if (mrioc->reset_in_progress) {
+		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
+		return -EFAULT;
+	}
+
+	data_out_sz = sizeof(struct phy_control_request);
+	data_in_sz = sizeof(struct phy_control_reply);
+	sz = data_out_sz + data_in_sz;
+	data_out = dma_alloc_coherent(&mrioc->pdev->dev, sz, &data_out_dma,
+	    GFP_KERNEL);
+	if (!data_out) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	data_in_dma = data_out_dma + data_out_sz;
+	phy_control_reply = data_out + data_out_sz;
+
+	rc = -EINVAL;
+	memset(data_out, 0, sz);
+
+	phy_control_request = data_out;
+	phy_control_request->smp_frame_type = 0x40;
+	phy_control_request->function = 0x91;
+	phy_control_request->request_length = 9;
+	phy_control_request->allocated_response_length = 0;
+	phy_control_request->phy_identifier = phy->number;
+	phy_control_request->phy_operation = phy_operation;
+	phy_control_request->programmed_min_physical_link_rate =
+	    phy->minimum_linkrate << 4;
+	phy_control_request->programmed_max_physical_link_rate =
+	    phy->maximum_linkrate << 4;
+
+	memset(&mpi_request, 0, request_sz);
+	memset(&mpi_reply, 0, reply_sz);
+	mpi_request.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
+	mpi_request.function = MPI3_FUNCTION_SMP_PASSTHROUGH;
+	mpi_request.io_unit_port = (u8) mpi3mr_get_port_id_by_sas_phy(phy);
+	mpi_request.sas_address = cpu_to_le64(phy->identify.sas_address);
+
+	psge = &mpi_request.request_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, data_out_sz, data_out_dma);
+
+	psge = &mpi_request.response_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, data_in_sz, data_in_dma);
+
+	dprint_transport_info(mrioc,
+	    "sending phy control SMP request to sas_address(0x%016llx), phy_id(%d) opcode(%d)\n",
+	    (unsigned long long)phy->identify.sas_address, phy->number,
+	    phy_operation);
+
+	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
+	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
+		goto out;
+
+	dprint_transport_info(mrioc,
+	    "phy control SMP request completed with ioc_status(0x%04x)\n",
+	    ioc_status);
+
+	if (ioc_status == MPI3_IOCSTATUS_SUCCESS) {
+		dprint_transport_info(mrioc,
+		    "phy control - reply data transfer size(%d)\n",
+		    le16_to_cpu(mpi_reply.response_data_length));
+
+		if (le16_to_cpu(mpi_reply.response_data_length) !=
+		    sizeof(struct phy_control_reply))
+			goto out;
+		dprint_transport_info(mrioc,
+		    "phy control - function_result(%d)\n",
+		    phy_control_reply->function_result);
+		rc = 0;
+	}
+ out:
+	if (data_out)
+		dma_free_coherent(&mrioc->pdev->dev, sz, data_out,
+		    data_out_dma);
+
+	return rc;
+}
+
+/**
+ * mpi3mr_transport_phy_reset - Reset a given phy
+ * @phy: The SAS transport layer phy object
+ * @hard_reset: Flag to indicate the type of reset
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+mpi3mr_transport_phy_reset(struct sas_phy *phy, int hard_reset)
+{
+	struct mpi3mr_ioc *mrioc = phy_to_mrioc(phy);
+	struct mpi3_iounit_control_request mpi_request;
+	struct mpi3_iounit_control_reply mpi_reply;
+	u16 request_sz = sizeof(struct mpi3_iounit_control_request);
+	u16 reply_sz = sizeof(struct mpi3_iounit_control_reply);
+	int rc = 0;
+	u16 ioc_status;
+
+	rc = mpi3mr_parent_present(mrioc, phy);
+	if (rc)
+		return rc;
+
+	/* handle expander phys */
+	if (phy->identify.sas_address != mrioc->sas_hba.sas_address)
+		return mpi3mr_expander_phy_control(mrioc, phy,
+		    (hard_reset == 1) ? SMP_PHY_CONTROL_HARD_RESET :
+		    SMP_PHY_CONTROL_LINK_RESET);
+
+	/* handle hba phys */
+	memset(&mpi_request, 0, request_sz);
+	mpi_request.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
+	mpi_request.function = MPI3_FUNCTION_IO_UNIT_CONTROL;
+	mpi_request.operation = MPI3_CTRL_OP_SAS_PHY_CONTROL;
+	mpi_request.param8[MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_ACTION_INDEX] =
+		(hard_reset ? MPI3_CTRL_ACTION_HARD_RESET :
+		 MPI3_CTRL_ACTION_LINK_RESET);
+	mpi_request.param8[MPI3_CTRL_OP_SAS_PHY_CONTROL_PARAM8_PHY_INDEX] =
+		phy->number;
+
+	dprint_transport_info(mrioc,
+	    "sending phy reset request to sas_address(0x%016llx), phy_id(%d) hard_reset(%d)\n",
+	    (unsigned long long)phy->identify.sas_address, phy->number,
+	    hard_reset);
+
+	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
+	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status)) {
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	dprint_transport_info(mrioc,
+	    "phy reset request completed with ioc_status(0x%04x)\n",
+	    ioc_status);
+out:
+	return rc;
+}
+
+/**
+ * mpi3mr_transport_phy_enable - enable/disable phys
+ * @phy: The SAS transport layer phy object
+ * @enable: flag to enable/disable, enable phy when true
+ *
+ * This function enables/disables a given by executing required
+ * configuration page changes or expander phy control command
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+mpi3mr_transport_phy_enable(struct sas_phy *phy, int enable)
+{
+	struct mpi3mr_ioc *mrioc = phy_to_mrioc(phy);
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
+	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1 = NULL;
+	u16 sz;
+	int rc = 0;
+	int i, discovery_active;
+
+	rc = mpi3mr_parent_present(mrioc, phy);
+	if (rc)
+		return rc;
+
+	/* handle expander phys */
+	if (phy->identify.sas_address != mrioc->sas_hba.sas_address)
+		return mpi3mr_expander_phy_control(mrioc, phy,
+		    (enable == 1) ? SMP_PHY_CONTROL_LINK_RESET :
+		    SMP_PHY_CONTROL_DISABLE);
+
+	/* handle hba phys */
+	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
+		(mrioc->sas_hba.num_phys *
+		 sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg0) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* unable to enable/disable phys when discovery is active */
+	for (i = 0, discovery_active = 0; i < mrioc->sas_hba.num_phys ; i++) {
+		if (sas_io_unit_pg0->phy_data[i].port_flags &
+		    MPI3_SASIOUNIT0_PORTFLAGS_DISC_IN_PROGRESS) {
+			ioc_err(mrioc,
+			    "discovery is active on port = %d, phy = %d\n"
+			    "\tunable to enable/disable phys, try again later!\n",
+			    sas_io_unit_pg0->phy_data[i].io_unit_port, i);
+			discovery_active = 1;
+		}
+	}
+
+	if (discovery_active) {
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	if ((sas_io_unit_pg0->phy_data[phy->number].phy_flags &
+	     (MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
+	      MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* read sas_iounit page 1 */
+	sz = offsetof(struct mpi3_sas_io_unit_page1, phy_data) +
+		(mrioc->sas_hba.num_phys *
+		 sizeof(struct mpi3_sas_io_unit1_phy_data));
+	sas_io_unit_pg1 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg1) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (mpi3mr_cfg_get_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (enable)
+		sas_io_unit_pg1->phy_data[phy->number].phy_flags
+		    &= ~MPI3_SASIOUNIT1_PHYFLAGS_PHY_DISABLE;
+	else
+		sas_io_unit_pg1->phy_data[phy->number].phy_flags
+		    |= MPI3_SASIOUNIT1_PHYFLAGS_PHY_DISABLE;
+
+	mpi3mr_cfg_set_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz);
+
+	/* link reset */
+	if (enable)
+		mpi3mr_transport_phy_reset(phy, 0);
+
+ out:
+	kfree(sas_io_unit_pg1);
+	kfree(sas_io_unit_pg0);
+	return rc;
+}
+
+/**
+ * mpi3mr_transport_phy_speed - set phy min/max speed
+ * @phy: The SAS transport later phy object
+ * @rates: Rates defined as in sas_phy_linkrates
+ *
+ * This function sets the link rates given in the rates
+ * argument to the given phy by executing required configuration
+ * page changes or expander phy control command
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+mpi3mr_transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
+{
+	struct mpi3mr_ioc *mrioc = phy_to_mrioc(phy);
+	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1 = NULL;
+	struct mpi3_sas_phy_page0 phy_pg0;
+	u16 sz, ioc_status;
+	int rc = 0;
+
+	rc = mpi3mr_parent_present(mrioc, phy);
+	if (rc)
+		return rc;
+
+	if (!rates->minimum_linkrate)
+		rates->minimum_linkrate = phy->minimum_linkrate;
+	else if (rates->minimum_linkrate < phy->minimum_linkrate_hw)
+		rates->minimum_linkrate = phy->minimum_linkrate_hw;
+
+	if (!rates->maximum_linkrate)
+		rates->maximum_linkrate = phy->maximum_linkrate;
+	else if (rates->maximum_linkrate > phy->maximum_linkrate_hw)
+		rates->maximum_linkrate = phy->maximum_linkrate_hw;
+
+	/* handle expander phys */
+	if (phy->identify.sas_address != mrioc->sas_hba.sas_address) {
+		phy->minimum_linkrate = rates->minimum_linkrate;
+		phy->maximum_linkrate = rates->maximum_linkrate;
+		return mpi3mr_expander_phy_control(mrioc, phy,
+		    SMP_PHY_CONTROL_LINK_RESET);
+	}
+
+	/* handle hba phys */
+	sz = offsetof(struct mpi3_sas_io_unit_page1, phy_data) +
+		(mrioc->sas_hba.num_phys *
+		 sizeof(struct mpi3_sas_io_unit1_phy_data));
+	sas_io_unit_pg1 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg1) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (mpi3mr_cfg_get_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	sas_io_unit_pg1->phy_data[phy->number].max_min_link_rate =
+		(rates->minimum_linkrate + (rates->maximum_linkrate << 4));
+
+	if (mpi3mr_cfg_set_sas_io_unit_pg1(mrioc, sas_io_unit_pg1, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* link reset */
+	mpi3mr_transport_phy_reset(phy, 0);
+
+	/* read phy page 0, then update the rates in the sas transport phy */
+	if (!mpi3mr_cfg_get_sas_phy_pg0(mrioc, &ioc_status, &phy_pg0,
+	    sizeof(struct mpi3_sas_phy_page0),
+	    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, phy->number) &&
+	    (ioc_status == MPI3_IOCSTATUS_SUCCESS)) {
+		phy->minimum_linkrate = mpi3mr_convert_phy_link_rate(
+		    phy_pg0.programmed_link_rate &
+		    MPI3_SAS_PRATE_MIN_RATE_MASK);
+		phy->maximum_linkrate = mpi3mr_convert_phy_link_rate(
+		    phy_pg0.programmed_link_rate >> 4);
+		phy->negotiated_linkrate =
+			mpi3mr_convert_phy_link_rate(
+			    (phy_pg0.negotiated_link_rate &
+			    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK)
+			    >> MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
+	}
+
+out:
+	kfree(sas_io_unit_pg1);
+	return rc;
+}
+
+/**
+ * mpi3mr_map_smp_buffer - map BSG dma buffer
+ * @dev: Generic device reference
+ * @buf: BSG buffer pointer
+ * @dma_addr: Physical address holder
+ * @dma_len: Mapped DMA buffer length.
+ * @p: Virtual address holder
+ *
+ * This function maps the DMAable buffer
+ *
+ * Return: 0 on success, non-zero on failure
+ */
+static int
+mpi3mr_map_smp_buffer(struct device *dev, struct bsg_buffer *buf,
+		dma_addr_t *dma_addr, size_t *dma_len, void **p)
+{
+	/* Check if the request is split across multiple segments */
+	if (buf->sg_cnt > 1) {
+		*p = dma_alloc_coherent(dev, buf->payload_len, dma_addr,
+				GFP_KERNEL);
+		if (!*p)
+			return -ENOMEM;
+		*dma_len = buf->payload_len;
+	} else {
+		if (!dma_map_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL))
+			return -ENOMEM;
+		*dma_addr = sg_dma_address(buf->sg_list);
+		*dma_len = sg_dma_len(buf->sg_list);
+		*p = NULL;
+	}
+
+	return 0;
+}
+
+/**
+ * mpi3mr_unmap_smp_buffer - unmap BSG dma buffer
+ * @dev: Generic device reference
+ * @buf: BSG buffer pointer
+ * @dma_addr: Physical address to be unmapped
+ * @p: Virtual address
+ *
+ * This function unmaps the DMAable buffer
+ */
+static void
+mpi3mr_unmap_smp_buffer(struct device *dev, struct bsg_buffer *buf,
+		dma_addr_t dma_addr, void *p)
+{
+	if (p)
+		dma_free_coherent(dev, buf->payload_len, p, dma_addr);
+	else
+		dma_unmap_sg(dev, buf->sg_list, 1, DMA_BIDIRECTIONAL);
+}
+
+/**
+ * mpi3mr_transport_smp_handler - handler for smp passthru
+ * @job: BSG job reference
+ * @shost: SCSI host object reference
+ * @rphy: SAS transport rphy object pointing the expander
+ *
+ * This is used primarily by smp utils for sending the SMP
+ * commands to the expanders attached to the controller
+ */
+static void
+mpi3mr_transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
+	struct sas_rphy *rphy)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	struct mpi3_smp_passthrough_request mpi_request;
+	struct mpi3_smp_passthrough_reply mpi_reply;
+	int rc;
+	void *psge;
+	dma_addr_t dma_addr_in;
+	dma_addr_t dma_addr_out;
+	void *addr_in = NULL;
+	void *addr_out = NULL;
+	size_t dma_len_in;
+	size_t dma_len_out;
+	unsigned int reslen = 0;
+	u16 request_sz = sizeof(struct mpi3_smp_passthrough_request);
+	u16 reply_sz = sizeof(struct mpi3_smp_passthrough_reply);
+	u8 sgl_flags = MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
+	u16 ioc_status;
+
+	if (mrioc->reset_in_progress) {
+		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = mpi3mr_map_smp_buffer(&mrioc->pdev->dev, &job->request_payload,
+	    &dma_addr_out, &dma_len_out, &addr_out);
+	if (rc)
+		goto out;
+
+	if (addr_out)
+		sg_copy_to_buffer(job->request_payload.sg_list,
+		    job->request_payload.sg_cnt, addr_out,
+		    job->request_payload.payload_len);
+
+	rc = mpi3mr_map_smp_buffer(&mrioc->pdev->dev, &job->reply_payload,
+			&dma_addr_in, &dma_len_in, &addr_in);
+	if (rc)
+		goto unmap_out;
+
+	memset(&mpi_request, 0, request_sz);
+	memset(&mpi_reply, 0, reply_sz);
+	mpi_request.host_tag = cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
+	mpi_request.function = MPI3_FUNCTION_SMP_PASSTHROUGH;
+	mpi_request.io_unit_port = (u8) mpi3mr_get_port_id_by_rphy(mrioc, rphy);
+	mpi_request.sas_address = ((rphy) ?
+	    cpu_to_le64(rphy->identify.sas_address) :
+	    cpu_to_le64(mrioc->sas_hba.sas_address));
+	psge = &mpi_request.request_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, dma_len_out - 4, dma_addr_out);
+
+	psge = &mpi_request.response_sge;
+	mpi3mr_add_sg_single(psge, sgl_flags, dma_len_in - 4, dma_addr_in);
+
+	dprint_transport_info(mrioc, "sending SMP request\n");
+
+	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
+	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
+		goto unmap_in;
+
+	dprint_transport_info(mrioc,
+	    "SMP request completed with ioc_status(0x%04x)\n", ioc_status);
+
+	dprint_transport_info(mrioc,
+		    "SMP request - reply data transfer size(%d)\n",
+		    le16_to_cpu(mpi_reply.response_data_length));
+
+	memcpy(job->reply, &mpi_reply, reply_sz);
+	job->reply_len = reply_sz;
+	reslen = le16_to_cpu(mpi_reply.response_data_length);
+
+	if (addr_in)
+		sg_copy_from_buffer(job->reply_payload.sg_list,
+				job->reply_payload.sg_cnt, addr_in,
+				job->reply_payload.payload_len);
+
+	rc = 0;
+unmap_in:
+	mpi3mr_unmap_smp_buffer(&mrioc->pdev->dev, &job->reply_payload,
+			dma_addr_in, addr_in);
+unmap_out:
+	mpi3mr_unmap_smp_buffer(&mrioc->pdev->dev, &job->request_payload,
+			dma_addr_out, addr_out);
+out:
+	bsg_job_done(job, rc, reslen);
+}
+
+struct sas_function_template mpi3mr_transport_functions = {
+	.get_linkerrors		= mpi3mr_transport_get_linkerrors,
+	.get_enclosure_identifier = mpi3mr_transport_get_enclosure_identifier,
+	.get_bay_identifier	= mpi3mr_transport_get_bay_identifier,
+	.phy_reset		= mpi3mr_transport_phy_reset,
+	.phy_enable		= mpi3mr_transport_phy_enable,
+	.set_phy_speed		= mpi3mr_transport_phy_speed,
+	.smp_handler		= mpi3mr_transport_smp_handler,
+};
+
+struct scsi_transport_template *mpi3mr_transport_template;
-- 
2.27.0


--0000000000007f958505e569f039
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKslidIFwaDUHU0VsV/A
FUFrBMjLuijcwf6i2ckL37HkMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDA1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQATMTk0KTSJkQnWf9H1lMAsY3Gv9WSXrO7izxSt
vgjP2PcdIe2C6XZR7BCt9Aqv2DnuyACok5Rivpn5ygsYdkbW868uW4/jQZ4ugZajskgHU+tmW5OB
ZrDlt//E+Doc9EhS6HS3cbrVLOwtAwTXhqiX0BjHCXeKjYn3yiwZI8kQqx9gHIcCylUbvQ/cC9DD
PRJiuXeieR/ffpUcIUk10Qc4ht2JaNAuah8EYZjV30PvAHoUELg3EEI8jflkjPf0MbUyU3lOpRtN
ZeWRyaEY6HaxlbBd5UH7Lbsqxe+0bGV9NR8UCMjZwb9P/Le1NgDdu7V7nfYa9l2ovGagd8a0nxUw
--0000000000007f958505e569f039--
