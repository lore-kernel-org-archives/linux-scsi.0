Received: from mail-out.aladdin-rd.ru (mail-out.aladdin-rd.ru [91.199.251.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC6F3C6613;
	Thu, 26 Mar 2026 09:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.199.251.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519117; cv=none; b=kaFOeHxhRTfvctIgPNTgMK/G0VgQwxEPoYwKlrr0OywEj0cKMYumvJvW9MNarxWSiZj4uA083XAxe5RfuZvhZZYgrfK1LRRfPh5J7GevNkGYuoA20w+/sF5A3jNjDkOqOFUcNAbfABQS1B3Rd/VdO04pqHGei8un1/zVonEAKlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519117; c=relaxed/simple;
	bh=GecF2UtI5yLv2YcvChPTWETKSH7tEE2890V6rnYqOGQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QtamU9/YcRsbzV3zjVlXP8O0ia9AP2xgjqCiASdfbbr+ujaUd33aM/Gd0J6gpK1vsJyIpCBqI8RHEbz+95W/GaFJsniMZvFz61Z6qDrPuXzZXz+t3Swop596PSPPZyDyA2kw6D4yvwfZ9g6Dk2TprdhNJCd0z1w8x6esM2hTKHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru; spf=pass smtp.mailfrom=aladdin.ru; dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b=PTrA43su; arc=none smtp.client-ip=91.199.251.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b="PTrA43su"
DKIM-Signature: v=1; a=rsa-sha256; d=aladdin.ru; s=mail; c=simple/simple;
	t=1774518177; h=from:subject:to:date:message-id;
	bh=GecF2UtI5yLv2YcvChPTWETKSH7tEE2890V6rnYqOGQ=;
	b=PTrA43suoAcXIXy/pZj9oeXJNQb0EjAte+QP+t6VUvuRcI6byxedPVMnLIrdCZA+I3hPeQp6lhl
	wbwatvYktB1VBQ2swd2nrhMZeIib7nItO/7cAPXQvcX9mFCc5fkJuMJzu7RSP+eWkSYUBsWCXFy61
	UCufQGxkGeuvpJV+0cUv7tYthyMOqxLja+j7w7nY1bNv9eT8EnKOumuZdCAviKjQ9VtXVH4XDfKuw
	bwydUKwyr22BVqYcIYMYmNbQ9K5Dn27TwQ0IV3/GgC0YLlaMJX6M8Y/aJv1Ute8osU7CHJN0uA+zX
	VHsvLJTuOjY7dZ77gxGMr42owcnGpSpbE6Pw==
From: Daniil Dulov <d.dulov@aladdin.ru>
To: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: Daniil Dulov <d.dulov@aladdin.ru>, Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Tony Battersby <tonyb@cybernetics.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>,
	<stable@vger.kernel.org>
Subject: [PATCH] scsi: qla2xxx: Check if target mode enabled in case of task management commands
Date: Thu, 26 Mar 2026 12:42:49 +0300
Message-ID: <20260326094249.1366353-1-d.dulov@aladdin.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EXCH-2016-04.aladdin.ru (192.168.1.104) To
 EXCH-2016-01.aladdin.ru (192.168.1.101)

TYPE_TGT_TMCMD are not being skipped now, but tgt_ops are dereferenced
in qlt_free_ul_cmd() without checking if target mode is enabled. However,
it is possible that commands requiring target mode to be enabled are
received while target mode is disabled as it is seen in TYPE_TGT_CMD case.

To fix the issue check if target mode is enabled in TYPE_TGT_TMCMD
case as well.

Fixes: d46c69a087aa ("scsi: qla2xxx: Clear cmds after chip reset")
Cc: stable@vger.kernel.org
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 72b1c28e4dae..e81ef3629aaa 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1890,6 +1890,13 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 				}
 				break;
 			case TYPE_TGT_TMCMD:
+				if (!vha->hw->tgt.tgt_ops || !tgt ||
+				    qla_ini_mode_enabled(vha)) {
+					ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
+					    "HOST-ABORT-HNDLR: dpc_flags=%lx. Target mode disabled\n",
+					    vha->dpc_flags);
+					continue;
+				}
 				/*
 				 * Currently, only ABTS response gets on the
 				 * outstanding_cmds[]
-- 
2.34.1

