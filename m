Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262CC6FBF;
	Sat, 21 Sep 2024 06:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726900746; cv=none; b=UW24L6S+igYkOEzMbhkwSK+Kv/CmwV0QREQWgukr7wpQwY5QU2Lztkul0/UfezIjMwizX4C6aZDMDTanHZU0HmgZyYvfoRLyeKODi5QRcawhdRmCdeL9WT5aZOI45ULzilv/7jEXoGQSFup/7h5dZP6XUt7kgnOW4uz66+//JA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726900746; c=relaxed/simple;
	bh=pcnWHw2f9ld/9KL/5BiX49jgJNtufikeQHK7aDD3J8k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hm1lZx0Vj4lLmH7klTb2F1VGpMKQglnd1MBCl6v7ZGxH5x0715Z2Zy4utcOTmCRvBkaQS67PE5jRtqOBEwTmxWFa31WEoa1xFIwoltNjyey6aPu68Fv/jk/y1xr1DA9phO3dUpusEB8foo4KlkgKFWw+NIYFs0zOE+fIXwCn8w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4X9fgz09f0z1T7lc;
	Sat, 21 Sep 2024 14:37:35 +0800 (CST)
Received: from kwepemj200011.china.huawei.com (unknown [7.202.194.23])
	by mail.maildlp.com (Postfix) with ESMTPS id 8380E140159;
	Sat, 21 Sep 2024 14:38:54 +0800 (CST)
Received: from huawei.com (10.67.174.77) by kwepemj200011.china.huawei.com
 (7.202.194.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 21 Sep
 2024 14:38:53 +0800
From: Liao Chen <liaochen4@huawei.com>
To: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <skashyap@marvell.com>, <jhasan@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>
Subject: [PATCH -next v2] scsi: qedf: Remove dead code
Date: Sat, 21 Sep 2024 06:29:56 +0000
Message-ID: <20240921062956.2027563-1-liaochen4@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemj200011.china.huawei.com (7.202.194.23)

If container_of() is used correctly, its result is never NULL. Remove
the code that depends on container_of() returning a NULL pointer.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
---
 drivers/scsi/qedf/qedf_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cf13148ba281..df756f3eef3e 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -4018,11 +4018,6 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
-	if (!qedf) {
-		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
-		return;
-	}
-
 	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "Already is in recovery, hence not calling software context reset.\n");
-- 
2.34.1

