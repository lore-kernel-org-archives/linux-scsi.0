From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] scsi: aacraid: Don't copy uninitialized stack memory to userspace
Date: Fri, 23 Jun 2017 09:04:22 -0500
Message-ID: <20170623140422.30320-1-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Both aac_send_raw_srb() and aac_get_hba_info() may copy stack
allocated structs to userspace without initializing all members
of these structs. Clear out this memory to prevent information
leaks.

Fixes: 423400e64d377 ("scsi: aacraid: Include HBA direct interface")
Fixes: c799d519bf088 ("scsi: aacraid: Retrieve HBA host information ioctl")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/scsi/aacraid/commctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index d2f8d5954840..476ada6e39d0 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -950,6 +950,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			&((struct aac_native_hba *)srbfib->hw_fib_va)->resp.err;
 		struct aac_srb_reply reply;
 
+		memset(&reply, 0, sizeof(reply));
 		reply.status = ST_OK;
 		if (srbfib->flags & FIB_CONTEXT_FLAG_FASTRESP) {
 			/* fast response */
@@ -1019,6 +1020,7 @@ static int aac_get_hba_info(struct aac_dev *dev, void __user *arg)
 {
 	struct aac_hba_info hbainfo;
 
+	memset(&hbainfo, 0, sizeof(hbainfo));
 	hbainfo.adapter_number		= (u8) dev->id;
 	hbainfo.system_io_bus_number	= dev->pdev->bus->number;
 	hbainfo.device_number		= (dev->pdev->devfn >> 3);
-- 
2.11.0
