Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C231410E
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:20 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz2-0005nP-NZ; Sun, 03 Dec 2023 17:06:16 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz2-00DKAO-58; Sun, 03 Dec 2023 17:06:16 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-00DPpK-SA; Sun, 03 Dec 2023 17:06:15 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 13/14] scsi: sun3x_esp: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:58 +0100
Message-ID:  <5010d1a4f3d77eaa1114fa254c343c4f23313901.1701619134.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
References: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1883; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=b8kdc5NUtC8q0GXD2i5QPt7FoloXN5G7rEJdkurrL5I=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdnsppi63Ssn9wP43fZFWIrXiD6qeZrCnMye Bs8MyJHZWSJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynZwAKCRCPgPtYfRL+ TraZCACAFmJv5gpY1Rkz7QjGeo/e44+YlAYGYsp0xYBvuHNm3IHAr6M1C6Hm2qNicdx5IvphSyq CMA5mIRjAY+DGcAInseByGmggTe0FRv94MkjkowzOMnoqCTK8fPyG+oTBZF0EHamIVldz1iq4JN 6f9JYolAl7KiGQC4HG5JYKTQgKCLkUGhDelBCFKdb3xosc1F/GjOVq1HdFKzmOwawuvsEgZgG/H /BB/8MFToxdsdQYHJj/U6ynQ+3rwdVGScYskLwpeAppOIRCSq/9zdiUs7VqnpkbKZEZ6jMdEw/k a4HhEGZR4oTPXfb3rdubzgC3i32qS4E4F/PpH+s7hPh+Q5P1
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

In the error path emit an error message replacing the (less useful)
message by the core. Apart from the improved error message there is no
change in behaviour.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/scsi/sun3x_esp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 30f67cbf4a7a..09219c362acc 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -243,7 +243,7 @@ static int esp_sun3x_probe(struct platform_device *dev)
 	return err;
 }
 
-static int esp_sun3x_remove(struct platform_device *dev)
+static void esp_sun3x_remove(struct platform_device *dev)
 {
 	struct esp *esp = dev_get_drvdata(&dev->dev);
 	unsigned int irq = esp->host->irq;
@@ -261,13 +261,11 @@ static int esp_sun3x_remove(struct platform_device *dev)
 			  esp->command_block_dma);
 
 	scsi_host_put(esp->host);
-
-	return 0;
 }
 
 static struct platform_driver esp_sun3x_driver = {
 	.probe          = esp_sun3x_probe,
-	.remove         = esp_sun3x_remove,
+	.remove_new     = esp_sun3x_remove,
 	.driver = {
 		.name   = "sun3x_esp",
 	},
-- 
2.42.0

