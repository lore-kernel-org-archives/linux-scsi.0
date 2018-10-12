From: Feng Li <lifeng1519@gmail.com>
Subject: [PATCH] smartpqi: Fix timeout of smartpqi probe stage
Date: Fri, 12 Oct 2018 11:13:36 +0800
Message-ID: <CAEK8JBAgRwHZDBrNDNmmRXC3WgX9tVqeoFk5edLHfJL9OWQ-zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I use 'HPE Smart Array E208i-a SR Gen10 Controller', and pass through
the SAS controller from ESXi 6.0U1 to VM, which is installed CentOS 7.4/7.5.
The disk is not found.

The error log is "controller not ready after 30 seconds."

Add some logs, and could check the probe stage needs nearly 36s to match the
status.

Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/scsi/smartpqi/smartpqi_sis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c
b/drivers/scsi/smartpqi/smartpqi_sis.c
index 5141bd4c9..bc7efdacb 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -59,7 +59,7 @@

 #define SIS_CTRL_KERNEL_UP 0x80
 #define SIS_CTRL_KERNEL_PANIC 0x100
-#define SIS_CTRL_READY_TIMEOUT_SECS 30
+#define SIS_CTRL_READY_TIMEOUT_SECS 90
 #define SIS_CTRL_READY_RESUME_TIMEOUT_SECS 90
 #define SIS_CTRL_READY_POLL_INTERVAL_MSECS 10

--
2.11.0
