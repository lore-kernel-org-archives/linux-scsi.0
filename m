From: DingXiang <dingxiang@huawei.com>
Subject: [PATCH V2 resend] libata:fix kernel panic when hotplug
Date: Thu, 16 Jun 2016 12:45:40 +0800
Message-ID: <1466052340-25520-1-git-send-email-dingxiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, fangwei1@huawei.com, miaoxie@huawei.com, wangyijing@huawei.com, zhangaihua1@huawei.com, zhaohongjiang@huawei.com, houtao1@huawei.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dingxiang@huawei.com
List-Id: linux-scsi@vger.kernel.org

In normal condition,if we use sas protocol and hotplug a
sata disk on a port,the sas driver will send event
"PORTE_BYTES_DMAED" and call function "sas_porte_bytes_dmaed".
But if a sata disk is run io and unplug it,then plug a new
sata disk,this operation may cause a kernel panic like this:

[ 2366.923208] Unable to handle kernel NULL pointer dereference
at virtual address 000007b8
...
[ 2368.766334] Call trace:
[ 2368.781712] [<ffffffc00065c3b0>] sas_find_dev_by_rphy+0x48/0x118
[ 2368.800394] [<ffffffc00065c4a8>] sas_target_alloc+0x28/0x98
[ 2368.817975] [<ffffffc00063e920>] scsi_alloc_target+0x248/0x308
[ 2368.835570] [<ffffffc000640080>] __scsi_add_device+0xb8/0x160
[ 2368.853034] [<ffffffc0006e52d8>] ata_scsi_scan_host+0x190/0x230
[ 2368.871614] [<ffffffc0006e54b0>] ata_scsi_hotplug+0xc8/0xe8
[ 2368.889152] [<ffffffc0000da75c>] process_one_work+0x164/0x438
[ 2368.908003] [<ffffffc0000dab74>] worker_thread+0x144/0x4b0
[ 2368.924613] [<ffffffc0000e0ffc>] kthread+0xfc/0x110

This because "dev_to_shost" in "sas_find_dev_by_rphy" return
a NULL point,and SHOST_TO_SAS_HA used it,so kernel panic happened.

why did dev_to_shost return a NULL point?
Because in "__scsi_add_device" ,
struct device *parent = &shost->shost_gendev,
and in "scsi_alloc_target", "*parent" is assigned to
"starget->dev.parent",then "sas_target_alloc" will get
"struct sas_rphy" according "starget->dev.parent", and in
"sas_find_dev_by_rphy" , we will get "struct Scsi_Host *shost"
according "rphy->dev.parent",we will find that
rphy->dev.parent = shost->shost_gendev.parent, and shost_gendev.parent
is "ap->tdev",there is no parent any more,so "dev_to_shost"
return a NULL point.

when the panic will happen?
When libata is handling error,and add hotplug_task to workqueue,
if a new sata disk pluged at this moment,the libata hotplug task
will run and panic will happen.

In fact,we don't need libata to deal with hotplug in sas environment.
So we can't run ata hotplug task when ata port is sas host.

Signed-off-by: Ding Xiang <dingxiang@huawei.com>
---
 drivers/ata/libata-eh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 61dc7a9..4428a7c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -816,7 +816,8 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 
 	if (ap->pflags & ATA_PFLAG_LOADING)
 		ap->pflags &= ~ATA_PFLAG_LOADING;
-	else if (ap->pflags & ATA_PFLAG_SCSI_HOTPLUG)
+	else if ((ap->pflags & ATA_PFLAG_SCSI_HOTPLUG) &&
+		 !(ap->pflags & ATA_FLAG_SAS_HOST))
 		schedule_delayed_work(&ap->hotplug_task, 0);
 
 	if (ap->pflags & ATA_PFLAG_RECOVERED)
-- 
2.5.0
