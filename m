From: Yanjiang Jin <yanjiang.jin@hxt-semitech.com>
Subject: [PATCH] scsi: smartpqi: call pqi_free_interrupts() in pqi_shutdown()
Date: Thu, 20 Dec 2018 16:32:35 +0800
Message-ID: <1545294755-29565-2-git-send-email-yanjiang.jin@hxt-semitech.com>
References: <1545294755-29565-1-git-send-email-yanjiang.jin@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545294755-29565-1-git-send-email-yanjiang.jin@hxt-semitech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, yanjiang.jin@hxt-semitech.com
Cc: yu.zheng@hxt-semitech.com, jinyanjiang@gmail.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We must free all irqs during shutdown, else kexec's 2nd kernel would hang
in pqi_wait_for_completion_io() as below:

Call trace:

 pqi_wait_for_completion_io
 pqi_submit_raid_request_synchronous.constprop.78+0x23c/0x310 [smartpqi]
 pqi_configure_events+0xec/0x1f8 [smartpqi]
 pqi_ctrl_init+0x814/0xca0 [smartpqi]
 pqi_pci_probe+0x400/0x46c [smartpqi]
 local_pci_probe+0x48/0xb0
 pci_device_probe+0x14c/0x1b0
 really_probe+0x218/0x3fc
 driver_probe_device+0x70/0x140
 __driver_attach+0x11c/0x134
 bus_for_each_dev+0x70/0xc8
 driver_attach+0x30/0x38
 bus_add_driver+0x1f0/0x294
 driver_register+0x74/0x12c
 __pci_register_driver+0x64/0x70
 pqi_init+0xd0/0x10000 [smartpqi]
 do_one_initcall+0x60/0x1d8
 do_init_module+0x64/0x1f8
 load_module+0x10ec/0x1350
 __se_sys_finit_module+0xd4/0x100
 __arm64_sys_finit_module+0x28/0x34
 el0_svc_handler+0x104/0x160
 el0_svc+0x8/0xc

This happens only in the following combinations:

1. smartpqi is built as module, not built-in;
2. We have a disk connected to smartpqi card;
3. Both kexec's 1st and 2nd kernels use this disk as Rootfs' mount point.

Signed-off-by: Yanjiang Jin <yanjiang.jin@hxt-semitech.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a25a07a..55c1d82 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6670,6 +6670,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
         * storage.
         */
        rc = pqi_flush_cache(ctrl_info, SHUTDOWN);
+       pqi_free_interrupts(ctrl_info);
        pqi_reset(ctrl_info);
        if (rc == 0)
                return;
--
1.8.3.1




This email is intended only for the named addressee. It may contain information that is confidential/private, legally privileged, or copyright-protected, and you should handle it accordingly. If you are not the intended recipient, you do not have legal rights to retain, copy, or distribute this email or its contents, and should promptly delete the email and all electronic copies in your system; do not retain copies in any media. If you have received this email in error, please notify the sender promptly. Thank you.
