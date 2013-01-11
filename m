From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] cxgb4i: Remove the scsi host device when removing device
Date: Fri, 11 Jan 2013 17:12:09 -0200
Message-ID: <1357931529-10248-1-git-send-email-cascardo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, JBottomley@parallels.com, linux-kernel@vger.kernel.org, kxie@chelsio.com, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, Divy La Rey <divy@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

When doing a hotplug remove of a cxgb4 device, there are still dandling
symlinks at /sys/class/scsi_host/hostX to the removed PCI device. The
upper layer device may also try to send data, which may crash the
system.

The DETACH message from the lower level driver is sent to the ULD when
the device is removed, when the scsi host should be removed from the
system, avoiding any problems.

After this patch, there are no more dangling symlinks and many attempts
to crash the system while there is SCSI activity and removing the device
have failed. Adding the device back again works as expected, with the
scsi hosts showing up again.

Based on a patch by Karen Xie.

Cc: Karen Xie <kxie@chelsio.com>
Cc: Divy La Rey <divy@chelsio.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index f924b3c..3fecf35 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1564,6 +1564,7 @@ static int t4_uld_state_change(void *handle, enum cxgb4_state state)
 		break;
 	case CXGB4_STATE_DETACH:
 		pr_info("cdev 0x%p, DETACH.\n", cdev);
+		cxgbi_device_unregister(cdev);
 		break;
 	default:
 		pr_info("cdev 0x%p, unknown state %d.\n", cdev, state);
-- 
1.7.1
