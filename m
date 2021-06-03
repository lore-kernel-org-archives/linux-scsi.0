Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEBBC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 14:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A209F61009
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 14:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhFCO1V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 10:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhFCO1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Jun 2021 10:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ABAF613D6;
        Thu,  3 Jun 2021 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622730335;
        bh=KrvlF2SSvoJTPAl0ne0vJ9IvroX5ybow8slKP04AmhM=;
        h=From:To:Subject:Date:From;
        b=rSs9yKQfezqKzeO+cct3jj9Oyro+FSJvPC0TdwJmUgjN4HWmfw/ZcnazqIQALMqmA
         V4KZDLpWKEVbKXXritCKRkSp2NZZM7N/VFdyJExrTtC4yuVkNufaNJpeQrmY+daJcD
         4t/qQZ2g45ZI9rWArkiFzmUevWqujNs25BiQtgQMLORXaWVqlu2P5oe2cKu5F++FGw
         Ik10AesvuyDtmSFk01rk4n4XbeKeBxxFzheb2cVPZ9Sdx/JI3zrRP7DygpeNzaFAL5
         k/SxfWJqpix68KgEZAv9toXpznMpHUhY6S0z6E4Msdj0CPMcxGlC4IcLPLPUQKw/Cl
         vInXMXMRFd/Sg==
From:   Felipe Balbi <balbi@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: UFS failures with v5.13-rc4
Date:   Thu, 03 Jun 2021 17:25:31 +0300
Message-ID: <87lf7rc9es.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain


Hi guys,

Today I managed to trigger some pretty bad faults with with v5.13-rc4
running on SM8150 (Snapdragon) and iozone.

It seems the problem only happens when using bfq iosched, as I couldn't
trigger it with mq-deadline.

Here's the relevant snippet of console logs, full dmesg.txt attached.

# echo bfq > /sys/block/sdg/queue/scheduler
# iozone -i 0 -R -t 8 -s 1G -r 16M -b /tmp/iozone-bfq.xls -F /mnt/file0 /mnt/file1 /mnt/file2 /mnt/file3 /mnt/file4 /mnt/file5 /mnt/file6 /mnt/file7
        Iozone: Performance Test of File I/O
                Version $Revision: 3.489 $
                Compiled for 64 bit mode.
                Build: linux

        Contributors:William Norcott, Don Capps, Isom Crawford, Kirby Collins
                     Al Slater, Scott Rhine, Mike Wisner, Ken Goss
                     Steve Landherr, Brad Smith, Mark Kelly, Dr. Alain CYR,
                     Randy Dunlap, Mark Montague, Dan Million, Gavin Brebner,
                     Jean-Marc Zucconi, Jeff Blomberg, Benny Halevy, Dave Boone,
                     Erik Habbinga, Kris Strecker, Walter Wong, Joshua Root,
                     Fabrice Bacchella, Zhenghua Xue, Qin Li, Darren Sawyer,
                     Vangel Bojaxhi, Ben England, Vikentsi Lapa,
                     Alexey Skidanov, Sudhir Kumar.

        Run began: Thu Jan  1 02:29:50 1970

        Excel chart generation enabled
        File size set to 1048576 kB
        Record Size 16384 kB
        Command line used: iozone -i 0 -R -t 8 -s 1G -r 16M -b /tmp/iozone-bfq.xls -F /mnt/file0 /mnt/file1 /mnt/file2 /mnt/file3 /mnt/file4 /mnt/file5 /mnt/file6 /mnt/fil
e7
        Output is in kBytes/sec
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 kBytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
        Throughput test with 8 processes
        Each process writes a 1048576 kByte file in 16384 kByte records
[ 2475.173128] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out
[ 2475.182205] ufshcd-qcom 1d84000.ufshc: ufshcd_try_to_abort_task: no response from device. tag = 0, err -110
[ 2475.252049] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.317224] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.382038] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.447318] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.453450] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2475.522779] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.587983] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.653027] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.719555] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.725690] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2475.795173] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.861232] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.926035] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.991184] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.997382] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2476.064948] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.129955] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.194502] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.259851] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.265962] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2476.334428] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.399788] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.465468] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.529965] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.536086] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2476.544523] ufshcd-qcom 1d84000.ufshc: ufshcd_err_handler: reset and restore failed with err -5
[ 2476.606521] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.615917] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 35 b5 7c 00 00 10 00
[ 2476.623715] blk_update_request: I/O error, dev sdg, sector 28158944 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=dmesg.txt

# echo bfq > /sys/block/sdg/queue/scheduler
# iozone -i 0 -R -t 8 -s 1G -r 16M -b /tmp/iozone-bfq.xls -F /mnt/file0 /mnt/fil
e1 /mnt/file2 /mnt/file3 /mnt/file4 /mnt/file5 /mnt/file6 /mnt/file7
        Iozone: Performance Test of File I/O
                Version $Revision: 3.489 $
                Compiled for 64 bit mode.
                Build: linux

        Contributors:William Norcott, Don Capps, Isom Crawford, Kirby Collins
                     Al Slater, Scott Rhine, Mike Wisner, Ken Goss
                     Steve Landherr, Brad Smith, Mark Kelly, Dr. Alain CYR,
                     Randy Dunlap, Mark Montague, Dan Million, Gavin Brebner,
                     Jean-Marc Zucconi, Jeff Blomberg, Benny Halevy, Dave Boone,
                     Erik Habbinga, Kris Strecker, Walter Wong, Joshua Root,
                     Fabrice Bacchella, Zhenghua Xue, Qin Li, Darren Sawyer,
                     Vangel Bojaxhi, Ben England, Vikentsi Lapa,
                     Alexey Skidanov, Sudhir Kumar.

        Run began: Thu Jan  1 02:29:50 1970

        Excel chart generation enabled
        File size set to 1048576 kB
        Record Size 16384 kB
        Command line used: iozone -i 0 -R -t 8 -s 1G -r 16M -b /tmp/iozone-bfq.xls -F /mnt/file0 /mnt/file1 /mnt/file2 /mnt/file3 /mnt/file4 /mnt/file5 /mnt/file6 /mnt/fil
e7
        Output is in kBytes/sec
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 kBytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
        Throughput test with 8 processes
        Each process writes a 1048576 kByte file in 16384 kByte records
[ 2475.173128] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out
[ 2475.182205] ufshcd-qcom 1d84000.ufshc: ufshcd_try_to_abort_task: no response from device. tag = 0, err -110
[ 2475.252049] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.317224] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.382038] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.447318] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.453450] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2475.522779] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.587983] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.653027] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.719555] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.725690] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2475.795173] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.861232] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.926035] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.991184] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2475.997382] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2476.064948] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.129955] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.194502] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.259851] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.265962] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2476.334428] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.399788] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.465468] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.529965] ufshcd-qcom 1d84000.ufshc: Controller enable failed
[ 2476.536086] ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
[ 2476.544523] ufshcd-qcom 1d84000.ufshc: ufshcd_err_handler: reset and restore failed with err -5
[ 2476.606521] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.615917] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 35 b5 7c 00 00 10 00
[ 2476.623715] blk_update_request: I/O error, dev sdg, sector 28158944 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2476.634930] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.644325] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 0f 30 cc 00 00 10 00
[ 2476.652111] blk_update_request: I/O error, dev sdg, sector 7964256 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.663220] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.672609] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 0f 30 bc 00 00 10 00
[ 2476.680389] blk_update_request: I/O error, dev sdg, sector 7964128 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.691482] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.700859] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 07 b4 cc 00 00 10 00
[ 2476.708632] blk_update_request: I/O error, dev sdg, sector 4040288 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.719727] sd 0:0:0:6: [sdg] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.729109] sd 0:0:0:6: [sdg] tag#4 CDB: opcode=0x2a 2a 00 00 0f 30 ac 00 00 10 00
[ 2476.736885] blk_update_request: I/O error, dev sdg, sector 7964000 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.747962] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.757337] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 07 b4 bc 00 00 10 00
[ 2476.765107] blk_update_request: I/O error, dev sdg, sector 4040160 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.778748] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.788183] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 0e 32 3c 00 00 10 00
[ 2476.796090] blk_update_request: I/O error, dev sdg, sector 7442912 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.827147] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.836586] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 0f 30 dc 00 00 10 00
[ 2476.844457] blk_update_request: I/O error, dev sdg, sector 7964384 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.855736] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.856689] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2476.865160] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 0f 30 ec 00 00 10 00
[ 2476.874542] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 07 b4 fc 00 00 10 00
[ 2476.882320] blk_update_request: I/O error, dev sdg, sector 7964512 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.890086] blk_update_request: I/O error, dev sdg, sector 4040672 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2476.901289] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 439340)
[ 2476.923052] Buffer I/O error on device sdg1, logical block 438284
[ 2476.929349] Buffer I/O error on device sdg1, logical block 438285
[ 2476.935634] Buffer I/O error on device sdg1, logical block 438286
[ 2476.941922] Buffer I/O error on device sdg1, logical block 438287
[ 2476.948217] Buffer I/O error on device sdg1, logical block 438288
[ 2476.954505] Buffer I/O error on device sdg1, logical block 438289
[ 2476.960784] Buffer I/O error on device sdg1, logical block 438290
[ 2476.967068] Buffer I/O error on device sdg1, logical block 438291
[ 2476.973356] Buffer I/O error on device sdg1, logical block 438292
[ 2476.979648] Buffer I/O error on device sdg1, logical block 438293
[ 2477.085102] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3519532)
[ 2477.135580] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2240556)
[ 2477.187187] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 996396)
[ 2477.210721] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 930860)
[ 2477.415035] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 340012)
[ 2477.434370] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 505888)
[ 2477.550884] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2273324)
[ 2477.579243] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 440352)
[ 2477.605380] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 931872)
[ 2481.614355] scsi_io_completion_action: 4153 callbacks suppressed
[ 2481.614382] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.630089] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 19 3d 9c 00 00 10 00
[ 2481.637972] print_req_error: 4155 callbacks suppressed
[ 2481.637979] blk_update_request: I/O error, dev sdg, sector 13233376 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.654467] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.663953] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 09 ba dc 00 00 10 00
[ 2481.671820] blk_update_request: I/O error, dev sdg, sector 5101280 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.682914] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.692379] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 09 ba cc 00 00 10 00
[ 2481.700250] blk_update_request: I/O error, dev sdg, sector 5101152 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.711330] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.720799] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 19 3d 8c 00 00 10 00
[ 2481.728660] blk_update_request: I/O error, dev sdg, sector 13233248 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.739841] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.749299] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 04 35 9c 00 00 10 00
[ 2481.757158] blk_update_request: I/O error, dev sdg, sector 2206944 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.768228] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.777690] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 04 35 8c 00 00 10 00
[ 2481.785550] blk_update_request: I/O error, dev sdg, sector 2206816 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.796628] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.797444] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.806092] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 04 35 7c 00 00 10 00
[ 2481.806096] blk_update_request: I/O error, dev sdg, sector 2206688 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.815563] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 09 bb dc 00 00 10 00
[ 2481.823425] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.825085] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2481.825098] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 19 3e 4c 00 00 10 00
[ 2481.825106] blk_update_request: I/O error, dev sdg, sector 13234784 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.825150] blk_update_request: I/O error, dev sdg, sector 13234656 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.825181] blk_update_request: I/O error, dev sdg, sector 13234528 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2481.902385] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 04 35 6c 00 00 10 00
[ 2481.942239] EXT4-fs warning: 87 callbacks suppressed
[ 2481.942250] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 637996)
[ 2481.958191] buffer_io_error: 67562 callbacks suppressed
[ 2481.958195] Buffer I/O error on device sdg1, logical block 636940
[ 2481.969854] Buffer I/O error on device sdg1, logical block 636941
[ 2481.976133] Buffer I/O error on device sdg1, logical block 636942
[ 2481.982403] Buffer I/O error on device sdg1, logical block 636943
[ 2481.988681] Buffer I/O error on device sdg1, logical block 636944
[ 2481.994952] Buffer I/O error on device sdg1, logical block 636945
[ 2482.001218] Buffer I/O error on device sdg1, logical block 636946
[ 2482.007485] Buffer I/O error on device sdg1, logical block 636947
[ 2482.013751] Buffer I/O error on device sdg1, logical block 636948
[ 2482.020017] Buffer I/O error on device sdg1, logical block 636949
[ 2482.139464] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1654816)
[ 2482.174448] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3225644)
[ 2482.274537] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 276512)
[ 2482.362896] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 571436)
[ 2482.364129] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 639008)
[ 2482.373836] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2144288)
[ 2482.414332] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1357868)
[ 2482.425358] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3226668)
[ 2482.669425] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 572460)
[ 2486.577502] Buffer I/O error on dev sdg1, logical block 1, lost async page write
[ 2486.588538] Buffer I/O error on dev sdg1, logical block 131599, lost async page write

[ 2486.596654] Buffer I/O error on dev sdg1, logical block 131072, lost async page write
[ 2486.604910] Buffer I/O error on dev sdg1, logical block 66065, lost async page write
[ 2486.612890] Buffer I/O error on dev sdg1, logical block 66066, lost async page write
        Children see throughput for  8 initial writers  [ 2486.620858] Buffer I/O error on dev sdg1, logical block 66067, lost async page write
=  195274.80 kB/sec[ 2486.633204] Buffer I/O error on dev sdg1, logical block 66068, lost async page write

[ 2486.642873] scsi_io_completion_action: 4356 callbacks suppressed
[ 2486.642886] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2486.658708] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 01 00 20 00 00 01 00
        Parent sees throughput for  8 initial writers   =  125029.20 kB/[ 2sec[ 2486.666581] blk_update_request: I/O error, dev sdg, sector 524544 op 0x1:(WRITE) flags 0x1
03000 phys_seg 1 prio class 0

[ 2486.688662] Buffer I/O error on dev sdg1, logical block 65536, lost async page write
[ 2486.696826] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
        Min throughput per process [ 2486.706285] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 00 80 22 00 00 01 00
[ 2486.716657] blk_update_request: I/O error, dev sdg, sector 262416 op 0x1:(WRITE) flags 0x103000 phys_seg 1 prio class 0
                [ 2486.727728] Buffer I/O error on dev sdg1, logical block 32770, lost async page write
[ 2486.735890] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
        =   22522.58 kB/sec
[ 2486.745346] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 00 00 25 00 00 01 00
[ 2486.755271] blk_update_request: I/O error, dev sdg, sector 296 op 0x1:(WRITE) flags 0x103000 phys_seg 1 prio class 0
[ 2486.766071] Buffer I/O error on dev sdg1, logical block 5, lost async page write
        Max throughput per process [ 2486.774489] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
                        =   26719.42 kB/sec
        Avg throughput per process                      =   24409[ 2486.785595] sd 0:0:0:6: [sdg] tag#0 CDB: .35 kB/sec
        Min xfer                                        =  884736.00 kB
[ 2486.800578] blk_update_request: I/O error, dev sdg, sector 4198800 op 0x1:(WRITE) flags 0x103000 phys_seg 3 prio class 0
[ 2486.815743] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2486.825157] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 08 00 20 00 00 01 00
[ 2486.832941] blk_update_request: I/O error, dev sdg, sector 4194560 op 0x1:(WRITE) flags 0x103000 phys_seg 1 prio class 0
[ 2486.844161] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2486.853549] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 07 82 36 00 00 01 00
[ 2486.861350] blk_update_request: I/O error, dev sdg, sector 3936688 op 0x1:(WRITE) flags 0x103000 phys_seg 1 prio class 0
[ 2486.872563] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2486.881966] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 07 80 20 00 00 01 00
[ 2486.889756] blk_update_request: I/O error, dev sdg, sector 3932416 op 0x1:(WRITE) flags 0x103000 phys_seg 1 prio class 0
[ 2486.900974] sd 0:0:0:6: [sdg] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2486.910363] sd 0:0:0:6: [sdg] tag#4 CDB: opcode=0x2a 2a 00 00 07 02 32 00 00 03 00
[ 2486.918159] blk_update_request: I/O error, dev sdg, sector 3674512 op 0x1:(WRITE) flags 0x103000 phys_seg 3 prio class 0
[ 2486.929385] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2486.938794] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 07 00 20 00 00 01 00
[ 2486.946583] blk_update_request: I/O error, dev sdg, sector 3670272 op 0x1:(WRITE) flags 0x103000 phys_seg 1 prio class 0
[ 2486.957810] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2486.957995] blk_update_request: I/O error, dev sdg, sector 6029568 op 0x1:(WRITE) flags 0x103000 phys_seg 1 prio class 0
[ 2486.967208] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 06 82 36 00 00 01 00
[ 2489.235235] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2489.352977] EXT4-fs (sdg1): I/O error while writing superblock
[ 2489.362763] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2489.453111] EXT4-fs (sdg1): I/O error while writing superblock
[ 2489.453843] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2489.538985] EXT4-fs (sdg1): I/O error while writing superblock
[ 2489.542738] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2489.614518] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2489.641298] EXT4-fs (sdg1): I/O error while writing superblock
[ 2489.652082] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2489.689196] EXT4-fs (sdg1): I/O error while writing superblock
[ 2489.698461] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2489.716729] EXT4-fs warning: 92 callbacks suppressed
[ 2489.721919] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2199491)
[ 2489.732871] buffer_io_error: 70402 callbacks suppressed
[ 2489.732889] Buffer I/O error on device sdg1, logical block 2197504
[ 2489.744662] Buffer I/O error on device sdg1, logical block 2197505
[ 2489.751076] Buffer I/O error on device sdg1, logical block 2197506
[ 2489.757455] Buffer I/O error on device sdg1, logical block 2197507
[ 2489.763830] Buffer I/O error on device sdg1, logical block 2197508
[ 2489.770230] Buffer I/O error on device sdg1, logical block 2197509
[ 2489.776611] Buffer I/O error on device sdg1, logical block 2197510
[ 2489.782995] Buffer I/O error on device sdg1, logical block 2197511
[ 2489.789371] Buffer I/O error on device sdg1, logical block 2197512
[ 2489.795759] Buffer I/O error on device sdg1, logical block 2197513
[ 2489.809993] EXT4-fs (sdg1): I/O error while writing superblock
[ 2489.863214] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2199584)
[ 2489.890904] EXT4-fs (sdg1): I/O error while writing superblock
[ 2489.918493] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3444081)
[ 2489.967780] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2490.032555] EXT4-fs (sdg1): I/O error while writing superblock
[ 2490.034458] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3444768)
[ 2490.140435] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 396709)
[ 2490.157843] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2490.222473] EXT4-fs (sdg1): I/O error while writing superblock
[ 2490.229499] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 397344)
[ 2490.232791] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2490.282491] EXT4-fs (sdg1): I/O error while writing superblock
[ 2490.324521] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 822872)
[ 2490.366350] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 823328)
[ 2490.464810] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 888056)
[ 2490.578409] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 888864)
[ 2491.690352] scsi_io_completion_action: 1568 callbacks suppressed
[ 2491.690385] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.706072] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 05 8e 10 00 00 10 00
[ 2491.713961] print_req_error: 1568 callbacks suppressed
[ 2491.713966] blk_update_request: I/O error, dev sdg, sector 2912384 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.730365] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.739853] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 05 8e 00 00 00 10 00
[ 2491.747729] blk_update_request: I/O error, dev sdg, sector 2912256 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.758822] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.768288] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 05 8d f0 00 00 10 00
[ 2491.776156] blk_update_request: I/O error, dev sdg, sector 2912128 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.787228] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.796703] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 05 8d e0 00 00 10 00
[ 2491.804567] blk_update_request: I/O error, dev sdg, sector 2912000 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.815651] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.825112] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 05 8d d0 00 00 10 00
[ 2491.832971] blk_update_request: I/O error, dev sdg, sector 2911872 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.844047] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.853522] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 05 8d c0 00 00 10 00
[ 2491.861382] blk_update_request: I/O error, dev sdg, sector 2911744 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.872456] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.881925] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 05 8d b0 00 00 10 00
[ 2491.889796] blk_update_request: I/O error, dev sdg, sector 2911616 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.900877] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.910340] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 05 8d a0 00 00 10 00
[ 2491.918203] blk_update_request: I/O error, dev sdg, sector 2911488 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.929279] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.938656] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 05 8d 90 00 00 10 00
[ 2491.946430] blk_update_request: I/O error, dev sdg, sector 2911360 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.957514] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2491.958208] blk_update_request: I/O error, dev sdg, sector 2914944 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2491.966903] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 05 8d 80 00 00 10 00
[ 2492.806577] buffer_io_error: 368 callbacks suppressed
[ 2492.806594] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2492.871197] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2493.938559] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2494.278417] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2494.497654] EXT4-fs error: 11 callbacks suppressed
[ 2494.497671] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2494.582278] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2494.589923] EXT4-fs: 11 callbacks suppressed
[ 2494.589929] EXT4-fs (sdg1): I/O error while writing superblock
[ 2494.770644] EXT4-fs warning: 32 callbacks suppressed
[ 2494.770660] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1216544)
[ 2494.786712] buffer_io_error: 46288 callbacks suppressed
[ 2494.786716] Buffer I/O error on device sdg1, logical block 1215706
[ 2494.798453] Buffer I/O error on device sdg1, logical block 1215707
[ 2494.804817] Buffer I/O error on device sdg1, logical block 1215708
[ 2494.811175] Buffer I/O error on device sdg1, logical block 1215709
[ 2494.817533] Buffer I/O error on device sdg1, logical block 1215710
[ 2494.823886] Buffer I/O error on device sdg1, logical block 1215711
[ 2494.830242] Buffer I/O error on device sdg1, logical block 1215712
[ 2494.836589] Buffer I/O error on device sdg1, logical block 1215713
[ 2494.842943] Buffer I/O error on device sdg1, logical block 1215714
[ 2494.849297] Buffer I/O error on device sdg1, logical block 1215715
[ 2495.109444] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2495.122819] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 233504)
[ 2495.190605] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2495.198194] EXT4-fs (sdg1): I/O error while writing superblock
[ 2495.266640] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2493506)
[ 2495.418639] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2494496)
[ 2495.638565] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2395438)
[ 2495.726522] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2396192)
[ 2495.938383] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1281293)
[ 2496.022630] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1282080)
[ 2496.235421] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 167119)
[ 2496.322652] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 167968)
[ 2496.698263] scsi_io_completion_action: 2368 callbacks suppressed
[ 2496.698288] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.713972] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 2f 8a 50 00 00 10 00
[ 2496.721846] print_req_error: 2368 callbacks suppressed
[ 2496.721851] blk_update_request: I/O error, dev sdg, sector 24924800 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.738339] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.747813] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 2f 8a 40 00 00 10 00
[ 2496.755674] blk_update_request: I/O error, dev sdg, sector 24924672 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.766846] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.776318] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 2f 8a 30 00 00 10 00
[ 2496.784179] blk_update_request: I/O error, dev sdg, sector 24924544 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.795340] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.804807] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 2f 8a 20 00 00 10 00
[ 2496.812663] blk_update_request: I/O error, dev sdg, sector 24924416 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.823819] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.833282] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 2f 8a 10 00 00 10 00
[ 2496.841137] blk_update_request: I/O error, dev sdg, sector 24924288 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.852297] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.861756] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 2f 8a 00 00 00 10 00
[ 2496.869619] blk_update_request: I/O error, dev sdg, sector 24924160 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.880784] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.890256] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 2f 89 f0 00 00 10 00
[ 2496.898109] blk_update_request: I/O error, dev sdg, sector 24924032 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.909275] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.918648] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 2f 89 e0 00 00 10 00
[ 2496.926423] blk_update_request: I/O error, dev sdg, sector 24923904 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.937593] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.946974] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 2f 89 d0 00 00 10 00
[ 2496.954746] blk_update_request: I/O error, dev sdg, sector 24923776 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.965917] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2496.966427] blk_update_request: I/O error, dev sdg, sector 24924928 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2496.975291] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 2f 89 c0 00 00 10 00
[ 2497.805652] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2497.872243] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2497.879846] EXT4-fs (sdg1): I/O error while writing superblock
[ 2499.245581] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2499.318308] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2499.326222] EXT4-fs (sdg1): I/O error while writing superblock
[ 2499.682830] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2499.726582] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2499.734171] EXT4-fs (sdg1): I/O error while writing superblock
[ 2499.781275] EXT4-fs warning: 25 callbacks suppressed
[ 2499.781291] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 855433)
[ 2499.797256] buffer_io_error: 34588 callbacks suppressed
[ 2499.797260] Buffer I/O error on device sdg1, logical block 854016
[ 2499.808919] Buffer I/O error on device sdg1, logical block 854017
[ 2499.815209] Buffer I/O error on device sdg1, logical block 854018
[ 2499.821487] Buffer I/O error on device sdg1, logical block 854019
[ 2499.827759] Buffer I/O error on device sdg1, logical block 854020
[ 2499.834028] Buffer I/O error on device sdg1, logical block 854021
[ 2499.840302] Buffer I/O error on device sdg1, logical block 854022
[ 2499.846576] Buffer I/O error on device sdg1, logical block 854023
[ 2499.852842] Buffer I/O error on device sdg1, logical block 854024
[ 2499.859110] Buffer I/O error on device sdg1, logical block 854025
[ 2499.935899] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 855941)
[ 2499.993383] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2500.007524] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 856096)
[ 2500.027876] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2500.035502] EXT4-fs (sdg1): I/O error while writing superblock
[ 2500.142497] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2624723)
[ 2500.232412] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2625568)
[ 2500.400509] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3476512)
[ 2500.613876] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2500.672249] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2500.679847] EXT4-fs (sdg1): I/O error while writing superblock
[ 2500.681832] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 299040)
[ 2500.914249] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 36896)
[ 2501.046014] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2657312)
[ 2501.060221] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2501.226299] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3313116)
[ 2501.734302] scsi_io_completion_action: 2314 callbacks suppressed
[ 2501.734329] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.750009] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 2f 8d 70 00 00 10 00
[ 2501.757883] print_req_error: 2314 callbacks suppressed
[ 2501.757889] blk_update_request: I/O error, dev sdg, sector 24931200 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.774369] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.783851] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 2f 8d 60 00 00 10 00
[ 2501.791712] blk_update_request: I/O error, dev sdg, sector 24931072 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.802889] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.812354] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 2f 8d 50 00 00 10 00
[ 2501.820223] blk_update_request: I/O error, dev sdg, sector 24930944 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.831380] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.840842] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 2f 8d 40 00 00 10 00
[ 2501.848705] blk_update_request: I/O error, dev sdg, sector 24930816 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.859872] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.869337] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 2f 8d 30 00 00 10 00
[ 2501.877201] blk_update_request: I/O error, dev sdg, sector 24930688 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.888365] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.897835] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 2f 8d 20 00 00 10 00
[ 2501.905702] blk_update_request: I/O error, dev sdg, sector 24930560 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.916875] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.926338] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 2f 8d 10 00 00 10 00
[ 2501.934201] blk_update_request: I/O error, dev sdg, sector 24930432 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.945358] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.954825] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 2f 8d 00 00 00 10 00
[ 2501.962685] blk_update_request: I/O error, dev sdg, sector 24930304 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2501.973847] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2501.983220] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 2f 8c f0 00 00 10 00
[ 2501.990999] blk_update_request: I/O error, dev sdg, sector 24930176 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2502.002165] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2502.002968] blk_update_request: I/O error, dev sdg, sector 24933760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2502.011546] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 2f 8c e0 00 00 10 00
[ 2503.093165] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2503.146684] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2503.154386] EXT4-fs (sdg1): I/O error while writing superblock
[ 2504.481377] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2504.578995] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2504.586656] EXT4-fs (sdg1): I/O error while writing superblock
[ 2504.853598] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2504.918323] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2504.925895] EXT4-fs (sdg1): I/O error while writing superblock
[ 2504.929450] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2504.986885] EXT4-fs warning: 27 callbacks suppressed
[ 2504.986903] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 790133)
[ 2505.002865] buffer_io_error: 36854 callbacks suppressed
[ 2505.002870] Buffer I/O error on device sdg1, logical block 788480
[ 2505.014530] Buffer I/O error on device sdg1, logical block 788481
[ 2505.020815] Buffer I/O error on device sdg1, logical block 788482
[ 2505.027090] Buffer I/O error on device sdg1, logical block 788483
[ 2505.033366] Buffer I/O error on device sdg1, logical block 788484
[ 2505.039635] Buffer I/O error on device sdg1, logical block 788485
[ 2505.045907] Buffer I/O error on device sdg1, logical block 788486
[ 2505.052182] Buffer I/O error on device sdg1, logical block 788487
[ 2505.058446] Buffer I/O error on device sdg1, logical block 788488
[ 2505.064713] Buffer I/O error on device sdg1, logical block 788489
[ 2505.072833] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2505.080378] EXT4-fs (sdg1): I/O error while writing superblock
[ 2505.082021] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 790560)
[ 2505.211197] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3083296)
[ 2505.233674] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2505.283257] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2505.290879] EXT4-fs (sdg1): I/O error while writing superblock
[ 2505.346516] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2658336)
[ 2505.516398] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1740832)
[ 2505.670617] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3378208)
[ 2505.801403] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2505.822441] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 986935)
[ 2505.850426] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 987168)
[ 2505.886440] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2505.894029] EXT4-fs (sdg1): I/O error while writing superblock
[ 2506.110593] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1150603)
[ 2506.210478] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1151008)
[ 2506.774761] scsi_io_completion_action: 2237 callbacks suppressed
[ 2506.774803] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2506.790534] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 0e 8f f7 00 00 10 00
[ 2506.798446] print_req_error: 2237 callbacks suppressed
[ 2506.798457] blk_update_request: I/O error, dev sdg, sector 7634872 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2506.814873] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2506.824353] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 0e 8f e7 00 00 10 00
[ 2506.832217] blk_update_request: I/O error, dev sdg, sector 7634744 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2506.890062] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2506.899543] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 01 91 d0 00 00 10 00
[ 2506.907425] blk_update_request: I/O error, dev sdg, sector 822912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2506.918437] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2506.927911] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 01 91 c0 00 00 10 00
[ 2506.935779] blk_update_request: I/O error, dev sdg, sector 822784 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2506.946775] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2506.956242] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 01 91 b0 00 00 10 00
[ 2506.964106] blk_update_request: I/O error, dev sdg, sector 822656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2506.975086] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2506.984557] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 01 91 a0 00 00 10 00
[ 2506.992415] blk_update_request: I/O error, dev sdg, sector 822528 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2507.003418] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2507.012881] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 01 91 90 00 00 10 00
[ 2507.020746] blk_update_request: I/O error, dev sdg, sector 822400 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2507.031741] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2507.041207] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 01 91 80 00 00 10 00
[ 2507.049073] blk_update_request: I/O error, dev sdg, sector 822272 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2507.060064] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2507.069521] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 01 91 70 00 00 10 00
[ 2507.077381] blk_update_request: I/O error, dev sdg, sector 822144 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2507.088365] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2507.097834] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 01 91 60 00 00 10 00
[ 2507.105695] blk_update_request: I/O error, dev sdg, sector 822016 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2508.273297] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2508.326324] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2508.333978] EXT4-fs (sdg1): I/O error while writing superblock
[ 2509.613627] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2509.714391] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2509.721959] EXT4-fs (sdg1): I/O error while writing superblock
[ 2509.953451] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2510.037306] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2510.044875] EXT4-fs (sdg1): I/O error while writing superblock
[ 2510.098526] EXT4-fs warning: 25 callbacks suppressed
[ 2510.098535] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2889760)
[ 2510.114575] buffer_io_error: 36854 callbacks suppressed
[ 2510.114579] Buffer I/O error on device sdg1, logical block 2887680
[ 2510.126333] Buffer I/O error on device sdg1, logical block 2887681
[ 2510.132700] Buffer I/O error on device sdg1, logical block 2887682
[ 2510.139074] Buffer I/O error on device sdg1, logical block 2887683
[ 2510.145444] Buffer I/O error on device sdg1, logical block 2887684
[ 2510.151812] Buffer I/O error on device sdg1, logical block 2887685
[ 2510.158181] Buffer I/O error on device sdg1, logical block 2887686
[ 2510.164542] Buffer I/O error on device sdg1, logical block 2887687
[ 2510.170902] Buffer I/O error on device sdg1, logical block 2887688
[ 2510.177262] Buffer I/O error on device sdg1, logical block 2887689
[ 2510.306510] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3183648)
[ 2510.317309] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2510.320336] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2510.366257] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2510.373818] EXT4-fs (sdg1): I/O error while writing superblock
[ 2510.379768] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3346128)
[ 2510.428074] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3346464)
[ 2510.480294] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2427468)
[ 2510.538401] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2428163)
[ 2510.628133] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2428960)
[ 2510.639309] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2428898)
[ 2510.699886] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3214145)
[ 2510.752301] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3214368)
[ 2510.837508] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2510.882731] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2510.890295] EXT4-fs (sdg1): I/O error while writing superblock
[ 2511.822378] scsi_io_completion_action: 2458 callbacks suppressed
[ 2511.822411] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2511.838102] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 09 8a 00 00 00 10 00
[ 2511.845977] print_req_error: 2458 callbacks suppressed
[ 2511.845984] blk_update_request: I/O error, dev sdg, sector 5001216 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2511.862389] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2511.871869] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 09 89 f0 00 00 10 00
[ 2511.879735] blk_update_request: I/O error, dev sdg, sector 5001088 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2511.890830] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2511.900305] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 09 89 e0 00 00 10 00
[ 2511.908177] blk_update_request: I/O error, dev sdg, sector 5000960 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2511.919248] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2511.928716] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 09 89 d0 00 00 10 00
[ 2511.936576] blk_update_request: I/O error, dev sdg, sector 5000832 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2511.947647] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2511.957111] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 09 89 c0 00 00 10 00
[ 2511.964975] blk_update_request: I/O error, dev sdg, sector 5000704 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2511.976049] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2511.985521] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 09 89 b0 00 00 10 00
[ 2511.993381] blk_update_request: I/O error, dev sdg, sector 5000576 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2512.004456] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2512.013925] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 09 89 a0 00 00 10 00
[ 2512.021795] blk_update_request: I/O error, dev sdg, sector 5000448 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2512.032869] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2512.042336] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 09 89 90 00 00 10 00
[ 2512.050193] blk_update_request: I/O error, dev sdg, sector 5000320 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2512.061276] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2512.070738] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 09 89 80 00 00 10 00
[ 2512.078602] blk_update_request: I/O error, dev sdg, sector 5000192 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2512.089673] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2512.090127] blk_update_request: I/O error, dev sdg, sector 5003776 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2512.099144] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 09 89 70 00 00 10 00
[ 2513.037312] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2513.142574] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2513.150228] EXT4-fs (sdg1): I/O error while writing superblock
[ 2514.261880] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2514.358372] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2514.365952] EXT4-fs (sdg1): I/O error while writing superblock
[ 2514.621747] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2514.690997] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2514.698990] EXT4-fs (sdg1): I/O error while writing superblock
[ 2514.937127] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2515.019290] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2515.026853] EXT4-fs (sdg1): I/O error while writing superblock
[ 2515.104076] EXT4-fs warning: 34 callbacks suppressed
[ 2515.104090] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 169031)
[ 2515.120049] buffer_io_error: 40950 callbacks suppressed
[ 2515.120054] Buffer I/O error on device sdg1, logical block 167936
[ 2515.131694] Buffer I/O error on device sdg1, logical block 167937
[ 2515.137974] Buffer I/O error on device sdg1, logical block 167938
[ 2515.144245] Buffer I/O error on device sdg1, logical block 167939
[ 2515.150533] Buffer I/O error on device sdg1, logical block 167940
[ 2515.156817] Buffer I/O error on device sdg1, logical block 167941
[ 2515.163091] Buffer I/O error on device sdg1, logical block 167942
[ 2515.169369] Buffer I/O error on device sdg1, logical block 167943
[ 2515.175643] Buffer I/O error on device sdg1, logical block 167944
[ 2515.181923] Buffer I/O error on device sdg1, logical block 167945
[ 2515.338594] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 170016)
[ 2515.389429] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2515.487084] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2515.494717] EXT4-fs (sdg1): I/O error while writing superblock
[ 2515.514782] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 5152)
[ 2515.641945] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2496544)
[ 2515.816305] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2397483)
[ 2515.889908] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2398240)
[ 2516.014394] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1283104)
[ 2516.141971] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1544224)
[ 2516.362285] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1478688)
[ 2516.488485] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1641504)
[ 2516.854310] scsi_io_completion_action: 2413 callbacks suppressed
[ 2516.854337] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2516.870027] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 33 90 e0 00 00 10 00
[ 2516.877904] print_req_error: 2413 callbacks suppressed
[ 2516.877909] blk_update_request: I/O error, dev sdg, sector 27035392 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2516.894395] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2516.903889] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 33 90 d0 00 00 10 00
[ 2516.911767] blk_update_request: I/O error, dev sdg, sector 27035264 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2516.922944] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2516.932409] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 33 90 c0 00 00 10 00
[ 2516.940277] blk_update_request: I/O error, dev sdg, sector 27035136 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2516.951437] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2516.960910] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 33 90 b0 00 00 10 00
[ 2516.968775] blk_update_request: I/O error, dev sdg, sector 27035008 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2516.979944] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2516.989403] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 33 90 a0 00 00 10 00
[ 2516.997266] blk_update_request: I/O error, dev sdg, sector 27034880 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2517.008431] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2517.017899] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 33 90 90 00 00 10 00
[ 2517.025761] blk_update_request: I/O error, dev sdg, sector 27034752 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2517.036941] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2517.046416] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 33 90 80 00 00 10 00
[ 2517.054286] blk_update_request: I/O error, dev sdg, sector 27034624 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2517.065441] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2517.074910] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 33 90 70 00 00 10 00
[ 2517.082773] blk_update_request: I/O error, dev sdg, sector 27034496 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2517.093938] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2517.103402] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 33 90 60 00 00 10 00
[ 2517.111269] blk_update_request: I/O error, dev sdg, sector 27034368 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2517.122433] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2517.122899] blk_update_request: I/O error, dev sdg, sector 27037952 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2517.131911] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 33 90 50 00 00 10 00
[ 2517.513677] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2517.610417] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2517.618207] EXT4-fs (sdg1): I/O error while writing superblock
[ 2518.677576] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2518.678597] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2518.702508] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2518.762435] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2518.769992] EXT4-fs (sdg1): I/O error while writing superblock
[ 2518.842397] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2518.849971] EXT4-fs (sdg1): I/O error while writing superblock
[ 2519.022906] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2519.118323] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2519.125916] EXT4-fs (sdg1): I/O error while writing superblock
[ 2519.353139] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2519.446440] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2519.454017] EXT4-fs (sdg1): I/O error while writing superblock
[ 2519.825161] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2519.879254] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2519.886905] EXT4-fs (sdg1): I/O error while writing superblock
[ 2520.142415] EXT4-fs warning: 22 callbacks suppressed
[ 2520.142425] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3315744)
[ 2520.158472] buffer_io_error: 38018 callbacks suppressed
[ 2520.158478] Buffer I/O error on device sdg1, logical block 3314828
[ 2520.170216] Buffer I/O error on device sdg1, logical block 3314829
[ 2520.176581] Buffer I/O error on device sdg1, logical block 3314830
[ 2520.182947] Buffer I/O error on device sdg1, logical block 3314831
[ 2520.189310] Buffer I/O error on device sdg1, logical block 3314832
[ 2520.195668] Buffer I/O error on device sdg1, logical block 3314833
[ 2520.202031] Buffer I/O error on device sdg1, logical block 3314834
[ 2520.208402] Buffer I/O error on device sdg1, logical block 3314835
[ 2520.214760] Buffer I/O error on device sdg1, logical block 3314836
[ 2520.221125] Buffer I/O error on device sdg1, logical block 3314837
[ 2520.394366] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2561056)
[ 2520.566635] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1642528)
[ 2520.898520] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3479584)
[ 2521.082683] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 791584)
[ 2521.254549] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3381280)
[ 2521.586505] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2103328)
[ 2521.770581] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1610784)
[ 2521.866340] scsi_io_completion_action: 2140 callbacks suppressed
[ 2521.866368] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2521.882048] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 34 0e a0 00 00 10 00
[ 2521.889934] print_req_error: 2140 callbacks suppressed
[ 2521.889941] blk_update_request: I/O error, dev sdg, sector 27292928 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2521.906425] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2521.915910] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 34 0e 90 00 00 10 00
[ 2521.923782] blk_update_request: I/O error, dev sdg, sector 27292800 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2521.934961] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2521.944430] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 34 0e 80 00 00 10 00
[ 2521.952296] blk_update_request: I/O error, dev sdg, sector 27292672 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2521.963458] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2521.972928] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 34 0e 70 00 00 10 00
[ 2521.980789] blk_update_request: I/O error, dev sdg, sector 27292544 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2521.991952] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2522.001416] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 34 0e 60 00 00 10 00
[ 2522.009278] blk_update_request: I/O error, dev sdg, sector 27292416 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2522.017354] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2522.020440] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2522.041422] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 34 0e 50 00 00 10 00
[ 2522.049288] blk_update_request: I/O error, dev sdg, sector 27292288 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2522.060451] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2522.069912] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 34 0e 40 00 00 10 00
[ 2522.077767] blk_update_request: I/O error, dev sdg, sector 27292160 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2522.088938] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2522.098400] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 34 0e 30 00 00 10 00
[ 2522.106266] blk_update_request: I/O error, dev sdg, sector 27292032 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2522.117434] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2522.126816] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 34 0e 20 00 00 10 00
[ 2522.134593] blk_update_request: I/O error, dev sdg, sector 27291904 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2522.145770] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2522.146158] blk_update_request: I/O error, dev sdg, sector 27295488 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2522.155140] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 34 0e 10 00 00 10 00
[ 2522.189890] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2522.197461] EXT4-fs (sdg1): I/O error while writing superblock
[ 2522.206103] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3412000)
[ 2522.294756] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 200736)
[ 2523.338764] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2523.422371] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2523.430028] EXT4-fs (sdg1): I/O error while writing superblock
[ 2523.637958] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2523.677588] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2523.685438] EXT4-fs (sdg1): I/O error while writing superblock
[ 2523.705120] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2523.754385] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2523.761954] EXT4-fs (sdg1): I/O error while writing superblock
[ 2523.946814] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2524.031678] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2524.039328] EXT4-fs (sdg1): I/O error while writing superblock
[ 2524.425330] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2524.506382] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2524.514105] EXT4-fs (sdg1): I/O error while writing superblock
[ 2525.326360] EXT4-fs warning: 20 callbacks suppressed
[ 2525.326375] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3086368)
[ 2525.342418] buffer_io_error: 35690 callbacks suppressed
[ 2525.342422] Buffer I/O error on device sdg1, logical block 3084288
[ 2525.354169] Buffer I/O error on device sdg1, logical block 3084289
[ 2525.360551] Buffer I/O error on device sdg1, logical block 3084290
[ 2525.366922] Buffer I/O error on device sdg1, logical block 3084291
[ 2525.373298] Buffer I/O error on device sdg1, logical block 3084292
[ 2525.379670] Buffer I/O error on device sdg1, logical block 3084293
[ 2525.386035] Buffer I/O error on device sdg1, logical block 3084294
[ 2525.392390] Buffer I/O error on device sdg1, logical block 3084295
[ 2525.398746] Buffer I/O error on device sdg1, logical block 3084296
[ 2525.405101] Buffer I/O error on device sdg1, logical block 3084297
[ 2525.587280] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 107552)
[ 2525.762530] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1611808)
[ 2526.078445] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 921632)
[ 2526.262516] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1346592)
[ 2526.434610] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2756640)
[ 2526.633262] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2526.710321] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1744899)
[ 2526.728468] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2526.736034] EXT4-fs (sdg1): I/O error while writing superblock
[ 2526.754577] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1744928)
[ 2526.850671] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3382304)
[ 2526.886959] scsi_io_completion_action: 2307 callbacks suppressed
[ 2526.886987] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2526.902614] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 1d 8d e0 00 00 10 00
[ 2526.910403] print_req_error: 2307 callbacks suppressed
[ 2526.910410] blk_update_request: I/O error, dev sdg, sector 15494912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2526.928643] sd 0:0:0:6: [sdg] tag#7 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2526.938045] sd 0:0:0:6: [sdg] tag#7 CDB: opcode=0x2a 2a 00 00 1d 8d f0 00 00 10 00
[ 2526.945826] blk_update_request: I/O error, dev sdg, sector 15495040 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2526.974386] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2526.983886] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 1d 8e e0 00 00 10 00
[ 2526.991776] blk_update_request: I/O error, dev sdg, sector 15496960 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.002959] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2527.012429] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 1d 8e d0 00 00 10 00
[ 2527.020298] blk_update_request: I/O error, dev sdg, sector 15496832 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.031471] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2527.040942] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 1d 8e c0 00 00 10 00
[ 2527.048812] blk_update_request: I/O error, dev sdg, sector 15496704 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.059973] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2527.069443] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 1d 8e b0 00 00 10 00
[ 2527.077302] blk_update_request: I/O error, dev sdg, sector 15496576 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.088479] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2527.097942] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 1d 8e a0 00 00 10 00
[ 2527.105806] blk_update_request: I/O error, dev sdg, sector 15496448 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.116979] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2527.126446] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 1d 8e 90 00 00 10 00
[ 2527.134305] blk_update_request: I/O error, dev sdg, sector 15496320 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.145484] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2527.154954] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 1d 8e 80 00 00 10 00
[ 2527.162814] blk_update_request: I/O error, dev sdg, sector 15496192 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.173975] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2527.174394] blk_update_request: I/O error, dev sdg, sector 15499136 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2527.183353] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 1d 8e 70 00 00 10 00
[ 2527.222339] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1937440)
[ 2527.934430] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2528.022495] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2528.030150] EXT4-fs (sdg1): I/O error while writing superblock
[ 2528.118630] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2528.289139] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2528.386463] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2528.394054] EXT4-fs (sdg1): I/O error while writing superblock
[ 2528.605424] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2528.654241] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2528.662060] EXT4-fs (sdg1): I/O error while writing superblock
[ 2529.125198] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2529.210510] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2529.218106] EXT4-fs (sdg1): I/O error while writing superblock
[ 2530.510182] EXT4-fs warning: 21 callbacks suppressed
[ 2530.510191] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1675296)
[ 2530.526256] buffer_io_error: 36854 callbacks suppressed
[ 2530.526264] Buffer I/O error on device sdg1, logical block 1673216
[ 2530.538030] Buffer I/O error on device sdg1, logical block 1673217
[ 2530.544392] Buffer I/O error on device sdg1, logical block 1673218
[ 2530.550742] Buffer I/O error on device sdg1, logical block 1673219
[ 2530.557100] Buffer I/O error on device sdg1, logical block 1673220
[ 2530.563458] Buffer I/O error on device sdg1, logical block 1673221
[ 2530.569815] Buffer I/O error on device sdg1, logical block 1673222
[ 2530.576169] Buffer I/O error on device sdg1, logical block 1673223
[ 2530.582523] Buffer I/O error on device sdg1, logical block 1673224
[ 2530.588871] Buffer I/O error on device sdg1, logical block 1673225
[ 2530.754767] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2329632)
[ 2530.919708] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3383328)
[ 2531.138566] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2105376)
[ 2531.265328] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2531.306528] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1612832)
[ 2531.370976] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2531.379284] EXT4-fs (sdg1): I/O error while writing superblock
[ 2531.467300] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 628768)
[ 2531.783240] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1546272)
[ 2531.953318] scsi_io_completion_action: 2252 callbacks suppressed
[ 2531.953358] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2531.969004] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 16 93 a0 00 00 10 00
[ 2531.976790] print_req_error: 2252 callbacks suppressed
[ 2531.976797] blk_update_request: I/O error, dev sdg, sector 11836672 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2531.993268] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.002658] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 16 93 90 00 00 10 00
[ 2532.010435] blk_update_request: I/O error, dev sdg, sector 11836544 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.021601] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.030978] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 16 93 80 00 00 10 00
[ 2532.038755] blk_update_request: I/O error, dev sdg, sector 11836416 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.049917] sd 0:0:0:6: [sdg] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.059288] sd 0:0:0:6: [sdg] tag#4 CDB: opcode=0x2a 2a 00 00 16 93 70 00 00 10 00
[ 2532.067062] blk_update_request: I/O error, dev sdg, sector 11836288 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.078231] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.087610] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 16 93 60 00 00 10 00
[ 2532.095383] blk_update_request: I/O error, dev sdg, sector 11836160 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.106544] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.107579] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.115918] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 16 93 50 00 00 10 00
[ 2532.115921] blk_update_request: I/O error, dev sdg, sector 11836032 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.115927] sd 0:0:0:6: [sdg] tag#7 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.125297] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 30 9c a0 00 00 10 00
[ 2532.133060] sd 0:0:0:6: [sdg] tag#7 CDB: opcode=0x2a 2a 00 00 16 93 40 00 00 10 00
[ 2532.133064] blk_update_request: I/O error, dev sdg, sector 11835904 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.133070] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.133073] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 16 93 30 00 00 10 00
[ 2532.144229] blk_update_request: I/O error, dev sdg, sector 25486592 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.153602] blk_update_request: I/O error, dev sdg, sector 11835776 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.153608] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2532.153610] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 16 93 20 00 00 10 00
[ 2532.161395] blk_update_request: I/O error, dev sdg, sector 25486464 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2532.248116] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1479712)
[ 2532.355525] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3186720)
[ 2532.557596] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2532.634043] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2532.642038] EXT4-fs (sdg1): I/O error while writing superblock
[ 2532.643371] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2232352)
[ 2532.748109] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2532.913282] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2532.962532] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2532.970132] EXT4-fs (sdg1): I/O error while writing superblock
[ 2532.973494] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2533.027488] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2533.035076] EXT4-fs (sdg1): I/O error while writing superblock
[ 2533.241112] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2533.305257] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2533.312898] EXT4-fs (sdg1): I/O error while writing superblock
[ 2533.733144] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2533.798383] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2533.805950] EXT4-fs (sdg1): I/O error while writing superblock
[ 2535.618537] EXT4-fs warning: 19 callbacks suppressed
[ 2535.618552] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3055648)
[ 2535.634605] buffer_io_error: 36854 callbacks suppressed
[ 2535.634608] Buffer I/O error on device sdg1, logical block 3053568
[ 2535.646343] Buffer I/O error on device sdg1, logical block 3053569
[ 2535.652701] Buffer I/O error on device sdg1, logical block 3053570
[ 2535.659059] Buffer I/O error on device sdg1, logical block 3053571
[ 2535.665413] Buffer I/O error on device sdg1, logical block 3053572
[ 2535.671768] Buffer I/O error on device sdg1, logical block 3053573
[ 2535.678118] Buffer I/O error on device sdg1, logical block 3053574
[ 2535.684472] Buffer I/O error on device sdg1, logical block 3053575
[ 2535.690827] Buffer I/O error on device sdg1, logical block 3053576
[ 2535.697183] Buffer I/O error on device sdg1, logical block 3053577
[ 2535.877287] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2535.890451] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2792480)
[ 2535.962580] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2535.970172] EXT4-fs (sdg1): I/O error while writing superblock
[ 2536.050602] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1480736)
[ 2536.366475] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1644576)
[ 2536.566648] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3480608)
[ 2536.738564] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 331808)
[ 2536.987203] scsi_io_completion_action: 2220 callbacks suppressed
[ 2536.987234] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.002947] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 14 0e 70 00 00 10 00
[ 2537.010823] print_req_error: 2220 callbacks suppressed
[ 2537.010829] blk_update_request: I/O error, dev sdg, sector 10515328 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.027332] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.036802] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 14 0e 60 00 00 10 00
[ 2537.044672] blk_update_request: I/O error, dev sdg, sector 10515200 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.055836] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.065299] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 14 0e 50 00 00 10 00
[ 2537.073166] blk_update_request: I/O error, dev sdg, sector 10515072 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.084328] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.093799] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 14 0e 40 00 00 10 00
[ 2537.101663] blk_update_request: I/O error, dev sdg, sector 10514944 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.112827] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.122287] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 14 0e 30 00 00 10 00
[ 2537.130156] blk_update_request: I/O error, dev sdg, sector 10514816 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.141330] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.150796] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 14 0e 20 00 00 10 00
[ 2537.158658] blk_update_request: I/O error, dev sdg, sector 10514688 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.169822] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.179287] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 14 0e 10 00 00 10 00
[ 2537.185205] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2537.187158] blk_update_request: I/O error, dev sdg, sector 10514560 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.209815] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.219284] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 14 0e 00 00 00 10 00
[ 2537.227142] blk_update_request: I/O error, dev sdg, sector 10514432 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.238316] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.247783] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 14 0d f0 00 00 10 00
[ 2537.255645] blk_update_request: I/O error, dev sdg, sector 10514304 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.266812] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2537.267432] blk_update_request: I/O error, dev sdg, sector 10517832 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2537.276286] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 14 0d e0 00 00 10 00
[ 2537.304128] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1314521)
[ 2537.323195] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2537.330762] EXT4-fs (sdg1): I/O error while writing superblock
[ 2537.335012] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1314848)
[ 2537.398516] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1805344)
[ 2537.499182] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2564128)
[ 2537.533509] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2537.586991] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2537.594589] EXT4-fs (sdg1): I/O error while writing superblock
[ 2537.605241] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2537.674003] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2537.681617] EXT4-fs (sdg1): I/O error while writing superblock
[ 2537.861229] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2537.950394] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2537.957969] EXT4-fs (sdg1): I/O error while writing superblock
[ 2538.373180] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2538.462174] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2538.469773] EXT4-fs (sdg1): I/O error while writing superblock
[ 2540.597837] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2540.703317] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2540.710937] EXT4-fs (sdg1): I/O error while writing superblock
[ 2540.763246] EXT4-fs warning: 17 callbacks suppressed
[ 2540.763266] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3481632)
[ 2540.779351] buffer_io_error: 35830 callbacks suppressed
[ 2540.779359] Buffer I/O error on device sdg1, logical block 3480576
[ 2540.791132] Buffer I/O error on device sdg1, logical block 3480577
[ 2540.797498] Buffer I/O error on device sdg1, logical block 3480578
[ 2540.803865] Buffer I/O error on device sdg1, logical block 3480579
[ 2540.810225] Buffer I/O error on device sdg1, logical block 3480580
[ 2540.816594] Buffer I/O error on device sdg1, logical block 3480581
[ 2540.822952] Buffer I/O error on device sdg1, logical block 3480582
[ 2540.829323] Buffer I/O error on device sdg1, logical block 3480583
[ 2540.835683] Buffer I/O error on device sdg1, logical block 3480584
[ 2540.842046] Buffer I/O error on device sdg1, logical block 3480585
[ 2541.082357] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 794656)
[ 2541.238507] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3087392)
[ 2541.411448] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1806368)
[ 2541.759040] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1220640)
[ 2541.877568] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2541.942459] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1575968)
[ 2541.956108] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2541.986444] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2541.994018] EXT4-fs (sdg1): I/O error while writing superblock
[ 2541.995702] scsi_io_completion_action: 2177 callbacks suppressed
[ 2541.995721] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.015693] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 05 9d f0 00 00 10 00
[ 2542.023571] print_req_error: 2177 callbacks suppressed
[ 2542.023578] blk_update_request: I/O error, dev sdg, sector 2944896 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.039980] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.049462] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 05 9d e0 00 00 10 00
[ 2542.057331] blk_update_request: I/O error, dev sdg, sector 2944768 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.068416] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.077883] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 05 9d d0 00 00 10 00
[ 2542.085742] blk_update_request: I/O error, dev sdg, sector 2944640 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.096810] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.106277] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 05 9d c0 00 00 10 00
[ 2542.114141] blk_update_request: I/O error, dev sdg, sector 2944512 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.125233] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.134703] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 05 9d b0 00 00 10 00
[ 2542.142561] blk_update_request: I/O error, dev sdg, sector 2944384 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.153650] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.163116] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 05 9d a0 00 00 10 00
[ 2542.170978] blk_update_request: I/O error, dev sdg, sector 2944256 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.183563] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.193077] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 05 9f 90 00 00 10 00
[ 2542.200973] blk_update_request: I/O error, dev sdg, sector 2948224 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.209273] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2542.212065] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.233047] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 05 9f 80 00 00 10 00
[ 2542.240929] blk_update_request: I/O error, dev sdg, sector 2948096 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.252018] sd 0:0:0:6: [sdg] tag#14 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.261486] sd 0:0:0:6: [sdg] tag#14 CDB: opcode=0x2a 2a 00 00 05 9f 70 00 00 10 00
[ 2542.269348] blk_update_request: I/O error, dev sdg, sector 2947968 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.280428] sd 0:0:0:6: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2542.289895] sd 0:0:0:6: [sdg] tag#15 CDB: opcode=0x2a 2a 00 00 05 9f 60 00 00 10 00
[ 2542.297761] blk_update_request: I/O error, dev sdg, sector 2947840 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2542.342356] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2542.349913] EXT4-fs (sdg1): I/O error while writing superblock
[ 2542.366401] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 368672)
[ 2542.502338] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 829472)
[ 2542.541250] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2542.609306] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2542.616889] EXT4-fs (sdg1): I/O error while writing superblock
[ 2542.666916] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 893984)
[ 2542.806550] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2891808)
[ 2543.129255] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2543.174552] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2543.182116] EXT4-fs (sdg1): I/O error while writing superblock
[ 2545.361344] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2545.446365] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2545.453947] EXT4-fs (sdg1): I/O error while writing superblock
[ 2545.886567] EXT4-fs warning: 18 callbacks suppressed
[ 2545.886587] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3447840)
[ 2545.902630] buffer_io_error: 35830 callbacks suppressed
[ 2545.902635] Buffer I/O error on device sdg1, logical block 3446784
[ 2545.914373] Buffer I/O error on device sdg1, logical block 3446785
[ 2545.920735] Buffer I/O error on device sdg1, logical block 3446786
[ 2545.927100] Buffer I/O error on device sdg1, logical block 3446787
[ 2545.933457] Buffer I/O error on device sdg1, logical block 3446788
[ 2545.939824] Buffer I/O error on device sdg1, logical block 3446789
[ 2545.946194] Buffer I/O error on device sdg1, logical block 3446790
[ 2545.952560] Buffer I/O error on device sdg1, logical block 3446791
[ 2545.958918] Buffer I/O error on device sdg1, logical block 3446792
[ 2545.965283] Buffer I/O error on device sdg1, logical block 3446793
[ 2546.138490] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1576992)
[ 2546.388178] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2297594)
[ 2546.470533] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2297888)
[ 2546.650914] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 201760)
[ 2546.653480] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2546.746528] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2546.754115] EXT4-fs (sdg1): I/O error while writing superblock
[ 2546.808122] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 895008)
[ 2546.985512] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2547.030353] scsi_io_completion_action: 2209 callbacks suppressed
[ 2547.030381] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.045977] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 23 97 d0 00 00 10 00
[ 2547.053767] print_req_error: 2209 callbacks suppressed
[ 2547.053772] blk_update_request: I/O error, dev sdg, sector 18660992 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.071934] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.081447] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 04 a8 c0 00 00 10 00
[ 2547.089342] blk_update_request: I/O error, dev sdg, sector 2442752 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.100461] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.109944] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 04 a8 b0 00 00 10 00
[ 2547.117823] blk_update_request: I/O error, dev sdg, sector 2442624 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.128930] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.138399] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 04 a8 a0 00 00 10 00
[ 2547.146265] blk_update_request: I/O error, dev sdg, sector 2442496 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.157341] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.166814] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 04 a8 90 00 00 10 00
[ 2547.174679] blk_update_request: I/O error, dev sdg, sector 2442368 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.185747] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.195212] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 04 a8 80 00 00 10 00
[ 2547.203073] blk_update_request: I/O error, dev sdg, sector 2442240 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.214145] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.223621] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 04 a8 70 00 00 10 00
[ 2547.231484] blk_update_request: I/O error, dev sdg, sector 2442112 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.242556] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.252022] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 04 a8 60 00 00 10 00
[ 2547.259886] blk_update_request: I/O error, dev sdg, sector 2441984 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.270958] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.280337] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 04 a8 50 00 00 10 00
[ 2547.288107] blk_update_request: I/O error, dev sdg, sector 2441856 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2547.299182] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2547.299502] blk_update_request: I/O error, dev sdg, sector 256 op 0x1:(WRITE) flags 0x23800 phys_seg 1 prio class 0
[ 2547.308557] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 04 a8 40 00 00 10 00
[ 2547.308594] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2332704)
[ 2547.319282] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2547.345508] EXT4-fs (sdg1): I/O error while writing superblock
[ 2547.373495] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 306208)
[ 2547.449547] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 139296)
[ 2547.568947] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 3579936)
[ 2547.885459] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2547.942318] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2547.949898] EXT4-fs (sdg1): I/O error while writing superblock
[ 2550.101539] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2550.166324] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2550.173894] EXT4-fs (sdg1): I/O error while writing superblock
[ 2551.002541] EXT4-fs warning: 25 callbacks suppressed
[ 2551.002557] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2757664)
[ 2551.018598] buffer_io_error: 36854 callbacks suppressed
[ 2551.018602] Buffer I/O error on device sdg1, logical block 2756608
[ 2551.030350] Buffer I/O error on device sdg1, logical block 2756609
[ 2551.036722] Buffer I/O error on device sdg1, logical block 2756610
[ 2551.043100] Buffer I/O error on device sdg1, logical block 2756611
[ 2551.049469] Buffer I/O error on device sdg1, logical block 2756612
[ 2551.055834] Buffer I/O error on device sdg1, logical block 2756613
[ 2551.062197] Buffer I/O error on device sdg1, logical block 2756614
[ 2551.068552] Buffer I/O error on device sdg1, logical block 2756615
[ 2551.074908] Buffer I/O error on device sdg1, logical block 2756616
[ 2551.081267] Buffer I/O error on device sdg1, logical block 2756617
[ 2551.089005] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2551.254457] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 307232)
[ 2551.345435] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2551.422571] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2551.430145] EXT4-fs (sdg1): I/O error while writing superblock
[ 2551.583155] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2463776)
[ 2551.665728] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2551.742448] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2551.750020] EXT4-fs (sdg1): I/O error while writing superblock
[ 2551.751889] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 660512)
[ 2551.884465] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2797600)
[ 2551.961551] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2552.026309] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2552.033886] EXT4-fs (sdg1): I/O error while writing superblock
[ 2552.050386] scsi_io_completion_action: 2273 callbacks suppressed
[ 2552.050406] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.066072] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 08 9e 80 00 00 10 00
[ 2552.073947] print_req_error: 2273 callbacks suppressed
[ 2552.073952] blk_update_request: I/O error, dev sdg, sector 4518912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.090343] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.099831] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 08 9e 70 00 00 10 00
[ 2552.107699] blk_update_request: I/O error, dev sdg, sector 4518784 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.118786] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.128257] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 08 9e 60 00 00 10 00
[ 2552.136127] blk_update_request: I/O error, dev sdg, sector 4518656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.147201] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.156669] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 08 9e 50 00 00 10 00
[ 2552.164535] blk_update_request: I/O error, dev sdg, sector 4518528 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.175615] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.185081] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 08 9e 40 00 00 10 00
[ 2552.192941] blk_update_request: I/O error, dev sdg, sector 4518400 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.204016] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.213481] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 08 9e 30 00 00 10 00
[ 2552.221339] blk_update_request: I/O error, dev sdg, sector 4518272 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.232428] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.241898] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 08 9e 20 00 00 10 00
[ 2552.249767] blk_update_request: I/O error, dev sdg, sector 4518144 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.260841] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.261163] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.270218] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 08 9e 10 00 00 10 00
[ 2552.279694] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 08 9f 90 00 00 10 00
[ 2552.287461] blk_update_request: I/O error, dev sdg, sector 4518016 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.287471] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2552.295323] blk_update_request: I/O error, dev sdg, sector 4521088 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.326811] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 08 9e 00 00 00 10 00
[ 2552.334594] blk_update_request: I/O error, dev sdg, sector 4517888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2552.390545] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 565280)
[ 2552.450521] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1776672)
[ 2552.514599] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2431008)
[ 2552.541498] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2552.586597] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2552.594183] EXT4-fs (sdg1): I/O error while writing superblock
[ 2552.670582] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3416096)
[ 2552.762391] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3386400)
[ 2554.761354] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2554.830228] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2554.837890] EXT4-fs (sdg1): I/O error while writing superblock
[ 2556.009400] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2556.070299] EXT4-fs warning: 19 callbacks suppressed
[ 2556.070310] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 44064)
[ 2556.086152] buffer_io_error: 36854 callbacks suppressed
[ 2556.086155] Buffer I/O error on device sdg1, logical block 43008
[ 2556.097714] Buffer I/O error on device sdg1, logical block 43009
[ 2556.103894] Buffer I/O error on device sdg1, logical block 43010
[ 2556.110078] Buffer I/O error on device sdg1, logical block 43011
[ 2556.116264] Buffer I/O error on device sdg1, logical block 43012
[ 2556.122446] Buffer I/O error on device sdg1, logical block 43013
[ 2556.128623] Buffer I/O error on device sdg1, logical block 43014
[ 2556.134808] Buffer I/O error on device sdg1, logical block 43015
[ 2556.140991] Buffer I/O error on device sdg1, logical block 43016
[ 2556.147163] Buffer I/O error on device sdg1, logical block 43017
[ 2556.166784] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2556.174389] EXT4-fs (sdg1): I/O error while writing superblock
[ 2556.234350] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1777696)
[ 2556.321765] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2556.370357] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2556.377943] EXT4-fs (sdg1): I/O error while writing superblock
[ 2556.389315] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2556.442539] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1028128)
[ 2556.463513] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2556.471122] EXT4-fs (sdg1): I/O error while writing superblock
[ 2556.550495] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 3484704)
[ 2556.614112] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2556.654445] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3387424)
[ 2556.684456] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2556.692123] EXT4-fs (sdg1): I/O error while writing superblock
[ 2556.791389] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2433056)
[ 2556.908256] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 203808)
[ 2557.038684] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2824224)
[ 2557.070446] scsi_io_completion_action: 2470 callbacks suppressed
[ 2557.070472] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.086163] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 07 91 10 00 00 10 00
[ 2557.094041] print_req_error: 2470 callbacks suppressed
[ 2557.094046] blk_update_request: I/O error, dev sdg, sector 3967104 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.110452] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.119926] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 07 91 00 00 00 10 00
[ 2557.127795] blk_update_request: I/O error, dev sdg, sector 3966976 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.129111] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2557.138887] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.138892] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 07 90 f0 00 00 10 00
[ 2557.167724] blk_update_request: I/O error, dev sdg, sector 3966848 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.178808] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.188273] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 07 90 e0 00 00 10 00
[ 2557.196137] blk_update_request: I/O error, dev sdg, sector 3966720 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.207211] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.216677] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 07 90 d0 00 00 10 00
[ 2557.224545] blk_update_request: I/O error, dev sdg, sector 3966592 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.235638] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.245101] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 07 90 c0 00 00 10 00
[ 2557.252968] blk_update_request: I/O error, dev sdg, sector 3966464 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.264048] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.265007] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.273432] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 07 90 b0 00 00 10 00
[ 2557.282902] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 07 92 10 00 00 10 00
[ 2557.290669] blk_update_request: I/O error, dev sdg, sector 3966336 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.290680] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.298546] blk_update_request: I/O error, dev sdg, sector 3969152 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.309607] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 07 90 a0 00 00 10 00
[ 2557.309610] blk_update_request: I/O error, dev sdg, sector 3966208 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.309615] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2557.319006] blk_update_request: I/O error, dev sdg, sector 3969024 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2557.330069] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 07 90 90 00 00 10 00
[ 2557.378465] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2557.386215] EXT4-fs (sdg1): I/O error while writing superblock
[ 2557.461310] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 497696)
[ 2557.556199] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2665504)
[ 2559.253315] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2559.334291] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2559.341881] EXT4-fs (sdg1): I/O error while writing superblock
[ 2559.734824] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2560.489615] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2560.547063] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2560.554749] EXT4-fs (sdg1): I/O error while writing superblock
[ 2560.805822] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2560.874325] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2560.881992] EXT4-fs (sdg1): I/O error while writing superblock
[ 2561.089655] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2561.126992] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2561.134588] EXT4-fs (sdg1): I/O error while writing superblock
[ 2561.206504] EXT4-fs warning: 20 callbacks suppressed
[ 2561.206519] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2109472)
[ 2561.222588] buffer_io_error: 38902 callbacks suppressed
[ 2561.222593] Buffer I/O error on device sdg1, logical block 2107392
[ 2561.234334] Buffer I/O error on device sdg1, logical block 2107393
[ 2561.240707] Buffer I/O error on device sdg1, logical block 2107394
[ 2561.247078] Buffer I/O error on device sdg1, logical block 2107395
[ 2561.253453] Buffer I/O error on device sdg1, logical block 2107396
[ 2561.259816] Buffer I/O error on device sdg1, logical block 2107397
[ 2561.266184] Buffer I/O error on device sdg1, logical block 2107398
[ 2561.272552] Buffer I/O error on device sdg1, logical block 2107399
[ 2561.278909] Buffer I/O error on device sdg1, logical block 2107400
[ 2561.285263] Buffer I/O error on device sdg1, logical block 2107401
[ 2561.387144] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2759712)
[ 2561.522463] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2666528)
[ 2561.605964] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2561.643344] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2561.650965] EXT4-fs (sdg1): I/O error while writing superblock
[ 2561.665519] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 989216)
[ 2561.766555] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2167840)
[ 2561.886681] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 630816)
[ 2562.106386] scsi_io_completion_action: 2422 callbacks suppressed
[ 2562.106419] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.122115] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 35 20 20 00 00 10 00
[ 2562.129986] print_req_error: 2422 callbacks suppressed
[ 2562.129992] blk_update_request: I/O error, dev sdg, sector 27853056 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.146476] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.155943] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 19 20 10 00 00 10 00
[ 2562.163816] blk_update_request: I/O error, dev sdg, sector 13172864 op 0x1:(WRITE) flags 0x0 phys_seg 16 prio class 0
[ 2562.174712] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1646624)
[ 2562.185639] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.195107] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 19 20 00 00 00 10 00
[ 2562.202965] blk_update_request: I/O error, dev sdg, sector 13172736 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.214130] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.223596] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 19 1f f0 00 00 10 00
[ 2562.231460] blk_update_request: I/O error, dev sdg, sector 13172608 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.242624] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.252088] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 19 1f e0 00 00 10 00
[ 2562.259953] blk_update_request: I/O error, dev sdg, sector 13172480 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.271119] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.280592] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 19 1f d0 00 00 10 00
[ 2562.288454] blk_update_request: I/O error, dev sdg, sector 13172352 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.299614] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.309075] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 19 1f c0 00 00 10 00
[ 2562.316942] blk_update_request: I/O error, dev sdg, sector 13172224 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.328111] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.337580] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 19 1f b0 00 00 10 00
[ 2562.345444] blk_update_request: I/O error, dev sdg, sector 13172096 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.356607] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.356884] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2562.365976] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 19 1f a0 00 00 10 00
[ 2562.375449] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 35 21 c0 00 00 10 00
[ 2562.383222] blk_update_request: I/O error, dev sdg, sector 13171968 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.383228] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1646615)
[ 2562.413135] blk_update_request: I/O error, dev sdg, sector 27856384 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2562.484166] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3482656)
[ 2562.604433] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1288224)
[ 2563.641510] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2563.702291] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2563.709922] EXT4-fs (sdg1): I/O error while writing superblock
[ 2564.837778] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2564.894941] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2564.902503] EXT4-fs (sdg1): I/O error while writing superblock
[ 2565.125286] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2565.166259] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2565.173828] EXT4-fs (sdg1): I/O error while writing superblock
[ 2565.389478] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2565.446286] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2565.453864] EXT4-fs (sdg1): I/O error while writing superblock
[ 2565.873326] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2565.925993] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2565.933568] EXT4-fs (sdg1): I/O error while writing superblock
[ 2566.235726] EXT4-fs warning: 24 callbacks suppressed
[ 2566.235744] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 796704)
[ 2566.251724] buffer_io_error: 40950 callbacks suppressed
[ 2566.251730] Buffer I/O error on device sdg1, logical block 794624
[ 2566.263372] Buffer I/O error on device sdg1, logical block 794625
[ 2566.269658] Buffer I/O error on device sdg1, logical block 794626
[ 2566.275939] Buffer I/O error on device sdg1, logical block 794627
[ 2566.282215] Buffer I/O error on device sdg1, logical block 794628
[ 2566.288486] Buffer I/O error on device sdg1, logical block 794629
[ 2566.294763] Buffer I/O error on device sdg1, logical block 794630
[ 2566.301044] Buffer I/O error on device sdg1, logical block 794631
[ 2566.307314] Buffer I/O error on device sdg1, logical block 794632
[ 2566.313590] Buffer I/O error on device sdg1, logical block 794633
[ 2566.488364] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3089440)
[ 2566.656416] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2566176)
[ 2566.972353] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1517600)
[ 2567.154786] scsi_io_completion_action: 2341 callbacks suppressed
[ 2567.154818] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.170537] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 05 a3 10 00 00 10 00
[ 2567.178418] print_req_error: 2341 callbacks suppressed
[ 2567.178426] blk_update_request: I/O error, dev sdg, sector 2955392 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.194836] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.204317] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 05 a3 00 00 00 10 00
[ 2567.212180] blk_update_request: I/O error, dev sdg, sector 2955264 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.223271] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.232740] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 05 a2 f0 00 00 10 00
[ 2567.240610] blk_update_request: I/O error, dev sdg, sector 2955136 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.251682] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.261155] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 05 a2 e0 00 00 10 00
[ 2567.269016] blk_update_request: I/O error, dev sdg, sector 2955008 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.280095] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.289567] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 05 a2 d0 00 00 10 00
[ 2567.297437] blk_update_request: I/O error, dev sdg, sector 2954880 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.308506] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.317973] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 05 a2 c0 00 00 10 00
[ 2567.325837] blk_update_request: I/O error, dev sdg, sector 2954752 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.336911] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.346371] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 05 a2 b0 00 00 10 00
[ 2567.354237] blk_update_request: I/O error, dev sdg, sector 2954624 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.365311] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.374783] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 05 a2 a0 00 00 10 00
[ 2567.382639] blk_update_request: I/O error, dev sdg, sector 2954496 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.393722] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.403102] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 05 a2 90 00 00 10 00
[ 2567.410877] blk_update_request: I/O error, dev sdg, sector 2954368 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.421948] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2567.422308] blk_update_request: I/O error, dev sdg, sector 25518720 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2567.431326] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 05 a2 80 00 00 10 00
[ 2567.451633] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 369696)
[ 2567.482469] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3190816)
[ 2567.536490] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1223908)
[ 2567.585732] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1224736)
[ 2567.684057] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 240672)
[ 2567.780097] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 137248)
[ 2567.865799] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2567.915242] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2567.922826] EXT4-fs (sdg1): I/O error while writing superblock
[ 2567.984420] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2569.005443] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2569.098938] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2569.106553] EXT4-fs (sdg1): I/O error while writing superblock
[ 2569.277468] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2569.330068] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2569.337644] EXT4-fs (sdg1): I/O error while writing superblock
[ 2569.537256] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2569.569694] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2569.577254] EXT4-fs (sdg1): I/O error while writing superblock
[ 2570.021489] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2570.122690] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2570.130279] EXT4-fs (sdg1): I/O error while writing superblock
[ 2571.303117] EXT4-fs warning: 24 callbacks suppressed
[ 2571.303134] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1225760)
[ 2571.319214] buffer_io_error: 42998 callbacks suppressed
[ 2571.319219] Buffer I/O error on device sdg1, logical block 1224704
[ 2571.330957] Buffer I/O error on device sdg1, logical block 1224705
[ 2571.337336] Buffer I/O error on device sdg1, logical block 1224706
[ 2571.343702] Buffer I/O error on device sdg1, logical block 1224707
[ 2571.350070] Buffer I/O error on device sdg1, logical block 1224708
[ 2571.356442] Buffer I/O error on device sdg1, logical block 1224709
[ 2571.362816] Buffer I/O error on device sdg1, logical block 1224710
[ 2571.369191] Buffer I/O error on device sdg1, logical block 1224711
[ 2571.375557] Buffer I/O error on device sdg1, logical block 1224712
[ 2571.381917] Buffer I/O error on device sdg1, logical block 1224713
[ 2571.527083] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2795552)
[ 2571.802518] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 405214)
[ 2571.886700] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 405536)
[ 2571.961360] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2572.034523] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2501664)
[ 2572.066416] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2572.073981] EXT4-fs (sdg1): I/O error while writing superblock
[ 2572.154446] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2267168)
[ 2572.186480] scsi_io_completion_action: 2670 callbacks suppressed
[ 2572.186509] sd 0:0:0:6: [sdg] tag#7 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.202118] sd 0:0:0:6: [sdg] tag#7 CDB: opcode=0x2a 2a 00 00 0c b9 f0 00 00 10 00
[ 2572.209912] print_req_error: 2670 callbacks suppressed
[ 2572.209917] blk_update_request: I/O error, dev sdg, sector 6672256 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.226315] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.235700] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 0c b9 e0 00 00 10 00
[ 2572.243478] blk_update_request: I/O error, dev sdg, sector 6672128 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.254560] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.263938] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 0c b9 d0 00 00 10 00
[ 2572.271717] blk_update_request: I/O error, dev sdg, sector 6672000 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.282785] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.292261] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 0c b9 c0 00 00 10 00
[ 2572.300121] blk_update_request: I/O error, dev sdg, sector 6671872 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.311217] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.320682] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 0c b9 b0 00 00 10 00
[ 2572.328555] blk_update_request: I/O error, dev sdg, sector 6671744 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.339629] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.341346] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.349105] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 0c b9 a0 00 00 10 00
[ 2572.349110] blk_update_request: I/O error, dev sdg, sector 6671616 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.349122] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.349125] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 0c b9 90 00 00 10 00
[ 2572.349127] blk_update_request: I/O error, dev sdg, sector 6671488 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.349133] sd 0:0:0:6: [sdg] tag#14 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.349135] sd 0:0:0:6: [sdg] tag#14 CDB: opcode=0x2a 2a 00 00 0c b9 80 00 00 10 00
[ 2572.349137] blk_update_request: I/O error, dev sdg, sector 6671360 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.349142] sd 0:0:0:6: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2572.349146] sd 0:0:0:6: [sdg] tag#15 CDB: opcode=0x2a 2a 00 00 0c b9 70 00 00 10 00
[ 2572.349148] blk_update_request: I/O error, dev sdg, sector 6671232 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.349157] blk_update_request: I/O error, dev sdg, sector 6671104 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2572.473825] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 0c ba 00 00 00 10 00
[ 2572.534502] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 834690)
[ 2572.612793] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 835616)
[ 2572.744409] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2004000)
[ 2572.872343] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2209824)
[ 2573.105260] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2573.158562] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2573.166116] EXT4-fs (sdg1): I/O error while writing superblock
[ 2573.377328] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2573.454360] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2573.461950] EXT4-fs (sdg1): I/O error while writing superblock
[ 2573.637475] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2573.659422] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2573.666994] EXT4-fs (sdg1): I/O error while writing superblock
[ 2574.117243] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2574.206897] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2574.214493] EXT4-fs (sdg1): I/O error while writing superblock
[ 2576.101329] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2576.154550] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2576.162209] EXT4-fs (sdg1): I/O error while writing superblock
[ 2576.402616] EXT4-fs warning: 18 callbacks suppressed
[ 2576.402633] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2404384)
[ 2576.418673] buffer_io_error: 34806 callbacks suppressed
[ 2576.418679] Buffer I/O error on device sdg1, logical block 2402304
[ 2576.430417] Buffer I/O error on device sdg1, logical block 2402305
[ 2576.436792] Buffer I/O error on device sdg1, logical block 2402306
[ 2576.443155] Buffer I/O error on device sdg1, logical block 2402307
[ 2576.449520] Buffer I/O error on device sdg1, logical block 2402308
[ 2576.455884] Buffer I/O error on device sdg1, logical block 2402309
[ 2576.462245] Buffer I/O error on device sdg1, logical block 2402310
[ 2576.468606] Buffer I/O error on device sdg1, logical block 2402311
[ 2576.474974] Buffer I/O error on device sdg1, logical block 2402312
[ 2576.481334] Buffer I/O error on device sdg1, logical block 2402313
[ 2576.630472] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1289248)
[ 2576.644292] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2576.790686] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2005024)
[ 2577.058834] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1251112)
[ 2577.094903] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1251360)
[ 2577.226544] scsi_io_completion_action: 2205 callbacks suppressed
[ 2577.226567] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.242162] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 36 13 d0 00 00 10 00
[ 2577.249948] print_req_error: 2205 callbacks suppressed
[ 2577.249953] blk_update_request: I/O error, dev sdg, sector 28352128 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.266448] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.275839] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 36 13 c0 00 00 10 00
[ 2577.283616] blk_update_request: I/O error, dev sdg, sector 28352000 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.294789] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.304170] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 36 13 b0 00 00 10 00
[ 2577.311954] blk_update_request: I/O error, dev sdg, sector 28351872 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.323117] sd 0:0:0:6: [sdg] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.332501] sd 0:0:0:6: [sdg] tag#4 CDB: opcode=0x2a 2a 00 00 36 13 a0 00 00 10 00
[ 2577.340266] blk_update_request: I/O error, dev sdg, sector 28351744 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.351422] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.360796] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 36 13 90 00 00 10 00
[ 2577.365221] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2577.368577] blk_update_request: I/O error, dev sdg, sector 28351616 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.391253] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.400630] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 36 13 80 00 00 10 00
[ 2577.408404] blk_update_request: I/O error, dev sdg, sector 28351488 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.419575] sd 0:0:0:6: [sdg] tag#7 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.420443] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.428950] sd 0:0:0:6: [sdg] tag#7 CDB: opcode=0x2a 2a 00 00 36 13 70 00 00 10 00
[ 2577.428955] blk_update_request: I/O error, dev sdg, sector 28351360 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.428971] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.438353] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 06 34 d0 00 00 10 00
[ 2577.446133] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 36 13 60 00 00 10 00
[ 2577.446136] blk_update_request: I/O error, dev sdg, sector 28351232 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.446156] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2577.457301] blk_update_request: I/O error, dev sdg, sector 3253888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.457334] blk_update_request: I/O error, dev sdg, sector 3253760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2577.466676] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 36 13 50 00 00 10 00
[ 2577.467599] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2577.474496] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3544096)
[ 2577.552234] EXT4-fs (sdg1): I/O error while writing superblock
[ 2577.607267] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 407584)
[ 2577.673346] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2577.706840] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2577.714444] EXT4-fs (sdg1): I/O error while writing superblock
[ 2577.717543] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2577.750943] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2504736)
[ 2577.782276] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2577.789839] EXT4-fs (sdg1): I/O error while writing superblock
[ 2577.858418] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2405408)
[ 2577.963092] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3581984)
[ 2577.973307] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2578.010602] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2578.018213] EXT4-fs (sdg1): I/O error while writing superblock
[ 2578.485485] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2578.568111] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2578.575752] EXT4-fs (sdg1): I/O error while writing superblock
[ 2580.541547] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2580.607535] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2580.615113] EXT4-fs (sdg1): I/O error while writing superblock
[ 2581.422648] EXT4-fs warning: 19 callbacks suppressed
[ 2581.422663] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3151904)
[ 2581.438722] buffer_io_error: 36854 callbacks suppressed
[ 2581.438727] Buffer I/O error on device sdg1, logical block 3149824
[ 2581.450458] Buffer I/O error on device sdg1, logical block 3149825
[ 2581.456825] Buffer I/O error on device sdg1, logical block 3149826
[ 2581.463186] Buffer I/O error on device sdg1, logical block 3149827
[ 2581.469548] Buffer I/O error on device sdg1, logical block 3149828
[ 2581.475912] Buffer I/O error on device sdg1, logical block 3149829
[ 2581.482269] Buffer I/O error on device sdg1, logical block 3149830
[ 2581.488631] Buffer I/O error on device sdg1, logical block 3149831
[ 2581.494996] Buffer I/O error on device sdg1, logical block 3149832
[ 2581.501371] Buffer I/O error on device sdg1, logical block 3149833
[ 2581.659745] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 900128)
[ 2581.763058] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2581.801258] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2406432)
[ 2581.842246] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2581.849914] EXT4-fs (sdg1): I/O error while writing superblock
[ 2581.984982] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1291928)
[ 2582.052997] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1292320)
[ 2582.086950] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2582.146300] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2582.153978] EXT4-fs (sdg1): I/O error while writing superblock
[ 2582.162911] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 3322912)
[ 2582.263284] scsi_io_completion_action: 2385 callbacks suppressed
[ 2582.263307] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.279019] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 08 a7 f0 00 00 10 00
[ 2582.286901] print_req_error: 2385 callbacks suppressed
[ 2582.286907] blk_update_request: I/O error, dev sdg, sector 4538240 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.304976] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.314365] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 1b 20 d0 00 00 10 00
[ 2582.322149] blk_update_request: I/O error, dev sdg, sector 14222976 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.333321] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.342706] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 1b 20 c0 00 00 10 00
[ 2582.350481] blk_update_request: I/O error, dev sdg, sector 14222848 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.361644] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.363227] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2582.371111] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 1b 20 b0 00 00 10 00
[ 2582.371116] blk_update_request: I/O error, dev sdg, sector 14222720 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.371135] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.371138] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 1b 20 a0 00 00 10 00
[ 2582.371139] blk_update_request: I/O error, dev sdg, sector 14222592 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.371145] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.371147] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 1b 20 90 00 00 10 00
[ 2582.371149] blk_update_request: I/O error, dev sdg, sector 14222464 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.371155] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.372204] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.372219] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 1b 21 e0 00 00 10 00
[ 2582.372229] blk_update_request: I/O error, dev sdg, sector 14225152 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.372256] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.372266] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 1b 21 d0 00 00 10 00
[ 2582.372273] blk_update_request: I/O error, dev sdg, sector 14225024 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.372292] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2582.372301] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 1b 21 c0 00 00 10 00
[ 2582.372309] blk_update_request: I/O error, dev sdg, sector 14224896 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.372325] blk_update_request: I/O error, dev sdg, sector 14224768 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2582.564458] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 1b 20 80 00 00 10 00
[ 2582.572370] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 567328)
[ 2582.609664] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2582.617303] EXT4-fs (sdg1): I/O error while writing superblock
[ 2582.755356] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1779744)
[ 2582.883528] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 631840)
[ 2582.909758] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2582.961829] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2582.969470] EXT4-fs (sdg1): I/O error while writing superblock
[ 2582.983745] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2111520)
[ 2585.081176] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2585.178157] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2585.185743] EXT4-fs (sdg1): I/O error while writing superblock
[ 2585.550399] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2586.289581] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2586.354477] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2586.362048] EXT4-fs (sdg1): I/O error while writing superblock
[ 2586.484996] EXT4-fs warning: 22 callbacks suppressed
[ 2586.485010] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2570272)
[ 2586.501054] buffer_io_error: 36854 callbacks suppressed
[ 2586.501059] Buffer I/O error on device sdg1, logical block 2568192
[ 2586.512804] Buffer I/O error on device sdg1, logical block 2568193
[ 2586.519174] Buffer I/O error on device sdg1, logical block 2568194
[ 2586.525536] Buffer I/O error on device sdg1, logical block 2568195
[ 2586.531901] Buffer I/O error on device sdg1, logical block 2568196
[ 2586.538265] Buffer I/O error on device sdg1, logical block 2568197
[ 2586.544629] Buffer I/O error on device sdg1, logical block 2568198
[ 2586.550984] Buffer I/O error on device sdg1, logical block 2568199
[ 2586.557344] Buffer I/O error on device sdg1, logical block 2568200
[ 2586.563702] Buffer I/O error on device sdg1, logical block 2568201
[ 2586.605298] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2586.670408] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2586.677984] EXT4-fs (sdg1): I/O error while writing superblock
[ 2586.681573] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1520672)
[ 2586.786806] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 632864)
[ 2586.893760] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2586.933810] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2586.941389] EXT4-fs (sdg1): I/O error while writing superblock
[ 2586.946832] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1030176)
[ 2587.015811] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1647648)
[ 2587.082994] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3221536)
[ 2587.232213] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1619824)
[ 2587.250386] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1620000)
[ 2587.282600] scsi_io_completion_action: 2439 callbacks suppressed
[ 2587.282620] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.298211] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 15 a0 70 00 00 10 00
[ 2587.306001] print_req_error: 2439 callbacks suppressed
[ 2587.306007] blk_update_request: I/O error, dev sdg, sector 11338624 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.322486] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.331883] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 15 a0 60 00 00 10 00
[ 2587.339662] blk_update_request: I/O error, dev sdg, sector 11338496 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.377497] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2587.386512] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.398505] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 15 a1 80 00 00 10 00
[ 2587.406378] blk_update_request: I/O error, dev sdg, sector 11340800 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.417570] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.427038] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 15 a1 70 00 00 10 00
[ 2587.434903] blk_update_request: I/O error, dev sdg, sector 11340672 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.446072] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.455542] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 15 a1 60 00 00 10 00
[ 2587.463407] blk_update_request: I/O error, dev sdg, sector 11340544 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.474561] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.484026] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 15 a1 50 00 00 10 00
[ 2587.491889] blk_update_request: I/O error, dev sdg, sector 11340416 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.503058] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.512531] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 15 a1 40 00 00 10 00
[ 2587.520395] blk_update_request: I/O error, dev sdg, sector 11340288 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.531555] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.541027] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 15 a1 30 00 00 10 00
[ 2587.548889] blk_update_request: I/O error, dev sdg, sector 11340160 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.560074] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.569537] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 15 a1 20 00 00 10 00
[ 2587.577408] blk_update_request: I/O error, dev sdg, sector 11340032 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.588571] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2587.598044] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 15 a1 10 00 00 10 00
[ 2587.605904] blk_update_request: I/O error, dev sdg, sector 11339904 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2587.627045] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2587.634712] EXT4-fs (sdg1): I/O error while writing superblock
[ 2587.655557] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1418272)
[ 2587.786504] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 112672)
[ 2589.409352] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2589.462366] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2589.470017] EXT4-fs (sdg1): I/O error while writing superblock
[ 2590.593686] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2590.655234] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2590.662878] EXT4-fs (sdg1): I/O error while writing superblock
[ 2590.879169] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2590.936537] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2590.944197] EXT4-fs (sdg1): I/O error while writing superblock
[ 2591.153743] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2591.250129] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2591.258068] EXT4-fs (sdg1): I/O error while writing superblock
[ 2591.629484] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2591.639920] EXT4-fs warning: 22 callbacks suppressed
[ 2591.639943] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2730016)
[ 2591.657116] buffer_io_error: 40950 callbacks suppressed
[ 2591.657124] Buffer I/O error on device sdg1, logical block 2727936
[ 2591.668903] Buffer I/O error on device sdg1, logical block 2727937
[ 2591.675273] Buffer I/O error on device sdg1, logical block 2727938
[ 2591.681631] Buffer I/O error on device sdg1, logical block 2727939
[ 2591.687993] Buffer I/O error on device sdg1, logical block 2727940
[ 2591.694350] Buffer I/O error on device sdg1, logical block 2727941
[ 2591.700705] Buffer I/O error on device sdg1, logical block 2727942
[ 2591.707057] Buffer I/O error on device sdg1, logical block 2727943
[ 2591.713415] Buffer I/O error on device sdg1, logical block 2727944
[ 2591.719771] Buffer I/O error on device sdg1, logical block 2727945
[ 2591.770557] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2591.778158] EXT4-fs (sdg1): I/O error while writing superblock
[ 2591.848451] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3060768)
[ 2591.984392] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1972256)
[ 2592.161084] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 177767)
[ 2592.232422] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 178208)
[ 2592.306567] scsi_io_completion_action: 2319 callbacks suppressed
[ 2592.306592] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.322199] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 09 a9 80 00 00 10 00
[ 2592.329984] print_req_error: 2319 callbacks suppressed
[ 2592.329990] blk_update_request: I/O error, dev sdg, sector 5065728 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.347906] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.357405] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 09 aa 70 00 00 10 00
[ 2592.365278] blk_update_request: I/O error, dev sdg, sector 5067648 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.376382] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.385859] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 09 aa 60 00 00 10 00
[ 2592.393728] blk_update_request: I/O error, dev sdg, sector 5067520 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.404806] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.414276] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 09 aa 50 00 00 10 00
[ 2592.422137] blk_update_request: I/O error, dev sdg, sector 5067392 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.433212] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.442680] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 09 aa 40 00 00 10 00
[ 2592.450555] blk_update_request: I/O error, dev sdg, sector 5067264 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.461636] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.471105] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 09 aa 30 00 00 10 00
[ 2592.478964] blk_update_request: I/O error, dev sdg, sector 5067136 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.490044] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.499504] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 09 aa 20 00 00 10 00
[ 2592.507364] blk_update_request: I/O error, dev sdg, sector 5067008 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.518431] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.527900] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 09 aa 10 00 00 10 00
[ 2592.535761] blk_update_request: I/O error, dev sdg, sector 5066880 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.546850] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.556316] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 09 aa 00 00 00 10 00
[ 2592.564182] blk_update_request: I/O error, dev sdg, sector 5066752 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.575260] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2592.575584] blk_update_request: I/O error, dev sdg, sector 5070208 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2592.584631] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 09 a9 f0 00 00 10 00
[ 2592.630882] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 633888)
[ 2592.754890] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2603040)
[ 2592.934664] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2897822)
[ 2593.002758] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2897952)
[ 2593.142599] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3191840)
[ 2593.741278] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2593.785634] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2593.793202] EXT4-fs (sdg1): I/O error while writing superblock
[ 2594.029314] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2594.865656] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2594.934371] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2594.942260] EXT4-fs (sdg1): I/O error while writing superblock
[ 2595.149424] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2595.234532] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2595.242133] EXT4-fs (sdg1): I/O error while writing superblock
[ 2595.425649] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2595.498525] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2595.506217] EXT4-fs (sdg1): I/O error while writing superblock
[ 2595.905543] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2595.954594] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2595.962260] EXT4-fs (sdg1): I/O error while writing superblock
[ 2596.695178] EXT4-fs warning: 22 callbacks suppressed
[ 2596.695203] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3192864)
[ 2596.711285] buffer_io_error: 39926 callbacks suppressed
[ 2596.711290] Buffer I/O error on device sdg1, logical block 3191808
[ 2596.723029] Buffer I/O error on device sdg1, logical block 3191809
[ 2596.729403] Buffer I/O error on device sdg1, logical block 3191810
[ 2596.735770] Buffer I/O error on device sdg1, logical block 3191811
[ 2596.742138] Buffer I/O error on device sdg1, logical block 3191812
[ 2596.748505] Buffer I/O error on device sdg1, logical block 3191813
[ 2596.754873] Buffer I/O error on device sdg1, logical block 3191814
[ 2596.761232] Buffer I/O error on device sdg1, logical block 3191815
[ 2596.767592] Buffer I/O error on device sdg1, logical block 3191816
[ 2596.773950] Buffer I/O error on device sdg1, logical block 3191817
[ 2597.150623] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 16416)
[ 2597.350811] scsi_io_completion_action: 2335 callbacks suppressed
[ 2597.350841] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.366578] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 34 24 80 00 00 10 00
[ 2597.374462] print_req_error: 2335 callbacks suppressed
[ 2597.374468] blk_update_request: I/O error, dev sdg, sector 27337728 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.390960] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.400443] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 34 24 70 00 00 10 00
[ 2597.408318] blk_update_request: I/O error, dev sdg, sector 27337600 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.419501] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.428965] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 34 24 60 00 00 10 00
[ 2597.436836] blk_update_request: I/O error, dev sdg, sector 27337472 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.447998] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.457466] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 34 24 50 00 00 10 00
[ 2597.465330] blk_update_request: I/O error, dev sdg, sector 27337344 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.476492] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.485953] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 34 24 40 00 00 10 00
[ 2597.493815] blk_update_request: I/O error, dev sdg, sector 27337216 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.504980] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.514451] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 34 24 30 00 00 10 00
[ 2597.522309] blk_update_request: I/O error, dev sdg, sector 27337088 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.533490] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.542957] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 34 24 20 00 00 10 00
[ 2597.550828] blk_update_request: I/O error, dev sdg, sector 27336960 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.561993] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.571458] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 2f bc 10 00 00 10 00
[ 2597.579317] blk_update_request: I/O error, dev sdg, sector 25026688 op 0x1:(WRITE) flags 0x0 phys_seg 16 prio class 0
[ 2597.590218] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.599606] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 2f bc 00 00 00 10 00
[ 2597.607380] blk_update_request: I/O error, dev sdg, sector 25026560 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.618541] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2597.619114] blk_update_request: I/O error, dev sdg, sector 27340288 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2597.627921] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 2f bb f0 00 00 10 00
[ 2597.627944] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3128352)
[ 2597.706158] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3418144)
[ 2597.814277] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1350889)
[ 2597.894681] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1351712)
[ 2597.969196] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2598.006418] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 244768)
[ 2598.026180] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2598.033817] EXT4-fs (sdg1): I/O error while writing superblock
[ 2598.090618] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3250208)
[ 2598.223060] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1054752)
[ 2598.350689] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1938464)
[ 2599.141644] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2599.246080] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2599.253667] EXT4-fs (sdg1): I/O error while writing superblock
[ 2599.418952] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2599.498516] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2599.506138] EXT4-fs (sdg1): I/O error while writing superblock
[ 2599.685703] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2599.734900] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2599.742491] EXT4-fs (sdg1): I/O error while writing superblock
[ 2600.197778] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2600.242639] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2600.250608] EXT4-fs (sdg1): I/O error while writing superblock
[ 2601.939505] EXT4-fs warning: 21 callbacks suppressed
[ 2601.939520] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3645472)
[ 2601.955561] buffer_io_error: 37878 callbacks suppressed
[ 2601.955567] Buffer I/O error on device sdg1, logical block 3645294
[ 2601.967309] Buffer I/O error on device sdg1, logical block 3645295
[ 2601.973688] Buffer I/O error on device sdg1, logical block 3645296
[ 2601.980056] Buffer I/O error on device sdg1, logical block 3645297
[ 2601.986428] Buffer I/O error on device sdg1, logical block 3645298
[ 2601.992799] Buffer I/O error on device sdg1, logical block 3645299
[ 2601.999162] Buffer I/O error on device sdg1, logical block 3645300
[ 2602.005516] Buffer I/O error on device sdg1, logical block 3645301
[ 2602.011872] Buffer I/O error on device sdg1, logical block 3645302
[ 2602.018226] Buffer I/O error on device sdg1, logical block 3645303
[ 2602.024778] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3645326)
[ 2602.202832] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 760864)
[ 2602.219302] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2602.330430] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2602.339652] EXT4-fs (sdg1): I/O error while writing superblock
[ 2602.362821] scsi_io_completion_action: 2350 callbacks suppressed
[ 2602.362850] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.378552] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 01 b8 40 00 00 10 00
[ 2602.386428] print_req_error: 2350 callbacks suppressed
[ 2602.386434] blk_update_request: I/O error, dev sdg, sector 901632 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.402742] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.412223] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 01 b8 30 00 00 10 00
[ 2602.420089] blk_update_request: I/O error, dev sdg, sector 901504 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.431083] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.440546] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 01 b8 20 00 00 10 00
[ 2602.448414] blk_update_request: I/O error, dev sdg, sector 901376 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.459400] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.468877] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 1d 98 10 00 00 10 00
[ 2602.476747] blk_update_request: I/O error, dev sdg, sector 15515776 op 0x1:(WRITE) flags 0x0 phys_seg 16 prio class 0
[ 2602.487664] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.497133] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 1d 98 00 00 00 10 00
[ 2602.504990] blk_update_request: I/O error, dev sdg, sector 15515648 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.516156] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.516498] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.525621] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 1d 97 f0 00 00 10 00
[ 2602.525625] blk_update_request: I/O error, dev sdg, sector 15515520 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.535092] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 01 b8 50 00 00 10 00
[ 2602.542968] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.554114] blk_update_request: I/O error, dev sdg, sector 901760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.561977] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 1d 97 e0 00 00 10 00
[ 2602.561980] blk_update_request: I/O error, dev sdg, sector 15515392 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.601443] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.610907] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 1d 97 d0 00 00 10 00
[ 2602.618760] blk_update_request: I/O error, dev sdg, sector 15515264 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.629924] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2602.630291] blk_update_request: I/O error, dev sdg, sector 901888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2602.639396] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 1d 97 c0 00 00 10 00
[ 2602.658313] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1939488)
[ 2602.776558] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 114720)
[ 2602.946559] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2602.954295] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2364448)
[ 2603.138705] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 409632)
[ 2603.478481] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2506784)
[ 2603.493471] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2603.586485] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2603.594079] EXT4-fs (sdg1): I/O error while writing superblock
[ 2603.630412] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2407456)
[ 2603.751470] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2695200)
[ 2603.785779] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2603.854484] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2603.862049] EXT4-fs (sdg1): I/O error while writing superblock
[ 2604.085365] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2604.134053] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2604.141680] EXT4-fs (sdg1): I/O error while writing superblock
[ 2604.650953] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2604.725996] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2604.733629] EXT4-fs (sdg1): I/O error while writing superblock
[ 2606.821087] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2606.906504] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2606.914079] EXT4-fs (sdg1): I/O error while writing superblock
[ 2606.948536] EXT4-fs warning: 17 callbacks suppressed
[ 2606.948552] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2923552)
[ 2606.964593] buffer_io_error: 34806 callbacks suppressed
[ 2606.964598] Buffer I/O error on device sdg1, logical block 2922496
[ 2606.976351] Buffer I/O error on device sdg1, logical block 2922497
[ 2606.982725] Buffer I/O error on device sdg1, logical block 2922498
[ 2606.989088] Buffer I/O error on device sdg1, logical block 2922499
[ 2606.995455] Buffer I/O error on device sdg1, logical block 2922500
[ 2607.001821] Buffer I/O error on device sdg1, logical block 2922501
[ 2607.008183] Buffer I/O error on device sdg1, logical block 2922502
[ 2607.014548] Buffer I/O error on device sdg1, logical block 2922503
[ 2607.020908] Buffer I/O error on device sdg1, logical block 2922504
[ 2607.027262] Buffer I/O error on device sdg1, logical block 2922505
[ 2607.148945] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2365472)
[ 2607.378405] scsi_io_completion_action: 2172 callbacks suppressed
[ 2607.378435] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.394047] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 0e 96 60 00 00 10 00
[ 2607.401833] print_req_error: 2172 callbacks suppressed
[ 2607.401838] blk_update_request: I/O error, dev sdg, sector 7648000 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.450554] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.460060] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 0e 97 60 00 00 10 00
[ 2607.467946] blk_update_request: I/O error, dev sdg, sector 7650048 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.479064] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.488553] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 0e 97 50 00 00 10 00
[ 2607.496419] blk_update_request: I/O error, dev sdg, sector 7649920 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.507509] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.516976] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 0e 97 40 00 00 10 00
[ 2607.524850] blk_update_request: I/O error, dev sdg, sector 7649792 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.535922] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.545395] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 0e 97 30 00 00 10 00
[ 2607.553260] blk_update_request: I/O error, dev sdg, sector 7649664 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.564334] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.573797] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 0e 97 20 00 00 10 00
[ 2607.581660] blk_update_request: I/O error, dev sdg, sector 7649536 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.592736] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.602201] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 0e 97 10 00 00 10 00
[ 2607.610066] blk_update_request: I/O error, dev sdg, sector 7649408 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.621157] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.630620] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 0e 97 00 00 00 10 00
[ 2607.638485] blk_update_request: I/O error, dev sdg, sector 7649280 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.649554] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.659023] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 0e 96 f0 00 00 10 00
[ 2607.666885] blk_update_request: I/O error, dev sdg, sector 7649152 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.677963] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2607.687341] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 0e 96 e0 00 00 10 00
[ 2607.695115] blk_update_request: I/O error, dev sdg, sector 7649024 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2607.708577] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 956448)
[ 2607.775215] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2528288)
[ 2607.843532] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2408480)
[ 2608.101708] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2608.126703] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1294368)
[ 2608.170301] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2608.179041] EXT4-fs (sdg1): I/O error while writing superblock
[ 2608.242638] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3324960)
[ 2608.367082] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 3489824)
[ 2608.397768] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2608.444280] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2608.451842] EXT4-fs (sdg1): I/O error while writing superblock
[ 2608.454353] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2608.498363] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2608.505973] EXT4-fs (sdg1): I/O error while writing superblock
[ 2608.520100] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 466976)
[ 2608.590271] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 72736)
[ 2608.717670] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2608.753716] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2608.761286] EXT4-fs (sdg1): I/O error while writing superblock
[ 2609.213496] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2609.268241] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2609.275864] EXT4-fs (sdg1): I/O error while writing superblock
[ 2611.221501] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2611.298222] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2611.305804] EXT4-fs (sdg1): I/O error while writing superblock
[ 2611.537468] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2612.058324] EXT4-fs warning: 21 callbacks suppressed
[ 2612.058338] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1522720)
[ 2612.074384] buffer_io_error: 40950 callbacks suppressed
[ 2612.074389] Buffer I/O error on device sdg1, logical block 1521664
[ 2612.086139] Buffer I/O error on device sdg1, logical block 1521665
[ 2612.092520] Buffer I/O error on device sdg1, logical block 1521666
[ 2612.098901] Buffer I/O error on device sdg1, logical block 1521667
[ 2612.105274] Buffer I/O error on device sdg1, logical block 1521668
[ 2612.111639] Buffer I/O error on device sdg1, logical block 1521669
[ 2612.118009] Buffer I/O error on device sdg1, logical block 1521670
[ 2612.124381] Buffer I/O error on device sdg1, logical block 1521671
[ 2612.130737] Buffer I/O error on device sdg1, logical block 1521672
[ 2612.137087] Buffer I/O error on device sdg1, logical block 1521673
[ 2612.310350] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 73760)
[ 2612.397351] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2612.406383] scsi_io_completion_action: 2479 callbacks suppressed
[ 2612.406412] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.424578] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 17 9a 70 00 00 10 00
[ 2612.432460] print_req_error: 2479 callbacks suppressed
[ 2612.432465] blk_update_request: I/O error, dev sdg, sector 12374912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.448966] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.458452] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 17 9a 60 00 00 10 00
[ 2612.466325] blk_update_request: I/O error, dev sdg, sector 12374784 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.477499] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.486970] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 17 9a 50 00 00 10 00
[ 2612.494836] blk_update_request: I/O error, dev sdg, sector 12374656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.505999] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.515470] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 17 9a 40 00 00 10 00
[ 2612.523336] blk_update_request: I/O error, dev sdg, sector 12374528 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.534503] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.543965] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 17 9a 30 00 00 10 00
[ 2612.551833] blk_update_request: I/O error, dev sdg, sector 12374400 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.562999] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.572460] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 17 9a 20 00 00 10 00
[ 2612.580319] blk_update_request: I/O error, dev sdg, sector 12374272 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.591491] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.600952] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 17 9a 10 00 00 10 00
[ 2612.608815] blk_update_request: I/O error, dev sdg, sector 12374144 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.619982] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.629445] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 17 9a 00 00 00 10 00
[ 2612.637310] blk_update_request: I/O error, dev sdg, sector 12374016 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.648483] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.657946] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 17 99 f0 00 00 10 00
[ 2612.665805] blk_update_request: I/O error, dev sdg, sector 12373888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.676971] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2612.678961] blk_update_request: I/O error, dev sdg, sector 12377344 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2612.686432] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 17 99 e0 00 00 10 00
[ 2612.705577] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2612.713145] EXT4-fs (sdg1): I/O error while writing superblock
[ 2612.741168] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2612.773470] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2612.781049] EXT4-fs (sdg1): I/O error while writing superblock
[ 2612.807394] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1548170)
[ 2612.844891] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1548320)
[ 2612.940433] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1481760)
[ 2613.013509] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2613.042553] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3282976)
[ 2613.078455] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2613.086039] EXT4-fs (sdg1): I/O error while writing superblock
[ 2613.186362] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2731736)
[ 2613.238615] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2732064)
[ 2613.330361] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3062816)
[ 2613.442362] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 208928)
[ 2613.537850] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2613.570546] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2613.578113] EXT4-fs (sdg1): I/O error while writing superblock
[ 2615.489526] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2615.555786] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2615.563380] EXT4-fs (sdg1): I/O error while writing superblock
[ 2616.653503] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2616.740037] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2616.747614] EXT4-fs (sdg1): I/O error while writing superblock
[ 2616.921595] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2617.014362] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2617.021943] EXT4-fs (sdg1): I/O error while writing superblock
[ 2617.067059] EXT4-fs warning: 20 callbacks suppressed
[ 2617.067071] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3063840)
[ 2617.083147] buffer_io_error: 37878 callbacks suppressed
[ 2617.083152] Buffer I/O error on device sdg1, logical block 3062784
[ 2617.094905] Buffer I/O error on device sdg1, logical block 3062785
[ 2617.101275] Buffer I/O error on device sdg1, logical block 3062786
[ 2617.107642] Buffer I/O error on device sdg1, logical block 3062787
[ 2617.114006] Buffer I/O error on device sdg1, logical block 3062788
[ 2617.120368] Buffer I/O error on device sdg1, logical block 3062789
[ 2617.126732] Buffer I/O error on device sdg1, logical block 3062790
[ 2617.133086] Buffer I/O error on device sdg1, logical block 3062791
[ 2617.139445] Buffer I/O error on device sdg1, logical block 3062792
[ 2617.145796] Buffer I/O error on device sdg1, logical block 3062793
[ 2617.241307] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2617.282286] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2617.289851] EXT4-fs (sdg1): I/O error while writing superblock
[ 2617.323679] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 143392)
[ 2617.410898] scsi_io_completion_action: 2452 callbacks suppressed
[ 2617.410920] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.426603] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 36 aa c0 00 00 10 00
[ 2617.434478] print_req_error: 2452 callbacks suppressed
[ 2617.434482] blk_update_request: I/O error, dev sdg, sector 28661248 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.470553] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.479952] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 36 ab c0 00 00 10 00
[ 2617.487740] blk_update_request: I/O error, dev sdg, sector 28663296 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.498921] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.508312] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 36 ab b0 00 00 10 00
[ 2617.516088] blk_update_request: I/O error, dev sdg, sector 28663168 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.527251] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.536630] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 36 ab a0 00 00 10 00
[ 2617.544408] blk_update_request: I/O error, dev sdg, sector 28663040 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.555559] sd 0:0:0:6: [sdg] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.564938] sd 0:0:0:6: [sdg] tag#4 CDB: opcode=0x2a 2a 00 00 36 ab 90 00 00 10 00
[ 2617.572712] blk_update_request: I/O error, dev sdg, sector 28662912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.583881] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.593254] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 36 ab 80 00 00 10 00
[ 2617.601023] blk_update_request: I/O error, dev sdg, sector 28662784 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.612182] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.621559] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 36 ab 70 00 00 10 00
[ 2617.629333] blk_update_request: I/O error, dev sdg, sector 28662656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.640505] sd 0:0:0:6: [sdg] tag#7 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.641649] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.649880] sd 0:0:0:6: [sdg] tag#7 CDB: opcode=0x2a 2a 00 00 36 ab 60 00 00 10 00
[ 2617.649883] blk_update_request: I/O error, dev sdg, sector 28662528 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.649890] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2617.649893] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 36 ab 50 00 00 10 00
[ 2617.659283] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 2a 2c b0 00 00 10 00
[ 2617.667044] blk_update_request: I/O error, dev sdg, sector 28662400 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.667049] blk_update_request: I/O error, dev sdg, sector 28662272 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2617.725434] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3583008)
[ 2617.755149] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2617.783574] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2764832)
[ 2617.807080] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2617.814643] EXT4-fs (sdg1): I/O error while writing superblock
[ 2617.923552] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3223584)
[ 2618.071067] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1184800)
[ 2618.189972] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2039840)
[ 2618.419757] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2072608)
[ 2618.574520] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1756192)
[ 2618.756072] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1228832)
[ 2619.849766] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2619.918570] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2619.926152] EXT4-fs (sdg1): I/O error while writing superblock
[ 2620.269546] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2621.081363] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2621.146553] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2621.154221] EXT4-fs (sdg1): I/O error while writing superblock
[ 2621.334879] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2621.394577] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2621.402245] EXT4-fs (sdg1): I/O error while writing superblock
[ 2621.669648] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2621.734270] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2621.741836] EXT4-fs (sdg1): I/O error while writing superblock
[ 2622.117416] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2622.195257] EXT4-fs warning: 19 callbacks suppressed
[ 2622.195275] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2803744)
[ 2622.211319] buffer_io_error: 37878 callbacks suppressed
[ 2622.211323] Buffer I/O error on device sdg1, logical block 2801664
[ 2622.223067] Buffer I/O error on device sdg1, logical block 2801665
[ 2622.229440] Buffer I/O error on device sdg1, logical block 2801666
[ 2622.235807] Buffer I/O error on device sdg1, logical block 2801667
[ 2622.242174] Buffer I/O error on device sdg1, logical block 2801668
[ 2622.248538] Buffer I/O error on device sdg1, logical block 2801669
[ 2622.254902] Buffer I/O error on device sdg1, logical block 2801670
[ 2622.261259] Buffer I/O error on device sdg1, logical block 2801671
[ 2622.267613] Buffer I/O error on device sdg1, logical block 2801672
[ 2622.273972] Buffer I/O error on device sdg1, logical block 2801673
[ 2622.295944] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2622.303552] EXT4-fs (sdg1): I/O error while writing superblock
[ 2622.414318] scsi_io_completion_action: 2302 callbacks suppressed
[ 2622.414342] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.430037] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 1a cc 90 00 00 10 00
[ 2622.437921] print_req_error: 2302 callbacks suppressed
[ 2622.437927] blk_update_request: I/O error, dev sdg, sector 14050432 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.454414] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.463899] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 1a cc 80 00 00 10 00
[ 2622.471768] blk_update_request: I/O error, dev sdg, sector 14050304 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.482940] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.492404] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 1a cc 70 00 00 10 00
[ 2622.500273] blk_update_request: I/O error, dev sdg, sector 14050176 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.511437] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.520908] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 1a cc 60 00 00 10 00
[ 2622.528767] blk_update_request: I/O error, dev sdg, sector 14050048 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.539937] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.549405] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 1a cc 50 00 00 10 00
[ 2622.557264] blk_update_request: I/O error, dev sdg, sector 14049920 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.568426] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.568623] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.577901] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 1a cc 40 00 00 10 00
[ 2622.587372] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 1a cc a0 00 00 10 00
[ 2622.595228] blk_update_request: I/O error, dev sdg, sector 14049792 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.595237] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.595241] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 1a cc 30 00 00 10 00
[ 2622.603100] blk_update_request: I/O error, dev sdg, sector 14050560 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.642733] blk_update_request: I/O error, dev sdg, sector 14049664 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.653905] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.663366] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 1a cc 20 00 00 10 00
[ 2622.671235] blk_update_request: I/O error, dev sdg, sector 14049536 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2622.682393] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2622.691863] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 0f c4 10 00 00 10 00
[ 2622.699728] blk_update_request: I/O error, dev sdg, sector 8265856 op 0x1:(WRITE) flags 0x0 phys_seg 16 prio class 0
[ 2622.710583] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1033248)
[ 2622.803487] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1757216)
[ 2622.978008] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2170912)
[ 2623.108169] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 728096)
[ 2623.236650] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 51232)
[ 2623.468281] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1161248)
[ 2623.596152] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1389600)
[ 2623.723794] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2439200)
[ 2623.984381] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 210976)
[ 2624.261560] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2624.300309] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2624.307885] EXT4-fs (sdg1): I/O error while writing superblock
[ 2625.389260] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2625.454306] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2625.461874] EXT4-fs (sdg1): I/O error while writing superblock
[ 2625.633375] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2625.718532] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2625.726129] EXT4-fs (sdg1): I/O error while writing superblock
[ 2625.945714] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2626.019430] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2626.027018] EXT4-fs (sdg1): I/O error while writing superblock
[ 2626.397412] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2626.478892] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2626.486477] EXT4-fs (sdg1): I/O error while writing superblock
[ 2627.222458] EXT4-fs warning: 22 callbacks suppressed
[ 2627.222473] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2115616)
[ 2627.238518] buffer_io_error: 44022 callbacks suppressed
[ 2627.238523] Buffer I/O error on device sdg1, logical block 2114560
[ 2627.250266] Buffer I/O error on device sdg1, logical block 2114561
[ 2627.256642] Buffer I/O error on device sdg1, logical block 2114562
[ 2627.263012] Buffer I/O error on device sdg1, logical block 2114563
[ 2627.269371] Buffer I/O error on device sdg1, logical block 2114564
[ 2627.275749] Buffer I/O error on device sdg1, logical block 2114565
[ 2627.282108] Buffer I/O error on device sdg1, logical block 2114566
[ 2627.288474] Buffer I/O error on device sdg1, logical block 2114567
[ 2627.294835] Buffer I/O error on device sdg1, logical block 2114568
[ 2627.301190] Buffer I/O error on device sdg1, logical block 2114569
[ 2627.422508] scsi_io_completion_action: 2681 callbacks suppressed
[ 2627.422537] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.438151] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 2a 33 90 00 00 10 00
[ 2627.445940] print_req_error: 2681 callbacks suppressed
[ 2627.445945] blk_update_request: I/O error, dev sdg, sector 22125696 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.462434] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.471820] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 2a 33 80 00 00 10 00
[ 2627.479598] blk_update_request: I/O error, dev sdg, sector 22125568 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.490780] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.500166] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 2a 33 70 00 00 10 00
[ 2627.507952] blk_update_request: I/O error, dev sdg, sector 22125440 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.519119] sd 0:0:0:6: [sdg] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.528504] sd 0:0:0:6: [sdg] tag#4 CDB: opcode=0x2a 2a 00 00 2a 33 60 00 00 10 00
[ 2627.536274] blk_update_request: I/O error, dev sdg, sector 22125312 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.547428] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.556802] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 2a 33 50 00 00 10 00
[ 2627.564580] blk_update_request: I/O error, dev sdg, sector 22125184 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.575750] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.585125] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 2a 33 40 00 00 10 00
[ 2627.592904] blk_update_request: I/O error, dev sdg, sector 22125056 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.604079] sd 0:0:0:6: [sdg] tag#7 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.604942] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.613459] sd 0:0:0:6: [sdg] tag#7 CDB: opcode=0x2a 2a 00 00 2a 33 30 00 00 10 00
[ 2627.622927] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 2a 34 90 00 00 10 00
[ 2627.630697] blk_update_request: I/O error, dev sdg, sector 22124928 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.630707] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.638570] blk_update_request: I/O error, dev sdg, sector 22127744 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.638590] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2627.649736] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 2a 33 20 00 00 10 00
[ 2627.649741] blk_update_request: I/O error, dev sdg, sector 22124800 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.649751] blk_update_request: I/O error, dev sdg, sector 22124672 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2627.659118] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 2a 34 80 00 00 10 00
[ 2627.771523] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2766880)
[ 2627.840191] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1186848)
[ 2627.895357] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 18464)
[ 2628.110357] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3131424)
[ 2628.234562] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2606112)
[ 2628.266517] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2628.357143] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2628.393256] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3153952)
[ 2628.426360] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2628.433920] EXT4-fs (sdg1): I/O error while writing superblock
[ 2628.602396] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 434208)
[ 2628.726414] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 498720)
[ 2628.841369] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 315424)
[ 2629.485284] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2629.558188] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2629.565760] EXT4-fs (sdg1): I/O error while writing superblock
[ 2629.729432] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2629.775234] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2629.782815] EXT4-fs (sdg1): I/O error while writing superblock
[ 2629.785873] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2629.813509] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2629.821091] EXT4-fs (sdg1): I/O error while writing superblock
[ 2630.041308] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2630.111627] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2630.119214] EXT4-fs (sdg1): I/O error while writing superblock
[ 2630.494122] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2630.580031] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2630.587652] EXT4-fs (sdg1): I/O error while writing superblock
[ 2632.373497] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2632.424482] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2632.432151] EXT4-fs (sdg1): I/O error while writing superblock
[ 2632.459171] scsi_io_completion_action: 2554 callbacks suppressed
[ 2632.459196] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.474945] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 30 c7 30 00 00 10 00
[ 2632.482842] print_req_error: 2554 callbacks suppressed
[ 2632.482851] blk_update_request: I/O error, dev sdg, sector 25573760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.499381] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.508879] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 30 c7 20 00 00 10 00
[ 2632.516767] blk_update_request: I/O error, dev sdg, sector 25573632 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.527987] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.537484] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 30 c7 10 00 00 10 00
[ 2632.545375] blk_update_request: I/O error, dev sdg, sector 25573504 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.556577] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.566069] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 30 c7 00 00 00 10 00
[ 2632.573940] blk_update_request: I/O error, dev sdg, sector 25573376 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.585151] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.594632] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 30 c6 f0 00 00 10 00
[ 2632.602507] blk_update_request: I/O error, dev sdg, sector 25573248 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.613702] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.614588] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.623198] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 30 c6 e0 00 00 10 00
[ 2632.632562] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 07 9c 40 00 00 10 00
[ 2632.640427] blk_update_request: I/O error, dev sdg, sector 25573120 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.648201] blk_update_request: I/O error, dev sdg, sector 3990016 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.659376] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.670441] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.679897] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 30 c6 d0 00 00 10 00
[ 2632.689274] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 07 9c 30 00 00 10 00
[ 2632.689279] blk_update_request: I/O error, dev sdg, sector 3989888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.689290] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2632.689295] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 07 9c 20 00 00 10 00
[ 2632.697166] blk_update_request: I/O error, dev sdg, sector 25572992 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.704930] blk_update_request: I/O error, dev sdg, sector 3989760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2632.802897] EXT4-fs warning: 20 callbacks suppressed
[ 2632.802917] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3196960)
[ 2632.818972] buffer_io_error: 40950 callbacks suppressed
[ 2632.818976] Buffer I/O error on device sdg1, logical block 3194880
[ 2632.830717] Buffer I/O error on device sdg1, logical block 3194881
[ 2632.837079] Buffer I/O error on device sdg1, logical block 3194882
[ 2632.843443] Buffer I/O error on device sdg1, logical block 3194883
[ 2632.849801] Buffer I/O error on device sdg1, logical block 3194884
[ 2632.856161] Buffer I/O error on device sdg1, logical block 3194885
[ 2632.862523] Buffer I/O error on device sdg1, logical block 3194886
[ 2632.868879] Buffer I/O error on device sdg1, logical block 3194887
[ 2632.875231] Buffer I/O error on device sdg1, logical block 3194888
[ 2632.881587] Buffer I/O error on device sdg1, logical block 3194889
[ 2632.928617] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 499744)
[ 2633.174667] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 991264)
[ 2633.450594] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3358752)
[ 2633.541513] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2633.612455] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1163296)
[ 2633.634547] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2633.642139] EXT4-fs (sdg1): I/O error while writing superblock
[ 2633.778354] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1253408)
[ 2633.789183] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2633.826539] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2633.834099] EXT4-fs (sdg1): I/O error while writing superblock
[ 2633.840585] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1874976)
[ 2633.855219] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2633.898399] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2633.906005] EXT4-fs (sdg1): I/O error while writing superblock
[ 2633.938961] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 378912)
[ 2634.108081] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2634.134588] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 839712)
[ 2634.186436] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2634.194028] EXT4-fs (sdg1): I/O error while writing superblock
[ 2634.271443] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 904224)
[ 2634.557304] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2634.604721] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2634.612372] EXT4-fs (sdg1): I/O error while writing superblock
[ 2636.473324] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2636.543161] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2636.551184] EXT4-fs (sdg1): I/O error while writing superblock
[ 2637.000268] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2637.531072] scsi_io_completion_action: 2357 callbacks suppressed
[ 2637.531104] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.546824] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 32 27 c0 00 00 10 00
[ 2637.554703] print_req_error: 2357 callbacks suppressed
[ 2637.554708] blk_update_request: I/O error, dev sdg, sector 26295808 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.571217] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.580703] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 32 27 b0 00 00 10 00
[ 2637.588569] blk_update_request: I/O error, dev sdg, sector 26295680 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.599745] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.609213] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 32 27 a0 00 00 10 00
[ 2637.617080] blk_update_request: I/O error, dev sdg, sector 26295552 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.628243] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.637062] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2637.637714] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 32 27 90 00 00 10 00
[ 2637.657077] blk_update_request: I/O error, dev sdg, sector 26295424 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.668243] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.677713] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 32 27 80 00 00 10 00
[ 2637.685570] blk_update_request: I/O error, dev sdg, sector 26295296 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.696732] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.706197] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 32 27 70 00 00 10 00
[ 2637.714066] blk_update_request: I/O error, dev sdg, sector 26295168 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.725235] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.734710] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 32 27 60 00 00 10 00
[ 2637.742577] blk_update_request: I/O error, dev sdg, sector 26295040 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.753738] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.763199] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 32 27 50 00 00 10 00
[ 2637.771064] blk_update_request: I/O error, dev sdg, sector 26294912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.782228] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.782565] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2637.791610] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 32 27 40 00 00 10 00
[ 2637.791615] blk_update_request: I/O error, dev sdg, sector 26294784 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.801079] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 08 00 00 00 20 00 00 01 00
[ 2637.808854] blk_update_request: I/O error, dev sdg, sector 26294656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2637.839046] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2637.846607] EXT4-fs (sdg1): I/O error while writing superblock
[ 2637.854612] EXT4-fs warning: 15 callbacks suppressed
[ 2637.854628] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3287072)
[ 2637.870685] buffer_io_error: 37878 callbacks suppressed
[ 2637.870688] Buffer I/O error on device sdg1, logical block 3284992
[ 2637.882480] Buffer I/O error on device sdg1, logical block 3284993
[ 2637.888862] Buffer I/O error on device sdg1, logical block 3284994
[ 2637.895222] Buffer I/O error on device sdg1, logical block 3284995
[ 2637.901588] Buffer I/O error on device sdg1, logical block 3284996
[ 2637.907950] Buffer I/O error on device sdg1, logical block 3284997
[ 2637.914335] Buffer I/O error on device sdg1, logical block 3284998
[ 2637.917450] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2637.920710] Buffer I/O error on device sdg1, logical block 3284999
[ 2637.938569] Buffer I/O error on device sdg1, logical block 3285000
[ 2637.944948] Buffer I/O error on device sdg1, logical block 3285001
[ 2637.996342] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2638.003916] EXT4-fs (sdg1): I/O error while writing superblock
[ 2638.020755] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1876000)
[ 2638.187105] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1392672)
[ 2638.273767] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2638.287322] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 74784)
[ 2638.338171] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2638.345774] EXT4-fs (sdg1): I/O error while writing superblock
[ 2638.415067] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 905248)
[ 2638.589388] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 118816)
[ 2638.729268] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2638.744267] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 183328)
[ 2638.814596] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2638.822187] EXT4-fs (sdg1): I/O error while writing superblock
[ 2638.902005] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3459104)
[ 2639.204568] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 411680)
[ 2639.372441] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2507808)
[ 2640.773488] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2640.854517] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2640.862129] EXT4-fs (sdg1): I/O error while writing superblock
[ 2642.025488] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2642.094788] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2642.102401] EXT4-fs (sdg1): I/O error while writing superblock
[ 2642.113082] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2642.178584] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2642.186161] EXT4-fs (sdg1): I/O error while writing superblock
[ 2642.305203] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2642.334299] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2642.341885] EXT4-fs (sdg1): I/O error while writing superblock
[ 2642.353958] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2642.387260] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2642.394855] EXT4-fs (sdg1): I/O error while writing superblock
[ 2642.534305] scsi_io_completion_action: 2409 callbacks suppressed
[ 2642.534331] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.549948] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 00 48 50 00 00 10 00
[ 2642.557745] print_req_error: 2409 callbacks suppressed
[ 2642.557751] blk_update_request: I/O error, dev sdg, sector 148096 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.606487] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.609581] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2642.615983] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 00 49 50 00 00 10 00
[ 2642.615994] blk_update_request: I/O error, dev sdg, sector 150144 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.616051] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.655861] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 00 49 40 00 00 10 00
[ 2642.663739] blk_update_request: I/O error, dev sdg, sector 150016 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.674733] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.684212] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 00 49 30 00 00 10 00
[ 2642.692070] blk_update_request: I/O error, dev sdg, sector 149888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.703051] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.712512] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 00 49 20 00 00 10 00
[ 2642.720383] blk_update_request: I/O error, dev sdg, sector 149760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.731382] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.740862] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 00 49 10 00 00 10 00
[ 2642.748726] blk_update_request: I/O error, dev sdg, sector 149632 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.759729] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.769191] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 00 49 00 00 00 10 00
[ 2642.777054] blk_update_request: I/O error, dev sdg, sector 149504 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.788037] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.797508] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 00 48 f0 00 00 10 00
[ 2642.805366] blk_update_request: I/O error, dev sdg, sector 149376 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.816356] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.816739] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2642.825823] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 00 48 e0 00 00 10 00
[ 2642.825827] blk_update_request: I/O error, dev sdg, sector 149248 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.825841] blk_update_request: I/O error, dev sdg, sector 149120 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2642.865230] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 08 00 00 00 20 00 00 01 00
[ 2642.873134] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2642.880694] EXT4-fs (sdg1): I/O error while writing superblock
[ 2642.968491] EXT4-fs warning: 18 callbacks suppressed
[ 2642.968506] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 20512)
[ 2642.984391] buffer_io_error: 39926 callbacks suppressed
[ 2642.984398] Buffer I/O error on device sdg1, logical block 18432
[ 2642.995966] Buffer I/O error on device sdg1, logical block 18433
[ 2643.002152] Buffer I/O error on device sdg1, logical block 18434
[ 2643.008331] Buffer I/O error on device sdg1, logical block 18435
[ 2643.014517] Buffer I/O error on device sdg1, logical block 18436
[ 2643.020704] Buffer I/O error on device sdg1, logical block 18437
[ 2643.026895] Buffer I/O error on device sdg1, logical block 18438
[ 2643.033074] Buffer I/O error on device sdg1, logical block 18439
[ 2643.039251] Buffer I/O error on device sdg1, logical block 18440
[ 2643.045431] Buffer I/O error on device sdg1, logical block 18441
[ 2643.077202] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2643.121456] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2643.129130] EXT4-fs (sdg1): I/O error while writing superblock
[ 2643.131257] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3132448)
[ 2643.241539] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2508832)
[ 2643.456194] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2410528)
[ 2643.649105] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3329056)
[ 2643.824659] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 808992)
[ 2644.141056] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3102752)
[ 2644.325036] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2216992)
[ 2644.496695] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3393568)
[ 2644.820908] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2768928)
[ 2645.125876] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2645.208479] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2645.216074] EXT4-fs (sdg1): I/O error while writing superblock
[ 2646.030908] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2646.405203] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2646.470226] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2646.477821] EXT4-fs (sdg1): I/O error while writing superblock
[ 2646.493328] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2646.550446] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2646.558070] EXT4-fs (sdg1): I/O error while writing superblock
[ 2646.701285] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2646.752454] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2646.760311] EXT4-fs (sdg1): I/O error while writing superblock
[ 2647.033822] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2647.086239] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2647.493535] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2647.536111] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2647.544019] EXT4-fs: 1 callbacks suppressed
[ 2647.544029] EXT4-fs (sdg1): I/O error while writing superblock
[ 2647.562444] scsi_io_completion_action: 2332 callbacks suppressed
[ 2647.562471] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.578174] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 27 4a e0 00 00 10 00
[ 2647.586063] print_req_error: 2332 callbacks suppressed
[ 2647.586069] blk_update_request: I/O error, dev sdg, sector 20600576 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.602571] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.612062] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 27 4a d0 00 00 10 00
[ 2647.619934] blk_update_request: I/O error, dev sdg, sector 20600448 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.631109] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.640579] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 27 4a c0 00 00 10 00
[ 2647.648448] blk_update_request: I/O error, dev sdg, sector 20600320 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.659611] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.669086] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 27 4a b0 00 00 10 00
[ 2647.676949] blk_update_request: I/O error, dev sdg, sector 20600192 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.688124] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.697594] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 27 4a a0 00 00 10 00
[ 2647.705456] blk_update_request: I/O error, dev sdg, sector 20600064 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.716628] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.726095] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 27 4a 90 00 00 10 00
[ 2647.733955] blk_update_request: I/O error, dev sdg, sector 20599936 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.745130] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.754597] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 27 4a 80 00 00 10 00
[ 2647.762458] blk_update_request: I/O error, dev sdg, sector 20599808 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.773629] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.774084] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.783011] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 27 4a 70 00 00 10 00
[ 2647.792484] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 27 4b f0 00 00 10 00
[ 2647.800256] blk_update_request: I/O error, dev sdg, sector 20599680 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.800265] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2647.808119] blk_update_request: I/O error, dev sdg, sector 20602752 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.839805] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 27 4a 60 00 00 10 00
[ 2647.847586] blk_update_request: I/O error, dev sdg, sector 20599552 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2647.996251] EXT4-fs warning: 16 callbacks suppressed
[ 2647.996266] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2576416)
[ 2648.012322] buffer_io_error: 36854 callbacks suppressed
[ 2648.012327] Buffer I/O error on device sdg1, logical block 2574336
[ 2648.024073] Buffer I/O error on device sdg1, logical block 2574337
[ 2648.030438] Buffer I/O error on device sdg1, logical block 2574338
[ 2648.036811] Buffer I/O error on device sdg1, logical block 2574339
[ 2648.043175] Buffer I/O error on device sdg1, logical block 2574340
[ 2648.049535] Buffer I/O error on device sdg1, logical block 2574341
[ 2648.055898] Buffer I/O error on device sdg1, logical block 2574342
[ 2648.062257] Buffer I/O error on device sdg1, logical block 2574343
[ 2648.068618] Buffer I/O error on device sdg1, logical block 2574344
[ 2648.074976] Buffer I/O error on device sdg1, logical block 2574345
[ 2648.167654] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1526816)
[ 2648.322436] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2218016)
[ 2648.619180] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3463200)
[ 2648.786859] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 414752)
[ 2648.952422] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 636960)
[ 2649.160350] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3225632)
[ 2649.314418] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1422368)
[ 2649.565624] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2649.600170] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1681440)
[ 2649.646522] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2649.654309] EXT4-fs (sdg1): I/O error while writing superblock
[ 2649.669216] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2649.707152] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2649.714725] EXT4-fs (sdg1): I/O error while writing superblock
[ 2649.762067] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 806944)
[ 2650.745631] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2650.836428] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2650.844022] EXT4-fs (sdg1): I/O error while writing superblock
[ 2651.001443] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2651.082265] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2651.089842] EXT4-fs (sdg1): I/O error while writing superblock
[ 2651.309132] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2651.353916] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2651.361491] EXT4-fs (sdg1): I/O error while writing superblock
[ 2651.769154] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2651.854414] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2651.861990] EXT4-fs (sdg1): I/O error while writing superblock
[ 2652.602473] scsi_io_completion_action: 2393 callbacks suppressed
[ 2652.602505] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.618196] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 24 d1 80 00 00 10 00
[ 2652.626073] print_req_error: 2393 callbacks suppressed
[ 2652.626080] blk_update_request: I/O error, dev sdg, sector 19303424 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.642574] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.652052] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 24 d1 70 00 00 10 00
[ 2652.659924] blk_update_request: I/O error, dev sdg, sector 19303296 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.671100] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.680571] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 24 d1 60 00 00 10 00
[ 2652.688435] blk_update_request: I/O error, dev sdg, sector 19303168 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.699601] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.709068] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 24 d1 50 00 00 10 00
[ 2652.716934] blk_update_request: I/O error, dev sdg, sector 19303040 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.728096] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.737564] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 24 d1 40 00 00 10 00
[ 2652.745426] blk_update_request: I/O error, dev sdg, sector 19302912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.756591] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.766064] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 24 d1 30 00 00 10 00
[ 2652.773928] blk_update_request: I/O error, dev sdg, sector 19302784 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.785091] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.794555] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 24 d1 20 00 00 10 00
[ 2652.802422] blk_update_request: I/O error, dev sdg, sector 19302656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.813585] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.823052] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 24 d1 10 00 00 10 00
[ 2652.830919] blk_update_request: I/O error, dev sdg, sector 19302528 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.842084] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.851454] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 24 d1 00 00 00 10 00
[ 2652.859234] blk_update_request: I/O error, dev sdg, sector 19302400 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.870400] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2652.870780] blk_update_request: I/O error, dev sdg, sector 19303936 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2652.879790] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 24 d0 f0 00 00 10 00
[ 2653.159043] EXT4-fs warning: 21 callbacks suppressed
[ 2653.159061] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2733855)
[ 2653.175111] buffer_io_error: 40950 callbacks suppressed
[ 2653.175115] Buffer I/O error on device sdg1, logical block 2732032
[ 2653.186870] Buffer I/O error on device sdg1, logical block 2732033
[ 2653.193243] Buffer I/O error on device sdg1, logical block 2732034
[ 2653.199618] Buffer I/O error on device sdg1, logical block 2732035
[ 2653.205977] Buffer I/O error on device sdg1, logical block 2732036
[ 2653.212340] Buffer I/O error on device sdg1, logical block 2732037
[ 2653.218700] Buffer I/O error on device sdg1, logical block 2732038
[ 2653.225054] Buffer I/O error on device sdg1, logical block 2732039
[ 2653.231407] Buffer I/O error on device sdg1, logical block 2732040
[ 2653.237764] Buffer I/O error on device sdg1, logical block 2732041
[ 2653.278550] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2734112)
[ 2653.402376] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 144416)
[ 2653.650628] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3100704)
[ 2653.725409] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2653.802005] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2653.809586] EXT4-fs (sdg1): I/O error while writing superblock
[ 2653.837638] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2653.910358] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2653.917926] EXT4-fs (sdg1): I/O error while writing superblock
[ 2653.934764] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2215968)
[ 2653.945778] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2215956)
[ 2654.075180] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 212045)
[ 2654.198510] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 213024)
[ 2654.374468] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1842826)
[ 2654.450484] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1843232)
[ 2654.462622] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2654.909497] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2654.951953] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2654.959509] EXT4-fs (sdg1): I/O error while writing superblock
[ 2655.001143] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2655.062306] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2655.069888] EXT4-fs (sdg1): I/O error while writing superblock
[ 2655.169326] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2655.226445] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2655.234036] EXT4-fs (sdg1): I/O error while writing superblock
[ 2655.454876] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2655.518743] EXT4-fs (sdg1): I/O error while writing superblock
[ 2655.923331] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2655.990267] buffer_io_error: 1 callbacks suppressed
[ 2655.990282] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2656.002972] EXT4-fs (sdg1): I/O error while writing superblock
[ 2657.618950] scsi_io_completion_action: 2654 callbacks suppressed
[ 2657.618977] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.634596] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 1e 9a 30 00 00 10 00
[ 2657.642389] print_req_error: 2654 callbacks suppressed
[ 2657.642394] blk_update_request: I/O error, dev sdg, sector 16044416 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.658874] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.668271] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 1e 9a 20 00 00 10 00
[ 2657.676053] blk_update_request: I/O error, dev sdg, sector 16044288 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.687235] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.696698] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 1e 9a 10 00 00 10 00
[ 2657.704573] blk_update_request: I/O error, dev sdg, sector 16044160 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.715735] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.725203] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 1e 9a 00 00 00 10 00
[ 2657.733061] blk_update_request: I/O error, dev sdg, sector 16044032 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.744230] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.753692] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 1e 99 f0 00 00 10 00
[ 2657.761556] blk_update_request: I/O error, dev sdg, sector 16043904 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.772716] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.782186] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 1e 99 e0 00 00 10 00
[ 2657.790044] blk_update_request: I/O error, dev sdg, sector 16043776 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.801208] sd 0:0:0:6: [sdg] tag#14 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.810678] sd 0:0:0:6: [sdg] tag#14 CDB: opcode=0x2a 2a 00 00 1e 99 d0 00 00 10 00
[ 2657.818536] blk_update_request: I/O error, dev sdg, sector 16043648 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.829707] sd 0:0:0:6: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.830475] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.839180] sd 0:0:0:6: [sdg] tag#15 CDB: opcode=0x2a 2a 00 00 1e 99 c0 00 00 10 00
[ 2657.839185] blk_update_request: I/O error, dev sdg, sector 16043520 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.839193] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2657.848572] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 1e 9b 30 00 00 10 00
[ 2657.856435] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 1e 99 b0 00 00 10 00
[ 2657.856439] blk_update_request: I/O error, dev sdg, sector 16043392 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.856446] blk_update_request: I/O error, dev sdg, sector 16043264 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2657.868405] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2657.946294] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2657.953876] EXT4-fs (sdg1): I/O error while writing superblock
[ 2657.965088] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2657.988292] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2657.995872] EXT4-fs (sdg1): I/O error while writing superblock
[ 2658.251905] EXT4-fs warning: 24 callbacks suppressed
[ 2658.251921] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1038368)
[ 2658.268001] buffer_io_error: 44022 callbacks suppressed
[ 2658.268007] Buffer I/O error on device sdg1, logical block 1036288
[ 2658.279747] Buffer I/O error on device sdg1, logical block 1036289
[ 2658.286106] Buffer I/O error on device sdg1, logical block 1036290
[ 2658.292457] Buffer I/O error on device sdg1, logical block 1036291
[ 2658.298813] Buffer I/O error on device sdg1, logical block 1036292
[ 2658.305168] Buffer I/O error on device sdg1, logical block 1036293
[ 2658.311517] Buffer I/O error on device sdg1, logical block 1036294
[ 2658.317867] Buffer I/O error on device sdg1, logical block 1036295
[ 2658.324215] Buffer I/O error on device sdg1, logical block 1036296
[ 2658.330564] Buffer I/O error on device sdg1, logical block 1036297
[ 2658.699158] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3495968)
[ 2658.895392] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1255456)
[ 2659.005363] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2659.094490] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2659.102057] EXT4-fs (sdg1): I/O error while writing superblock
[ 2659.168639] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1878048)
[ 2659.269237] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2659.284413] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1451040)
[ 2659.336956] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2659.345908] EXT4-fs (sdg1): I/O error while writing superblock
[ 2659.388591] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 534560)
[ 2659.549389] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2659.563079] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2697248)
[ 2659.606413] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2659.613989] EXT4-fs (sdg1): I/O error while writing superblock
[ 2659.670640] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3200032)
[ 2659.802660] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 907296)
[ 2660.017199] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2660.038615] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 337952)
[ 2660.072916] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2660.080487] EXT4-fs (sdg1): I/O error while writing superblock
[ 2661.949682] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2662.034496] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2662.042098] EXT4-fs (sdg1): I/O error while writing superblock
[ 2662.061300] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2662.118367] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2662.125998] EXT4-fs (sdg1): I/O error while writing superblock
[ 2662.367883] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2662.666831] scsi_io_completion_action: 2411 callbacks suppressed
[ 2662.666863] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.682575] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 23 a0 c0 00 00 10 00
[ 2662.690445] print_req_error: 2411 callbacks suppressed
[ 2662.690450] blk_update_request: I/O error, dev sdg, sector 18679296 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.706946] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.716419] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 23 a0 b0 00 00 10 00
[ 2662.724291] blk_update_request: I/O error, dev sdg, sector 18679168 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.735455] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.744924] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 23 a0 a0 00 00 10 00
[ 2662.752787] blk_update_request: I/O error, dev sdg, sector 18679040 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.763944] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.773406] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 23 a0 90 00 00 10 00
[ 2662.781271] blk_update_request: I/O error, dev sdg, sector 18678912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.792432] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.801892] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 23 a0 80 00 00 10 00
[ 2662.809765] blk_update_request: I/O error, dev sdg, sector 18678784 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.820933] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.830398] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 23 a0 70 00 00 10 00
[ 2662.838258] blk_update_request: I/O error, dev sdg, sector 18678656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.849428] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.858901] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 23 a0 60 00 00 10 00
[ 2662.866769] blk_update_request: I/O error, dev sdg, sector 18678528 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.877937] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.887411] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 23 a0 50 00 00 10 00
[ 2662.895278] blk_update_request: I/O error, dev sdg, sector 18678400 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.906444] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.915822] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 23 a0 40 00 00 10 00
[ 2662.923600] blk_update_request: I/O error, dev sdg, sector 18678272 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.934766] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2662.935149] blk_update_request: I/O error, dev sdg, sector 18681856 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2662.944141] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 23 a0 30 00 00 10 00
[ 2663.105499] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2663.166316] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2663.173893] EXT4-fs (sdg1): I/O error while writing superblock
[ 2663.201380] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2663.259373] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2663.267004] EXT4-fs (sdg1): I/O error while writing superblock
[ 2663.286991] EXT4-fs warning: 16 callbacks suppressed
[ 2663.287009] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1714208)
[ 2663.303084] buffer_io_error: 37878 callbacks suppressed
[ 2663.303091] Buffer I/O error on device sdg1, logical block 1712128
[ 2663.314859] Buffer I/O error on device sdg1, logical block 1712129
[ 2663.321234] Buffer I/O error on device sdg1, logical block 1712130
[ 2663.327598] Buffer I/O error on device sdg1, logical block 1712131
[ 2663.333965] Buffer I/O error on device sdg1, logical block 1712132
[ 2663.340325] Buffer I/O error on device sdg1, logical block 1712133
[ 2663.346681] Buffer I/O error on device sdg1, logical block 1712134
[ 2663.353039] Buffer I/O error on device sdg1, logical block 1712135
[ 2663.359392] Buffer I/O error on device sdg1, logical block 1712136
[ 2663.361705] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2663.365738] Buffer I/O error on device sdg1, logical block 1712137
[ 2663.405488] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2663.413438] EXT4-fs (sdg1): I/O error while writing superblock
[ 2663.417070] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2663.439648] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2171936)
[ 2663.459171] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2663.466759] EXT4-fs (sdg1): I/O error while writing superblock
[ 2663.518523] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3201056)
[ 2663.666578] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3024928)
[ 2663.684892] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2663.774634] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 468000)
[ 2663.878480] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 120864)
[ 2664.023130] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 186400)
[ 2664.117077] EXT4-fs error: 1 callbacks suppressed
[ 2664.117094] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2664.152337] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 21536)
[ 2664.190509] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2664.198080] EXT4-fs: 1 callbacks suppressed
[ 2664.198092] EXT4-fs (sdg1): I/O error while writing superblock
[ 2664.270598] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2578287)
[ 2664.286058] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2578464)
[ 2666.050060] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2666.110316] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2666.117983] EXT4-fs (sdg1): I/O error while writing superblock
[ 2666.153154] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2666.222472] EXT4-fs (sdg1): I/O error while writing superblock
[ 2667.201502] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2667.278301] buffer_io_error: 1 callbacks suppressed
[ 2667.278317] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2667.290927] EXT4-fs (sdg1): I/O error while writing superblock
[ 2667.297344] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2667.357863] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2667.365429] EXT4-fs (sdg1): I/O error while writing superblock
[ 2667.457671] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2667.514336] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2667.521950] EXT4-fs (sdg1): I/O error while writing superblock
[ 2667.686195] scsi_io_completion_action: 2638 callbacks suppressed
[ 2667.686223] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.701904] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 2f 59 10 00 00 10 00
[ 2667.709779] print_req_error: 2638 callbacks suppressed
[ 2667.709784] blk_update_request: I/O error, dev sdg, sector 24823936 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.726278] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.735754] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 2f 59 00 00 00 10 00
[ 2667.743616] blk_update_request: I/O error, dev sdg, sector 24823808 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.745116] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2667.754791] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.775774] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 2f 58 f0 00 00 10 00
[ 2667.783645] blk_update_request: I/O error, dev sdg, sector 24823680 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.794826] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.804296] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 2f 58 e0 00 00 10 00
[ 2667.812167] blk_update_request: I/O error, dev sdg, sector 24823552 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.823355] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.832824] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 2f 58 d0 00 00 10 00
[ 2667.840690] blk_update_request: I/O error, dev sdg, sector 24823424 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.851861] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.861330] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 2f 58 c0 00 00 10 00
[ 2667.869193] blk_update_request: I/O error, dev sdg, sector 24823296 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.880371] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.889833] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 2f 58 b0 00 00 10 00
[ 2667.897708] blk_update_request: I/O error, dev sdg, sector 24823168 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.908880] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.909339] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.918352] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 2f 58 a0 00 00 10 00
[ 2667.918355] blk_update_request: I/O error, dev sdg, sector 24823040 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.927821] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 08 00 00 00 20 00 00 01 00
[ 2667.935689] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2667.935692] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 2f 58 90 00 00 10 00
[ 2667.946843] blk_update_request: I/O error, dev sdg, sector 256 op 0x1:(WRITE) flags 0x23800 phys_seg 1 prio class 0
[ 2667.954712] blk_update_request: I/O error, dev sdg, sector 24822912 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2667.993733] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2668.001268] EXT4-fs (sdg1): I/O error while writing superblock
[ 2668.213129] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2668.298558] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2668.306179] EXT4-fs (sdg1): I/O error while writing superblock
[ 2668.314246] EXT4-fs warning: 27 callbacks suppressed
[ 2668.314256] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3399712)
[ 2668.330283] buffer_io_error: 42080 callbacks suppressed
[ 2668.330288] Buffer I/O error on device sdg1, logical block 3398762
[ 2668.342036] Buffer I/O error on device sdg1, logical block 3398763
[ 2668.348409] Buffer I/O error on device sdg1, logical block 3398764
[ 2668.354771] Buffer I/O error on device sdg1, logical block 3398765
[ 2668.361139] Buffer I/O error on device sdg1, logical block 3398766
[ 2668.367506] Buffer I/O error on device sdg1, logical block 3398767
[ 2668.373864] Buffer I/O error on device sdg1, logical block 3398768
[ 2668.380219] Buffer I/O error on device sdg1, logical block 3398769
[ 2668.386574] Buffer I/O error on device sdg1, logical block 3398770
[ 2668.392932] Buffer I/O error on device sdg1, logical block 3398771
[ 2668.568676] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 3288096)
[ 2668.866691] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 916314)
[ 2669.061874] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 917536)
[ 2669.242099] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 123936)
[ 2669.425711] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2533408)
[ 2669.743115] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2041629)
[ 2669.766569] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2041888)
[ 2669.948655] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 908320)
[ 2670.185823] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1236633)
[ 2670.197922] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2670.280108] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2670.287688] EXT4-fs (sdg1): I/O error while writing superblock
[ 2670.305205] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2670.350380] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2670.357969] EXT4-fs (sdg1): I/O error while writing superblock
[ 2670.869890] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2671.411399] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2671.494411] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2671.502063] EXT4-fs (sdg1): I/O error while writing superblock
[ 2671.513232] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2671.576170] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2671.583748] EXT4-fs (sdg1): I/O error while writing superblock
[ 2671.677500] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2671.718127] EXT4-fs (sdg1): I/O error while writing superblock
[ 2671.965485] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2672.035255] EXT4-fs (sdg1): I/O error while writing superblock
[ 2672.417093] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2672.499153] buffer_io_error: 2 callbacks suppressed
[ 2672.499171] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2672.511844] EXT4-fs (sdg1): I/O error while writing superblock
[ 2672.738666] scsi_io_completion_action: 2281 callbacks suppressed
[ 2672.738692] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.754414] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 19 af 20 00 00 10 00
[ 2672.762300] print_req_error: 2281 callbacks suppressed
[ 2672.762306] blk_update_request: I/O error, dev sdg, sector 13465856 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.778809] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.788293] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 19 af 10 00 00 10 00
[ 2672.796167] blk_update_request: I/O error, dev sdg, sector 13465728 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.807343] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.816817] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 19 af 00 00 00 10 00
[ 2672.824694] blk_update_request: I/O error, dev sdg, sector 13465600 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.835855] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.845320] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 19 ae f0 00 00 10 00
[ 2672.853188] blk_update_request: I/O error, dev sdg, sector 13465472 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.864354] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.873817] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 19 ae e0 00 00 10 00
[ 2672.881680] blk_update_request: I/O error, dev sdg, sector 13465344 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.892859] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.902323] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 19 ae d0 00 00 10 00
[ 2672.910187] blk_update_request: I/O error, dev sdg, sector 13465216 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.921358] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.930821] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 19 ae c0 00 00 10 00
[ 2672.938687] blk_update_request: I/O error, dev sdg, sector 13465088 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.949848] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.959322] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 19 ae b0 00 00 10 00
[ 2672.967181] blk_update_request: I/O error, dev sdg, sector 13464960 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2672.978353] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2672.987729] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 19 ae a0 00 00 10 00
[ 2672.995505] blk_update_request: I/O error, dev sdg, sector 13464832 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2673.006665] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2673.007086] blk_update_request: I/O error, dev sdg, sector 16958080 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2673.016054] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 19 ae 90 00 00 10 00
[ 2673.320038] EXT4-fs warning: 19 callbacks suppressed
[ 2673.320096] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 125874)
[ 2673.336130] buffer_io_error: 34700 callbacks suppressed
[ 2673.336135] Buffer I/O error on device sdg1, logical block 123904
[ 2673.347814] Buffer I/O error on device sdg1, logical block 123905
[ 2673.354119] Buffer I/O error on device sdg1, logical block 123906
[ 2673.360424] Buffer I/O error on device sdg1, logical block 123907
[ 2673.366712] Buffer I/O error on device sdg1, logical block 123908
[ 2673.372998] Buffer I/O error on device sdg1, logical block 123909
[ 2673.379282] Buffer I/O error on device sdg1, logical block 123910
[ 2673.385564] Buffer I/O error on device sdg1, logical block 123911
[ 2673.391849] Buffer I/O error on device sdg1, logical block 123912
[ 2673.398131] Buffer I/O error on device sdg1, logical block 123913
[ 2673.486482] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 127118)
[ 2673.578608] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 128032)
[ 2673.706515] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 909344)
[ 2673.894444] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1910419)
[ 2673.962650] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1910816)
[ 2674.102755] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2860064)
[ 2674.382571] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 319520)
[ 2674.425335] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2674.490540] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2674.498189] EXT4-fs (sdg1): I/O error while writing superblock
[ 2674.537161] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2674.552343] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 56917)
[ 2674.604718] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 57376)
[ 2674.619115] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2674.628981] EXT4-fs (sdg1): I/O error while writing superblock
[ 2675.617469] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2675.702926] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2675.710524] EXT4-fs (sdg1): I/O error while writing superblock
[ 2675.857268] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2675.918063] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2675.925644] EXT4-fs (sdg1): I/O error while writing superblock
[ 2676.149341] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2676.174199] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2676.181820] EXT4-fs (sdg1): I/O error while writing superblock
[ 2676.613163] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2676.654530] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2676.662115] EXT4-fs (sdg1): I/O error while writing superblock
[ 2677.770609] scsi_io_completion_action: 2513 callbacks suppressed
[ 2677.770635] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.786332] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 01 db e0 00 00 10 00
[ 2677.794209] print_req_error: 2513 callbacks suppressed
[ 2677.794214] blk_update_request: I/O error, dev sdg, sector 974592 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2677.810537] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.820016] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 01 db d0 00 00 10 00
[ 2677.827886] blk_update_request: I/O error, dev sdg, sector 974464 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2677.838882] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.848356] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 01 db c0 00 00 10 00
[ 2677.856224] blk_update_request: I/O error, dev sdg, sector 974336 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2677.867208] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.876682] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 01 db b0 00 00 10 00
[ 2677.884545] blk_update_request: I/O error, dev sdg, sector 974208 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2677.895532] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.904999] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 01 db a0 00 00 10 00
[ 2677.912866] blk_update_request: I/O error, dev sdg, sector 974080 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2677.923856] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.933324] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 01 db 90 00 00 10 00
[ 2677.941192] blk_update_request: I/O error, dev sdg, sector 973952 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2677.952175] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.961636] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 01 db 80 00 00 10 00
[ 2677.969506] blk_update_request: I/O error, dev sdg, sector 973824 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2677.980495] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2677.989961] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 01 db 70 00 00 10 00
[ 2677.997825] blk_update_request: I/O error, dev sdg, sector 973696 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2678.008839] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2678.018213] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 01 db 60 00 00 10 00
[ 2678.025986] blk_update_request: I/O error, dev sdg, sector 973568 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2678.036980] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2678.037915] blk_update_request: I/O error, dev sdg, sector 977152 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2678.046367] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 01 db 50 00 00 10 00
[ 2678.545683] EXT4-fs warning: 23 callbacks suppressed
[ 2678.545698] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 571044)
[ 2678.561655] buffer_io_error: 40950 callbacks suppressed
[ 2678.561660] Buffer I/O error on device sdg1, logical block 569344
[ 2678.573322] Buffer I/O error on device sdg1, logical block 569345
[ 2678.579597] Buffer I/O error on device sdg1, logical block 569346
[ 2678.585880] Buffer I/O error on device sdg1, logical block 569347
[ 2678.592159] Buffer I/O error on device sdg1, logical block 569348
[ 2678.594577] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2678.598434] Buffer I/O error on device sdg1, logical block 569349
[ 2678.598440] Buffer I/O error on device sdg1, logical block 569350
[ 2678.598444] Buffer I/O error on device sdg1, logical block 569351
[ 2678.598449] Buffer I/O error on device sdg1, logical block 569352
[ 2678.634974] Buffer I/O error on device sdg1, logical block 569353
[ 2678.695014] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2678.702607] EXT4-fs (sdg1): I/O error while writing superblock
[ 2678.718606] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 571424)
[ 2678.999138] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 1783840)
[ 2679.274655] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1976135)
[ 2679.311033] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1976352)
[ 2679.502032] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1943306)
[ 2679.586619] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 1943584)
[ 2679.598370] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2679.893384] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2679.930489] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 852000)
[ 2679.941571] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 851953)
[ 2680.000834] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2680.008478] EXT4-fs (sdg1): I/O error while writing superblock
[ 2680.165615] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2680.202304] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 272416)
[ 2680.230551] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2680.238119] EXT4-fs (sdg1): I/O error while writing superblock
[ 2680.473113] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2680.538369] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2680.545969] EXT4-fs (sdg1): I/O error while writing superblock
[ 2680.981165] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2681.038305] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2681.045881] EXT4-fs (sdg1): I/O error while writing superblock
[ 2682.826235] scsi_io_completion_action: 2175 callbacks suppressed
[ 2682.826264] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2682.841972] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 19 30 90 00 00 10 00
[ 2682.849854] print_req_error: 2175 callbacks suppressed
[ 2682.849860] blk_update_request: I/O error, dev sdg, sector 13206656 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2682.866362] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2682.875846] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 19 30 80 00 00 10 00
[ 2682.883712] blk_update_request: I/O error, dev sdg, sector 13206528 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2682.894884] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2682.904356] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 19 30 70 00 00 10 00
[ 2682.912223] blk_update_request: I/O error, dev sdg, sector 13206400 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2682.923387] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2682.932858] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 19 30 60 00 00 10 00
[ 2682.940719] blk_update_request: I/O error, dev sdg, sector 13206272 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2682.951877] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2682.961340] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 19 30 50 00 00 10 00
[ 2682.969201] blk_update_request: I/O error, dev sdg, sector 13206144 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2682.980367] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2682.989835] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 19 30 40 00 00 10 00
[ 2682.997701] blk_update_request: I/O error, dev sdg, sector 13206016 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2683.008867] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2683.018328] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 19 30 30 00 00 10 00
[ 2683.026191] blk_update_request: I/O error, dev sdg, sector 13205888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2683.037358] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2683.046821] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 19 30 20 00 00 10 00
[ 2683.054679] blk_update_request: I/O error, dev sdg, sector 13205760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2683.065841] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2683.075217] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 2f dc 10 00 00 10 00
[ 2683.082987] blk_update_request: I/O error, dev sdg, sector 25092224 op 0x1:(WRITE) flags 0x0 phys_seg 16 prio class 0
[ 2683.093885] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2683.094269] blk_update_request: I/O error, dev sdg, sector 13207168 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2683.103271] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 2f dc 00 00 00 10 00
[ 2683.109420] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2683.154328] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2683.162086] EXT4-fs (sdg1): I/O error while writing superblock
[ 2683.626603] EXT4-fs warning: 19 callbacks suppressed
[ 2683.626619] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 843139)
[ 2683.642579] buffer_io_error: 36854 callbacks suppressed
[ 2683.642584] Buffer I/O error on device sdg1, logical block 841728
[ 2683.654240] Buffer I/O error on device sdg1, logical block 841729
[ 2683.660530] Buffer I/O error on device sdg1, logical block 841730
[ 2683.666820] Buffer I/O error on device sdg1, logical block 841731
[ 2683.673095] Buffer I/O error on device sdg1, logical block 841732
[ 2683.679372] Buffer I/O error on device sdg1, logical block 841733
[ 2683.685650] Buffer I/O error on device sdg1, logical block 841734
[ 2683.691932] Buffer I/O error on device sdg1, logical block 841735
[ 2683.698206] Buffer I/O error on device sdg1, logical block 841736
[ 2683.704478] Buffer I/O error on device sdg1, logical block 841737
[ 2683.800004] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 843808)
[ 2684.120276] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2369568)
[ 2684.337308] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2684.446263] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2684.453830] EXT4-fs (sdg1): I/O error while writing superblock
[ 2684.455706] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 911392)
[ 2684.617140] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2684.724416] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2684.731991] EXT4-fs (sdg1): I/O error while writing superblock
[ 2684.752284] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1046560)
[ 2684.851902] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 385056)
[ 2684.925115] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2684.986336] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2684.993910] EXT4-fs (sdg1): I/O error while writing superblock
[ 2684.995647] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1090961)
[ 2685.060469] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1091616)
[ 2685.152725] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1637408)
[ 2685.232206] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2416322)
[ 2685.453028] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2685.522400] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2685.529972] EXT4-fs (sdg1): I/O error while writing superblock
[ 2687.529579] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2687.600263] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2687.607843] EXT4-fs (sdg1): I/O error while writing superblock
[ 2687.637313] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2687.698634] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2687.706214] EXT4-fs (sdg1): I/O error while writing superblock
[ 2687.882451] scsi_io_completion_action: 2334 callbacks suppressed
[ 2687.882481] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2687.898160] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 0e a1 30 00 00 10 00
[ 2687.906036] print_req_error: 2334 callbacks suppressed
[ 2687.906043] blk_update_request: I/O error, dev sdg, sector 7670144 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2687.922444] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2687.931941] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 0e a1 20 00 00 10 00
[ 2687.939805] blk_update_request: I/O error, dev sdg, sector 7670016 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2687.950892] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2687.960359] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 0e a1 10 00 00 10 00
[ 2687.968235] blk_update_request: I/O error, dev sdg, sector 7669888 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2687.979311] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2687.988775] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 0e a1 00 00 00 10 00
[ 2687.996640] blk_update_request: I/O error, dev sdg, sector 7669760 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2688.007707] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2688.017169] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 0e a0 f0 00 00 10 00
[ 2688.025038] blk_update_request: I/O error, dev sdg, sector 7669632 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2688.036126] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2688.045601] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 0e a0 e0 00 00 10 00
[ 2688.053460] blk_update_request: I/O error, dev sdg, sector 7669504 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2688.064543] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2688.074006] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 0e a0 d0 00 00 10 00
[ 2688.081872] blk_update_request: I/O error, dev sdg, sector 7669376 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2688.092957] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2688.102427] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 0e a0 c0 00 00 10 00
[ 2688.110285] blk_update_request: I/O error, dev sdg, sector 7669248 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2688.121361] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2688.130734] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 0e a0 b0 00 00 10 00
[ 2688.138507] blk_update_request: I/O error, dev sdg, sector 7669120 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2688.149585] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2688.149964] blk_update_request: I/O error, dev sdg, sector 7672704 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2688.158968] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 0e a0 a0 00 00 10 00
[ 2688.572263] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2688.818879] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2688.858810] EXT4-fs warning: 19 callbacks suppressed
[ 2688.858826] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1048608)
[ 2688.874861] buffer_io_error: 36854 callbacks suppressed
[ 2688.874866] Buffer I/O error on device sdg1, logical block 1046528
[ 2688.886604] Buffer I/O error on device sdg1, logical block 1046529
[ 2688.892972] Buffer I/O error on device sdg1, logical block 1046530
[ 2688.899332] Buffer I/O error on device sdg1, logical block 1046531
[ 2688.905687] Buffer I/O error on device sdg1, logical block 1046532
[ 2688.912049] Buffer I/O error on device sdg1, logical block 1046533
[ 2688.918408] Buffer I/O error on device sdg1, logical block 1046534
[ 2688.924765] Buffer I/O error on device sdg1, logical block 1046535
[ 2688.931115] Buffer I/O error on device sdg1, logical block 1046536
[ 2688.937472] Buffer I/O error on device sdg1, logical block 1046537
[ 2688.949130] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3498371)
[ 2688.995397] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2689.003135] EXT4-fs (sdg1): I/O error while writing superblock
[ 2689.099283] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3499018)
[ 2689.105476] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2689.154320] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2689.161921] EXT4-fs (sdg1): I/O error while writing superblock
[ 2689.178507] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3500064)
[ 2689.239000] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1638432)
[ 2689.308175] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 3073394)
[ 2689.393228] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2689.446761] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2689.454335] EXT4-fs (sdg1): I/O error while writing superblock
[ 2689.474559] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 3074986)
[ 2689.506453] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 3075104)
[ 2689.615034] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3334176)
[ 2689.738534] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2580255)
[ 2689.885069] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2689.934791] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2689.942356] EXT4-fs (sdg1): I/O error while writing superblock
[ 2691.861638] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2691.954329] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2691.961939] EXT4-fs (sdg1): I/O error while writing superblock
[ 2691.969181] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2691.994208] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2692.001768] EXT4-fs (sdg1): I/O error while writing superblock
[ 2692.906642] scsi_io_completion_action: 2548 callbacks suppressed
[ 2692.906667] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2692.922280] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 35 77 f1 00 00 10 00
[ 2692.930075] print_req_error: 2548 callbacks suppressed
[ 2692.930081] blk_update_request: I/O error, dev sdg, sector 28032904 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2692.946583] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2692.955978] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 35 77 e1 00 00 10 00
[ 2692.963756] blk_update_request: I/O error, dev sdg, sector 28032776 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2692.974939] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2692.984409] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 35 77 d1 00 00 10 00
[ 2692.992286] blk_update_request: I/O error, dev sdg, sector 28032648 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.003455] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2693.012921] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 35 77 c1 00 00 10 00
[ 2693.020780] blk_update_request: I/O error, dev sdg, sector 28032520 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.031942] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2693.033574] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2693.041411] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 35 77 b1 00 00 10 00
[ 2693.041415] blk_update_request: I/O error, dev sdg, sector 28032392 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.041430] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2693.041432] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 35 77 a1 00 00 10 00
[ 2693.089277] blk_update_request: I/O error, dev sdg, sector 28032264 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.100445] sd 0:0:0:6: [sdg] tag#14 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2693.101294] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2693.109911] sd 0:0:0:6: [sdg] tag#14 CDB: opcode=0x2a 2a 00 00 35 77 91 00 00 10 00
[ 2693.119378] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 2e ec f0 00 00 10 00
[ 2693.119384] blk_update_request: I/O error, dev sdg, sector 24602496 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.127248] blk_update_request: I/O error, dev sdg, sector 28032136 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.127256] sd 0:0:0:6: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2693.135123] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2693.146267] sd 0:0:0:6: [sdg] tag#15 CDB: opcode=0x2a 2a 00 00 35 77 81 00 00 10 00
[ 2693.146270] blk_update_request: I/O error, dev sdg, sector 28032008 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.157423] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 2e ec e0 00 00 10 00
[ 2693.157426] blk_update_request: I/O error, dev sdg, sector 24602368 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2693.239668] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2693.247654] EXT4-fs (sdg1): I/O error while writing superblock
[ 2693.314154] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2693.351025] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2693.358667] EXT4-fs (sdg1): I/O error while writing superblock
[ 2693.577532] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2693.651261] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2693.658820] EXT4-fs (sdg1): I/O error while writing superblock
[ 2694.054336] EXT4-fs warning: 24 callbacks suppressed
[ 2694.054352] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3402489)
[ 2694.057011] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2694.059499] buffer_io_error: 43216 callbacks suppressed
[ 2694.059504] Buffer I/O error on device sdg1, logical block 3400922
[ 2694.093604] Buffer I/O error on device sdg1, logical block 3400923
[ 2694.099981] Buffer I/O error on device sdg1, logical block 3400924
[ 2694.106354] Buffer I/O error on device sdg1, logical block 3400925
[ 2694.109577] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 3402784)
[ 2694.112715] Buffer I/O error on device sdg1, logical block 3400926
[ 2694.123603] Buffer I/O error on device sdg1, logical block 3402457
[ 2694.129940] Buffer I/O error on device sdg1, logical block 3400927
[ 2694.136303] Buffer I/O error on device sdg1, logical block 3402458
[ 2694.142626] Buffer I/O error on device sdg1, logical block 3400928
[ 2694.148968] Buffer I/O error on device sdg1, logical block 3402459
[ 2694.186663] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2694.194241] EXT4-fs (sdg1): I/O error while writing superblock
[ 2694.442541] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 62738)
[ 2694.606572] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 64544)
[ 2694.736314] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3111033)
[ 2694.962496] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3112641)
[ 2694.979744] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3112992)
[ 2695.101280] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 338976)
[ 2695.278304] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2910545)
[ 2695.466415] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2912075)
[ 2696.026668] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2696.114214] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2696.121784] EXT4-fs (sdg1): I/O error while writing superblock
[ 2696.129494] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2696.182584] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2696.190428] EXT4-fs (sdg1): I/O error while writing superblock
[ 2696.533609] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2697.178313] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2697.273710] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2697.281326] EXT4-fs (sdg1): I/O error while writing superblock
[ 2697.449535] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2697.518526] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2697.526115] EXT4-fs (sdg1): I/O error while writing superblock
[ 2697.705736] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2697.767443] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2697.775023] EXT4-fs (sdg1): I/O error while writing superblock
[ 2697.915191] scsi_io_completion_action: 2553 callbacks suppressed
[ 2697.915222] sd 0:0:0:6: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2697.930922] sd 0:0:0:6: [sdg] tag#23 CDB: opcode=0x2a 2a 00 00 33 f9 df 00 00 10 00
[ 2697.938810] print_req_error: 2553 callbacks suppressed
[ 2697.938816] blk_update_request: I/O error, dev sdg, sector 27250424 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2697.990446] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2697.999951] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 33 fa df 00 00 10 00
[ 2698.007837] blk_update_request: I/O error, dev sdg, sector 27252472 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.019035] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.028526] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 33 fa cf 00 00 10 00
[ 2698.036393] blk_update_request: I/O error, dev sdg, sector 27252344 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.047560] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.057033] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 33 fa bf 00 00 10 00
[ 2698.064899] blk_update_request: I/O error, dev sdg, sector 27252216 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.076064] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.085533] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 33 fa af 00 00 10 00
[ 2698.093393] blk_update_request: I/O error, dev sdg, sector 27252088 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.104557] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.114014] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 33 fa 9f 00 00 10 00
[ 2698.121875] blk_update_request: I/O error, dev sdg, sector 27251960 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.133042] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.142506] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 33 fa 8f 00 00 10 00
[ 2698.150365] blk_update_request: I/O error, dev sdg, sector 27251832 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.161534] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.171003] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 33 fa 7f 00 00 10 00
[ 2698.178872] blk_update_request: I/O error, dev sdg, sector 27251704 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.185245] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2698.190036] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.190040] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 33 fa 6f 00 00 10 00
[ 2698.218866] blk_update_request: I/O error, dev sdg, sector 27251576 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.230038] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2698.239412] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 33 fa 5f 00 00 10 00
[ 2698.247185] blk_update_request: I/O error, dev sdg, sector 27251448 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2698.297919] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2698.305479] EXT4-fs (sdg1): I/O error while writing superblock
[ 2699.166437] EXT4-fs warning: 21 callbacks suppressed
[ 2699.166452] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2221088)
[ 2699.182507] buffer_io_error: 41756 callbacks suppressed
[ 2699.182513] Buffer I/O error on device sdg1, logical block 2220032
[ 2699.194248] Buffer I/O error on device sdg1, logical block 2220033
[ 2699.200624] Buffer I/O error on device sdg1, logical block 2220034
[ 2699.206996] Buffer I/O error on device sdg1, logical block 2220035
[ 2699.213364] Buffer I/O error on device sdg1, logical block 2220036
[ 2699.219728] Buffer I/O error on device sdg1, logical block 2220037
[ 2699.226087] Buffer I/O error on device sdg1, logical block 2220038
[ 2699.232446] Buffer I/O error on device sdg1, logical block 2220039
[ 2699.238807] Buffer I/O error on device sdg1, logical block 2220040
[ 2699.245165] Buffer I/O error on device sdg1, logical block 2220041
[ 2699.574399] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2915447)
[ 2699.762553] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2916384)
[ 2699.934504] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 3204128)
[ 2700.177405] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2700.254373] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2700.264532] EXT4-fs (sdg1): I/O error while writing superblock
[ 2700.285237] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2700.341505] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 260836)
[ 2700.402399] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2700.410044] EXT4-fs (sdg1): I/O error while writing superblock
[ 2700.531868] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 262176)
[ 2700.662478] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3140886)
[ 2700.842018] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3142465)
[ 2701.024386] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3143712)
[ 2701.151880] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 814036)
[ 2701.453382] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2701.542442] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2701.550021] EXT4-fs (sdg1): I/O error while writing superblock
[ 2701.689550] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2701.735307] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2701.742924] EXT4-fs (sdg1): I/O error while writing superblock
[ 2701.761186] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2701.803824] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2701.811408] EXT4-fs (sdg1): I/O error while writing superblock
[ 2701.973345] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2702.025989] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2702.033572] EXT4-fs (sdg1): I/O error while writing superblock
[ 2702.453295] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2702.542351] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2702.549924] EXT4-fs (sdg1): I/O error while writing superblock
[ 2703.002327] scsi_io_completion_action: 2456 callbacks suppressed
[ 2703.002352] sd 0:0:0:6: [sdg] tag#24 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.018051] sd 0:0:0:6: [sdg] tag#24 CDB: opcode=0x2a 2a 00 00 21 ec c0 00 00 10 00
[ 2703.025926] print_req_error: 2456 callbacks suppressed
[ 2703.025931] blk_update_request: I/O error, dev sdg, sector 17786368 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.042425] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.051912] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 21 ec b0 00 00 10 00
[ 2703.059787] blk_update_request: I/O error, dev sdg, sector 17786240 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.070976] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.080449] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 21 ec a0 00 00 10 00
[ 2703.088317] blk_update_request: I/O error, dev sdg, sector 17786112 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.099482] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.108956] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 21 ec 90 00 00 10 00
[ 2703.116823] blk_update_request: I/O error, dev sdg, sector 17785984 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.127989] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.137448] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 21 ec 80 00 00 10 00
[ 2703.145318] blk_update_request: I/O error, dev sdg, sector 17785856 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.156477] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.165942] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 21 ec 70 00 00 10 00
[ 2703.173799] blk_update_request: I/O error, dev sdg, sector 17785728 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.184970] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.194431] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 21 ec 60 00 00 10 00
[ 2703.202295] blk_update_request: I/O error, dev sdg, sector 17785600 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.213460] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.222928] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 21 ec 50 00 00 10 00
[ 2703.230790] blk_update_request: I/O error, dev sdg, sector 17785472 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.241956] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.251328] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 21 ec 40 00 00 10 00
[ 2703.259105] blk_update_request: I/O error, dev sdg, sector 17785344 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.270269] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2703.270611] blk_update_request: I/O error, dev sdg, sector 17786880 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2703.279649] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 21 ec 30 00 00 10 00
[ 2704.320590] EXT4-fs warning: 14 callbacks suppressed
[ 2704.320615] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 323616)
[ 2704.336625] buffer_io_error: 39544 callbacks suppressed
[ 2704.336634] Buffer I/O error on device sdg1, logical block 321154
[ 2704.348313] Buffer I/O error on device sdg1, logical block 321155
[ 2704.354596] Buffer I/O error on device sdg1, logical block 321156
[ 2704.360873] Buffer I/O error on device sdg1, logical block 321157
[ 2704.367139] Buffer I/O error on device sdg1, logical block 321158
[ 2704.373414] Buffer I/O error on device sdg1, logical block 321159
[ 2704.379684] Buffer I/O error on device sdg1, logical block 321160
[ 2704.385952] Buffer I/O error on device sdg1, logical block 321161
[ 2704.392218] Buffer I/O error on device sdg1, logical block 321162
[ 2704.398494] Buffer I/O error on device sdg1, logical block 321163
[ 2704.409229] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2704.466137] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2704.473712] EXT4-fs (sdg1): I/O error while writing superblock
[ 2704.501235] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2704.544131] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2704.551713] EXT4-fs (sdg1): I/O error while writing superblock
[ 2704.594717] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3145472)
[ 2704.612658] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3145760)
[ 2704.757205] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2614977)
[ 2704.804426] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 2615328)
[ 2704.816169] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2704.994385] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 819232)
[ 2705.205930] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2240513)
[ 2705.242393] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2240544)
[ 2705.415019] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2818080)
[ 2705.585271] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2705.646550] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2705.654143] EXT4-fs (sdg1): I/O error while writing superblock
[ 2705.659937] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1042558)
[ 2705.833179] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2705.903030] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2705.910994] EXT4-fs (sdg1): I/O error while writing superblock
[ 2706.085681] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2706.119182] EXT4-fs (sdg1): I/O error while writing superblock
[ 2706.561324] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2706.627842] buffer_io_error: 1 callbacks suppressed
[ 2706.627859] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2706.640478] EXT4-fs (sdg1): I/O error while writing superblock
[ 2708.062486] scsi_io_completion_action: 2575 callbacks suppressed
[ 2708.062512] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.078117] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 04 f8 40 00 00 10 00
[ 2708.085926] print_req_error: 2575 callbacks suppressed
[ 2708.085932] blk_update_request: I/O error, dev sdg, sector 2605568 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.102342] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.111744] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 04 f8 30 00 00 10 00
[ 2708.119529] blk_update_request: I/O error, dev sdg, sector 2605440 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.130618] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.140096] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 04 f8 20 00 00 10 00
[ 2708.147972] blk_update_request: I/O error, dev sdg, sector 2605312 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.159046] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.168517] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 04 f8 10 00 00 10 00
[ 2708.176380] blk_update_request: I/O error, dev sdg, sector 2605184 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.187457] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.196926] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 04 f8 00 00 00 10 00
[ 2708.204786] blk_update_request: I/O error, dev sdg, sector 2605056 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.215855] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.225325] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 04 f7 f0 00 00 10 00
[ 2708.233184] blk_update_request: I/O error, dev sdg, sector 2604928 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.244264] sd 0:0:0:6: [sdg] tag#14 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.245391] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.253731] sd 0:0:0:6: [sdg] tag#14 CDB: opcode=0x2a 2a 00 00 04 f7 e0 00 00 10 00
[ 2708.263129] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 04 f9 40 00 00 10 00
[ 2708.270982] blk_update_request: I/O error, dev sdg, sector 2604800 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.278752] blk_update_request: I/O error, dev sdg, sector 2607616 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.278775] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.289828] sd 0:0:0:6: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2708.300892] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 04 f9 30 00 00 10 00
[ 2708.300897] blk_update_request: I/O error, dev sdg, sector 2607488 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.310270] sd 0:0:0:6: [sdg] tag#15 CDB: opcode=0x2a 2a 00 00 04 f7 d0 00 00 10 00
[ 2708.310274] blk_update_request: I/O error, dev sdg, sector 2604672 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2708.534905] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2708.626258] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2708.633888] EXT4-fs (sdg1): I/O error while writing superblock
[ 2709.486434] EXT4-fs warning: 17 callbacks suppressed
[ 2709.486452] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 1716256)
[ 2709.502516] buffer_io_error: 40308 callbacks suppressed
[ 2709.502521] Buffer I/O error on device sdg1, logical block 1714176
[ 2709.514282] Buffer I/O error on device sdg1, logical block 1714177
[ 2709.520668] Buffer I/O error on device sdg1, logical block 1714178
[ 2709.527038] Buffer I/O error on device sdg1, logical block 1714179
[ 2709.533405] Buffer I/O error on device sdg1, logical block 1714180
[ 2709.539776] Buffer I/O error on device sdg1, logical block 1714181
[ 2709.546140] Buffer I/O error on device sdg1, logical block 1714182
[ 2709.552505] Buffer I/O error on device sdg1, logical block 1714183
[ 2709.558870] Buffer I/O error on device sdg1, logical block 1714184
[ 2709.565231] Buffer I/O error on device sdg1, logical block 1714185
[ 2709.701357] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2709.794782] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2709.802361] EXT4-fs (sdg1): I/O error while writing superblock
[ 2709.876327] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 2011168)
[ 2709.973360] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2710.010440] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1044512)
[ 2710.050312] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2710.057874] EXT4-fs (sdg1): I/O error while writing superblock
[ 2710.234224] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1191902)
[ 2710.249228] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2710.263110] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1191968)
[ 2710.308341] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2710.316294] EXT4-fs (sdg1): I/O error while writing superblock
[ 2710.372081] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1322016)
[ 2710.494414] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2129952)
[ 2710.705187] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2710.707624] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1632655)
[ 2710.806551] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2710.814121] EXT4-fs (sdg1): I/O error while writing superblock
[ 2710.900463] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1633312)
[ 2711.307841] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1767554)
[ 2712.713441] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2712.782423] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2712.790011] EXT4-fs (sdg1): I/O error while writing superblock
[ 2713.072915] scsi_io_completion_action: 2252 callbacks suppressed
[ 2713.072943] sd 0:0:0:6: [sdg] tag#19 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.088625] sd 0:0:0:6: [sdg] tag#19 CDB: opcode=0x2a 2a 00 00 2c b6 f0 00 00 10 00
[ 2713.096500] print_req_error: 2252 callbacks suppressed
[ 2713.096506] blk_update_request: I/O error, dev sdg, sector 23443328 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.112988] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.122462] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 2c b6 e0 00 00 10 00
[ 2713.130328] blk_update_request: I/O error, dev sdg, sector 23443200 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.141512] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.150976] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 00 00 2c b6 d0 00 00 10 00
[ 2713.158836] blk_update_request: I/O error, dev sdg, sector 23443072 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.171752] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.181141] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 2c b7 80 00 00 10 00
[ 2713.188915] blk_update_request: I/O error, dev sdg, sector 23444480 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.200086] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.209561] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 2c b7 70 00 00 10 00
[ 2713.217426] blk_update_request: I/O error, dev sdg, sector 23444352 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.228606] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.238078] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 2c b7 60 00 00 10 00
[ 2713.245944] blk_update_request: I/O error, dev sdg, sector 23444224 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.257111] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.257601] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.266576] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 2c b7 50 00 00 10 00
[ 2713.275954] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 2c b7 d0 00 00 10 00
[ 2713.283810] blk_update_request: I/O error, dev sdg, sector 23444096 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.283822] sd 0:0:0:6: [sdg] tag#13 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.291596] blk_update_request: I/O error, dev sdg, sector 23445120 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.291633] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2713.292417] blk_update_request: I/O error, dev sdg, sector 23445248 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.302762] sd 0:0:0:6: [sdg] tag#13 CDB: opcode=0x2a 2a 00 00 2c b7 40 00 00 10 00
[ 2713.302765] blk_update_request: I/O error, dev sdg, sector 23443968 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2713.362931] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 2c b7 c0 00 00 10 00
[ 2714.522235] EXT4-fs warning: 20 callbacks suppressed
[ 2714.522252] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1769236)
[ 2714.538298] buffer_io_error: 38260 callbacks suppressed
[ 2714.538302] Buffer I/O error on device sdg1, logical block 1768448
[ 2714.550047] Buffer I/O error on device sdg1, logical block 1768449
[ 2714.556423] Buffer I/O error on device sdg1, logical block 1768450
[ 2714.562785] Buffer I/O error on device sdg1, logical block 1768451
[ 2714.569140] Buffer I/O error on device sdg1, logical block 1768452
[ 2714.575499] Buffer I/O error on device sdg1, logical block 1768453
[ 2714.581858] Buffer I/O error on device sdg1, logical block 1768454
[ 2714.588220] Buffer I/O error on device sdg1, logical block 1768455
[ 2714.594584] Buffer I/O error on device sdg1, logical block 1768456
[ 2714.600947] Buffer I/O error on device sdg1, logical block 1768457
[ 2714.686293] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1769504)
[ 2714.812811] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3026766)
[ 2714.829009] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3026767)
[ 2714.891126] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 1552416)
[ 2714.957239] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3467135)
[ 2714.968345] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 3467134)
[ 2715.377435] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3158048)
[ 2715.404112] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 1535095)
[ 2715.442611] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 996750)
[ 2716.214019] Buffer I/O error on dev sdg1, logical block 5, lost async page write
[ 2718.078767] scsi_io_completion_action: 3577 callbacks suppressed
[ 2718.078805] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.094538] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 16 34 50 00 00 10 00
[ 2718.102352] print_req_error: 3577 callbacks suppressed
[ 2718.102358] blk_update_request: I/O error, dev sdg, sector 11641472 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.118877] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.128284] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 16 34 60 00 00 10 00
[ 2718.136086] blk_update_request: I/O error, dev sdg, sector 11641600 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.147292] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.147932] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.156684] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 09 43 50 00 00 10 00
[ 2718.166157] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 34 ff 28 00 00 10 00
[ 2718.173933] blk_update_request: I/O error, dev sdg, sector 4856448 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.173966] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.181806] blk_update_request: I/O error, dev sdg, sector 27785536 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.213428] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 00 00 09 43 40 00 00 10 00
[ 2718.221223] blk_update_request: I/O error, dev sdg, sector 4856320 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.232345] sd 0:0:0:6: [sdg] tag#10 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.233474] sd 0:0:0:6: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.241839] sd 0:0:0:6: [sdg] tag#10 CDB: opcode=0x2a 2a 00 00 34 ff 18 00 00 10 00
[ 2718.251296] sd 0:0:0:6: [sdg] tag#22 CDB: opcode=0x2a 2a 00 00 34 ff 48 00 00 10 00
[ 2718.251305] blk_update_request: I/O error, dev sdg, sector 27785792 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.259169] blk_update_request: I/O error, dev sdg, sector 27785408 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.259207] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.298848] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 00 00 34 ff 08 00 00 10 00
[ 2718.306725] blk_update_request: I/O error, dev sdg, sector 27785280 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2718.317934] sd 0:0:0:6: [sdg] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.319188] sd 0:0:0:6: [sdg] tag#30 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2718.327428] sd 0:0:0:6: [sdg] tag#12 CDB: opcode=0x2a 2a 00 00 23 28 d0 00 00 10 00
[ 2718.336892] sd 0:0:0:6: [sdg] tag#30 CDB: opcode=0x2a 2a 00 00 37 32 31 00 00 10 00
[ 2718.336900] blk_update_request: I/O error, dev sdg, sector 28938632 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2718.344772] blk_update_request: I/O error, dev sdg, sector 18433664 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2719.556867] EXT4-fs warning: 38 callbacks suppressed
[ 2719.556885] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 21 starting block 471072)
[ 2719.572852] buffer_io_error: 52848 callbacks suppressed
[ 2719.572857] Buffer I/O error on device sdg1, logical block 468992
[ 2719.584532] Buffer I/O error on device sdg1, logical block 468993
[ 2719.590823] Buffer I/O error on device sdg1, logical block 468994
[ 2719.597126] Buffer I/O error on device sdg1, logical block 468995
[ 2719.603418] Buffer I/O error on device sdg1, logical block 468996
[ 2719.609702] Buffer I/O error on device sdg1, logical block 468997
[ 2719.615982] Buffer I/O error on device sdg1, logical block 468998
[ 2719.622261] Buffer I/O error on device sdg1, logical block 468999
[ 2719.628537] Buffer I/O error on device sdg1, logical block 469000
[ 2719.634812] Buffer I/O error on device sdg1, logical block 469001
[ 2720.052314] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1816608)
[ 2720.065290] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 1816573)
[ 2720.092725] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3618836)
[ 2720.219140] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2373664)
[ 2720.247216] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2863137)
[ 2720.379336] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1880096)
[ 2720.794585] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 3160096)
[ 2720.916612] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 3291168)
[ 2720.940618] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 931872)
[ 2723.098314] scsi_io_completion_action: 3373 callbacks suppressed
[ 2723.098384] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.114069] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 11 2f f0 00 00 10 00
[ 2723.121888] print_req_error: 3373 callbacks suppressed
[ 2723.121896] blk_update_request: I/O error, dev sdg, sector 9011072 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2723.138308] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.147708] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 11 2f e0 00 00 10 00
[ 2723.155491] blk_update_request: I/O error, dev sdg, sector 9010944 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2723.166642] sd 0:0:0:6: [sdg] tag#14 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.167996] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.176130] sd 0:0:0:6: [sdg] tag#14 CDB: opcode=0x2a 2a 00 00 18 35 00 00 00 10 00
[ 2723.185606] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 06 b4 c0 00 00 10 00
[ 2723.185616] blk_update_request: I/O error, dev sdg, sector 3515904 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2723.193486] blk_update_request: I/O error, dev sdg, sector 12691456 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2723.193525] sd 0:0:0:6: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.233069] sd 0:0:0:6: [sdg] tag#15 CDB: opcode=0x2a 2a 00 00 18 34 f0 00 00 10 00
[ 2723.240954] blk_update_request: I/O error, dev sdg, sector 12691328 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2723.266226] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.273157] sd 0:0:0:6: [sdg] tag#14 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.275704] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 27 60 c0 00 00 10 00
[ 2723.285175] sd 0:0:0:6: [sdg] tag#14 CDB: opcode=0x2a 2a 00 00 13 2b f0 00 00 10 00
[ 2723.293025] blk_update_request: I/O error, dev sdg, sector 20645376 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2723.300899] blk_update_request: I/O error, dev sdg, sector 10051456 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2723.312089] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.323274] sd 0:0:0:6: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.332698] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 18 31 51 00 00 10 00
[ 2723.332704] blk_update_request: I/O error, dev sdg, sector 12683912 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2723.342175] sd 0:0:0:6: [sdg] tag#15 CDB: opcode=0x2a 2a 00 00 13 2b e0 00 00 10 00
[ 2723.350051] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2723.361203] blk_update_request: I/O error, dev sdg, sector 10051328 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2723.369060] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 18 31 41 00 00 10 00
[ 2723.369064] blk_update_request: I/O error, dev sdg, sector 12683784 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2724.703840] EXT4-fs warning: 26 callbacks suppressed
[ 2724.703854] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1587232)
[ 2724.719894] buffer_io_error: 51465 callbacks suppressed
[ 2724.719898] Buffer I/O error on device sdg1, logical block 1586096
[ 2724.731633] Buffer I/O error on device sdg1, logical block 1586097
[ 2724.737985] Buffer I/O error on device sdg1, logical block 1586098
[ 2724.744338] Buffer I/O error on device sdg1, logical block 1586099
[ 2724.750699] Buffer I/O error on device sdg1, logical block 1586100
[ 2724.757053] Buffer I/O error on device sdg1, logical block 1586101
[ 2724.763410] Buffer I/O error on device sdg1, logical block 1586102
[ 2724.769759] Buffer I/O error on device sdg1, logical block 1586103
[ 2724.776108] Buffer I/O error on device sdg1, logical block 1586104
[ 2724.782459] Buffer I/O error on device sdg1, logical block 1586105
[ 2724.812420] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2275208)
[ 2724.845961] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2519351)
[ 2724.954178] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 1257504)
[ 2724.987576] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 27 starting block 2275360)
[ 2725.014394] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2830369)
[ 2725.094847] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2831967)
[ 2725.106579] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2831966)
[ 2725.175829] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 2832075)
[ 2725.310320] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 2582428)
[ 2728.106419] scsi_io_completion_action: 3049 callbacks suppressed
[ 2728.106451] sd 0:0:0:6: [sdg] tag#26 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.122166] sd 0:0:0:6: [sdg] tag#26 CDB: opcode=0x2a 2a 00 00 34 42 91 00 00 10 00
[ 2728.130048] print_req_error: 3049 callbacks suppressed
[ 2728.130055] blk_update_request: I/O error, dev sdg, sector 27399304 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2728.146534] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.156021] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 31 b6 f0 00 00 10 00
[ 2728.163891] blk_update_request: I/O error, dev sdg, sector 26064768 op 0x1:(WRITE) flags 0x800 phys_seg 16 prio class 0
[ 2728.178917] sd 0:0:0:6: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.188308] sd 0:0:0:6: [sdg] tag#5 CDB: opcode=0x2a 2a 00 00 34 42 d1 00 00 10 00
[ 2728.196084] blk_update_request: I/O error, dev sdg, sector 27399816 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2728.207252] sd 0:0:0:6: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.207851] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.216630] sd 0:0:0:6: [sdg] tag#6 CDB: opcode=0x2a 2a 00 00 34 42 c1 00 00 10 00
[ 2728.216633] blk_update_request: I/O error, dev sdg, sector 27399688 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2728.245075] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 1a 31 70 00 00 10 00
[ 2728.252965] blk_update_request: I/O error, dev sdg, sector 13732736 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2728.264171] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.265621] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.273644] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 27 76 80 00 00 10 00
[ 2728.273651] blk_update_request: I/O error, dev sdg, sector 20689920 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2728.283134] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x2a 2a 00 00 20 ac 10 00 00 10 00
[ 2728.291018] sd 0:0:0:6: [sdg] tag#29 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.291220] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.291236] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 34 43 61 00 00 10 00
[ 2728.291244] blk_update_request: I/O error, dev sdg, sector 27400968 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2728.302154] blk_update_request: I/O error, dev sdg, sector 17129600 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2728.310015] sd 0:0:0:6: [sdg] tag#29 CDB: opcode=0x2a 2a 00 00 27 76 70 00 00 10 00
[ 2728.310020] blk_update_request: I/O error, dev sdg, sector 20689792 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2728.319540] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2728.387606] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 20 ac 00 00 00 10 00
[ 2728.395477] blk_update_request: I/O error, dev sdg, sector 17129472 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2729.790189] EXT4-fs warning: 39 callbacks suppressed
[ 2729.790205] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1718304)
[ 2729.806256] buffer_io_error: 55786 callbacks suppressed
[ 2729.806262] Buffer I/O error on device sdg1, logical block 1718070
[ 2729.818030] Buffer I/O error on device sdg1, logical block 1718071
[ 2729.824410] Buffer I/O error on device sdg1, logical block 1718072
[ 2729.830779] Buffer I/O error on device sdg1, logical block 1718073
[ 2729.837144] Buffer I/O error on device sdg1, logical block 1718074
[ 2729.843503] Buffer I/O error on device sdg1, logical block 1718075
[ 2729.849860] Buffer I/O error on device sdg1, logical block 1718076
[ 2729.856225] Buffer I/O error on device sdg1, logical block 1718077
[ 2729.862597] Buffer I/O error on device sdg1, logical block 1718078
[ 2729.868957] Buffer I/O error on device sdg1, logical block 1718079
[ 2730.114406] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 26 starting block 2175008)
[ 2730.132672] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 503840)
[ 2730.414200] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3516253)
[ 2730.529847] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 933715)
[ 2730.657784] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 28 starting block 933920)
[ 2730.769560] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 23 starting block 3516448)
[ 2730.791290] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 22 starting block 2419596)
[ 2730.840562] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1849376)
[ 2730.851574] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 24 starting block 1849365)
[ 2733.109288] scsi_io_completion_action: 3461 callbacks suppressed
[ 2733.109313] sd 0:0:0:6: [sdg] tag#20 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.125066] sd 0:0:0:6: [sdg] tag#20 CDB: opcode=0x2a 2a 00 00 05 38 e0 00 00 10 00
[ 2733.132950] print_req_error: 3461 callbacks suppressed
[ 2733.132957] blk_update_request: I/O error, dev sdg, sector 2737920 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2733.149370] sd 0:0:0:6: [sdg] tag#21 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.158851] sd 0:0:0:6: [sdg] tag#21 CDB: opcode=0x2a 2a 00 00 05 38 f0 00 00 10 00
[ 2733.166721] blk_update_request: I/O error, dev sdg, sector 2738048 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2733.190581] sd 0:0:0:6: [sdg] tag#7 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.199978] sd 0:0:0:6: [sdg] tag#7 CDB: opcode=0x2a 2a 00 00 30 25 b0 00 00 10 00
[ 2733.207771] blk_update_request: I/O error, dev sdg, sector 25243008 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2733.220188] sd 0:0:0:6: [sdg] tag#27 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.229684] sd 0:0:0:6: [sdg] tag#27 CDB: opcode=0x2a 2a 00 00 30 25 d0 00 00 10 00
[ 2733.237573] blk_update_request: I/O error, dev sdg, sector 25243264 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2733.248796] sd 0:0:0:6: [sdg] tag#28 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.258281] sd 0:0:0:6: [sdg] tag#28 CDB: opcode=0x2a 2a 00 00 30 25 c0 00 00 10 00
[ 2733.266151] blk_update_request: I/O error, dev sdg, sector 25243136 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2733.278894] sd 0:0:0:6: [sdg] tag#17 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.288388] sd 0:0:0:6: [sdg] tag#17 CDB: opcode=0x2a 2a 00 00 30 25 e0 00 00 10 00
[ 2733.296274] blk_update_request: I/O error, dev sdg, sector 25243392 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2733.307458] sd 0:0:0:6: [sdg] tag#18 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.316927] sd 0:0:0:6: [sdg] tag#18 CDB: opcode=0x2a 2a 00 00 30 25 f0 00 00 10 00
[ 2733.324796] blk_update_request: I/O error, dev sdg, sector 25243520 op 0x1:(WRITE) flags 0x4000 phys_seg 16 prio class 0
[ 2733.336607] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.345988] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 05 39 00 00 00 10 00
[ 2733.353765] blk_update_request: I/O error, dev sdg, sector 2738176 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2733.366261] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.375777] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 05 f9 40 00 00 10 00
[ 2733.383667] blk_update_request: I/O error, dev sdg, sector 3131904 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2733.396674] sd 0:0:0:6: [sdg] tag#8 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2733.406102] sd 0:0:0:6: [sdg] tag#8 CDB: opcode=0x2a 2a 00 00 07 3d 60 00 00 10 00
[ 2733.413921] blk_update_request: I/O error, dev sdg, sector 3795712 op 0x1:(WRITE) flags 0x4800 phys_seg 16 prio class 0
[ 2734.802279] EXT4-fs warning: 47 callbacks suppressed
[ 2734.802295] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2043937)
[ 2734.818330] buffer_io_error: 63679 callbacks suppressed
[ 2734.818336] Buffer I/O error on device sdg1, logical block 2043904
[ 2734.966706] EXT4-fs warning (device sdg1): ext4_end_bio:342: I/O error 10 writing to inode 25 starting block 2045984)
[ 2734.977636] Buffer I/O error on device sdg1, logical block 2043905
[ 2734.984050] Buffer I/O error on device sdg1, logical block 2043906
[ 2734.990431] Buffer I/O error on device sdg1, logical block 2043907
[ 2734.996802] Buffer I/O error on device sdg1, logical block 2043908
[ 2735.003167] Buffer I/O error on device sdg1, logical block 2043909
[ 2735.009534] Buffer I/O error on device sdg1, logical block 2043910
[ 2735.015902] Buffer I/O error on device sdg1, logical block 2043911
[ 2735.022269] Buffer I/O error on device sdg1, logical block 2043912
[ 2735.028638] Buffer I/O error on device sdg1, logical block 2043913

        Children see throughput for  8 rewriters        =   33828.82 kB/sec
        Parent sees throughput for  8 rewriters         =   30988.69 kB/sec
        Min throughput per process                      =    3862.66 kB/sec
        Max throughput per process                      =    4688.87 kB/sec
        Avg throughput per process                      =    4228.60 kB/sec
        Min xfer                                        =  868352.00 kB
[ 2739.119606] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2739.208971] scsi_io_completion_action: 1284 callbacks suppressed
[ 2739.209015] sd 0:0:0:6: [sdg] tag#31 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.224825] sd 0:0:0:6: [sdg] tag#31 CDB: opcode=0x2a 2a 08 00 00 00 20 00 00 01 00
[ 2739.232787] print_req_error: 1284 callbacks suppressed
[ 2739.232808] blk_update_request: I/O error, dev sdg, sector 256 op 0x1:(WRITE) flags 0x23800 phys_seg 1 prio class 0
[ 2739.248888] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2739.256549] EXT4-fs (sdg1): I/O error while writing superblock
[ 2739.325406] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2739.416871] sd 0:0:0:6: [sdg] tag#11 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.426371] sd 0:0:0:6: [sdg] tag#11 CDB: opcode=0x2a 2a 08 00 00 00 20 00 00 01 00
[ 2739.434259] blk_update_request: I/O error, dev sdg, sector 256 op 0x1:(WRITE) flags 0x23800 phys_seg 1 prio class 0
[ 2739.445000] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2739.452528] EXT4-fs error (device sdg1): ext4_check_bdev_write_error:215: comm iozone: Error while async write back metadata
[ 2739.452691] EXT4-fs (sdg1): I/O error while writing superblock
[ 2739.548992] sd 0:0:0:6: [sdg] tag#9 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.558425] sd 0:0:0:6: [sdg] tag#9 CDB: opcode=0x2a 2a 08 00 00 00 20 00 00 01 00
[ 2739.566239] blk_update_request: I/O error, dev sdg, sector 256 op 0x1:(WRITE) flags 0x23800 phys_seg 1 prio class 0
[ 2739.576972] Buffer I/O error on dev sdg1, logical block 0, lost sync page write
[ 2739.584552] EXT4-fs (sdg1): I/O error while writing superblock
[ 2739.609851] sd 0:0:0:6: [sdg] tag#16 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.619432] sd 0:0:0:6: [sdg] tag#16 CDB: opcode=0x35 35 00 00 00 00 00 00 00 00 00
[ 2739.627339] blk_update_request: I/O error, dev sdg, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
[ 2739.669157] sd 0:0:0:6: [sdg] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.678557] sd 0:0:0:6: [sdg] tag#0 CDB: opcode=0x2a 2a 00 00 07 00 20 00 00 01 00
[ 2739.686359] blk_update_request: I/O error, dev sdg, sector 3670272 op 0x1:(WRITE) flags 0x3000 phys_seg 1 prio class 0
[ 2739.697361] Buffer I/O error on dev sdg1, logical block 458752, lost async page write
[ 2739.705453] sd 0:0:0:6: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.714841] sd 0:0:0:6: [sdg] tag#1 CDB: opcode=0x2a 2a 00 00 06 80 20 00 00 01 00
[ 2739.722627] blk_update_request: I/O error, dev sdg, sector 3408128 op 0x1:(WRITE) flags 0x3000 phys_seg 1 prio class 0
[ 2739.733624] Buffer I/O error on dev sdg1, logical block 425984, lost async page write
[ 2739.741697] sd 0:0:0:6: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.751081] sd 0:0:0:6: [sdg] tag#2 CDB: opcode=0x2a 2a 00 00 06 00 20 00 00 01 00
[ 2739.758860] blk_update_request: I/O error, dev sdg, sector 3145984 op 0x1:(WRITE) flags 0x3000 phys_seg 1 prio class 0
[ 2739.769837] Buffer I/O error on dev sdg1, logical block 393216, lost async page write
[ 2739.777895] sd 0:0:0:6: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.787274] sd 0:0:0:6: [sdg] tag#3 CDB: opcode=0x2a 2a 00 00 05 80 20 00 00 01 00
[ 2739.795047] blk_update_request: I/O error, dev sdg, sector 2883840 op 0x1:(WRITE) flags 0x3000 phys_seg 1 prio class 0
[ 2739.806018] Buffer I/O error on dev sdg1, logical block 360448, lost async page write
[ 2739.814067] sd 0:0:0:6: [sdg] tag#4 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.814423] sd 0:0:0:6: [sdg] tag#25 UNKNOWN(0x2003) Result: hostbyte=0x07 driverbyte=0x00 cmd_age=0s
[ 2739.823444] sd 0:0:0:6: [sdg] tag#4 CDB: opcode=0x2a 2a 00 00 05 00 20 00 00 01 00
[ 2739.823447] blk_update_request: I/O error, dev sdg, sector 2621696 op 0x1:(WRITE) flags 0x3000 phys_seg 1 prio class 0
[ 2739.823450] Buffer I/O error on dev sdg1, logical block 327680, lost async page write
[ 2739.823462] blk_update_request: I/O error, dev sdg, sector 2359568 op 0x1:(WRITE) flags 0x3000 phys_seg 1 prio class 0
[ 2739.832925] sd 0:0:0:6: [sdg] tag#25 CDB: opcode=0x2a 2a 00 00 08 00 20 00 00 01 00
[ 2739.840688] Buffer I/O error on dev sdg1, logical block 294914, lost async page write
[ 2739.840703] Buffer I/O error on dev sdg1, logical block 262144, lost async page write

--=-=-=
Content-Type: text/plain


-- 
balbi

--=-=-=--
