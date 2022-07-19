Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F9DC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 11:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiGSLiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 07:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiGSLiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 07:38:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678CD1EC4C
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 04:38:17 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JBK6fG004516;
        Tue, 19 Jul 2022 11:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=+M6gwhonCos3/4opSAQMiqYmmT67X+ulPGsvoihjpj8=;
 b=hmg377HitJWcLKpv94QTz1S7byFsyXAEkbk31MfqA9+OV4IDzNgxMZ+Q20WOBWBuOyfh
 3NbRN+st3GLNwSTX8MeCI6P49rBDa+3XvDTzU7O3KBxyCmojtqicRY4jxuKuXAW5Kidm
 OtXBoz46r/3qiOzKD9LnaS8zsP/J7YFPtRFCpURLiMs6uXhNzDbSg7ySNx4aX3hMq4We
 8Em+b81Y7HYPMOoqt5qPIa5yHFAmmYgJbthxK9l6i8OZ6hOxvMcGfdHbfvYo1JysFJpf
 9NZOGjFlhRmGIB73DGBdyUosxWR/fMe3td+8nWVjcxumoae+bT36oXWynFDP+UzBK6Bx AA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdun8rcn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 11:38:10 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JBLRp3010850;
        Tue, 19 Jul 2022 11:37:51 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8k27f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 11:37:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JBbmgb13107472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 11:37:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52E07A405B;
        Tue, 19 Jul 2022 11:37:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 357A1A4054;
        Tue, 19 Jul 2022 11:37:48 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.83.209])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 19 Jul 2022 11:37:48 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1oDlXv-000QMj-Lp;
        Tue, 19 Jul 2022 13:37:47 +0200
Date:   Tue, 19 Jul 2022 11:37:47 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: regression next-20220714: mkfs.ext4 on multipath device over
 scsi disks causes 'lifelock' in block layer
Message-ID: <YtaXi23TBli7F8Pz@t480-pf1aa2c2.fritz.box>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-11-martin.petersen@oracle.com>
 <YtWPoZISMLxHA/vu@t480-pf1aa2c2.fritz.box>
 <yq1edyhrgpi.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <yq1edyhrgpi.fsf@ca-mkp.ca.oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LSKRCL6VF9YhJZrKXWnfYQCpUrCZeCeF
X-Proofpoint-ORIG-GUID: LSKRCL6VF9YhJZrKXWnfYQCpUrCZeCeF
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 18, 2022 at 10:23:26PM -0400, Martin K. Petersen wrote:
> Please send the output of:
> 
> # grep . /sys/block/sdN/queue/discard_* /sys/block/sdN/device/scsi_disk/*/*_mode
> # sg_readcap -l /dev/sdN
> # sg_vpg -p bl /dev/sdN
> # sg_vpg -p lbpv /dev/sdN
> 
> Ideally (for the grep) before and after the offending commit.

Sure,

I assume with `sg_vpg` you mean `sg_vpd`.

1bd95bb98f83 ("scsi: sd: Move WRITE_ZEROES configuration to a separate function")
---------------------------------------------------------------------------------

This is the first bad commit 

  # lsblk -s /dev/mapper/mpathe1
  NAME     MAJ:MIN RM SIZE RO TYPE  MOUNTPOINTS
  mpathe1  251:5    0  20G  0 part
  └─mpathe 251:2    0  20G  0 mpath
    ├─sde    8:64   0  20G  0 disk
    └─sdi    8:128  0  20G  0 disk
  
  # ll /dev/mapper/{mpathe1,mpathe}
  lrwxrwxrwx. 1 root root 7 Jul 19 12:52 /dev/mapper/mpathe -> ../dm-2
  lrwxrwxrwx. 1 root root 7 Jul 19 12:52 /dev/mapper/mpathe1 -> ../dm-5
  
  # lsblk -st /dev/mapper/mpathe1
  NAME     ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED       RQ-SIZE  RA WSAME
  mpathe1          0    512      0     512     512    1                 128 128    0B
  └─mpathe         0    512      0     512     512    1 mq-deadline     256 128    0B
    ├─sde          0    512      0     512     512    1 bfq             256 512    0B
    └─sdi          0    512      0     512     512    1 bfq             256 512    0B
  
  # lsblk -sD /dev/mapper/mpathe1
  NAME     DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
  mpathe1         0        1G      32M         0
  └─mpathe        0        1G      32M         0
    ├─sde         0        1G      32M         0
    └─sdi         0        1G      32M         0
  
  # grep -H . /sys/block/{sde,sdi,dm-2,dm-5}/queue/discard_* /sys/block/{sde,sdi}/device/scsi_disk/*/*_mode
  /sys/block/sde/queue/discard_granularity:1073741824
  /sys/block/sde/queue/discard_max_bytes:33553920
  /sys/block/sde/queue/discard_max_hw_bytes:33553920
  /sys/block/sde/queue/discard_zeroes_data:0
  /sys/block/sdi/queue/discard_granularity:1073741824
  /sys/block/sdi/queue/discard_max_bytes:33553920
  /sys/block/sdi/queue/discard_max_hw_bytes:33553920
  /sys/block/sdi/queue/discard_zeroes_data:0
  /sys/block/dm-2/queue/discard_granularity:1073741824
  /sys/block/dm-2/queue/discard_max_bytes:33553920
  /sys/block/dm-2/queue/discard_max_hw_bytes:33553920
  /sys/block/dm-2/queue/discard_zeroes_data:0
  /sys/block/dm-5/queue/discard_granularity:1073741824
  /sys/block/dm-5/queue/discard_max_bytes:33553920
  /sys/block/dm-5/queue/discard_max_hw_bytes:33553920
  /sys/block/dm-5/queue/discard_zeroes_data:0
  /sys/block/sde/device/scsi_disk/2:0:0:1083719810/protection_mode:none
  /sys/block/sde/device/scsi_disk/2:0:0:1083719810/provisioning_mode:writesame_16
  /sys/block/sde/device/scsi_disk/2:0:0:1083719810/zeroing_mode:writesame_16_unmap
  /sys/block/sdi/device/scsi_disk/3:0:0:1083719810/protection_mode:none
  /sys/block/sdi/device/scsi_disk/3:0:0:1083719810/provisioning_mode:writesame_16
  /sys/block/sdi/device/scsi_disk/3:0:0:1083719810/zeroing_mode:writesame_16_unmap
  
  # sg_readcap -l /dev/sde
  Read Capacity results:
     Protection: prot_en=0, p_type=0, p_i_exponent=0
     Logical block provisioning: lbpme=1, lbprz=1
     Last LBA=41943039 (0x27fffff), Number of logical blocks=41943040
     Logical block length=512 bytes
     Logical blocks per physical block exponent=0
     Lowest aligned LBA=0
  Hence:
     Device size: 21474836480 bytes, 20480.0 MiB, 21.47 GB
  
  # dmesg | tail -n 5
  [  111.308428] sd 2:0:0:1083719810: [sde] tag#2053 Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK cmd_age=0s
  [  111.308438] sd 2:0:0:1083719810: [sde] tag#2053 CDB: Inquiry 12 01 b9 00 04 00
  [  111.308441] sd 2:0:0:1083719810: [sde] tag#2053 Sense Key : Illegal Request [current]
  [  111.308444] sd 2:0:0:1083719810: [sde] tag#2053 Add. Sense: Invalid field in cdb
  [  111.311099]  sde: sde1
  
  # sg_readcap -l /dev/sdi
  Read Capacity results:
     Protection: prot_en=0, p_type=0, p_i_exponent=0
     Logical block provisioning: lbpme=1, lbprz=1
     Last LBA=41943039 (0x27fffff), Number of logical blocks=41943040
     Logical block length=512 bytes
     Logical blocks per physical block exponent=0
     Lowest aligned LBA=0
  Hence:
     Device size: 21474836480 bytes, 20480.0 MiB, 21.47 GB
  
  # dmesg | tail -n 5
  [  125.621343] sd 3:0:0:1083719810: [sdi] tag#2325 Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK cmd_age=0s
  [  125.621352] sd 3:0:0:1083719810: [sdi] tag#2325 CDB: Inquiry 12 01 b9 00 04 00
  [  125.621355] sd 3:0:0:1083719810: [sdi] tag#2325 Sense Key : Illegal Request [current]
  [  125.621358] sd 3:0:0:1083719810: [sdi] tag#2325 Add. Sense: Invalid field in cdb
  [  125.623898]  sdi: sdi1
  
  # sg_vpd -p bl /dev/sde
  Block limits VPD page (SBC):
    Write same non-zero (WSNZ): 0
    Maximum compare and write length: 1 blocks
    Optimal transfer length granularity: 0 blocks [not reported]
    Maximum transfer length: 0 blocks [not reported]
    Optimal transfer length: 0 blocks [not reported]
    Maximum prefetch transfer length: 0 blocks [ignored]
    Maximum unmap LBA count: -1 [unbounded]
    Maximum unmap block descriptor count: 0 [Unmap command not implemented]
    Optimal unmap granularity: 2097152 blocks
    Unmap granularity alignment valid: true
    Unmap granularity alignment: 0
    Maximum write same length: 0 blocks [not reported]
    Maximum atomic transfer length: 0 blocks [not reported]
    Atomic alignment: 0 [unaligned atomic writes permitted]
    Atomic transfer length granularity: 0 [no granularity requirement
    Maximum atomic transfer length with atomic boundary: 0 blocks [not reported]
    Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]
  
  # sg_vpd -p lbpv /dev/sde
  Logical block provisioning VPD page (SBC):
    Unmap command supported (LBPU): 0
    Write same (16) with unmap bit supported (LBPWS): 1
    Write same (10) with unmap bit supported (LBPWS10): 0
    Logical block provisioning read zeros (LBPRZ): 0
    Anchored LBAs supported (ANC_SUP): 0
    Threshold exponent: 21
    Descriptor present (DP): 0
    Minimum percentage: 0 [not reported]
    Provisioning type: 0 (not known or fully provisioned)
    Threshold percentage: 0 [percentages not supported]
  
  # sg_vpd -p bl /dev/sdi
  Block limits VPD page (SBC):
    Write same non-zero (WSNZ): 0
    Maximum compare and write length: 1 blocks
    Optimal transfer length granularity: 0 blocks [not reported]
    Maximum transfer length: 0 blocks [not reported]
    Optimal transfer length: 0 blocks [not reported]
    Maximum prefetch transfer length: 0 blocks [ignored]
    Maximum unmap LBA count: -1 [unbounded]
    Maximum unmap block descriptor count: 0 [Unmap command not implemented]
    Optimal unmap granularity: 2097152 blocks
    Unmap granularity alignment valid: true
    Unmap granularity alignment: 0
    Maximum write same length: 0 blocks [not reported]
    Maximum atomic transfer length: 0 blocks [not reported]
    Atomic alignment: 0 [unaligned atomic writes permitted]
    Atomic transfer length granularity: 0 [no granularity requirement
    Maximum atomic transfer length with atomic boundary: 0 blocks [not reported]
    Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]
  
  # sg_vpd -p lbpv /dev/sdi
  Logical block provisioning VPD page (SBC):
    Unmap command supported (LBPU): 0
    Write same (16) with unmap bit supported (LBPWS): 1
    Write same (10) with unmap bit supported (LBPWS10): 0
    Logical block provisioning read zeros (LBPRZ): 0
    Anchored LBAs supported (ANC_SUP): 0
    Threshold exponent: 21
    Descriptor present (DP): 0
    Minimum percentage: 0 [not reported]
    Provisioning type: 0 (not known or fully provisioned)
    Threshold percentage: 0 [percentages not supported]
  
  # mkfs.ext4 -F /dev/mapper/mpathe1
  ...
  [  307.192885] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [  307.192892] device-mapper: multipath: 251:2: Failing path 8:128.
  [  307.192938] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [  307.192941] device-mapper: multipath: 251:2: Failing path 8:64.
  [  311.548555] device-mapper: multipath: 251:2: Reinstating path 8:128.
  [  311.548883] device-mapper: multipath: 251:2: Reinstating path 8:64.
  [  311.562499] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [  311.562521] device-mapper: multipath: 251:2: Failing path 8:128.
  [  311.562553] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [  311.562557] device-mapper: multipath: 251:2: Failing path 8:64.
  ...

5be0f08e9d95 ("scsi: sd: Fix discard errors during revalidate")
---------------------------------------------------------------

This is the last good commit

  # lsblk -s /dev/mapper/mpathe1
  NAME     MAJ:MIN RM SIZE RO TYPE  MOUNTPOINTS
  mpathe1  251:6    0  20G  0 part
  └─mpathe 251:2    0  20G  0 mpath
    ├─sde    8:64   0  20G  0 disk
    └─sdf    8:80   0  20G  0 disk
  
  # ll /dev/mapper/{mpathe1,mpathe}
  lrwxrwxrwx. 1 root root 7 Jul 19 12:29 /dev/mapper/mpathe -> ../dm-2
  lrwxrwxrwx. 1 root root 7 Jul 19 12:37 /dev/mapper/mpathe1 -> ../dm-6
  
  # lsblk -st /dev/mapper/mpathe1
  NAME     ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED       RQ-SIZE  RA WSAME
  mpathe1          0    512      0     512     512    1                 128 128    0B
  └─mpathe         0    512      0     512     512    1 mq-deadline     256 128    0B
    ├─sde          0    512      0     512     512    1 bfq             256 512    0B
    └─sdf          0    512      0     512     512    1 bfq             256 512    0B
  
  # lsblk -sD /dev/mapper/mpathe1
  NAME     DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
  mpathe1         0        1G       4G         0
  └─mpathe        0        1G       4G         0
    ├─sde         0        1G       4G         0
    └─sdf         0        1G       4G         0
  
  # grep -H . /sys/block/{sde,sdf,dm-2,dm-6}/queue/discard_* /sys/block/{sde,sdf}/device/scsi_disk/*/*_mode
  /sys/block/sde/queue/discard_granularity:1073741824
  /sys/block/sde/queue/discard_max_bytes:4294966784
  /sys/block/sde/queue/discard_max_hw_bytes:4294966784
  /sys/block/sde/queue/discard_zeroes_data:0
  /sys/block/sdf/queue/discard_granularity:1073741824
  /sys/block/sdf/queue/discard_max_bytes:4294966784
  /sys/block/sdf/queue/discard_max_hw_bytes:4294966784
  /sys/block/sdf/queue/discard_zeroes_data:0
  /sys/block/dm-2/queue/discard_granularity:1073741824
  /sys/block/dm-2/queue/discard_max_bytes:4294966784
  /sys/block/dm-2/queue/discard_max_hw_bytes:4294966784
  /sys/block/dm-2/queue/discard_zeroes_data:0
  /sys/block/dm-6/queue/discard_granularity:1073741824
  /sys/block/dm-6/queue/discard_max_bytes:4294966784
  /sys/block/dm-6/queue/discard_max_hw_bytes:4294966784
  /sys/block/dm-6/queue/discard_zeroes_data:0
  /sys/block/sde/device/scsi_disk/2:0:0:1083719810/protection_mode:none
  /sys/block/sde/device/scsi_disk/2:0:0:1083719810/provisioning_mode:writesame_16
  /sys/block/sde/device/scsi_disk/2:0:0:1083719810/zeroing_mode:writesame_16_unmap
  /sys/block/sdf/device/scsi_disk/3:0:0:1083719810/protection_mode:none
  /sys/block/sdf/device/scsi_disk/3:0:0:1083719810/provisioning_mode:writesame_16
  /sys/block/sdf/device/scsi_disk/3:0:0:1083719810/zeroing_mode:writesame_16_unmap
  
  # mkfs.ext4 -F /dev/mapper/mpathe1
  mke2fs 1.46.5 (30-Dec-2021)
  Discarding device blocks: done
  Creating filesystem with 5242368 4k blocks and 1310720 inodes
  Filesystem UUID: 5d0dc4c2-445c-4a90-aaa1-0998459497c5
  Superblock backups stored on blocks:
  	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
  	4096000
  
  Allocating group tables: done
  Writing inode tables: done
  Creating journal (32768 blocks): done
  Writing superblocks and filesystem accounting information: done

This is a IBM DS8870 (first announced in 2012):
https://www.ibm.com/common/ssi/rep_sm/4/877/ENUS2424-_h04/index.html

This is one of the oldest storage boxes we have right now, and this
regression it doesn't seem to happen on newer models as far as I can
see.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
