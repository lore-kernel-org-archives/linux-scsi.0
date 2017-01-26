From: Augusto Mecking Caringi <augustocaringi@gmail.com>
Subject: [PATCH] scsi: srp_transport: Fix 'always false comparison' in srp_tmo_valid()
Date: Thu, 26 Jan 2017 11:17:16 +0000
Message-ID: <1485429447-19103-1-git-send-email-augustocaringi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Augusto Mecking Caringi <augustocaringi@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Ewan D. Milne" <emilne@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In a 64bit system (where long is 64bit wide), even dividing LONG_MAX by
HZ will always be bigger than the max value that an int variable can
hold.

This has been detected by building the driver with W=1:

drivers/scsi/scsi_transport_srp.c: In function ‘srp_tmo_valid’:
drivers/scsi/scsi_transport_srp.c:92:19: warning: comparison is always
false due to limited range of data type [-Wtype-limits]
if (dev_loss_tmo >= LONG_MAX / HZ)
                   ^

Signed-off-by: Augusto Mecking Caringi <augustocaringi@gmail.com>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index b87a786..d8c83f4 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -89,7 +89,7 @@ int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo, int dev_loss_tmo)
 	if (fast_io_fail_tmo < 0 &&
 	    dev_loss_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
-	if (dev_loss_tmo >= LONG_MAX / HZ)
+	if (dev_loss_tmo >= INT_MAX / HZ)
 		return -EINVAL;
 	if (fast_io_fail_tmo >= 0 && dev_loss_tmo >= 0 &&
 	    fast_io_fail_tmo >= dev_loss_tmo)
-- 
2.7.4
