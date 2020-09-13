Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00505C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 07:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B60A217BA
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 07:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="O/V13iVt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgIMHFV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 03:05:21 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50918 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgIMHFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 13 Sep 2020 03:05:19 -0400
Received: from zn.tnic (p200300ec2f290b00e66ccb465e44ee87.dip0.t-ipconnect.de [IPv6:2003:ec:2f29:b00:e66c:cb46:5e44:ee87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DA5051EC0501;
        Sun, 13 Sep 2020 09:05:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1599980717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e914e8whMVmGW7aK1X34dlD6tHZkjqgsV/4kJ55/P7o=;
        b=O/V13iVt2p0xPpHzk/GRBfdatRwzoT9Wa0wS2vgdZJJ1xtFMiRz54TiqNaZFJdkXREMKQ/
        zjJMhsav4whZwyZflsfCQJk42nqv/Fz+VUxbpJx/qyRWFqpCJrH2/vhfOrV5Brl252e8pg
        6VqExBImCtD0ZPqCeJMXcr6l1kKHjBM=
Date:   Sun, 13 Sep 2020 09:05:06 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 0/2] Fix handling of host-aware ZBC disks
Message-ID: <20200913070506.GA5213@zn.tnic>
References: <20200913060304.294898-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200913060304.294898-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mornin',

On Sun, Sep 13, 2020 at 03:03:02PM +0900, Damien Le Moal wrote:
> I tested all this. I could recreate the hang you are seeing with
> CONFIG_BLK_DEV_ZONED disabled. The cause for this hang was that
> good_bytes always ended up being 0 for all IOs to the host-aware disk.
> The fix for this is in the first patch.
> If you could test this (on top of 5.9-rc), it would be great. Thanks !

Sure, below is the diff of both boot dmesgs, with CONFIG_BLK_DEV_ZONED
and without it. So for both:

Tested-by: Borislav Petkov <bp@suse.de>

Thanks Damien and sorry for ruining your weekend.

---
--- 09-rc4+.CONFIG_BLK_DEV_ZONED	2020-09-13 08:36:13.423999302 +0200
+++ 09-rc4+.CONFIG_BLK_DEV_ZONED.off	2020-09-13 08:43:45.371999496 +0200
@@ -825,28 +825,26 @@ input: DATACOMP SteelS쀁̄Љ̒DATA Cons
 hid-generic 0003:04B4:0101.0002: input,hidraw1: USB HID v1.00 Device [DATACOMP SteelS쀁̄Љ̒DATA] on usb-0000:03:00.0-12/input1
 usb 1-13: new low-speed USB device number 3 using xhci_hcd
 usb 1-13: New USB device found, idVendor=046d, idProduct=c018, bcdDevice=43.01
-ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
 usb 1-13: New USB device strings: Mfr=1, Product=2, SerialNumber=0
-ata4.00: NCQ Send/Recv Log not supported
 usb 1-13: Product: USB Optical Mouse
 usb 1-13: Manufacturer: Logitech
+ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
+ata4.00: NCQ Send/Recv Log not supported
 ata4.00: ATA-10: ST8000AS0022-1WL17Z, SN01, max UDMA/133
-ata4.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 32), AA
 input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-13/1-13:1.0/0003:046D:C018.0003/input/input5
+ata4.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 32), AA
 ata4.00: NCQ Send/Recv Log not supported
 hid-generic 0003:046D:C018.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:03:00.0-13/input0
 ata4.00: configured for UDMA/133
 scsi 3:0:0:0: Direct-Access     ATA      ST8000AS0022-1WL SN01 PQ: 0 ANSI: 5
 sd 3:0:0:0: Attached scsi generic sg1 type 0
-sd 3:0:0:0: [sdb] Host-aware zoned block device
+sd 3:0:0:0: [sdb] Host-aware SMR disk used as regular disk
 sd 3:0:0:0: [sdb] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
 sd 3:0:0:0: [sdb] 4096-byte physical blocks
 sd 3:0:0:0: [sdb] Write Protect is off
 sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
 sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
-sd 3:0:0:0: [sdb] 29808 zones of 524288 logical blocks + 1 runt zone
  sdb: sdb1
-sdb: disabling host aware zoned block device support due to partitions
 sd 3:0:0:0: [sdb] Attached SCSI disk
 ata5: failed to resume link (SControl 0)
 ata5: SATA link down (SStatus 0 SControl 0)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
