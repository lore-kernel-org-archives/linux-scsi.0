From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] [SCSI] bfa: integer overflow in debugfs
Date: Wed, 4 Oct 2017 10:50:37 +0300
Message-ID: <20171004075037.j7pkdqqcegvba44e@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42729 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdJDHux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2017 03:50:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Jing Huang <huangj@brocade.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We could allocate less memory than intended because we do:

	bfad->regdata = kzalloc(len << 2, GFP_KERNEL);

The shift can overflow leading to a crash.  This is debugfs code so the
impact is very small.  I fixed the network version of this in March with
commit 13e2d5187f6b ("bna: integer overflow bug in debugfs").

Fixes: ab2a9ba189e8 ("[SCSI] bfa: add debugfs support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 8dcd8c70c7ee..05f523971348 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -255,7 +255,8 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	struct bfad_s *bfad = port->bfad;
 	struct bfa_s *bfa = &bfad->bfa;
 	struct bfa_ioc_s *ioc = &bfa->ioc;
-	int addr, len, rc, i;
+	int addr, rc, i;
+	u32 len;
 	u32 *regbuf;
 	void __iomem *rb, *reg_addr;
 	unsigned long flags;
@@ -266,7 +267,7 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
-	if (rc < 2) {
+	if (rc < 2 || len > (UINT_MAX >> 2)) {
 		printk(KERN_INFO
 			"bfad[%d]: %s failed to read user buf\n",
 			bfad->inst_no, __func__);
