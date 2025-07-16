Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD921D5B8
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752691729; cv=none; b=sRkVP9cgOM+3t30SU7LBrAucCsXDj3oKbuXOwfnUe5n/h87IiHZvgWl/UfqyCi3I4KfA69gdDsFV4GWYIL6Wd/mjElZU4riCORrqJdzFpkgWtYYlMyN4l2Ebcke3rPoD5m7cdUGQ0weBYf9RqKdjl62nRf0nkh4J3dajA4D7FhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752691729; c=relaxed/simple;
	bh=nItQj6rE1YH8V/GcxTjznsiofLMVNr1EUn+L8g6TuN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX50lao3ONoj2bXsM+Br5a+Z/fQeVUbFCletNG0hmcOC6fBaMS5oFTQb3AaAGThFbBc3f/Of2c+YjoTa7fSO/wK+UAnSUo1a495ZsjoDdlPH9Ujgk1czX11RxKFiRADjD3j5r6jSEGmQ9CN70cK9VOe9Sk5VPUscn7MUw2A9qgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gvx6uSrX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gvx6uSrX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752691724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLVCzoaStKGeTMMQMM3ZzEifcOcu0QkyqkLF0DQSkBY=;
	b=Gvx6uSrX5qIJtp7DbJbSriIaMF8qlqcXOLlQkwdjBh4YnlsqbNL6BkSbTB6RBKMsRU4mS+
	i4/SRJ8dTuwiV5PsyG7qFBvvL8uoOoclFc9ZwoCj/juK7ApNa/R0KuJlik5lSdALmfcydl
	/JeSmNyCyWY5JOV0bSa3KNRx8rL7XLA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-539-E5I46SXdOje2IyQnFYorew-1; Wed,
 16 Jul 2025 14:48:41 -0400
X-MC-Unique: E5I46SXdOje2IyQnFYorew-1
X-Mimecast-MFC-AGG-ID: E5I46SXdOje2IyQnFYorew_1752691720
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A51251800447;
	Wed, 16 Jul 2025 18:48:40 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.88.244])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC2E918002AF;
	Wed, 16 Jul 2025 18:48:39 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com
Subject: [PATCH 4/5] scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16) returning no data
Date: Wed, 16 Jul 2025 14:48:32 -0400
Message-ID: <20250716184833.67055-5-emilne@redhat.com>
In-Reply-To: <20250716184833.67055-1-emilne@redhat.com>
References: <20250716184833.67055-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
and can extract invalid (e.g. zero) data when a malfunctioning device does
not actually transfer any data, but returnes a good status otherwise.
Check for this and retry, and log a message and return -EINVAL if we can't
get the capacity information.

We encountered a device that did this once but returned good data afterwards.

See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 69 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f8bc5f6a6511..c8f2efe3b767 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2633,6 +2633,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		[13] = RC16_LEN,
 	};
 	struct scsi_sense_hdr sshdr;
+	int count, resid;
 	int sense_valid = 0;
 	int the_result;
 	unsigned int alignment;
@@ -2683,17 +2684,31 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.resid = &resid,
 		.failures = &failures,
 	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	memset(buffer, 0, RC16_LEN);
+	for (count = 0; count < 3; ++count) {
+		memset(buffer, 0, RC16_LEN);
 
-	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
-				      &exec_args);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+					      buffer, RC16_LEN, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
+
+		if (the_result == 0) {
+			/*
+			 * if nothing was transferred, we try
+			 * again. It's a workaround for a broken
+			 * device.
+			 */
+			if (resid == RC16_LEN)
+				continue;
+		}
+		break;
+	}
 
 	if (the_result > 0) {
 		if (media_not_present(sdkp, &sshdr))
@@ -2717,6 +2732,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EINVAL;
 	}
 
+	if (resid == RC16_LEN) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Read Capacity(16) returned good status but no data");
+		return -EINVAL;
+	}
+
 	sector_size = get_unaligned_be32(&buffer[8]);
 	lba = get_unaligned_be64(&buffer[0]);
 
@@ -2749,11 +2770,20 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	return sector_size;
 }
 
+#define RC10_LEN 8
+#if RC10_LEN > SD_BUF_SIZE
+#error RC10_LEN must not be more than SD_BUF_SIZE
+#endif
+
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
 	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	int count, resid;
+	int the_result;
+	sector_t lba;
+	unsigned sector_size;
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
 		{
@@ -2785,17 +2815,28 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.resid = &resid,
 		.failures = &failures,
 	};
-	int the_result;
-	sector_t lba;
-	unsigned sector_size;
 
-	memset(buffer, 0, 8);
+	for (count = 0; count < 3; ++count) {
+		memset(buffer, 0, RC10_LEN);
 
-	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-				      8, SD_TIMEOUT, sdkp->max_retries,
-				      &exec_args);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+					      buffer, RC10_LEN, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
+
+		if (the_result == 0) {
+			/*
+			 * if nothing was transferred, we try
+			 * again. It's a workaround for a broken
+			 * device.
+			 */
+			if (resid == RC10_LEN)
+				continue;
+		}
+		break;
+	}
 
 	if (the_result > 0) {
 		if (media_not_present(sdkp, &sshdr))
@@ -2808,6 +2849,12 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EINVAL;
 	}
 
+	if (resid == RC10_LEN) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Read Capacity(10) returned good status but no data");
+		return -EINVAL;
+	}
+
 	sector_size = get_unaligned_be32(&buffer[4]);
 	lba = get_unaligned_be32(&buffer[0]);
 
-- 
2.47.1

