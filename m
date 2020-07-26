Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE0BC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED5612070B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="UJJe4taX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgGZPfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:51 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.5]:61357 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbgGZPfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777747; i=@ts.fujitsu.com;
        bh=3Dr9L1Lw9/CiK8afeg4DStkBmBuyCm8ZavaSMzq71do=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=UJJe4taXnXxBZkeqNJ+TWOiymOO3zGToK1y5BeXzwLe03SsZQAqwVYsn+Mja5BbBO
         ZXyY8kmLj7XXc0mT3SP6L3U0jd+c3yfmuy27z3N25WerQ2JMLkEraZAUdjLC50B+ef
         HTq6+FGWwcioRuV1v9f9gAHzmz+1K0AqN4gkmRIyoy12UNlcKpcFl7YMLxdepWnlyS
         U0F3scEuP9DaUz8sLJyJpofQoo4y3AWc1XdCKyJf01Os1xiJ/UFiHVpDWv1u4Ih8yP
         pFLBwswHUl8mYhVaeZhUcqtRp/7U2OIwD5mbkpd+1tA1mAClRTM8pG18EFAvq6WXSI
         4VN8Mruggu5vg==
Received: from [100.112.192.107] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.eu-west-1.aws.symcld.net id 69/7D-15309-3D2AD1F5; Sun, 26 Jul 2020 15:35:47 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRWlGSWpSXmKPExsViZ8MRqntpkWy
  8QdtzG4vu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxrSvs9kL
  bvJW/Jm5hL2B8TN3FyMXh5DAZEaJxbNvMEM40xkljuzsZupi5ORgEzCQWDHpPgtIQkRgDaPEy
  jvzmEESzAJ6EtP+rWMHsYUF3CQeL9zBCGKzCKhKfHo2A6yZV8BO4v2qn2A1EgLyEh0HJrOA2J
  wC9hIb534AmyMEVLNs0wH2CYzcCxgZVjFaJBVlpmeU5CZm5ugaGhjoGhoa6RpaGukaGZjoJVb
  pJuqlluqWpxaX6BrqJZYX6xVX5ibnpOjlpZZsYgQGSkrBgTM7GE+9/qB3iFGSg0lJlNdgimy8
  EF9SfkplRmJxRnxRaU5q8SFGGQ4OJQneqwuBcoJFqempFWmZOcCghUlLcPAoifDOAUnzFhck5
  hZnpkOkTjEqSonz9oMkBEASGaV5cG2wSLnEKCslzMvIwMAgxFOQWpSbWYIq/4pRnINRSZjXCm
  QKT2ZeCdz0V0CLmYAWu1+SBFlckoiQkmpg0mhe9+PMsjjxFjYZIankenXd2uaMxtnpC/omvdr
  9jUMi/Ez1GQ/n70/zwre6/94Zbc7N09c4RyCMY9OH8ByppFa2/N3njZI4Fp+Yz/b5TkWgvau5
  1pl8nupehh13NV5Ou/Tlgd4z1lPenx/ETvVs4ap01/c551OeufTvoqAGrkVHJ2t89o55YSWif
  e7ch7KCWad7p7GyG8lcyYgqSczm81nf5/q/x6j2fosKm8SMFbVODx9vNs355M1+5PpCuRiWFz
  MfGmjEKW/VYn42q1GRz26GzamwrIoVNptEp88LfvWTv5T5Uuf+i7/nTNt88nmW0hL7nskLcmW
  nLoncFxRRvCe3+hDb4wWXt9/LbHquxFKckWioxVxUnAgAuRlB0Q8DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-7.tower-271.messagelabs.com!1595777746!220568!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5383 invoked from network); 26 Jul 2020 15:35:46 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-7.tower-271.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:46 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZdE5006422;
        Sun, 26 Jul 2020 16:35:40 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 411802062A;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 3/8] scsi: target: tcmu: Use priv pointer in se_cmd
Date:   Sun, 26 Jul 2020 17:35:05 +0200
Message-Id: <20200726153510.13077-4-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We initialize and clean up the se_cmd's priv pointer
under cmd_ring_lock to point to the corresponding tcmu_cmd.

In the patch that implements tmr_notify callback in
tcmu we will use the priv pointer.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 366878b0b2fd..b06b18d1b135 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -541,6 +541,8 @@ tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 {
+	if (tcmu_cmd->se_cmd)
+		tcmu_cmd->se_cmd->priv = NULL;
 	kfree(tcmu_cmd->dbi);
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
@@ -1109,10 +1111,11 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	mutex_lock(&udev->cmdr_lock);
+	se_cmd->priv = tcmu_cmd;
 	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
-	mutex_unlock(&udev->cmdr_lock);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
+	mutex_unlock(&udev->cmdr_lock);
 	return scsi_ret;
 }
 
@@ -1179,7 +1182,6 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
 out:
-	cmd->se_cmd = NULL;
 	tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
 	tcmu_free_cmd(cmd);
 }
@@ -1285,6 +1287,7 @@ static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
 	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
 	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
+	se_cmd->priv = NULL;
 	cmd->se_cmd = NULL;
 
 	pr_debug("Timing out inflight cmd %u on dev %s.\n",
-- 
2.12.3

