Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E90CC2D0D1
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F260222C2
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfLSArO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:47:14 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33636 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSArN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 19:47:13 -0500
Received: by mail-pf1-f194.google.com with SMTP id z16so2187211pfk.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 16:47:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2MV+o4FbKOKEbUkzlqFKi4g2nXUjmbvBDb07qWwKjU=;
        b=Ww6900h0dWd2rnyqXkDB52d9q+/zRnpkpb0/hjpWLt+0FfG0VM6S4S10uLD+mmlffU
         xSe4ucJXjnjyh5TqEJeR28/q0rneg9N8/425iRjaod6z4M44NPVlm7D71U8S4aOcXkrS
         W5G07FWuISEAuICq0LWrYB3s+wSk/oN+KPTgU0+UF+zyq1UOKO6qNmEigVQ2q2etq3jc
         K0Hp03Nh7lWHPj+jhyc2q7DmvIz+0UL1jJ/E4dNwkjrfvhHKxzjXvi+D0c84zTMLb6+v
         DQPAKv0u+ATCuo35WanVAv2ry4qaLpznfV9IZDfn966HWiPQEibE5wNH85RnKKOcOYA6
         i6Kg==
X-Gm-Message-State: APjAAAXdjY6qTHMgMz2frs+rytjJGlKj5FGB0hkxDkbd/pPRHd3m+JwW
        0NvMdGHn1mbweRjWdT2qxCboQ3x6
X-Google-Smtp-Source: APXvYqxC6f2iR9/6pjjG8XRnbLMyf081Unn5TQmJj/q5Gli69s1Y2U6kCpJ0L/+Vdx6x9xte4UVYRA==
X-Received: by 2002:a63:dc0d:: with SMTP id s13mr5916601pgg.129.1576716432967;
        Wed, 18 Dec 2019 16:47:12 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 207sm5098894pfu.88.2019.12.18.16.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 16:47:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Improve readability of the code that handles qla_flt_header
Date:   Wed, 18 Dec 2019 16:47:06 -0800
Message-Id: <20191219004706.39039-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare qla_hw_data.flt as a qla_flt_header pointer instead of as a void
pointer. Add a zero-length array at the end of struct qla_flt_header to
make it clear that qla_flt_header and qla_flt_region are contiguous. This
patch removes several casts but does not change any functionality.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 +-
 drivers/scsi/qla2xxx/qla_fw.h  | 15 ++++++++-------
 drivers/scsi/qla2xxx/qla_os.c  |  2 ++
 drivers/scsi/qla2xxx/qla_sup.c | 11 ++++-------
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 35a979b55063..e55baec3db68 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3950,7 +3950,7 @@ struct qla_hw_data {
 	void		*sfp_data;
 	dma_addr_t	sfp_data_dma;
 
-	void		*flt;
+	struct qla_flt_header *flt;
 	dma_addr_t	flt_dma;
 
 #define XGMAC_DATA_SIZE	4096
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 9dc09c117416..5668b31db1ea 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1470,13 +1470,6 @@ struct qla_flt_location {
 	uint16_t checksum;
 };
 
-struct qla_flt_header {
-	uint16_t version;
-	uint16_t length;
-	uint16_t checksum;
-	uint16_t unused;
-};
-
 #define FLT_REG_FW		0x01
 #define FLT_REG_BOOT_CODE	0x07
 #define FLT_REG_VPD_0		0x14
@@ -1537,6 +1530,14 @@ struct qla_flt_region {
 	uint32_t end;
 };
 
+struct qla_flt_header {
+	uint16_t version;
+	uint16_t length;
+	uint16_t checksum;
+	uint16_t unused;
+	struct qla_flt_region region[0];
+};
+
 #define FLT_REGION_SIZE		16
 #define FLT_MAX_REGIONS		0xFF
 #define FLT_REGIONS_SIZE	(FLT_REGION_SIZE * FLT_MAX_REGIONS)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d19bf5225f4a..326f1b2dc0a2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7273,6 +7273,8 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
 	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
+	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
+	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
 
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index bbe90354f49b..76a38bf86cbc 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -669,8 +669,8 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t def = IS_QLA81XX(ha) ? 2 : IS_QLA25XX(ha) ? 1 : 0;
-	struct qla_flt_header *flt = (void *)ha->flt;
-	struct qla_flt_region *region = (void *)&flt[1];
+	struct qla_flt_header *flt = ha->flt;
+	struct qla_flt_region *region = &flt->region[0];
 	uint16_t *wptr, cnt, chksum;
 	uint32_t start;
 
@@ -2652,18 +2652,15 @@ qla28xx_get_flash_region(struct scsi_qla_host *vha, uint32_t start,
     struct qla_flt_region *region)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_flt_header *flt;
-	struct qla_flt_region *flt_reg;
+	struct qla_flt_header *flt = ha->flt;
+	struct qla_flt_region *flt_reg = &flt->region[0];
 	uint16_t cnt;
 	int rval = QLA_FUNCTION_FAILED;
 
 	if (!ha->flt)
 		return QLA_FUNCTION_FAILED;
 
-	flt = (struct qla_flt_header *)ha->flt;
-	flt_reg = (struct qla_flt_region *)&flt[1];
 	cnt = le16_to_cpu(flt->length) / sizeof(struct qla_flt_region);
-
 	for (; cnt; cnt--, flt_reg++) {
 		if (flt_reg->start == start) {
 			memcpy((uint8_t *)region, flt_reg,
