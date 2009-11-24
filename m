From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 05/38] move initio_remove_one to .devexit.text
Date: Tue, 24 Nov 2009 22:07:00 +0100
Message-ID: <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44628 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969AbZKXVI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 16:08:29 -0500
In-Reply-To: <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

The function initio_remove_one is used only wrapped by __devexit_p so
define it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@redhat.com>
---
 drivers/scsi/initio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..8bbfd99 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2964,7 +2964,7 @@ out_disable_device:
  *	finished being used.
  */
=20
-static void initio_remove_one(struct pci_dev *pdev)
+static void __devexit initio_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);
 	struct initio_host *s =3D (struct initio_host *)host->hostdata;
--=20
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
