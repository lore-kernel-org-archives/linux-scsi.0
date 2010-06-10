From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/12] scsi: megaraid_sas - Online Controller Reset - III:
 add the reset function for Gen2 related chip
Date: Wed, 9 Jun 2010 20:59:43 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D0804546@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add the gen2 chip reset functions to the driver.  Driver will write the gen2 chip register offset to force the controller to reset.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 14:38:29.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 14:38:43.000000000 -0400
@@ -662,6 +662,47 @@ static int
 megasas_adp_reset_gen2(struct megasas_instance *instance,
 			struct megasas_register_set __iomem *reg_set)
 {
+	u32			retry = 0 ;
+	u32			HostDiag;
+
+	writel(0, &reg_set->seq_offset);
+	writel(4, &reg_set->seq_offset);
+	writel(0xb, &reg_set->seq_offset);
+	writel(2, &reg_set->seq_offset);
+	writel(7, &reg_set->seq_offset);
+	writel(0xd, &reg_set->seq_offset);
+	msleep(1000);
+
+	HostDiag = (u32)readl(&reg_set->host_diag);
+
+	while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
+		msleep(100);
+		HostDiag = (u32)readl(&reg_set->host_diag);
+		printk(KERN_NOTICE "RESETGEN2: retry=%x, hostdiag=%x\n",
+					retry, HostDiag);
+
+		if (retry++ >= 100)
+			return 1;
+
+	}
+
+	printk(KERN_NOTICE "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
+
+	writel((HostDiag | DIAG_RESET_ADAPTER), &reg_set->host_diag);
+
+	ssleep(10);
+
+	HostDiag = (u32)readl(&reg_set->host_diag);
+	while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
+		msleep(100);
+		HostDiag = (u32)readl(&reg_set->host_diag);
+		printk(KERN_NOTICE "RESET_GEN2: retry=%x, hostdiag=%x\n",
+				retry, HostDiag);
+
+		if (retry++ >= 1000)
+			return 1;
+
+	}
 	return 0;
 }
