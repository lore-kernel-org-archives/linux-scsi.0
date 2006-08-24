From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: [SCSI] - eliminate hard-coded timeouts in qla1280.c
Date: Thu, 24 Aug 2006 14:01:59 -0400
Message-ID: <F3598542BAC24B4783B7A440D45522FF04B5D89B@usahm236.amer.corp.eds.com>
References: <20060824172845.GC2887@networkno.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ahmler7.mail.eds.com ([192.85.154.81]:9905 "EHLO
	ahmler7.mail.eds.com") by vger.kernel.org with ESMTP
	id S1751662AbWHXSCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2006 14:02:22 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20060824172845.GC2887@networkno.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Thiemo Seufer <ths@networkno.de>, 366730@bugs.debian.org, "Bailey, Scott" <scott.bailey@eds.com>

Thanks are due to Ian Dall for the following patch. It replaces
hard-coded
30-second timeouts in qla1280.c, enabling tape operations that take
longer
than 30 seconds to work again. :-)

This patch applies cleanly to 2.6.17.11 with an offset of 1 line.

Signed-off-by: R. Scott Bailey <scott.bailey@eds.com>

--- qla1280.c	2006-03-20 16:23:29.000000000 +1030
+++ qla1280.c	2006-03-23 23:37:28.000000000 +1030
@@ -2886,7 +2886,7 @@
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(30);
+	pkt->timeout = cpu_to_le16(cmd->timeout_per_command/HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
@@ -3185,7 +3185,7 @@
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(30);
+	pkt->timeout = cpu_to_le16(cmd->timeout_per_command/HZ);
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
