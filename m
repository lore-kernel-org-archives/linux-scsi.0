From: Colin King <colin.king@canonical.com>
Subject: [PATCH] [SCSI] aic7xxx: fix order of arguments in function prototype
Date: Sat,  8 Apr 2017 18:28:42 +0100
Message-ID: <20170408172842.20226-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The vendor/device and subvendor/subdevice arguments to the function
prototype ahc_9005_subdevinfo_valid are in the wrong order and
need to be swapped to fix this.  Detected with PVS-Studio studio.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aic7xxx/aic7xxx_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 22d5a949ec83..673e826d7adb 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -601,8 +601,8 @@ static const u_int ahc_num_pci_devs = ARRAY_SIZE(ahc_pci_ident_table);
 #define STA	0x08
 #define DPR	0x01
 
-static int ahc_9005_subdevinfo_valid(uint16_t vendor, uint16_t device,
-				     uint16_t subvendor, uint16_t subdevice);
+static int ahc_9005_subdevinfo_valid(uint16_t device, uint16_t vendor,
+				     uint16_t subdevice, uint16_t subvendor);
 static int ahc_ext_scbram_present(struct ahc_softc *ahc);
 static void ahc_scbram_config(struct ahc_softc *ahc, int enable,
 				  int pcheck, int fast, int large);
-- 
2.11.0
