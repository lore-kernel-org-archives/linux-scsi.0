From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: [Patch] zfcp: act enhancements corrections
Date: Mon, 29 Nov 2004 13:57:58 +0100
Message-ID: <OF2C369516.E9283E52-ONC1256F5B.003A1DCC-C1256F5B.0047384F@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:33237 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261721AbUK2M6A
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 07:58:00 -0500
Received: from d12nrmr1507.megacenter.de.ibm.com (d12nrmr1507.megacenter.de.ibm.com [9.149.167.1])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id iATCvwvU200596
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 12:57:58 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1507.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iATCvsvQ098708
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 13:57:54 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id iATCvwEr024908
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 13:57:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org





Hi,

following patch is against 2.6.10-rc2-bk9.

The patch:

- corrects errors introduced in open_unit_handler
  with recent patch submissions for act enhancements,
- changes formatting and some log-messages in act
  enhancments code,
- removes junk lines.


Regards,

Andreas

--

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diffstat:
 drivers/s390/scsi/zfcp_def.h  |    4 +--
 drivers/s390/scsi/zfcp_erp.c  |   38 ++++++++++++++-----------------
 drivers/s390/scsi/zfcp_ext.h  |    4 +--
 drivers/s390/scsi/zfcp_fsf.c  |   51 ++----------------------------------------
 drivers/s390/scsi/zfcp_scsi.c |    3 --
 5 files changed, 26 insertions(+), 74 deletions(-)

diff -urN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h      2004-11-26 10:47:10.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h    2004-11-26 10:47:27.000000000 +0100
@@ -34,8 +34,7 @@
 #ifndef ZFCP_DEF_H
 #define ZFCP_DEF_H

-/* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_DEF_REVISION "$Revision: 1.110 $"
+#define ZFCP_DEF_REVISION "$Revision: 1.111 $"

 /*************************** INCLUDES *****************************************/

@@ -70,6 +69,7 @@

 /********************* GENERAL DEFINES *********************************/

+/* zfcp version number, it consists of major, minor, and patch-level number */
 #define ZFCP_VERSION         "4.2.0"

 /**
diff -urN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c      2004-11-26 10:47:10.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c    2004-11-26 10:47:27.000000000 +0100
@@ -31,8 +31,7 @@

 #define ZFCP_LOG_AREA              ZFCP_LOG_AREA_ERP

-/* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_ERP_REVISION "$Revision: 1.83 $"
+#define ZFCP_ERP_REVISION "$Revision: 1.85 $"

 #include "zfcp_ext.h"

@@ -3482,9 +3481,8 @@
      debug_text_event(adapter->erp_dbf, 3, "p_access_block");
      debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
      read_lock_irqsave(&zfcp_data.config_lock, flags);
-     zfcp_erp_modify_port_status(port,
-           ZFCP_STATUS_COMMON_ERP_FAILED | ZFCP_STATUS_COMMON_ACCESS_DENIED,
-           ZFCP_SET);
+     zfcp_erp_modify_port_status(port, ZFCP_STATUS_COMMON_ERP_FAILED |
+                           ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
      read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }

@@ -3500,9 +3498,8 @@

      debug_text_event(adapter->erp_dbf, 3, "u_access_block");
      debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
-     zfcp_erp_modify_unit_status(unit,
-           ZFCP_STATUS_COMMON_ERP_FAILED | ZFCP_STATUS_COMMON_ACCESS_DENIED,
-           ZFCP_SET);
+     zfcp_erp_modify_unit_status(unit, ZFCP_STATUS_COMMON_ERP_FAILED |
+                           ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
 }

 /*
@@ -3541,19 +3538,21 @@
      debug_text_event(adapter->erp_dbf, 3, "p_access_unblock");
      debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));

-     if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &port->status)) {
+     if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
+                       &port->status)) {
            if (!atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
                  list_for_each_entry(unit, &port->unit_list_head, list)
                        zfcp_erp_unit_access_changed(unit);
            return;
      }

-     ZFCP_LOG_NORMAL("Trying to reopen port 0x%016Lx on adapter %s "
-                 "due to update to access control table\n",
+     ZFCP_LOG_NORMAL("reopen of port 0x%016Lx on adapter %s "
+                 "(due to ACT update)\n",
                  port->wwpn, zfcp_get_busid_by_adapter(adapter));
      if (zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED) != 0)
-           ZFCP_LOG_NORMAL("Reopen of port 0x%016Lx on adapter %s failed\n",
-                       port->wwpn, zfcp_get_busid_by_adapter(adapter));
+           ZFCP_LOG_NORMAL("failed reopen of port"
+                       "(adapter %s, wwpn=0x%016Lx)\n",
+                       zfcp_get_busid_by_adapter(adapter), port->wwpn);
 }

 /*
@@ -3572,16 +3571,15 @@
      if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &unit->status))
            return;

-     ZFCP_LOG_NORMAL("Trying to reopen unit 0x%016Lx "
-                 "on port 0x%016Lx on adapter %s "
-                 "due to update to access control table\n",
+     ZFCP_LOG_NORMAL("reopen of unit 0x%016Lx on port 0x%016Lx "
+                 " on adapter %s (due to ACT update)\n",
                  unit->fcp_lun, unit->port->wwpn,
                  zfcp_get_busid_by_adapter(adapter));
      if (zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED) != 0)
-           ZFCP_LOG_NORMAL("Reopen of unit 0x%016Lx "
-                       "on port 0x%016Lx on adapter %s failed\n",
-                       unit->fcp_lun, unit->port->wwpn,
-                       zfcp_get_busid_by_adapter(adapter));
+           ZFCP_LOG_NORMAL("failed reopen of unit (adapter %s, "
+                       "wwpn=0x%016Lx, fcp_lun=0x%016Lx)\n",
+                       zfcp_get_busid_by_adapter(adapter),
+                       unit->port->wwpn, unit->fcp_lun);
 }

 #undef ZFCP_LOG_AREA
diff -urN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h      2004-11-26 10:47:10.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h    2004-11-26 10:47:27.000000000 +0100
@@ -31,8 +31,8 @@

 #ifndef ZFCP_EXT_H
 #define ZFCP_EXT_H
-/* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_EXT_REVISION "$Revision: 1.61 $"
+
+#define ZFCP_EXT_REVISION "$Revision: 1.62 $"

 #include "zfcp_def.h"

diff -urN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c      2004-11-26 10:47:10.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c    2004-11-26 10:47:27.000000000 +0100
@@ -30,8 +30,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */

-/* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_FSF_C_REVISION "$Revision: 1.86 $"
+#define ZFCP_FSF_C_REVISION "$Revision: 1.87 $"

 #include "zfcp_ext.h"

@@ -3094,57 +3093,11 @@
      exclusive = bottom->lun_access_info & FSF_UNIT_ACCESS_EXCLUSIVE;
      readwrite = bottom->lun_access_info & FSF_UNIT_ACCESS_OUTBOUND_TRANSFER;

-     if (!adapter->supported_features & FSF_FEATURE_CFDC)
-           goto no_cfdc;
-
      atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
                    ZFCP_STATUS_UNIT_SHARED |
                    ZFCP_STATUS_UNIT_READONLY,
                    &unit->status);

-     if (!allowed)
-           atomic_set_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &unit->status);
-
-     if (!adapter->supported_features & FSF_FEATURE_LUN_SHARING)
-           goto no_lun_sharing;
-
-     if (!exclusive)
-           atomic_set_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
-
-     if (!readwrite) {
-           atomic_set_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
-           ZFCP_LOG_NORMAL("Unit 0x%016Lx on port 0x%016Lx on adapter %s "
-                       "accessed read-only\n", unit->fcp_lun,
-                       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-     }
-
-     if (exclusive && !readwrite) {
-           ZFCP_LOG_NORMAL("Exclusive access of read-only unit not "
-                       "supported\n");
-           zfcp_erp_unit_failed(unit);
-           fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-           goto skip_fsfstatus;
-     }
-     if (!exclusive && readwrite) {
-           ZFCP_LOG_NORMAL("Shared access of read-write unit is not "
-                       "supported\n");
-           zfcp_erp_unit_failed(unit);
-           fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-           goto skip_fsfstatus;
-     }
-
- no_lun_sharing:
- no_cfdc:
-     if (!(adapter->supported_features & FSF_FEATURE_CFDC) &&
-         (adapter->supported_features & FSF_FEATURE_LUN_SHARING)) {
-           ZFCP_LOG_NORMAL("LUN sharing without access control is not "
-                       "supported.\n");
-           zfcp_erp_unit_failed(unit);
-           fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-           goto skip_fsfstatus;
-     }
-
-
      /* evaluate FSF status in QTCB */
      switch (header->fsf_status) {

@@ -3196,6 +3149,8 @@
            }
            debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
            zfcp_erp_unit_access_denied(unit);
+           atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
+                atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
            fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
            break;

diff -urN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c     2004-11-26 10:47:10.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c   2004-11-26 10:47:27.000000000 +0100
@@ -31,8 +31,7 @@

 #define ZFCP_LOG_AREA              ZFCP_LOG_AREA_SCSI

-/* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_SCSI_REVISION "$Revision: 1.73 $"
+#define ZFCP_SCSI_REVISION "$Revision: 1.74 $"

 #include "zfcp_ext.h"


