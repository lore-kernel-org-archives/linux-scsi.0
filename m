From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH, resend] scsi: advansys: fix big-endian builds
Date: Mon, 16 Nov 2015 17:49:23 +0100
Message-ID: <4411376.blKgWIg75B@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Matthew Wilcox <willy@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Building the advansys driver in a big-endian configuration such as
ARM allmodconfig shows a warning:

 drivers/scsi/advansys.c: In function 'adv_build_req':
 include/uapi/linux/byteorder/big_endian.h:32:26: warning: large integer implicitly truncated to unsigned type [-Woverflow]
  #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
 drivers/scsi/advansys.c:7806:22: note: in expansion of macro 'cpu_to_le32'
   scsiqp->sense_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);

It turns out that the commit that introduced this used the cpu_to_le32()
incorrectly on an 8-bit field, which results in the sense_len to always
be set to zero, as the SCSI_SENSE_BUFFERSIZE value gets moved to upper
byte of the 32-bit intermediate.

This removes the cpu_to_le32() call to restore the original version.

I found this only by looking at the compiler output and have not done
a full review for possible further endianess bugs in the same driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 811ddc057aac ("advansys: use DMA-API for mapping sense buffer")
Cc: stable@vger.kernel.org # v4.2+
---
Using willy@linux.intel.com, as the address listed in MAINTAINERS
failed:

Failed to transport message. Message sending failed since the following recipients were rejected by the server: matthew@wil.cx (The server responded: Requested action not taken: mailbox unavailable invalid DNS MX or A/AAAA resource record)

Geert found the same bug and submitted the same patch earlier:
https://lkml.org/lkml/2015/6/24/89

Neither one has been reviewed or accepted so far. Can we get one of the
two merged please?

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4305178e4e01..1c1cd657c380 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7803,7 +7803,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		return ASC_BUSY;
 	}
 	scsiqp->sense_addr = cpu_to_le32(sense_addr);
-	scsiqp->sense_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
+	scsiqp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
 	/* Build ADV_SCSI_REQ_Q */
 
