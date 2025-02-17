Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CC92248B2;
	Mon, 17 Feb 2025 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739810626; cv=none; b=t0KQBTCwhPJXN1T91QQv3CnXJDfKUDe8mU6NlyLqV/h1z5X8Ro0Co/OIgOKZL8Ivp1XELVruYSeHGxbbnc2PpVMvgTjEg2sMmjyX8Yw8H+D51Jt2LFe4Vsf4pxj3ECcy0fPdJf9svDvvRStVLUZdQnf9SJCVCzw1bwp760R2RCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739810626; c=relaxed/simple;
	bh=X6jCN9VHkiQx5aMy7VM6jbvlCKbvGBTk7wzTebMXwMw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UCjCV2YhyYZCDbHdHhG7TninTNZHVSTf8AOHteeVVoeIGt1yjvciP6ahZnxDhAY0TkvInEPuV+ACUhzAfYCpA603J5Het3SR5bfMvmayjD4XSGiLFEx7lVabhhdOdoaarNwfBzl4FmYR1doza4lCexu4Z/mXzBy3OJbNh5Z9HWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=Xf5BEqZ/; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="Xf5BEqZ/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1739810625; x=1771346625;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X6jCN9VHkiQx5aMy7VM6jbvlCKbvGBTk7wzTebMXwMw=;
  b=Xf5BEqZ/6gos9vs74LEx6NJxUBHLmUW2wVharguzr9WL7aElSWEm+xCX
   FEJ14YQvGFfNPhhNfEmPmZUAkTs/SsFBmdAfxtc49p1oWpvAusmoF/m+F
   mHm2uKinSYHVjBA0FUKh8FFSv01fmC30MaoOYWw3HAM1M+HV9M+qAF8dY
   74JfxgIWvOAj++oc2Ws19q+JM/r5+o7shxLkdg55Crrij4lLfSQNtptIv
   N3yjxBiRfdKGYrY/kbSF0yMOaJkLJ3bCkbfsWhAxAB0iNq09in29veYQa
   nlOOZGSNU9tvSWGZt0jvtqWGrxdX0RICQw2eqt3WfcvuSCtvchhYUn7MO
   w==;
X-CSE-ConnectionGUID: dnzcMm8cTjerrGUU/CeufA==
X-CSE-MsgGUID: L2sUUXg0RQSo8Oeq29npUQ==
X-IronPort-AV: E=Sophos;i="6.13,293,1732550400"; 
   d="scan'208";a="38130450"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2025 00:43:37 +0800
IronPort-SDR: 67b35980_Pv+/pjUeakjavJ+iTjvWoW9FW3+YP/nWIbTuJx9UKSqeAEl
 w55DhdCkbwzk8uuYuzjZaLVDQGWogJrxPDpAKJQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Feb 2025 07:45:04 -0800
WDCIronportException: Internal
Received: from unknown (HELO WDAP-ez2C89klLd.corp.sandisk.com) ([10.112.13.179])
  by uls-op-cesaip02.wdc.com with ESMTP; 17 Feb 2025 08:43:35 -0800
From: Arthur Simchaev <arthur.simchaev@sandisk.com>
To: martin.petersen@oracle.com
Cc: avri.altman@sandisk.com,
	Avi.Shchislowski@sandisk.com,
	beanhuo@micron.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	Arthur Simchaev <arthur.simchaev@sandisk.com>
Subject: [PATCH] scsi: ufs: core: Fix memory crash in case arpmb command failed
Date: Mon, 17 Feb 2025 18:43:30 +0200
Message-Id: <20250217164330.245612-1-arthur.simchaev@sandisk.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case the device doesn't support arpmb, the kernel get memory crash
due to copy user data in bsg_transport_sg_io_fn level. So in case
ufshcd_send_bsg_uic_cmd returned error, do not change the job's reply_len.

Memory crash backtrace:
3,1290,531166405,-;ufshcd 0000:00:12.5: ARPMB OP failed: error code -22

4,1308,531166555,-;Call Trace:

4,1309,531166559,-; <TASK>

4,1310,531166565,-; ? show_regs+0x6d/0x80

4,1311,531166575,-; ? die+0x37/0xa0

4,1312,531166583,-; ? do_trap+0xd4/0xf0

4,1313,531166593,-; ? do_error_trap+0x71/0xb0

4,1314,531166601,-; ? usercopy_abort+0x6c/0x80

4,1315,531166610,-; ? exc_invalid_op+0x52/0x80

4,1316,531166622,-; ? usercopy_abort+0x6c/0x80

4,1317,531166630,-; ? asm_exc_invalid_op+0x1b/0x20

4,1318,531166643,-; ? usercopy_abort+0x6c/0x80

4,1319,531166652,-; __check_heap_object+0xe3/0x120

4,1320,531166661,-; check_heap_object+0x185/0x1d0

4,1321,531166670,-; __check_object_size.part.0+0x72/0x150

4,1322,531166679,-; __check_object_size+0x23/0x30

4,1323,531166688,-; bsg_transport_sg_io_fn+0x314/0x3b0

Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
---
 drivers/ufs/core/ufs_bsg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 8d4ad0a3f2cf..a8ed9bc6e4f1 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -194,10 +194,12 @@ static int ufs_bsg_request(struct bsg_job *job)
 	ufshcd_rpm_put_sync(hba);
 	kfree(buff);
 	bsg_reply->result = ret;
-	job->reply_len = !rpmb ? sizeof(struct ufs_bsg_reply) : sizeof(struct ufs_rpmb_reply);
 	/* complete the job here only if no error */
-	if (ret == 0)
+	if (ret == 0) {
+		job->reply_len = !rpmb ? sizeof(struct ufs_bsg_reply) :
+					 sizeof(struct ufs_rpmb_reply);
 		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
+	}
 
 	return ret;
 }
-- 
2.34.1

