Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814A4C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EBB12065F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="IjhHMDL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbgF3Krm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:47:42 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.4]:6067 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732635AbgF3Krj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593514057; i=@ts.fujitsu.com;
        bh=GtsGqb8EjApcsskALx6PiG8OhUw/DlwarEoa/E44tAU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=IjhHMDL7/x+uIFud06b4n/kNDFziunr832czTHq2goLv64kMCTyT3IjDzGgbh5dto
         SXrvuUFoTYVSFD6y43NYhrQ7nZ5m8/5yYrQJQ82Y8Ns0iAis6Q5IJ+wh05d+NIDGq+
         Zpkp/L4yWOidYO1sS89QppDDNQ4oFro88JZjGpMMerBFq8r15gpQ5nA1rjwh3IKBC1
         2SKDl2eFY0uL6+9b9aW2sdPs538itSYfMpvs/cW+jek7aEjLL8sFp07g3+I0kLiezY
         /YnqODb0bDEmSgUyQNCPhHXA5290EEcHdq+PKZ5sR2klvmq4K2OIH06jluw7xGjPGU
         JNAOlUzWJPnlQ==
Received: from [100.113.1.80] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-central-1.aws.symcld.net id BE/F9-22706-8481BFE5; Tue, 30 Jun 2020 10:47:36 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MxRddD4ne
  cwdVr2hbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjI5vP9kL
  /otU3JlV0cA4WaiLkYtDSGAyo8SR+//YIZzpjBI3/x9l7WLk5GATMJBYMek+C0hCRGANo8TKO
  /OYQRLMAnoS0/6tYwexhQW8JU6/m8kEYrMIqErse3uGEcTmFbCTeDbpHViNhIC8RMeBySwgNq
  eAvcTaw6fBbCGgmrWbZ7JNYORewMiwitEiqSgzPaMkNzEzR9fQwEDX0NBY10jX1FAvsUo3US+
  1VDc5Na+kKBEoqZdYXqxXXJmbnJOil5dasokRGCYphUzGOxivvf6gd4hRkoNJSZT33r9fcUJ8
  SfkplRmJxRnxRaU5qcWHGGU4OJQkeJ+K/44TEixKTU+tSMvMAYYsTFqCg0dJhHc/SJq3uCAxt
  zgzHSJ1ilFRSpx3pRhQQgAkkVGaB9cGi5NLjLJSwryMDAwMQjwFqUW5mSWo8q8YxTkYlYR5E0
  DG82TmlcBNfwW0mAlo8TWtXyCLSxIRUlINTBbtT6oyzwnpfbdjvp669sVqfecfMxmXGkX9fc6
  qdK1jyRLnXFaOB+8+39vs/Iqb4apNgXGrQuA0+ydMGv6eu0LPTzM8weTw/vi8PWwnbwd5zenk
  6zzdNGGr5ZzTG2y9d7Lc3zWdcy7jF+4HjtXfNe0F/l1gXH5ULu64it1yJq38nJ/fN/NEJ4m/m
  vjspeAu9Qfhd7T7N/25sPHX1mkFEVKaPyflKShZe711O6nB5p6rKbfWPiaWZXl78c1zZh5/LE
  QjLEtelectnh8zSTnc906zSajp9s8bls16vNnubGiqqsCTlKBTSbuWeQv9OfVT42PUfEFdiV9
  clz26fATtVJ6wWHf5R0T6ruvYv+mIkRJLcUaioRZzUXEiAHG1/JwOAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-5.tower-226.messagelabs.com!1593514056!1004467!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 14680 invoked from network); 30 Jun 2020 10:47:36 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-5.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 10:47:36 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UAlYsT025927;
        Tue, 30 Jun 2020 11:47:35 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 9D25820251;
        Tue, 30 Jun 2020 12:47:35 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC PATCH 8/8] scsi: target: tcmu: Make TMR notification optional
Date:   Tue, 30 Jun 2020 12:47:09 +0200
Message-Id: <20200630104709.23066-9-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
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
index 8d69cfa125b2..1082c5882dc6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -118,6 +118,7 @@ struct tcmu_dev {
 #define TCMU_DEV_BIT_OPEN 0
 #define TCMU_DEV_BIT_BROKEN 1
 #define TCMU_DEV_BIT_BLOCKED 2
+#define TCMU_DEV_BIT_TMR_NOTIFY 3
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -1261,6 +1262,9 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 	if (unqueued)
 		tcmu_set_next_deadline(&dev->qfull_queue, &dev->qfull_timer);
 
+	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags))
+		goto unlock;
+
 	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
 		 tcmu_tmr_type(tmf), dev->name, i, cmd_cnt);
 
@@ -2707,6 +2711,40 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
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
@@ -2788,6 +2826,7 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
+	&tcmu_attr_tmr_notification,
 	&tcmu_attr_nl_reply_supported,
 	NULL,
 };
-- 
2.12.3

