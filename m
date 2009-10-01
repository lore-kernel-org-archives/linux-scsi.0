From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 10/34] don't use __devexit_p to wrap lasi700_driver_remove
Date: Thu,  1 Oct 2009 10:28:14 +0200
Message-ID: <1254385718-14254-10-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56700 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbZJAI3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 04:29:48 -0400
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, Kyle McMartin <kyle@mcmartin.ca>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

The function lasi700_driver_remove is defined using __exit, so don't us=
e
__devexit_p but __exit_p to wrap it.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/lasi700.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index b3d3131..2991c81 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -167,7 +167,7 @@ static struct parisc_driver lasi700_driver =3D {
 	.name =3D		"lasi_scsi",
 	.id_table =3D	lasi700_ids,
 	.probe =3D	lasi700_probe,
-	.remove =3D	__devexit_p(lasi700_driver_remove),
+	.remove =3D	__exit_p(lasi700_driver_remove),
 };
=20
 static int __init
--=20
1.6.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
