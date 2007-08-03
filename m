From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc : lpfc_debugfs.c kmalloc + memset conversion to
	kzalloc
Date: Fri, 3 Aug 2007 16:14:59 +0000 (UTC)
Message-ID: <1186308017.2983.9.camel__29888.1924631589$1186157699$gmane$org@localhost.localdomain>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	 <200707312027.55149.m.kozlowski@tuxland.pl>  <46B34CA6.6010502@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49752 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbXHCQOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 12:14:48 -0400
In-Reply-To: <46B34CA6.6010502@emulex.com>
Date: Sun, 05 Aug 2007 06:00:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>

One more area, introduced by the lpfc 8.2.2 patches, that need the 
  kmalloc+memset conversion.

This patch to be applied atop the 8.2.2 patches.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>


diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2e3c01b..ef99e2b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -856,9 +856,9 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			goto debug_failed;
 		}
 		if (!phba->slow_ring_trc) {
-			phba->slow_ring_trc = kmalloc(
-				(sizeof(struct lpfc_debugfs_trc) *
-				lpfc_debugfs_max_slow_ring_trc),
+			phba->slow_ring_trc = kcalloc(
+				lpfc_debugfs_max_slow_ring_trc,
+				sizeof(struct lpfc_debugfs_trc),
 				GFP_KERNEL);
 			if (!phba->slow_ring_trc) {
 				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
@@ -867,9 +867,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				goto debug_failed;
 			}
 			atomic_set(&phba->slow_ring_trc_cnt, 0);
-			memset(phba->slow_ring_trc, 0,
-				(sizeof(struct lpfc_debugfs_trc) *
-				lpfc_debugfs_max_slow_ring_trc));
 		}
 	}
 


