From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH v2] [SCSI] bfa: allocate memory with GFP_ATOMIC in spinlock context
Date: Fri, 18 Apr 2014 00:58:42 -0700
Message-ID: <1397807922-21722-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

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
index cc0fbcdc5192..7593b7c1d336 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -507,7 +507,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
 	struct bfad_vport_s   *vport;
 	int rc;
 
-	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
 	if (!vport) {
 		bfa_trc(bfad, 0);
 		return;
-- 
1.8.3.2
