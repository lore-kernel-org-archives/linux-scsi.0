From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 23/34] don't use __devexit_p to wrap sgiwd93_remove
Date: Thu,  1 Oct 2009 10:28:27 +0200
Message-ID: <1254385718-14254-23-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56661 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbZJAI3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 04:29:40 -0400
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dmitri Vorobiev <dmitri.vorobiev@movial.fi>, linux-scsi@vger.kernel.org

The function sgiwd93_remove is defined using __exit, so don't use
__devexit_p but __exit_p to wrap it.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sgiwd93.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 0807b26..2f28ec4 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -312,7 +312,7 @@ static int __exit sgiwd93_remove(struct platform_de=
vice *pdev)
=20
 static struct platform_driver sgiwd93_driver =3D {
 	.probe  =3D sgiwd93_probe,
-	.remove =3D __devexit_p(sgiwd93_remove),
+	.remove =3D __exit_p(sgiwd93_remove),
 	.driver =3D {
 		.name   =3D "sgiwd93",
 		.owner	=3D THIS_MODULE,
--=20
1.6.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
