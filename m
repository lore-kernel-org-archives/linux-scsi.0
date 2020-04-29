Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A95C8300A
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72F82082E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="K7B5tHIh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgD2Jph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:37 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39854 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbgD2Jpg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:36 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 374544C84F;
        Wed, 29 Apr 2020 09:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153531; x=1589967932; bh=MHpALc/oNT9f7nhuCJ8vAm7IcIHgJW50szm
        IjnL6rQU=; b=K7B5tHIhuoDcGZg+G2XcQ3vUXyrRwgGH3g/4Y+FsBVq3necLJY8
        08uJLN+5ccc2k4RrbIlGAJl/O2n2zuCgDoe6aex0rnSBwAao6sNjiIsq079qH9+a
        2PS08OpM5dpUC+7xbHwafuoWR4DmtyS7cXgXGGwb5WNhK1Z5G8c0sM5c=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hnCe3u5gWA9B; Wed, 29 Apr 2020 12:45:31 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D81464C855;
        Wed, 29 Apr 2020 12:45:29 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:31 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RFC PATCH 11/11] scsi: target/core: Show peer ports in RTPG response
Date:   Wed, 29 Apr 2020 12:44:44 +0300
Message-ID: <20200429094443.43937-12-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The change makes peer ports visible in the response to REPORT TARGET
PORT GROUPS command. RTPI values of real SCSI target ports and peer
ports for each target port descriptor list are sorted in ascending
order.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_alua.c     | 32 +++++++++++++++++++++++----
 drivers/target/target_core_configfs.c |  2 ++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 81ed79500376..f7d88181d683 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -18,6 +18,7 @@
 #include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/sort.h>
 #include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
@@ -127,6 +128,11 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	return 0;
 }
 
+static int cmp_rtpi(const void *a, const void *b)
+{
+	return *(u16 *)a - *(u16 *)b;
+}
+
 /*
  * REPORT_TARGET_PORT_GROUPS
  *
@@ -138,7 +144,11 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct se_lun *lun;
+	struct t10_alua_tg_pt_gp_peer *peer;
 	unsigned char *buf;
+	u8 port_cnt;
+	u16 *ports = NULL;
+	int i = 0;
 	u32 rd_len = 0, off;
 	int ext_hdr = (cmd->t_task_cdb[1] & 0x20);
 
@@ -209,12 +219,24 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		/*
 		 * TARGET PORT COUNT
 		 */
-		buf[off++] = (tg_pt_gp->tg_pt_gp_members & 0xff);
+		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+		port_cnt = (tg_pt_gp->tg_pt_gp_members & 0xff);
+		buf[off++] = port_cnt;
 		rd_len += 8;
+		ports = kcalloc(tg_pt_gp->tg_pt_gp_members, sizeof(u16),
+				GFP_ATOMIC);
 
-		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+		i = 0;
 		list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
-				lun_tg_pt_gp_link) {
+				    lun_tg_pt_gp_link)
+			ports[i++] = lun->lun_tpg->tpg_rtpi;
+
+		list_for_each_entry(peer, &tg_pt_gp->tg_pt_gp_peer_list,
+				    tg_pt_gp_peer_list)
+			ports[i++] = peer->tg_pt_gp_peer_rtpi;
+
+		sort(ports, port_cnt, sizeof(*ports), cmp_rtpi, NULL);
+		for (i = 0; i < port_cnt; i++) {
 			/*
 			 * Start Target Port descriptor format
 			 *
@@ -224,10 +246,12 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 			/*
 			 * Set RELATIVE TARGET PORT IDENTIFIER
 			 */
-			put_unaligned_be16(lun->lun_tpg->tpg_rtpi, &buf[off]);
+			put_unaligned_be16(ports[i], &buf[off]);
 			off += 2;
 			rd_len += 4;
 		}
+		kfree(ports);
+		ports = NULL;
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	}
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c43f244f8bd6..4026debe30ca 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3161,6 +3161,7 @@ target_core_alua_tg_pt_gp_peers_make(struct config_group *group,
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_add_tail(&peer_port->tg_pt_gp_peer_list,
 		      &tg_pt_gp->tg_pt_gp_peer_list);
+	tg_pt_gp->tg_pt_gp_members++;
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	mutex_unlock(&g_rtpi_mutex);
 
@@ -3181,6 +3182,7 @@ static void target_core_alua_tg_pt_gp_peers_drop(struct config_group *group,
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(group,
 			struct t10_alua_tg_pt_gp, tg_pt_gp_peers_group);
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	tg_pt_gp->tg_pt_gp_members--;
 	list_del(&peer_port->tg_pt_gp_peer_list);
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-- 
2.26.1

