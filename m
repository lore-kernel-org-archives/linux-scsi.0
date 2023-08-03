Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726DBC001DF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Aug 2023 10:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbjHCKQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Aug 2023 06:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbjHCKQ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2023 06:16:26 -0400
X-Greylist: delayed 2680 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Aug 2023 03:15:30 PDT
Received: from smtp.mail.palai.org (mx.palai.org [136.243.195.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA97B211F
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2023 03:15:30 -0700 (PDT)
Received: by smtp.mail.palai.org with esmtpsa (TLS1.3:TLS_AES_128_GCM_SHA256:128)
        (Exim 4.94.2)
        (envelope-from <dan+33553920+linux-scsi+vger.kernel.org@latius.de>)
        id 1qRUfQ-0004mi-6S; Thu, 03 Aug 2023 09:30:48 +0000
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
From:   Daniel Hofmann <dan+33553920+linux-scsi+vger.kernel.org@latius.de>
Subject: Optimal I/O size of 33553920 bytes should not appear.
Message-ID: <15dec4ee-9b2c-66b3-35fe-333add83bdc4@latius.de>
Date:   Thu, 3 Aug 2023 11:30:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:115.0) Gecko/20100101
 Thunderbird/115.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin,

the "optimal" I/O size of 33553920 = 0xFFFF*512 bytes still appears
despite of commit 631669a256f9 (see
https://lore.kernel.org/linux-scsi/yq1ilehejy6.fsf@ca-mkp.ca.oracle.com/).

The reason is that there are devices in the wild which both report
sdkp->min_xfer_blocks == 1 and sdkp->opt_xfer_blocks == 0xFFFF. Hence,
opt_xfer_bytes % min_xfer_bytes == 0, and thus the check in
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/drivers/scsi/sd.c?h=6.5/scsi-fixes&id=06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5#n3341
fails.

It seems that sdkp->opt_xfer_blocks == 0xFFFF serves the same purpose as
q->limits.io_opt = 0 in
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/drivers/scsi/sd.c?h=6.5/scsi-fixes&id=06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5#n3453,
namely: to be a dummy value, indicating that no specific information is
available. Therefore, I suggest to explicitly test whether
sdkp->opt_xfer_blocks equals this dummy value 0xFFFF and to explicitly
fail the validation of the optimal transfer size if this is the case,
resulting in q->limits.io_opt = 0 instead of the bogus q->limits.io_opt
= 33553920. For example, consider this patch:


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 68b12afa0721..319400ec333d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3314,6 +3314,9 @@ static bool sd_validate_opt_xfer_size(struct
scsi_disk *sdkp,
 	if (sdkp->opt_xfer_blocks == 0)
 		return false;

+	if (sdkp->opt_xfer_blocks == 0xffff)
+		return false;
+
 	if (sdkp->opt_xfer_blocks > dev_max) {
 		sd_first_printk(KERN_WARNING, sdkp,
 				"Optimal transfer size %u logical blocks " \


(Additionally, it would be also possible to test whether the size of the
device is divisible (without remainder) by the assumed "optimal I/O
size". If it is not divisible by the assumed "optimal I/O size", it is
quite likely that the "optimal I/O size" is not useful, at least for
alignment of data onto that block device. In this case, the validation
should also fail.)


My real-world example:


# dmesg -H
[...]
[  +0.004324] scsi host2: uas
[  +0.002777] scsi 2:0:0:0: Direct-Access     Inateck  FE202x Series
1.00 PQ: 0 ANSI: 6
[  +0.019153] sd 2:0:0:0: Attached scsi generic sg2 type 0
[  +0.002565] sd 2:0:0:0: [sdb] 4000797360 512-byte logical blocks:
(2.05 TB/1.86 TiB)
[  +0.001319] sd 2:0:0:0: [sdb] Write Protect is off
[  +0.000005] sd 2:0:0:0: [sdb] Mode Sense: 37 00 00 08
[  +0.002499] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  +0.001295] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[  +0.000004] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[  +0.010352] sd 2:0:0:0: [sdb] Attached SCSI disk
[...]
# lsblk -t /dev/sdb
NAME                                                          ALIGNMENT
MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED       RQ-SIZE    RA WSAME
sdb                                                                   0
  512 33553920     512     512    0 mq-deadline      58 65532    0B



Fixing this would benefit downstream consumers of this value (libparted
and thus parted, gparted, partitioning tools used during installation of
a Linux system) by preventing them from creating actually unaligned
partitions by taking the bogus "optimal I/O size" as the alignment size.


Cheers,
Dan
