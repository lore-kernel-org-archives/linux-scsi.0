Received: from cvsmtppost18.nm.naver.com (cvsmtppost18.nm.naver.com [114.111.35.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B0B4F4746
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484701; cv=none; b=jfndz4P4UG3qc1eHsC2VUDho50lzsXcQC1w7gs6PUmv4corDKmpEJfq9LCeG8x0vOKqiNe4VQschR4adelwe8VowdZC1D3rV4QbP7C0yeYMoGRqM3Brgp+1d1TIqsEhrVfITlSoS2Rcb/72Pbpfy1qKWFgqL5LppuSEV9g0oJxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484701; c=relaxed/simple;
	bh=LCz+FnJ0aSqGVuP2eLKj82yEwf1gq2ITe2ISeVjVxXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aX8ciEPL8ZrDhZXzvvMC7WkhjLrn+sJG4et4gAGbbFYIllnrPi8Z7LGk7jyCEfxXBDy27eHPWye9KjFqYDIBs7MkXBq3NiBv8SoPgc5pRS2C3DX3/PETxk3Taeg5ikc0rsBH9eUSydVy1A1q65/VmV5ol53QpzFxN8XjDzdKmmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=kBQjvMqw; arc=none smtp.client-ip=114.111.35.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="kBQjvMqw"
Received: from cvsendbo016.nm ([10.112.24.39])
  by cvsmtppost18.nm.naver.com with ESMTP id vMJmTYhoRdm8xtynlolPjg
  for <linux-scsi@vger.kernel.org>;
  Thu, 08 Oct 2026 18:38:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791484690; bh=LCz+FnJ0aSqGVuP2eLKj82yEwf1gq2ITe2ISeVjVxXs=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=kBQjvMqwnHx9qIjD2RyHc2T9KQtq34HXFvE0EA34/LXQxS/+mZD8xm8NjvrXKNL5I
	 sFHTGradHXBgE0MI9EStAiUZ8uea8W7L0wMOC4bIrRLEEG+KwwUi1joC/N9ZKyPi80
	 9YYBJWtjREap6TSM1uUuKdIllhkVGDS5PGEo6bEgeTSe+sySWM4RCjT9zSwAgQ+Ik0
	 0aYEKerrLDkyTTVLZe5vQyZa9o8aTDOHv9Ol5knBGxpSPWTEXV7klgUGAenTvJdpoq
	 E5mwR4QF8LUsLaQ1c6Q5NDBaTQBFCBtrv2H1/F/ZC/2xn2rHVRjvmto0hPq/3hflgW
	 NMU0Wwx3tfe/A==
X-Session-ID: NrWKyFuFS3mM1Uc0OkcW1g
X-Works-Send-Opt: OPFwpzGdjHmdKHFOMr39Ko3YKBmqjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: sdb9FAulFqJZ+HmlaAUZ+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by mvnsmtp03.nm.naver.com with ESMTP id NrWKyFuFS3mM1Uc0OkcW1g
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Thu, 08 Oct 2026 18:38:09 -0000
From: tjdqudcks0424@naver.com
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Sung Byeongchan <tjdqudcks0424@naver.com>
Subject: [PATCH] scsi: target: iscsi: reject ImmediateData on non-WRITE commands
Date: Fri,  9 Oct 2026 03:38:03 +0900
Message-ID: <20261008183804.10356-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sung Byeongchan <tjdqudcks0424@naver.com>

ImmediateData is write data and is not valid on a non-WRITE SCSI Command.
The target nevertheless accepts it on READ commands.  An authenticated
remote initiator can make one se_cmd execute twice or make DataDigest
calculation walk beyond the command's SG list, crashing the target kernel.

Reject non-WRITE commands carrying ImmediateData.  A setup rejection is
queued before the data segment has been consumed, so also fail the
connection when that rejected command advertises a payload.  This selects
the bounded ERL=0 close policy and prevents payload, padding, digest, or
follow-up bytes from being interpreted as a new BHS.

The two parent crashes reproduced twice each in a local production LIO TCP
fixture.  A reject-only repair desynchronized the stream in three fresh
boots.  The final patch closed all ten rejected variants in three fresh
boots without unknown-opcode parsing, while normal READ without
ImmediateData and normal WRITE with ImmediateData passed in every boot.
The touched source is unchanged at
0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch applies and
builds cleanly.

The demonstrated impact is authenticated remote target-kernel denial of
service.  No controlled write, information disclosure, RCE, or LPE was
demonstrated.  The source reproducer and complete logs are available on
request and are not included in this public report.

OpenAI Codex assisted source inspection, test design, patch drafting, and
evidence organization.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
 drivers/target/iscsi/iscsi_target.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e75..a80bed0999ba3 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1098,6 +1098,12 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 					     ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
+	if (payload_length && !(hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
+		pr_err("Immediate data for non-WRITE command\n");
+		return iscsit_add_reject_cmd(cmd,
+					     ISCSI_REASON_PROTOCOL_ERROR, buf);
+	}
+
 	cdb = hdr->cdb;
 
 	if (hdr->hlength) {
@@ -1384,8 +1390,16 @@ iscsit_handle_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	bool dump_payload = false;
 
 	rc = iscsit_setup_scsi_cmd(conn, cmd, buf);
-	if (rc < 0)
+	if (rc < 0) {
+		/*
+		 * setup may queue a Reject before the data segment has been
+		 * consumed.  Do not let the receive loop treat those bytes as a
+		 * new BHS.  Closing is the bounded ERL=0 recovery policy.
+		 */
+		if (ntoh24(hdr->dlength))
+			return -1;
 		return 0;
+	}
 	/*
 	 * Allocation iovecs needed for struct socket operations for
 	 * traditional iSCSI block I/O.
-- 
2.43.0

