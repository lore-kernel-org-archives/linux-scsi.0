Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E251BC4E;
	Thu, 20 Feb 2025 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740061256; cv=none; b=r6eo33J+cuIEl/4XNPLQvyZ6PZenM780LyGUWlsu4HcTixM/9GIzluyBTzn9iZH8DOlUlNS88Hbqq1QrZGLZIusgWvFtDRuFgFeVm9Ac+auKC4H0eMUGhj10FlSSHOWdLNirNSs3Ut51DizIWzwbEh9oB3SAJPFJg4DnGsnpxmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740061256; c=relaxed/simple;
	bh=hlB4UciSi11RpeFBPHRSOm6Mu8yyv0oaYnrGMZP85jQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FnQUlCkC8HPAoMSmPiGlOKPff5hG4yAtrHqr+CGNDrViaCu26SdjzcDTb38S0SLRx/nY/vNQOdEJs2AxBbZTkkYshaf4vIk0oaJ0YZnNQ+GuXlI7y6C66TKaw256ZDthHER7lwO8SHgHY3ldlIs6G3C+9++XbQiWcCGitQGS7Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=0owBZmig; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="0owBZmig"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1740061254; x=1771597254;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hlB4UciSi11RpeFBPHRSOm6Mu8yyv0oaYnrGMZP85jQ=;
  b=0owBZmigGO/JhIuETDgkSYZp4mqP0GFQxl3c/S/ydgMNBXcWAbF3SnYX
   RjY0A2TxAZiM22ogozdemIIH+N+sRkMZqxBAZgC2wJCyYnICvRsrq7F6Y
   xf64+nEGtyB0Iwh1nxgpTDc+Eg+tD8SxYwqT2F9eHLThOCW1STKDEnJwW
   xpUpUFsZtHnk651dijsQxaQFGvj9lcMhYZrHZAx4yGJ/o28b5ScRG439M
   EJOUutkjupTNZHpwM8w4IqNdgqfvK9p/blE4rGZ69Ty1TTWMi8kf8Rp+t
   h9urVIdsB2YyUfZR6cQ2MYdRv1xvyDGRDCsXFxLv7QdTIQ4JSZbKrwv0V
   A==;
X-CSE-ConnectionGUID: 2yfWHHVVSXm9SrPNGCP2nw==
X-CSE-MsgGUID: 55rAeVaETIGlaPzBIcCF3g==
X-IronPort-AV: E=Sophos;i="6.13,301,1732550400"; 
   d="scan'208";a="40005309"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2025 22:20:46 +0800
IronPort-SDR: 67b72c82_rHksVnBmRq+0NWKSdBXEerblw71mXeDn6jT7I8mRbVFZ57+
 mb1ilfU9ZRUdOlERIsMlVfv8USS02m1bzUkoocg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Feb 2025 05:22:11 -0800
WDCIronportException: Internal
Received: from unknown (HELO WDAP-ez2C89klLd.wdc.com) ([10.137.186.126])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2025 06:20:44 -0800
From: Arthur Simchaev <arthur.simchaev@sandisk.com>
To: martin.petersen@oracle.com
Cc: avri.altman@sandisk.com,
	Avi.Shchislowski@sandisk.com,
	beanhuo@micron.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	Arthur Simchaev <arthur.simchaev@sandisk.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] ufs: core: bsg: Fix memory crash in case arpmb command failed
Date: Thu, 20 Feb 2025 16:20:39 +0200
Message-Id: <20250220142039.250992-1-arthur.simchaev@sandisk.com>
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
ufs_bsg_exec_advanced_rpmb_req returned error, do not set the job's
reply_len.

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

Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>

---
Changes in v3:
  - changing !rpmb into rpmb and by swapping the two sizeof() expressions

---
Changes in v2:
  - Add Fixes tag
  - Elaborate commit log
---
 drivers/ufs/core/ufs_bsg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 8d4ad0a3f2cf..252186124669 100644
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
+		job->reply_len = rpmb ? sizeof(struct ufs_rpmb_reply) :
+					sizeof(struct ufs_bsg_reply);
 		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
+	}
 
 	return ret;
 }
-- 
2.34.1

