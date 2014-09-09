From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/2] uas: Set no_report_opcodes
Date: Tue,  9 Sep 2014 16:59:59 +0200
Message-ID: <1410274800-11578-2-git-send-email-hdegoede@redhat.com>
References: <1410274800-11578-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410274800-11578-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

asm1051e usb <-> sata bridges hang when receiving a report opcodes scsi cmnd.
Take a page out of the usb-storage book, and simple disable no_report_opcodes
outright.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 3f42785..4e2f576 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -944,6 +944,8 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
+	sdev->no_report_opcodes = 1;
+
 	return 0;
 }
 
-- 
2.1.0
