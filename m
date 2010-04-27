From: akpm@linux-foundation.org
Subject: [patch 19/28] scsi: bfa: correct onstack wait_queue_head declaration
Date: Tue, 27 Apr 2010 14:23:02 -0700
Message-ID: <201004272123.o3RLN231020835@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757159Ab0D0VaS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:30:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, yong.zhang0@gmail.com, James.Bottomley@suse.de, huangj@Brocade.COM, roel.kluin@gmail.com

From: Yong Zhang <yong.zhang0@gmail.com>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Jing Huang <huangj@brocade.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfad_im.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/bfa/bfad_im.c~scsi-bfa-correct-onstack-wait_queue_head-declaration drivers/scsi/bfa/bfad_im.c
--- a/drivers/scsi/bfa/bfad_im.c~scsi-bfa-correct-onstack-wait_queue_head-declaration
+++ a/drivers/scsi/bfa/bfad_im.c
@@ -291,7 +291,7 @@ bfad_im_reset_lun_handler(struct scsi_cm
 	struct bfa_tskim_s *tskim;
 	struct bfad_itnim_s   *itnim;
 	struct bfa_itnim_s *bfa_itnim;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	int             rc = SUCCESS;
 	unsigned long   flags;
 	enum bfi_tskim_status task_status;
@@ -353,7 +353,7 @@ bfad_im_reset_bus_handler(struct scsi_cm
 	struct bfad_itnim_s   *itnim;
 	unsigned long   flags;
 	u32        i, rc, err_cnt = 0;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	enum bfi_tskim_status task_status;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
_
