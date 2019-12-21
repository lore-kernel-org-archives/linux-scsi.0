Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63D1C19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiHCQ30 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236336AbiHCQ3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:19 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B76FB7F1;
        Wed,  3 Aug 2022 09:29:18 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0D171412CC;
        Wed,  3 Aug 2022 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544154; x=1661358555; bh=bTn0+8wdAkk+C7HrrnZK+MAoT
        gpu4GHz8yPpg+OGVZ8=; b=Rkei+HlEHT4cH4zJ3aSoEPmxZO6DX3mElG2ZNTHDu
        soC/Is42wMve+qXKlUFs45rNcCiVN0Xn/qZZjNKNM9lM9TK+rifvQcLZ9rT1j5N8
        OYU04NqVAkD6ZA02Xpjp3Yoxm6EtLWqYs/8BpgdfRCa8478oelPHZdFq0D49HXs6
        Nw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6a6ew5FqCpt7; Wed,  3 Aug 2022 19:29:14 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5A6F041291;
        Wed,  3 Aug 2022 19:29:12 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:12 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:11 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 05/48] scsi: target/core: Use RTPI from target port
Date:   Sun, 22 Dec 2019 02:45:33 +0300
Message-ID: <20220803162857.27770-6-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

Replace all references to RTPI from LUN field to se_portal_group field.
It introduces consitent reporting of RTPI for all LUNs and all target
ports.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_alua.c   | 4 ++--
 drivers/target/target_core_device.c | 2 +-
 drivers/target/target_core_pr.c     | 8 ++++----
 drivers/target/target_core_spc.c    | 2 +-
 drivers/target/target_core_stat.c   | 6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 9d1a8238a4c6..774750715ba8 100644
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
@@ -404,7 +404,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			spin_lock(&dev->se_port_lock);
 			list_for_each_entry(lun, &dev->dev_sep_list,
 							lun_dev_link) {
-				if (lun->lun_rtpi != rtpi)
+				if (lun->lun_tpg->tpg_rtpi != rtpi)
 					continue;
 
 				// XXX: racy unlock
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 086ac9c9343c..bbef6b869ee9 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -223,7 +223,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 				tpg->se_tpg_tfo->fabric_name);
 			continue;
 		}
-		if (lun->lun_rtpi != rtpi)
+		if (lun->lun_tpg->tpg_rtpi != rtpi)
 			continue;
 
 		kref_get(&deve->pr_kref);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3829b61b56c1..668670b1414a 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -663,7 +663,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	}
 	pr_reg->pr_res_mapped_lun = mapped_lun;
 	pr_reg->pr_aptpl_target_lun = lun->unpacked_lun;
-	pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;
+	pr_reg->tg_pt_sep_rtpi = lun->lun_tpg->tpg_rtpi;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = aptpl;
@@ -969,7 +969,7 @@ static int __core_scsi3_check_aptpl_registration(
 			rcu_read_unlock();
 
 			pr_reg->pr_reg_nacl = nacl;
-			pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;
+			pr_reg->tg_pt_sep_rtpi = lun->lun_tpg->tpg_rtpi;
 			list_del(&pr_reg->pr_reg_aptpl_list);
 			spin_unlock(&pr_tmpl->aptpl_reg_lock);
 			/*
@@ -1577,7 +1577,7 @@ core_scsi3_decode_spec_i_port(
 			 */
 			if (tmp_tpg->proto_id != proto_ident)
 				continue;
-			dest_rtpi = tmp_lun->lun_rtpi;
+			dest_rtpi = tmp_lun->lun_tpg->tpg_rtpi;
 
 			iport_ptr = NULL;
 			i_str = target_parse_pr_out_transport_id(tmp_tpg,
@@ -3221,7 +3221,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 
 	spin_lock(&dev->se_port_lock);
 	list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
-		if (tmp_lun->lun_rtpi != rtpi)
+		if (tmp_lun->lun_tpg->tpg_rtpi != rtpi)
 			continue;
 		dest_se_tpg = tmp_lun->lun_tpg;
 		dest_tf_ops = dest_se_tpg->se_tpg_tfo;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 252d704264ed..be18a72d9f8a 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -332,7 +332,7 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		/* Skip over Obsolete field in RTPI payload
 		 * in Table 472 */
 		off += 2;
-		put_unaligned_be16(lun->lun_rtpi, &buf[off]);
+		put_unaligned_be16(lun->lun_tpg->tpg_rtpi, &buf[off]);
 		off += 2;
 		len += 8; /* Header size + Designation descriptor */
 		/*
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 62d15bcc3d93..8fd6efa2b978 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -455,7 +455,7 @@ static ssize_t target_stat_port_indx_show(struct config_item *item, char *page)
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_tpg->tpg_rtpi);
 	rcu_read_unlock();
 	return ret;
 }
@@ -561,7 +561,7 @@ static ssize_t target_stat_tgt_port_indx_show(struct config_item *item,
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_tpg->tpg_rtpi);
 	rcu_read_unlock();
 	return ret;
 }
@@ -579,7 +579,7 @@ static ssize_t target_stat_tgt_port_name_show(struct config_item *item,
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
 			tpg->se_tpg_tfo->fabric_name,
-			lun->lun_rtpi);
+			lun->lun_tpg->tpg_rtpi);
 	rcu_read_unlock();
 	return ret;
 }
-- 
2.25.1

