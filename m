From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fcoe: fix off-by-one array size comparison
Date: Thu,  6 Oct 2016 19:26:20 +0100
Message-ID: <20161006182620.32208-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Fix an off-by-one array size comparison that is comparing one too many
items in an array and hence will causing an out-of-bounds array read
on array fcoe_port_speed_mapping.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/fcoe/fcoe_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index c164eec..375c536 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -110,7 +110,7 @@ static inline u32 eth2fc_speed(u32 eth_port_speed)
 {
 	int i;
 
-	for (i = 0; i <= ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
 		if (fcoe_port_speed_mapping[i].eth_port_speed == eth_port_speed)
 			return fcoe_port_speed_mapping[i].fc_port_speed;
 	}
-- 
2.9.3
