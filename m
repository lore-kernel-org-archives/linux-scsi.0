Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D58C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E8DB206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KiajOmbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgHRMgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:36:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgHRMgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:36:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICVcZB026230
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:36:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3sDrUXgOBZDsXrWOIc/y6C7iMLpTXuSdr0nyWnC2l9Y=;
 b=KiajOmbzKreMSF24Pkg96G6HUMSLzpbQ+MWkwOBbI3LYYq1aHhlTRyPcI/p22rr+M1bd
 jnSqevdntL0MJ4Cy8GhxdspDdegTAlQ6ZxQSs91mfsnp32l+7oHQMFH3cUpIsgxv+qSX
 3drrjrZsncvBzQ6u9FAs3B3rLYhUzhHRosF8nLRWNRrqzq/OLs67FEkCXXu3aYzzfs4b
 KKwYqWEl6nOcUVh3oH70P7hYjXqL9QkFQQHbpWtrVNw8E/BEkZyFuucnAfQAYfLydkh+
 nWo1aqk4mzKraDgF7arlO+2sELloH2S3Q4hbUPY6s+98Oq0iAAENdcQscYp8cK4h6/Dy wA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhjcuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:36:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:36:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:36:04 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 85D583F703F;
        Tue, 18 Aug 2020 05:36:04 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICa42K020466;
        Tue, 18 Aug 2020 05:36:04 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICa4Jd020457;
        Tue, 18 Aug 2020 05:36:04 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/12] qla2xxx: Make tgt_port_database available in initiator mode
Date:   Tue, 18 Aug 2020 05:32:00 -0700
Message-ID: <20200818123203.20361-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200818123203.20361-1-njavali@marvell.com>
References: <20200818123203.20361-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

tgt_port_database data is today exported only in target mode, allow it
to be shown in initiator mode, as well.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 64 +++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 7482e6bf7f7f..610440c647a6 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -134,51 +134,51 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
 {
 	scsi_qla_host_t *vha = s->private;
 	struct qla_hw_data *ha = vha->hw;
-	struct gid_list_info *gid_list, *gid;
+	struct gid_list_info *gid_list;
 	dma_addr_t gid_list_dma;
 	fc_port_t fc_port;
+	char *id_iter;
 	int rc, i;
 	uint16_t entries, loop_id;
-	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 
 	seq_printf(s, "%s\n", vha->host_str);
-	if (tgt) {
-		gid_list = dma_alloc_coherent(&ha->pdev->dev,
-		    qla2x00_gid_list_size(ha),
-		    &gid_list_dma, GFP_KERNEL);
-		if (!gid_list) {
-			ql_dbg(ql_dbg_user, vha, 0x7018,
-			    "DMA allocation failed for %u\n",
-			     qla2x00_gid_list_size(ha));
-			return 0;
-		}
+	gid_list = dma_alloc_coherent(&ha->pdev->dev,
+				      qla2x00_gid_list_size(ha),
+				      &gid_list_dma, GFP_KERNEL);
+	if (!gid_list) {
+		ql_dbg(ql_dbg_user, vha, 0x7018,
+		       "DMA allocation failed for %u\n",
+		       qla2x00_gid_list_size(ha));
+		return 0;
+	}
 
-		rc = qla24xx_gidlist_wait(vha, gid_list, gid_list_dma,
-		    &entries);
-		if (rc != QLA_SUCCESS)
-			goto out_free_id_list;
+	rc = qla24xx_gidlist_wait(vha, gid_list, gid_list_dma,
+				  &entries);
+	if (rc != QLA_SUCCESS)
+		goto out_free_id_list;
 
-		gid = gid_list;
+	id_iter = (char *)gid_list;
 
-		seq_puts(s, "Port Name	Port ID 	Loop ID\n");
+	seq_puts(s, "Port Name	Port ID		Loop ID\n");
 
-		for (i = 0; i < entries; i++) {
-			loop_id = le16_to_cpu(gid->loop_id);
-			memset(&fc_port, 0, sizeof(fc_port_t));
+	for (i = 0; i < entries; i++) {
+		struct gid_list_info *gid =
+			(struct gid_list_info *)id_iter;
+		loop_id = le16_to_cpu(gid->loop_id);
+		memset(&fc_port, 0, sizeof(fc_port_t));
 
-			fc_port.loop_id = loop_id;
+		fc_port.loop_id = loop_id;
 
-			rc = qla24xx_gpdb_wait(vha, &fc_port, 0);
-			seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
-				fc_port.port_name, fc_port.d_id.b.domain,
-				fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
-				fc_port.loop_id);
-			gid = (void *)gid + ha->gid_list_info_size;
-		}
-out_free_id_list:
-		dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
-		    gid_list, gid_list_dma);
+		rc = qla24xx_gpdb_wait(vha, &fc_port, 0);
+		seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
+			   fc_port.port_name, fc_port.d_id.b.domain,
+			   fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
+			   fc_port.loop_id);
+		id_iter += ha->gid_list_info_size;
 	}
+out_free_id_list:
+	dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
+			  gid_list, gid_list_dma);
 
 	return 0;
 }
-- 
2.19.0.rc0

