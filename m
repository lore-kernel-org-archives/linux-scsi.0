Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7969CC83007
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5512520775
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="UzTdCyhH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgD2Jpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:41 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39876 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbgD2Jpe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 74B6B4C859;
        Wed, 29 Apr 2020 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153530; x=1589967931; bh=OpZDLyZWuYbZHkAlrHKrFYeFeg3RDr59Gi4
        mNhrrOhM=; b=UzTdCyhHpRE//Y48Urv9erAib9ZrxUT9CfJ15OpEdE5mGh2sbmB
        /mU6k1RJ9jQ424cTyNn5Xf622Opyo7mpqzzcXPYKfojyM0Ok04XnNvk7GpoLv35G
        oOxjYQbBwcGTxw0n0C+XTLFaMC1UdZj/fn8gTkdnpN195dLquXe8koso=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1BaxELlrBC8U; Wed, 29 Apr 2020 12:45:30 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 60EDD4C852;
        Wed, 29 Apr 2020 12:45:28 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:29 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RFC PATCH 08/11] scsi: target/core: Add RTPI attribute for target port
Date:   Wed, 29 Apr 2020 12:44:41 +0300
Message-ID: <20200429094443.43937-9-r.bolshakov@yadro.com>
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
---
 drivers/target/target_core_tpg.c | 69 ++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 67474690720d..c0d564f17951 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -720,6 +720,75 @@ void core_tpg_remove_lun(
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
+	ret = mutex_lock_interruptible(&g_tpg_mutex);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
+		if (se_tpg != tpg && val == tpg->tpg_rtpi) {
+			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts"
+			       " with TARGET_CORE[%s]->TPG[%u]\n",
+			       se_tpg->se_tpg_tfo->fabric_name,
+			       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
+			       val,
+			       tpg->se_tpg_tfo->fabric_name,
+			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (se_tpg->tpg_rtpi != val) {
+		se_tpg->tpg_rtpi = val;
+		core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
+	}
+	ret = count;
+out:
+	mutex_unlock(&g_tpg_mutex);
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
2.26.1

