Received: from mx13.kaspersky-labs.com (mx13.kaspersky-labs.com [91.103.66.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899132FE58F;
	Thu, 13 Nov 2025 12:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.103.66.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763038451; cv=none; b=jcw0/NnGt1rDtIhzOcmWXYjMtYKWiK+nkDvhsLnYXFMglZjrUN5IcAwMwjCPnUvM13MHGs6Nr7U/815t98HdES0A08dcEBaZAdCnegdwCsRsegfziAXEs7EqgJ1cZ0jIrMMLzZgog0Ekji3ZrRBuic7WrW/QQJIvlEmaGolJvv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763038451; c=relaxed/simple;
	bh=He5W9w0o3gZEj3ngImtJMh6IYb/JcHFHiPcuwB+F/08=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OIz2/To6X/z4OsnvA9sWIODc90gbUelRPFdU7CUpbDAr32unfCEEDmCUKXeKutoL5jjGPKONp8NbjvThszypc79JEXs1LKbvf93kzIZma9H3jwtRQ08VB7MHiktl7HxUgGrSingpIht2ecMaMQNlawvX2lCXlNiJNiQCwj+32pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kaspersky.com; spf=pass smtp.mailfrom=kaspersky.com; dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b=Xj7nddgc; arc=none smtp.client-ip=91.103.66.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kaspersky.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaspersky.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b="Xj7nddgc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
	s=mail202505; t=1763038445;
	bh=6jOhNJgESVCY0++4V+aoHjeXCSLIzoJdnO1bYCI5Fos=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Xj7nddgcLQyl5yyd2ylLyUKWf9+HShDkT5dFlgCQKvihSnTd/5Sv/S53NhVkQ42Mt
	 Bre60N8WwEKJoXdQSQqXfPM1kwGnB7YeqGL4LDDrOCfRcoayemUJERU0v6sjcjHLEK
	 0H5G5KXXX9OxYPAPvlcFALpJt5uwoX27/+gaoPpJS7QFMROFZPKgo8wyJ45ztf1Zqd
	 cbTkwKD1IHOnhLgxNXMHxSGD0pH0xcp/k6MRezxc3ecaV+bhT8SqtMtV+xg7FAZ2dW
	 lrTVWND4psY7xx0LexDQsqcA176Jjzhlk9fpwH5cfHILdqK+h1Y2tchsgqhecXQHkS
	 x4B9k/RWuo3gQ==
Received: from relay13.kaspersky-labs.com (localhost [127.0.0.1])
	by relay13.kaspersky-labs.com (Postfix) with ESMTP id 7033A3E3642;
	Thu, 13 Nov 2025 15:54:05 +0300 (MSK)
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
	by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 7D2223E4784;
	Thu, 13 Nov 2025 15:54:04 +0300 (MSK)
Received: from zhigulin-p.avp.ru (10.16.104.190) by HQMAILSRV2.avp.ru
 (10.64.57.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.29; Thu, 13 Nov
 2025 15:53:51 +0300
From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
To: Saurav Kashyap <skashyap@marvell.com>
CC: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>, Javed Hasan
	<jhasan@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Arun Easi <arun.easi@cavium.com>, Nilesh Javali
	<nilesh.javali@cavium.com>, "Dupuis, Chad" <chad.dupuis@cavium.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH] scsi: qedf: remove unreachable NULL check in qedf_flush_active_ios()
Date: Thu, 13 Nov 2025 15:53:49 +0300
Message-ID: <20251113125350.39950-1-Pavel.Zhigulin@kaspersky.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HQMAILSRV2.avp.ru (10.64.57.52) To HQMAILSRV2.avp.ru
 (10.64.57.52)
X-KSE-ServerInfo: HQMAILSRV2.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 11/13/2025 12:38:41
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 198049 [Nov 13 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: Pavel.Zhigulin@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 76 0.3.76
 6aad6e32ec76b30ee13ccddeafeaa4d1732eef15
X-KSE-AntiSpam-Info: {Tracking_cluster_exceptions}
X-KSE-AntiSpam-Info: {Tracking_real_kaspersky_domains}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;zhigulin-p.avp.ru:7.1.1,5.0.1;kaspersky.com:7.1.1,5.0.1
X-KSE-AntiSpam-Info: {Tracking_white_helo}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/13/2025 12:39:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11/13/2025 11:10:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/11/13 09:15:00 #27919685
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 52

qedf_flush_active_ios() iterates over the statically allocated
cmd_mgr->cmds[] array. Each element in this array is always valid, so
the check:

        if (!io_req)

can never be true. This condition is unreachable and redundant, and it
causes dead code that may confuse analysis tools.

Remove the redundant NULL check

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
---
 drivers/scsi/qedf/qedf_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..e926034c260f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1649,8 +1649,6 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, u64 lun)
 	for (i = 0; i < FCOE_PARAMS_NUM_TASKS; i++) {
 		io_req = &cmd_mgr->cmds[i];

-		if (!io_req)
-			continue;
 		if (!io_req->fcport)
 			continue;

--
2.43.0

