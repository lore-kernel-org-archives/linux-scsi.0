From: DingXiang <dingxiang@huawei.com>
Subject: [PATCH V2] libata:fix kernel panic when hotplug
Date: Thu, 16 Jun 2016 10:55:56 +0800
Message-ID: <1466045756-16425-1-git-send-email-dingxiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, fangwei1@huawei.com, miaoxie@huawei.com, wangyijing@huawei.com, zhangaihua1@huawei.com, zhaohongjiang@huawei.com, houtao1@huawei.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dingxiang@huawei.com
List-Id: linux-scsi@vger.kernel.org

From: Ding Xiang <dingxiang@huawei.com>

In normal condition,if we use sas protocol and hotplug a
sata disk on a port,the sas driver will send event
"PORTE_BYTES_DMAED" and call function "sas_porte_bytes_dmaed".
But if a sata disk is run io and unplug it,then plug a new
sata disk,this operation may cause a kernel panic like this:

[ 2366.923208] Unable to handle kernel NULL pointer dereference
at virtual address 000007b8
[ 2366.949253] pgd = ffffffc00121d000
[ 2366.971164] [000007b8] *pgd=00000027df893003, *pud=00000027df893003,
*pmd=00000027df894003, *pte=006000006d000707
[ 2367.022822] Internal error: Oops: 96000005 [#1] SMP
[ 2367.048490] Modules linked in: dm_mirror(E) dm_region_hash(E) dm_log(E)
dm_mod(E) crc32_arm64(E) aes_ce_blk(E) ablk_helper(E) cry ptd(E)
aes_ce_cipher(E) ghash_ce(E) sha2_ce(E) sha1_ce(E) ses(E) enclosure(E)
shpchp(E) marvell(E)
[ 2367.144808] CPU: 16 PID: 710 Comm: kworker/16:1 Tainted: G            E
4.1.23-next.aarch64 #1
[ 2367.180161] Hardware name: Huawei Taishan 2280 /BC11SPCC,
BIOS 1.28 05/14/2016
[ 2367.213305] Workqueue: events ata_scsi_hotplug
[ 2367.244296] task: ffffffe7db9b5e00 ti: ffffffe7db1a0000
task.ti: ffffffe7db1a0000
[ 2367.279949] PC is at sas_find_dev_by_rphy+0x48/0x118
[ 2367.312045] LR is at sas_find_dev_by_rphy+0x40/0x118
[ 2367.341970] pc : [<ffffffc00065c3b0>] lr : [<ffffffc00065c3a8>]
pstate: 00000145
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
[ 2368.940923] Code: aa1303e0 97ff5deb 34ffff80 d1082273 (f943de76)

This because "dev_to_shost" in "sas_find_dev_by_rphy" return
a NULL point,and SHOST_TO_SAS_HA used it,so kernel panic happed.

why dev_to_shost return a NULL point?
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
+		 !(ap->pflags & ATA_PFLAG_SAS_HOST))
 		schedule_delayed_work(&ap->hotplug_task, 0);
 
 	if (ap->pflags & ATA_PFLAG_RECOVERED)
-- 
2.5.0
