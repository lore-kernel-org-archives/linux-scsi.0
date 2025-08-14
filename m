Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741C422D4DC
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196168; cv=none; b=ULhQUx/dhxuKpICLdtVl5XP//YtaKUvnarveeYbWPX8pBNnYi8SfJ9B3TxsZg23+C5aiaeW03b6ptFLnE8xP1HJ4aBxXkJoeBcEjyj7Wv3mY1QSU8dBZ3m7YNq1pK8WU8D+soMCToke84ryzp4uRDnbaLF/P4qC4OQjW1RHPlPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196168; c=relaxed/simple;
	bh=H17JOViwZq/NgTZUTd3AqImZuChu35wlkdZHx8FeIu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1HimmxRyag3NhnpCPfFVBScFeWNpn7X6EzIzpYVyGcUkOMzmlhzW+ctqO6J/79FO7H6znh9sftGhQxPeDWyXmpxOAJJBWcGIOf9yuvweo7wvF/rwZwBj4Xu0ccy8oOVKEk2nQ1j/DSWK/D8o9J0hBk5uOAHzl21F1BBzPlBYG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nlms6gNH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nlms6gNH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYT4sobhSk1JSJsUwvABz07qSLSr99u7dCDIhezbv4k=;
	b=Nlms6gNHDDTotgEpEvmFVeEP0DP9+puAn3NqZJAxHwjCeF5AkG3cDZ0gEUxPEPkUJKiYb6
	EnMRTE+YXCoooNFsYJ7cDYHJNi3IsDIfmqScx5QHlgC6PqQTjUL+q5uWPnBZuDagUljBjc
	UMqenDAncnCFiFYYMtmhsWhfo0M/5MY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-dTYAn1w7MXiJhRLhxxEeFA-1; Thu,
 14 Aug 2025 14:29:22 -0400
X-MC-Unique: dTYAn1w7MXiJhRLhxxEeFA-1
X-Mimecast-MFC-AGG-ID: dTYAn1w7MXiJhRLhxxEeFA_1755196161
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB47E195608A;
	Thu, 14 Aug 2025 18:29:20 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A37291800282;
	Thu, 14 Aug 2025 18:29:19 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 7/9] scsi: sd: Check for and retry in case of READ_CAPCITY(10)/(16) returning no data
Date: Thu, 14 Aug 2025 14:29:05 -0400
Message-ID: <20250814182907.1501213-8-emilne@redhat.com>
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

sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
and can extract invalid (e.g. zero) data when a malfunctioning device does
not actually transfer any data, but returnes a good status otherwise.
Check for this and retry, and log a message and return -EINVAL if we can't
get the capacity information.

We encountered a device that did this once but returned good data afterwards.

See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 56 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f1ab2409ea3e..20b5eebba968 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2639,6 +2639,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		[13] = RC16_LEN,
 	};
 	struct scsi_sense_hdr sshdr;
+	int count, resid;
 	struct scsi_failure failure_defs[] = {
 		/*
 		 * Do not retry Invalid Command Operation Code or Invalid
@@ -2689,6 +2690,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.resid = &resid,
 		.failures = &failures,
 	};
 	int sense_valid = 0;
@@ -2700,11 +2702,23 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	memset(buffer, 0, buflen);
+	for (count = 0; count < 3; ++count) {
+		memset(buffer, 0, buflen);
 
-	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
-				      &exec_args);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+					      buffer, RC16_LEN, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
+
+		if ((the_result == 0) && (resid == RC16_LEN)) {
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
@@ -2728,6 +2742,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
 
@@ -2770,6 +2790,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 {
 	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	int count, resid;
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
 		{
@@ -2804,17 +2825,30 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.resid = &resid,
 		.failures = &failures,
 	};
 	int the_result;
 	sector_t lba;
 	unsigned sector_size;
 
-	memset(buffer, 0, buflen);
+	for (count = 0; count < 3; ++count) {
+		memset(buffer, 0, buflen);
 
-	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-				      8, SD_TIMEOUT, sdkp->max_retries,
-				      &exec_args);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+					      buffer, RC10_LEN, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
+
+		if ((the_result == 0) && (resid == RC16_LEN)) {
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
@@ -2827,6 +2861,12 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
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

