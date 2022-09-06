Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D949C6FA83
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 16:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiIFQR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbiIFQRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 12:17:20 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B6E72EF8;
        Tue,  6 Sep 2022 08:45:50 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B47AA448D0;
        Tue,  6 Sep 2022 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662479147; x=1664293548; bh=Pcssw7krtQTu4TVB36caMNq5b
        Tyaix+FwZotKVtTNeQ=; b=QFQiqMlQsWAAtLZteZds9ae8VYdCkQwKjYkVCKpOm
        0oIBpbsdmtaFBuJ37xV2dUMYSKUclfwzB8aPlndPVuR3tf7amVHRydiLFAdQsLyU
        N2XBVcMouYIlaq6uKRaTzqLrK3zSQxHmII7mLy5PLz5uOdIeknGZ2EVOcPs0niGA
        6E=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9trHGoVlEN2c; Tue,  6 Sep 2022 18:45:47 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 462DD4471D;
        Tue,  6 Sep 2022 18:45:43 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 6 Sep 2022 18:45:43 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 6 Sep 2022 18:45:42 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 6/7] scsi: target: core: Add RTPI attribute for target port
Date:   Tue, 6 Sep 2022 18:45:18 +0300
Message-ID: <20220906154519.27487-7-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906154519.27487-1-d.bogdanov@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

RELATIVE TARGET PORT IDENTIFIER can be read and configured via configfs:
$ echo 0x10 > $TARGET/tpgt_N/attrib/rtpi

RTPI has to be unique among all target ports, otherwise the write fails.

Configuration of a new RTPI value triggers INQUIRY DATA HAS CHANGED unit
attention as defined in SPC-4 "6.6.1 INQUIRY command introduction":

> If INQUIRY data changes for any reason, the device server shall
> establish a unit attention condition for the initiator port associated
> with every I_T nexus (see SAM-5), with the additional sense code set to
> INQUIRY DATA HAS CHANGED.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_tpg.c | 70 ++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index b359c83a99c6..85c9473a38fd 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -715,6 +715,76 @@ void core_tpg_remove_lun(
 	percpu_ref_exit(&lun->lun_ref);
 }
 
+/* Set a Unit Attention on all I_T nexuses related to the port */
+static void core_tpg_ua(struct se_portal_group *se_tpg, u8 asc, u8 ascq)
+{
+	struct se_lun *lun;
+	struct se_dev_entry *se_deve;
+
+	mutex_lock(&se_tpg->tpg_lun_mutex);
+	hlist_for_each_entry_rcu(lun, &se_tpg->tpg_lun_hlist, link) {
+		spin_lock(&lun->lun_deve_lock);
+		list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link)
+			core_scsi3_ua_allocate(se_deve, asc, ascq);
+		spin_unlock(&lun->lun_deve_lock);
+	}
+	mutex_unlock(&se_tpg->tpg_lun_mutex);
+}
+
+static ssize_t core_tpg_rtpi_show(struct config_item *item, char *page)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+
+	return sprintf(page, "%#x\n", se_tpg->tpg_rtpi);
+}
+
+static ssize_t core_tpg_rtpi_store(struct config_item *item,
+				   const char *page, size_t count)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+	struct se_portal_group *tpg;
+	bool rtpi_changed = false;
+	u16 val;
+	int ret;
+
+	ret = kstrtou16(page, 0, &val);
+	if (ret < 0)
+		return ret;
+	if (val == 0)
+		return -EINVAL;
+
+	/* RTPI shouldn't conflict with values of existing ports */
+	spin_lock(&g_tpg_lock);
+
+	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
+		if (se_tpg != tpg && val == tpg->tpg_rtpi) {
+			spin_unlock(&g_tpg_lock);
+			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
+			       se_tpg->se_tpg_tfo->fabric_name,
+			       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
+			       val,
+			       tpg->se_tpg_tfo->fabric_name,
+			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
+			return -EINVAL;
+		}
+	}
+
+	if (se_tpg->tpg_rtpi != val) {
+		se_tpg->tpg_rtpi = val;
+		rtpi_changed = true;
+	}
+	spin_unlock(&g_tpg_lock);
+
+	if (rtpi_changed)
+		core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
+	ret = count;
+
+	return ret;
+}
+
+CONFIGFS_ATTR(core_tpg_, rtpi);
+
 struct configfs_attribute *core_tpg_attrib_attrs[] = {
+	&core_tpg_attr_rtpi,
 	NULL,
 };
-- 
2.25.1

