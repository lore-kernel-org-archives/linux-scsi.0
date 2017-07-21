From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] scsi: megaraid_sas: fix memleak in megasas_alloc_cmdlist_fusion
Date: Fri, 21 Jul 2017 18:02:10 +0530
Message-ID: <f3bf379e6c4a705dd1e13d58c6d663fc@mail.gmail.com>
References: <1500634449-10837-1-git-send-email-shuwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500634449-10837-1-git-send-email-shuwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shuwang@redhat.com, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuhu@redhat.com, liwang@redhat.com
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: shuwang@redhat.com [mailto:shuwang@redhat.com]
>Sent: Friday, July 21, 2017 4:24 PM
>To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
>shivasharan.srikanteshwara@broadcom.com; jejb@linux.vnet.ibm.com;
>martin.petersen@oracle.com
>Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; linux-
>kernel@vger.kernel.org; chuhu@redhat.com; liwang@redhat.com; Shu Wang
>Subject: [PATCH] scsi: megaraid_sas: fix memleak in
>megasas_alloc_cmdlist_fusion
>
>From: Shu Wang <shuwang@redhat.com>
>
>Found this issue by kmemleak, a few kb mem was leaked in
>megasas_alloc_cmdlist_fusion when kzalloc failed for one
>megasas_cmd_fusion allocation.
>
>unreferenced object 0xffff88045dbd2000 (size 8192):
>  comm "systemd-udevd", pid 323, jiffies 4294671759 (age 49.008s)
>  backtrace:
>    [<ffffffff8176166a>] kmemleak_alloc+0x4a/0xa0
>    [<ffffffff812186a8>] __kmalloc+0xe8/0x220
>    [<ffffffffc0060594>] megasas_alloc_cmdlist_fusion+0x34/0xe0
>[megaraid_sas]
>(gdb) list *megasas_alloc_cmdlist_fusion+0x34
>0xd5c4 is in megasas_alloc_cmdlist_fusion
>               (drivers/scsi/megaraid/megaraid_sas_fusion.c:443).
>    [<ffffffffc0060ca5>] megasas_alloc_cmds_fusion+0x25/0x410
>[megaraid_sas]
>    [<ffffffffc0061edf>] megasas_init_adapter_fusion+0x21f/0x640
>[megaraid_sas]
>    [<ffffffffc005df17>] megasas_init_fw+0x357/0xd30 [megaraid_sas]
>    [<ffffffffc005ef26>] megasas_probe_one.part.33+0x636/0x1100
>[megaraid_sas]
>    [<ffffffffc005fa36>] megasas_probe_one+0x46/0xc0 [megaraid_sas]
>    [<ffffffff813d2ca5>] local_pci_probe+0x45/0xa0
>    [<ffffffff813d4222>] pci_device_probe+0x192/0x1b0
>    [<ffffffff814e3658>] driver_probe_device+0x2a8/0x460
>    [<ffffffff814e38ed>] __driver_attach+0xdd/0xe0
>    [<ffffffff814e124c>] bus_for_each_dev+0x6c/0xc0
>    [<ffffffff814e2dde>] driver_attach+0x1e/0x20
>    [<ffffffff814e2775>] bus_add_driver+0x45/0x270
>    [<ffffffff814e4400>] driver_register+0x60/0xe0 unreferenced object
>0xffff880454ce3600 (size 192):
>  backtrace:
>    [<ffffffff8176166a>] kmemleak_alloc+0x4a/0xa0
>    [<ffffffff8121801a>] kmem_cache_alloc_trace+0xca/0x1d0
>    [<ffffffffc00605d7>] megasas_alloc_cmdlist_fusion+0x77/0xe0
>[megaraid_sas]
>(gdb) list *megasas_alloc_cmdlist_fusion+0x77
>0xd607 is in megasas_alloc_cmdlist_fusion
>                (drivers/scsi/megaraid/megaraid_sas_fusion.c:450).
>    [<ffffffffc0060ca5>] megasas_alloc_cmds_fusion+0x25/0x410
>[megaraid_sas]
>    [<ffffffffc0061edf>] megasas_init_adapter_fusion+0x21f/0x640
>[megaraid_sas]
>    [<ffffffffc005df17>] megasas_init_fw+0x357/0xd30 [megaraid_sas]
>    [<ffffffffc005ef26>] megasas_probe_one.part.33+0x636/0x1100
>[megaraid_sas]
>    [<ffffffffc005fa36>] megasas_probe_one+0x46/0xc0 [megaraid_sas]
>    [<ffffffff813d2ca5>] local_pci_probe+0x45/0xa0
>    [<ffffffff813d4222>] pci_device_probe+0x192/0x1b0
>    [<ffffffff814e3658>] driver_probe_device+0x2a8/0x460
>    [<ffffffff814e38ed>] __driver_attach+0xdd/0xe0
>    [<ffffffff814e124c>] bus_for_each_dev+0x6c/0xc0
>    [<ffffffff814e2dde>] driver_attach+0x1e/0x20
>    [<ffffffff814e2775>] bus_add_driver+0x45/0x270
>    [<ffffffff814e4400>] driver_register+0x60/0xe0
>
>Signed-off-by: Shu Wang <shuwang@redhat.com>
>---
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index f990ab4d..9855106 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -425,7 +425,7 @@ static int megasas_create_sg_sense_fusion(struct
>megasas_instance *instance)  int  megasas_alloc_cmdlist_fusion(struct
>megasas_instance *instance)  {
>-	u32 max_mpt_cmd, i;
>+	u32 max_mpt_cmd, i, j;
> 	struct fusion_context *fusion;
>
> 	fusion = instance->ctrl_context;
>@@ -450,11 +450,15 @@ megasas_alloc_cmdlist_fusion(struct
>megasas_instance *instance)
> 		fusion->cmd_list[i] = kzalloc(sizeof(struct
>megasas_cmd_fusion),
> 					      GFP_KERNEL);
> 		if (!fusion->cmd_list[i]) {
>+			for (j = 0; j < i; j++)
>+				kfree(fusion->cmd_list[j]);
>+			kfree(fusion->cmd_list);
> 			dev_err(&instance->pdev->dev,
> 				"Failed from %s %d\n",  __func__,
__LINE__);
> 			return -ENOMEM;
> 		}
> 	}
>+
> 	return 0;
> }
> int
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>--
>2.5.0
