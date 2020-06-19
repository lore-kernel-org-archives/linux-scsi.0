Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64978C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 08:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B74F2080C
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 08:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbgFSIPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 04:15:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731022AbgFSIPo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jun 2020 04:15:44 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DCBC3BB5FDDBE129A4B3;
        Fri, 19 Jun 2020 16:15:39 +0800 (CST)
Received: from [10.133.219.224] (10.133.219.224) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Fri, 19 Jun 2020 16:15:30 +0800
From:   Hou Tao <houtao1@huawei.com>
Subject: [bug report][megaraid_sas] On 3108 RADI1 read performance is improved
 when nr_requests is decreased
To:     <linux-scsi@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
CC:     Hannes Reinecke <hare@suse.de>, <martin.petersen@oracle.com>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        <linux-block@vger.kernel.org>
Message-ID: <b87390d4-9981-41c2-7d5b-344ee3cf602a@huawei.com>
Date:   Fri, 19 Jun 2020 16:15:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.219.224]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Recently we encountered a read performance problem on LSI SAS-3 3108 RAID controller.
The read performance is much better when nr_requests is set as 192 compared with 256,
but after disabling the NoRA (No Readahead) feature of the hardware RAID1, there will
be no difference between nr_requests=192 and nr_requests=256.

One scene is the direct read of one ext4 file with 8GB size. The ext4 fs is stacked
on hardware RAID1 with 3.7TB size, and the RAID1 is composed of two HDDs.
The queue_depth of RAID1 device is set as 256 by driver.

fio --direct=1 --ioengine=libaio --group_reporting=1 --runtime=30 --bs=4k \
	--name=1 --numjobs=1 --iodepth=512 --filesize=8G --directory=/tmp/sdd

one ext4 file:
IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
 RA    | 51k             | 51k             | 48k             |
 NoRA  | 47k             | 46k             | 47k             |

Another scene is the direct read of two ext4 files with 4GB size.

fio --direct=1 --ioengine=libaio --group_reporting=1 --runtime=30 --bs=4k \
	--numjobs=2 --iodepth=256 --filesize=4G --directory=/tmp/sdd

two ext4 files:
IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
 RA    | 95.7k           | 94.5k           | 30.7k           |
 NoRA  | 27.3k           | 27.1k           | 27.2k           |

These results show RA feature can boost the read performance, but when nr_requests
is increased, performance is degraded.

However when using a JBOD setup on HDD which has the same model as the HDD
in RAID1 setup, there is no such problem.

one ext4 file:
IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
       | 50k             | 50.4k           | 50.5            |

two ext4 files:
IOPS   | nr_requests=128 | nr_requests=192 | nr_requests=256 |
       | 46.5k           | 46.3k           | 46.0k           |

So is the performance degradation a known issue of the RAID1 RA feature,
or is there other explanation for it ?

Regards,
Tao

---
Other details of test environment:

(1) linux kernel version
5.6.15

(2) block setup

device/queue_depth:256
queue/scheduler:[mq-deadline] kyber bfq none

(3) driver version
megasas: 07.713.01.00-rc1
[    3.302270] megasas: 07.713.01.00-rc1
[    3.302606] megaraid_sas 0000:1c:00.0: BAR:0x1  BAR's base_addr(phys):0x00000000a3500000  mapped virt_addr:0x00000000af230875
[    3.302608] megaraid_sas 0000:1c:00.0: FW now in Ready state
[    3.302610] megaraid_sas 0000:1c:00.0: 63 bit DMA mask and 32 bit consistent mask
[    3.302965] megaraid_sas 0000:1c:00.0: firmware supports msix        : (96)
[    3.305024] megaraid_sas 0000:1c:00.0: requested/available msix 73/73
[    3.305028] megaraid_sas 0000:1c:00.0: current msix/online cpus      : (73/72)
[    3.305029] megaraid_sas 0000:1c:00.0: RDPQ mode     : (disabled)
[    3.305031] megaraid_sas 0000:1c:00.0: Current firmware supports maximum commands: 928        LDIO threshold: 0
[    3.305362] megaraid_sas 0000:1c:00.0: Configured max firmware commands: 927
[    3.308155] megaraid_sas 0000:1c:00.0: Performance mode :Latency
[    3.308156] megaraid_sas 0000:1c:00.0: FW supports sync cache        : Yes
[    3.308161] megaraid_sas 0000:1c:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
[    3.352112] megaraid_sas 0000:1c:00.0: FW provided supportMaxExtLDs: 1       max_lds: 64
[    3.352113] megaraid_sas 0000:1c:00.0: controller type       : MR(1024MB)
[    3.352114] megaraid_sas 0000:1c:00.0: Online Controller Reset(OCR)  : Enabled
[    3.352114] megaraid_sas 0000:1c:00.0: Secure JBOD support   : Yes
[    3.352115] megaraid_sas 0000:1c:00.0: NVMe passthru support : No
[    3.352115] megaraid_sas 0000:1c:00.0: FW provided TM TaskAbort/Reset timeout        : 0 secs/0 secs
[    3.352116] megaraid_sas 0000:1c:00.0: JBOD sequence map support     : Yes
[    3.352117] megaraid_sas 0000:1c:00.0: PCI Lane Margining support    : No
[    3.375590] megaraid_sas 0000:1c:00.0: megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
[    3.375591] megaraid_sas 0000:1c:00.0: INIT adapter done
[    3.388987] megaraid_sas 0000:1c:00.0: pci id                : (0x1000)/(0x005d)/(0x19e5)/(0xd207)
[    3.388988] megaraid_sas 0000:1c:00.0: unevenspan support    : no
[    3.388988] megaraid_sas 0000:1c:00.0: firmware crash dump   : yes
[    3.388989] megaraid_sas 0000:1c:00.0: JBOD sequence map     : enabled

(4) megaraid firmware version

Product Name = SAS3108
FW Package Build = 24.16.0-0106
BIOS Version = 6.32.02.0_4.17.08.00_0x06150500
FW Version = 4.660.00-8102
Driver Name = megaraid_sas
Driver Version = 07.713.01.00-rc1
Current Personality = RAID-Mode

(5) hardware RAID1 setup

-------------------------------------------------------------
DG/VD TYPE  State Access Consist Cache Cac sCC     Size Name
-------------------------------------------------------------
1/2   RAID1 Optl  RW     Yes     RWTD  -   ON  3.637 TB
-------------------------------------------------------------

-----------------------------------------------------------------------
EID:Slt DID State DG     Size Intf Med SED PI SeSz Model       Sp Type
-----------------------------------------------------------------------
0:5       6 Onln   1 3.637 TB SATA HDD N   N  512B MG04ACA400N U  -
0:6       8 Onln   1 3.637 TB SATA HDD N   N  512B MG04ACA400N U  -
-----------------------------------------------------------------------

(6) hardware JBOD setup

-----------------------------------------------------------------------
EID:Slt DID State DG     Size Intf Med SED PI SeSz Model       Sp Type
-----------------------------------------------------------------------
0:4       7 JBOD  -  3.638 TB SATA HDD N   N  512B MG04ACA400N U  -
-----------------------------------------------------------------------
