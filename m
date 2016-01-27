From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/7] scsi: aha1542: avoid uninitialized variable warnings
Date: Wed, 27 Jan 2016 16:57:22 +0100
Message-ID: <1453910247-3447628-7-git-send-email-arnd@arndb.de>
References: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@HansenPartnership.com
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Gcc incorrectly detects that two variables in aha1542_queuecommand might
be used without an initialization:

scsi/aha1542.c: In function 'aha1542_queuecommand':
scsi/aha1542.c:382:16: error: 'cptr' may be used uninitialized in this function [-Werror=maybe-uninitialized]
scsi/aha1542.c:379:11: error: 'sg_count' may be used uninitialized in this function [-Werror=maybe-uninitialized]

The only user of these is doing the same check that the assigment
has, so it is actually guaranteed to work. Adding an "else" clause
with a fake initialization shuts up the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aha1542.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 5b8b2937a3fe..7db448ec8beb 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -403,6 +403,9 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		cptr = kmalloc(sizeof(*cptr) * sg_count, GFP_KERNEL | GFP_DMA);
 		if (!cptr)
 			return SCSI_MLQUEUE_HOST_BUSY;
+	} else {
+		sg_count = 0;
+		cptr = NULL;
 	}
 
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
-- 
2.7.0
