Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4393B840B;
	Fri, 24 Jul 2026 07:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784879965; cv=none; b=nq+3NsKPktl7svXwTI/EaAtkkv+TsEIEYy0tWj4mQfp8XL2Yaxu/iEgbyRUYu3t+OhKOs95tqeHm1SVFYPceICxeMbCvnEDjEJG0lo4ntOcOiN24kNfRqwHK9IyLSd9mVCtvQTnxVWLibzmJlJLvoYzn9I0N+ProRIx1uBysXSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784879965; c=relaxed/simple;
	bh=9fvwFd19UHU/o+z+SThdpN5kigAYFPIOquBUzL6JmBw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q4zoKP4yBIqBnPw41PMzAXfAULFrYn4HEd6o1qedh0w23mZsU4JSOuam6BuIhW9NSHTK8mObJHh3h/cFFU7mXk/NUgFPxWovJZ4j4NzcLPi5Dbj6ympcCMLs1N3kpL1+fayfq0N9YONWU3z8tExXeQX2rP/A7c5BTpAilRb8KkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BQQS+FIS; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BQQS+FIS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=UQ
	OTNOJTX+iy3xe7s4ve42dRgZ07Cp+Pdyd4Uq7LMDA=; b=BQQS+FISptKIkaUyE6
	0UBvUDK50qpCAm+UjP+yJb9DReUXX2ZSet4M7xcy8fcBJaCfxXnuLrEhrpMId3GM
	LFqcEZYyU0Xztm3fInpCXDopXnlDBRJmy4KUTboI8XmtY0ozCyUuAUmMcgVn1eFA
	/TUGLcoYyt1k3ZIydAGLjqaCE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDXf35FG2Nq8oDOLg--.61308S2;
	Fri, 24 Jul 2026 15:59:02 +0800 (CST)
From: kensanya@163.com
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: [PATCH] scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
Date: Fri, 24 Jul 2026 15:58:50 +0800
Message-Id: <20260724075850.280699-1-kensanya@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXf35FG2Nq8oDOLg--.61308S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFyDtw4rXF1UJw1xKw1UGFg_yoW8Xw43pr
	s3GFZ8JrZ5Gayjg3Z5JFWUXF15Aw17Kay5CF1xWa4fZrZ5AFW7KF1kJryUK3Z8KF93AayY
	9F4xZrW8tr48W3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UpuWJUUUUU=
X-CM-SenderInfo: 5nhq2txq1dqiywtou0bp/xtbCwgZLJ2pjG0Y53QAA3Y

From: TanZheng <tanzheng@kylinos.cn>

In the iblock_execute_pr_out function, PRO_PREEMPT, PRO_PREEMPT_AND_ABORT
and PRO_RELEASE all perform callback capability checks through
ops->pr_clear. The error check allows unimplemented hooks to pass through
the gate, resulting  dereferencing a NULL function pointer.

Check whether the hooks that need to be called are supported.

Fixes: 394f81184882 ("scsi: target: Add block PR support to iblock")
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
---
 drivers/target/target_core_iblock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1087d1d17c36..ea65d39fef88 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -906,7 +906,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_PREEMPT:
 	case PRO_PREEMPT_AND_ABORT:
-		if (!ops->pr_clear) {
+		if (!ops->pr_preempt) {
 			pr_err("block_device does not support pr_preempt.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
@@ -916,8 +916,8 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 				      sa == PRO_PREEMPT_AND_ABORT);
 		break;
 	case PRO_RELEASE:
-		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_pclear.\n");
+		if (!ops->pr_release) {
+			pr_err("block_device does not support pr_release.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
-- 
2.25.1

