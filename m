Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5541DC25B07
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiHCQ3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiHCQ3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:17 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932A7DEBD;
        Wed,  3 Aug 2022 09:29:15 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3D9CE412C8;
        Wed,  3 Aug 2022 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544152; x=1661358553; bh=cWTZkdj1OTtRNc40YGJ3Y4Qr8
        RkuXngG7Uzgs5cBdAU=; b=RPxPpAqD8+Xhi9nW/8xU2UxAM4vH038ReFTn+da4Z
        5lHX2Wzx42p+8L2nRnU23VMo5tPCMYb0ih7F1of8iv+tojFFXjfxNSUXiK16HW5E
        WBz73u2xF7D9w4zoSMcOjOewk4q+DzXtT1ph9ys7nFmybt4qM9zO2ss1+CtXtpxh
        lo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AOzRwOfmC1AA; Wed,  3 Aug 2022 19:29:12 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B8FA341283;
        Wed,  3 Aug 2022 19:29:11 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:11 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:10 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 01/48] scsi: target/core: Add a way to hide a port group
Date:   Sat, 4 Apr 2020 13:48:52 +0300
Message-ID: <20220803162857.27770-2-d.bogdanov@yadro.com>
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

Default target port group is always returned in the list of port groups,
even if the behaviour is unwanted, i.e. it has no members and
non-default port groups are primary port groups.

A new port group attribute - "hidden" can be used to hide empty port
groups with no ports in REPORT TARGET PORT GROUPS, including default
target port group:

  echo 1 > $DEVICE/alua/default_tg_pt_gp/hidden

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_alua.c     |  8 ++++++++
 drivers/target/target_core_configfs.c | 29 +++++++++++++++++++++++++++
 include/target/target_core_base.h     |  1 +
 3 files changed, 38 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 58df0145e8d0..9d1a8238a4c6 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -164,6 +164,8 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
+		if (tg_pt_gp->tg_pt_gp_hidden && !tg_pt_gp->tg_pt_gp_members)
+			continue;
 		/*
 		 * Check if the Target port group and Target port descriptor list
 		 * based on tg_pt_gp_members count will fit into the response payload.
@@ -308,6 +310,12 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
+	if (l_tg_pt_gp->tg_pt_gp_hidden && !tg_pt_gp->tg_pt_gp_members) {
+		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		pr_err("Unable to change state for hidden port group with no members\n");
+		rc = TCM_INVALID_CDB_FIELD;
+		goto out;
+	}
 	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
 	rcu_read_unlock();
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 416514c5c7ac..7c0e42e782de 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3029,6 +3029,33 @@ static ssize_t target_tg_pt_gp_preferred_store(struct config_item *item,
 	return core_alua_store_preferred_bit(to_tg_pt_gp(item), page, count);
 }
 
+static ssize_t target_tg_pt_gp_hidden_show(struct config_item *item,
+					   char *page)
+{
+	return sprintf(page, "%d\n", to_tg_pt_gp(item)->tg_pt_gp_hidden);
+}
+
+static ssize_t target_tg_pt_gp_hidden_store(struct config_item *item,
+					    const char *page, size_t count)
+{
+	struct t10_alua_tg_pt_gp *tg_pt_gp = to_tg_pt_gp(item);
+	int tmp, ret;
+
+	ret = kstrtoint(page, 0, &tmp);
+	if (ret < 0) {
+		pr_err("Unable to extract hidden flag: %d\n", ret);
+		return ret;
+	}
+
+	if (tmp != 0 && tmp != 1) {
+		pr_err("Illegal value for hidden flag: %d\n", tmp);
+		return -EINVAL;
+	}
+	tg_pt_gp->tg_pt_gp_hidden = tmp;
+
+	return count;
+}
+
 static ssize_t target_tg_pt_gp_tg_pt_gp_id_show(struct config_item *item,
 		char *page)
 {
@@ -3115,6 +3142,7 @@ CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_standby);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_active_optimized);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_active_nonoptimized);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_write_metadata);
+CONFIGFS_ATTR(target_tg_pt_gp_, hidden);
 CONFIGFS_ATTR(target_tg_pt_gp_, nonop_delay_msecs);
 CONFIGFS_ATTR(target_tg_pt_gp_, trans_delay_msecs);
 CONFIGFS_ATTR(target_tg_pt_gp_, implicit_trans_secs);
@@ -3138,6 +3166,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_tg_pt_gp_attr_trans_delay_msecs,
 	&target_tg_pt_gp_attr_implicit_trans_secs,
 	&target_tg_pt_gp_attr_preferred,
+	&target_tg_pt_gp_attr_hidden,
 	&target_tg_pt_gp_attr_tg_pt_gp_id,
 	&target_tg_pt_gp_attr_members,
 	NULL,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c2b36f7d917d..f607ff74c368 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -297,6 +297,7 @@ struct t10_alua_tg_pt_gp {
 	int	tg_pt_gp_trans_delay_msecs;
 	int	tg_pt_gp_implicit_trans_secs;
 	int	tg_pt_gp_pref;
+	int	tg_pt_gp_hidden;
 	int	tg_pt_gp_write_metadata;
 	u32	tg_pt_gp_members;
 	int	tg_pt_gp_alua_access_state;
-- 
2.25.1

