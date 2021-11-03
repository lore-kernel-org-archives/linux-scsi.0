Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC04C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 21:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24ACC60F58
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 21:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhKCV11 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 17:27:27 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:56778 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCV10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 17:27:26 -0400
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id iNkVmLbELBazoiNkWmwzkt; Wed, 03 Nov 2021 22:24:48 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 03 Nov 2021 22:24:48 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: target: Save a few cycles in 'transport_lookup_[cmd|tmr]_lun()'
Date:   Wed,  3 Nov 2021 22:24:46 +0100
Message-Id: <e4a21bc607c39935cb98d4825cd63ba349820550.1635974637.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use 'percpu_ref_tryget_live_rcu()' instead of 'percpu_ref_tryget_live()' to
save a few cycles when it is known that the rcu lock is already
taken/released.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 44bb380e7390..bfd5d5606522 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -77,7 +77,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 
 		se_lun = rcu_dereference(deve->se_lun);
 
-		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
+		if (!percpu_ref_tryget_live_rcu(&se_lun->lun_ref)) {
 			se_lun = NULL;
 			goto out_unlock;
 		}
@@ -154,7 +154,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	if (deve) {
 		se_lun = rcu_dereference(deve->se_lun);
 
-		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
+		if (!percpu_ref_tryget_live_rcu(&se_lun->lun_ref)) {
 			se_lun = NULL;
 			goto out_unlock;
 		}
-- 
2.30.2

