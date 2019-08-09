Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACB4C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A81A2216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405059AbfHIDC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33371 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405037AbfHIDCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so45223652pfq.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCZQ+qCkmgpsy21cQbtlyPAwXlV3MrC6tFMibucMfLs=;
        b=EZYY7wVGrC69FSXlPqSzkowIU2PVnOrNrQ6zDAZGCuRa668FhftQ7CXbtg5NqLZhND
         D/lzgah7jxMj5KJ5G6dGHk70ZKoyLtrzpuCTLaHSbiJXE0Vtkh4ONvIiTrkxUkJ1tFsU
         MyzJwF/f2/bbm12zzFOhEvMDLuKQtFqUbIs9pYI6TcKBuqKeBTVAIc7gxjQ/iqctfVRq
         7e5nYiku+o4afeU3nLQ2IH5dp/c9ydgqv7TYayUSXWHs7OR7k4bVCTnSMEkxvNE3HiNk
         vmS1OapqVg7N764gvUDL0ubfgudUEIu4UE72JizXM1dd96LHry/R+xmNvKd/JurI5Zep
         f/Ng==
X-Gm-Message-State: APjAAAXbP7scV7RjlA6a9Sw+FQBOzE2/+vqHdxm5sJRdLgoS9Ed0hUBn
        NnXnoPS0zeWWLki7yYBiAlDGCqkG
X-Google-Smtp-Source: APXvYqzZUyGgj0EuEdzaOPwHdxtgnKakCOV0VWNutCJNZHRSpLQmmfKfpM1f1FuCBQho3nBKYxEmsg==
X-Received: by 2002:a65:60d3:: with SMTP id r19mr15667231pgv.91.1565319774725;
        Thu, 08 Aug 2019 20:02:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 14/58] qla2xxx: Reduce the number of casts in GID list code
Date:   Thu,  8 Aug 2019 20:01:35 -0700
Message-Id: <20190809030219.11296-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes the code that parses the GID list easier to read
without changing the behavior of the code.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c    |  9 +++------
 drivers/scsi/qla2xxx/qla_init.c   | 18 ++++++++----------
 drivers/scsi/qla2xxx/qla_target.c |  9 +++------
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index a432caebefec..0a6fb359f4d5 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -57,10 +57,9 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 {
 	scsi_qla_host_t *vha = s->private;
 	struct qla_hw_data *ha = vha->hw;
-	struct gid_list_info *gid_list;
+	struct gid_list_info *gid_list, *gid;
 	dma_addr_t gid_list_dma;
 	fc_port_t fc_port;
-	char *id_iter;
 	int rc, i;
 	uint16_t entries, loop_id;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
@@ -82,13 +81,11 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 		if (rc != QLA_SUCCESS)
 			goto out_free_id_list;
 
-		id_iter = (char *)gid_list;
+		gid = gid_list;
 
 		seq_puts(s, "Port Name	Port ID 	Loop ID\n");
 
 		for (i = 0; i < entries; i++) {
-			struct gid_list_info *gid =
-			    (struct gid_list_info *)id_iter;
 			loop_id = le16_to_cpu(gid->loop_id);
 			memset(&fc_port, 0, sizeof(fc_port_t));
 
@@ -99,7 +96,7 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 				fc_port.port_name, fc_port.d_id.b.domain,
 				fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
 				fc_port.loop_id);
-			id_iter += ha->gid_list_info_size;
+			gid = (void *)gid + ha->gid_list_info_size;
 		}
 out_free_id_list:
 		dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3585eb7b87b5..c24d7667d3c9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5086,7 +5086,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 
 	uint16_t	index;
 	uint16_t	entries;
-	char		*id_iter;
+	struct gid_list_info *gid;
 	uint16_t	loop_id;
 	uint8_t		domain, area, al_pa;
 	struct qla_hw_data *ha = vha->hw;
@@ -5161,18 +5161,16 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	new_fcport->flags &= ~FCF_FABRIC_DEVICE;
 
 	/* Add devices to port list. */
-	id_iter = (char *)ha->gid_list;
+	gid = ha->gid_list;
 	for (index = 0; index < entries; index++) {
-		domain = ((struct gid_list_info *)id_iter)->domain;
-		area = ((struct gid_list_info *)id_iter)->area;
-		al_pa = ((struct gid_list_info *)id_iter)->al_pa;
+		domain = gid->domain;
+		area = gid->area;
+		al_pa = gid->al_pa;
 		if (IS_QLA2100(ha) || IS_QLA2200(ha))
-			loop_id = (uint16_t)
-			    ((struct gid_list_info *)id_iter)->loop_id_2100;
+			loop_id = gid->loop_id_2100;
 		else
-			loop_id = le16_to_cpu(
-			    ((struct gid_list_info *)id_iter)->loop_id);
-		id_iter += ha->gid_list_info_size;
+			loop_id = le16_to_cpu(gid->loop_id);
+		gid = (void *)gid + ha->gid_list_info_size;
 
 		/* Bypass reserved domain fields. */
 		if ((domain & 0xf0) == 0xf0)
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ded5f13372af..3a25536c2492 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1290,8 +1290,7 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 {
 	struct qla_hw_data *ha = vha->hw;
 	dma_addr_t gid_list_dma;
-	struct gid_list_info *gid_list;
-	char *id_iter;
+	struct gid_list_info *gid_list, *gid;
 	int res, rc, i;
 	uint16_t entries;
 
@@ -1314,11 +1313,9 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 		goto out_free_id_list;
 	}
 
-	id_iter = (char *)gid_list;
+	gid = gid_list;
 	res = -ENOENT;
 	for (i = 0; i < entries; i++) {
-		struct gid_list_info *gid = (struct gid_list_info *)id_iter;
-
 		if ((gid->al_pa == s_id[2]) &&
 		    (gid->area == s_id[1]) &&
 		    (gid->domain == s_id[0])) {
@@ -1326,7 +1323,7 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 			res = 0;
 			break;
 		}
-		id_iter += ha->gid_list_info_size;
+		gid = (void *)gid + ha->gid_list_info_size;
 	}
 
 out_free_id_list:
-- 
2.22.0

