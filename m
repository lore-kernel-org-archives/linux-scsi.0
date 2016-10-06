From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 10/12] scsi/ncr5380: Expedite register polling
Date: Thu,  6 Oct 2016 19:41:07 -0400 (EDT)
Message-ID: <8f6ca7428ba0c8a35aad7080a1a913b1aaa66725.1475791899.git.fthain@telegraphics.com.au>
References: <cover.1475791899.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1475791899.git.fthain@telegraphics.com.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Avoid the call to NCR5380_poll_politely2() when possible. The call is
easily short-circuited on the PIO fast path, using the inline wrapper.
This requires that the NCR5380_read macro be made available before
any #include "NCR5380.h" so a few declarations have to be moved too.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/NCR5380.h      | 3 +++
 drivers/scsi/arm/cumana_1.c | 4 ++++
 drivers/scsi/atari_scsi.c   | 6 +++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 4682baa..b2c560c 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -310,6 +310,9 @@ static inline int NCR5380_poll_politely(struct NCR5380_hostdata *hostdata,
                                         unsigned int reg, u8 bit, u8 val,
                                         unsigned long wait)
 {
+	if ((NCR5380_read(reg) & bit) == val)
+		return 0;
+
 	return NCR5380_poll_politely2(hostdata, reg, bit, val,
 						reg, bit, val, wait);
 }
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index ae1d4c6..fb7600d 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -29,6 +29,10 @@
 #define NCR5380_implementation_fields	\
 	unsigned ctrl
 
+struct NCR5380_hostdata;
+static u8 cumanascsi_read(struct NCR5380_hostdata *, unsigned int);
+static void cumanascsi_write(struct NCR5380_hostdata *, unsigned int, u8);
+
 #include "../NCR5380.h"
 
 #define CTRL	0x16fc
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index aed69ac..f77c311 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -57,6 +57,9 @@
 
 #define NCR5380_implementation_fields   /* none */
 
+static u8 (*atari_scsi_reg_read)(unsigned int);
+static void (*atari_scsi_reg_write)(unsigned int, u8);
+
 #define NCR5380_read(reg)               atari_scsi_reg_read(reg)
 #define NCR5380_write(reg, value)       atari_scsi_reg_write(reg, value)
 
@@ -126,9 +129,6 @@ static inline unsigned long SCSI_DMA_GETADR(void)
 
 static void atari_scsi_fetch_restbytes(void);
 
-static u8 (*atari_scsi_reg_read)(unsigned int);
-static void (*atari_scsi_reg_write)(unsigned int, u8);
-
 static unsigned long	atari_dma_residual, atari_dma_startaddr;
 static short		atari_dma_active;
 /* pointer to the dribble buffer */
-- 
2.7.3
