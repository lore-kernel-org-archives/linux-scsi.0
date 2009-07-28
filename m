From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] scsi_transport_sas: Write outside array bounds
Date: Tue, 28 Jul 2009 12:20:29 +0200
Message-ID: <4A6ED0ED.1090707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:45290 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZG1KRm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2009 06:17:42 -0400
Received: by ewy26 with SMTP id 26so3845925ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2009 03:17:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

SETUP_PORT_ATTRIBUTE increments count, making the write out of bounds (array of
size 1)

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Credits to Parfait (http://research.sun.com/projects/parfait/)

I suspect this isn't the only location where count shouldn't be incremented,
Somebody should review this function.

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 0895d3c..c784ae4 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1693,9 +1693,10 @@ sas_attach_transport(struct sas_function_template *ft)
 
 	count = 0;
 	SETUP_PORT_ATTRIBUTE(num_phys);
-	i->host_attrs[count] = NULL;
 
 	count = 0;
+	i->host_attrs[count] = NULL;
+
 	SETUP_PHY_ATTRIBUTE(initiator_port_protocols);
 	SETUP_PHY_ATTRIBUTE(target_port_protocols);
 	SETUP_PHY_ATTRIBUTE(device_type);
