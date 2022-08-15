Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B02C25B0F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 04:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiHPE5D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 00:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiHPE4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 00:56:24 -0400
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CCE80B51
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 13:52:28 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id Nh4To0e9HTLjwNh4TowhXt; Mon, 15 Aug 2022 22:52:26 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 15 Aug 2022 22:52:26 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     michael.christie@oracle.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v2] scsi: target: Save a few cycles in transport_lookup_[cmd|tmr]_lun()
Date:   Mon, 15 Aug 2022 22:52:24 +0200
Message-Id: <03705222390bfa3b48ad7658f693fc0fc030b3ae.1660596679.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use percpu_ref_tryget_live_rcu() instead of percpu_ref_tryget_live() to
save a few cycles when it is known that the rcu lock is already
taken/released.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Change in v2:
  * sync with -next

v1:
  * https://lore.kernel.org/all/e4a21bc607c39935cb98d4825cd63ba349820550.1635974637.git.christophe.jaillet@wanadoo.fr/
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b7f16ee8aa0e..76c6613a1da7 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -77,7 +77,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 
 		se_lun = deve->se_lun;
 
-		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
+		if (!percpu_ref_tryget_live_rcu(&se_lun->lun_ref)) {
 			se_lun = NULL;
 			goto out_unlock;
 		}
@@ -154,7 +154,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	if (deve) {
 		se_lun = deve->se_lun;
 
-		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
+		if (!percpu_ref_tryget_live_rcu(&se_lun->lun_ref)) {
 			se_lun = NULL;
 			goto out_unlock;
 		}
-- 
2.34.1

