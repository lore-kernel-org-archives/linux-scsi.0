Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5683C3F2CD
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A02C120842
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCDF34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 00:29:56 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36102 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCDF34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 00:29:56 -0500
Received: by mail-pl1-f196.google.com with SMTP id g12so500767plo.3
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2020 21:29:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s2qoA3oryiz1uT1/l27o7025/tE8Rmm9bGpEUdQwcqI=;
        b=YJ1aZMQPZXKh6vYCikU15og0WL5NXbkz4z1fcVqw3LitrEyDau3diYimy4upKa4YlC
         Dr/zVAgm4/raLMu1faUkfX1qDbgbJAjqcgyH7vLwEcTydDAIxVu651Q8+J0YeYnRu5LZ
         33+LMP0xo6uVEpS7NHM3XZy6y30R1x07jUMOmrzflRIQXUG++rfKRGtAaxjc+1XIh05v
         B43YYo973P5WVutWYWTlgupBHG38NvmEgETtWUPG1CKPCbMuzdrzkcAu/1lTWqYlN6zF
         2whvZJ7roqbgANW5t/2EBjFrhhMgrN570hdCzPd/UewZ7JqwyJkPakbO/vry2crKKXFr
         IrVg==
X-Gm-Message-State: ANhLgQ2PPc1Zwy6vMjQPcfdr2kDTrIwnpjUz8KGopWrmEOPjahw6DpJq
        ljT8oP2vGju3zga1guVsKfk=
X-Google-Smtp-Source: ADFU+vuxcGAVV9UnbjKOT40zPgshV2REq5zMnndHhKnexwb1rrgjELau99QQFpocfxS+PpwQ/7CX1g==
X-Received: by 2002:a17:902:208:: with SMTP id 8mr1572250plc.198.1583299794943;
        Tue, 03 Mar 2020 21:29:54 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:a86e:343d:2eff:fb40])
        by smtp.gmail.com with ESMTPSA id p94sm972784pjp.15.2020.03.03.21.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 21:29:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 2/6] qla2xxx: Add more BUILD_BUG_ON() statements
Date:   Tue,  3 Mar 2020 21:29:41 -0800
Message-Id: <20200304052945.23250-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304052945.23250-1-bvanassche@acm.org>
References: <20200304052945.23250-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before fixing the endianness annotations in data structures, make the
compiler verify the size of FC protocol and firmware data structures.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 67 +++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 17d85c4d1e3e..b2d47828dd5b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7838,31 +7838,98 @@ qla2x00_module_init(void)
 {
 	int ret = 0;
 
+	BUILD_BUG_ON(sizeof(cmd_a64_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(cmd_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(cont_a64_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(cont_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(init_cb_t) != 96);
+	BUILD_BUG_ON(sizeof(mrk_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(ms_iocb_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(request_t) != 64);
+	BUILD_BUG_ON(sizeof(struct abort_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct abts_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct access_chip_84xx) != 64);
+	BUILD_BUG_ON(sizeof(struct access_chip_84xx) != 64);
+	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
+	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_nvme) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
+	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
+	BUILD_BUG_ON(sizeof(struct cmd_type_7) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
+	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
+	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2344);
+	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
+	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
+	BUILD_BUG_ON(sizeof(struct ct_fdmi_hba_attr) != 260);
+	BUILD_BUG_ON(sizeof(struct ct_fdmi_port_attr) != 260);
+	BUILD_BUG_ON(sizeof(struct ct_rsp_hdr) != 16);
+	BUILD_BUG_ON(sizeof(struct ct_sns_req) != 4460);
 	BUILD_BUG_ON(sizeof(struct ctio_crc2_to_fw) != 64);
+	BUILD_BUG_ON(sizeof(struct device_reg_24xx) != 256);
+	BUILD_BUG_ON(sizeof(struct device_reg_25xxmq) != 24);
+	BUILD_BUG_ON(sizeof(struct device_reg_2xxx) != 256);
+	BUILD_BUG_ON(sizeof(struct device_reg_fx00) != 216);
+	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
+	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
 	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
+	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
+	BUILD_BUG_ON(sizeof(struct logio_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
+	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
+	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
+	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
+	BUILD_BUG_ON(sizeof(struct purex_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct qla2100_fw_dump) != 123634);
+	BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);
+	BUILD_BUG_ON(sizeof(struct qla24xx_fw_dump) != 37976);
+	BUILD_BUG_ON(sizeof(struct qla25xx_fw_dump) != 39228);
+	BUILD_BUG_ON(sizeof(struct qla2xxx_fce_chain) != 52);
+	BUILD_BUG_ON(sizeof(struct qla2xxx_fw_dump) != 136172);
+	BUILD_BUG_ON(sizeof(struct qla2xxx_mq_chain) != 524);
+	BUILD_BUG_ON(sizeof(struct qla2xxx_mqueue_chain) != 8);
+	BUILD_BUG_ON(sizeof(struct qla2xxx_mqueue_header) != 12);
+	BUILD_BUG_ON(sizeof(struct qla2xxx_offld_chain) != 24);
+	BUILD_BUG_ON(sizeof(struct qla81xx_fw_dump) != 39420);
+	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
+	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
+	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
 	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
 	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
+	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
+	BUILD_BUG_ON(sizeof(struct qla_npiv_entry) != 24);
+	BUILD_BUG_ON(sizeof(struct qla_npiv_header) != 16);
+	BUILD_BUG_ON(sizeof(struct rdp_rsp_payload) != 336);
 	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
+	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
+	BUILD_BUG_ON(sizeof(struct srb_iocb) != 312);
+	BUILD_BUG_ON(sizeof(struct sts_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry) != 64);
+	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
+	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
+	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
+	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
+	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
+	BUILD_BUG_ON(sizeof(sts_cont_entry_t) != 64);
+	BUILD_BUG_ON(sizeof(sts_entry_t) != 64);
+	BUILD_BUG_ON(sizeof(sw_info_t) != 32);
+	BUILD_BUG_ON(sizeof(target_id_t) != 2);
 
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
