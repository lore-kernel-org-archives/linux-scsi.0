From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 12/34] move megaraid_detach_one to .devexit.text
Date: Thu,  1 Oct 2009 10:28:16 +0200
Message-ID: <1254385718-14254-12-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56573 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbZJAI3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 04:29:24 -0400
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, linux-scsi@vger.kernel.org

The function megaraid_detach_one is used only wrapped by __devexit_p so
define it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_mbox.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megar=
aid/megaraid_mbox.c
index 234f0b7..9fc9cf7 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -76,7 +76,7 @@ static int megaraid_init(void);
 static void megaraid_exit(void);
=20
 static int megaraid_probe_one(struct pci_dev*, const struct pci_device=
_id *);
-static void megaraid_detach_one(struct pci_dev *);
+static void __devexit megaraid_detach_one(struct pci_dev *);
 static void megaraid_mbox_shutdown(struct pci_dev *);
=20
 static int megaraid_io_attach(adapter_t *);
@@ -551,7 +551,7 @@ out_probe_one:
  *
  * This routine is also called from the PCI hotplug system.
  */
-static void
+static void __devexit
 megaraid_detach_one(struct pci_dev *pdev)
 {
 	adapter_t		*adapter;
--=20
1.6.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
