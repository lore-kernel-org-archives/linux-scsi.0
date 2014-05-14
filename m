From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/2] target: Fix a comment in emulate_evpd_86
Date: Wed, 14 May 2014 15:48:07 -0700
Message-ID: <1400107687-15797-2-git-send-email-agrover@redhat.com>
References: <1400107687-15797-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbaENWsJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2014 18:48:09 -0400
In-Reply-To: <1400107687-15797-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Fix comment to make it clear that check_dev_wce can return true if
emulation is in use, but also if it's *not* emulated but the underlying
device supports it.

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 8653666..bda3a898 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -494,7 +494,7 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	/* Set HEADSUP, ORDSUP, SIMPSUP */
 	buf[5] = 0x07;
 
-	/* If WriteCache emulation is enabled, set V_SUP */
+	/* If WriteCache supported (or emulated), set V_SUP */
 	if (spc_check_dev_wce(dev))
 		buf[6] = 0x01;
 	/* If an LBA map is present set R_SUP */
-- 
1.9.0

