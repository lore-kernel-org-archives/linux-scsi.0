From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] iscsi_tcp: Enable large commands
Date: Tue, 15 Apr 2008 15:37:01 +0300
Message-ID: <4804A16D.7000002@panasas.com>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <48049E8A.7030700@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11566 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758048AbYDOMiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2008 08:38:50 -0400
In-Reply-To: <48049E8A.7030700@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Alasdair G Kergon <agk@redhat.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>


Let through up to the largest command of 260 defined by the scsi standard.
iscsi core supports this already. Now that the scsi-ml supports it we can
start using large commands.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/iscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 555f4e3..6500192 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1859,7 +1859,7 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 	shost->max_lun = iscsi_max_lun;
 	shost->max_id = 0;
 	shost->max_channel = 0;
-	shost->max_cmd_len = 16;
+	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 	shost->can_queue = cmds_max;
 
 	if (iscsi_host_add(shost, NULL))
-- 
1.5.3.3


