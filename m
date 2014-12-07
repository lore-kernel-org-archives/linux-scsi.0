From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 9/20] drivers/scsi: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:51 +0100
Message-ID: <1417980062-25151-10-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replace a misspelled function name by %s and then __func__.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/scsi/atp870u.c   |   10 +++++-----
 drivers/scsi/imm.c       |    2 +-
 drivers/scsi/initio.c    |    2 +-
 drivers/scsi/ncr53c8xx.c |    3 ++-
 drivers/scsi/ppa.c       |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e5dae7b..85fd163 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -1034,7 +1034,7 @@ static int initio_bad_seq(struct initio_host * host)
 {
 	struct scsi_ctrl_blk *scb;
 
-	printk("initio_bad_seg c=%d\n", host->index);
+	printk("%s c=%d\n", __func__, host->index);
 
 	if ((scb = host->active) != NULL) {
 		initio_unlink_busy_scb(host, scb);
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 5b93ed8..347fb49 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -772,7 +772,8 @@ static int __init sym53c8xx__setup(char *str)
 			break;
 #endif
 		default:
-			printk("sym53c8xx_setup: unexpected boot option '%.*s' ignored\n", (int)(pc-cur+1), cur);
+			printk("%s: unexpected boot option '%.*s' ignored\n",
+			       __func__, (int)(pc-cur+1), cur);
 			break;
 		}
 
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 1db8b26..4c1f08e 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -365,7 +365,7 @@ static int ppa_in(ppa_struct *dev, char *buffer, int len)
 		break;
 
 	default:
-		printk(KERN_ERR "PPA: bug in ppa_ins()\n");
+		printk(KERN_ERR "PPA: bug in %s()\n", __func__);
 		r = 0;
 		break;
 	}
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a795d81..ebb4556 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3016,12 +3016,12 @@ flash_ok_885:
 			goto scsi_add_fail;
 		scsi_scan_host(shpnt);
 #ifdef ED_DBGP			
-		printk("atp870u_prob : exit\n");
+		printk("%s : exit\n", __func__);
 #endif		
 		return 0;
 
 scsi_add_fail:
-	printk("atp870u_prob:scsi_add_fail\n");
+	printk("%s:scsi_add_fail\n", __func__);
 	if(ent->device==ATP885_DEVID) {
 		release_region(base_io, 0xff);
 	} else if((ent->device==ATP880_DEVID1)||(ent->device==ATP880_DEVID2)) {
@@ -3030,13 +3030,13 @@ scsi_add_fail:
 		release_region(base_io, 0x40);
 	}
 request_io_fail:
-	printk("atp870u_prob:request_io_fail\n");
+	printk("%s:request_io_fail\n", __func__);
 	free_irq(pdev->irq, shpnt);
 free_tables:
-	printk("atp870u_prob:free_table\n");
+	printk("%s:free_table\n", __func__);
 	atp870u_free_tables(shpnt);
 unregister:
-	printk("atp870u_prob:unregister\n");
+	printk("%s:unregister\n", __func__);
 	scsi_host_put(shpnt);
 	return -1;		
 err_eio:
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 89a8266..1f2a668 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -439,7 +439,7 @@ static int imm_in(imm_struct *dev, char *buffer, int len)
 		break;
 
 	default:
-		printk("IMM: bug in imm_ins()\n");
+		printk("IMM: bug in %s()\n", __func__);
 		r = 0;
 		break;
 	}
