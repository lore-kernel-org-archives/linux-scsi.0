From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 24/30] drivers/scsi/megaraid.c: kmalloc + memset conversion to kzalloc
Date: Fri, 10 Aug 2007 16:21:37 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229BF18C8@NAMAIL2.ad.lsil.com>
References: <200708102150.l7ALonOX011390@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38499 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbXHJWWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 18:22:14 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200708102150.l7ALonOX011390@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, m.kozlowski@tuxland.pl, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

ACK.

--Sumant
 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
akpm@linux-foundation.org
Sent: Friday, August 10, 2007 2:51 PM
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org;
m.kozlowski@tuxland.pl
Subject: [patch 24/30] drivers/scsi/megaraid.c: kmalloc + memset
conversion to kzalloc

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch does kmalloc + memset conversion to kzalloc and adds missing
check for kzalloc return value.

 drivers/scsi/megaraid.c | 116109 -> 116094 (-15 bytes)
drivers/scsi/megaraid.o | 257872 -> 257772 (-100 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN
drivers/scsi/megaraid.c~drivers-scsi-megaraidc-kmalloc-memset-conversion
-to-kzalloc drivers/scsi/megaraid.c
---
a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-kmalloc-memset-conversi
on-to-kzalloc
+++ a/drivers/scsi/megaraid.c
@@ -4408,8 +4408,10 @@ mega_internal_command(adapter_t *adapter
 	scmd = &adapter->int_scmd;
 	memset(scmd, 0, sizeof(Scsi_Cmnd));
 
-	sdev = kmalloc(sizeof(struct scsi_device), GFP_KERNEL);
-	memset(sdev, 0, sizeof(struct scsi_device));
+	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (!sdev)
+		return -ENOMEM;
+
 	scmd->device = sdev;
 
 	scmd->device->host = adapter->host;
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
