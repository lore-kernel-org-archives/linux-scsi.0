Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CE0C64E67
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLHLDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLHLCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:43 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD083244
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 03:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497271; x=1702033271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C0o70dzvp5L1imY2JoWlmSXhdbkUb91EcTTvwd5gWt8=;
  b=JkfhF1/FQwQRlH0HlYduRb2uCXCQSyEaCO/UHJvZEcKmFE3dQ4YIFDBI
   ly2o0owNNfjGQrixUmz9HHLL2ljOI4ASIHwzdfaUUS+GfecYrLKZ9CoY0
   xG+4J082gElXlGkuxBtCMUr2PMncphSgxSLRq9qyFshL3rphj1Sq3W+ga
   Jeh1Eb5eyrfvLXGX+ZFhptyKorhwXE5xtcUeVzDCk3yTBASS8lwyCUlRu
   Zb+6zEnCZiMWblIUtPUJvQ4xa7pkZiOsU6fSl1inkeneS3bdByjj2K8cP
   Vqki4ZcUpUudzDt1wRPKCYVROQkuCufd2a0MaEbZqlR10cgGGucDbpceh
   g==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333397"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:11 +0800
IronPort-SDR: OVNPAN37wyWaRkcYdC+Bv2ONuSGM1Ytf90hrRzsHdpp2kkSnEAKy2Xlh45hZeY89c90Lf3CcTi
 ZRP2NeR4Iq3wmNu5AafCDXEvHabDc7A5W20A4n+MapDVIo4bexEZX+DVzvCnF5s1S008JYdEka
 7uiKMFNVKL7TeyxsycJea4Xwc9xNNxV0hZ+AN5vswlck8HI53mSeXZ0v0f3hFeuylgzWt845MB
 Dl4kAeI2qAweYoBbo27YCovxFsfMciBuJMIBin51axzWYsQRyF0I12nBKpBh//RD4+I66m6vcf
 jxI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:56 -0800
IronPort-SDR: ZnB4waG20WGS5oaK5nvTNxME/Vir9ZqDWcajd9GAq7LxO94zQiUIY0F1Faezw2vazownDC+lhE
 miD+Uz/wywaTixHTGrC3wMIosiDCNpN3Elh+xB2GOH35lvWn8lkD+uO18pxOCUVTasWZnEQfFk
 aWlcl5Oz3iR8qWNnhkPfXmzq7wa97SE0yWnGNUKmBhbHY6HTo3rDS4xT9wixhLeQ+KCSztJ3UX
 mQj6uU02gABkJHYe5XTm9MDpuf79K62FCIQ8u77QGRjYV2nTIi3mXekqGW2zr2l850GIcBOsG+
 j1g=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:10 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 12/25] scsi: support retrieving sub-pages of mode pages
Date:   Thu,  8 Dec 2022 11:59:28 +0100
Message-Id: <20221208105947.2399894-13-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Allow scsi_mode_sense() to retrieve sub-pages of mode pages by adding
the subpage argument. Change all the current caller sites to specify
the subpage 0.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/scsi_lib.c           | 4 +++-
 drivers/scsi/scsi_transport_sas.c | 2 +-
 drivers/scsi/sd.c                 | 9 ++++-----
 drivers/scsi/sr.c                 | 2 +-
 include/scsi/scsi_device.h        | 5 +++--
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d243ebc5ad54..e64fd8f495d7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2142,6 +2142,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	@sdev:	SCSI device to be queried
  *	@dbd:	set to prevent mode sense from returning block descriptors
  *	@modepage: mode page being requested
+ *	@subpage: sub-page of the mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
  *	@len:	length of request buffer.
  *	@timeout: command timeout
@@ -2153,7 +2154,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	Returns zero if successful, or a negative error number on failure
  */
 int
-scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 		  unsigned char *buffer, int len, int timeout, int retries,
 		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
 {
@@ -2169,6 +2170,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	dbd = sdev->set_dbd_for_ms ? 8 : dbd;
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
+	cmd[3] = subpage;
 
 	/* caller might not be interested in sense, but we need it */
 	if (!sshdr)
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 74b99f2b0b74..d704c484a251 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1245,7 +1245,7 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
 	if (!buffer)
 		return -ENOMEM;
 
-	error = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
+	error = scsi_mode_sense(sdev, 1, 0x19, 0, buffer, BUF_SIZE, 30*HZ, 3,
 				&mode_data, NULL);
 
 	if (error)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..77259716ca75 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -184,7 +184,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		return count;
 	}
 
-	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
+	if (scsi_mode_sense(sdp, 0x08, 8, 0, buffer, sizeof(buffer), SD_TIMEOUT,
 			    sdkp->max_retries, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
@@ -2596,9 +2596,8 @@ sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 	if (sdkp->device->use_10_for_ms && len < 8)
 		len = 8;
 
-	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
-			       SD_TIMEOUT, sdkp->max_retries, data,
-			       sshdr);
+	return scsi_mode_sense(sdkp->device, dbd, modepage, 0, buffer, len,
+			       SD_TIMEOUT, sdkp->max_retries, data, sshdr);
 }
 
 /*
@@ -2855,7 +2854,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->protection_type == 0)
 		return;
 
-	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+	res = scsi_mode_sense(sdp, 1, 0x0a, 0, buffer, 36, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
 
 	if (res < 0 || !data.header_length ||
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..d2bbde7172ac 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -827,7 +827,7 @@ static int get_capabilities(struct scsi_cd *cd)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
+	rc = scsi_mode_sense(cd->device, 0, 0x2a, 0, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
 	if (rc < 0 || data.length > ms_len ||
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3642b8e3928b..a499cdac2ce8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -420,8 +420,9 @@ extern int scsi_track_queue_full(struct scsi_device *, int);
 extern int scsi_set_medium_removal(struct scsi_device *, char);
 
 extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
-			   unsigned char *buffer, int len, int timeout,
-			   int retries, struct scsi_mode_data *data,
+			   int subpage, unsigned char *buffer, int len,
+			   int timeout, int retries,
+			   struct scsi_mode_data *data,
 			   struct scsi_sense_hdr *);
 extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    unsigned char *buffer, int len, int timeout,
-- 
2.38.1

