Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98406C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D819610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhJGVWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:01 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:40715 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240643AbhJGVV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:59 -0400
Received: by mail-pj1-f45.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so7908172pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9u4GISVotQ7wq2cUYk/0BmpFVxH0/IJZGzhXVJeCLXo=;
        b=Ufm+hrPMdZE93gyrtc/HN7iPEIGf5qI2tdMV5B9PkCVMbQeAGnxv1SkYLyxAHtPQJr
         d/g1LgVSns3qFH8d0uHYMc6ifvDAcdTlJFIlStKcebgeIazsI0tlOW2Jn3SoD8G/kdjI
         7/o3ENVLwzuWAPlWBCK6YW+LDHN87luDgcyBEL4xzjiJVL+SCgpD4Q/lTwZ5A97f+3EL
         1ZKdm7s1tPCRW8Q/hB14PzSlEGbyTSfBDd3ouSFOgXNQjeok1UDd2xaTD/HFnx0s+uHU
         gUb9AIxWL/Anx6ATBTpgFLYBAyykPfDp8Q1TSKyw/UpUMXHwaMkZ1vg6XdpAfFpZNmeW
         07og==
X-Gm-Message-State: AOAM532qBTAQSZvb8UB63F9ZSV0Gp0QoDukGLOiVymhPsX+SBTCvPoS2
        xLmZ+3mAbmcjsNYEW08QvLk=
X-Google-Smtp-Source: ABdhPJxMcSZItQ4NrsrUibvcxRuLdzZzwsQ18qWir3lSPTQOZDrZtqUmnuK/l1DMBzQ2/M7b5S7f9A==
X-Received: by 2002:a17:90a:1942:: with SMTP id 2mr7969554pjh.195.1633641605069;
        Thu, 07 Oct 2021 14:20:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 27/46] scsi: lpfc: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:33 -0700
Message-Id: <20211007211852.256007-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 314 ++++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_crtn.h |   4 +-
 drivers/scsi/lpfc/lpfc_init.c |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c |   4 +-
 4 files changed, 171 insertions(+), 153 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b35bf70a8c0d..13885d3c7b7a 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6396,160 +6396,178 @@ LPFC_ATTR_RW(vmid_priority_tagging, LPFC_VMID_PRIO_TAG_DISABLE,
 	     LPFC_VMID_PRIO_TAG_ALL_TARGETS,
 	     "Enable Priority Tagging VMID support");
 
-struct device_attribute *lpfc_hba_attrs[] = {
-	&dev_attr_nvme_info,
-	&dev_attr_scsi_stat,
-	&dev_attr_bg_info,
-	&dev_attr_bg_guard_err,
-	&dev_attr_bg_apptag_err,
-	&dev_attr_bg_reftag_err,
-	&dev_attr_info,
-	&dev_attr_serialnum,
-	&dev_attr_modeldesc,
-	&dev_attr_modelname,
-	&dev_attr_programtype,
-	&dev_attr_portnum,
-	&dev_attr_fwrev,
-	&dev_attr_hdw,
-	&dev_attr_option_rom_version,
-	&dev_attr_link_state,
-	&dev_attr_num_discovered_ports,
-	&dev_attr_menlo_mgmt_mode,
-	&dev_attr_lpfc_drvr_version,
-	&dev_attr_lpfc_enable_fip,
-	&dev_attr_lpfc_temp_sensor,
-	&dev_attr_lpfc_log_verbose,
-	&dev_attr_lpfc_lun_queue_depth,
-	&dev_attr_lpfc_tgt_queue_depth,
-	&dev_attr_lpfc_hba_queue_depth,
-	&dev_attr_lpfc_peer_port_login,
-	&dev_attr_lpfc_nodev_tmo,
-	&dev_attr_lpfc_devloss_tmo,
-	&dev_attr_lpfc_enable_fc4_type,
-	&dev_attr_lpfc_fcp_class,
-	&dev_attr_lpfc_use_adisc,
-	&dev_attr_lpfc_first_burst_size,
-	&dev_attr_lpfc_ack0,
-	&dev_attr_lpfc_xri_rebalancing,
-	&dev_attr_lpfc_topology,
-	&dev_attr_lpfc_scan_down,
-	&dev_attr_lpfc_link_speed,
-	&dev_attr_lpfc_fcp_io_sched,
-	&dev_attr_lpfc_ns_query,
-	&dev_attr_lpfc_fcp2_no_tgt_reset,
-	&dev_attr_lpfc_cr_delay,
-	&dev_attr_lpfc_cr_count,
-	&dev_attr_lpfc_multi_ring_support,
-	&dev_attr_lpfc_multi_ring_rctl,
-	&dev_attr_lpfc_multi_ring_type,
-	&dev_attr_lpfc_fdmi_on,
-	&dev_attr_lpfc_enable_SmartSAN,
-	&dev_attr_lpfc_max_luns,
-	&dev_attr_lpfc_enable_npiv,
-	&dev_attr_lpfc_fcf_failover_policy,
-	&dev_attr_lpfc_enable_rrq,
-	&dev_attr_lpfc_fcp_wait_abts_rsp,
-	&dev_attr_nport_evt_cnt,
-	&dev_attr_board_mode,
-	&dev_attr_max_vpi,
-	&dev_attr_used_vpi,
-	&dev_attr_max_rpi,
-	&dev_attr_used_rpi,
-	&dev_attr_max_xri,
-	&dev_attr_used_xri,
-	&dev_attr_npiv_info,
-	&dev_attr_issue_reset,
-	&dev_attr_lpfc_poll,
-	&dev_attr_lpfc_poll_tmo,
-	&dev_attr_lpfc_task_mgmt_tmo,
-	&dev_attr_lpfc_use_msi,
-	&dev_attr_lpfc_nvme_oas,
-	&dev_attr_lpfc_nvme_embed_cmd,
-	&dev_attr_lpfc_fcp_imax,
-	&dev_attr_lpfc_force_rscn,
-	&dev_attr_lpfc_cq_poll_threshold,
-	&dev_attr_lpfc_cq_max_proc_limit,
-	&dev_attr_lpfc_fcp_cpu_map,
-	&dev_attr_lpfc_fcp_mq_threshold,
-	&dev_attr_lpfc_hdw_queue,
-	&dev_attr_lpfc_irq_chann,
-	&dev_attr_lpfc_suppress_rsp,
-	&dev_attr_lpfc_nvmet_mrq,
-	&dev_attr_lpfc_nvmet_mrq_post,
-	&dev_attr_lpfc_nvme_enable_fb,
-	&dev_attr_lpfc_nvmet_fb_size,
-	&dev_attr_lpfc_enable_bg,
-	&dev_attr_lpfc_soft_wwnn,
-	&dev_attr_lpfc_soft_wwpn,
-	&dev_attr_lpfc_soft_wwn_enable,
-	&dev_attr_lpfc_enable_hba_reset,
-	&dev_attr_lpfc_enable_hba_heartbeat,
-	&dev_attr_lpfc_EnableXLane,
-	&dev_attr_lpfc_XLanePriority,
-	&dev_attr_lpfc_xlane_lun,
-	&dev_attr_lpfc_xlane_tgt,
-	&dev_attr_lpfc_xlane_vpt,
-	&dev_attr_lpfc_xlane_lun_state,
-	&dev_attr_lpfc_xlane_lun_status,
-	&dev_attr_lpfc_xlane_priority,
-	&dev_attr_lpfc_sg_seg_cnt,
-	&dev_attr_lpfc_max_scsicmpl_time,
-	&dev_attr_lpfc_stat_data_ctrl,
-	&dev_attr_lpfc_aer_support,
-	&dev_attr_lpfc_aer_state_cleanup,
-	&dev_attr_lpfc_sriov_nr_virtfn,
-	&dev_attr_lpfc_req_fw_upgrade,
-	&dev_attr_lpfc_suppress_link_up,
-	&dev_attr_iocb_hw,
-	&dev_attr_pls,
-	&dev_attr_pt,
-	&dev_attr_txq_hw,
-	&dev_attr_txcmplq_hw,
-	&dev_attr_lpfc_sriov_hw_max_virtfn,
-	&dev_attr_protocol,
-	&dev_attr_lpfc_xlane_supported,
-	&dev_attr_lpfc_enable_mds_diags,
-	&dev_attr_lpfc_ras_fwlog_buffsize,
-	&dev_attr_lpfc_ras_fwlog_level,
-	&dev_attr_lpfc_ras_fwlog_func,
-	&dev_attr_lpfc_enable_bbcr,
-	&dev_attr_lpfc_enable_dpp,
-	&dev_attr_lpfc_enable_mi,
-	&dev_attr_cmf_info,
-	&dev_attr_lpfc_max_vmid,
-	&dev_attr_lpfc_vmid_inactivity_timeout,
-	&dev_attr_lpfc_vmid_app_header,
-	&dev_attr_lpfc_vmid_priority_tagging,
+static struct attribute *lpfc_hba_attrs[] = {
+	&dev_attr_nvme_info.attr,
+	&dev_attr_scsi_stat.attr,
+	&dev_attr_bg_info.attr,
+	&dev_attr_bg_guard_err.attr,
+	&dev_attr_bg_apptag_err.attr,
+	&dev_attr_bg_reftag_err.attr,
+	&dev_attr_info.attr,
+	&dev_attr_serialnum.attr,
+	&dev_attr_modeldesc.attr,
+	&dev_attr_modelname.attr,
+	&dev_attr_programtype.attr,
+	&dev_attr_portnum.attr,
+	&dev_attr_fwrev.attr,
+	&dev_attr_hdw.attr,
+	&dev_attr_option_rom_version.attr,
+	&dev_attr_link_state.attr,
+	&dev_attr_num_discovered_ports.attr,
+	&dev_attr_menlo_mgmt_mode.attr,
+	&dev_attr_lpfc_drvr_version.attr,
+	&dev_attr_lpfc_enable_fip.attr,
+	&dev_attr_lpfc_temp_sensor.attr,
+	&dev_attr_lpfc_log_verbose.attr,
+	&dev_attr_lpfc_lun_queue_depth.attr,
+	&dev_attr_lpfc_tgt_queue_depth.attr,
+	&dev_attr_lpfc_hba_queue_depth.attr,
+	&dev_attr_lpfc_peer_port_login.attr,
+	&dev_attr_lpfc_nodev_tmo.attr,
+	&dev_attr_lpfc_devloss_tmo.attr,
+	&dev_attr_lpfc_enable_fc4_type.attr,
+	&dev_attr_lpfc_fcp_class.attr,
+	&dev_attr_lpfc_use_adisc.attr,
+	&dev_attr_lpfc_first_burst_size.attr,
+	&dev_attr_lpfc_ack0.attr,
+	&dev_attr_lpfc_xri_rebalancing.attr,
+	&dev_attr_lpfc_topology.attr,
+	&dev_attr_lpfc_scan_down.attr,
+	&dev_attr_lpfc_link_speed.attr,
+	&dev_attr_lpfc_fcp_io_sched.attr,
+	&dev_attr_lpfc_ns_query.attr,
+	&dev_attr_lpfc_fcp2_no_tgt_reset.attr,
+	&dev_attr_lpfc_cr_delay.attr,
+	&dev_attr_lpfc_cr_count.attr,
+	&dev_attr_lpfc_multi_ring_support.attr,
+	&dev_attr_lpfc_multi_ring_rctl.attr,
+	&dev_attr_lpfc_multi_ring_type.attr,
+	&dev_attr_lpfc_fdmi_on.attr,
+	&dev_attr_lpfc_enable_SmartSAN.attr,
+	&dev_attr_lpfc_max_luns.attr,
+	&dev_attr_lpfc_enable_npiv.attr,
+	&dev_attr_lpfc_fcf_failover_policy.attr,
+	&dev_attr_lpfc_enable_rrq.attr,
+	&dev_attr_lpfc_fcp_wait_abts_rsp.attr,
+	&dev_attr_nport_evt_cnt.attr,
+	&dev_attr_board_mode.attr,
+	&dev_attr_max_vpi.attr,
+	&dev_attr_used_vpi.attr,
+	&dev_attr_max_rpi.attr,
+	&dev_attr_used_rpi.attr,
+	&dev_attr_max_xri.attr,
+	&dev_attr_used_xri.attr,
+	&dev_attr_npiv_info.attr,
+	&dev_attr_issue_reset.attr,
+	&dev_attr_lpfc_poll.attr,
+	&dev_attr_lpfc_poll_tmo.attr,
+	&dev_attr_lpfc_task_mgmt_tmo.attr,
+	&dev_attr_lpfc_use_msi.attr,
+	&dev_attr_lpfc_nvme_oas.attr,
+	&dev_attr_lpfc_nvme_embed_cmd.attr,
+	&dev_attr_lpfc_fcp_imax.attr,
+	&dev_attr_lpfc_force_rscn.attr,
+	&dev_attr_lpfc_cq_poll_threshold.attr,
+	&dev_attr_lpfc_cq_max_proc_limit.attr,
+	&dev_attr_lpfc_fcp_cpu_map.attr,
+	&dev_attr_lpfc_fcp_mq_threshold.attr,
+	&dev_attr_lpfc_hdw_queue.attr,
+	&dev_attr_lpfc_irq_chann.attr,
+	&dev_attr_lpfc_suppress_rsp.attr,
+	&dev_attr_lpfc_nvmet_mrq.attr,
+	&dev_attr_lpfc_nvmet_mrq_post.attr,
+	&dev_attr_lpfc_nvme_enable_fb.attr,
+	&dev_attr_lpfc_nvmet_fb_size.attr,
+	&dev_attr_lpfc_enable_bg.attr,
+	&dev_attr_lpfc_soft_wwnn.attr,
+	&dev_attr_lpfc_soft_wwpn.attr,
+	&dev_attr_lpfc_soft_wwn_enable.attr,
+	&dev_attr_lpfc_enable_hba_reset.attr,
+	&dev_attr_lpfc_enable_hba_heartbeat.attr,
+	&dev_attr_lpfc_EnableXLane.attr,
+	&dev_attr_lpfc_XLanePriority.attr,
+	&dev_attr_lpfc_xlane_lun.attr,
+	&dev_attr_lpfc_xlane_tgt.attr,
+	&dev_attr_lpfc_xlane_vpt.attr,
+	&dev_attr_lpfc_xlane_lun_state.attr,
+	&dev_attr_lpfc_xlane_lun_status.attr,
+	&dev_attr_lpfc_xlane_priority.attr,
+	&dev_attr_lpfc_sg_seg_cnt.attr,
+	&dev_attr_lpfc_max_scsicmpl_time.attr,
+	&dev_attr_lpfc_stat_data_ctrl.attr,
+	&dev_attr_lpfc_aer_support.attr,
+	&dev_attr_lpfc_aer_state_cleanup.attr,
+	&dev_attr_lpfc_sriov_nr_virtfn.attr,
+	&dev_attr_lpfc_req_fw_upgrade.attr,
+	&dev_attr_lpfc_suppress_link_up.attr,
+	&dev_attr_iocb_hw.attr,
+	&dev_attr_pls.attr,
+	&dev_attr_pt.attr,
+	&dev_attr_txq_hw.attr,
+	&dev_attr_txcmplq_hw.attr,
+	&dev_attr_lpfc_sriov_hw_max_virtfn.attr,
+	&dev_attr_protocol.attr,
+	&dev_attr_lpfc_xlane_supported.attr,
+	&dev_attr_lpfc_enable_mds_diags.attr,
+	&dev_attr_lpfc_ras_fwlog_buffsize.attr,
+	&dev_attr_lpfc_ras_fwlog_level.attr,
+	&dev_attr_lpfc_ras_fwlog_func.attr,
+	&dev_attr_lpfc_enable_bbcr.attr,
+	&dev_attr_lpfc_enable_dpp.attr,
+	&dev_attr_lpfc_enable_mi.attr,
+	&dev_attr_cmf_info.attr,
+	&dev_attr_lpfc_max_vmid.attr,
+	&dev_attr_lpfc_vmid_inactivity_timeout.attr,
+	&dev_attr_lpfc_vmid_app_header.attr,
+	&dev_attr_lpfc_vmid_priority_tagging.attr,
 	NULL,
 };
 
-struct device_attribute *lpfc_vport_attrs[] = {
-	&dev_attr_info,
-	&dev_attr_link_state,
-	&dev_attr_num_discovered_ports,
-	&dev_attr_lpfc_drvr_version,
-	&dev_attr_lpfc_log_verbose,
-	&dev_attr_lpfc_lun_queue_depth,
-	&dev_attr_lpfc_tgt_queue_depth,
-	&dev_attr_lpfc_nodev_tmo,
-	&dev_attr_lpfc_devloss_tmo,
-	&dev_attr_lpfc_hba_queue_depth,
-	&dev_attr_lpfc_peer_port_login,
-	&dev_attr_lpfc_restrict_login,
-	&dev_attr_lpfc_fcp_class,
-	&dev_attr_lpfc_use_adisc,
-	&dev_attr_lpfc_first_burst_size,
-	&dev_attr_lpfc_max_luns,
-	&dev_attr_nport_evt_cnt,
-	&dev_attr_npiv_info,
-	&dev_attr_lpfc_enable_da_id,
-	&dev_attr_lpfc_max_scsicmpl_time,
-	&dev_attr_lpfc_stat_data_ctrl,
-	&dev_attr_lpfc_static_vport,
-	&dev_attr_cmf_info,
+static const struct attribute_group lpfc_hba_attr_group = {
+	.attrs = lpfc_hba_attrs
+};
+
+const struct attribute_group *lpfc_hba_attr_groups[] = {
+	&lpfc_hba_attr_group,
+	NULL
+};
+
+static struct attribute *lpfc_vport_attrs[] = {
+	&dev_attr_info.attr,
+	&dev_attr_link_state.attr,
+	&dev_attr_num_discovered_ports.attr,
+	&dev_attr_lpfc_drvr_version.attr,
+	&dev_attr_lpfc_log_verbose.attr,
+	&dev_attr_lpfc_lun_queue_depth.attr,
+	&dev_attr_lpfc_tgt_queue_depth.attr,
+	&dev_attr_lpfc_nodev_tmo.attr,
+	&dev_attr_lpfc_devloss_tmo.attr,
+	&dev_attr_lpfc_hba_queue_depth.attr,
+	&dev_attr_lpfc_peer_port_login.attr,
+	&dev_attr_lpfc_restrict_login.attr,
+	&dev_attr_lpfc_fcp_class.attr,
+	&dev_attr_lpfc_use_adisc.attr,
+	&dev_attr_lpfc_first_burst_size.attr,
+	&dev_attr_lpfc_max_luns.attr,
+	&dev_attr_nport_evt_cnt.attr,
+	&dev_attr_npiv_info.attr,
+	&dev_attr_lpfc_enable_da_id.attr,
+	&dev_attr_lpfc_max_scsicmpl_time.attr,
+	&dev_attr_lpfc_stat_data_ctrl.attr,
+	&dev_attr_lpfc_static_vport.attr,
+	&dev_attr_cmf_info.attr,
 	NULL,
 };
 
+static const struct attribute_group lpfc_vport_attr_group = {
+	.attrs = lpfc_vport_attrs
+};
+
+const struct attribute_group *lpfc_vport_attr_groups[] = {
+	&lpfc_vport_attr_group,
+	NULL
+};
+
 /**
  * sysfs_ctlreg_write - Write method for writing to ctlreg
  * @filp: open sysfs file
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index c512f4199142..edac092eb0dd 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -428,8 +428,8 @@ void lpfc_get_cfgparam(struct lpfc_hba *);
 void lpfc_get_vport_cfgparam(struct lpfc_vport *);
 int lpfc_alloc_sysfs_attr(struct lpfc_vport *);
 void lpfc_free_sysfs_attr(struct lpfc_vport *);
-extern struct device_attribute *lpfc_hba_attrs[];
-extern struct device_attribute *lpfc_vport_attrs[];
+extern const struct attribute_group *lpfc_hba_attr_groups[];
+extern const struct attribute_group *lpfc_vport_attr_groups[];
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_template_nvme;
 extern struct fc_function_template lpfc_transport_functions;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ea8f929eb3f7..33b4912eccab 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4574,7 +4574,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 			/* Template for all vports this physical port creates */
 			memcpy(&phba->vport_template, &lpfc_template,
 			       sizeof(*template));
-			phba->vport_template.shost_attrs = lpfc_vport_attrs;
+			phba->vport_template.shost_groups = lpfc_vport_attr_groups;
 			phba->vport_template.eh_bus_reset_handler = NULL;
 			phba->vport_template.eh_host_reset_handler = NULL;
 			phba->vport_template.vendor_id = 0;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 17e677cf8dcd..ac2e297945bd 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -7203,7 +7203,7 @@ struct scsi_host_template lpfc_template_nvme = {
 	.this_id		= -1,
 	.sg_tablesize		= 1,
 	.cmd_per_lun		= 1,
-	.shost_attrs		= lpfc_hba_attrs,
+	.shost_groups		= lpfc_hba_attr_groups,
 	.max_sectors		= 0xFFFFFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.track_queue_depth	= 0,
@@ -7229,7 +7229,7 @@ struct scsi_host_template lpfc_template = {
 	.this_id		= -1,
 	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
-	.shost_attrs		= lpfc_hba_attrs,
+	.shost_groups		= lpfc_hba_attr_groups,
 	.max_sectors		= 0xFFFFFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= scsi_change_queue_depth,
