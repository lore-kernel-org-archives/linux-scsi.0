From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] scsi: ibmvscsi: constify dev_pm_ops structures
Date: Sun, 15 Jan 2017 10:23:17 +0530
Message-ID: <1484455997-24400-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35105 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdAOExk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2017 23:53:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: julia.lawall@lip6.fr, tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>

Declare dev_pm_ops structures as const as they are only stored in the pm
field of a vio_driver structure. This field is of type const, so
dev_pm_ops structures having similar properties can be declared const.
Done using Coccinelle:

@r1 disable optional_qualifier@
identifier i;
position p;
@@
static struct dev_pm_ops i@p={...};

@ok@
identifier r1.i;
position p;
struct vio_driver x;
@@
x.pm=&i@p;

@bad@
position p!={r1.p,ok.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct dev_pm_ops i;

File sizes after cross compiling the .o files for powerpc architecture.

File size before:
  text	   data	    bss	    dec	    hex	filename
  57893	   5665	     20	  63578	   f85a	drivers/scsi/ibmvscsi/ibmvfc.o

File size after:
  text	   data	    bss	    dec	    hex	filename
  58077	   5481	     20	  63578	   f85a	drivers/scsi/ibmvscsi/ibmvfc.o

File size before:
   text	   data	    bss	    dec	    hex	filenam
  20990	   2816	     80	  23886	   5d4e	drivers/scsi/ibmvscsi/ibmvscsi.o

File size after:
  text	   data	    bss	    dec	    hex	filename
  21174	   2632	     80	  23886	   5d4e	drivers/scsi/ibmvscsi/ibmvscsi.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c   | 2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 78b72c2..1e1b343 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4940,7 +4940,7 @@ static unsigned long ibmvfc_get_desired_dma(struct vio_dev *vdev)
 };
 MODULE_DEVICE_TABLE(vio, ibmvfc_device_table);
 
-static struct dev_pm_ops ibmvfc_pm_ops = {
+static const struct dev_pm_ops ibmvfc_pm_ops = {
 	.resume = ibmvfc_resume
 };
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 50cd011..b94e7b1 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2335,7 +2335,7 @@ static int ibmvscsi_resume(struct device *dev)
 };
 MODULE_DEVICE_TABLE(vio, ibmvscsi_device_table);
 
-static struct dev_pm_ops ibmvscsi_pm_ops = {
+static const struct dev_pm_ops ibmvscsi_pm_ops = {
 	.resume = ibmvscsi_resume
 };
 
-- 
1.9.1

