Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6712102
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-0005iF-T1; Sun, 03 Dec 2023 17:06:15 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-00DKAD-G0; Sun, 03 Dec 2023 17:06:15 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz1-00DPp8-6x; Sun, 03 Dec 2023 17:06:15 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 10/14] scsi: sgiwd93: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:55 +0100
Message-ID:  <92114604fd1274073915e515cae15003ff07aa4a.1701619134.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1932; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=DW3LG7aglWlZOVUC2OH9y5ea5FON/xeAQBAEDC/idiM=; b=owGbwMvMwMXY3/A7olbonx/jabUkhtSc5ckb3lg4dbtsvjD38jwDg7PyVYE9DewKLEYnY9ck5 e0zaEjsZDRmYWDkYpAVU2Sxb1yTaVUlF9m59t9lmEGsTCBTGLg4BWAirx+y/y/clGXxekUg96r/ DL9aGbgqZhXN5Gx2vV/oVPgtKdyzu3RbmxDv+YmMudOk3Hp5Pl/qNaou6j9+dIGIY/oF9pO3Fsz tXzqFcVpeXdONnee4pD7POvIu8GBJ7feH2suVTL58n5KYVm/Io7R8yf3LMp/79dTjL/epSkg5vO 3s2DlrRWxbhchDhjvTz4XIlf5LvtMcHfDb9Z1094Twc2JVLj+mPtigsS0yJeWUJ3eCz+spMSLzS 9r63V0OBhzJOL9Qr8R9W/rn10eaXnYVlrnu2xj1YAX3KiH+4/rTw6bG57R0np2Q6hQb2td7zfdr 9dR5oQ+v2Non20Vy95WrvKvQWTKRlevSXTU/wbmNDRMTAA==
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
 drivers/scsi/sgiwd93.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 88e2b5eb9caa..b0bef83db7b6 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -291,7 +291,7 @@ static int sgiwd93_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int sgiwd93_remove(struct platform_device *pdev)
+static void sgiwd93_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(pdev);
 	struct ip22_hostdata *hdata = (struct ip22_hostdata *) host->hostdata;
@@ -302,12 +302,11 @@ static int sgiwd93_remove(struct platform_device *pdev)
 	dma_free_noncoherent(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma,
 			DMA_TO_DEVICE);
 	scsi_host_put(host);
-	return 0;
 }
 
 static struct platform_driver sgiwd93_driver = {
 	.probe  = sgiwd93_probe,
-	.remove = sgiwd93_remove,
+	.remove_new = sgiwd93_remove,
 	.driver = {
 		.name   = "sgiwd93",
 	}
-- 
2.42.0

