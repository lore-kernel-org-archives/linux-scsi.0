From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: advansys: fix big-endian builds
Date: Tue, 06 Oct 2015 23:24:28 +0200
Message-ID: <5468884.cIlSBUgeTB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>, Hannes Reinecke <hare@suse.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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
---
Using willy@linux.intel.com, as the address listed in MAINTAINERS
failed:

Failed to transport message. Message sending failed since the following recipients were rejected by the server: matthew@wil.cx (The server responded: Requested action not taken: mailbox unavailable invalid DNS MX or A/AAAA resource record)

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
