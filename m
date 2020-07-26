Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2D3C43460
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED2222070B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="U1WUnzB7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGZPfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:55 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.112]:41720 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727905AbgGZPfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777748; i=@ts.fujitsu.com;
        bh=RVa74JN/7E1sOtlG/xtrBRDEnUbmbOYmdPBQhTIohTc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=U1WUnzB72AnaqPqdMHxw88ON9q9oJM9gF4PSfz1GZtLp8dvfpmSrS37/GdFBqDneC
         GVkWDveo6F0olwBQKrPoPlFymSANmh5UMCpX1JQmpWyry9772vBTktYTT6zklnUSrU
         fyhZXs7DyI2i3URMlTEVM+yWq4ylNK6IstXEIIJ8FBSHuE3ZUkfrEh03wSep1EiDus
         MO8kkaLDmdd/2dxN1D5g0dUAwaSSRGSRAPvfmzO3XezSiJeN8Zwnv+UCEng0f8IqLz
         5ooWxD6W4dt0aygNsBEWogWa/WC4psKsOAW3fCsp3R5CTTsjwnan7rnI27dJtXPV2d
         /7kodfftZNT0w==
Received: from [100.113.7.116] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-central-1.aws.symcld.net id 29/07-32390-3D2AD1F5; Sun, 26 Jul 2020 15:35:47 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRWlGSWpSXmKPExsViZ8MRont5kWy
  8wcKHEhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjPP//zEV
  /BGpmPn2AWMD4yyhLkYuDiGByYwSaz99ZIJwpjNKPJ09h7GLkZODTcBAYsWk+ywgCRGBNYwSK
  +/MYwZJMAvoSUz7t469i5GDQ1jAS+LUJVOQMIuAqsTCWU/YQGxeATuJ6Wu+soDYEgLyEh0HJo
  PZnAL2EhvnfgAbIwRUs2zTAfYJjNwLGBlWMVomFWWmZ5TkJmbm6BoaGOgaGhrrmusaGhnqJVb
  pJumlluomp+aVFCUCZfUSy4v1iitzk3NS9PJSSzYxAgMlpZC9cgfj2jcf9A4xSnIwKYnyGkyR
  jRfiS8pPqcxILM6ILyrNSS0+xCjDwaEkwXt1IVBOsCg1PbUiLTMHGLQwaQkOHiUR3jkgad7ig
  sTc4sx0iNQpRkUpcd5+kIQASCKjNA+uDRYplxhlpYR5GRkYGIR4ClKLcjNLUOVfMYpzMCoJ81
  qBTOHJzCuBm/4KaDET0GL3S5Igi0sSEVJSDUze/dd38Hto8QdNK1/M6isceUjPRPOrnVz0pwq
  9RfffGp1Y/IjhXric7K1Tp2qmLVByOT/ZpuRvSXvyAd0AezPm61NkV2wr9+uztz1RuYrxoWTv
  HMatAhLTHrbMdJ0keezOvpM6Z49tYkpb8Xi9Rkzc/J2trp0hZZ4z2oO4jR6ll19Z+emlnbj5n
  0sHu/5Js1kkiHY+uWI58dYt86o72XNfrHdSPpLeedJNVuNC4ithDvfu9afD7Sry3y9VftbcHL
  pydmZ/nU9dne6OQ6mJ6wW0T8x3ev19Z/f59/sfSf2bm6W3oSXg7Gn+Bx+tFyjMNpVUb+99FmF
  vltB0dFWcXsd858fsp094CrP3/H3pG6fEUpyRaKjFXFScCACIPsLaDwMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-17.tower-248.messagelabs.com!1595777746!197365!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18185 invoked from network); 26 Jul 2020 15:35:47 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-17.tower-248.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:47 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZkD6021579;
        Sun, 26 Jul 2020 16:35:46 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 6292020720;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 8/8] scsi: target: tcmu: Make TMR notification optional
Date:   Sun, 26 Jul 2020 17:35:10 +0200
Message-Id: <20200726153510.13077-9-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
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
 drivers/target/target_core_user.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index cb5a561a46e8..9b7592350502 100644
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
 		tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
 
+	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags))
+		goto unlock;
+
 	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
 		 tcmu_tmr_type(tmf), udev->name, i, cmd_cnt);
 
@@ -2706,6 +2710,39 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_tmr_notification_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%i\n",
+			test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags));
+}
+
+static ssize_t tcmu_tmr_notification_store(struct config_item *item,
+					   const char *page, size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
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
+		set_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags);
+	else
+		clear_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags);
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, tmr_notification);
+
 static ssize_t tcmu_block_dev_show(struct config_item *item, char *page)
 {
 	struct se_device *se_dev = container_of(to_config_group(item),
@@ -2787,6 +2824,7 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
+	&tcmu_attr_tmr_notification,
 	&tcmu_attr_nl_reply_supported,
 	NULL,
 };
-- 
2.12.3

