From: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Subject: [PATCH 1/1] qla2xxx: Fix sparse warnings for N2N
Date: Thu, 12 Oct 2017 23:08:21 -0700
Message-ID: <20171013060821.28237-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0040.outbound.protection.outlook.com ([104.47.40.40]:47568
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751373AbdJMGI2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 02:08:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@cavium.com>

Fixes following warning reported by 0-day kernel test build

drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla2x00_els_dcmd2_iocb_timeout':
drivers/scsi/qla2xxx/qla_iocb.c:2611:50: warning: format '%x' expects a matching
'unsigned int' argument [-Wformat=]
         "%s %d ELS Timeout, %8phC hdl=%x, portid=%06x\n",

drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla2x00_els_dcmd2_sp_done':
drivers/scsi/qla2xxx/qla_iocb.c:2634:11: warning: format '%s' expects argument of type 'char *', but argument 6 has type 'uint32_t {aka unsigned int}' [-Wformat=]
         "%s %s ELS hdl=%x, portid=%06x done %8pC\n",
	               ^
drivers/scsi/qla2xxx/qla_iocb.c:2634:35: warning: format '%x' expects argument of type 'unsigned int', but argument 8 has type 'uint8_t * {aka unsigned char *}' [-Wformat=]
         "%s %s ELS hdl=%x, portid=%06x done %8pC\n",
                                     ^
drivers/scsi/qla2xxx/qla_iocb.c:2634:44: warning: format '%p' expects a matching 'void *' argument [-Wformat=]
         "%s %s %ELS %hdl=%x, %portid=%06x %done %8pC\n",
	                                           ^
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6e57c48f8d95..0502ed7ee14e 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2608,7 +2608,7 @@ qla2x00_els_dcmd2_iocb_timeout(void *data)
 	int res;
 
 	ql_dbg(ql_dbg_io + ql_dbg_disc, vha, 0x3069,
-	    "%s %d ELS Timeout, %8phC hdl=%x, portid=%06x\n",
+	    "%s hdl=%x ELS Timeout, %8phC portid=%06x\n",
 	    sp->name, sp->handle, fcport->port_name, fcport->d_id.b24);
 
 	/* Abort the exchange */
@@ -2631,7 +2631,7 @@ qla2x00_els_dcmd2_sp_done(void *ptr, int res)
 	struct scsi_qla_host *vha = sp->vha;
 
 	ql_dbg(ql_dbg_io + ql_dbg_disc, vha, 0x3072,
-	    "%s %s ELS hdl=%x, portid=%06x done %8pC\n",
+	    "%s ELS hdl=%x, portid=%06x done %8pC\n",
 	    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	complete(&lio->u.els_plogi.comp);
-- 
2.12.0
