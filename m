From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part3 7/7] sg_io: cleanup and complete whitelist for disks
Date: Thu, 23 May 2013 15:59:35 +0200
Message-ID: <1369317575-4236-8-git-send-email-pbonzini@redhat.com>
References: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49809 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106Ab3EWN76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 May 2013 09:59:58 -0400
In-Reply-To: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

This splits entries for SBC commands that conflict with MMC, and adds
missing commands to the table from SBC and related standards.
Only commands that affect the medium are added:

- I added ATA PASS-THROUGH(16) because ATA PASS-THROUGH(12) is present;
using the (16) version is preferrable because (12) conflicts with the
destructive MMC command BLANK; see the sg_sat_identify man page for
example.

- WRITE SAME(16) and WRITE SAME(10) are used by discard and zero-out
feature.  For discard, the UNMAP command is already in the whitelist.
For zero-out, omitting them produces "WRITE SAME failed.  Manually
zeroing" errors in the log.

- COMPARE AND WRITE is used by cluster software.

- WRITE AND VERIFY(16) is needed to support >2TB disks, and the
corresponding 12-byte CDB is whitelisted already.  I didn't get reports
about _these_ command but I do get bug reports about >2TB disks.
SYNCHRONIZE CACHE(16) is similarly the 16-byte extension of another
10-byte command.

- similarly, in the case of VERIFY(12) and READ DEFECT DATA(12) the
same command was already whitelisted for another command length.

Commands that affect other state of the LUN are all privileged, with the
sole exception of START STOP UNIT, which has always been allowed for all
file descriptors.  I do not really agree with that and it's probably
an artifact of when /dev/cdrom had r--r--r-- permissions, but I'm not
trying to change that.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 0bf0820..216cd17 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -170,6 +170,8 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x88, D|      W|  O|      B        , read);  /* READ(16) */
 	sgio_bitmap_set(0x8F, D|      W|  O|      B        , read);  /* VERIFY(16) */
 	sgio_bitmap_set(0xA8, D|      W|R|O                , read);  /* READ(12) */
+	sgio_bitmap_set(0xAF, D|      W|  O                , read);  /* VERIFY(12) */
+	sgio_bitmap_set(0xB7, D|          O                , read);  /* READ DEFECT DATA(12) */
 
 	/* block devices, write */
 
@@ -179,10 +181,18 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0x2E, D|      W|R|O|      B|K      , write); /* WRITE AND VERIFY(10) */
 	sgio_bitmap_set(0x35, D|      W|R|O|      B|K      , write); /* SYNCHRONIZE CACHE(10) */
 	sgio_bitmap_set(0x3F, D|      W|  O                , write); /* WRITE LONG(10) */
+	sgio_bitmap_set(0x41, D                            , write); /* WRITE SAME(10) */
 	sgio_bitmap_set(0x42, D                            , write); /* UNMAP */
 	sgio_bitmap_set(0x48, D|                  B        , write); /* SANITIZE */
 	sgio_bitmap_set(0x51, D                            , write); /* XPWRITE(10) */
+	sgio_bitmap_set(0x53, D                            , write); /* XDWRITEREAD(10) */
+	sgio_bitmap_set(0x85, D|                  B        , write); /* ATA PASS-THROUGH(16) */
+	sgio_bitmap_set(0x89, D                            , write); /* COMPARE AND WRITE */
 	sgio_bitmap_set(0x8A, D|      W|  O|      B        , write); /* WRITE(16) */
+	sgio_bitmap_set(0x8E, D|      W|  O|      B        , write); /* WRITE AND VERIFY(16) */
+	sgio_bitmap_set(0x91, D|      W|  O|      B        , write); /* SYNCHRONIZE CACHE(16) */
+	sgio_bitmap_set(0x93, D                            , write); /* WRITE SAME(16) */
+	sgio_bitmap_set(0xA1, D|                  B        , write); /* ATA PASS-THROUGH(12) */
 	sgio_bitmap_set(0xAA, D|      W|R|O                , write); /* WRITE(12) */
 	sgio_bitmap_set(0xAC,             O                , write); /* ERASE(12) */
 	sgio_bitmap_set(0xAE, D|      W|  O                , write); /* WRITE AND VERIFY(12) */
@@ -239,12 +249,12 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(0xBD,           R                  , read);  /* MECHANISM STATUS */
 	sgio_bitmap_set(0xBE,           R                  , read);  /* READ CD */
 
-	sgio_bitmap_set(0x53, D|        R                  , write); /* RESERVE TRACK / XDWRITEREAD(10) */
+	sgio_bitmap_set(0x53,           R                  , write); /* RESERVE TRACK */
 	sgio_bitmap_set(0x54,           R                  , write); /* SEND OPC INFORMATION */
 	sgio_bitmap_set(0x58,           R                  , write); /* REPAIR TRACK */
 	sgio_bitmap_set(0x5B,           R                  , write); /* CLOSE TRACK/SESSION */
 	sgio_bitmap_set(0x5D,           R                  , write); /* SEND CUE SHEET */
-	sgio_bitmap_set(0xA1, D|        R|        B        , write); /* BLANK / ATA PASS-THROUGH(12) */
+	sgio_bitmap_set(0xA1,           R                  , write); /* BLANK */
 	sgio_bitmap_set(0xA2,           R                  , write); /* SEND EVENT */
 	sgio_bitmap_set(0xA3,           R                  , write); /* SEND KEY */
 	sgio_bitmap_set(0xA6,           R                  , write); /* LOAD/UNLOAD C/DVD */
-- 
1.8.1.4

