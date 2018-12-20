From: Yanjiang Jin <yanjiang.jin@hxt-semitech.com>
Subject: [PATCH] How to reproduce this issue
Date: Thu, 20 Dec 2018 16:32:34 +0800
Message-ID: <1545294755-29565-1-git-send-email-yanjiang.jin@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, yanjiang.jin@hxt-semitech.com
Cc: yu.zheng@hxt-semitech.com, jinyanjiang@gmail.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This happens only in the following combinations:

1. smartpqi is built as module, not built-in;
2. We have a disk connected to smartpqi card;
3. Both kexec's 1st and 2nd kernels use this disk as Rootfs' mount point.

This issue can be found on my ARM64 board: QDF2400:

kexec -l /boot/vmlinuz-4.20.0-rc6+ --initrd=/boot/initramfs-4.20.0-rc6+.img --append="$(cat /proc/cmdline)"
kexec -e

Yanjiang Jin (1):
  scsi: smartpqi: call pqi_free_interrupts() in pqi_shutdown()

 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

--
1.8.3.1




This email is intended only for the named addressee. It may contain information that is confidential/private, legally privileged, or copyright-protected, and you should handle it accordingly. If you are not the intended recipient, you do not have legal rights to retain, copy, or distribute this email or its contents, and should promptly delete the email and all electronic copies in your system; do not retain copies in any media. If you have received this email in error, please notify the sender promptly. Thank you.
