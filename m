From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 5/6] qla4xxx: Move an array from a .h into a .c file
Date: Tue, 23 Jan 2018 16:33:50 -0800
Message-ID: <20180124003351.2616-6-bart.vanassche@wdc.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18101 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbeAXAdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 19:33:53 -0500
In-Reply-To: <20180124003351.2616-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

This patch does not change any functionality but slightly reduces
the size of the compiled kernel module.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 2 ++
 drivers/scsi/qla4xxx/ql4_nx.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 968bd85610f8..43f73583ef5c 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -45,6 +45,8 @@ qla4_8xxx_pci_base_offsetfset(struct scsi_qla_host *ha, unsigned long off)
 	return NULL;
 }
 
+static const int MD_MIU_TEST_AGT_RDDATA[] = { 0x410000A8,
+				0x410000AC, 0x410000B8, 0x410000BC };
 #define MAX_CRB_XFORM 60
 static unsigned long crb_addr_xform[MAX_CRB_XFORM];
 static int qla4_8xxx_crb_table_initialized;
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 2c098cf9a1ac..98fe78613eb7 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -1022,6 +1022,4 @@ struct qla8xxx_minidump_entry_queue {
 #define MD_MIU_TEST_AGT_WRDATA_ULO		0x410000B0
 #define MD_MIU_TEST_AGT_WRDATA_UHI		0x410000B4
 
-static const int MD_MIU_TEST_AGT_RDDATA[] = { 0x410000A8,
-				0x410000AC, 0x410000B8, 0x410000BC };
 #endif
-- 
2.15.1
