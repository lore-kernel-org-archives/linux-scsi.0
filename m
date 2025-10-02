Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C6627B34F
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 19:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433126; cv=none; b=U0e8j9OmfMevm0rEMJYU+9EameJ54ACAgZLDuGH1W4DpwXPV6cEzX4ChUTG23WCY/Vdv/B45dOnG8Vb4BwYQcDQ0UQibZfuTSq727iv6IO3EHEiorvpQjosJnCUjkXn5UoWa/iEy70GGvAi1Dq/7EssytForyWbobIE9teYV3/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433126; c=relaxed/simple;
	bh=/GzHMxzX7xkxUP+eCMrnfTZf/mba148qI/Ado4oksX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqZUbXUZnbuqwZWLxMXdg5An7Cc9POd/rrsTyN4QYpQYG75K4ep6kGSMUoBcsXOL8dAx7UVhiEQaUnjg3GASvwWVHYV0Z8g+e/G6y1fNL4F7k1CHG97qU/tsEnaJ+4xpUi+sTLkeSsgcL8QuBg7htQsgpCAyMtLCceJhtvyMNQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dyfVmFnG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dyfVmFnG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759433122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdWkzujkuMEwipgRYycG3ttxc1yVnqyfors5+AaitVY=;
	b=dyfVmFnGIEnd1BFjJpeMfLO6BvWdmHoOmmktwxd2diKqLZqHbHozNN4EeMCE3/eCdZtoEt
	L1Tp4uwLxUi2hDZes+GPQ3wZSxwshBhqdyZADb45UszNll4CIFBsqbepMQmIAM2U+jwRxD
	7DlsIaH61+y4FrzZSUSL7Un5WZHReCw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-FLFiwjarNY2bsG7z8lIbTw-1; Thu,
 02 Oct 2025 15:25:18 -0400
X-MC-Unique: FLFiwjarNY2bsG7z8lIbTw-1
X-Mimecast-MFC-AGG-ID: FLFiwjarNY2bsG7z8lIbTw_1759433117
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91E7618002CA;
	Thu,  2 Oct 2025 19:25:17 +0000 (UTC)
Received: from emilne-na.ibmlowe.csb (unknown [10.17.17.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C16C1954126;
	Thu,  2 Oct 2025 19:25:16 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hare@suse.de
Subject: [PATCH v4 3/9] scsi: sd: Have scsi-ml retry read_capacity_16 errors
Date: Thu,  2 Oct 2025 15:25:04 -0400
Message-ID: <20251002192510.1922731-4-emilne@redhat.com>
In-Reply-To: <20251002192510.1922731-1-emilne@redhat.com>
References: <20251002192510.1922731-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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

Original patch by Mike Christie <michael.christie@oracle.com> modified
based upon review comments for an earlier version of this patch.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 107 +++++++++++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e3b802b26f0e..25561d01f972 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2631,14 +2631,66 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		struct queue_limits *lim, unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = {
+		[0] = SERVICE_ACTION_IN_16,
+		[1] = SAI_READ_CAPACITY_16,
+		[13] = RC16_LEN,
+	};
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/*
+		 * Do not retry Invalid Command Operation Code or Invalid
+		 * Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.ascq = 0x00,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.ascq = 0x00,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Do not retry Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Device reset might occur several times so retry a lot */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0x00,
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
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
@@ -2646,40 +2698,27 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
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

