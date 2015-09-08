From: Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] storvsc: use small sg_tablesize on x86
Date: Tue,  8 Sep 2015 10:06:41 +0000
Message-ID: <1441706801-15300-1-git-send-email-olaf@aepfle.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@odin.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
List-Id: linux-scsi@vger.kernel.org

Reducing the sg_tablesize allows booting of 32bit kernels in VMs, after
commit be0cf6ca301c61458dc4aa1a37acf4f58d2ed3d6 ("scsi: storvsc: Set the
tablesize based on the information given by the host")

[    5.567138] hv_storvsc vmbus_1: adjusting sg_tablesize 0x800 -> 0x20

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/scsi/storvsc_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 40c43ae..36bf183 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1907,6 +1907,11 @@ static int storvsc_probe(struct hv_device *device,
 	 * from the host.
 	 */
 	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
+#if defined(CONFIG_X86_32)
+	dev_warn(&device->device, "adjusting sg_tablesize 0x%x -> 0x%x",
+			host->sg_tablesize, MAX_MULTIPAGE_BUFFER_COUNT);
+	host->sg_tablesize = MAX_MULTIPAGE_BUFFER_COUNT;
+#endif
 
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
