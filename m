Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C269BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5E160ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbhJLXj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:29 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:42959 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbhJLXjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:24 -0400
Received: by mail-pg1-f172.google.com with SMTP id 66so538223pgc.9
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D/Ac2I+8O3KqNwk6eUFfAkswjNKflitnqb1Y2vJE2Zc=;
        b=p3H/4mb442rCyaxEXavUSHbtSXYSLspUcr3zZv7ZjuyJ0cgSsEoVCKoj0fagg/z/VW
         KZ+DRPEX/ObgsZ1CFjSb9OXFMv9tuUgMP/EQHURhCHs06MiJpcwrNRp4P8aUpURRqpd2
         bTRcSXsekkvQz0DcSI9FuH5C36lra/bATWRGhwP70j6QcygciNN8/UhkJO4YwEdm0Hod
         m8HawVDe2xwxDtydEti8sPTPGTRG5BTSZNfHABV6S3FZrKU+mPuwr6iWFJuRSpUvGxid
         UH/2DVd8l7ghwC3IQg51/3GyPGGPYz7ob/7BOAQdPBk6zc21h+M0lPu8ZIvvfVpMVWEL
         YyRA==
X-Gm-Message-State: AOAM5308TX1Sn1foe4Uc6n2pkUwV+4wewHGFTKZkpAoZ4hf+ITagvrhw
        VD2PRVBAEadZkmYIS3xOArhTzkfFxIzzoA==
X-Google-Smtp-Source: ABdhPJw9bROe8USAt2CujyOnvEc3lbTkWrVKHkpnP+bHBO319zhbL1rjJNCgfxj+G4RUvUERLL5vKA==
X-Received: by 2002:a05:6a00:1634:b0:44b:7184:5ec4 with SMTP id e20-20020a056a00163400b0044b71845ec4mr34288470pfc.40.1634081842206;
        Tue, 12 Oct 2021 16:37:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 40/46] scsi: qla2xxx: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:52 -0700
Message-Id: <20211012233558.4066756-41-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.
Additionally, remove qla_insert_tgt_attrs() and replace it with
qla_host_attr_is_visible().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 125 +++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 +-
 drivers/scsi/qla2xxx/qla_os.c   |   5 +-
 3 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cb5f2ecb652d..30f9545d2285 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2481,72 +2481,77 @@ static DEVICE_ATTR(port_no, 0444, qla2x00_port_no_show, NULL);
 static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
 static DEVICE_ATTR_RO(edif_doorbell);
 
-
-struct device_attribute *qla2x00_host_attrs[] = {
-	&dev_attr_driver_version,
-	&dev_attr_fw_version,
-	&dev_attr_serial_num,
-	&dev_attr_isp_name,
-	&dev_attr_isp_id,
-	&dev_attr_model_name,
-	&dev_attr_model_desc,
-	&dev_attr_pci_info,
-	&dev_attr_link_state,
-	&dev_attr_zio,
-	&dev_attr_zio_timer,
-	&dev_attr_beacon,
-	&dev_attr_beacon_config,
-	&dev_attr_optrom_bios_version,
-	&dev_attr_optrom_efi_version,
-	&dev_attr_optrom_fcode_version,
-	&dev_attr_optrom_fw_version,
-	&dev_attr_84xx_fw_version,
-	&dev_attr_total_isp_aborts,
-	&dev_attr_serdes_version,
-	&dev_attr_mpi_version,
-	&dev_attr_phy_version,
-	&dev_attr_flash_block_size,
-	&dev_attr_vlan_id,
-	&dev_attr_vn_port_mac_address,
-	&dev_attr_fabric_param,
-	&dev_attr_fw_state,
-	&dev_attr_optrom_gold_fw_version,
-	&dev_attr_thermal_temp,
-	&dev_attr_diag_requests,
-	&dev_attr_diag_megabytes,
-	&dev_attr_fw_dump_size,
-	&dev_attr_allow_cna_fw_dump,
-	&dev_attr_pep_version,
-	&dev_attr_min_supported_speed,
-	&dev_attr_max_supported_speed,
-	&dev_attr_zio_threshold,
-	&dev_attr_dif_bundle_statistics,
-	&dev_attr_port_speed,
-	&dev_attr_port_no,
-	&dev_attr_fw_attr,
-	&dev_attr_dport_diagnostics,
-	&dev_attr_edif_doorbell,
-	&dev_attr_mpi_pause,
-	NULL, /* reserve for qlini_mode */
-	NULL, /* reserve for ql2xiniexchg */
-	NULL, /* reserve for ql2xexchoffld */
+static struct attribute *qla2x00_host_attrs[] = {
+	&dev_attr_driver_version.attr,
+	&dev_attr_fw_version.attr,
+	&dev_attr_serial_num.attr,
+	&dev_attr_isp_name.attr,
+	&dev_attr_isp_id.attr,
+	&dev_attr_model_name.attr,
+	&dev_attr_model_desc.attr,
+	&dev_attr_pci_info.attr,
+	&dev_attr_link_state.attr,
+	&dev_attr_zio.attr,
+	&dev_attr_zio_timer.attr,
+	&dev_attr_beacon.attr,
+	&dev_attr_beacon_config.attr,
+	&dev_attr_optrom_bios_version.attr,
+	&dev_attr_optrom_efi_version.attr,
+	&dev_attr_optrom_fcode_version.attr,
+	&dev_attr_optrom_fw_version.attr,
+	&dev_attr_84xx_fw_version.attr,
+	&dev_attr_total_isp_aborts.attr,
+	&dev_attr_serdes_version.attr,
+	&dev_attr_mpi_version.attr,
+	&dev_attr_phy_version.attr,
+	&dev_attr_flash_block_size.attr,
+	&dev_attr_vlan_id.attr,
+	&dev_attr_vn_port_mac_address.attr,
+	&dev_attr_fabric_param.attr,
+	&dev_attr_fw_state.attr,
+	&dev_attr_optrom_gold_fw_version.attr,
+	&dev_attr_thermal_temp.attr,
+	&dev_attr_diag_requests.attr,
+	&dev_attr_diag_megabytes.attr,
+	&dev_attr_fw_dump_size.attr,
+	&dev_attr_allow_cna_fw_dump.attr,
+	&dev_attr_pep_version.attr,
+	&dev_attr_min_supported_speed.attr,
+	&dev_attr_max_supported_speed.attr,
+	&dev_attr_zio_threshold.attr,
+	&dev_attr_dif_bundle_statistics.attr,
+	&dev_attr_port_speed.attr,
+	&dev_attr_port_no.attr,
+	&dev_attr_fw_attr.attr,
+	&dev_attr_dport_diagnostics.attr,
+	&dev_attr_edif_doorbell.attr,
+	&dev_attr_mpi_pause.attr,
+	&dev_attr_qlini_mode.attr,
+	&dev_attr_ql2xiniexchg.attr,
+	&dev_attr_ql2xexchoffld.attr,
 	NULL,
 };
 
-void qla_insert_tgt_attrs(void)
+static umode_t qla_host_attr_is_visible(struct kobject *kobj,
+					struct attribute *attr, int i)
 {
-	struct device_attribute **attr;
+	if (ql2x_ini_mode != QLA2XXX_INI_MODE_DUAL &&
+	    (attr == &dev_attr_qlini_mode.attr ||
+	     attr == &dev_attr_ql2xiniexchg.attr ||
+	     attr == &dev_attr_ql2xexchoffld.attr))
+		return 0;
+	return attr->mode;
+}
 
-	/* advance to empty slot */
-	for (attr = &qla2x00_host_attrs[0]; *attr; ++attr)
-		continue;
+static const struct attribute_group qla2x00_host_attr_group = {
+	.is_visible = qla_host_attr_is_visible,
+	.attrs = qla2x00_host_attrs
+};
 
-	*attr = &dev_attr_qlini_mode;
-	attr++;
-	*attr = &dev_attr_ql2xiniexchg;
-	attr++;
-	*attr = &dev_attr_ql2xexchoffld;
-}
+const struct attribute_group *qla2x00_host_groups[] = {
+	&qla2x00_host_attr_group,
+	NULL
+};
 
 /* Host attributes. */
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5ff974e98783..3c4fa8bac88d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -742,7 +742,7 @@ uint qla25xx_fdmi_port_speed_currently(struct qla_hw_data *);
  * Global Function Prototypes in qla_attr.c source file.
  */
 struct device_attribute;
-extern struct device_attribute *qla2x00_host_attrs[];
+extern const struct attribute_group *qla2x00_host_groups[];
 struct fc_function_template;
 extern struct fc_function_template qla2xxx_transport_functions;
 extern struct fc_function_template qla2xxx_transport_vport_functions;
@@ -756,7 +756,6 @@ extern int qla2x00_echo_test(scsi_qla_host_t *,
 extern int qla24xx_update_all_fcp_prio(scsi_qla_host_t *);
 extern int qla24xx_fcp_prio_cfg_valid(scsi_qla_host_t *,
 	struct qla_fcp_prio_cfg *, uint8_t);
-void qla_insert_tgt_attrs(void);
 /*
  * Global Function Prototypes in qla_dfs.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 03ff2596715b..4f828ce25b25 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7943,7 +7943,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
-	.shost_attrs		= qla2x00_host_attrs,
+	.shost_groups		= qla2x00_host_groups,
 
 	.supported_mode		= MODE_INITIATOR,
 	.track_queue_depth	= 1,
@@ -8131,9 +8131,6 @@ qla2x00_module_init(void)
 	if (ql2xextended_error_logging == 1)
 		ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;
 
-	if (ql2x_ini_mode == QLA2XXX_INI_MODE_DUAL)
-		qla_insert_tgt_attrs();
-
 	qla2xxx_transport_template =
 	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template) {
