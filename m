From: Ganesh Goudar <ganeshgr@chelsio.com>
Subject: [PATCH net-next 1/2] cxgb4: change the port capability bits definition
Date: Wed, 23 May 2018 20:02:58 +0530
Message-ID: <1527085978-9859-1-git-send-email-ganeshgr@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: nirranjan@chelsio.com, indranil@chelsio.com, venkatesh@chelsio.com, linux-scsi@vger.kernel.org, varun@chelsio.com, Ganesh Goudar <ganeshgr@chelsio.com>, Casey Leedom <leedom@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

MDI Port Capabilities bit definitions were inconsistent with
regard to the MDI enum values. 2 bits used to define MDI in
the port capabilities are not really separable, it's a 2-bit
field with 4 different values. Change the port capability bit
definitions to be "AUTO" and "STRAIGHT" in order to get them
to line up with the enum's.

Signed-off-by: Casey Leedom <leedom@chelsio.com>
Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c     | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h  | 8 ++++----
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c | 2 +-
 drivers/scsi/csiostor/csio_hw.c                | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index df5e7c7..537ed07 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3941,8 +3941,8 @@ static fw_port_cap32_t fwcaps16_to_caps32(fw_port_cap16_t caps16)
 	CAP16_TO_CAP32(FC_RX);
 	CAP16_TO_CAP32(FC_TX);
 	CAP16_TO_CAP32(ANEG);
-	CAP16_TO_CAP32(MDIX);
 	CAP16_TO_CAP32(MDIAUTO);
+	CAP16_TO_CAP32(MDISTRAIGHT);
 	CAP16_TO_CAP32(FEC_RS);
 	CAP16_TO_CAP32(FEC_BASER_RS);
 	CAP16_TO_CAP32(802_3_PAUSE);
@@ -3982,8 +3982,8 @@ static fw_port_cap16_t fwcaps32_to_caps16(fw_port_cap32_t caps32)
 	CAP32_TO_CAP16(802_3_PAUSE);
 	CAP32_TO_CAP16(802_3_ASM_DIR);
 	CAP32_TO_CAP16(ANEG);
-	CAP32_TO_CAP16(MDIX);
 	CAP32_TO_CAP16(MDIAUTO);
+	CAP32_TO_CAP16(MDISTRAIGHT);
 	CAP32_TO_CAP16(FEC_RS);
 	CAP32_TO_CAP16(FEC_BASER_RS);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index e6b2e95..2d91480 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -2471,8 +2471,8 @@ enum fw_port_cap {
 	FW_PORT_CAP_FC_RX		= 0x0040,
 	FW_PORT_CAP_FC_TX		= 0x0080,
 	FW_PORT_CAP_ANEG		= 0x0100,
-	FW_PORT_CAP_MDIX		= 0x0200,
-	FW_PORT_CAP_MDIAUTO		= 0x0400,
+	FW_PORT_CAP_MDIAUTO		= 0x0200,
+	FW_PORT_CAP_MDISTRAIGHT		= 0x0400,
 	FW_PORT_CAP_FEC_RS		= 0x0800,
 	FW_PORT_CAP_FEC_BASER_RS	= 0x1000,
 	FW_PORT_CAP_FEC_RESERVED	= 0x2000,
@@ -2515,8 +2515,8 @@ enum fw_port_mdi {
 #define	FW_PORT_CAP32_802_3_PAUSE	0x00040000UL
 #define	FW_PORT_CAP32_802_3_ASM_DIR	0x00080000UL
 #define	FW_PORT_CAP32_ANEG		0x00100000UL
-#define	FW_PORT_CAP32_MDIX		0x00200000UL
-#define	FW_PORT_CAP32_MDIAUTO		0x00400000UL
+#define	FW_PORT_CAP32_MDIAUTO		0x00200000UL
+#define	FW_PORT_CAP32_MDISTRAIGHT	0x00400000UL
 #define	FW_PORT_CAP32_FEC_RS		0x00800000UL
 #define	FW_PORT_CAP32_FEC_BASER_RS	0x01000000UL
 #define	FW_PORT_CAP32_FEC_RESERVED1	0x02000000UL
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
index 798695b..3017f78 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
@@ -341,8 +341,8 @@ static fw_port_cap32_t fwcaps16_to_caps32(fw_port_cap16_t caps16)
 	CAP16_TO_CAP32(FC_RX);
 	CAP16_TO_CAP32(FC_TX);
 	CAP16_TO_CAP32(ANEG);
-	CAP16_TO_CAP32(MDIX);
 	CAP16_TO_CAP32(MDIAUTO);
+	CAP16_TO_CAP32(MDISTRAIGHT);
 	CAP16_TO_CAP32(FEC_RS);
 	CAP16_TO_CAP32(FEC_BASER_RS);
 	CAP16_TO_CAP32(802_3_PAUSE);
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 96bbb82..a10cf25 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -1500,8 +1500,8 @@ fw_port_cap32_t fwcaps16_to_caps32(fw_port_cap16_t caps16)
 	CAP16_TO_CAP32(FC_RX);
 	CAP16_TO_CAP32(FC_TX);
 	CAP16_TO_CAP32(ANEG);
-	CAP16_TO_CAP32(MDIX);
 	CAP16_TO_CAP32(MDIAUTO);
+	CAP16_TO_CAP32(MDISTRAIGHT);
 	CAP16_TO_CAP32(FEC_RS);
 	CAP16_TO_CAP32(FEC_BASER_RS);
 	CAP16_TO_CAP32(802_3_PAUSE);
-- 
2.1.0
