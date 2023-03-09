Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87946C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjCIV43 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjCIVzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:54 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE23EFF6B;
        Thu,  9 Mar 2023 13:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398943; x=1709934943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6a26TpaTO3Swq0OhnR7pZAw5dPnmyLg49YT96Gy6n6I=;
  b=pbun/5UQtKLsFxfaaKqoZd6XehKf6IIkIhjmPhXFNrgSPv3HXXpBd+QZ
   sdF7qbPrGvTJ2AnR5N2oVtmPw6G4dp3HQBYkOQbgx5SnxMtrj3O/0AUte
   jKimdcjkTViwOrFcsrxdYKmio0fB9waXX2QWPm4skjumTiRejNzeYZis3
   jVqhWS1wiCOs7zct0luFBWrzLF+2OYI8IBfUI3UC4VgVe4L8YEH2FKZFO
   BOlwLLC9mDmTI5PD54Z0fW9mMSWkaIUJN2js4h/8YFL924T+N3UQHNAVR
   TqWqakIDZ3eOCh6qbGSjtAfdj/FCn/8kn4CJonnwxfWh2mcOqfx2V5Rtz
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225270969"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:43 +0800
IronPort-SDR: ZEBBXIvF49USCdYEyU5DA419rWJmiqvFfKvwpKEhPofHaD+P0yxqJ3KKr0MqjbWbeDnRIjySd1
 TPw1B/Jc/a5hdvgg27o/B2ttF1RmzA9iJs7xEjljkgiMdsA+7iJgb/3ZgbdrKeKmrmUVSHhqK2
 3k9lvVeY7n5B58xBQnxJ0CqU8YYnHytWKRIL0B6OWPC0tWHQqt5m11BQxve6ICLQ2K4wB4xvp/
 o8nBoldhcFHB1A7vNjweCt2pzsd+pwPAhUkYiBHmKRbeVjGU8nJveb17V1JViwHW+KY3CZ40u1
 o18=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:36 -0800
IronPort-SDR: DFY4a4L9YH9r1ynzWYWH0LcA1ux/NLj9Q/32xmzM6ro56tknivMbfZx9rOJF4M1jcgnxrYPTPQ
 yO4d8Z1Tdud5UgyNIFriUXypgdVMUq4M6DJT0ek2fsYoqK4esu/PfWNMEneYOp0rMtFkP6HQ3b
 ts5AF5fXyVFE2DViJy8QDaeVOL50keEaiCN58e1LNz5Qc22+WgGS/1SNImj8UrLGCtDB77HN9o
 lrMNSvtVM1h225xjVR2BsMhlorX+E4rCzWLh+A97tc1leTm+8xWkyaCjBLsgXqiXqMXl6a3qDn
 cac=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:41 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 06/19] scsi: support retrieving sub-pages of mode pages
Date:   Thu,  9 Mar 2023 22:54:58 +0100
Message-Id: <20230309215516.3800571-7-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
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
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c           | 4 +++-
 drivers/scsi/scsi_transport_sas.c | 2 +-
 drivers/scsi/sd.c                 | 9 ++++-----
 drivers/scsi/sr.c                 | 2 +-
 include/scsi/scsi_device.h        | 8 ++++----
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fac9c31161d2..633c4e8af830 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2144,6 +2144,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	@sdev:	SCSI device to be queried
  *	@dbd:	set to prevent mode sense from returning block descriptors
  *	@modepage: mode page being requested
+ *	@subpage: sub-page of the mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
  *	@len:	length of request buffer.
  *	@timeout: command timeout
@@ -2155,7 +2156,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	Returns zero if successful, or a negative error number on failure
  */
 int
-scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 		  unsigned char *buffer, int len, int timeout, int retries,
 		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
 {
@@ -2175,6 +2176,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	dbd = sdev->set_dbd_for_ms ? 8 : dbd;
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
+	cmd[3] = subpage;
 
 	sshdr = exec_args.sshdr;
 
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
index 4f28dd617eca..8e856a7a6338 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -183,7 +183,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		return count;
 	}
 
-	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
+	if (scsi_mode_sense(sdp, 0x08, 8, 0, buffer, sizeof(buffer), SD_TIMEOUT,
 			    sdkp->max_retries, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
@@ -2610,9 +2610,8 @@ sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 	if (sdkp->device->use_10_for_ms && len < 8)
 		len = 8;
 
-	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
-			       SD_TIMEOUT, sdkp->max_retries, data,
-			       sshdr);
+	return scsi_mode_sense(sdkp->device, dbd, modepage, 0, buffer, len,
+			       SD_TIMEOUT, sdkp->max_retries, data, sshdr);
 }
 
 /*
@@ -2869,7 +2868,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->protection_type == 0)
 		return;
 
-	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+	res = scsi_mode_sense(sdp, 1, 0x0a, 0, buffer, 36, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
 
 	if (res < 0 || !data.header_length ||
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 9e51dcd30bfd..09fdb0e269d9 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -830,7 +830,7 @@ static int get_capabilities(struct scsi_cd *cd)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
+	rc = scsi_mode_sense(cd->device, 0, 0x2a, 0, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
 	if (rc < 0 || data.length > ms_len ||
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index de310f21406c..ff4ad3596fa7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -419,10 +419,10 @@ extern int scsi_track_queue_full(struct scsi_device *, int);
 
 extern int scsi_set_medium_removal(struct scsi_device *, char);
 
-extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
-			   unsigned char *buffer, int len, int timeout,
-			   int retries, struct scsi_mode_data *data,
-			   struct scsi_sense_hdr *);
+int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+		    int subpage, unsigned char *buffer, int len, int timeout,
+		    int retries, struct scsi_mode_data *data,
+		    struct scsi_sense_hdr *);
 extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    unsigned char *buffer, int len, int timeout,
 			    int retries, struct scsi_mode_data *data,
-- 
2.39.2

