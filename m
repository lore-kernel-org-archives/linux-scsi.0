Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A691B653C;
	Fri, 13 Sep 2024 03:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726199117; cv=none; b=htWj853iUPmJed2622bybtV5Pjb7W2aeQ0s6bI5YIohYaJQwQyhSEMaIGBSZb3v/XqVDKKRvp63zu58A1MaLf2G/8wUqPF22+WAQyPMacmugY/x98cVD4wmtMIV2l4REtA8bdWVF71JPe3ChwC6WqSwDgBLHRaFhVcgl7izyUmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726199117; c=relaxed/simple;
	bh=8CiYljOttU3RMsKwHDx5X/Ct2ctl0M+3ISzbVKy3LZs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B0D6t2fZc0sHhh+ImxA3uo0VdomvHpBd3CWUmddBwIegjsK/+a0cXoMIk8HMDFQk1KVagx2c/B2lGBiXazIrMbNpMyD8r/9Qa9LupCgrn25YhurYR5Pzq4dYRQt0Zm0YyqUAIN7FKAx2VEGDWKA/1jK10+9THqWT8ZWfWtvThQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4X4gCq2xVTzyRsv;
	Fri, 13 Sep 2024 11:44:23 +0800 (CST)
Received: from kwepemj200011.china.huawei.com (unknown [7.202.194.23])
	by mail.maildlp.com (Postfix) with ESMTPS id 02A9D1401F0;
	Fri, 13 Sep 2024 11:45:11 +0800 (CST)
Received: from huawei.com (10.67.174.77) by kwepemj200011.china.huawei.com
 (7.202.194.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 13 Sep
 2024 11:45:10 +0800
From: Liao Chen <liaochen4@huawei.com>
To: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <skashyap@marvell.com>, <jhasan@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<njavali@marvell.com>
Subject: [PATCH] scsi: qedf: Fix potential null pointer dereference
Date: Fri, 13 Sep 2024 03:36:27 +0000
Message-ID: <20240913033627.1465713-1-liaochen4@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemj200011.china.huawei.com (7.202.194.23)

qedf is checked to be null in this if branch, accessing its member will
cause a null pointer dereference. Fix it by passing a direct NULL into
the error function.

Fixes: 51071f0831ea ("scsi: qedf: Don't process stag work during unload and recovery")
Signed-off-by: Liao Chen <liaochen4@huawei.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 4813087e58a1..9d4738db0e51 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -4021,7 +4021,7 @@ void qedf_stag_change_work(struct work_struct *work)
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
 	if (!qedf) {
-		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		QEDF_ERR(NULL, "qedf is NULL");
 		return;
 	}
 
-- 
2.34.1

