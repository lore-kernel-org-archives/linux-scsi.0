Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D031C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jul 2022 13:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiGUN0G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUN0F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2022 09:26:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5194186E8
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2022 06:26:02 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDNOdb011178;
        Thu, 21 Jul 2022 13:26:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=sF+9nm1JZKwMuY9z8vx2m/XhmEcTSkQ5P6ZQ2aLxjvw=;
 b=fRYg/Fsd+NvH0M2JfpMsHCVTwlvTX7sJfpd7u+FU/EcUw6bkSOFivGnfynQYQ+Pmmnq5
 gXK9b8Z9j+/vOj5PHmoU2+Pwta72YiltKXEKvi1l9NwED8Qj5m0mZALzId8Uo4USz2bL
 5eEh+BXUxH7aLucZccwU4XkjNEwEZnaz/vmvEbaLsD5WOnGGx02QFIPgzYNV8VMSSgbH
 wVdj/8iE1GfOoom4K1g02MX7ZFM0QarozkuWZkTqHuTf2Qs2w+5Ci5hwjaWzfmboDEfZ
 UWODP3DBgFejL1TMHWFzDY2v7m/p/9QD9zwrPeXybiEFPDIEQvJyrZDZYHAa705zNvn4 xQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7my0219-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:26:01 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LDP1d7031547;
        Thu, 21 Jul 2022 13:25:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj70nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 13:25:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LDPtNW24772952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 13:25:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D198FA4051;
        Thu, 21 Jul 2022 13:25:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5235A4040;
        Thu, 21 Jul 2022 13:25:55 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.230])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 21 Jul 2022 13:25:55 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1oEWBf-001vhb-Bt;
        Thu, 21 Jul 2022 15:25:55 +0200
Date:   Thu, 21 Jul 2022 13:25:55 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: Re: regression next-20220714: mkfs.ext4 on multipath device over
 scsi disks causes 'lifelock' in block layer
Message-ID: <YtlT41EUrt2gDncP@t480-pf1aa2c2.fritz.box>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-11-martin.petersen@oracle.com>
 <YtWPoZISMLxHA/vu@t480-pf1aa2c2.fritz.box>
 <yq1edyhrgpi.fsf@ca-mkp.ca.oracle.com>
 <YtaXi23TBli7F8Pz@t480-pf1aa2c2.fritz.box>
 <yq1v8rrkxwv.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <yq1v8rrkxwv.fsf@ca-mkp.ca.oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iAOvW4ljzXU8zKSfmAJPGhSkn7KbDDu4
X-Proofpoint-ORIG-GUID: iAOvW4ljzXU8zKSfmAJPGhSkn7KbDDu4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_17,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 20, 2022 at 10:29:06PM -0400, Martin K. Petersen wrote:
> > This is one of the oldest storage boxes we have right now, and this
> > regression it doesn't seem to happen on newer models as far as I can
> > see.
> 
> I have not had much luck reproducing your results today despite
> reporting the same parameters in the VPD pages as your device.
> 
> I would appreciate if you send me the output of:
> 
> # grep . /sys/block/{sd,dm}*/queue/write_zeroes_max_bytes /sys/block/sd*/device/scsi_disk/*/max_write_same_blocks
> 
> for the failing configuration.

Again at commit
1bd95bb98f83 ("scsi: sd: Move WRITE_ZEROES configuration to a separate function")

The device names keep changing like that because these are CI systems
that are reset and re-installed every night, and I don't get the same
system every day; just in case this looks strange.

  # lsblk -s -o '+KNAME' /dev/mapper/mpathd1
  NAME     MAJ:MIN RM SIZE RO TYPE  MOUNTPOINTS KNAME
  mpathd1  251:2    0  20G  0 part              dm-2
  └─mpathd 251:0    0  20G  0 mpath             dm-0
    ├─sda    8:0    0  20G  0 disk              sda
    └─sde    8:64   0  20G  0 disk              sde
  
  # grep . /sys/block/{sda,sde,dm-0,dm-2}/queue/write_zeroes_max_bytes /sys/block/{sda,sde}/device/scsi_disk/*/max_write_same_blocks
  /sys/block/sda/queue/write_zeroes_max_bytes:33553920
  /sys/block/sde/queue/write_zeroes_max_bytes:33553920
  /sys/block/dm-0/queue/write_zeroes_max_bytes:33553920
  /sys/block/dm-2/queue/write_zeroes_max_bytes:33553920
  /sys/block/sda/device/scsi_disk/0:0:0:1079787648/max_write_same_blocks:65535
  /sys/block/sde/device/scsi_disk/1:0:0:1079787648/max_write_same_blocks:65535
  
  # for fl in /sys/block/sda/device/scsi_disk/*/device/inquiry /sys/block/sda/device/scsi_disk/*/device/vpd_*; do (set -x; xxd "${fl}"); done
  + xxd /sys/block/sda/device/scsi_disk/0:0:0:1079787648/device/inquiry
  00000000: 0000 0532 9f10 1002 4942 4d20 2020 2020  ...2....IBM
  00000010: 3231 3037 3930 3020 2020 2020 2020 2020  2107900
  00000020: 3130 3630 3735 444c 3234 3138 3035 4320  106075DL241805C
  00000030: 2020 2020 2020 2020 0000 0060 0da0 0a00          ...`....
  00000040: 0300 0320 0000 0000 0000 0000 0000 0000  ... ............
  00000050: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  00000060: 0101 3037 3500 3034 3731 3400 0000 8800  ..075.04714.....
  00000070: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  00000080: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  00000090: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  000000a0: 0002 0800                                ....
  + xxd /sys/block/sda/device/scsi_disk/0:0:0:1079787648/device/vpd_pg0
  00000000: 0000 000a 0080 8386 b0b1 b2c0 c1c2       ..............
  + xxd /sys/block/sda/device/scsi_disk/0:0:0:1079787648/device/vpd_pg80
  00000000: 0080 0010 3735 444c 3234 3138 3035 4320  ....75DL241805C
  00000010: 2020 2020
  + xxd /sys/block/sda/device/scsi_disk/0:0:0:1079787648/device/vpd_pg83
  00000000: 0083 0024 0103 0010 6005 0763 07ff c5e3  ...$....`..c....
  00000010: 0000 0000 0000 805c 0114 0004 0000 0101  .......\........
  00000020: 0115 0004 0000 0000                      ........
  + xxd /sys/block/sda/device/scsi_disk/0:0:0:1079787648/device/vpd_pgb0
  00000000: 00b0 003c 0001 0000 0000 0000 0000 0000  ...<............
  00000010: 0000 0000 ffff ffff 0000 0000 0020 0000  ............. ..
  00000020: 8000 0000 0000 0000 0000 0000 0000 0000  ................
  00000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  + xxd /sys/block/sda/device/scsi_disk/0:0:0:1079787648/device/vpd_pgb1
  00000000: 00b1 003c 1c20 0000 0000 0000 0000 0000  ...<. ..........
  00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  00000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  00000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  + xxd /sys/block/sda/device/scsi_disk/0:0:0:1079787648/device/vpd_pgb2
  00000000: 00b2 0004 1540 0000                      .....@..

Maybe this also helps, I took a snapshot of dmesg when the devices are
sensed:

  ...
  [    3.228175] SCSI subsystem initialized
  ...
  [    3.942878] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log.
  [    3.942912] device-mapper: uevent: version 1.0.3
  [    3.942981] device-mapper: ioctl: 4.46.0-ioctl (2022-02-22) initialised: dm-devel@redhat.com
  ...
  [   31.563828] zfcp 0.0.1900: qdio: ZFCP on SC 15b using AI:1 QEBSM:0 PRI:1 TDD:1 SIGA: W
  [   32.688192] scsi host0: scsi_eh_0: sleeping
  [   32.688238] scsi host0: zfcp
  ...
  [   32.725595] scsi 0:0:0:0: scsi scan: INQUIRY pass 1 length 36
  [   32.725921] scsi 0:0:0:0: scsi scan: INQUIRY successful with code 0x0
  [   32.725931] scsi 0:0:0:0: scsi scan: INQUIRY pass 2 length 164
  [   32.726133] scsi 0:0:0:0: scsi scan: INQUIRY successful with code 0x0
  [   32.726139] scsi 0:0:0:0: scsi scan: peripheral device type of 31, no device added
  [   32.726560] scsi 0:0:0:0: scsi scan: Sending REPORT LUNS to (try 0)
  [   32.727220] scsi 0:0:0:0: scsi scan: REPORT LUNS successful (try 0) result 0x0
  [   32.727222] scsi 0:0:0:0: scsi scan: REPORT LUN scan
  [   32.727475] scsi 0:0:0:1079787648: scsi scan: INQUIRY pass 1 length 36
  [   32.727717] scsi 0:0:0:1079787648: scsi scan: INQUIRY successful with code 0x0
  [   32.727723] scsi 0:0:0:1079787648: scsi scan: INQUIRY pass 2 length 164
  [   32.727927] scsi 0:0:0:1079787648: scsi scan: INQUIRY successful with code 0x0
  [   32.727935] scsi 0:0:0:1079787648: Direct-Access     IBM      2107900          1060 PQ: 0 ANSI: 5
  [   32.729982] scsi 0:0:0:1079787648: sg_alloc: dev=0
  [   32.730027] sd 0:0:0:1079787648: Attached scsi generic sg0 type 0
  ...
  [   32.730502] sd 0:0:0:1079787648: Power-on or device reset occurred
  [   32.730508] sd 0:0:0:1079787648: [sda] tag#2176 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
  [   32.730511] sd 0:0:0:1079787648: [sda] tag#2176 CDB: Test Unit Ready 00 00 00 00 00 00
  [   32.730514] sd 0:0:0:1079787648: [sda] tag#2176 Sense Key : Unit Attention [current]
  [   32.730516] sd 0:0:0:1079787648: [sda] tag#2176 Add. Sense: Power on, reset, or bus device reset occurred
  ...
  [   32.730774] sd 0:0:0:1079787648: [sda] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
  [   32.730928] sd 0:0:0:1079787648: [sda] Write Protect is off
  [   32.730930] sd 0:0:0:1079787648: [sda] Mode Sense: ed 00 00 08
  [   32.731243] sd 0:0:0:1079787648: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  [   32.731376] sd 0:0:0:1079787648: [sda] tag#3781 Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK cmd_age=0s
  [   32.731379] sd 0:0:0:1079787648: [sda] tag#3781 CDB: Report supported operation codes a3 0c 01 12 00 00 00 00 00 0a 00 00
  [   32.731381] sd 0:0:0:1079787648: [sda] tag#3781 Sense Key : Illegal Request [current]
  [   32.731383] sd 0:0:0:1079787648: [sda] tag#3781 Add. Sense: Invalid field in cdb
  ...
  [   32.734915] sd 0:0:0:1079787648: [sda] tag#3784 Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK cmd_age=0s
  [   32.734917] sd 0:0:0:1079787648: [sda] tag#3784 CDB: Inquiry 12 01 b9 00 04 00
  [   32.734919] sd 0:0:0:1079787648: [sda] tag#3784 Sense Key : Illegal Request [current]
  [   32.734921] sd 0:0:0:1079787648: [sda] tag#3784 Add. Sense: Invalid field in cdb
  ...
  [   32.737032]  sda: sda1
  ...
  [   32.737185] sd 0:0:0:1079787648: [sda] Attached SCSI disk
  ...
  [   37.294939] alua: device handler registered
  [   37.296390] emc: device handler registered
  [   37.297819] rdac: device handler registered
  [   37.351199] device-mapper: multipath service-time: version 0.3.0 loaded
  [   37.351424] sd 0:0:0:1079787648: alua: supports implicit TPGS
  [   37.351427] sd 0:0:0:1079787648: alua: device naa.6005076307ffc5e3000000000000805c port group 0 rel port 101
  ...
  [   37.378201] sd 0:0:0:1079787648: alua: transition timeout set to 60 seconds
  [   37.378204] sd 0:0:0:1079787648: alua: port group 00 state A preferred supports tolusnA
  ...

Thanks for the support Martin.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
