From: James.Smart@Emulex.Com
Subject: [PATCH] fix the fix for multiple HBA problem with transport classes
Date: Wed, 2 Feb 2005 15:55:06 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F331@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:38817 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262549AbVBBUzM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2005 15:55:12 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

Testing was showing transport devices not being enumerated.

The reason was the wrong attribute container was being compared
against in the "match" functions.  This patch fixes it.

-- james s


diff -puN a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2005-02-02 14:49:15.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2005-02-02 15:31:47.000000000 -0500
@@ -759,7 +759,7 @@ static int fc_target_match(struct attrib
 
 	i = to_fc_internal(shost->transportt);
 
-	return &i->t.host_attrs == cont;
+	return &i->t.target_attrs == cont;
 }
 
 
diff -puN a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	2005-02-02 14:58:01.000000000 -0500
+++ b/drivers/scsi/scsi_transport_spi.c	2005-02-02 15:32:52.000000000 -0500
@@ -148,7 +148,7 @@ static int spi_host_match(struct attribu
 
 	i = to_spi_internal(shost->transportt);
 
-	return &i->t.target_attrs == cont;
+	return &i->t.host_attrs == cont;
 }
 
 static int spi_device_configure(struct device *dev)
diff -puN a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c	2005-02-02 15:30:56.000000000 -0500
+++ b/drivers/scsi/scsi_transport_iscsi.c	2005-02-02 15:32:07.000000000 -0500
@@ -289,7 +289,7 @@ static int iscsi_target_match(struct att
 
 	i = to_iscsi_internal(shost->transportt);
 
-	return &i->t.host_attrs == cont;
+	return &i->t.target_attrs == cont;
 }
 
 struct scsi_transport_template *
_
