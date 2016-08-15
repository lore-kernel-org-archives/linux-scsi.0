From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] fcoe: provide translation table between Ethernet and FC port speeds
Date: Mon, 15 Aug 2016 17:24:09 +0200
Message-ID: <1471274649-27113-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Provide a translation table between Ethernet and FC port speeds so odd
speeds (from a Ethernet POV) like 8 Gbit are correctly mapped to sysfs
and open-fcoe's fcoeadm.

Before:
    Description:      BCM57840 NetXtreme II 10/20-Gigabit Ethernet
    Revision:         11
    Manufacturer:     Broadcom Corporation
    Serial Number:    6CC2173EA1D0

    Driver:           bnx2x 1.712.30-0
    Number of Ports:  1

        Symbolic Name:     bnx2fc (QLogic BCM57840) v2.10.3 over eth2
        OS Device Name:    host1
        Node Name:         0x20006cc2173ea1d1
        Port Name:         0x10006cc2173ea1d1
        FabricName:        0x100000c0dd0ce717
        Speed:             unknown
        Supported Speed:   1 Gbit, 10 Gbit
        MaxFrameSize:      2048 bytes
        FC-ID (Port ID):   0x660702
        State:             Online

After:
    Description:      BCM57840 NetXtreme II 10/20-Gigabit Ethernet
    Revision:         11
    Manufacturer:     Broadcom Corporation
    Serial Number:    6CC2173EA1D0

    Driver:           bnx2x 1.712.30-0
    Number of Ports:  1

        Symbolic Name:     bnx2fc (QLogic BCM57840) v2.10.3 over eth2
        OS Device Name:    host1
        Node Name:         0x20006cc2173ea1d1
        Port Name:         0x10006cc2173ea1d1
        FabricName:        0x100000c0dd0ce717
        Speed:             8 Gbit
        Supported Speed:   1 Gbit, 10 Gbit
        MaxFrameSize:      2048 bytes
        FC-ID (Port ID):   0x660701
        State:             Online

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/fcoe/fcoe_transport.c | 48 ++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 7028dd3..3e7f0e7 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -83,6 +83,36 @@ static struct notifier_block libfcoe_notifier = {
 	.notifier_call = libfcoe_device_notification,
 };
 
+static const struct {
+	u32 fc_port_speed;
+	u32 eth_port_speed;
+} fcoe_port_speed_mapping[] = {
+	{ FC_PORTSPEED_1GBIT, SPEED_1000 },
+	{ FC_PORTSPEED_2GBIT, 2000 },
+	{ FC_PORTSPEED_4GBIT, 4000 },
+	{ FC_PORTSPEED_8GBIT, 8000 },
+	{ FC_PORTSPEED_10GBIT, SPEED_10000 },
+	{ FC_PORTSPEED_16GBIT, 16000 },
+	{ FC_PORTSPEED_20GBIT, SPEED_20000  },
+	{ FC_PORTSPEED_25GBIT, SPEED_25000  },
+	{ FC_PORTSPEED_32GBIT, 32000 },
+	{ FC_PORTSPEED_40GBIT, SPEED_40000  },
+	{ FC_PORTSPEED_50GBIT, SPEED_50000  },
+	{ FC_PORTSPEED_100GBIT, SPEED_100000 },
+};
+
+static inline u32 eth2fc_speed(u32 eth_port_speed)
+{
+	int i;
+
+	for (i = 0; i <= ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
+		if (fcoe_port_speed_mapping[i].eth_port_speed == eth_port_speed)
+			return fcoe_port_speed_mapping[i].fc_port_speed;
+	}
+
+	return FC_PORTSPEED_UNKNOWN;
+}
+
 /**
  * fcoe_link_speed_update() - Update the supported and actual link speeds
  * @lport: The local port to update speeds for
@@ -126,23 +156,7 @@ int fcoe_link_speed_update(struct fc_lport *lport)
 			    SUPPORTED_40000baseLR4_Full))
 			lport->link_supported_speeds |= FC_PORTSPEED_40GBIT;
 
-		switch (ecmd.base.speed) {
-		case SPEED_1000:
-			lport->link_speed = FC_PORTSPEED_1GBIT;
-			break;
-		case SPEED_10000:
-			lport->link_speed = FC_PORTSPEED_10GBIT;
-			break;
-		case SPEED_20000:
-			lport->link_speed = FC_PORTSPEED_20GBIT;
-			break;
-		case SPEED_40000:
-			lport->link_speed = FC_PORTSPEED_40GBIT;
-			break;
-		default:
-			lport->link_speed = FC_PORTSPEED_UNKNOWN;
-			break;
-		}
+		lport->link_speed = eth2fc_speed(ecmd.base.speed);
 		return 0;
 	}
 	return -1;
-- 
1.8.5.6
