Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23C1CC
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-0005i4-JP; Sun, 03 Dec 2023 17:06:15 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-00DKA6-6o; Sun, 03 Dec 2023 17:06:15 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DPp4-UB; Sun, 03 Dec 2023 17:06:14 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 09/14] scsi: qlogicpti: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:54 +0100
Message-ID:  <8242c07f617fc946aab857c9357f540598fe964e.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1993; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=DX9lJcChY3CbQVT0Hv59ZpzGpcFqvDKPIdvqtf8GhXo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdibp/lMfWQf/RxHEVZXQ0cP6woZbRj9WksK jlDcwSlxoCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynYgAKCRCPgPtYfRL+ ToIOB/9DKjLa9KSKqfZR3a2o0UfL4a9LfJKqX9gAwCG+/C+jDcOzPljdBmF+A9kjCgHfPYPa+eq LQPfCLu5QhZ4wq9BwGPYNDjOg240cfAU1aJIXovGLsmY0meAElXqJDIcFNfSdHL08O3D1oZMq3/ wNphFlz14C32fSzWeT+WyAaEpx+lKntQSX/6OJeES7mvaS68uBmoxoEHm15hQAcAl8OlkMin/Aa Jg8KvnJFsCLAsaRlatext/vijw1ND5PHLYdaHvpHPSmkqvR3lQpmYlkKSaNvfNqDAOBvQN7ZDTG t3P0fa1YkQgyDbmyYXUR7ZqVoN1MOhpShj1rfiHf+dN3v301
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
 drivers/scsi/qlogicpti.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 3b95f7a6216f..5d560d9b8944 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1409,7 +1409,7 @@ static int qpti_sbus_probe(struct platform_device *op)
 	return -ENODEV;
 }
 
-static int qpti_sbus_remove(struct platform_device *op)
+static void qpti_sbus_remove(struct platform_device *op)
 {
 	struct qlogicpti *qpti = dev_get_drvdata(&op->dev);
 
@@ -1438,8 +1438,6 @@ static int qpti_sbus_remove(struct platform_device *op)
 		of_iounmap(&op->resource[0], qpti->sreg, sizeof(unsigned char));
 
 	scsi_host_put(qpti->qhost);
-
-	return 0;
 }
 
 static const struct of_device_id qpti_match[] = {
@@ -1465,7 +1463,7 @@ static struct platform_driver qpti_sbus_driver = {
 		.of_match_table = qpti_match,
 	},
 	.probe		= qpti_sbus_probe,
-	.remove		= qpti_sbus_remove,
+	.remove_new	= qpti_sbus_remove,
 };
 module_platform_driver(qpti_sbus_driver);
 
-- 
2.42.0

