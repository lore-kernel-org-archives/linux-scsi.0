From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] scsi_transport_sas.c - make write attrs link_reset and hard_reset writeable
Date: Wed, 17 May 2006 18:19:43 -0600
Message-ID: <20060518001943.GA8896@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:18358 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750827AbWERAY0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 20:24:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

A couple write attributes in sas transport layer have a small
bug that prevents them from being written to.  Those
attributes are the link_reset and write_reset.  This is due
the store field being set to NULL.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


--- b/drivers/scsi/scsi_transport_sas.c	2006-05-16 15:10:30.000000000 -0600
+++ a/drivers/scsi/scsi_transport_sas.c	2006-05-17 18:07:33.000000000 -0600
@@ -977,7 +977,6 @@
 #define SETUP_TEMPLATE(attrb, field, perm, test)				\
 	i->private_##attrb[count] = class_device_attr_##field;		\
 	i->private_##attrb[count].attr.mode = perm;			\
-	i->private_##attrb[count].store = NULL;				\
 	i->attrb[count] = &i->private_##attrb[count];			\
 	if (test)							\
 		count++
