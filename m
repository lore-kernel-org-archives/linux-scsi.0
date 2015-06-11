From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] bfa: fix leak of bfad_im_port_index on module unload
Date: Fri, 12 Jun 2015 01:50:45 +0300
Message-ID: <1434063045-17480-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

Resources allocated within bfad_im_port_index idr are not deallocated
on module unload. The patch adds idr_destroy() in exit function.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/bfa/bfad_im.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 7223b0006740..8367c11d554b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -851,6 +851,8 @@ bfad_im_module_exit(void)
 
 	if (bfad_im_scsi_vport_transport_template)
 		fc_release_transport(bfad_im_scsi_vport_transport_template);
+
+	idr_destroy(&bfad_im_port_index);
 }
 
 void
-- 
1.9.1
