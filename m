From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
Date: Thu, 16 Aug 2012 16:38:45 +0200
Message-ID: <1345127925-32042-1-git-send-email-lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, tytso@mit.edu, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Currently it is possible to unmap one more block than user requested to
due to the off-by-one error in unmap_region(). This is probably due to
the fact that the end variable despite its name actually points to the
last block to unmap + 1. However in the condition it is handled as the
last block of the region to unmap.

The bug was not previously spotted probably due to the fact that the
region was not zeroed, which has changed with commit
be1dd78de5686c062bb3103f9e86d444a10ed783. With that commit we were able
to corrupt the ext4 file system on 256M scsi_debug device with LBPRZ
enabled using fstrim.

Since the 'end' semantic is the same in several functions there this
commit just fixes the condition to use the 'end' variable correctly in
that context.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 182d5a5..f4cc413 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2054,7 +2054,7 @@ static void unmap_region(sector_t lba, unsigned int len)
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end && block < map_size) {
+		if (rem == 0 && lba + granularity < end && block < map_size) {
 			clear_bit(block, map_storep);
 			if (scsi_debug_lbprz)
 				memset(fake_storep +
-- 
1.7.7.6
