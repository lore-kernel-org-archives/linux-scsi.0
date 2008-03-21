From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 1/8] mvsas: fill in error info record and phy mode6 bits.
Date: Fri, 21 Mar 2008 19:00:56 +0800
Message-ID: <47E39568.60407@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:11707 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754378AbYCULBA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 07:01:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

and remove some unused members from struct.

Signed-off-by: Ke Wei <kewei@marvell.com>
---
drivers/scsi/mvsas.c |  123
+++++++++++++++++++++++++++++++++++---------------
1 files changed, 87 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 5ec0665..3a447fe 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -37,11 +37,13 @@
#include <linux/dma-mapping.h>
#include <linux/ctype.h>
#include <scsi/libsas.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/sas_ata.h>
#include <asm/io.h>

#define DRV_NAME    "mvsas"
-#define DRV_VERSION    "0.5.1"
-#define _MV_DUMP 0
+#define DRV_VERSION    "0.5.2"
+#define _MV_DUMP    0
#define MVS_DISABLE_NVRAM
#define MVS_DISABLE_MSI

@@ -52,7 +54,7 @@
     readl(regs + MVS_##reg);        \
     } while (0)

-#define MVS_ID_NOT_MAPPED    0xff
+#define MVS_ID_NOT_MAPPED    0x7f
#define MVS_CHIP_SLOT_SZ    (1U << mvi->chip->slot_width)

/* offset for D2H FIS in the Received FIS List Structure */
@@ -84,6 +86,7 @@ enum driver_configuration {
     MVS_RX_FIS_COUNT    = 17,    /* Optional rx'd FISs (max 17) */

     MVS_QUEUE_SIZE        = 30,    /* Support Queue depth */
+    MVS_CAN_QUEUE        = MVS_SLOTS - 1,    /* SCSI Queue depth */
};

/* unchangeable hardware details */
@@ -358,7 +361,20 @@ enum hw_register_bits {

     /* VSR */
     /* PHYMODE 6 (CDB) */
-    PHY_MODE6_DTL_SPEED    = (1U << 27),
+    PHY_MODE6_LATECLK    = (1U << 29),    /* Lock Clock */
+    PHY_MODE6_DTL_SPEED    = (1U << 27),    /* Digital Loop Speed */
+    PHY_MODE6_FC_ORDER    = (1U << 26),    /* Fibre Channel Mode Order*/
+    PHY_MODE6_MUCNT_EN    = (1U << 24),    /* u Count Enable */
+    PHY_MODE6_SEL_MUCNT_LEN    = (1U << 22),    /* Training Length
Select */
+    PHY_MODE6_SELMUPI    = (1U << 20),    /* Phase Multi Select (init) */
+    PHY_MODE6_SELMUPF    = (1U << 18),    /* Phase Multi Select (final) */
+    PHY_MODE6_SELMUFF    = (1U << 16),    /* Freq Loop Multi Sel(final) */
+    PHY_MODE6_SELMUFI    = (1U << 14),    /* Freq Loop Multi Sel(init) */
+    PHY_MODE6_FREEZE_LOOP    = (1U << 12),    /* Freeze Rx CDR Loop */
+    PHY_MODE6_INT_RXFOFFS    = (1U << 3),    /* Rx CDR Freq Loop Enable */
+    PHY_MODE6_FRC_RXFOFFS    = (1U << 2),    /* Initial Rx CDR Offset */
+    PHY_MODE6_STAU_0D8    = (1U << 1),    /* Rx CDR Freq Loop Saturate */
+    PHY_MODE6_RXSAT_DIS    = (1U << 0),    /* Saturate Ctl */
};

enum mvs_info_flags {
@@ -511,7 +527,43 @@ enum status_buffer {
};

enum error_info_rec {
-    CMD_ISS_STPD    =  (1U << 31),    /* Cmd Issue Stopped */
+    CMD_ISS_STPD    = (1U << 31),    /* Cmd Issue Stopped */
+    CMD_PI_ERR    = (1U << 30),    /* Protection info error.  see flags2 */
+    RSP_OVER    = (1U << 29),    /* rsp buffer overflow */
+    RETRY_LIM    = (1U << 28),    /* FIS/frame retry limit exceeded */
+    UNK_FIS     = (1U << 27),    /* unknown FIS */
+    DMA_TERM    = (1U << 26),    /* DMA terminate primitive rx'd */
+    SYNC_ERR    = (1U << 25),    /* SYNC rx'd during frame xmit */
+    TFILE_ERR    = (1U << 24),    /* SATA taskfile Error bit set */
+    R_ERR        = (1U << 23),    /* SATA returned R_ERR prim */
+    RD_OFS        = (1U << 20),    /* Read DATA frame invalid offset */
+    XFER_RDY_OFS    = (1U << 19),    /* XFER_RDY offset error */
+    UNEXP_XFER_RDY    = (1U << 18),    /* unexpected XFER_RDY error */
+    DATA_OVER_UNDER = (1U << 16),    /* data overflow/underflow */
+    INTERLOCK    = (1U << 15),    /* interlock error */
+    NAK        = (1U << 14),    /* NAK rx'd */
+    ACK_NAK_TO    = (1U << 13),    /* ACK/NAK timeout */
+    CXN_CLOSED    = (1U << 12),    /* cxn closed w/out ack/nak */
+    OPEN_TO     = (1U << 11),    /* I_T nexus lost, open cxn timeout */
+    PATH_BLOCKED    = (1U << 10),    /* I_T nexus lost, pathway blocked */
+    NO_DEST     = (1U << 9),    /* I_T nexus lost, no destination */
+    STP_RES_BSY    = (1U << 8),    /* STP resources busy */
+    BREAK        = (1U << 7),    /* break received */
+    BAD_DEST    = (1U << 6),    /* bad destination */
+    BAD_PROTO    = (1U << 5),    /* protocol not supported */
+    BAD_RATE    = (1U << 4),    /* cxn rate not supported */
+    WRONG_DEST    = (1U << 3),    /* wrong destination error */
+    CREDIT_TO    = (1U << 2),    /* credit timeout */
+    WDOG_TO     = (1U << 1),    /* watchdog timeout */
+    BUF_PAR     = (1U << 0),    /* buffer parity error */
+};
+
+enum error_info_rec_2 {
+    SLOT_BSY_ERR    = (1U << 31),    /* Slot Busy Error */
+    GRD_CHK_ERR    = (1U << 14),    /* Guard Check Error */
+    APP_CHK_ERR    = (1U << 13),    /* Application Check error */
+    REF_CHK_ERR    = (1U << 12),    /* Reference Check Error */
+    USR_BLK_NM    = (1U << 0),    /* User Block Number */
};

struct mvs_chip_info {
@@ -543,28 +595,12 @@ struct mvs_cmd_hdr {
     __le32            reserved[4];
};

-struct mvs_slot_info {
-    struct sas_task        *task;
-    u32            n_elem;
-    u32            tx;
-
-    /* DMA buffer for storing cmd tbl, open addr frame, status buffer,
-     * and PRD table
-     */
-    void            *buf;
-    dma_addr_t        buf_dma;
-#if _MV_DUMP
-    u32            cmd_size;
-#endif
-
-    void            *response;
-};
-
struct mvs_port {
     struct asd_sas_port    sas_port;
     u8            port_attached;
     u8            taskfileset;
     u8            wide_port_phymap;
+    struct list_head    list;
};

struct mvs_phy {
@@ -582,6 +618,27 @@ struct mvs_phy {
     u32        frame_rcvd_size;
     u8        frame_rcvd[32];
     u8        phy_attached;
+    enum sas_linkrate    minimum_linkrate;
+    enum sas_linkrate    maximum_linkrate;
+};
+
+struct mvs_slot_info {
+    struct list_head    list;
+    struct sas_task        *task;
+    u32            n_elem;
+    u32            tx;
+
+    /* DMA buffer for storing cmd tbl, open addr frame, status buffer,
+     * and PRD table
+     */
+    void            *buf;
+    dma_addr_t        buf_dma;
+#if _MV_DUMP
+    u32            cmd_size;
+#endif
+
+    void            *response;
+    struct mvs_port        *port;
};

struct mvs_info {
@@ -612,21 +669,14 @@ struct mvs_info {

     const struct mvs_chip_info *chip;

-    unsigned long        tags[MVS_SLOTS];
+    u8            tags[MVS_SLOTS];
     struct mvs_slot_info    slot_info[MVS_SLOTS];
                 /* further per-slot information */
     struct mvs_phy        phy[MVS_MAX_PHYS];
     struct mvs_port        port[MVS_MAX_PHYS];
-
-    u32            can_queue;    /* per adapter */
-    u32            tag_out;    /*Get*/
-    u32            tag_in;        /*Give*/
-};
-
-struct mvs_queue_task {
-    struct list_head list;
-
-    void   *uldd_task;
+#ifdef MVS_USE_TASKLET
+    struct tasklet_struct    tasklet;
+#endif
};

static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
@@ -641,10 +691,11 @@ static u32 mvs_read_port_irq_mask(struct mvs_info
*mvi, u32 port);
static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i);
static void mvs_detect_porttype(struct mvs_info *mvi, int i);
static void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
+static void mvs_release_task(struct mvs_info *mvi, int phy_no);

static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
static void mvs_scan_start(struct Scsi_Host *);
-static int mvs_sas_slave_alloc(struct scsi_device *scsi_dev);
+static int mvs_slave_configure(struct scsi_device *sdev);

static struct scsi_transport_template *mvs_stt;

@@ -659,7 +710,7 @@ static struct scsi_host_template mvs_sht = {
     .name            = DRV_NAME,
     .queuecommand        = sas_queuecommand,
     .target_alloc        = sas_target_alloc,
-    .slave_configure    = sas_slave_configure,
+    .slave_configure    = mvs_slave_configure,
     .slave_destroy        = sas_slave_destroy,
     .scan_finished        = mvs_scan_finished,
     .scan_start        = mvs_scan_start,
@@ -674,7 +725,7 @@ static struct scsi_host_template mvs_sht = {
     .use_clustering        = ENABLE_CLUSTERING,
     .eh_device_reset_handler    = sas_eh_device_reset_handler,
     .eh_bus_reset_handler    = sas_eh_bus_reset_handler,
-    .slave_alloc        = mvs_sas_slave_alloc,
+    .slave_alloc        = sas_slave_alloc,
     .target_destroy        = sas_target_destroy,
     .ioctl            = sas_ioctl,
};
-- 
1.5.4





