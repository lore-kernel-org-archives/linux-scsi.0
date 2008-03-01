From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/4] tgt: stop zero'ing scsi_cmnd
Date: Sat,  1 Mar 2008 15:36:35 +0900
Message-ID: <1204353397-29855-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204353397-29855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204353397-29855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60813 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbYCAGha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Mar 2008 01:37:30 -0500
In-Reply-To: <1204353397-29855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

The scsi midlayer allocates scsi_cmnd->sense_buffer dynamically so we
can't initialize scsi_cmnd (the midlyaer does for us).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_tgt_lib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 3677fbb..b142514 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -103,7 +103,6 @@ struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *shost,
 	if (!cmd)
 		goto release_rq;
 
-	memset(cmd, 0, sizeof(*cmd));
 	cmd->sc_data_direction = data_dir;
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->request = rq;
-- 
1.5.3.7

