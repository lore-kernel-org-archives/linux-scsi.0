From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] Revert accidental Makefile change
Date: Wed, 27 Jul 2005 13:54:05 -0400
Message-ID: <1122486845.2757.19.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-64-105-159-118.phlapafg.covad.net ([64.105.159.118]:61099
	"HELO roinet.com") by vger.kernel.org with SMTP id S262335AbVG0RyH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 13:54:07 -0400
Received: from dv (unknown [192.168.1.1])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(Client did not present a certificate)
	by mail.roinet.com (Postfix) with ESMTP id 7FE3245DF42
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2005 13:54:05 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!

In the current git kernel, the qla2xxx.ko module is build and installed,
although I have never requested it and I don't have any modules enabled.

I found the corresponding entry in the git log (commit
fca297037127e524e8f61b3fc1c7a1886e5d757b), and it looks like that
the change in drivers/scsi/qla2xxx/Makefile was committed accidentally.
The comment doesn't refer to Makefile.

Signed-off-by: Pavel Roskin <proski@gnu.org>

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,6 +1,4 @@
 EXTRA_CFLAGS += -DUNIQUE_FW_NAME
-CONFIG_SCSI_QLA24XX=m
-EXTRA_CFLAGS += -DCONFIG_SCSI_QLA24XX -DCONFIG_SCSI_QLA24XX_MODULE
 
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_rscn.o qla_attr.o
@@ -16,4 +14,3 @@ obj-$(CONFIG_SCSI_QLA22XX) += qla2xxx.o 
 obj-$(CONFIG_SCSI_QLA2300) += qla2xxx.o qla2300.o
 obj-$(CONFIG_SCSI_QLA2322) += qla2xxx.o qla2322.o
 obj-$(CONFIG_SCSI_QLA6312) += qla2xxx.o qla6312.o
-obj-$(CONFIG_SCSI_QLA24XX) += qla2xxx.o


-- 
Regards,
Pavel Roskin

