Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453512D7DEF
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 10:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209021; cv=none; b=XMhwQVFiO17AmLcNP1eO61/TD4P2a23zXnsm1LOf8nguPsLqJpN1UUA1lKnHnJAOl2LEiCA6jZISpTjoDFYAE1qTWXer5eEAGm7E1k1tdmyBMMe5Vr7FkmmoC5LrxHVOWyzZSm6302nOpyYNx/7UuQsvflObEJ0LG0MO2re4Sn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209021; c=relaxed/simple;
	bh=pMeHfgv+kz/+HfL9i/pP+LnrGc9VyuR2KxLmr+vbmHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nioB+533lCQ0AbiAxwf+yEnvHkPijoZGbp8BdOlQGTOFu5orsYEu3/Xn4l22MtiwLxgXKb2AWtTKyR4ExTa7TpFkaSTNxXnANj+XrB7CZpSrqCVfChgmFusBl5rxgeb5++YwDUcz9J486Rwa2qQFZVCJUWWefPdO39yrqXSW6qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FRzQ9Inj; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FRzQ9Inj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=3j
	KOTMABXwMrmQIBuOq/DbHBILHPTZDPbU6d7YCQg2E=; b=FRzQ9InjWt9eCA3nSC
	NYWrYB9V7lmo+Q75M0U5isUVMEplV56bX4sPzelX64vDwcNfpY2mzG85t6eP2y4g
	PB/5qc7SEs0EV5WU8MfJhAZJzbaybcStsbqRBTe5aKsYxwM0PEwHrlN4yDUptmhF
	IzNpx5qnEvVHs7JLTI183hSq4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAntXCaWTpqUiV6FA--.20165S6;
	Tue, 23 Jun 2026 18:02:08 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: hare@suse.de,
	tom.leiming@gmail.com,
	p.raghav@samsung.com,
	dlemoal@kernel.org,
	sw.prabhu6@gmail.com,
	linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v1 4/4] scsi: sd: fix sd_done() sense handling condition
Date: Tue, 23 Jun 2026 18:01:59 +0800
Message-Id: <20260623100159.4018066-5-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAntXCaWTpqUiV6FA--.20165S6
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFWkGF1rAw4DtrWUZw13urg_yoWkGFc_uF
	4FgrsrWr1Y9rsxur1IkF13Zasava15Wrn5u3sYvryayry8W3sFgFyUZF9xAF48Wr4jkFy5
	tw4Dtr13Cr1kGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbiID3UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QCnOGo6WaAnBQAA39

Commit 464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE") replaced
driver_byte(result) != DRIVER_SENSE with
!scsi_status_is_check_condition(result) but kept the old OR-shaped
gate.  That lets CHECK CONDITION with invalid or deferred sense enter
the sense_key switch with an uninitialized or stale sshdr.

Only handle sshdr when CHECK CONDITION is indicated and the sense
data is valid and not deferred.

Fixes: 464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f05e7683df6..110ea4d793f3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2419,8 +2419,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (!scsi_status_is_check_condition(result) &&
-	    (!sense_valid || sense_deferred))
+	if (!scsi_status_is_check_condition(result) ||
+	    !sense_valid || sense_deferred)
 		goto out;
 
 	switch (sshdr.sense_key) {
-- 
2.25.1

