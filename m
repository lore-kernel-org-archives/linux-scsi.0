Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA96C19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbiHCQaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238362AbiHCQ3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:43 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CB646D9A;
        Wed,  3 Aug 2022 09:29:42 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B4BDC412D1;
        Wed,  3 Aug 2022 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544179; x=1661358580; bh=CfEYe0eUF+xFUwUpdFGO4qS65
        rJQg7BGNpQzrHb6DGU=; b=wIf3GVhPyomicjYN4mYHfHfljmJmSQfi/xNNZEN5N
        GSw4s783D6yPP1p9/sIBSJb1I13OYa1ifFoDhWVl1dO5Mfzp8H8GewElSwEwpRYU
        lcu9RVp+aUHeHjxBYAJ0wHPS9kuPqGlexPTFIGgp4G5JPTW28nbC1t9LbRUYvUyF
        DA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yQ9jNpZhM58j; Wed,  3 Aug 2022 19:29:39 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7625D412D8;
        Wed,  3 Aug 2022 19:29:20 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:20 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:19 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 29/48] target: core: store proto_id in APTPL
Date:   Thu, 30 Jun 2022 14:11:01 +0300
Message-ID: <20220803162857.27770-30-d.bogdanov@yadro.com>
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

Store and read proto_id in APTPL to create TransportID.
That will allow to report registrations for not yet created TPG/ACL/LUNs

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c | 13 +++++++++++--
 drivers/target/target_core_pr.c       | 15 ++++++++++-----
 drivers/target/target_core_pr.h       |  2 +-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 0978279bd5e3..f63c37344104 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1974,7 +1974,8 @@ enum {
 	Opt_initiator_fabric, Opt_initiator_node, Opt_initiator_sid,
 	Opt_sa_res_key, Opt_res_holder, Opt_res_type, Opt_res_scope,
 	Opt_res_all_tg_pt, Opt_mapped_lun, Opt_target_fabric,
-	Opt_target_node, Opt_tpgt, Opt_port_rtpi, Opt_target_lun, Opt_err
+	Opt_target_node, Opt_tpgt, Opt_port_rtpi, Opt_target_lun,
+	Opt_proto_id, Opt_err
 };
 
 static match_table_t tokens = {
@@ -1992,6 +1993,7 @@ static match_table_t tokens = {
 	{Opt_tpgt, "tpgt=%d"},
 	{Opt_port_rtpi, "port_rtpi=%d"},
 	{Opt_target_lun, "target_lun=%u"},
+	{Opt_proto_id, "proto_id=%u"},
 	{Opt_err, NULL}
 };
 
@@ -2010,6 +2012,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	u16 tpgt = 0;
 	u16 rtpi = 0;
 	u8 type = 0;
+	u8 proto_id = 0;
 
 	if (!dev->dev_attrib.emulate_pr ||
 	    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
@@ -2151,6 +2154,12 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 				goto out;
 			target_lun = (u64)tmp_ll;
 			break;
+		case Opt_proto_id:
+			ret = match_int(args, &arg);
+			if (ret)
+				goto out;
+			proto_id = (u16)arg;
+			break;
 		default:
 			break;
 		}
@@ -2171,7 +2180,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 
 	ret = core_scsi3_alloc_aptpl_registration(&dev->t10_pr, sa_res_key,
 			i_port, isid, mapped_lun, rtpi, target_lun,
-			res_holder, all_tg_pt, type);
+			res_holder, all_tg_pt, type, proto_id);
 out:
 	kfree(i_fabric);
 	kfree(i_port);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index f5796d60ed76..d177db3024c9 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -842,7 +842,8 @@ int core_scsi3_alloc_aptpl_registration(
 	u64 target_lun,
 	int res_holder,
 	int all_tg_pt,
-	u8 type)
+	u8 type,
+	u8 proto_id)
 {
 	struct t10_pr_registration *pr_reg;
 
@@ -886,6 +887,7 @@ int core_scsi3_alloc_aptpl_registration(
 	 * Copy the i_port information from caller.
 	 */
 	snprintf(pr_reg->pr_iport, PR_APTPL_MAX_IPORT_LEN, "%s", i_port);
+	target_gen_pr_transport_id(pr_reg, proto_id, i_port, isid);
 	/*
 	 * Set pr_res_holder from caller, the pr_reg who is the reservation
 	 * holder will get it's pointer set in core_scsi3_aptpl_reserve() once
@@ -1836,19 +1838,22 @@ static int core_scsi3_update_aptpl_buf(
 				"sa_res_key=%llu\n"
 				"res_holder=1\nres_type=%02x\n"
 				"res_scope=%02x\nres_all_tg_pt=%d\n"
-				"mapped_lun=%llu\n", reg_count,
+				"mapped_lun=%llu\nproto_id=%u\n", reg_count,
 				pr_reg->pr_iport, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_res_type,
 				pr_reg->pr_res_scope, pr_reg->pr_reg_all_tg_pt,
-				pr_reg->pr_res_mapped_lun);
+				pr_reg->pr_res_mapped_lun,
+				pr_reg->pr_tid[0] & 0xF);
 		} else {
 			snprintf(tmp, 512, "PR_REG_START: %d\n"
 				"initiator_node=%s\n%s"
 				"sa_res_key=%llu\nres_holder=0\n"
-				"res_all_tg_pt=%d\nmapped_lun=%llu\n",
+				"res_all_tg_pt=%d\nmapped_lun=%llu\n"
+				"proto_id=%u\n",
 				reg_count, pr_reg->pr_iport, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_reg_all_tg_pt,
-				pr_reg->pr_res_mapped_lun);
+				pr_reg->pr_res_mapped_lun,
+				pr_reg->pr_tid[0] & 0xF);
 		}
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 954b0dff32bf..589fdac5470f 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -64,7 +64,7 @@ extern sense_reason_t target_scsi2_reservation_reserve(struct se_cmd *);
 extern int core_scsi3_alloc_aptpl_registration(
 			struct t10_reservation *, u64,
 			unsigned char *, unsigned char *, u64,
-			u16, u64, int, int, u8);
+			u16, u64, int, int, u8, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
 			struct se_node_acl *, u64);
-- 
2.25.1

