Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E4BEADC;
	Fri, 20 Sep 2024 02:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726798659; cv=none; b=QuTg0gc7MNu4zpsMx3ceVma7Ff6Dwuhel7A9GfLPSmnYXI4fT/a+Wr7IQU8B7L+NHlHsUfku7KxY3QqKv9awfjfS4Y3anFCLbnb5v9YjyEADMM8HLo6VSJpCFhDrqCM8rczLLCiWONSD61jR4rod/paoTtYfA2lfvKa92l5vwxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726798659; c=relaxed/simple;
	bh=w7gcuKTC+Wfhx0Wk/jd0CQnbLtXGOaNgT9nVJt1j92Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JC0NF/xhVewSRKxUOS2Med4YoX8QysUEe8JTxEaQI1r+HZZYmdcI0VLXgjM9b7dUYrJnDAaaXtu5bEsjXhGsMCNMDtpJr6jyDjgX6fVKFOxVX69ogqMOnRuW8Q4hJL8Gckp8y4U6pz0uHX0cC5OzeCWKlhVPnMCeDe9tMvj+hMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4X8wvz4WsvzpTR4;
	Fri, 20 Sep 2024 10:15:27 +0800 (CST)
Received: from kwepemj200011.china.huawei.com (unknown [7.202.194.23])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D87A1800D5;
	Fri, 20 Sep 2024 10:17:31 +0800 (CST)
Received: from huawei.com (10.67.174.77) by kwepemj200011.china.huawei.com
 (7.202.194.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 20 Sep
 2024 10:17:30 +0800
From: Liao Chen <liaochen4@huawei.com>
To: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <skashyap@marvell.com>, <jhasan@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>
Subject: [PATCH -next] scsi: qedf: Fix potential null pointer dereference
Date: Fri, 20 Sep 2024 02:08:35 +0000
Message-ID: <20240920020835.1857251-1-liaochen4@huawei.com>
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

qedf is checked to be null in this if branch, accessing its member will
cause a null pointer dereference. As suggested by Bart, fix it by
deleting the logic since qedf cannot be NULL in this function.

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

