From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] SCSI-debug: Less function calls in scsi_debug_init()
 after error detection
Date: Fri, 06 Feb 2015 18:25:27 +0100
Message-ID: <54D4F907.3040205@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54D4F7DF.8070008@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D4F7DF.8070008@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 6 Feb 2015 17:48:34 +0100

The vfree() function was called in two cases by the scsi_debug_init() function
during error handling even if the passed variables "dif_storep" and
"map_storep" contained null pointers eventually.

This implementation detail could be improved by the introduction of two
jump labels.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/scsi_debug.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9e4add7..756b7be 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4887,7 +4887,7 @@ static int __init scsi_debug_init(void)
 		if (dif_storep == NULL) {
 			pr_err("%s: out of mem. (DIX)\n", __func__);
 			ret = -ENOMEM;
-			goto free_vm;
+			goto free_fake;
 		}
 
 		memset(dif_storep, 0xff, dif_size);
@@ -4920,7 +4920,7 @@ static int __init scsi_debug_init(void)
 		if (map_storep == NULL) {
 			pr_err("%s: out of mem. (MAP)\n", __func__);
 			ret = -ENOMEM;
-			goto free_vm;
+			goto free_dif;
 		}
 
 		bitmap_zero(map_storep, map_size);
@@ -4934,7 +4934,7 @@ static int __init scsi_debug_init(void)
 	if (IS_ERR(pseudo_primary)) {
 		pr_warn("%s: root_device_register() error\n", __func__);
 		ret = PTR_ERR(pseudo_primary);
-		goto free_vm;
+		goto free_map;
 	}
 	ret = bus_register(&pseudo_lld_bus);
 	if (ret < 0) {
@@ -4968,9 +4968,11 @@ bus_unreg:
 	bus_unregister(&pseudo_lld_bus);
 dev_unreg:
 	root_device_unregister(pseudo_primary);
-free_vm:
+free_map:
 	vfree(map_storep);
+free_dif:
 	vfree(dif_storep);
+free_fake:
 	vfree(fake_storep);
 	return ret;
 }
-- 
2.2.2
