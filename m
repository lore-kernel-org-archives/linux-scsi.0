From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/4] tgt: set the data length properly
Date: Sat,  1 Mar 2008 15:36:36 +0900
Message-ID: <1204353397-29855-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204353397-29855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204353397-29855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204353397-29855-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35758 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbYCAGha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Mar 2008 01:37:30 -0500
In-Reply-To: <1204353397-29855-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

scsi_tgt uses REQ_TYPE_BLOCK_PC so scsi_init_io doesn't set the length
for us. scsi_tgt needs to do it by itself.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_tgt_lib.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index b142514..a0f308b 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -381,6 +381,11 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 		scsi_release_buffers(cmd);
 		goto unmap_rq;
 	}
+	/*
+	 * we use REQ_TYPE_BLOCK_PC so scsi_init_io doesn't set the
+	 * length for us.
+	 */
+	cmd->sdb.length = rq->data_len;
 
 	return 0;
 
-- 
1.5.3.7

