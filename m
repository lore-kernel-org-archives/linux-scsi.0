From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: [PATCH][BUGFIX] : megaraid patch for 2.10.1 (irq disable bug fix)
Date: Mon, 23 Feb 2004 12:24:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230C730@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34012 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261903AbUBWRYe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 12:24:34 -0500
List-Id: linux-scsi@vger.kernel.org
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hello all,

The following patch fixes a bug in megaraid driver version 2.10.1
where irq was erroneously being disabled.

Thanks,
Sreenivas

diff -Naur current/drivers/scsi/megaraid.c patched/drivers/scsi/megaraid.c
--- current/drivers/scsi/megaraid.c	2004-02-23 23:56:10.000000000 -0500
+++ patched/drivers/scsi/megaraid.c	2004-02-23 23:56:18.000000000 -0500
@@ -2474,7 +2474,9 @@
 	memset(raw_mbox, 0, sizeof(raw_mbox));
 	raw_mbox[0] = FLUSH_ADAPTER;
 
-	irq_disable(adapter);
+	if( adapter->flag & BOARD_IOMAP ) 
+		irq_disable(adapter);
+
 	free_irq(adapter->host->irq, adapter);
 
 	/* Issue a blocking (interrupts disabled) command to the card */
@@ -4040,7 +4042,9 @@
 		memset(raw_mbox, 0, sizeof(raw_mbox));
 		raw_mbox[0] = FLUSH_ADAPTER;
 
-		irq_disable(adapter);
+		if( adapter->flag & BOARD_IOMAP ) 
+			irq_disable(adapter);
+
 		free_irq(adapter->host->irq, adapter);
 
 		/*
