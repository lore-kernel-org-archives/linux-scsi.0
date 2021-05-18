Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC19C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 23:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B176160FF0
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 23:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhERXld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 19:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhERXld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 19:41:33 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DC7C061573
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 16:40:14 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id a7so1589981qvf.11
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 16:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=dj5fE5/YVOUNv/N5t2bldTjoFdNcW/U7gfZjdQ2p9ws=;
        b=h3Ej6sD476q1mQqrUAcjBrwHIqx0oxi7h3sc9VjmFL9VjQmhBAvJWY970e+OiA7k2r
         Jjm8OzrgD9T9Rvhw+mBqd4+2pTh8nJ91ipjDNEoQFpqhXwkwk7/z5x8yXSlBpZ0jNRmR
         xozlSrI4ZJwD7vRfTu1fCK+XwETu9PUM77IMDBlMUirqu6lLkSvUXgkzMHmrALpGh/Te
         j2AhVlv44kyHjdb94ln0K9v2+vC0ciSxO9lBlsK4ZDBgK+F/d/g2ed0ZQbvDn0ejdXGv
         Hx3lPKXPJuzPzi37x/YIBoWcvhK/ycwgq34A6duBDpTLO7EJnEnTyBnhniAR3BsrmdGv
         S98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=dj5fE5/YVOUNv/N5t2bldTjoFdNcW/U7gfZjdQ2p9ws=;
        b=f9wdXrp9x+X6jwSptvN8jI7pepuE9S5uzU0KlkSggiLsX/UPmgQXYC4RVHNVMLtdll
         o5VHAotEWkvLhF/2C1iw895i+h/AL4ffjM9mQPJrd7/K+r6ieQjdn58t9YjM/wcVn6EA
         UY9LEY/ERLDKXo3bNk8Vy87mPnuX3kNyhQ5hAnUIVRZDoSXp/gP98VxNRhyF4jBrKzMD
         lsh05odkvbjBPl8kJE8XsCXr56tiBOA6fsXf/ReS2n/9LPiOCn0QkRs0Ag2kzsfDh6Ox
         F3yIqTKeS2yaSyKmcuMi6DYViIvYpK2Dpox6uF34igGop9FyZ4sMYWLjprzYPlKkh+JH
         aS0w==
X-Gm-Message-State: AOAM531VeeMStgCcDbV6zC+sXGMRxXGiHaQIW03tpEhBWqcYU4vuGpDB
        zHVBrxMgFg5zjn4T8RyqxhU=
X-Google-Smtp-Source: ABdhPJwoHZ/tCpS/v/I6Nr7QCgbhPXNX8nWSx5qryL/VHw1zmRKuwE1b8XxVqywVe0xiuHZIlyIkBQ==
X-Received: by 2002:a0c:9b83:: with SMTP id o3mr9108712qve.4.1621381214027;
        Tue, 18 May 2021 16:40:14 -0700 (PDT)
Received: from david-pc (c-73-82-11-57.hsd1.ga.comcast.net. [73.82.11.57])
        by smtp.gmail.com with ESMTPSA id p9sm15762469qtl.78.2021.05.18.16.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 16:40:13 -0700 (PDT)
Date:   Tue, 18 May 2021 19:40:09 -0400
From:   David Sebek <dasebek@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     dasebek@gmail.com
Subject: [PATCH] scsi: Fix incorrect writesame_16 provisioning mode for some
 devices
Message-ID: <YKRQWXABfmy/wk4j@david-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch addresses an issue when 'writesame_16' provisioning mode
could be incorrectly set for some storage devices that support
logical block provisioning (LBPME=1) but with some other operation
than 'writesame_16' specified in a VPD.

Prior to this patch, the read_capacity_16() function used to set
block provisioning mode to 'writesame_16' for all devices that have
the LBPME bit enabled, without checking the logical provisioning VPD
page for the correct command to be used. Setting the provisioning
mode in the read_capacity_16() function seems unnecessary for
multiple reasons:
1. the correct mode is then detected and set by the
   sd_read_block_provisioning() and sd_read_block_limits() functions
2. it can result in an incorrect provisioning mode to be enabled for
   some devices that use some other block provisioning mode than
   'writesame_16'.

Prior to applying this patch, my 5TB WD Black P10 USB external hard
drive was detected to support TRIM (verified by lsblk -D). However,
any TRIM attempt (fstrim, blkdiscard) resulted in I/O errors in
dmesg, and the TRIM operation did not seem to unmap any blocks.
The problem was that the kernel used 'writesame_16' even though
the hard drive supported 'unmap' command instead.

$ cat /sys/block/sdb/device/scsi_disk/6\:0\:0\:0/provisioning_mode
writesame_16

$ sudo sg_vpd -a /dev/sdb
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBPWS): 0
  Write same (10) with unmap bit supported (LBPWS10): 0

The drive uses Bulk-Only USB interface instead of UASP. Because
of it, read_capacity_10() is used first. But because the capacity
of the drive is 5TB, read_capacity_16() is tried next. This
function set the provisioning mode to 'writesame_16' since the
drive reports LBPME=1. But because the drive is connected via USB,
the VPD page is ignored (skip_vpd_pages is set to true in
scsiglue.c), the correct provisioning mode (unmap) is never
set, and an incorrect provisioning mode (writesame_16) was kept
instead.

This was not an issue on my internal SSD which supports 'writesame_16'
discard command. In that case, read_capacity_16() set the discard mode
to 'writesame_16' (which happened to be the correct one in this case),
and shortly after that, sd_read_block_provisioning() and
sd_read_block_limits() set the discard mode to 'writesame_16' again.

After applying this patch, my USB hard drive is treated as if it
didn't support the discard operation (because VPD is not checked
in the case of a USB device that does not support UASP).
This is better than issuing invalid commands to the device.

$ cat /sys/block/sdb/device/scsi_disk/*/provisioning_mode
full

Signed-off-by: David Sebek <dasebek@gmail.com>
---
 drivers/scsi/sd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb3c37d1e009..2ad4abc1cbc2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2416,8 +2416,6 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
-
-		sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
-- 
2.31.1

