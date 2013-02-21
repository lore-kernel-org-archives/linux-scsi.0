From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 2/4] scsi: storvsc: avoid usage of WRITE_SAME
Date: Thu, 21 Feb 2013 12:04:51 -0800
Message-ID: <1361477093-17549-2-git-send-email-kys@microsoft.com>
References: <1361477060-17505-1-git-send-email-kys@microsoft.com>
 <1361477093-17549-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1361477093-17549-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: Olaf Hering <olaf@aepfle.de>
List-Id: linux-scsi@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

Set scsi_device->no_write_same because the host does not support it.
Also blacklist WRITE_SAME to avoid (and log) accident usage.

If the guest uses the ext4 filesystem, storvsc hangs while it prints
these messages in an endless loop:
...
[  161.459523] hv_storvsc vmbus_0_1: cmd 0x41 scsi status 0x2 srb status 0x6
[  161.462157] sd 2:0:0:0: [sda]
[  161.463135] Sense Key : No Sense [current]
[  161.464983] sd 2:0:0:0: [sda]
[  161.465899] Add. Sense: No additional sense information
[  161.468211] hv_storvsc vmbus_0_1: cmd 0x41 scsi status 0x2 srb status 0x6
[  161.475766] sd 2:0:0:0: [sda]
[  161.476728] Sense Key : No Sense [current]
[  161.478284] sd 2:0:0:0: [sda]
[  161.479441] Add. Sense: No additional sense information
...

This happens with a guest running on Windows Server 2012, but happens to
work while running on Windows Server 2008. WRITE_SAME isnt really
supported by both versions, so disable the command usage globally.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: KY Srinivasan <kys@microsoft.com>
Cc: <linux-scsi@vger.kernel.org>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5ada1d0..2060509 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1156,6 +1156,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
+	sdevice->no_write_same = 1;
+
 	return 0;
 }
 
@@ -1238,6 +1240,8 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	u8 scsi_op = scmnd->cmnd[0];
 
 	switch (scsi_op) {
+	/* the host does not handle WRITE_SAME, log accident usage */
+	case WRITE_SAME:
 	/*
 	 * smartd sends this command and the host does not handle
 	 * this. So, don't send it.
-- 
1.7.4.1
