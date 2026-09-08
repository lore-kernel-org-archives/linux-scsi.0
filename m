Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0389A5335B4
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 12:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788869357; cv=none; b=tcUYLJlUoda86+hpDrfoy3VbRcdImJoGmn8HBvpOpEe3lL/RwqtXvgkhfIwScKcaD0Om+C63fkeOUUtReP9GtWya93+2jw52RiV/3WAwW2++NDv+B1LB7mgzcChJhh/KKj7Nr1ws2fXF1aszDy04UK/075ZJQpUVQTKUm2jQr68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788869357; c=relaxed/simple;
	bh=0YubeKBjprJKmRRPXQYG8+ALgUfRA4X9Npm86Jfnxqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ls8hECeKQTlvUKK1Ch5aAblvqdxQQBCZAzZ5GyaliicOwr3pNDBLABkJtHbek1TC66CWH2L7l7wfPQYFq6mNUlvt+i0RwVgbEJ93+zucP0TLOQbQfM7ucnaA3x/fTpqdOJGuAyEBrWgUNzyvqiIVpBIB0GPSYGYKL96tz5TYacU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CENWYMLZ; arc=none smtp.client-ip=91.218.175.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CENWYMLZ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0YubeKBjprJKmRRPXQYG8+ALgUfRA4X9Npm86Jfnxqg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788869340; v=1; x=1789474140;
 b=CENWYMLZXMv/Wu/eFBpPeNeAos/UEWYKTRa0EHORCwHuLyNedZmkWGN9V5siIC9koSYfBYtF
 dC0TswTAR0PAryGGY6PsVkR005KyaZiXhtwubZgoQO7ZpOjtEbRBpcnCKM/01/97F4hhRN0IA6s
 MFYKPTqHhPMNqHdDQofne6Rc=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 6887c2b189903f79;
	Tue, 08 Sep 2026 12:09:00 +0000
X-Mizu-Trace-ID: 6887c2b189903f79
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	hare@suse.de,
	John Garry <john.garry@linux.dev>
Subject: [PATCH RFC] scsi: core: Clear cmd->flags for terminal queuing error
Date: Tue,  8 Sep 2026 13:08:41 +0100
Message-ID: <20260908120841.185742-1-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a request can't be queued in scsi_queue_rq(), then we error out with
a blk_status_t code. Such a scenario may be the scsi_device has its
transport offline.

For BLK_STS_RESOURCE or BLK_STS_AGAIN, the request will be requeued in the
block layer. For other errors, the block layer ends the request and so
we won't see it again (until recycled).

Normally when a request completes scmd->flags is cleared in
scsi_end_request().

However for the error scenario mentioned above, scsi_end_request() is
not called and so scmd->flags is not cleared. As such, when the request
is recycled we see the old value in scmd->flags.

Fix this issue by clearing scmd->flags in the error scenario mentioned.

Signed-off-by: John Garry <john.garry@linux.dev>
---
Setting as an RFC as I am not 100% sure that this is correct as there are
lots of paths involved. Sashiko pointed out a related issue in
https://lore.kernel.org/linux-scsi/20260729161243.C918D1F00A3A@smtp.kernel.org/,
but blk_mq_cleanup_rq() -> scsi_cleanup_rq() -> cmd->flags = 0 is only
called for by DM code.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index af27fd3df8d4..295f8b4afaa7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1967,6 +1967,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		 */
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
+		cmd->flags = 0;
 		scsi_run_queue_async(sdev);
 		break;
 	}
-- 
2.43.0

