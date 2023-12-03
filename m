Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D27F3
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:20 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz2-0005j8-8M; Sun, 03 Dec 2023 17:06:16 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-00DKAH-Mh; Sun, 03 Dec 2023 17:06:15 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-00DPpC-Df; Sun, 03 Dec 2023 17:06:15 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 11/14] scsi: sni_53c710: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:56 +0100
Message-ID:  <2f4b7366ca00a107a9595514795e909e632980da.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1928; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=JVXR/wGLKd4oXjMe20bO4gGzC6ZHjdQOxID8arexqvs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdkPz0RcmVpObAkOKaKHE/StzZioMOpdiaEJ ZY5QYIbaj+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynZAAKCRCPgPtYfRL+ TvozCACJXUkTkuz7361IrfRWYT0d6c3g4fbsQoD6zZF+vyXmYYfGuvzPmoHhRTXIlo1NNUvpoxK xdA0ZfCG9+XfFCgNlbxYw1SgHvq2B6nQ2+yotgG5RSUpXXtv7Aix8EqJb2lpAkccH8aeKnYcDWc VHD3aay2tA7k5SJiPzeLBFV5aLNN29sqdi/e8lIAB7s7BSFcUwZp4XtKJV8Kfdu3eAZUU7647Ff mMXQzMDFIfMZ0rlH99Nu+TsUbu1MBnw+F+iLsOKmcwl2yE8pq1sep84xt+dJQaEj7xd0EiDDoP5 x8y1EDNA1q4dxJDcVrbMwDU1LJ99SwlsqRU3Auzzpo0rHxsO
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
 drivers/scsi/sni_53c710.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 678651b9b4dd..9df1c90a24c1 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -104,7 +104,7 @@ static int snirm710_probe(struct platform_device *dev)
 	return -ENODEV;
 }
 
-static int snirm710_driver_remove(struct platform_device *dev)
+static void snirm710_driver_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
 	struct NCR_700_Host_Parameters *hostdata =
@@ -115,13 +115,11 @@ static int snirm710_driver_remove(struct platform_device *dev)
 	free_irq(host->irq, host);
 	iounmap(hostdata->base);
 	kfree(hostdata);
-
-	return 0;
 }
 
 static struct platform_driver snirm710_driver = {
 	.probe	= snirm710_probe,
-	.remove	= snirm710_driver_remove,
+	.remove_new = snirm710_driver_remove,
 	.driver	= {
 		.name	= "snirm_53c710",
 	},
-- 
2.42.0

