Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE50CC3524A
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75A9620838
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="emd6LCyu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgBBKrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 05:47:22 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8763 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgBBKrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 05:47:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580640439; x=1612176439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=rAReo7Ghhyllt4vhzaYwGGfwgZx7+2h3+bZQ0IC2fB4=;
  b=emd6LCyuKKzFzfJbrC1Rmy6JzPBnQLYJ4lhVfuppTDL8ifEUv6jR7Q38
   /oVnMtS3DWlml46RxoXROId/x/xmULHCItlIU59/QYE6B0EDDMZZFOIHI
   ZHTFRFI7JqLbxhhXia95c/kUA5VtYOjpu4jUkhgA+52DeKma76S1cr7oU
   pPfYMg4Bcy8oEBFj0ooeeLRs2Hw4n6Lesh+MwhbTYmnpo5R7ZONeQDUy6
   1551yXXsVF+NKH0Hk8VM2nDvw/o1CF5ulFPoGNFl+46fgDjcPzJen4SHG
   OYbpVnrPfw64IIrUfPA7jae2iR7rm/R5IJmHojARBgH4FOrCmgYwKvx42
   w==;
IronPort-SDR: vCgjVBXvrQ6ToTLyjPrGg/dAQyQs4yZkrspw634yhZivPZvs8X8bS087j4anEHX5YVIdJWmGSW
 c8QdEUOJc5OGuwjKGLol2MSPIrmNyhWW82U/21+SD2oZMd2zrcWCXVpGDSlUBC8PNAAZpfqIvf
 V+kVVjbR4lskIZnPgc8HitzI1IT0HsnxZ4pknjQsj4b72nFaZv4vXj2BTS7+vVjI5rvpkPoKIo
 6Zl+jcpYNy0wp/1yn/cyfRdt00+vmFFHwz5/gNYcHLxFEjv27+aKuhHWQATbvP/C/ASg4AqH+6
 KF8=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="128925973"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 18:47:19 +0800
IronPort-SDR: 9CqXTRR0ZleFwOWUNuNeTvCvFRjXKr0FPLyJbkzLGbcvEo/F04wJO0gDBDv0Syc6mzOohnapnS
 z1RNsKZrj9YScg6gdA0hEyekGzRN7ic7belqPJrkqlO88R+wIjVGPiD05UqC/tru/3ceR3RM9J
 P2bldDGDz8ve5trThsTP5MR0mYJjjEHX6+4pSuNN3Y+Wp7X09C/XreCQDyzHt+qBaz1P2r9Af1
 q5TjdB8xWF9shlHUtj6e+VaHjpEU/9p9bg1c+QKgD/EsRkAkJnxc460FVZ7Af11WhC15NTaomV
 uZn5aY7I2UxsnIZwFZo38yCn
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2020 02:40:25 -0800
IronPort-SDR: XI6t96dGbXOX1k+jk4xPRZt4RrXd86gFSq7r7R51IXvsEigcIJpNnUfJKqQ6ZipJQjmljyzPwl
 suD6M32ZwW/0ctXp3NCLvhJSvF1MCN3xhNcriiNpXk6WM8bZSlgSapk1AtZjquWYcwmgjQMl8M
 7tqWffg/2rbAI9fonjp2SGxc9YLIOWFYVZ/EgXCQRb4KdioXGGzR7rghD9FXiiIDrSCqRkusJo
 v/OwoLSgNNpp6MIpMwdL9Hw3EM3RngaO33rCdgjcNQoMZMdtpETRz2qeqyZwtIQCWHBUbUTEMl
 uFk=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2020 02:47:16 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Avi Shchislowski <avi.shchislowski@wdc.com>,
        Uri Yanai <uri.yanai@wdc.com>
Subject: [PATCH 4/5] scsi: ufs-thermal: implement thermal file ops
Date:   Sun,  2 Feb 2020 12:46:58 +0200
Message-Id: <1580640419-6703-5-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The thermal interface adds a new thermal zone device sensor under
/sys/class/thermal/ folder.

Signed-off-by: Uri Yanai <uri.yanai@wdc.com>
Signed-off-by: Avi Shchislowski <avi.shchislowski@wdc.com>
---
 drivers/scsi/ufs/ufs-thermal.c | 122 ++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufs.h         |   3 +
 2 files changed, 117 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-thermal.c b/drivers/scsi/ufs/ufs-thermal.c
index dfa5d68..23e4ac1 100644
--- a/drivers/scsi/ufs/ufs-thermal.c
+++ b/drivers/scsi/ufs/ufs-thermal.c
@@ -31,6 +31,99 @@ enum {
 		}
 };
 
+#define attr2milicelcius(attr) (((0xFF & attr) - 80) * 1000)
+
+static int ufs_thermal_get_temp(struct thermal_zone_device *device,
+				  int *temperature)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)device->devdata;
+	u32 temp;
+	int err;
+
+	err = ufshcd_query_attr(hba,
+			UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_ROUGH_TEMP,
+			0, 0, &temp);
+	if (err)
+		return -EINVAL;
+
+	*temperature = attr2milicelcius(temp);
+	return 0;
+}
+
+static int ufs_thermal_get_trip_temp(
+		struct thermal_zone_device *device,
+				 int trip, int *temp)
+{
+
+	if (trip < 0 || trip >= UFS_THERM_MAX_TRIPS)
+		return -EINVAL;
+
+	*temp = thermal.trip[trip];
+
+	return 0;
+}
+
+static int ufs_thermal_get_trip_type(
+		struct thermal_zone_device *device,
+		int trip, enum thermal_trip_type *type)
+{
+	if (trip < 0 || trip >= UFS_THERM_MAX_TRIPS)
+		return -EINVAL;
+
+	*type = THERMAL_TRIP_PASSIVE;
+
+	return 0;
+}
+
+static int ufs_thermal_get_boundary(struct ufs_hba *hba,
+					int trip, int *boundary)
+{
+	enum attr_idn idn;
+	int err = 0;
+	u32 val;
+
+	idn = trip == UFS_THERM_HIGH_TEMP ?
+			QUERY_ATTR_IDN_TOO_HIGH_TEMP :
+			QUERY_ATTR_IDN_TOO_LOW_TEMP;
+
+	err = ufshcd_query_attr(hba,
+			UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, 0, 0, &val);
+	if (err) {
+		dev_err(hba->dev,
+		"Failed to get device too %s temperature boundary\n",
+		trip == UFS_THERM_HIGH_TEMP ? "high" : "low");
+		goto out;
+	}
+
+	if (val < 1 || val > 250) {
+		dev_err(hba->dev, "out of device temperature boundary\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	*boundary = attr2milicelcius(val);
+
+out:
+	return err;
+}
+
+static int ufs_thermal_set_trip(struct ufs_hba *hba, int trip)
+{
+	int temp;
+	int err = 0;
+
+	err = ufs_thermal_get_boundary(hba, trip, &temp);
+	if (err)
+		return err;
+
+	thermal.trip[trip] = temp;
+
+	return err;
+
+}
+
 void ufs_thermal_exception_event_handler(struct ufs_hba *hba,
 		u32 exception_status)
 {
@@ -46,17 +139,12 @@ void ufs_thermal_exception_event_handler(struct ufs_hba *hba,
 	}
 }
 
-static  struct thermal_zone_device_ops ufs_thermal_ops = {
-	.get_temp = NULL,
-	.get_trip_temp = NULL,
-	.get_trip_type = NULL,
-};
-
 static int ufs_thermal_enable_ee(struct ufs_hba *hba)
 {
 	return ufshcd_enable_ee(hba, MASK_EE_URGENT_TEMP);
 }
 
+
 static void ufs_thermal_zone_unregister(struct ufs_hba *hba)
 {
 	if (thermal.zone) {
@@ -66,7 +154,13 @@ static void ufs_thermal_zone_unregister(struct ufs_hba *hba)
 	}
 }
 
-static int ufs_thermal_register(struct ufs_hba *hba)
+static  struct thermal_zone_device_ops ufs_thermal_ops = {
+	.get_temp = ufs_thermal_get_temp,
+	.get_trip_temp = ufs_thermal_get_trip_temp,
+	.get_trip_type = ufs_thermal_get_trip_type,
+};
+
+static int ufs_thermal_register(struct ufs_hba *hba, u8 ufs_features)
 {
 	int err = 0;
 	char name[THERMAL_NAME_LENGTH] = {};
@@ -74,6 +168,18 @@ static int ufs_thermal_register(struct ufs_hba *hba)
 	snprintf(name, THERMAL_NAME_LENGTH, "ufs_storage_%d",
 			hba->host->host_no);
 
+	if (ufs_features & UFS_FEATURE_HTEMP) {
+		err = ufs_thermal_set_trip(hba, UFS_THERM_HIGH_TEMP);
+		if (err)
+			goto out;
+	}
+
+	if (ufs_features & UFS_FEATURE_LTEMP) {
+		err = ufs_thermal_set_trip(hba, UFS_THERM_LOW_TEMP);
+		if (err)
+			goto out;
+	}
+
 	thermal.zone = thermal_zone_device_register(name, UFS_THERM_MAX_TRIPS,
 			0, hba, &ufs_thermal_ops, NULL, 0, 0);
 	if (IS_ERR(thermal.zone)) {
@@ -122,7 +228,7 @@ int ufs_thermal_probe(struct ufs_hba *hba)
 	if (!ufs_features)
 		goto out;
 
-	err = ufs_thermal_register(hba);
+	err = ufs_thermal_register(hba, ufs_features);
 	if (err)
 		goto out;
 
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 8fc0b0c..9f8224b 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -167,6 +167,9 @@ enum attr_idn {
 	QUERY_ATTR_IDN_FFU_STATUS		= 0x14,
 	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
 	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
+	QUERY_ATTR_IDN_ROUGH_TEMP		= 0x18,
+	QUERY_ATTR_IDN_TOO_HIGH_TEMP		= 0x19,
+	QUERY_ATTR_IDN_TOO_LOW_TEMP		= 0x1A,
 };
 
 /* Descriptor idn for Query requests */
-- 
1.9.1

