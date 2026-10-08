Received: from mvsmtppost24.nm.naver.com (mvsmtppost24.nm.naver.com [61.247.196.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBD03BE646
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 06:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.247.196.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440047; cv=none; b=KAV54GLRid+DgQz8w4A3p8o95ILzzRWJkzIMqnQeDtA+VcD9YeUP8DypHA31hJNZyoeY3GGO1Mz/7GpDwcbysHWmMhBvSj0PIZVlZYXuocSTjj8/9gG1sfZ+h7d91A4kynYWRms6/lKrm8VcHeWW0YluRAKgmTPpPUhJkZ7Nopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440047; c=relaxed/simple;
	bh=I9TvN0KB172pufzQF2Ry8vRfl8pTDPCguZMkc/k23uA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BJ99hbllB5gaUqFmjpeiF7OwY31BqnltyzweTHI4HdnKhpEVodhjb5jDvZjwggacjkq13Fq0m+nDna2dw7D2X61Xb6caKkIOp2iTGWE/sYR1AnzR9q26pEPBGTu93MUf7n0mwQVCcO2tJ2S5YwFQSZ/Aw885hzzLQBF/TUA2H1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=jn+iOttp; arc=none smtp.client-ip=61.247.196.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="jn+iOttp"
Received: from cvsendbo015.nm ([10.112.22.33])
  by mvsmtppost24.nm.naver.com with ESMTP id qARPpMCmR+ejBKqOGvnH0Q
  for <linux-scsi@vger.kernel.org>;
  Thu, 08 Oct 2026 06:03:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791439436; bh=I9TvN0KB172pufzQF2Ry8vRfl8pTDPCguZMkc/k23uA=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=jn+iOttplyhR1xzoRmZjXFhvu2CM8My2yDGZnEhCAUCJY+e69N0cSmdRnY7noTXrc
	 465tKftYPsyB/tSLZg5Qkd9Hay0NI0KJ5sLQ9SCQ3i23vpCwJeUe5n0duhUz/vvru/
	 cQ7bOfEm0nFqMC4t57KgUY48tUfI7+A1czjC/gAqkneiv/UHfA5tbFxhtH4tjWAj32
	 N30LZxNMV6ge6n9c3pp4YpHsUfPHgZQrNm/i0gcK9SJjatWbIf4Txj8f8xLLeq04tI
	 H2H8PO3CWT1+2IbqIJb/DBhXRZ0YMMKuSC/RfE0rvzMhiDQqYYEcYlOgQbN7TZerAY
	 tJwnNm2w/dx1w==
X-Session-ID: o4sOYSJCR-aB1mOCXmfdFg
X-Works-Send-Opt: OlewpzGdjHmdKHFOMr39Ko3YKHmqjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: rZYmFAulFqJZ+Hm9KqgX+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp011.nm.naver.com with ESMTP id o4sOYSJCR-aB1mOCXmfdFg
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Thu, 08 Oct 2026 06:03:55 -0000
From: sung byeongchan <tjdqudcks0424@naver.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] target: iscsi: reject ImmediateData on non-WRITE commands
Date: Thu,  8 Oct 2026 15:03:47 +0900
Message-ID: <20261008060347.175260-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ImmediateData carries unsolicited write payload and is not valid for a
command without the W bit.  iscsit_setup_scsi_cmd() nevertheless accepts
it on READ commands and passes the payload into write-data handling.

This permits two independently reproduced failure modes.  If the immediate
data is larger than the READ CDB-derived data length while DataDigest is
enabled, iscsit_crc_sglist() walks beyond the command scatterlist and
dereferences a NULL entry.  If the expected transfer and immediate-data
lengths are equal, the receive path can execute the command before CmdSN
sequencing and the sequencing path can execute the same se_cmd again after
its first completion.

Reject ImmediateData on non-WRITE commands before parsing the CDB or
allocating backend state.

Both failures reproduced twice on the originally tested baseline with an
authenticated CHAP-SHA256 initiator.  The fixed kernel rejected both
inputs twice.  A READ without ImmediateData and a WRITE carrying
ImmediateData continued to complete normally.

The demonstrated impact is authenticated remote denial of service of the
target kernel.  No controlled write, disclosure, RCE, or LPE was
demonstrated.  The source reproducer is available privately on request and
is intentionally omitted from this public submission.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e75..b8e26e00cd462 100644
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
-- 
2.43.0

