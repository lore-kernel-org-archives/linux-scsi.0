Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A19219303
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196161; cv=none; b=EF1jvHaH/j5RsfpDZhWKS4oPLShbq+Tmd94rYZ4PenUszVPeEtKiCCbE9VxVku6UMQDCsfi7WjBqi5vIogGhaLOcvykIBGcCQp8KTlnstCLINEyvTGTn1f0F9tNJb0I8DK9BiQXb6ZMZLdRJZgGDIHLfB6HHYlPigKZANvIhJzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196161; c=relaxed/simple;
	bh=4Kjx0tC+lyWZGfEOWYS6JOEusp5rRG+j0mQ6a3aDT24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sf4w1WmTRUCe/e0bAWLMoyBD5OpLnfJjjQGo2w5ppOxXS+gutbP2lY5OvJZvDRiiHR/QcWg8vnI4I2AV5A/kT/O8Vxr0w2fmS8YhISkt4qLGftpovnV6ay6R7ZWShPBoOEO2rCpT3uHO5/TxF2nvBnwmL0gjLwM3T73izK+95Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eSMYB2Y8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eSMYB2Y8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSU8pybX6uE6/561uEOG9NgIFIP4vrhMd5cFk2WjTt0=;
	b=eSMYB2Y8F6OiPdLxaS53J2D9Fdn6DCjvSFyaLV0+8SRfAVYLgqWEuSEmYEqZzLOmBrAp9l
	UpgEF50hB0QxxdGkipqUxP2Al0atoXHnzSlxF3gqAQKcJ1m3FdIVBYnKCkPXCO/ELqFfHQ
	oTmCSHVrFZAXKf+M0U3BE3oj2PNe7Xg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-ji2bVnPoNn2k5T8eUIwGHQ-1; Thu,
 14 Aug 2025 14:29:15 -0400
X-MC-Unique: ji2bVnPoNn2k5T8eUIwGHQ-1
X-Mimecast-MFC-AGG-ID: ji2bVnPoNn2k5T8eUIwGHQ_1755196154
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AC3A195F166;
	Thu, 14 Aug 2025 18:29:14 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 64963180044F;
	Thu, 14 Aug 2025 18:29:13 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 3/9] scsi: sd: Pass buffer length as argument to sd_read_capacity() et al.
Date: Thu, 14 Aug 2025 14:29:01 -0400
Message-ID: <20250814182907.1501213-4-emilne@redhat.com>
In-Reply-To: <20250814182907.1501213-1-emilne@redhat.com>
References: <20250814182907.1501213-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

That will make it easier to spot an inconsistent buffer size value.
Also, memset() the entire buffer rather than the 8 or 32 bytes expected
back from READ CAPACITY(10) or READ CAPACITY(16).

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e3b802b26f0e..ae8eac4b1cb2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2629,7 +2629,8 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 #define READ_CAPACITY_RETRIES_ON_RESET	10
 
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
-		struct queue_limits *lim, unsigned char *buffer)
+			    struct queue_limits *lim, unsigned char *buffer,
+			    unsigned int buflen)
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
@@ -2651,7 +2652,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[0] = SERVICE_ACTION_IN_16;
 		cmd[1] = SAI_READ_CAPACITY_16;
 		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
+		memset(buffer, 0, buflen);
 
 		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
 					      buffer, RC16_LEN, SD_TIMEOUT,
@@ -2719,8 +2720,13 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	return sector_size;
 }
 
+#define RC10_LEN 8
+#if RC10_LEN > SD_BUF_SIZE
+#error RC10_LEN must not be more than SD_BUF_SIZE
+#endif
+
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
-						unsigned char *buffer)
+			    unsigned char *buffer, unsigned int buflen)
 {
 	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
@@ -2765,7 +2771,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	sector_t lba;
 	unsigned sector_size;
 
-	memset(buffer, 0, 8);
+	memset(buffer, 0, buflen);
 
 	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
 				      8, SD_TIMEOUT, sdkp->max_retries,
@@ -2819,23 +2825,24 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
  */
 static void
 sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
-		unsigned char *buffer)
+		 unsigned char *buffer, unsigned int buflen)
 {
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
 
 	if (sd_try_rc16_first(sdp)) {
-		sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
+		sector_size = read_capacity_16(sdkp, sdp, lim, buffer, buflen);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
 		if (sector_size == -ENODEV)
 			return;
 		if (sector_size < 0)
-			sector_size = read_capacity_10(sdkp, sdp, buffer);
+			sector_size = read_capacity_10(sdkp, sdp, buffer,
+						       buflen);
 		if (sector_size < 0)
 			return;
 	} else {
-		sector_size = read_capacity_10(sdkp, sdp, buffer);
+		sector_size = read_capacity_10(sdkp, sdp, buffer, buflen);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
 		if (sector_size < 0)
@@ -2845,7 +2852,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			int old_sector_size = sector_size;
 			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
 					"Trying to use READ CAPACITY(16).\n");
-			sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
+			sector_size = read_capacity_16(sdkp, sdp, lim, buffer,
+						       buflen);
 			if (sector_size < 0) {
 				sd_printk(KERN_NOTICE, sdkp,
 					"Using 0xffffffff as device size\n");
@@ -3730,7 +3738,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, &lim, buffer);
+		sd_read_capacity(sdkp, &lim, buffer, SD_BUF_SIZE);
 		/*
 		 * Some USB/UAS devices return generic values for mode pages
 		 * until the media has been accessed. Trigger a READ operation
-- 
2.47.1

