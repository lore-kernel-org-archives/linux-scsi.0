From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document how to add devices
	that need special flags in the SCSI subsystem
Date: Sat, 13 Aug 2016 21:03:45 +0200
Message-ID: <1471115025-8137-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Full flags list at include/scsi/scsi_devinfo.h


Arrays controllers included currently:

 {"3PARdata", "VV", NULL, BLIST_REPORTLUN2},

 {"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 {"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},
 {"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 {"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 {"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 {"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512},

 {"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},

 {"DGC", "RAID", NULL, BLIST_SPARSELUN},
 {"DGC", "DISK", NULL, BLIST_SPARSELUN},					<-- mising VDISK ??
 {"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 {"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

 {"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

 {"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
 {"HP", "OPEN-", "*", BLIST_REPORTLUN2},

 {"HITACHI", "DF400", "*", BLIST_REPORTLUN2},
 {"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
 {"HP", "DF400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 {"HP", "DF500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 {"HP", "DF600", "*", BLIST_SPARSELUN | BLIST_LARGELUN},			<-- bug, also apply: 627511e3e

 {"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

 {"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},				<-- ontap

 {"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},				<-- rdac!!

 {"SGI", "TP9100", "*", BLIST_REPORTLUN2},

 {"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},

 {"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 {"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 {"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 {"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},


Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a69002f..a489d6c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -22,6 +22,9 @@
  *
  * Devices with a proprietary handler must also be included in
  * the kernel side. Currently at drivers/scsi/scsi_dh.c
+ *
+ * Moreover, if a device needs a special treatment by the SCSI
+ * subsystem it should be included in drivers/scsi/scsi_devinfo.c
  */
 static struct hwentry default_hw[] = {
 	/*
-- 
2.7.4
