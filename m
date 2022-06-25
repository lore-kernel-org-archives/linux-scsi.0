Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9968C43334
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jun 2022 10:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiFYKrv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jun 2022 06:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiFYKru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jun 2022 06:47:50 -0400
X-Greylist: delayed 321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 03:47:48 PDT
Received: from ste-pvt-msa2.bahnhof.se (ste-pvt-msa2.bahnhof.se [213.80.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F372FE58
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2022 03:47:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 2E1C03FD57
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2022 12:42:26 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from ste-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (ste-ftg-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ze5ZFP0d8NXo for <linux-scsi@vger.kernel.org>;
        Sat, 25 Jun 2022 12:42:24 +0200 (CEST)
Received: by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id B54BB3F4DA
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2022 12:42:24 +0200 (CEST)
Received: from [192.168.0.134] (port=35244)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1o53FA-0004ka-6W
        for linux-scsi@vger.kernel.org; Sat, 25 Jun 2022 12:42:24 +0200
Message-ID: <5dc8adc2-d974-7ee2-ad9e-f968f215cfd8@tnonline.net>
Date:   Sat, 25 Jun 2022 12:42:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: mpt3sas and /sys/block/<dev>/device/timeout
Content-Language: en-US
From:   Forza <forza@tnonline.net>
To:     linux-scsi@vger.kernel.org
References: <3e2b3e3b-447a-a84c-65cd-e2965a3d8a12@tnonline.net>
In-Reply-To: <3e2b3e3b-447a-a84c-65cd-e2965a3d8a12@tnonline.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/25/22 01:10, Forza wrote:
> Hi,
> 
> I am currently facing an issue with a Broadcom HBA 9500-8i SAS 
> controller where 'blkdiscard /dev/sdX' on WD SA500 SATA SSDs cause an IO 
> timeout and device reset.
> 
> * LSI/Broadcom HBA 9500-8i SAS/SATA controller
> * WD RED SA500 NAS SATA SSD 2TB (WDS200T1R0A-68A4W0)
>    Drive FW: 411000WR
> * Alpine Linux kernel 5.15.48
> * /sys/block/sdf/queue/
>    discard_granularity:512
>    discard_max_bytes:134217216
>    discard_max_hw_bytes:134217216
> 
> I simply issue a 'blkdiscard /dev/sdf' and after about 30 seconds the 
> following errors show in dmesg (quite a lot of rows). The full 
> blkdiscard takes between 1.5 and 2.5 minutes depending on the SSD I run 
> on (I have 4 drives). The problem is the same if I run fstrim on a 
> mounted XFS or Btrfs (but not ext4) filesystem on these drives.
> 
> [  +0.000003] scsi target6:0:4: handle(0x0029), 
> sas_address(0x5003048020db4543), phy(3)
> [  +0.000003] scsi target6:0:4: enclosure logical 
> id(0x5003048020db457f), slot(3)
> [  +0.000003] scsi target6:0:4: enclosure level(0x0000), connector name( 
> C0.1)
> [  +0.000003] sd 6:0:4:0: No reference found at driver, assuming 
> scmd(0x00000000eb0d9438) might have completed
> [  +0.000003] sd 6:0:4:0: task abort: SUCCESS scmd(0x00000000eb0d9438)
> [  +0.000012] sd 6:0:4:0: attempting task 
> abort!scmd(0x0000000075f63919), outstanding for 30397 ms & timeout 30000 ms
> [  +0.000003] sd 6:0:4:0: [sdg] tag#2762 CDB: opcode=0x42 42 00 00 00 00 
> 00 00 00 18 00
> [  +0.000002] scsi target6:0:4: handle(0x0029), 
> sas_address(0x5003048020db4543), phy(3)
> [  +0.000004] scsi target6:0:4: enclosure logical 
> id(0x5003048020db457f), slot(3)
> [  +0.000002] scsi target6:0:4: enclosure level(0x0000), connector name( 
> C0.1)
> [  +0.000003] sd 6:0:4:0: No reference found at driver, assuming 
> scmd(0x0000000075f63919) might have completed
> [  +0.000003] sd 6:0:4:0: task abort: SUCCESS scmd(0x0000000075f63919)
> [  +0.255021] sd 6:0:4:0: Power-on or device reset occurred
> 
> 
> Does the mpt3sas driver or the HBA controller not follow the 
> /sys/block/<dev>/device/timeout value? I have mine set to 180 seconds.
> 
> It seems that there are many hardcoded timeout values in the driver code.
> 
> https://github.com/torvalds/linux/blob/master/drivers/scsi/mpt3sas/mpt3sas_scsih.c 
> 
> https://github.com/torvalds/linux/blob/6a0a17e6c6d1091ada18d43afd87fb26a82a9823/drivers/scsi/mpt3sas/mpt3sas_scsih.c#L3303-L3306 
> 
> 
> Any thoughts other than trying to avoid using discards/fstrim? I did 
> reach out to Broadcom for support, and they claim it is a fault in the 
> fstrim code and that on FreeBSD they had fixed this. Not sure how 
> relevant that statement is though.
> 
> Thanks,
> Forza
> 

I used blktrace to capture some events that might help debug where the 
issues are. I don't know how to interpret the results though.


1) running blkdiscard /dev/sdf1
https://paste.tnonline.net/files/MYymVOfP4ROQ_blktrace.tar.xz

2) running mkfs.btrfs /dev/sdf1
https://paste.tnonline.net/files/5UUvxYlQD46Q_blktrace_mkfs.tar.xz

3) running fstrim on mounted btrfs
https://paste.tnonline.net/files/gultxaa7OP8P_blktrace_fstrim.tar.xz
https://paste.tnonline.net/files/8Vy7D0uR2Mk5_dmesg_fstrim.txt

Example output:
Input file sdf.blktrace.0 added
   8,80   1        1     0.000000000  5527  A   D 2048 + 8388607 <- (8,81) 0
   8,80   1        2     0.000002456  5527  Q   D 2048 + 8388607 
[blkdiscard]
   8,80   1        3     0.000004876  5527  X   D 2048 / 264191 [blkdiscard]
   8,80   1        4     0.000009894  5527  G   D 2048 + 262143 [blkdiscard]
   8,80   1        5     0.000010754  5527  P   N [blkdiscard]
   8,80   1        6     0.000012881  5527  X   D 264191 / 526334 
[blkdiscard]
   8,80   1        7     0.000013925  5527  G   D 264191 + 262143 
[blkdiscard]
   8,80   1        8     0.000014896  5527  U   N [blkdiscard] 1
   8,80   1        9     0.000015890  5527  I   D 2048 + 262143 [blkdiscard]
   8,80   1       10     0.000027270  5527  D   D 2048 + 262143 [blkdiscard]
   8,80   1       11     0.000039543  5527  P   N [blkdiscard]
   8,80   1       12     0.000040775  5527  X   D 526334 / 788477 
[blkdiscard]
   8,80   1       13     0.000041572  5527  G   D 526334 + 262143 
[blkdiscard]
   8,80   1       14     0.000041842  5527  U   N [blkdiscard] 1
   8,80   1       15     0.000042175  5527  I   D 264191 + 262143 
[blkdiscard]
   8,80   1       16     0.000044967  5527  D   D 264191 + 262143 
[blkdiscard]
   8,80   1       17     0.000047802  5527  P   N [blkdiscard]
   8,80   1       18     0.000048798  5527  X   D 788477 / 1050620 
[blkdiscard]
   8,80   1       19     0.000049493  5527  G   D 788477 + 262143 
[blkdiscard]
   8,80   1       20     0.000049715  5527  U   N [blkdiscard] 1
   8,80   1       21     0.000050022  5527  I   D 526334 + 262143 
[blkdiscard]
   8,80   1       22     0.000052386  5527  D   D 526334 + 262143 
[blkdiscard]
   8,80   1       23     0.000055063  5527  P   N [blkdiscard]
...
snip ~100k lines
...
   8,80   4    10940    97.593173642   548  D  DS 3904898591 + 262143 
[kworker/4:1H]
   8,80   4    10941    97.603196002     0  C  DS 3900704303 + 3932145 [0]
   8,80   4    10942    97.603246256   548  D  DS 3905160734 + 262143 
[kworker/4:1H]
   8,80   4    10943    97.613166491     0  C  DS 3900704303 + 4194288 [0]
   8,80   4    10944    97.613216413   548  D  DS 3905422877 + 262143 
[kworker/4:1H]
   8,80   4    10945    97.623198445     0  C  DS 3900704303 + 4456431 [0]
   8,80   4    10946    97.623249722   548  D  DS 3905685020 + 262143 
[kworker/4:1H]
   8,80   4    10947    97.633162688     0  C  DS 3900704303 + 4718574 [0]
   8,80   4    10948    97.633212563   548  D  DS 3905947163 + 262143 
[kworker/4:1H]
   8,80   4    10949    97.643154345     0  C  DS 3900704303 + 4980717 [0]
   8,80   4    10950    97.643204045   548  D  DS 3906209306 + 262143 
[kworker/4:1H]
   8,80   4    10951    97.653270127     0  C  DS 3900704303 + 5242860 [0]
   8,80   4    10952    97.653319479   548  D  DS 3906471449 + 262143 
[kworker/4:1H]
   8,80   4    10953    97.663202719     0  C  DS 3900704303 + 5505003 [0]
   8,80   4    10954    97.663253381   548  D  DS 3906733592 + 262143 
[kworker/4:1H]
   8,80   4    10955    97.673273616     0  C  DS 3900704303 + 5767146 [0]
   8,80   4    10956    97.673321526   548  D  DS 3906995735 + 33257 
[kworker/4:1H]
   8,80   4    10957    97.683204146     0  C  DS 3900704303 + 6029289 [0]
   8,80   4    10958    97.693695724     0  C  DS 3900704303 + 6291432 [0]
   8,80   4    10959    97.703304939     0  C   D 3892315696 + 6553575 [0]
   8,80   4    10960    97.713278422     0  C   D 3867149875 + 6553575 [0]
   8,80   4    10961    97.723309633     0  C   D 3867149875 + 6815718 [0]
   8,80   4    10962    97.733228328     0  C   D 3867149875 + 7077861 [0]
   8,80   4    10963    97.743206422     0  C   D 3867149875 + 7340004 [0]
   8,80   4    10964    97.753131380     0  C   D 3867149875 + 7602147 [0]
   8,80   4    10965    97.763353833     0  C   D 3867149875 + 7864290 [0]
   8,80   4    10966    97.773132921     0  C   D 3867149875 + 8126433 [0]
   8,80   4    10967    97.783267092     0  C   D 3867149875 + 8388576 [0]
   8,80   4    10968    97.784616230     0  C   D 3867149875 + 8388607 [0]
   8,80   4    10969    97.793083064     0  C   D 3875538482 + 262143 [0]
   8,80   4    10970    97.803187466     0  C   D 3875538482 + 524286 [0]
   8,80   4    10971    97.813136517     0  C   D 3875538482 + 786429 [0]
   8,80   4    10972    97.823092905     0  C   D 3875538482 + 1048572 [0]
   8,80   4    10973    97.833401461     0  C   D 3875538482 + 1310715 [0]
   8,80   4    10974    97.843100535     0  C   D 3875538482 + 1572858 [0]
   8,80   4    10975    97.853242242     0  C   D 3875538482 + 1835001 [0]
   8,80   4    10976    97.863173598     0  C   D 3875538482 + 2097144 [0]
   8,80   4    10977    97.873196944     0  C   D 3875538482 + 2359287 [0]
   8,80   4    10978    97.883177261     0  C   D 3875538482 + 2621430 [0]
   8,80   4    10979    97.893191605     0  C   D 3875538482 + 2883573 [0]
   8,80   4    10980    97.903370941     0  C   D 3875538482 + 3145716 [0]
   8,80   4    10981    97.913331748     0  C   D 3875538482 + 3407859 [0]
   8,80   4    10982    97.923181282     0  C   D 3875538482 + 3670002 [0]
   8,80   4    10983    97.933252172     0  C   D 3875538482 + 3932145 [0]
   8,80   4    10984    97.943217689     0  C   D 3875538482 + 4194288 [0]
   8,80   4    10985    97.953153062     0  C   D 3875538482 + 4456431 [0]
   8,80   4    10986    97.963283883     0  C   D 3875538482 + 4718574 [0]
   8,80   4    10987    97.973210464     0  C   D 3892315696 + 6291432 [0]
   8,80   4    10988    97.983769074     0  C  DS 3900704303 + 6324689 [0]

CPU0 (sdf):
  Reads Queued:    , iB   Writes Queued:    , iB
  Read Dispatches: , iB   Write Dispatches: , iB
  Reads Requeued:                 Writes Requeued:
  Reads Completed: , iB   Writes Completed: , iB
  Read Merges:     , iB   Write Merges:     , iB
  Read depth:             2               Write depth:            32
  PC Reads Queued: , iB   PC Writes Queued: , iB
  PC Read Disp.:   , iB   PC Write Disp.:   , iB
  PC Reads Req.:                  PC Writes Req.:
  PC Reads Compl.:                PC Writes Compl.:
  IO unplugs:          2360               Timer unplugs:         348
CPU1 (sdf):
  Reads Queued:    , iB   Writes Queued:    , iB
  Read Dispatches: , iB   Write Dispatches: , iB
  Reads Requeued:                 Writes Requeued:
  Reads Completed: , iB   Writes Completed: , iB
  Read Merges:     , iB   Write Merges:     , iB
  Read depth:             2               Write depth:            32
  IO unplugs:          5500               Timer unplugs:         778
CPU2 (sdf):
  Reads Queued:    , iB   Writes Queued:    , iB
  Read Dispatches: , iB   Write Dispatches: , iB
  Reads Requeued:                 Writes Requeued:
  Reads Completed: , iB   Writes Completed: , iB
  Read Merges:     , iB   Write Merges:     , iB
  Read depth:             2               Write depth:            32
  IO unplugs:          2419               Timer unplugs:         354
CPU3 (sdf):
  Reads Queued:    , iB   Writes Queued:    , iB
  Read Dispatches: , iB   Write Dispatches: , iB
  Reads Requeued:                 Writes Requeued:
  Reads Completed: , iB   Writes Completed: , iB
  Read Merges:     , iB   Write Merges:     , iB
  Read depth:             2               Write depth:            32
  IO unplugs:           977               Timer unplugs:         144
CPU4 (sdf):
  Reads Queued:    , iB   Writes Queued:    , iB
  Read Dispatches: , iB   Write Dispatches: , iB
  Reads Requeued:                 Writes Requeued:
  Reads Completed: , iB   Writes Completed: , iB
  Read Merges:     , iB   Write Merges:     , iB
  Read depth:             2               Write depth:            32
  IO unplugs:          1334               Timer unplugs:         197
CPU5 (sdf):
  Reads Queued:    , iB   Writes Queued:    , iB
  Read Dispatches: , iB   Write Dispatches: , iB
  Reads Requeued:                 Writes Requeued:
  Reads Completed: , iB   Writes Completed: , iB
  Read Merges:     , iB   Write Merges:     , iB
  Read depth:             2               Write depth:            32
  PC Reads Queued: , iB   PC Writes Queued: , iB
  PC Read Disp.:   , iB   PC Write Disp.:   , iB
  PC Reads Req.:                  PC Writes Req.:
  PC Reads Compl.:                PC Writes Compl.:
  IO unplugs:           518               Timer unplugs:          71

Total (sdf):
  Reads Queued:    , iB   Writes Queued:    , iB
  Read Dispatches: , iB   Write Dispatches: , iB
  Reads Requeued:                 Writes Requeued:
  Reads Completed: , iB   Writes Completed: , iB
  Read Merges:     , iB   Write Merges:     , iB
  PC Reads Queued: , iB   PC Writes Queued: , iB
  PC Read Disp.:   , iB   PC Write Disp.:   , iB
  PC Reads Req.:                  PC Writes Req.:
  PC Reads Compl.:                PC Writes Compl.:
  IO unplugs:         13108               Timer unplugs:        1892
Events (sdf): Skips: 0 forward (0 -   0.0%)
Trace started at Sat Jun 25 12:05:11 2022


Thanks,
Forza
