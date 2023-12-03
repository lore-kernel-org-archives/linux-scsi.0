Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F8B106
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-0005hW-Ts; Sun, 03 Dec 2023 17:06:14 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DK9t-HP; Sun, 03 Dec 2023 17:06:14 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DPos-7z; Sun, 03 Dec 2023 17:06:14 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 06/14] scsi: mac_esp: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:51 +0100
Message-ID:  <9013c84059b8ccd6a5c8305aa35cfdfa314ba74c.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1844; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=eq33+WGghO/SVL/B/pYvTYvDw2vusngjGxzoUEKQznU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdfLZ0A/rjpy9pmNHFB+dqZFK4ehkn4BgppL ryV9cx9o2mJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynXwAKCRCPgPtYfRL+ TjJXB/41IUjR2sHCMUoNtVMo0PNWFhOLbwYU12SN32jSCIVotYD47+sBW+aDBvHu6auXf9CjUIW AEATbCOaNugGAus4luz5I/jmw2Nvbr8CH5GltmcpA0RU/zzDpGXnt4qNqjahxa7V05aewvX5id1 biEbgRG99Mwz0tHdaI9x7PL3Z+MNgx4oH5Y22QT6tPyuI/Kqh+HliyoIquxYsbZGfIMYDIz1kdJ DSzzHd2aRxW3b7j+tnCHUfdH28qFNM33vEVZ9AKEAgH2w2A+mdgN08nsxjh10HRZr7G8mrhA1U9 rvU5jLqqlEzP9dVmbN1YZdgWlKR04Du2RMBvPbsWHct4Z0vx
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
 drivers/scsi/mac_esp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 3f0061b00494..187ae0a65d40 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -407,7 +407,7 @@ static int esp_mac_probe(struct platform_device *dev)
 	return err;
 }
 
-static int esp_mac_remove(struct platform_device *dev)
+static void esp_mac_remove(struct platform_device *dev)
 {
 	struct mac_esp_priv *mep = platform_get_drvdata(dev);
 	struct esp *esp = mep->esp;
@@ -428,13 +428,11 @@ static int esp_mac_remove(struct platform_device *dev)
 	kfree(esp->command_block);
 
 	scsi_host_put(esp->host);
-
-	return 0;
 }
 
 static struct platform_driver esp_mac_driver = {
 	.probe    = esp_mac_probe,
-	.remove   = esp_mac_remove,
+	.remove_new = esp_mac_remove,
 	.driver   = {
 		.name	= DRV_MODULE_NAME,
 	},
-- 
2.42.0

