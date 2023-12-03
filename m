Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C816113
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:21 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-0005hk-5O; Sun, 03 Dec 2023 17:06:15 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DK9y-OY; Sun, 03 Dec 2023 17:06:14 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DPow-FG; Sun, 03 Dec 2023 17:06:14 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 07/14] scsi: mac: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:52 +0100
Message-ID:  <89ce161dad52d99df07135531512ccecb7f25d14.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1879; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=+LAH4AA0RrqXbnfMQIUBKTSBhjrcodlYO5mcqrnMDPQ=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdgVBHV894GQAFtGORXe+ic77vux7kj7otYh VEWYkYmWwaJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynYAAKCRCPgPtYfRL+ Ti28CAC1ecVDoF4232TAOHwjXEEWk3skYG1vPOsvJ0u6KwTO2noX1zlaLi9G43WcT0N5BGo6GRO FVROJa331uv1CSZZkDEqkuWSslzReqKdKykmCvpNxsFuRh2Y8TMnQsVUTGz7Z27kn9TRpZL6nL/ NWeC6uuWMsLneA13HazPS3qxYt8nwY9HWmdI7k1n0atakpUH8q0/+EtKtmQ/3wkZWzupqf4nZ4s 2iv49+toUx/xB5Y3d7iAoA5vfdrkQY5B3aYPlY1g6Bjmuaer6pTZRBNcuDW23xJBNfOHcFi2ujO IyKBvRZhdt10iMYFFZe49Q5bYZi4FheA9Eon7Q0yABPmx77d
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
 drivers/scsi/mac_scsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2e511697fce3..181f16899fdc 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -523,7 +523,7 @@ static int __init mac_scsi_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __exit mac_scsi_remove(struct platform_device *pdev)
+static void __exit mac_scsi_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *instance = platform_get_drvdata(pdev);
 
@@ -532,11 +532,10 @@ static int __exit mac_scsi_remove(struct platform_device *pdev)
 		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
 	scsi_host_put(instance);
-	return 0;
 }
 
 static struct platform_driver mac_scsi_driver = {
-	.remove = __exit_p(mac_scsi_remove),
+	.remove_new = __exit_p(mac_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
 	},
-- 
2.42.0

