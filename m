From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v3 0/7] Enhance libsas hotplug feature
Date: Thu, 13 Jul 2017 16:38:18 +0800
Message-ID: <5967317A.9080401@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <153868d4-9aa6-21b5-81f3-868668218cb2@huawei.com>
 <5966CEE7.4060506@huawei.com>
 <47ad4316-e374-26db-3cbe-aa91642aeb68@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <47ad4316-e374-26db-3cbe-aa91642aeb68@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org



在 2017/7/13 16:08, John Garry 写道:
> On 13/07/2017 02:37, wangyijing wrote:
>>> > So much nicer. BTW, /dev/sdb is a SATA disk, the rest are SAS.
>> Oh, I take a mistake ? The result you tested the hotplug which applied this patchset is fine ?
>>
>> Thanks!
>> Yijing.
> 
> Well basic hotplug is fine, as below. I did not do any robust testing.
> 

OK， thanks，I tested with and without fio running, the results are both fine.

Thanks!
Yijing.

> root@(none)$ echo 0 > ./phy-0:7/sas_phy/phy-0:7/enable
> root@(none)$ [  180.147676] hisi_sas_v2_hw HISI0162:01: found dev[8:1] is gone
> [  180.216558] hisi_sas_v2_hw HISI0162:01: found dev[7:1] is gone
> [  180.280548] hisi_sas_v2_hw HISI0162:01: found dev[6:1] is gone
> [  180.352556] hisi_sas_v2_hw HISI0162:01: found dev[5:1] is gone
> [  180.432495] hisi_sas_v2_hw HISI0162:01: found dev[4:1] is gone
> [  180.508492] hisi_sas_v2_hw HISI0162:01: found dev[3:1] is gone
> [  180.527577] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> [  180.532728] sd 0:0:1:0: [sdb] Synchronize Cache(10) failed: Result: hostbyte=0x04 driverbyte=0x00
> [  180.541591] sd 0:0:1:0: [sdb] Stopping disk
> [  180.545767] sd 0:0:1:0: [sdb] Start/Stop Unit failed: Result: hostbyte=0x04 driverbyte=0x00
> [  180.612491] hisi_sas_v2_hw HISI0162:01: found dev[2:5] is gone
> [  180.696452] hisi_sas_v2_hw HISI0162:01: found dev[1:1] is gone
> [  180.703221] hisi_sas_v2_hw HISI0162:01: found dev[0:2] is gone
> 
> root@(none)$ echo 1 > ./phy-0:7/sas_phy/phy-0:7/enable
> root@(none)$ [  185.937831] hisi_sas_v2_hw HISI0162:01: phyup: phy7 link_rate=11
> [  185.996575] scsi 0:0:8:0: Direct-Access     SanDisk  LT0200MO P404 PQ: 0 ANSI: 6
> [  187.059642] ata2.00: ATA-8: HGST HUS724040ALA640, MFAOA8B0, max UDMA/133
> [  187.066341] ata2.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [  187.073278] ata2.00: ATA Identify Device Log not supported
> [  187.078755] ata2.00: Security Log not supported
> [  187.085239] ata2.00: ATA Identify Device Log not supported
> [  187.090715] ata2.00: Security Log not supported
> [  187.095236] ata2.00: configured for UDMA/133
> [  187.136917] scsi 0:0:9:0: Direct-Access     ATA      HGST HUS724040AL A8B0 PQ: 0 ANSI: 5
> [  187.187612] sd 0:0:9:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
> [  187.195365] sd 0:0:9:0: [sdb] Write Protect is off
> [  187.200161] sd 0:0:9:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  187.223844] sd 0:0:9:0: [sdb] Attached SCSI disk
> [  187.225498] scsi 0:0:10:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  187.243864] sd 0:0:8:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  187.285879] sd 0:0:8:0: [sda] Write Protect is off
> [  187.367898] sd 0:0:8:0: [sda] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  187.524043] scsi 0:0:11:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  187.701505] sd 0:0:10:0: [sdc] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  187.743547] sd 0:0:10:0: [sdc] Write Protect is off
> [  187.822546] scsi 0:0:12:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  187.825531] sd 0:0:10:0: [sdc] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  188.000167] sd 0:0:11:0: [sdd] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  188.042205] sd 0:0:11:0: [sdd] Write Protect is off
> [  188.121527] scsi 0:0:13:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  188.124274] sd 0:0:11:0: [sdd] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  188.298942] sd 0:0:12:0: [sde] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  188.340960] sd 0:0:12:0: [sde] Write Protect is off
> [  188.420023] scsi 0:0:14:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  188.422969] sd 0:0:12:0: [sde] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  188.597501] sd 0:0:13:0: [sdf] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  188.605069] sd 0:0:8:0: [sda] Attached SCSI disk
> [  188.639520] sd 0:0:13:0: [sdf] Write Protect is off
> [  188.682445] scsi 0:0:15:0: Enclosure         12G SAS  Expander  RevB PQ: 0 ANSI: 6
> [  188.721540] sd 0:0:13:0: [sdf] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  188.896399] sd 0:0:14:0: [sdg] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  188.938445] sd 0:0:14:0: [sdg] Write Protect is off
> [  189.020444] sd 0:0:14:0: [sdg] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  189.060608] sd 0:0:10:0: [sdc] Attached SCSI disk
> [  189.359073] sd 0:0:11:0: [sdd] Attached SCSI disk
> [  189.657643] sd 0:0:12:0: [sde] Attached SCSI disk
> [  189.956585] sd 0:0:13:0: [sdf] Attached SCSI disk
> [  190.255148] sd 0:0:14:0: [sdg] Attached SCSI disk
> 
> root@(none)$ echo 0 > ./phy-0:7/sas_phy/phy-0:7/enable
> root@(none)$ [  192.895718] hisi_sas_v2_hw HISI0162:01: found dev[8:1] is gone
> [  192.964671] hisi_sas_v2_hw HISI0162:01: found dev[7:1] is gone
> [  193.032744] hisi_sas_v2_hw HISI0162:01: found dev[6:1] is gone
> [  193.096755] hisi_sas_v2_hw HISI0162:01: found dev[5:1] is gone
> [  193.157072] hisi_sas_v2_hw HISI0162:01: found dev[4:1] is gone
> [  193.221062] hisi_sas_v2_hw HISI0162:01: found dev[3:1] is gone
> [  193.247684] sd 0:0:9:0: [sdb] Synchronizing SCSI cache
> [  193.252834] sd 0:0:9:0: [sdb] Synchronize Cache(10) failed: Result: hostbyte=0x04 driverbyte=0x00
> [  193.261701] sd 0:0:9:0: [sdb] Stopping disk
> [  193.265879] sd 0:0:9:0: [sdb] Start/Stop Unit failed: Result: hostbyte=0x04 driverbyte=0x00
> [  193.325165] hisi_sas_v2_hw HISI0162:01: found dev[2:5] is gone
> [  193.381094] hisi_sas_v2_hw HISI0162:01: found dev[1:1] is gone
> [  193.388719] hisi_sas_v2_hw HISI0162:01: found dev[0:2] is gone
> 
> root@(none)$ echo 1 > ./phy-0:7/sas_phy/phy-0:7/enable
> root@(none)$ [  196.221879] hisi_sas_v2_hw HISI0162:01: phyup: phy7 link_rate=11
> [  196.281178] scsi 0:0:16:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  196.973390] ata3.00: ATA-8: HGST HUS724040ALA640, MFAOA8B0, max UDMA/133
> [  196.980088] ata3.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [  196.987022] ata3.00: ATA Identify Device Log not supported
> [  196.992499] ata3.00: Security Log not supported
> [  196.998953] ata3.00: ATA Identify Device Log not supported
> [  197.004434] ata3.00: Security Log not supported
> [  197.008954] ata3.00: configured for UDMA/133
> [  197.050428] scsi 0:0:17:0: Direct-Access     ATA      HGST HUS724040AL A8B0 PQ: 0 ANSI: 5
> [  197.091593] sd 0:0:17:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
> [  197.099441] sd 0:0:17:0: [sdb] Write Protect is off
> [  197.104326] sd 0:0:17:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  197.122982] sd 0:0:17:0: [sdb] Attached SCSI disk
> [  197.129367] scsi 0:0:18:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  197.157605] sd 0:0:16:0: [sda] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  197.199622] sd 0:0:16:0: [sda] Write Protect is off
> [  197.281604] sd 0:0:16:0: [sda] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  197.427727] scsi 0:0:19:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  197.605362] sd 0:0:18:0: [sdc] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  197.647409] sd 0:0:18:0: [sdc] Write Protect is off
> [  197.726403] scsi 0:0:20:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  197.729389] sd 0:0:18:0: [sdc] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  197.903664] sd 0:0:19:0: [sdd] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  197.945699] sd 0:0:19:0: [sdd] Write Protect is off
> [  198.024789] scsi 0:0:21:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  198.027685] sd 0:0:19:0: [sdd] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  198.202410] sd 0:0:20:0: [sde] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  198.244458] sd 0:0:20:0: [sde] Write Protect is off
> [  198.323137] scsi 0:0:22:0: Direct-Access     SanDisk  LT0200MO  P404 PQ: 0 ANSI: 6
> [  198.326491] sd 0:0:20:0: [sde] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  198.500754] sd 0:0:21:0: [sdf] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  198.516373] sd 0:0:16:0: [sda] Attached SCSI disk
> [  198.542773] sd 0:0:21:0: [sdf] Write Protect is off
> [  198.585184] scsi 0:0:23:0: Enclosure         12G SAS  Expander  RevB PQ: 0 ANSI: 6
> [  198.624911] sd 0:0:21:0: [sdf] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  198.799446] sd 0:0:22:0: [sdg] 390721968 512-byte logical blocks: (200 GB/186 GiB)
> [  198.841484] sd 0:0:22:0: [sdg] Write Protect is off
> [  198.923508] sd 0:0:22:0: [sdg] Write cache: disabled, read cache: disabled, supports DPO and FUA
> [  198.964420] sd 0:0:18:0: [sdc] Attached SCSI disk
> [  199.262903] sd 0:0:19:0: [sdd] Attached SCSI disk
> [  199.561175] sd 0:0:20:0: [sde] Attached SCSI disk
> [  199.859533] sd 0:0:21:0: [sdf] Attached SCSI disk
> 
> root@(none)$ [  200.158121] sd 0:0:22:0: [sdg] Attached SCSI disk
> 
> root@(none)$
> 
> 
>>
>>
>>> >
>>> > John
> 
> 
> 
> .
> 
