From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 5/6] drivers/scsi: Correct use after free
Date: Tue, 22 Dec 2009 21:32:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912222132080.28669@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754911AbZLVUcd@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@adaptec.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move the kfree after a reference to the freed structure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
identifier f;
iterator I;
statement S;
@@

*kfree(x);
... when != &x
    when != x = e
    when != I(x,...) S
*x->f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/dpt_i2o.c              |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 4967643..18c625c 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1229,12 +1229,13 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba)
 		}
 	}
 	pci_dev_put(pHba->pDev);
-	kfree(pHba);
 
 	if (adpt_sysfs_class)
 		device_destroy(adpt_sysfs_class,
 				MKDEV(DPTI_I2O_MAJOR, pHba->unit));
 
+	kfree(pHba);
+
 	if(hba_count <= 0){
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
 		if (adpt_sysfs_class) {
