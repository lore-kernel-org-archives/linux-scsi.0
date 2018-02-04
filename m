From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] libata: remove WARN() for DMA or PIO command without data
Date: Sat,  3 Feb 2018 20:33:27 -0800
Message-ID: <20180204043327.16760-1-ebiggers3@gmail.com>
References: <001a11425956f5f3d0055c82f08d@google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38498 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbeBDEdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2018 23:33:45 -0500
In-Reply-To: <001a11425956f5f3d0055c82f08d@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, syzkaller-bugs@googlegroups.com, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

syzkaller hit a WARN() in ata_qc_issue() when writing to /dev/sg0.  This
happened because it issued a READ_6 command with no data buffer.

Just remove the WARN(), as it doesn't appear indicate a kernel bug.  The
expected behavior is to fail the command, which the code does.

Here's a reproducer that works in QEMU when /dev/sg0 refers to a disk of
the default type ("82371SB PIIX3 IDE"):

    #include <fcntl.h>
    #include <unistd.h>

    int main()
    {
            char buf[42] = { [36] = 0x8 /* READ_6 */ };

            write(open("/dev/sg0", O_RDWR), buf, sizeof(buf));
    }

Fixes: f92a26365a72 ("libata: change ATA_QCFLAG_DMAMAP semantics")
Reported-by: syzbot+f7b556d1766502a69d85071d2ff08bd87be53d0f@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> # v2.6.25+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ata/libata-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3c09122bf0382..61b09968d0326 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5401,8 +5401,7 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	 * We guarantee to LLDs that they will have at least one
 	 * non-zero sg if the command is a data command.
 	 */
-	if (WARN_ON_ONCE(ata_is_data(prot) &&
-			 (!qc->sg || !qc->n_elem || !qc->nbytes)))
+	if (ata_is_data(prot) && (!qc->sg || !qc->n_elem || !qc->nbytes))
 		goto sys_err;
 
 	if (ata_is_dma(prot) || (ata_is_pio(prot) &&
-- 
2.16.1
