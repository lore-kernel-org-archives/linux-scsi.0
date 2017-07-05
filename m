From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: mpt3sas: remove unnecessary statics
Date: Tue, 4 Jul 2017 21:30:03 -0500
Message-ID: <20170705023003.GA6156@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Remove unnecessary static on local variable raid_device in functions
scsih_get_resync(), scsih_get_state(),_scsih_sas_ir_operation_status_event(),
and _scsih_scan_for_devices_after_reset(). Such variables
are initialized before being used, on every execution path throughout
the mentioned functions. The statics have no benefit and, removing
them reduce the code size.

This issue was detected using Coccinelle and the following semantic patch:

@bad exists@
position p;
identifier x;
type T;
@@

static T x@p;
...
x = <+...x...+>

@@
identifier x;
expression e;
type T;
position p != bad.p;
@@

-static
 T x@p;
 ... when != x
     when strict
?x = e;

In the following log you can see the difference in the code size. This log
is the output of the size command, before and after the code change:

before:
   text    data     bss     dec     hex filename
 126304   30384    1280  157968   26910 drivers/scsi/mpt3sas/mpt3sas_scsih.o

after:
 text      data     bss     dec     hex filename
 126292   30240    1152  157684   267f4 drivers/scsi/mpt3sas/mpt3sas_scsih.o

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 22998cb..417e5d1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1571,7 +1571,7 @@ scsih_get_resync(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
-	static struct _raid_device *raid_device;
+	struct _raid_device *raid_device;
 	unsigned long flags;
 	Mpi2RaidVolPage0_t vol_pg0;
 	Mpi2ConfigReply_t mpi_reply;
@@ -1632,7 +1632,7 @@ scsih_get_state(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
-	static struct _raid_device *raid_device;
+	struct _raid_device *raid_device;
 	unsigned long flags;
 	Mpi2RaidVolPage0_t vol_pg0;
 	Mpi2ConfigReply_t mpi_reply;
@@ -7027,7 +7027,7 @@ _scsih_sas_ir_operation_status_event(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2EventDataIrOperationStatus_t *event_data =
 		(Mpi2EventDataIrOperationStatus_t *)
 		fw_event->event_data;
-	static struct _raid_device *raid_device;
+	struct _raid_device *raid_device;
 	unsigned long flags;
 	u16 handle;
 
@@ -7531,7 +7531,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	u64 sas_address;
 	struct _sas_device *sas_device;
 	struct _sas_node *expander_device;
-	static struct _raid_device *raid_device;
+	struct _raid_device *raid_device;
 	u8 retry_count;
 	unsigned long flags;
 
-- 
2.5.0
