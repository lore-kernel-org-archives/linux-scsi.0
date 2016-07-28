From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH] mpt3sas: Ensure the connector_name string is NUL-terminated
Date: Wed, 27 Jul 2016 21:45:51 -0700
Message-ID: <8b53a29b3ec90c9a7030e8fa3e1555ad5802dce9.1469680625.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44143 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750946AbcG1EqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2016 00:46:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u6S4k4nU032026
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2016 21:46:04 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 24exkkngdg-1
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2016 21:46:04 -0700
Received: from facebook.com (2401:db00:11:d0be:face:0:1b:0)	by
 mx-out.facebook.com (10.103.99.99) with ESMTP	id
 2fc00c76547e11e68c730002c9dfb610-101f9af0 for <linux-scsi@vger.kernel.org>;
	Wed, 27 Jul 2016 21:46:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Calvin Owens <calvinowens@fb.com>

We blindly trust the hardware to give us NUL-terminated strings, which
is a bad idea because it doesn't always do that. For example:

  [  481.184784] mpt3sas_cm0: 	enclosure level(0x0000), connector name(     \x3)

In this case, connector_name is four spaces. We got lucky here because
the 2nd byte beyond our character array happens to be a NUL. Fix this
by explicitly writing '\0' to the end of the string to ensure we don't
run off the edge of the world in printk().

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 892c9be..eb7f5b0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -478,7 +478,7 @@ struct _sas_device {
 	u8	pfa_led_on;
 	u8	pend_sas_rphy_add;
 	u8	enclosure_level;
-	u8	connector_name[4];
+	u8	connector_name[5];
 	struct kref refcount;
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index cd91a68..acabe48 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5380,8 +5380,9 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 		     MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
 			sas_device->enclosure_level =
 				le16_to_cpu(sas_device_pg0.EnclosureLevel);
-			memcpy(&sas_device->connector_name[0],
-				&sas_device_pg0.ConnectorName[0], 4);
+			memcpy(sas_device->connector_name,
+				sas_device_pg0.ConnectorName, 4);
+			sas_device->connector_name[4] = '\0';
 		} else {
 			sas_device->enclosure_level = 0;
 			sas_device->connector_name[0] = '\0';
@@ -5508,8 +5509,9 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	if (sas_device_pg0.Flags & MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
 		sas_device->enclosure_level =
 			le16_to_cpu(sas_device_pg0.EnclosureLevel);
-		memcpy(&sas_device->connector_name[0],
-			&sas_device_pg0.ConnectorName[0], 4);
+		memcpy(sas_device->connector_name,
+			sas_device_pg0.ConnectorName, 4);
+		sas_device->connector_name[4] = '\0';
 	} else {
 		sas_device->enclosure_level = 0;
 		sas_device->connector_name[0] = '\0';
-- 
2.8.0.rc2

