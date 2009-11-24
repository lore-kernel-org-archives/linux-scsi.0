From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 21/38] move stex_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:16 +0100
Message-ID: <1259096853-18909-21-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-17-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-18-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-19-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44749 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934048AbZKXVIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 16:08:42 -0500
In-Reply-To: <1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ed Lin <ed.lin@promise.com>, Yang Hongyang <yanghy@cn.fujitsu.com>, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net

The function stex_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Willem Riede <osst@riede.org>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: "Kai M=C3=A4kisara" <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ed Lin <ed.lin@promise.com>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org
Cc: osst-users@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/stex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 09fa886..09ee386 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1679,7 +1679,7 @@ static void stex_hba_free(struct st_hba *hba)
 			  hba->dma_mem, hba->dma_handle);
 }
=20
-static void stex_remove(struct pci_dev *pdev)
+static void __devexit stex_remove(struct pci_dev *pdev)
 {
 	struct st_hba *hba =3D pci_get_drvdata(pdev);
=20
--=20
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
