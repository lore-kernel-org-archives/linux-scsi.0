Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39E8FC
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-0005hN-Nt; Sun, 03 Dec 2023 17:06:14 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DK9n-BF; Sun, 03 Dec 2023 17:06:14 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DPoo-2I; Sun, 03 Dec 2023 17:06:14 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 05/14] scsi: jazz_esp: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:50 +0100
Message-ID:  <f71efbe17973c97fd2a1e78f8d7fcf456644510b.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1944; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=V3JPJOOIOfwLn8zm7K2n2toKLuKsK7g98HVnJbZkmMk=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdeKSzYUrXinYcieiKsuk3mEIowYCboTea09 Mghy+RmAEKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynXgAKCRCPgPtYfRL+ TgW7B/47F88dCFPo2y5c4J9fIg5p8yNTSqZd8tnwGRPnAjqUoyHfmw9Wke3X0yXSRUraPc3Q9Hc RV3KxC6BqbTVyMJMKnYcSL2knpI7iIcB7DKMAPHN0VnUSu2WDwnjHJloY+oOA6QgwtmvCxBEejb icVY/89EXSauP3wQApEPZOAF57zW3j/9ayrAqPiUFOqzW1DDDdqvPTN5XMZeP1p0ia86CVBMRyk 9STMsmQl2TYenhOlqjYlAauLdbMD7goHK3cYfi0rEzlkp0l9wcjAN3ffitJhaenCYg1Y13ay33v HIfPeSvgdb+TWVYzDwdcRZuLSIyAG108KUKkzZMZFB8Jcmjk
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
 drivers/scsi/jazz_esp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 0c842fb29aa0..494a671fb556 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -176,7 +176,7 @@ static int esp_jazz_probe(struct platform_device *dev)
 	return err;
 }
 
-static int esp_jazz_remove(struct platform_device *dev)
+static void esp_jazz_remove(struct platform_device *dev)
 {
 	struct esp *esp = dev_get_drvdata(&dev->dev);
 	unsigned int irq = esp->host->irq;
@@ -189,8 +189,6 @@ static int esp_jazz_remove(struct platform_device *dev)
 			  esp->command_block_dma);
 
 	scsi_host_put(esp->host);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -198,7 +196,7 @@ MODULE_ALIAS("platform:jazz_esp");
 
 static struct platform_driver esp_jazz_driver = {
 	.probe		= esp_jazz_probe,
-	.remove		= esp_jazz_remove,
+	.remove_new	= esp_jazz_remove,
 	.driver	= {
 		.name	= "jazz_esp",
 	},
-- 
2.42.0

