From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] bfa: integer overflow bug in debugfs
Date: Mon, 19 Oct 2015 13:17:49 +0300
Message-ID: <20151019101749.GD26688@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20353 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbbJSKSC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 06:18:02 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The "len << 2" operation can have an integer overflow and leading to a
kernel crash.  This is debugfs and thus root only so no one really
cares, but we should fix it anyway just to make the static checker
happy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 74a307c..d5832b1 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -254,7 +254,8 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	struct bfad_s *bfad = port->bfad;
 	struct bfa_s *bfa = &bfad->bfa;
 	struct bfa_ioc_s *ioc = &bfa->ioc;
-	int addr, len, rc, i;
+	unsigned int len;
+	int addr, rc, i;
 	u32 *regbuf;
 	void __iomem *rb, *reg_addr;
 	unsigned long flags;
@@ -265,7 +266,7 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
-	if (rc < 2) {
+	if (rc < 2 || len > UINT_MAX >> 2) {
 		printk(KERN_INFO
 			"bfad[%d]: %s failed to read user buf\n",
 			bfad->inst_no, __func__);
