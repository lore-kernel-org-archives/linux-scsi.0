Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18EBC83004
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEDF92083B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="RAOGpK5g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgD2Jpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:33 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39818 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbgD2Jpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 64E7D4C84A;
        Wed, 29 Apr 2020 09:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153525; x=1589967926; bh=v6yhXlmMHe26RUddvzkCQo4XwKzPLNddnmx
        yDZ8ycNc=; b=RAOGpK5gGTUhavuzoFwEgFla2FXIM39wkR2hAqvV9wO6Fupmf3S
        5sc/0tCL1OEvwKoTwBPWaAPMPuagUo6q6tO0SM07Jwq+1UlddJozn5kdA9F2Zy/u
        36y7Yjou5oZltzRIlCm/VExoJRV8/PmJ3zCHW+fWvXtv6bJsjPgMRPlQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E44eh2qQMZ1v; Wed, 29 Apr 2020 12:45:25 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 08FFA4C84B;
        Wed, 29 Apr 2020 12:45:25 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:26 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RFC PATCH 01/11] scsi: target/core: Add a way to hide a port group
Date:   Wed, 29 Apr 2020 12:44:34 +0300
Message-ID: <20200429094443.43937-2-r.bolshakov@yadro.com>
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

Default target port group is always returned in the list of port groups,
even if the behaviour is unwanted, i.e. it has no members and
non-default port groups are primary port groups.

A new port group attribute - "hidden" can be used to hide empty port
groups with no ports in REPORT TARGET PORT GROUPS, including default
target port group:

  echo 1 > $DEVICE/alua/default_tg_pt_gp/hidden

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_alua.c     |  9 +++++++++
 drivers/target/target_core_configfs.c | 29 +++++++++++++++++++++++++++
 include/target/target_core_base.h     |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 385e4cf9cfa6..b98a5b5fce49 100644
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
@@ -308,6 +310,13 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
+	if (l_tg_pt_gp->tg_pt_gp_hidden && !tg_pt_gp->tg_pt_gp_members) {
+		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		pr_err("Unable to change state for hidden port group"
+		       " with no members\n");
+		rc = TCM_INVALID_CDB_FIELD;
+		goto out;
+	}
 	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
 	spin_unlock(&l_lun->lun_tg_pt_gp_lock);
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ff82b21fdcce..42390ce9d4db 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2908,6 +2908,33 @@ static ssize_t target_tg_pt_gp_preferred_store(struct config_item *item,
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
@@ -2996,6 +3023,7 @@ CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_standby);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_active_optimized);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_active_nonoptimized);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_write_metadata);
+CONFIGFS_ATTR(target_tg_pt_gp_, hidden);
 CONFIGFS_ATTR(target_tg_pt_gp_, nonop_delay_msecs);
 CONFIGFS_ATTR(target_tg_pt_gp_, trans_delay_msecs);
 CONFIGFS_ATTR(target_tg_pt_gp_, implicit_trans_secs);
@@ -3019,6 +3047,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_tg_pt_gp_attr_trans_delay_msecs,
 	&target_tg_pt_gp_attr_implicit_trans_secs,
 	&target_tg_pt_gp_attr_preferred,
+	&target_tg_pt_gp_attr_hidden,
 	&target_tg_pt_gp_attr_tg_pt_gp_id,
 	&target_tg_pt_gp_attr_members,
 	NULL,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6d4a694f6ea7..922b3086e408 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -292,6 +292,7 @@ struct t10_alua_tg_pt_gp {
 	int	tg_pt_gp_trans_delay_msecs;
 	int	tg_pt_gp_implicit_trans_secs;
 	int	tg_pt_gp_pref;
+	int	tg_pt_gp_hidden;
 	int	tg_pt_gp_write_metadata;
 	u32	tg_pt_gp_members;
 	int	tg_pt_gp_alua_access_state;
-- 
2.26.1

