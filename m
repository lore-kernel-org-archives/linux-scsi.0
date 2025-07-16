Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534DE21D5B8
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752691722; cv=none; b=pz22LAClxyRjSlh9vzVcmE/B0jI1cG6uhUv87cxqmmURFXb+SvTWxyjqu6+4KtlCZblFgQtetQHxjaEUMQTBSQ9e8eoVNICMHT/sgsKtLmj6usbXFHKjTWwfrPArTptnmjZ3kHwZQdbdiw/FY5x9j4zEbeDKPEk4ZeSgvpOM5J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752691722; c=relaxed/simple;
	bh=PdHCu4EqpqPXVEsfYFGlRJDAqJRnYuiFAZ5z3kx2HOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLmcPwLTSEHrcmCqoZvHWLhAkoLbt4+jRzjXkj2WGMwZntZxyo7X3FiYBJ+x5GR75BbKxXj4HF+Effzjfo5ODXT3Mg0YfeamlK1ge2UR/G1ytV15X6qbLE8tmWL8IGxMauHGtAFfGUhBbt9HMsfYfDAZSSUkS1fCQMsq/fevwvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tj2APnlS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tj2APnlS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752691719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVUw3oCTbJFsFPu4wQg5a5yKkaNJ/zDgvlej0MAaC4c=;
	b=Tj2APnlSrharKSmwpe16xohJnTpdncHYM/vtRCdTXog3Z5SHg/pwv4f4TokERRDfiEQJU/
	P6wBn0d7UYWImLlCVdFpRbS7MORCKE+M17Umvik6S5zxX2EoBrFjCPQPYS/2YJoDBa7Hz0
	0R+pPISriD23uICbJTmfy7SnG/HrBzA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-ebWPzXyJNrOa-Ufbn4WbLQ-1; Wed,
 16 Jul 2025 14:48:37 -0400
X-MC-Unique: ebWPzXyJNrOa-Ufbn4WbLQ-1
X-Mimecast-MFC-AGG-ID: ebWPzXyJNrOa-Ufbn4WbLQ_1752691716
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B93F19560B2;
	Wed, 16 Jul 2025 18:48:36 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.88.244])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7CE7C18002AF;
	Wed, 16 Jul 2025 18:48:35 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com
Subject: [PATCH 1/5] scsi: sd: Have scsi-ml retry read_capacity_16 errors
Date: Wed, 16 Jul 2025 14:48:29 -0400
Message-ID: <20250716184833.67055-2-emilne@redhat.com>
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

From: Mike Christie <michael.christie@oracle.com>

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with this patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs since the block layer waits/retries for us. For possible
memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
retrying will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the main loop's retries. Each UA now gets
READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
is already 10 and is not based on anything specific like a spec or
device, so the extra 3 we got from the main loop was probably just an
accident and is not going to help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 108 ++++++++++++++++++++++++++++++----------------
 1 file changed, 71 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f6e87705b62..41b7dee5eaf1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2626,55 +2626,89 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		struct queue_limits *lim, unsigned char *buffer)
 {
-	unsigned char cmd[16];
-	struct scsi_sense_hdr sshdr;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+	static const u8 cmd[16] = {
+		[0] = SERVICE_ACTION_IN_16,
+		[1] = SAI_READ_CAPACITY_16,
+		[13] = RC16_LEN,
 	};
+	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failure_defs[] = {
+		/*
+		 * Do not retry Invalid Command Operation Code or Invalid
+		 * Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Do not retry Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Device reset might occur several times so retry a lot */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry 3 times */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = &failures,
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
-					      buffer, RC16_LEN, SD_TIMEOUT,
-					      sdkp->max_retries, &exec_args);
-		if (the_result > 0) {
-			if (media_not_present(sdkp, &sshdr))
-				return -ENODEV;
+	memset(buffer, 0, RC16_LEN);
 
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
+
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00) {
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+		}
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.47.1

