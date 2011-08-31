From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] scsi: qla4xxx needs libiscsi.o
Date: Wed, 31 Aug 2011 15:02:00 -0700
Message-ID: <20110831150200.54bec12e.rdunlap@xenotime.net>
References: <20110831150137.acb3b3805bd599ac57ce96c8@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59527 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756216Ab1HaWCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2011 18:02:05 -0400
In-Reply-To: <20110831150137.acb3b3805bd599ac57ce96c8@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, iscsi-driver@qlogic.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jejbscsi <jbottomley@parallels.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <rdunlap@xenotime.net>

qla4xxx driver needs to be linked with libiscsi.o to fix
build errors.  This happens when no other drivers that use
libiscsi.o are enabled.

Found in linux-next but applies to mainline also.

ERROR: "iscsi_conn_stop" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_get_addr_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_teardown" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_host_alloc" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_start" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_send_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_set_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_failure" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_complete_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_session_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_bind" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_conn_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
ERROR: "iscsi_itt_to_task" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110831.orig/drivers/scsi/Makefile
+++ linux-next-20110831/drivers/scsi/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicf
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
 obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o 
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
-obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
+obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
