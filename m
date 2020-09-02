Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78230C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502CC2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZrWsBrMk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIBH3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:29:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49494 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726247AbgIBH3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:29:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0827QHNR016277
        for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2020 00:29:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Q+0H442qC7kc0hYNuUZVRDljNpFDNadm4voVj/jsKAY=;
 b=ZrWsBrMk9rmZi3gtyuu6AxL8wd2R5Rqr4a0IgtI/ey5EgjM4WHEPSqHIvbISF37vgAB1
 bUpkgj9WLlFq6uNgbJMm4OUBcBGKC1RQjOlkYU96Xlp39Vc5dVS+MQl1PfmSyZ5FNzTP
 HN8vlBh4jffVcD8m/oEV8ldBBhEn0O1kfYXXq/tpLF8syMLrj+JOFOa7Jd7spghBJr06
 UnBW4OgE6w/3j1Iz6ktLBanrLPr903olBZeefB/B/fGFzljhJeG6MwwUp2aC2+sqCERo
 otqpxVTLTx3Af4OzRITws2CyjgMxb1LG10hb7OrkcKqJjD+N3Ti/blL06Cxy90sUJBhA 0g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqdwy6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 00:29:51 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:29:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:29:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 00:29:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 095773F703F;
        Wed,  2 Sep 2020 00:29:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0827Tnvj011596;
        Wed, 2 Sep 2020 00:29:49 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0827Tn2t011595;
        Wed, 2 Sep 2020 00:29:49 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 09/13] qla2xxx: Make tgt_port_database available in initiator mode
Date:   Wed, 2 Sep 2020 00:25:44 -0700
Message-ID: <20200902072548.11491-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200902072548.11491-1-njavali@marvell.com>
References: <20200902072548.11491-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-02,2020-09-02 signatures=0
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
index 616ce891818d..1e9db568aee3 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -138,51 +138,51 @@ qla2x00_dfs_tgt_port_database_show(struct seq_file *s, void *unused)
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

