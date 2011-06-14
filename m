From: yxlraid@gmail.com
Subject: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Tue, 14 Jun 2011 23:17:08 +0800
Message-ID: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56260 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab1FNPRy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2011 11:17:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: James.Bottomley@suse.de, jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com

From: Xiangliang Yu <yuxiangl@marvell.com>

-- The value of child link rate should is minimum of link rate, or
   command will fail if child link rate is bigger than parent link rate.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/libsas/sas_expander.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 874e29d..6ccca09 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
 			sas_port_add_phy(port, phy->phy);
 		}
 	}
-	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
+	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);
 	child->pathways = min(child->pathways, parent->pathways);
 }
 
-- 
1.7.5.4

