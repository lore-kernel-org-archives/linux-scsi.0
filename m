Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9EDC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C4D620748
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Be0AWo0w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgGJKtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:49:18 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:33147 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgGJKss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=jQy4nY8Tj9Q0u5Df6KSJFBCCOS8urVh+KpkBLHKQs5s=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=Be0AWo0wCFmX9yzU5TqsTUxxEQpYsMr5XiUUyc9LOYZQTm3jK9dF7eu5yLwjnGa4g
         HaW7uvQW3klU6cNYxZmYpxRt9KJXE28eYXnarQAs2FfHP9t3lcKqeh9PH96mnXrnHY
         v7SLEjYw1SH3xSBzSj6/p39LTZ8m/MdVkWZvYX5dr/HNXiZF3pdwfL648BmYQUvvk9
         HTlFrsmgrvYWLWu05G45yExHibQv7bRJwNDn6T789WnNMAK8nX8clzmjnCH0ZUoN62
         fHUeOYoYWXtpHxptMfIK8wynniV2CjMwAkNHAyvJjeD/uArQi69qQg9ZWlCmAQt3O9
         cF2PAXVwk74iA==
Received: from [100.113.3.12] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id 03/2C-07993-C87480F5; Fri, 10 Jul 2020 10:48:44 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MRqtvjzhF
  v0DyF1aL7+g42i+XH/zFZ/J10g9WidelbJgcWj49Pb7F4fN4kF8AUxZqZl5RfkcCa0fq+k7ng
  v0hF48yzTA2Mk4W6GLk4hAQmM0q8X3aYCcKZzigx+cxRIIeTg03AQGLFpPssIAkRgTWMEivvz
  GMGSTAL6ElM+7eOHcQWFnCXuLTnKQuIzSKgKrH6cysriM0rYCfx7cNJsEESAvISHQcmg9VwCt
  hL7O/6B2YLAdXs6nvIOoGRewEjwypGy6SizPSMktzEzBxdQwMDXUNDY11DXSMDc73EKt1EvdR
  S3eTUvJKiRKCsXmJ5sV5xZW5yTopeXmrJJkZgqKQUMp7fwTj1zQe9Q4ySHExKorzTPrLHC/El
  5adUZiQWZ8QXleakFh9ilOHgUJLglXLjiBcSLEpNT61Iy8wBhi1MWoKDR0mEd74LUJq3uCAxt
  zgzHSJ1ilFRSpz3nzNQQgAkkVGaB9cGi5VLjLJSwryMDAwMQjwFqUW5mSWo8q8YxTkYlYAqXI
  Gm8GTmlcBNfwW0mAlo8VEONpDFJYkIKakGJq/3O++8eqTwxFKGJdU/6936vpr4rrqdFYdUjd9
  8/BvjevPBq9Ll5UozohZ2iLTv49xiVlDOo9jm8fb0hm3eWTmT3nccZ5ho/sjTZv0Wf8naLypp
  7wMZjm2o2cjT82NV1KrrbE0HlAL+nvBhy3t17fWzcCFT75h1v1d5PtLLMTxYeNJ13db9bSsk5
  /w31Fu/7Na/Kds2bwnMb2taavLoaYDAXGvhiYkfdu9cuMY4YOrJh7ylHrG745pVn+R+rr0pYu
  ujK19eFhJ2PO6mwPE/j3Pv73qQef13gfKfsrmflPkM0hSilu2+G7F1/oYeyx1fXtyZ1rxMaqm
  3Xnfkmgt2XJGbdM/+X3eE2flYWP+HpRFKLMUZiYZazEXFiQBp05apEAMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-5.tower-226.messagelabs.com!1594378123!1882140!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 14734 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-5.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmghE025788;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 9CFAE208F4;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 8/8] scsi: target: tcmu: Make TMR notification optional
Date:   Fri, 10 Jul 2020 12:48:17 +0200
Message-Id: <20200710104817.19462-9-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
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
index e864706de977..a8294f525124 100644
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

