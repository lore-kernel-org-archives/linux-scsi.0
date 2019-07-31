From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bfa: remove redundant assignment to variable error
Date: Wed, 31 Jul 2019 23:11:52 +0100
Message-ID: <20190731221152.15304-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable error is being initialized with a value that is never read
and error is being re-assigned a little later on. The assignment is
redundant and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bfa/bfad_im.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index b2014cb96f58..22f06be2606f 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -536,7 +536,7 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 			struct device *dev)
 {
 	struct bfad_im_port_pointer *im_portp;
-	int error = 1;
+	int error;
 
 	mutex_lock(&bfad_mutex);
 	error = idr_alloc(&bfad_im_port_index, im_port, 0, 0, GFP_KERNEL);
-- 
2.20.1
