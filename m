Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C69C47409
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BE6720842
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="O/hCvtqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgBBHmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 02:42:09 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6569 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgBBHmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 02:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580629329; x=1612165329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Xs9N9QZ4AbsZnN4+EE7/dkXNKRLNQj6ng9In0uQPpKc=;
  b=O/hCvtqLXrmJFdhyGPaQLZjM18AqBYuSzhPrsjPMcRQVCP3r86jBf8ew
   mtdlZAza0Z3PhA1J7LkLS6FQ2aeqWEI/YI/MLcyHe5mQl1OQmBRR0zUPK
   smQO719Ff5S/wuG0FFGDeuSESb8KqI3olwWh13/t8a0dRz0BBDchxigd/
   WXlw6CbVLvc6tTVPN1Jn4WIp1JIyErHql1oU62n+quaCiytInwcRFwmQc
   gHTuPfyNFYts4KWpUCOA05wxYWNdqLWx6iUdV1Or9n8dCFioVJnjoXPU9
   KeZb2BMMkZ+JdLMfJh8YZ7q/SGTaQz+S+/3Wm3ZjeQoJrybRArPoK8p6v
   g==;
IronPort-SDR: w7BIj56Bv4FZHtH8/dhQf/QlmCnbq7WNgqz1or7VVEo9/CNHN1D8tWD+GSDXwPCW4cR+nUJdi5
 qpzCD/F5o9I9eVjveVsP6rDWYguCioa9NehsYys8X7rfI8ykMOwQUulGZXCd4oGxDlugSo6mpx
 J9uLtGavFeZnDFuH0L7wDezprNza/PSiupAri52JUv9W1ySkeMiCN6C291z33SH4Kb3eCSLwHr
 VVzVdwgPddCWB4iGoOf7WST3kq2OSmHGZsInZM4ZfYON6Pc8hDLIn0EX3j0naggaSN3jjB2T5b
 a9U=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="130383380"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 15:42:08 +0800
IronPort-SDR: vJWlDUrlFpQNqvLrwYvMqnB9d0V/BYjVATXBsSMeWKcScODYi1Bh6RPOhFhVsUPZme+9C7Hnri
 SVSyvOaYyPPZKQyWU9HzD0hekEJmYivnM0Z0CtsG9A85mm0/1UrDCERFUBsc2FhgoAUIZZ1UTZ
 ZS6z260SDSwVNUb5tYXrXT49q0ONxebASdVonhviNdkhY00og3CfPQCVfNKjP9dUBoZrv/Uz1A
 NUX4v2r7NhPbcnvAS+0TALAksXlIolS6l/+hMwvq4pDrrIfTJ4sO+f+OwjhoxnDJTk4EXcXL2b
 CWrMJdPS9+VjcjC2JOBWeuJV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 23:35:15 -0800
IronPort-SDR: wgFSpxN3tIkuUx/+1AWBOcvRR+P8Oq9jdBbMUQ4nAwSAXU1ZmUDOxDauqRBaE6DO2w4m/TsFL4
 Ku4Z08vzgYXq/PyDET1oiCEJjRAp+knL0P4Eg/69VxQaAvn6H0XNmIMay6rvdiYMCkows6iZCk
 bqyYos1A3M6v443yYUZ+at0NjF1qra/vPYnTjM0OMfXgmo5EeqND7cne54Mc6C6mrCEF5vQH9k
 IP2eBoDHcveGmSPZpHfDaNVI9hz+MRAHBeXj/PYR6+U9RR6P6U9gM0BMNFsGG4tP0eXzMKEbQ6
 nmc=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip02.wdc.com with ESMTP; 01 Feb 2020 23:42:06 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Avi Shchislowski <avi.shchislowski@sandisk.com>,
        Uri Yanai <uri.yanai@wdc.com>
Subject: [PATCH 4/5] scsi: ufs-thermal: implement thermal file ops
Date:   Sun,  2 Feb 2020 09:41:52 +0200
Message-Id: <1580629313-20078-5-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
References: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Avi Shchislowski <avi.shchislowski@sandisk.com>

The thermal interface adds a new thermal zone device sensor under
/sys/class/thermal/ folder.

Signed-off-by: Uri Yanai <uri.yanai@wdc.com>
Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
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

