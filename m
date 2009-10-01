From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 25/34] don't use __devexit_p to wrap snirm710_driver_remove
Date: Thu,  1 Oct 2009 10:28:29 +0200
Message-ID: <1254385718-14254-25-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56697 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbZJAI3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 04:29:47 -0400
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi@vger.kernel.org

The function snirm710_driver_remove is defined using __exit, so don't
use __devexit_p but __exit_p to wrap it.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sni_53c710.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 37b3359..491a088 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -133,7 +133,7 @@ static int __exit snirm710_driver_remove(struct pla=
tform_device *dev)
=20
 static struct platform_driver snirm710_driver =3D {
 	.probe	=3D snirm710_probe,
-	.remove	=3D __devexit_p(snirm710_driver_remove),
+	.remove	=3D __exit_p(snirm710_driver_remove),
 	.driver	=3D {
 		.name	=3D "snirm_53c710",
 		.owner	=3D THIS_MODULE,
--=20
1.6.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
