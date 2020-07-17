Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22150C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F16C62076A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="PB0C8Z3q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGQQMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:35 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.3]:13165 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726715AbgGQQMe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595002351; i=@ts.fujitsu.com;
        bh=dZhFODA67iOeAY5hp0b1fuqO9uOJIOpZU4v8VMP7G3s=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=PB0C8Z3qNTg2TGIz1jNZ3yWbcVE/5yzTYPtfkISg712X/N7HzEblNovOHbYz568W9
         bhbP8sPLNonsjZienPKPwJ4hF3QNZ5JW2XgJzf7IF2hESYWvoXuVtqx5aDjPr21CpD
         0+rbE/Lj3hEqiqKrhulyDIxD77glWtr8TmxZgakoUdp34hBY5zKp3txy2j3MtthkEr
         XPK88Retm4aU93LY9UW4eBNStjTsd3RYnZO5HBd9oetXSQ5n+lXZfiiM/BZdpkAB7t
         gTawVJGtwcr8bH2Y7Ec7FiQYwrVN0RcuzQSE2atDNNUJ8Q5cbmAb4G5EVgc1Gbmp5X
         b2zo7jcnPRcYw==
Received: from [100.113.2.186] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-central-1.aws.symcld.net id C0/57-21639-EEDC11F5; Fri, 17 Jul 2020 16:12:30 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MRovvurGC
  8QXu/nEX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE14/9NmYL/
  IhUPlh1ibWCcLNTFyMUhJDCZUeLZubssEM50Rom/77cydTFycrAJGEismHQfLCEisIZRYuWde
  cwgCWYBPYlp/9axg9jCAl4Sb59tYu1i5OBgEVCV+H0nHiTMK2An0f5rJ1i5hIC8RMeBySwgNq
  eAvcTsbwcZQWwhoJoH694yT2DkXsDIsIrRMqkoMz2jJDcxM0fX0MBA19DQWBdIGhvoJVbpJuq
  lluomp+aVFCUCZfUSy4v1iitzk3NS9PJSSzYxAsMkpZChaQfju1cf9A4xSnIwKYnytq0SjBfi
  S8pPqcxILM6ILyrNSS0+xCjDwaEkwSt+CignWJSanlqRlpkDDFmYtAQHj5IIr/EZoDRvcUFib
  nFmOkTqFKOilDivGEhCACSRUZoH1waLk0uMslLCvIwMDAxCPAWpRbmZJajyrxjFORiVhHnDQK
  bwZOaVwE1/BbSYCWjxxs+8IItLEhFSUg1MMw4dnf/8943bTz6kTeiZIctZ8FKhqM1icU6qp7H
  UirV+lxbGndYyfWW6mmmufOpsMcbuldsCz53XVJw7W2377M9Hc6IEf1ou6Pp3R/oX48f/R1w0
  HOdYZt8L7tFpPPBVbpm2xap9k5Rb83V1n3QtCr/ZZLCxaXY3W8/Frotf7t/06N6SHXPt1ZtXR
  6XbxE4XnTmeWaR6u/iVeP4pTcWLC4M3mnka/M1eOafUfYO11zXnlUeeXZxpGluqselMhMCbYw
  fPMhmrmThNXsvv//PoJMbmDQ5nglvfLyr5ry2s1uZ92u7BYk/ZvntcyaGbJ++8pmcyqyUxas2
  ZoMXbNtSneax4kuYm37MituF6/5wTn5VYijMSDbWYi4oTAeVcYtQOAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-34.tower-232.messagelabs.com!1595002349!1121731!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18996 invoked from network); 17 Jul 2020 16:12:30 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-34.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jul 2020 16:12:30 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06HGCTom009897;
        Fri, 17 Jul 2020 17:12:29 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 37A6120918;
        Fri, 17 Jul 2020 18:12:21 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 8/8] scsi: target: tcmu: Make TMR notification optional
Date:   Fri, 17 Jul 2020 18:12:12 +0200
Message-Id: <20200717161212.10731-9-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add "tmr_notification" configFS attribute to tcmu devices.
If default value 0 of the attribute is used, tcmu only
removes aborted commands from qfull_queue.
If user changes tmr_notification to 1, additionally
TMR notifications will be written to the cmd ring.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 92b7a2e84e64..95e66b707373 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -118,6 +118,7 @@ struct tcmu_dev {
 #define TCMU_DEV_BIT_OPEN 0
 #define TCMU_DEV_BIT_BROKEN 1
 #define TCMU_DEV_BIT_BLOCKED 2
+#define TCMU_DEV_BIT_TMR_NOTIFY 3
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -1260,6 +1261,9 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 	if (unqueued)
 		tcmu_set_next_deadline(&dev->qfull_queue, &dev->qfull_timer);
 
+	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags))
+		goto unlock;
+
 	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
 		 tcmu_tmr_type(tmf), dev->name, i, cmd_cnt);
 
@@ -2706,6 +2710,40 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_tmr_notification_show(struct config_item *item,
+					     char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	struct tcmu_dev *dev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%i\n",
+			test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags));
+}
+
+static ssize_t tcmu_tmr_notification_store(struct config_item *item,
+					   const char *page, size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	struct tcmu_dev *dev = TCMU_DEV(da->da_dev);
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+	if (val > 1)
+		return -EINVAL;
+
+	if (val)
+		set_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags);
+	else
+		clear_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags);
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, tmr_notification);
+
 static ssize_t tcmu_block_dev_show(struct config_item *item, char *page)
 {
 	struct se_device *se_dev = container_of(to_config_group(item),
@@ -2787,6 +2825,7 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
+	&tcmu_attr_tmr_notification,
 	&tcmu_attr_nl_reply_supported,
 	NULL,
 };
-- 
2.12.3

