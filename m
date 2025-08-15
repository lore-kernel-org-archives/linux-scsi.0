Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2B2405FD
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292548; cv=none; b=TcGWSLsiqCYRVbTHXdwa/kz4iGBxre+dyrS7gcCp/9t4qCaipv29//58l62OA15JEiJjBPKp8TMfwKzoZyM/IhCNIqTT5a89rLNvMbena8wsHl25VZ78NcAUk1FwzeCKbuFDqM5a8PVD5yJFlDUgVekLcVl6DjfQajD3lwDcywM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292548; c=relaxed/simple;
	bh=dwBwSm78Va9WXRETOZhayCxHsxgMz93bjn5BUx5839c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX8hh2KMVokNWJ+bEyCLpbW4uK8mJ1aK87eNpz7mV73AFz+OMyjiAsUXIZIaie6YFKNHbSk4cRQjNGO7OKAKVoioWV3K/FqWQyptj4QL+AoDibK+A+ujg8gPltyHM/vTLAUJIzwn8ggviHKuwvahpxZDK/WLrmdjQWdx8mPxJO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TvW4Oid2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TvW4Oid2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=82UryjMgImZCV8v0PMIvZRq9pjyaY5Ce8+rPK0PEh/w=;
	b=TvW4Oid2dij4Cv3PwV3kPDFF5ecmq6Kwuj2hmCl/L1emVQDbz3usEgCf3898TNIr8ZejUa
	5tLhYPqZxqsbeJbZ7ZT6IC69XKgnImeaM+XFAzawYay471sXVzO8gkjS/BV9MjhCIRcFSo
	6jl4PHR7AnRW2Pj+p4R4jmSudOMUvTI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-lhH-q124PRuz2PEzzB48sw-1; Fri,
 15 Aug 2025 17:15:39 -0400
X-MC-Unique: lhH-q124PRuz2PEzzB48sw-1
X-Mimecast-MFC-AGG-ID: lhH-q124PRuz2PEzzB48sw_1755292538
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60987180048E;
	Fri, 15 Aug 2025 21:15:38 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08E7519A4C9C;
	Fri, 15 Aug 2025 21:15:36 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 6/8] scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16) returning no data
Date: Fri, 15 Aug 2025 17:15:23 -0400
Message-ID: <20250815211525.1524254-7-emilne@redhat.com>
In-Reply-To: <20250815211525.1524254-1-emilne@redhat.com>
References: <20250815211525.1524254-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
and can extract invalid (e.g. zero) data when a malfunctioning device does
not actually transfer any data, but returnes a good status otherwise.
Check for this and retry, and log a message and return -EINVAL if we can't
get the capacity information.

We encountered a device that did this once but returned good data afterwards.

See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 61 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index acd79e9a0d82..6066f5c92c74 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2638,6 +2638,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		[13] = RC16_LEN,
 	};
 	struct scsi_sense_hdr sshdr;
+	int count, resid;
 	struct scsi_failure failure_defs[] = {
 		/*
 		 * Do not retry Invalid Command Operation Code or Invalid
@@ -2688,6 +2689,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.resid = &resid,
 		.failures = &failures,
 	};
 	int sense_valid = 0;
@@ -2699,11 +2701,23 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
+		if (the_result == 0 && resid == RC16_LEN) {
+			/*
+			 * if nothing was transferred, we try
+			 * again. It's a workaround for a broken
+			 * device.
+			 */
+			continue;
+		}
+		break;
+	}
 
 	if (the_result > 0) {
 		if (media_not_present(sdkp, &sshdr))
@@ -2727,6 +2741,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
 
@@ -2759,11 +2779,17 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
 		{
@@ -2798,17 +2824,30 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.resid = &resid,
 		.failures = &failures,
 	};
 	int the_result;
 	sector_t lba;
 	unsigned sector_size;
 
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
+		if (the_result == 0 && resid == RC10_LEN) {
+			/*
+			 * if nothing was transferred, we try
+			 * again. It's a workaround for a broken
+			 * device.
+			 */
+			continue;
+		}
+		break;
+	}
 
 	if (the_result > 0) {
 		if (media_not_present(sdkp, &sshdr))
@@ -2821,6 +2860,12 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
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

