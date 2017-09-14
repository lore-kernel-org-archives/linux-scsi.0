From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid: kmemleak: Track page allocation for fusion
Date: Thu, 14 Sep 2017 18:21:17 +0530
Message-ID: <6c64f326aac146e1c37a8efd92ce4a1d@mail.gmail.com>
References: <20170914061646.10275-1-shuwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170914061646.10275-1-shuwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuwang@redhat.com, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, liwang@redhat.com, chuhu@redhat.com
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: shuwang@redhat.com [mailto:shuwang@redhat.com]
Sent: Thursday, September 14, 2017 11:47 AM
To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
shivasharan.srikanteshwara@broadcom.com; jejb@linux.vnet.ibm.com;
martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; catalin.marinas@arm.com; liwang@redhat.com;
chuhu@redhat.com; Shu Wang
Subject: [PATCH] megaraid: kmemleak: Track page allocation for fusion

From: Shu Wang <shuwang@redhat.com>

Kmemleak reports about a thousand false positives for fusion-> cmd_list[].
Root casue is the cmd_list objects are allocated from slab allocator, and
stored its pointer in object allocated by page allocator. The fix will
tell kmemleak to track and scan fusion object.

Before patch:
kmemleak: 1004 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

unreferenced object 0xffff88042584e000 (size 8192):
  backtrace:
     kmemleak_alloc+0x4a/0xa0
     __kmalloc+0xec/0x220
     megasas_alloc_cmdlist_fusion+0x3e/0x140 [megaraid_sas]
     megasas_alloc_cmds_fusion+0x44/0x450 [megaraid_sas]
     megasas_init_adapter_fusion+0x21d/0x6e0 [megaraid_sas]
     megasas_init_fw+0x357/0xd30 [megaraid_sas]
     megasas_probe_one.part.34+0x5be/0x1040 [megaraid_sas]
     megasas_probe_one+0x46/0xc0 [megaraid_sas]
     local_pci_probe+0x45/0xa0
     work_for_cpu_fn+0x14/0x20
     process_one_work+0x149/0x360
     worker_thread+0x1d8/0x3c0
     kthread+0x109/0x140
     ret_from_fork+0x25/0x30

Signed-off-by: Shu Wang <shuwang@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 11bd2e698b84..621299edd8de 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -48,6 +48,7 @@
 #include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
+#include <linux/kmemleak.h>

 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -4512,7 +4513,9 @@ megasas_alloc_fusion_context(struct megasas_instance
*instance)
 			dev_err(&instance->pdev->dev, "Failed from %s
%d\n", __func__, __LINE__);
 			return -ENOMEM;
 		}
-	}
+	} else
+		kmemleak_alloc(instance->ctrl_context,
+			sizeof(struct fusion_context), 1, GFP_KERNEL);

 	fusion = instance->ctrl_context;

@@ -4548,9 +4551,11 @@ megasas_free_fusion_context(struct megasas_instance
*instance)

 		if (is_vmalloc_addr(fusion))
 			vfree(fusion);
-		else
+		else {
 			free_pages((ulong)fusion,
 				instance->ctrl_context_pages);
+			kmemleak_free(fusion);
+		}
 	}
 }
Looks good. Thanks for catching this.

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

--
2.13.5
