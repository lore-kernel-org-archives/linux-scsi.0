From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 2/4] [SCSI] bfa: correct onstack wait_queue_head declaration
Date: Fri,  5 Feb 2010 21:52:38 +0800
Message-ID: <b47c0527f1471857fec4662da1bfd0bb9e6071a7.1265375697.git.yong.zhang0@gmail.com>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
 <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
In-Reply-To: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
References: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Jing Huang <huangj@brocade.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/bfa/bfad_im.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f788c2a..3299c7e 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -282,7 +282,7 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 	struct bfa_tskim_s *tskim;
 	struct bfad_itnim_s   *itnim;
 	struct bfa_itnim_s *bfa_itnim;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	int             rc = SUCCESS;
 	unsigned long   flags;
 	enum bfi_tskim_status task_status;
@@ -344,7 +344,7 @@ bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
 	struct bfad_itnim_s   *itnim;
 	unsigned long   flags;
 	u32        i, rc, err_cnt = 0;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	enum bfi_tskim_status task_status;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-- 
1.6.3.3
