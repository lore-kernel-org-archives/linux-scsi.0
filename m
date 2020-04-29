Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6ECCC8300A
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820DD20775
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="pgIBmbv2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgD2Jpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:35 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39854 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726423AbgD2Jpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id ECDE74C854;
        Wed, 29 Apr 2020 09:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153527; x=1589967928; bh=bFJIOge9+mMiSBUv12gdYtzMBlCFiKSAmL2
        XwLQqWvg=; b=pgIBmbv2ow/Wt2JaVOliAvkPplr213wSsPNaecWHnwfaew0ReiG
        rDTD2+VxU6pwUbCGAKCd/vrJE/+Q0NMCRuqnu7HdNtyqTLpjaIF0i7em0bcsu29s
        ifklDr3paGT/wd+Mcoqe7582kIoqYML+Suq14M6MwxbqULEN+8ulq96M=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wDPbX3FncoU8; Wed, 29 Apr 2020 12:45:27 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EC5154C84F;
        Wed, 29 Apr 2020 12:45:26 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:28 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RFC PATCH 05/11] scsi: target/core: Use RTPI from target port
Date:   Wed, 29 Apr 2020 12:44:38 +0300
Message-ID: <20200429094443.43937-6-r.bolshakov@yadro.com>
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

Replace all references to RTPI from LUN field to se_portal_group field.
It introduces consitent reporting of RTPI for all LUNs and all target
ports.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_alua.c   | 4 ++--
 drivers/target/target_core_device.c | 2 +-
 drivers/target/target_core_pr.c     | 8 ++++----
 drivers/target/target_core_spc.c    | 2 +-
 drivers/target/target_core_stat.c   | 6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index b98a5b5fce49..8053f3989bbb 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -224,7 +224,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 			/*
 			 * Set RELATIVE TARGET PORT IDENTIFIER
 			 */
-			put_unaligned_be16(lun->lun_rtpi, &buf[off]);
+			put_unaligned_be16(lun->lun_tpg->tpg_rtpi, &buf[off]);
 			off += 2;
 			rd_len += 4;
 		}
@@ -405,7 +405,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			spin_lock(&dev->se_port_lock);
 			list_for_each_entry(lun, &dev->dev_sep_list,
 							lun_dev_link) {
-				if (lun->lun_rtpi != rtpi)
+				if (lun->lun_tpg->tpg_rtpi != rtpi)
 					continue;
 
 				// XXX: racy unlock
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4cee1138284b..cb4d8cc4ff45 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -227,7 +227,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 				tpg->se_tpg_tfo->fabric_name);
 			continue;
 		}
-		if (lun->lun_rtpi != rtpi)
+		if (lun->lun_tpg->tpg_rtpi != rtpi)
 			continue;
 
 		kref_get(&deve->pr_kref);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5e931690e697..87af494c4e75 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -662,7 +662,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	}
 	pr_reg->pr_res_mapped_lun = mapped_lun;
 	pr_reg->pr_aptpl_target_lun = lun->unpacked_lun;
-	pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;
+	pr_reg->tg_pt_sep_rtpi = lun->lun_tpg->tpg_rtpi;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = aptpl;
@@ -971,7 +971,7 @@ static int __core_scsi3_check_aptpl_registration(
 			rcu_read_unlock();
 
 			pr_reg->pr_reg_nacl = nacl;
-			pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;
+			pr_reg->tg_pt_sep_rtpi = lun->lun_tpg->tpg_rtpi;
 			list_del(&pr_reg->pr_reg_aptpl_list);
 			spin_unlock(&pr_tmpl->aptpl_reg_lock);
 			/*
@@ -1589,7 +1589,7 @@ core_scsi3_decode_spec_i_port(
 			 */
 			if (tmp_tpg->proto_id != proto_ident)
 				continue;
-			dest_rtpi = tmp_lun->lun_rtpi;
+			dest_rtpi = tmp_lun->lun_tpg->tpg_rtpi;
 
 			i_str = target_parse_pr_out_transport_id(tmp_tpg,
 					ptr, &tid_len, &iport_ptr);
@@ -3225,7 +3225,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 
 	spin_lock(&dev->se_port_lock);
 	list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
-		if (tmp_lun->lun_rtpi != rtpi)
+		if (tmp_lun->lun_tpg->tpg_rtpi != rtpi)
 			continue;
 		dest_se_tpg = tmp_lun->lun_tpg;
 		dest_tf_ops = dest_se_tpg->se_tpg_tfo;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 633dee9ac877..0b276c79fdba 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -301,7 +301,7 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		/* Skip over Obsolete field in RTPI payload
 		 * in Table 472 */
 		off += 2;
-		put_unaligned_be16(lun->lun_rtpi, &buf[off]);
+		put_unaligned_be16(lun->lun_tpg->tpg_rtpi, &buf[off]);
 		off += 2;
 		len += 8; /* Header size + Designation descriptor */
 		/*
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 237309db4b33..9d5a2bc43d4e 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -458,7 +458,7 @@ static ssize_t target_stat_port_indx_show(struct config_item *item, char *page)
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_tpg->tpg_rtpi);
 	rcu_read_unlock();
 	return ret;
 }
@@ -564,7 +564,7 @@ static ssize_t target_stat_tgt_port_indx_show(struct config_item *item,
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_tpg->tpg_rtpi);
 	rcu_read_unlock();
 	return ret;
 }
@@ -582,7 +582,7 @@ static ssize_t target_stat_tgt_port_name_show(struct config_item *item,
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
 			tpg->se_tpg_tfo->fabric_name,
-			lun->lun_rtpi);
+			lun->lun_tpg->tpg_rtpi);
 	rcu_read_unlock();
 	return ret;
 }
-- 
2.26.1

