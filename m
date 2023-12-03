Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60CB101
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-0005hu-By; Sun, 03 Dec 2023 17:06:15 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DKA2-VY; Sun, 03 Dec 2023 17:06:14 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-00DPp0-MW; Sun, 03 Dec 2023 17:06:14 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 08/14] scsi: mvme16x: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:53 +0100
Message-ID:  <1d16e93a498831abd64df8b8cf54fd8872cdd1cd.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2091; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=OmXRLj7k/75ILKZOY3rC0Oh9OHKObfZIwuESWPXVjtM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdhzT4TJdCtFZXIriXfeFHv1lVktPFGFMiLu bkAX9UTpWeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynYQAKCRCPgPtYfRL+ Tn/iB/9Xg/IIJmyxC9vyaE6xj/fjOcyoaynT9o7u5et7oecIyUgT6/ZHC21ctNSyI7vWzu7Rmo0 Kmww1aKA3fRSDbKJFI/VYCSf9a1XEZNOWYxwxQ2vifgF/TnKDivl5V77rqMtREXb43VtDZMydYe VjWR1YXIbKuHbgBLF6x7dakOtVdT2go6bAlaEK7ewYpHw2qdUXffV+071jJ1L4uDTTFRO9obtYb iWjEWjOQJ4fXJeuheVXU/u7IfVbLihojPdHH9AZz0n1OgQtZ/32Anor9561TRdZk7tJDh42V7z/ PIiyvKoxTwL+fTz84Ndjr+1GpmSXxmFRHN2mBH9LBS/ihi+G
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
 drivers/scsi/mvme16x_scsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index 21d638299ab8..e08a38e2a442 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -103,7 +103,7 @@ static int mvme16x_probe(struct platform_device *dev)
 	return -ENODEV;
 }
 
-static int mvme16x_device_remove(struct platform_device *dev)
+static void mvme16x_device_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
@@ -120,8 +120,6 @@ static int mvme16x_device_remove(struct platform_device *dev)
 	NCR_700_release(host);
 	kfree(hostdata);
 	free_irq(host->irq, host);
-
-	return 0;
 }
 
 static struct platform_driver mvme16x_scsi_driver = {
@@ -129,7 +127,7 @@ static struct platform_driver mvme16x_scsi_driver = {
 		.name           = "mvme16x-scsi",
 	},
 	.probe          = mvme16x_probe,
-	.remove         = mvme16x_device_remove,
+	.remove_new     = mvme16x_device_remove,
 };
 
 static int __init mvme16x_scsi_init(void)
-- 
2.42.0

