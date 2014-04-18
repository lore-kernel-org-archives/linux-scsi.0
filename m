From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] [SCSI] bfa: allocate memory with GFP_ATOMIC in spinlock context
Date: Fri, 18 Apr 2014 00:25:49 -0700
Message-ID: <1397805949-20502-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:56847 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaDRH0J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2014 03:26:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

bfa_fcb_pbc_vport_create() is called only from bfa_fcs_pbc_vport_init(),
that is called only from bfad_drv_start() with bfad_lock spinlock held.
So the patch replaces GFP_KERNEL with GFP_ATOMIC to avoid
sleeping in atomic spinlock context.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/bfa/bfad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index cc0fbcdc5192..8f46d1b72fb8 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -652,7 +652,7 @@ bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 	unsigned long	flags;
 	struct completion fcomp;
 
-	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
 	if (!vport) {
 		rc = BFA_STATUS_ENOMEM;
 		goto ext;
-- 
1.8.3.2

