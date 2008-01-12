From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] libsas: fix sense_buffer overrun
Date: Sun, 13 Jan 2008 02:20:18 +0900
Message-ID: <20080113022015S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44951 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbYALRU2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jan 2008 12:20:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b784089..828fed1 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -108,7 +108,7 @@ static void sas_scsi_task_done(struct sas_task *task)
 			break;
 		case SAM_CHECK_COND:
 			memcpy(sc->sense_buffer, ts->buf,
-			       max(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
+			       min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
 			stat = SAM_CHECK_COND;
 			break;
 		default:
-- 
1.5.3.4

