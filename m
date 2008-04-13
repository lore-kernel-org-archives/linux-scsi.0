From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/4] iscsi_tcp: Enable large command
Date: Sun, 13 Apr 2008 19:41:18 +0300
Message-ID: <480237AE.4040101@panasas.com>
References: <47E92672.1040208@panasas.com> <48023526.5050709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56837 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbYDMQlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2008 12:41:50 -0400
In-Reply-To: <48023526.5050709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mike


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


