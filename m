Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71B8C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 09:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82CD64ED7
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 09:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhBTJmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 04:42:00 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:31951 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhBTJle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 04:41:34 -0500
Received: from localhost.localdomain ([90.126.17.6])
        by mwinf5d81 with ME
        id XMfs2400107rLVE03MfsbN; Sat, 20 Feb 2021 10:39:52 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 20 Feb 2021 10:39:52 +0100
X-ME-IP: 90.126.17.6
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: mpt3sas: Do not use GFP_KERNEL in atomic context
Date:   Sat, 20 Feb 2021 10:39:51 +0100
Message-Id: <20210220093951.905362-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'mpt3sas_get_port_by_id()' can be called when a spinlock is hold. So use
GFP_ATOMIC instead of GFP_KERNEL when allocating memory.

Issue spotted by call_kern.cocci:
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 7125 inside lock on line 7123 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 6842 inside lock on line 6839 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 6854 inside lock on line 6851 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 7706 inside lock on line 7702 but uses GFP_KERNEL
./drivers/scsi/mpt3sas/mpt3sas_scsih.c:416:42-52: ERROR: function mpt3sas_get_port_by_id called on line 10260 inside lock on line 10256 but uses GFP_KERNEL

Fixes: 324c122fc0a4 ("scsi: mpt3sas: Add module parameter multipath_on_hba")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ffca03064797..6aa6de729187 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -413,7 +413,7 @@ mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc,
 	 * And add this object to port_table_list.
 	 */
 	if (!ioc->multipath_on_hba) {
-		port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
+		port = kzalloc(sizeof(struct hba_port), GFP_ATOMIC);
 		if (!port)
 			return NULL;
 
-- 
2.27.0

