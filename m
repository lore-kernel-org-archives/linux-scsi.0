From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch] qlogic: don't call qlogic_release in qlogic_config
Date: Sun, 26 Oct 2003 11:37:31 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031026133730.GA470@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:32266 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S263126AbTJZNii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Oct 2003 08:38:38 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,
	with these last two patches, my qlogic based pcmcia card is usable.
Mike Christie told me that other pcmcia drivers except ninja need the same
type of fix and i'll be doing it now.

p.s.: please cc me as i'm not subscribed to linux-scsi

--
aris


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-dont_call_release.patch"

--- linux/drivers/scsi/pcmcia/qlogic_stub.c.orig	2003-10-24 11:36:07.000000000 -0200
+++ linux/drivers/scsi/pcmcia/qlogic_stub.c	2003-10-24 11:56:33.000000000 -0200
@@ -265,7 +265,11 @@
 
 cs_failed:
 	cs_error(link->handle, last_fn, last_ret);
-	qlogic_release(link);
+	link->dev = NULL;
+	CardServices(ReleaseConfiguration, link->handle);
+	CardServices(ReleaseIO, link->handle, &link->io);
+	CardServices(ReleaseIRQ, link->handle, &link->irq);
+	link->state &= ~DEV_CONFIG;
 	return;
 
 }				/* qlogic_config */

--PNTmBPCT7hxwcZjr--
