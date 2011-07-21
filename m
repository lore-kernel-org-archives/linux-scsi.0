From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 012/103] tcm_loop: off by one in tcm_loop_make_naa_tpg()
Date: Thu, 21 Jul 2011 00:04:48 -0700
Message-ID: <1311231979-6631-13-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.150]:24839 "HELO
	nm5-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003Ab1GUHAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:00:21 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Dan Carpenter <error27@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Dan Carpenter <error27@gmail.com>

This is an off by one 'tgpt' check in tcm_loop_make_naa_tpg() that could result
in memory corruption.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3274fec..26e3681 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1230,7 +1230,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 	tpgt_str += 5; /* Skip ahead of "tpgt_" */
 	tpgt = (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
 
-	if (tpgt > TL_TPGS_PER_HBA) {
+	if (tpgt >= TL_TPGS_PER_HBA) {
 		printk(KERN_ERR "Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
 				" %u\n", tpgt, TL_TPGS_PER_HBA);
 		return ERR_PTR(-EINVAL);
-- 
1.7.6

