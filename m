Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F7FC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39FC02078B
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="caI1WKsI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGJKst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:48:49 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:36914 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgGJKsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=3Dr9L1Lw9/CiK8afeg4DStkBmBuyCm8ZavaSMzq71do=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=caI1WKsILvA8UuCEL7WDeZwVODMet2QPO/loiMf8+2G3iKhekarW6Z8eRdmRBiQKM
         mbFhgc1vkRbWEL8ub/45Yd3OFhCBsvPjT9z87ev854RIBYmmd10F5Ve9my981XPw6O
         IyhnwnKjPuWvxSPvMhdBcAhmz6UVAv+2P1ZmNlxdAWI8g4EiBM7g0KYGZgy+xQd4Ge
         lhRR3G5WtI4tpM8PzxSy0Oltr+Gcj9gFYoCzgvd9MrVNIx9yB0hKLAARGnJ6eJXAaJ
         A80MYU6+gDnozfU+qopo6y5wspTOr7C+/+5y8Bk59Olf9DJxxUZnJCaQG8jFdrZj3N
         PzUgvF6Ew/U3g==
Received: from [100.113.3.12] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id 22/81-55518-B87480F5; Fri, 10 Jul 2020 10:48:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MRqtvtzhF
  v8HyzjkX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE1Y9rX2ewF
  N3kr/sxcwt7A+Jm7i5GLQ0hgMqPEky9bmSCc6YwSm19+Zu1i5ORgEzCQWDHpPgtIQkRgDaPEy
  jvzmEESzAJ6EtP+rWMHsYUFnCWadnUwgtgsAqoSe5Y0g8V5BewkXi7bCzZIQkBeouPAZBYQm1
  PAXmJ/1z8wWwioZlffQ9YJjNwLGBlWMVomFWWmZ5TkJmbm6BoaGOgaGhrrGuoaGZvpJVbpJuq
  lluomp+aVFCUCZfUSy4v1iitzk3NS9PJSSzYxAkMlpZDxzQ7Gr68/6B1ilORgUhLlnfaRPV6I
  Lyk/pTIjsTgjvqg0J7X4EKMMB4eSBK+UG0e8kGBRanpqRVpmDjBsYdISHDxKIrzzXYDSvMUFi
  bnFmekQqVOMilLivP+cgRICIImM0jy4NlisXGKUlRLmZWRgYBDiKUgtys0sQZV/xSjOwagkzB
  sNsp0nM68EbvoroMVMQIuPcrCBLC5JREhJNTDN71Ko4Fh7aF9pSHU8C/ul8Dcf//uZBR477Jy
  9ydcx45O4onqT7hwe/oCYwrji+u+r7x036dWeVmR2PlV34sE0yad8nN8sL7DtkQnK+JH8SPfx
  THZ/uW3KF0uULjxpt5mb0WZVrde896drTNyRjZIfXMO39/7Q/zthQvKFb+o7fIo/3zrlferfO
  e+bB6wVpsr/yzx+Z/q1U2s0H/t/8Lp9etm3d1GNk1N3XTowh2feEW29qTczrk6WTstj18ieYS
  p60se6nUNBPNf5f16L7S6hidWcref8vOstVFdzhLvsLtqfI/824piMuqC54L+py/nucQezzln
  BFllztUSvNvlH6EzGApan8w8smVT7SEeJpTgj0VCLuag4EQB/LgCtEAMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-11.tower-228.messagelabs.com!1594378122!685817!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23786 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-11.tower-228.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmg5o025761;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 670AD204D1;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 3/8] scsi: target: tcmu: Use priv pointer in se_cmd
Date:   Fri, 10 Jul 2020 12:48:12 +0200
Message-Id: <20200710104817.19462-4-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
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

