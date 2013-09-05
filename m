From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Subject: [PATCH] scsi: Add printk to detect retry loop
Date: Thu, 05 Sep 2013 17:33:11 +0900
Message-ID: <20130905083310.3079.7106.stgit@ltc223.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch is to avoid indefinite command retry loop.
The previous RFC patch is here:
http://marc.info/?t=137690537600002&r=1&w=3

In the previous discuss, James says that once retry loop is detected,
whether or not to panic(offline) should be decided by user, and not in
scsi subsystem. So we need a way to detect retry loop and report it to
user space.

This patch adds printk to detect command retry loop in user space. When
the command retry count exceeds the allowed count(scmd->allowed), the
kernel prints messages, which can be handled in user space application.
Here the allowed count(scmd->allowed) is currently used as finite retry
limit count. Once retry count exceeds the allowed count on a device,
the message is suppressed on the device to avoid too much messages
outputted in dmesg.


---

Eiichi Tsukata (1):
      scsi: Add printk to detect retry loop


 drivers/scsi/scsi_error.c  |    3 +--
 drivers/scsi/scsi_lib.c    |   14 ++++++++++++++
 include/scsi/scsi_device.h |    1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
Eiichi Tsukata
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: eiichi.tsukata.xh@hitachi.com
