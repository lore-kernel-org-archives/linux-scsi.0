From: Martin Hicks <mort@wildopensource.com>
Subject: [PATCH] Fix template size calculation in transport attributes
Date: Mon, 29 Mar 2004 12:22:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040329172201.GB18948@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FkmkrVfFsRoUs1wW"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:21670 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S263027AbUC2RWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 12:22:04 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi,

This small patch fixes the template size calculation in
{spi,fc}_attach_transport().

Thanks
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="transport-attrs-template-size.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1663  -> 1.1664 
#	drivers/scsi/scsi_transport_fc.c	1.2     -> 1.3    
#	drivers/scsi/scsi_transport_spi.c	1.5     -> 1.6    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/29	mort@tomahawk.engr.sgi.com	1.1664
# Fix a bug in the SPI and FC transport attributes code.
# The calculation of template size was wrong.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	Mon Mar 29 09:19:12 2004
+++ b/drivers/scsi/scsi_transport_fc.c	Mon Mar 29 09:19:12 2004
@@ -159,7 +159,7 @@
 	i->t.attrs = &i->attrs[0];
 	i->t.class = &fc_transport_class;
 	i->t.setup = &fc_setup_transport_attrs;
-	i->t.size = sizeof(struct fc_transport_attrs) - sizeof(unsigned long);
+	i->t.size = sizeof(struct fc_transport_attrs);
 	i->f = ft;
 
 	SETUP_ATTRIBUTE_RD(port_id);
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	Mon Mar 29 09:19:12 2004
+++ b/drivers/scsi/scsi_transport_spi.c	Mon Mar 29 09:19:12 2004
@@ -632,7 +632,7 @@
 	i->t.attrs = &i->attrs[0];
 	i->t.class = &spi_transport_class;
 	i->t.setup = &spi_setup_transport_attrs;
-	i->t.size = sizeof(struct spi_transport_attrs) - sizeof(unsigned long);
+	i->t.size = sizeof(struct spi_transport_attrs);
 	i->f = ft;
 
 	SETUP_ATTRIBUTE(period);

--FkmkrVfFsRoUs1wW--
