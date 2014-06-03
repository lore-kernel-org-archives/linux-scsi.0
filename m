From: =?UTF-8?q?Cl=C3=A9ment=20Calmels?= <clement.calmels@free.fr>
Subject: [PATCH] sd: bad return code of init_sd
Date: Tue,  3 Jun 2014 23:34:25 +0200
Message-ID: <1401831265-8547-1-git-send-email-clement.calmels@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In init_sd function, if kmem_cache_create or mempool_create_slab_pools
calls fail, the error will not be correclty reported because
class_register previously set the value of err to 0.

Signed-off-by: Cl=C3=A9ment Calmels <clement.calmels@free.fr>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e9689d5..7daa2aa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3205,12 +3205,14 @@ static int __init init_sd(void)
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
 		printk(KERN_ERR "sd: can't init extended cdb cache\n");
+		err =3D -ENOMEM;
 		goto err_out_class;
 	}
=20
 	sd_cdb_pool =3D mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cach=
e);
 	if (!sd_cdb_pool) {
 		printk(KERN_ERR "sd: can't init extended cdb pool\n");
+		err =3D -ENOMEM;
 		goto err_out_cache;
 	}
=20
--=20
2.0.0
