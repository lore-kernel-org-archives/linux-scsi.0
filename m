Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BACC433FB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36EC520792
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g8dXQTy8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgGWMZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbgGWMZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:13 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687B7C0619E6
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so4994713wrw.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cFAwrJOlCaFEAVVXRM8LDqpbMDff7j2Fk+BIxfpepaE=;
        b=g8dXQTy8iWZ/pt+ut/TLsb7iSfAJcjVrkyf6QbrijskAnGR9/49VfRqguD6pCv4Z0T
         1MhKE6RG8mLHO1UGPkiCJMj8RQX/RfycK/PExTKbIjLT9s9/lCO/tloSzxd4b/Iz1Qxg
         zWMP2pz014MHwwUHceBDQC5iLwJzMF9k/23yzMxQXTnr6tCDr/jfR5za7hfMzVWt8wj7
         HsFQhJbLgAdqOrGjeFGjELXDbYNQqrsaXBRFie4tByCK9JsJRfZ/zNaHJaMXZ5RKFWjI
         dJBA/qVzG38Gh8WMqAOmfaK9xmTwdsl4b86COjmKUy5BO9Py2tj/xWc1sG57ehZohAcS
         k+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFAwrJOlCaFEAVVXRM8LDqpbMDff7j2Fk+BIxfpepaE=;
        b=PRx0b87iBa3NvkI3h4YvP85QaqPCr51Kla6sp42/qj/ltZHEiOOpFmgYC+1DISJYKI
         gbD199EgRzvvIv6/p0lACw98uAdO86NxUol74TzIeTjzvzju5b85OPWss7e1F86e2cQN
         wKUsuiJrXfAM7+XescUl6UEKiMhqMTWt69X+H+j3kH6iGBAQR6Jskd4BE6NGVjEOXhBc
         6QhErJcmke+yiDt+DMVm5k8/jbqifBWb7Do7Z0vT2Qftn34hERMUAjj5Cwh0LeShGVW+
         DiO47gzKDNGTqS9VC+Ed6b2OYC4NzxFj5CO/bUoyFOga+kPB4Q47Kas6mEixveXtewsb
         /fXw==
X-Gm-Message-State: AOAM532zKwrYkPOyzMxdE3LqHCDaZ+QApfc3fmtQsLZ3vu78RA3I+DIE
        Z24lu5M/RRlzOekGDT+XfChNFC6pyyw=
X-Google-Smtp-Source: ABdhPJzgX1K70aJ6Evdd74S501XGoQPyL6zPbkRybZlJlfOrxnM1Oy51c6xjZQ2vc5ko9lDy4ZvFHQ==
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr3861082wru.341.1595507108920;
        Thu, 23 Jul 2020 05:25:08 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 16/40] scsi: lpfc: lpfc_init: Add and rename a whole bunch of function parameter descriptions
Date:   Thu, 23 Jul 2020 13:24:22 +0100
Message-Id: <20200723122446.1329773-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_init.c:1136: warning: Function parameter or member 't' not described in 'lpfc_hb_timeout'
 drivers/scsi/lpfc/lpfc_init.c:1136: warning: Excess function parameter 'ptr' description in 'lpfc_hb_timeout'
 drivers/scsi/lpfc/lpfc_init.c:1170: warning: Function parameter or member 't' not described in 'lpfc_rrq_timeout'
 drivers/scsi/lpfc/lpfc_init.c:1170: warning: Excess function parameter 'ptr' description in 'lpfc_rrq_timeout'
 drivers/scsi/lpfc/lpfc_init.c:1232: warning: Function parameter or member 'work' not described in 'lpfc_idle_stat_delay_work'
 drivers/scsi/lpfc/lpfc_init.c:1817: warning: Function parameter or member 'en_rn_msg' not described in 'lpfc_sli4_port_sta_fn_reset'
 drivers/scsi/lpfc/lpfc_init.c:3033: warning: Function parameter or member 'mbx_action' not described in 'lpfc_block_mgmt_io'
 drivers/scsi/lpfc/lpfc_init.c:3481: warning: Function parameter or member 'mbx_action' not described in 'lpfc_offline_prep'
 drivers/scsi/lpfc/lpfc_init.c:4150: warning: Function parameter or member 'phba' not described in 'lpfc_new_io_buf'
 drivers/scsi/lpfc/lpfc_init.c:4150: warning: Function parameter or member 'num_to_alloc' not described in 'lpfc_new_io_buf'
 drivers/scsi/lpfc/lpfc_init.c:4150: warning: Excess function parameter 'vport' description in 'lpfc_new_io_buf'
 drivers/scsi/lpfc/lpfc_init.c:4150: warning: Excess function parameter 'num_to_allocate' description in 'lpfc_new_io_buf'
 drivers/scsi/lpfc/lpfc_init.c:4736: warning: Function parameter or member 't' not described in 'lpfc_sli4_fcf_redisc_wait_tmo'
 drivers/scsi/lpfc/lpfc_init.c:4736: warning: Excess function parameter 'ptr' description in 'lpfc_sli4_fcf_redisc_wait_tmo'
 drivers/scsi/lpfc/lpfc_init.c:5103: warning: Excess function parameter 'evt_code' description in 'lpfc_async_link_speed_to_read_top'
 drivers/scsi/lpfc/lpfc_init.c:5377: warning: Function parameter or member 'acqe_sli' not described in 'lpfc_sli4_async_sli_evt'
 drivers/scsi/lpfc/lpfc_init.c:5377: warning: Excess function parameter 'acqe_fc' description in 'lpfc_sli4_async_sli_evt'
 drivers/scsi/lpfc/lpfc_init.c:5634: warning: Function parameter or member 'phba' not described in 'lpfc_sli4_perform_all_vport_cvl'
 drivers/scsi/lpfc/lpfc_init.c:5634: warning: Excess function parameter 'vport' description in 'lpfc_sli4_perform_all_vport_cvl'
 drivers/scsi/lpfc/lpfc_init.c:5655: warning: Function parameter or member 'acqe_fip' not described in 'lpfc_sli4_async_fip_evt'
 drivers/scsi/lpfc/lpfc_init.c:5655: warning: Excess function parameter 'acqe_link' description in 'lpfc_sli4_async_fip_evt'
 drivers/scsi/lpfc/lpfc_init.c:5908: warning: Function parameter or member 'acqe_dcbx' not described in 'lpfc_sli4_async_dcbx_evt'
 drivers/scsi/lpfc/lpfc_init.c:5908: warning: Excess function parameter 'acqe_link' description in 'lpfc_sli4_async_dcbx_evt'
 drivers/scsi/lpfc/lpfc_init.c:5927: warning: Function parameter or member 'acqe_grp5' not described in 'lpfc_sli4_async_grp5_evt'
 drivers/scsi/lpfc/lpfc_init.c:5927: warning: Excess function parameter 'acqe_link' description in 'lpfc_sli4_async_grp5_evt'
 drivers/scsi/lpfc/lpfc_init.c:7279: warning: Function parameter or member 'iocb_count' not described in 'lpfc_init_iocb_list'
 drivers/scsi/lpfc/lpfc_init.c:8227: warning: Function parameter or member 'if_type' not described in 'lpfc_sli4_bar1_register_memmap'
 drivers/scsi/lpfc/lpfc_init.c:8414: warning: Excess function parameter 'phba' description in 'LINK_FLAGS_DEF'
 drivers/scsi/lpfc/lpfc_init.c:8414: warning: Excess function parameter 'rdconf' description in 'LINK_FLAGS_DEF'
 drivers/scsi/lpfc/lpfc_init.c:10734: warning: Function parameter or member 'cfg_mode' not described in 'lpfc_sli_enable_intr'
 drivers/scsi/lpfc/lpfc_init.c:11241: warning: Function parameter or member 'eqlist' not described in 'lpfc_cpuhp_get_eq'
 drivers/scsi/lpfc/lpfc_init.c:11726: warning: Function parameter or member 'cfg_mode' not described in 'lpfc_sli4_enable_intr'
 drivers/scsi/lpfc/lpfc_init.c:12997: warning: Excess function parameter 'ret' description in 'lpfc_write_firmware'
 drivers/scsi/lpfc/lpfc_init.c:13103: warning: Function parameter or member 'fw_upgrade' not described in 'lpfc_sli4_request_firmware_update'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 45 +++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ccfae1c0c0963..c4a7e82d3ff24 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -993,7 +993,6 @@ lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
 
 /**
  * lpfc_hba_down_post_s3 - Perform lpfc uninitialization after HBA reset
-	int i;
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do uninitialization after the HBA is reset when bring
@@ -1121,7 +1120,7 @@ lpfc_hba_down_post(struct lpfc_hba *phba)
 
 /**
  * lpfc_hb_timeout - The HBA-timer timeout handler
- * @ptr: unsigned long holds the pointer to lpfc hba data structure.
+ * @t: timer context used to obtain the pointer to lpfc hba data structure.
  *
  * This is the HBA-timer timeout handler registered to the lpfc driver. When
  * this timer fires, a HBA timeout event shall be posted to the lpfc driver
@@ -1155,7 +1154,7 @@ lpfc_hb_timeout(struct timer_list *t)
 
 /**
  * lpfc_rrq_timeout - The RRQ-timer timeout handler
- * @ptr: unsigned long holds the pointer to lpfc hba data structure.
+ * @t: timer context used to obtain the pointer to lpfc hba data structure.
  *
  * This is the RRQ-timer timeout handler registered to the lpfc driver. When
  * this timer fires, a RRQ timeout event shall be posted to the lpfc driver
@@ -1219,7 +1218,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 	return;
 }
 
-/**
+/*
  * lpfc_idle_stat_delay_work - idle_stat tracking
  *
  * This routine tracks per-cq idle_stat and determines polling decisions.
@@ -1804,7 +1803,7 @@ lpfc_handle_eratt_s3(struct lpfc_hba *phba)
  * lpfc_sli4_port_sta_fn_reset - The SLI4 function reset due to port status reg
  * @phba: pointer to lpfc hba data structure.
  * @mbx_action: flag for mailbox shutdown action.
- *
+ * @en_rn_msg: send reset/port recovery message.
  * This routine is invoked to perform an SLI4 port PCI function reset in
  * response to port status register polling attention. It waits for port
  * status register (ERR, RDY, RN) bits before proceeding with function reset.
@@ -3021,6 +3020,7 @@ lpfc_stop_hba_timers(struct lpfc_hba *phba)
 /**
  * lpfc_block_mgmt_io - Mark a HBA's management interface as blocked
  * @phba: pointer to lpfc hba data structure.
+ * @mbx_action: flag for mailbox no wait action.
  *
  * This routine marks a HBA's management interface as blocked. Once the HBA's
  * management interface is marked as blocked, all the user space access to
@@ -3471,6 +3471,7 @@ lpfc_unblock_mgmt_io(struct lpfc_hba * phba)
 /**
  * lpfc_offline_prep - Prepare a HBA to be brought offline
  * @phba: pointer to lpfc hba data structure.
+ * @mbx_action: flag for mailbox shutdown action.
  *
  * This routine is invoked to prepare a HBA to be brought offline. It performs
  * unregistration login to all the nodes on all vports and flushes the mailbox
@@ -4133,8 +4134,8 @@ lpfc_sli4_io_sgl_update(struct lpfc_hba *phba)
 
 /**
  * lpfc_new_io_buf - IO buffer allocator for HBA with SLI4 IF spec
- * @vport: The virtual port for which this call being executed.
- * @num_to_allocate: The requested number of buffers to allocate.
+ * @phba: Pointer to lpfc hba data structure.
+ * @num_to_alloc: The requested number of buffers to allocate.
  *
  * This routine allocates nvme buffers for device with SLI-4 interface spec,
  * the nvme buffer contains all the necessary information needed to initiate
@@ -4723,7 +4724,7 @@ lpfc_fcf_redisc_wait_start_timer(struct lpfc_hba *phba)
 
 /**
  * lpfc_sli4_fcf_redisc_wait_tmo - FCF table rediscover wait timeout
- * @ptr: Map to lpfc_hba data structure pointer.
+ * @t: Timer context used to obtain the pointer to lpfc hba data structure.
  *
  * This routine is invoked when waiting for FCF table rediscover has been
  * timed out. If new FCF record(s) has (have) been discovered during the
@@ -5090,7 +5091,6 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
  * lpfc_async_link_speed_to_read_top - Parse async evt link speed code to read
  * topology.
  * @phba: pointer to lpfc hba data structure.
- * @evt_code: asynchronous event code.
  * @speed_code: asynchronous event link speed code.
  *
  * This routine is to parse the giving SLI4 async event link speed code into
@@ -5368,7 +5368,7 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 /**
  * lpfc_sli4_async_sli_evt - Process the asynchronous SLI link event
  * @phba: pointer to lpfc hba data structure.
- * @acqe_fc: pointer to the async SLI completion queue entry.
+ * @acqe_sli: pointer to the async SLI completion queue entry.
  *
  * This routine is to handle the SLI4 asynchronous SLI events.
  **/
@@ -5624,7 +5624,7 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
 
 /**
  * lpfc_sli4_perform_all_vport_cvl - Perform clear virtual link on all vports
- * @vport: pointer to lpfc hba data structure.
+ * @phba: pointer to lpfc hba data structure.
  *
  * This routine is to perform Clear Virtual Link (CVL) on all vports in
  * response to a FCF dead event.
@@ -5645,7 +5645,7 @@ lpfc_sli4_perform_all_vport_cvl(struct lpfc_hba *phba)
 /**
  * lpfc_sli4_async_fip_evt - Process the asynchronous FCoE FIP event
  * @phba: pointer to lpfc hba data structure.
- * @acqe_link: pointer to the async fcoe completion queue entry.
+ * @acqe_fip: pointer to the async fcoe completion queue entry.
  *
  * This routine is to handle the SLI4 asynchronous fcoe event.
  **/
@@ -5898,7 +5898,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 /**
  * lpfc_sli4_async_dcbx_evt - Process the asynchronous dcbx event
  * @phba: pointer to lpfc hba data structure.
- * @acqe_link: pointer to the async dcbx completion queue entry.
+ * @acqe_dcbx: pointer to the async dcbx completion queue entry.
  *
  * This routine is to handle the SLI4 asynchronous dcbx event.
  **/
@@ -5915,7 +5915,7 @@ lpfc_sli4_async_dcbx_evt(struct lpfc_hba *phba,
 /**
  * lpfc_sli4_async_grp5_evt - Process the asynchronous group5 event
  * @phba: pointer to lpfc hba data structure.
- * @acqe_link: pointer to the async grp5 completion queue entry.
+ * @acqe_grp5: pointer to the async grp5 completion queue entry.
  *
  * This routine is to handle the SLI4 asynchronous grp5 event. A grp5 event
  * is an asynchronous notified of a logical link speed change.  The Port
@@ -7266,6 +7266,7 @@ lpfc_free_iocb_list(struct lpfc_hba *phba)
 /**
  * lpfc_init_iocb_list - Allocate and initialize iocb list.
  * @phba: pointer to lpfc hba data structure.
+ * @iocb_count: number of requested iocbs
  *
  * This routine is invoked to allocate and initizlize the driver's IOCB
  * list and set up the IOCB tag array accordingly.
@@ -8219,6 +8220,7 @@ lpfc_sli4_bar0_register_memmap(struct lpfc_hba *phba, uint32_t if_type)
 /**
  * lpfc_sli4_bar1_register_memmap - Set up SLI4 BAR1 register memory map.
  * @phba: pointer to lpfc hba data structure.
+ * @if_type: sli if type to operate on.
  *
  * This routine is invoked to set up SLI4 BAR1 register memory map.
  **/
@@ -8400,20 +8402,19 @@ static const char * const lpfc_topo_to_str[] = {
 	"P2P then Loop",
 };
 
+#define	LINK_FLAGS_DEF	0x0
+#define	LINK_FLAGS_P2P	0x1
+#define	LINK_FLAGS_LOOP	0x2
 /**
  * lpfc_map_topology - Map the topology read from READ_CONFIG
  * @phba: pointer to lpfc hba data structure.
- * @rdconf: pointer to read config data
+ * @rd_config: pointer to read config data
  *
  * This routine is invoked to map the topology values as read
  * from the read config mailbox command. If the persistent
  * topology feature is supported, the firmware will provide the
  * saved topology information to be used in INIT_LINK
- *
  **/
-#define	LINK_FLAGS_DEF	0x0
-#define	LINK_FLAGS_P2P	0x1
-#define	LINK_FLAGS_LOOP	0x2
 static void
 lpfc_map_topology(struct lpfc_hba *phba, struct lpfc_mbx_read_config *rd_config)
 {
@@ -10716,6 +10717,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 /**
  * lpfc_sli_enable_intr - Enable device interrupt to SLI-3 device.
  * @phba: pointer to lpfc hba data structure.
+ * @cfg_mode: Interrupt configuration mode (INTx, MSI or MSI-X).
  *
  * This routine is invoked to enable device interrupt and associate driver's
  * interrupt handler(s) to interrupt vector(s) to device with SLI-3 interface
@@ -11233,7 +11235,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
  *
  * @phba:   pointer to lpfc hba data structure.
  * @cpu:    cpu going offline
- * @eqlist:
+ * @eqlist: eq list to append to
  */
 static int
 lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
@@ -11708,6 +11710,7 @@ lpfc_sli4_enable_msi(struct lpfc_hba *phba)
 /**
  * lpfc_sli4_enable_intr - Enable device interrupt to SLI-4 device
  * @phba: pointer to lpfc hba data structure.
+ * @cfg_mode: Interrupt configuration mode (INTx, MSI or MSI-X).
  *
  * This routine is invoked to enable device interrupt and associate driver's
  * interrupt handler(s) to interrupt vector(s) to device with SLI-4
@@ -12989,7 +12992,6 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
  * lpfc_write_firmware - attempt to write a firmware image to the port
  * @fw: pointer to firmware image returned from request_firmware.
  * @context: pointer to firmware image returned from request_firmware.
- * @ret: return value this routine provides to the caller.
  *
  **/
 static void
@@ -13094,6 +13096,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 /**
  * lpfc_sli4_request_firmware_update - Request linux generic firmware upgrade
  * @phba: pointer to lpfc hba data structure.
+ * @fw_upgrade: which firmware to update.
  *
  * This routine is called to perform Linux generic firmware upgrade on device
  * that supports such feature.
-- 
2.25.1

