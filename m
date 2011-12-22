From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] SCSI: Change size of factor from u64 to unsigned int.
Date: Thu, 22 Dec 2011 17:18:33 +0000
Message-ID: <20111222171833.GA16435@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Struct scsi_device.sector_size is unsigned int, so the value of factor
can have at most 23 significant bits.

Adding a type check to do_div() caught these two do_div as the only
invocations in the kernel passing a non-32-bit divisor.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-scsi@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..42a1ff6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1335,8 +1335,7 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 		start_lba <<= 1;
 		end_lba <<= 1;
 	} else {
-		/* be careful ... don't want any overflows */
-		u64 factor = scmd->device->sector_size / 512;
+		unsigned int factor = scmd->device->sector_size / 512;
 		do_div(start_lba, factor);
 		do_div(end_lba, factor);
 	}
