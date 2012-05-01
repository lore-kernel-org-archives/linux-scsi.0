From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] scsi: fix qla2xxx printk format warnings
Date: Tue, 01 May 2012 08:18:47 -0700
Message-ID: <4F9FFED7.4060000@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34208 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756601Ab2EAPS1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 11:18:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings (from i386 build) by using %zu
format specifier.  No warnings on i386 or x86_64.

drivers/scsi/qla2xxx/qla_target.c:2951:5: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'size_t'
drivers/scsi/qla2xxx/tcm_qla2xxx.c:1564:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
drivers/scsi/qla2xxx/tcm_qla2xxx.c:1570:2: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
drivers/scsi/qla2xxx/tcm_qla2xxx.c:1576:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
drivers/scsi/qla2xxx/tcm_qla2xxx.c:1584:2: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'


Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc:	linux-driver@qlogic.com
---
 drivers/scsi/qla2xxx/qla_target.c  |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20120430.orig/drivers/scsi/qla2xxx/qla_target.c
+++ linux-next-20120430/drivers/scsi/qla2xxx/qla_target.c
@@ -2948,7 +2948,7 @@ static int qla_tgt_set_data_offset(struc
 			sg_srr_start = sg;
 			ql_dbg(ql_dbg_tgt_sgl, cmd->vha, 0xe307, "Found matching sg[%d],"
 				" using %p as sg_srr_start, and using first_offset:"
-				" %lu\n", i, sg, first_offset);
+				" %zu\n", i, sg, first_offset);
 			break;
 		}
 		tmp += sg->length;
--- linux-next-20120430.orig/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ linux-next-20120430/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1561,27 +1561,27 @@ static int tcm_qla2xxx_init_lport(struct
 	lport->lport_fcport_map = vmalloc(
 			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 	if (!lport->lport_fcport_map) {
-		pr_err("Unable to allocate lport_fcport_map of %lu"
+		pr_err("Unable to allocate lport_fcport_map of %zu"
 			" bytes\n", sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 		return -ENOMEM;
 	}
 	memset(lport->lport_fcport_map, 0,
 			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
-	pr_debug("qla2xxx: Allocated lport_fcport_map of %lu bytes\n",
+	pr_debug("qla2xxx: Allocated lport_fcport_map of %zu bytes\n",
 			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 
 	lport->lport_loopid_map = vmalloc(sizeof(struct tcm_qla2xxx_fc_loopid) *
 				65536);
 	if (!lport->lport_loopid_map) {
 		pr_err("Unable to allocate lport->lport_loopid_map"
-			" of %lu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
+			" of %zu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
 			* 65536);
 		vfree(lport->lport_fcport_map);
 		return -ENOMEM;
 	}
 	memset(lport->lport_loopid_map, 0, sizeof(struct tcm_qla2xxx_fc_loopid)
 			* 65536);
-	pr_debug("qla2xxx: Allocated lport_loopid_map of %lu bytes\n",
+	pr_debug("qla2xxx: Allocated lport_loopid_map of %zu bytes\n",
 			sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
 	return 0;
 }
