Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E69BFA
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:21 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz2-0005oZ-Sw; Sun, 03 Dec 2023 17:06:16 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz2-00DKAR-A4; Sun, 03 Dec 2023 17:06:16 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz2-00DPpN-18; Sun, 03 Dec 2023 17:06:16 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 14/14] scsi: sun_esp: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:59 +0100
Message-ID:  <1d385231c23c2a1e6e7dc1968eb111327386d1f6.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1963; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=669rSRbFAMDpXl1yfjpgeYu0Rciw+vTbBypz438k1KA=; b=owEBbAGT/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdo0Yub6ZnaZAtp4ZN/cWTVrqgggbIJu3eJN Wer3bkvQuCJATIEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynaAAKCRCPgPtYfRL+ TmFhB/jJJ+J7DR/w8IK7Y65UOYrwQGhY7Nw+ZUk893a3QdA5I8eeo/QBRwCbH9X3URfONXTtjur 7cfWZ//RhdsjXmveq4ARP65BLffj2KuWzqPW86fPsEsr2xASo5Hz99TAUuqXNRzNpGJL+xOKwgG tBLTPDLi3JSvw+g/QsP+8IYpkCSECqwv3u/ET0OG1UuHE7OJz7kJ9ubCQ7OwlLHlkiNKRYhqhe0 R2oLgp3I66cSXtk9D8Ra50jV4T+QVSrLVOFCrGYAlVAldCGuQLBdflIO5DWEhZXIuehwiJr8q35 B8uzUwIj3B5XrkBc2WL7C0EAWRB/vvSu15LsF/gV1SVdlhQ=
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
 drivers/scsi/sun_esp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index afa9d02a33ec..64a7c2c6c5ff 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -550,7 +550,7 @@ static int esp_sbus_probe(struct platform_device *op)
 	return ret;
 }
 
-static int esp_sbus_remove(struct platform_device *op)
+static void esp_sbus_remove(struct platform_device *op)
 {
 	struct esp *esp = dev_get_drvdata(&op->dev);
 	struct platform_device *dma_of = esp->dma;
@@ -581,8 +581,6 @@ static int esp_sbus_remove(struct platform_device *op)
 	dev_set_drvdata(&op->dev, NULL);
 
 	put_device(&dma_of->dev);
-
-	return 0;
 }
 
 static const struct of_device_id esp_match[] = {
@@ -605,7 +603,7 @@ static struct platform_driver esp_sbus_driver = {
 		.of_match_table = esp_match,
 	},
 	.probe		= esp_sbus_probe,
-	.remove		= esp_sbus_remove,
+	.remove_new	= esp_sbus_remove,
 };
 module_platform_driver(esp_sbus_driver);
 
-- 
2.42.0

