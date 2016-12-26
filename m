From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/2] scsi: qla2xxx: silent -Wformat-security warning
Date: Mon, 26 Dec 2016 14:23:09 +0100
Message-ID: <20161226132310.3204-1-nicolas.iooss_linux@m4x.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Iooss <nicolas.iooss_linux@m4x.org>
List-Id: linux-scsi@vger.kernel.org

qla24xx_enable_msix() calls scnprintf() with a non-literal format
string. This makes clang report -Wformat-security warnings when
compiling this function:

    drivers/scsi/qla2xxx/qla_isr.c:3083:7: error: format string is not a
    string literal (potentially insecure) [-Werror,-Wformat-security]
                        msix_entries[i].name);
                        ^~~~~~~~~~~~~~~~~~~~
    drivers/scsi/qla2xxx/qla_isr.c:3083:7: note: treat the string as an
    argument to avoid this
                        msix_entries[i].name);
                        ^
                        "%s",
    drivers/scsi/qla2xxx/qla_isr.c:3119:7: error: format string is not a
    string literal (potentially insecure) [-Werror,-Wformat-security]
                        msix_entries[QLA_ATIO_VECTOR].name);
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    drivers/scsi/qla2xxx/qla_isr.c:3119:7: note: treat the string as an
    argument to avoid this
                        msix_entries[QLA_ATIO_VECTOR].name);
                        ^
                        "%s",

Even though msix_entries[...].name are initialized as literal strings
with no % character and are never modified, introduce a "%s" format
parameter in order to silent this -Wformat-security warning and make
clang able to detect at compile time real bugs related to string
formatting.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5093ca9b02ec..474b415217df 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3080,7 +3080,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		qentry->handle = rsp;
 		rsp->msix = qentry;
 		scnprintf(qentry->name, sizeof(qentry->name),
-		    msix_entries[i].name);
+		    "%s", msix_entries[i].name);
 		if (IS_P3P_TYPE(ha))
 			ret = request_irq(qentry->vector,
 				qla82xx_msix_entries[i].handler,
@@ -3116,7 +3116,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		rsp->msix = qentry;
 		qentry->handle = rsp;
 		scnprintf(qentry->name, sizeof(qentry->name),
-		    msix_entries[QLA_ATIO_VECTOR].name);
+		    "%s", msix_entries[QLA_ATIO_VECTOR].name);
 		qentry->in_use = 1;
 		ret = request_irq(qentry->vector,
 			msix_entries[QLA_ATIO_VECTOR].handler,
-- 
2.11.0
