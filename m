Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16A1C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jun 2022 23:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiFXXRj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jun 2022 19:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiFXXRg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jun 2022 19:17:36 -0400
X-Greylist: delayed 416 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Jun 2022 16:17:34 PDT
Received: from pio-pvt-msa1.bahnhof.se (pio-pvt-msa1.bahnhof.se [79.136.2.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0555A88B37
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2022 16:17:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTP id 45EBB3F2DD
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2022 01:10:36 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from pio-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id U-k-cKZP9SuL for <linux-scsi@vger.kernel.org>;
        Sat, 25 Jun 2022 01:10:35 +0200 (CEST)
Received: by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id 5755F3F2A6
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2022 01:10:35 +0200 (CEST)
Received: from [192.168.0.134] (port=53446)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1o4sRe-0006QP-Sz
        for linux-scsi@vger.kernel.org; Sat, 25 Jun 2022 01:10:34 +0200
Message-ID: <3e2b3e3b-447a-a84c-65cd-e2965a3d8a12@tnonline.net>
Date:   Sat, 25 Jun 2022 01:10:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
From:   Forza <forza@tnonline.net>
To:     linux-scsi@vger.kernel.org
Subject: mpt3sas and /sys/block/<dev>/device/timeout
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I am currently facing an issue with a Broadcom HBA 9500-8i SAS 
controller where 'blkdiscard /dev/sdX' on WD SA500 SATA SSDs cause an IO 
timeout and device reset.

* LSI/Broadcom HBA 9500-8i SAS/SATA controller
* WD RED SA500 NAS SATA SSD 2TB (WDS200T1R0A-68A4W0)
   Drive FW: 411000WR
* Alpine Linux kernel 5.15.48
* /sys/block/sdf/queue/
   discard_granularity:512
   discard_max_bytes:134217216
   discard_max_hw_bytes:134217216

I simply issue a 'blkdiscard /dev/sdf' and after about 30 seconds the 
following errors show in dmesg (quite a lot of rows). The full 
blkdiscard takes between 1.5 and 2.5 minutes depending on the SSD I run 
on (I have 4 drives). The problem is the same if I run fstrim on a 
mounted XFS or Btrfs (but not ext4) filesystem on these drives.

[  +0.000003] scsi target6:0:4: handle(0x0029), 
sas_address(0x5003048020db4543), phy(3)
[  +0.000003] scsi target6:0:4: enclosure logical 
id(0x5003048020db457f), slot(3)
[  +0.000003] scsi target6:0:4: enclosure level(0x0000), connector name( 
C0.1)
[  +0.000003] sd 6:0:4:0: No reference found at driver, assuming 
scmd(0x00000000eb0d9438) might have completed
[  +0.000003] sd 6:0:4:0: task abort: SUCCESS scmd(0x00000000eb0d9438)
[  +0.000012] sd 6:0:4:0: attempting task 
abort!scmd(0x0000000075f63919), outstanding for 30397 ms & timeout 30000 ms
[  +0.000003] sd 6:0:4:0: [sdg] tag#2762 CDB: opcode=0x42 42 00 00 00 00 
00 00 00 18 00
[  +0.000002] scsi target6:0:4: handle(0x0029), 
sas_address(0x5003048020db4543), phy(3)
[  +0.000004] scsi target6:0:4: enclosure logical 
id(0x5003048020db457f), slot(3)
[  +0.000002] scsi target6:0:4: enclosure level(0x0000), connector name( 
C0.1)
[  +0.000003] sd 6:0:4:0: No reference found at driver, assuming 
scmd(0x0000000075f63919) might have completed
[  +0.000003] sd 6:0:4:0: task abort: SUCCESS scmd(0x0000000075f63919)
[  +0.255021] sd 6:0:4:0: Power-on or device reset occurred


Does the mpt3sas driver or the HBA controller not follow the 
/sys/block/<dev>/device/timeout value? I have mine set to 180 seconds.

It seems that there are many hardcoded timeout values in the driver code.

https://github.com/torvalds/linux/blob/master/drivers/scsi/mpt3sas/mpt3sas_scsih.c
https://github.com/torvalds/linux/blob/6a0a17e6c6d1091ada18d43afd87fb26a82a9823/drivers/scsi/mpt3sas/mpt3sas_scsih.c#L3303-L3306

Any thoughts other than trying to avoid using discards/fstrim? I did 
reach out to Broadcom for support, and they claim it is a fault in the 
fstrim code and that on FreeBSD they had fixed this. Not sure how 
relevant that statement is though.

Thanks,
Forza

