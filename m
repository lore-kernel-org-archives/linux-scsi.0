From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 3/4] ps3rom: updates after final review
Date: Thu, 19 Jul 2007 15:54:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191554210.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
 <20070719021045.c0b994ca.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191548070.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1543760630-1184853294=:8661"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43795 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964910AbXGSNy4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 09:54:56 -0400
In-Reply-To: <Pine.LNX.4.62.0707191548070.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1543760630-1184853294=:8661
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

ps3rom: updates after final review:
  o Kill confusing ps3rom_priv() macro, open code it instead
  o kmap_atomic() cannot fail

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/scsi/ps3rom.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -42,7 +42,6 @@ struct ps3rom_private {
 	struct ps3_storage_device *dev;
 	struct scsi_cmnd *curr_cmd;
 };
-#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
 
 
 #define LV1_STORAGE_SEND_ATAPI_COMMAND	(1)
@@ -113,8 +112,6 @@ static int fill_from_dev_buffer(struct s
 	for (k = 0, req_len = 0, act_len = 0; k < cmd->use_sg; ++k, ++sgpnt) {
 		if (active) {
 			kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
-			if (!kaddr)
-				return -1;
 			len = sgpnt->length;
 			if ((req_len + len) > buflen) {
 				active = 0;
@@ -151,8 +148,6 @@ static int fetch_to_dev_buffer(struct sc
 	sgpnt = cmd->request_buffer;
 	for (k = 0, req_len = 0, fin = 0; k < cmd->use_sg; ++k, ++sgpnt) {
 		kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
-		if (!kaddr)
-			return -1;
 		len = sgpnt->length;
 		if ((req_len + len) > buflen) {
 			len = buflen - req_len;
@@ -379,7 +374,7 @@ static irqreturn_t ps3rom_interrupt(int 
 		return IRQ_HANDLED;
 	}
 
-	host = ps3rom_priv(dev);
+	host = dev->sbd.core.driver_data;
 	priv = shost_priv(host);
 	cmd = priv->curr_cmd;
 
@@ -469,7 +464,7 @@ static int __devinit ps3rom_probe(struct
 	}
 
 	priv = shost_priv(host);
-	ps3rom_priv(dev) = host;
+	dev->sbd.core.driver_data = host;
 	priv->dev = dev;
 
 	/* One device/LUN per SCSI bus */
@@ -489,7 +484,7 @@ static int __devinit ps3rom_probe(struct
 
 fail_host_put:
 	scsi_host_put(host);
-	ps3rom_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 fail_teardown:
 	ps3stor_teardown(dev);
 fail_free_bounce:
@@ -500,12 +495,12 @@ fail_free_bounce:
 static int ps3rom_remove(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
-	struct Scsi_Host *host = ps3rom_priv(dev);
+	struct Scsi_Host *host = dev->sbd.core.driver_data;
 
 	scsi_remove_host(host);
 	ps3stor_teardown(dev);
 	scsi_host_put(host);
-	ps3rom_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 	kfree(dev->bounce_buf);
 	return 0;
 }

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1543760630-1184853294=:8661--
