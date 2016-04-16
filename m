From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] aha1542: probe correct address for isapnp
Date: Sat, 16 Apr 2016 22:32:41 +0200
Message-ID: <1460838770-1250252-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>, James Bottomley <JBottomley@Odin.com>, Ondrej Zary <linux@rainbow-software.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

gcc warns about an out of bounds access after a recent cleanup:

drivers/scsi/aha1542.c: In function 'aha1542_pnp_probe':
drivers/scsi/aha1542.c:703:27: error: array subscript is above array bounds [-Werror=array-bounds]
  unsigned int base_io = io[indx];
                         ~~^~~~~~
drivers/scsi/aha1542.c:728:2: error: array subscript is above array bounds [-Werror=array-bounds]
  aha1542_set_bus_times(sh, bus_on[indx], bus_off[indx], dma_speed[indx]);

Indeed the aha1542_pnp_probe() function that was added cannot possibly
have worked, as it first tries to find an available index to use for
the probed device, but then passes one after the last index to the
aha1542_hw_init() function.

This is an attempt to rework the probe function into what it should
have been. It is however not tested any more than the original patch
other than making sure we get no warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 643a7c43f11e ("aha1542: Stop using scsi_module.c")
---
 drivers/scsi/aha1542.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 7db448ec8beb..132c311ef605 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -996,25 +996,31 @@ static int aha1542_pnp_probe(struct pnp_dev *pdev, const struct pnp_device_id *i
 {
 	int indx;
 	struct Scsi_Host *sh;
+	int ret;
 
-	for (indx = 0; indx < ARRAY_SIZE(io); indx++) {
-		if (io[indx])
-			continue;
+	for (indx = 0; indx < ARRAY_SIZE(io); indx++)
+		if (!io[indx])
+			break;
 
-		if (pnp_activate_dev(pdev) < 0)
-			continue;
+	if (indx == ARRAY_SIZE(io))
+		return -ENXIO;
 
-		io[indx] = pnp_port_start(pdev, 0);
+	ret = pnp_activate_dev(pdev);
+	if (ret < 0)
+		return ret;
 
-		/* The card can be queried for its DMA, we have
-		   the DMA set up that is enough */
+	io[indx] = pnp_port_start(pdev, 0);
 
-		dev_info(&pdev->dev, "ISAPnP found an AHA1535 at I/O 0x%03X", io[indx]);
-	}
+	/* The card can be queried for its DMA, we have
+	   the DMA set up that is enough */
+
+	dev_info(&pdev->dev, "ISAPnP found an AHA1535 at I/O 0x%03X", io[indx]);
 
 	sh = aha1542_hw_init(&driver_template, &pdev->dev, indx);
-	if (!sh)
+	if (!sh) {
+		pnp_disable_dev(pdev);
 		return -ENODEV;
+	}
 
 	pnp_set_drvdata(pdev, sh);
 	return 0;
-- 
2.7.0
