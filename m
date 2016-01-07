From: mchristi@redhat.com
Subject: [PATCH 1/1] scsi: add Synology to 1024 sector blacklist
Date: Thu,  7 Jan 2016 16:34:05 -0600
Message-ID: <1452206045-18332-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbcAGWeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jan 2016 17:34:08 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 2C009C001273
	for <linux-scsi@vger.kernel.org>; Thu,  7 Jan 2016 22:34:08 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

Another iscsi target that cannot handle large IOs,
but does not tell us a limit.

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
sectors for this target by adding it to the scsi blacklist. We do
not have good contacs with this vendors, so I have not been able to
try and fix on their side.

I have posted this a long while back, but it was not merged. This
version just fixes it up for merge/patch failures in the original
version.

Reported-by: Ancoron Luciferis <ancoron.luciferis@googlemail.com>
Reported-by: Michael Meyers <steltek@tcnnet.com>
Signed-off-by: Mike Christie <mchristi@redhat.com>

---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 2c1160c7..47b9d13 100644
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

