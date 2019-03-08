From: <Kento.A.Kobayashi@sony.com>
Subject: [PATCH] usb: uas: fix usb subsystem hang after power off hub port
Date: Fri, 8 Mar 2019 09:13:05 +0000
Message-ID: <AE5419EAB4965843B3C0C1FE29F1FFE5872241@JPYOKXMS103.jp.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: oneukum@suse.com, stern@rowland.harvard.edu, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The issue happens with following steps:
Access usb3.0/3.1 device that uses uas driver.
Power off hub port connecting device by ioctl(USBDEVFS_CONTROL).
Wait longer than 30s(scsi layer timeout period is 30s).
Execute commands like lsusb, no response and usb subsytem hangs.

After scsi layer timeout, uas_eh_bus_reset_handler works and enter
usb_reset_device. During reset, current uas_post_reset returns 1 if
uas_configure_endpoints fails with -ENODEV, then it tries to rebind
uas driver. The unbind request cannot complete because program goes
to host_not_ready in scsi_request_fn. As result, it stops at device
reset process and the lock took before reset will not be released.

The usb_reset_and_verify_device included in usb_reset_device fails
with -ENODEV after power off hub port, and the -ENODEV error will
be reported to uas_eh_bus_reset_handler and upper layer, so it
doesn't need to do rebind if -ENODEV happens.

Signed-off-by: Kento Kobayashi <Kento.A.Kobayashi@sony.com>
---
drivers/usb/storage/uas.c | 3 +++
1 file changed, 3 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 36742e8..24b09fd 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1116,6 +1116,9 @@ static int uas_post_reset(struct usb_interface *intf)

        scsi_unblock_requests(shost);

+       if (err == -ENODEV)
+               return 0;
+
        return err ? 1 : 0;
 }

-- 
2.7.4
