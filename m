Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB6DC61DB3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbjALOIM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjALOGm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:06:42 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC19559C2;
        Thu, 12 Jan 2023 06:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532274; x=1705068274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QNXbTQtYuwTypo6ZVaz9AMEzjAItPRnZYKMlV+efXS4=;
  b=fbB/mJgNk+yNprM2DQesSrffUskfX5z7ptxtNQHNDxPfs7kzwA9JEAxK
   DljgNKEaJHRJGBLnD4JVTlhktkFUIsmeLKiTqdBnfmh4fRLZlPiItHuCB
   FxnaKJxBFVzS95w0fp0SRdBCwLBwNAUwfDaIY2R86s01QRpdjclVuN0ld
   H73OOZb9kkiM+7Wo2WfXqQNNuLchkYfl8DmnmSMmZN+BzTmLRBXSvOIXI
   O3+nbzpvUgRoxrufbpMIe0AR5AGpxNUlKaN8KXS2d/qabHXTt32yAWIp4
   TuCUPUKOeF5BhGsBvWJiuxj/W6MdR7TIO3mDazYWIj9AKiB2nYufXCKdk
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632678"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:33 +0800
IronPort-SDR: iOqDsIJ+tKWBqIol5n3iI9mPAmuEeF40/fyyLIKTeKBfYa/kj26zbnmgUwEyepMMNiq3UDgsXj
 vYG5QdBw+ztgTdQgAF4/NB3bY3CanNM8nkZMiSsAqqF/ky2gp6xuiwoTeLfVxdETtC2UUslHhB
 jEPqC61yQCfmKZgsJGtxI67AShhfVGJY2ANQWiUG3n6fkwQ2UFx38P5SYzGTEIB4rzaI6hsutK
 njwHxnC/cZh9IKrrW3uJehZIlHgaxOfnxxYqJZ6q5E4q8KY7TJlBwdsrpth88BrlEdVXFoxPMO
 fSo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:36 -0800
IronPort-SDR: OGMRGmlaNGcpfAB8WqD99uf0554Os8AK/xatQH8t8tF5MwoYqdVz4ONfqpGkuLOhMYo0UfiGGv
 QkDFf13zDyN3gehxzjNSjcnTbQB6pQsV9ly/FZb7qP1BjDkZXq74FI0As2AzHTwBjGJ53RQ46u
 ldSlmPEboF43TtBTmwKRMGmEx/2YYlohHL9KTicijn0T2F2JXpSmjxyqoWSSz/Esm65goakPk+
 s2cGGH6VhNc5yUa+3YQWufq8J4pDsvaWptyjkzIVR+R9NlDCrxg6QbTkH9Wcb0l1DZIUMaMcqq
 M44=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:31 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 05/18] scsi: support retrieving sub-pages of mode pages
Date:   Thu, 12 Jan 2023 15:03:54 +0100
Message-Id: <20230112140412.667308-6-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
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
---
 drivers/scsi/scsi_lib.c           | 4 +++-
 drivers/scsi/scsi_transport_sas.c | 2 +-
 drivers/scsi/sd.c                 | 9 ++++-----
 drivers/scsi/sr.c                 | 2 +-
 include/scsi/scsi_device.h        | 5 +++--
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6630a36b873e..79cece5eff5d 100644
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
2.39.0

