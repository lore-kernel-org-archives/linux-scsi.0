From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi: add Synology to 1024 sector blacklist
Date: Fri, 22 May 2015 14:22:52 -0500
Message-ID: <1432322572-5879-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57229 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbbEVTXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2015 15:23:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Another day another iSCSI target that cannot handle large IOs.
The Synology iSCSI targets report:

Block limits VPD page (SBC):
  Write same no zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 0 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 0 blocks
  Maximum prefetch length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks

and the size of the command it can handle seems to depend on how much
memory it can allocate at the time. This results in IO errors when
handling large IOs. This patch just has us use the old 1024 default
sectors for this target by adding it to the scsi blacklist.

Reported-by: Ancoron Luciferis <ancoron.luciferis@googlemail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 848c7ca..d2a8bdf 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -227,6 +227,7 @@ static struct {
 	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024}, 
+	{"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
 	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
-- 
1.8.3.1

