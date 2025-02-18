Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD08023F295;
	Tue, 18 Feb 2025 11:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739877334; cv=none; b=Rjieg3bJhV9L6+ZT5v633U9skDNEl4lYEOAYgolQvdwSE6sssffsrasof26zQlIm58gVH7WzQvRYNxv5udo8IweHODu1BA4YidgCKZNir6O8SbJQ9NJgZJUtndDY9+pKixhViyFrHQmk3NSg80WnZ4qaJZJSkvonEOWbfwcWIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739877334; c=relaxed/simple;
	bh=ufqG7XoGOJZCg/c36vHLg/i8bJImksgJs7KeU/+b6mc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h1FsxIqtg6WKZF9djgvwQY3odwE9lNoBxxQuEbppqXPai0t3sM2/5W5iCky3oimeJ+v1DQLuNZhUBM8aa/oDIDmNLX3DHno1tYP4ldVeUXKDfMCScib55ZnzpeASwHJ8yogGseqIs+hG0GUW2TflleuhAZgBrPMPDV4XGArTScE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=XDJpg2we; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="XDJpg2we"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1739877333; x=1771413333;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ufqG7XoGOJZCg/c36vHLg/i8bJImksgJs7KeU/+b6mc=;
  b=XDJpg2we9L+/sn4/ZTEMepa0rD9URkTPlFLwmHamman19pM/ppzWwR7g
   b7V8+nOXxMsoWoqDucD9eh9x6GdthyFXXaQpPtnSTNqzRxkDLdfaZLrRT
   1nVdJ9XaMBGIGN6Yq/7X2ezFN10EuvHRG3jC8AiBPevWcCn3qBG6Poi2G
   UtiamyIdTD+MZ8rdMdnMeWaW0gs1hfujCi4hfES373cvr6cG53Kd8Kev1
   Ws1L+jhzunEnhHSTS80OGsonhWHjdbWw8eu2GTr75+hAxH/3DiXM+gFbg
   jINfz2XhcTCNv3QiE8Zp/PTO57Lsg/d+1mA+j7Qxcp8mWBrMCMoFCTj89
   w==;
X-CSE-ConnectionGUID: kzPNWm4vQnmc3ihwnCQ3sA==
X-CSE-MsgGUID: zrwzFhjOTyuPPdnDXwNx9w==
X-IronPort-AV: E=Sophos;i="6.13,295,1732550400"; 
   d="scan'208";a="38739768"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2025 19:15:32 +0800
IronPort-SDR: 67b45e1a_qx6JGEbPkJxRdaa7oidkw1zvzA+ND3kGszbPapWhSdzZY2B
 KlcdaH1raNkRltGWuH8/FL0dzNwCR8EHwVUS1Mw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Feb 2025 02:16:58 -0800
WDCIronportException: Internal
Received: from unknown (HELO WDAP-ez2C89klLd.corp.sandisk.com) ([10.112.13.179])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2025 03:15:29 -0800
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
Subject: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb command failed
Date: Tue, 18 Feb 2025 13:15:27 +0200
Message-Id: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
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
Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>

---
Changes in v2:
  - Add Fixes tag
  - Elaborate commit log

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

