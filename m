Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58D2274658;
	Tue, 15 Jul 2025 07:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566073; cv=none; b=WZ6xIYpQbY3AaVKVYEXiQLQm+7qQ0cVawFgj5j8jG+XL8vm4pMRQTmCOWuMER9TPc4t9Y3vua/hIzn57BBSpDVG9UbOdvmOKGlAEoaQ3BRD0/qn5r7zvL+ChRHRQrPPmfqdyGx15m3aVLvpR1dYcEN6BBbsDsQUZd/P8rrbDvWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566073; c=relaxed/simple;
	bh=uWmehmNiGf8T4RfU0s+cwTdBH+OEaWHv6hOIyw8S+aY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=af5FpGXum3bdgWDQokmAZHTZTsmgCzQj4NA8VPIbJ/afGlCVi4z8irON+KGc9KWrPGV1Z1mP7FneO+DemVLBuS9UUoDNA5RhJ6NdqokOU+XPrE0JOpitasFfprgABjM9E+2oGz+eQxvrjG5CMQ7nhvlLO3llN+2QxAxD4bWgvFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bhBHD0dCMz2TT4Y;
	Tue, 15 Jul 2025 15:52:24 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 00CE9180043;
	Tue, 15 Jul 2025 15:54:27 +0800 (CST)
Received: from huawei.com (10.175.112.188) by kwepemg500017.china.huawei.com
 (7.202.181.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 15 Jul
 2025 15:54:25 +0800
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <lduncan@suse.com>, <cleech@redhat.com>, <njavali@marvell.com>,
	<mrangankar@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
	<James.Bottomley@HansenPartnership.com>, <michael.christie@oracle.com>
CC: <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yukuai1@huaweicloud.com>,
	<houtao1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
	<chengzhihao1@huawei.com>, <lilingfeng@huaweicloud.com>,
	<lilingfeng3@huawei.com>
Subject: [PATCH] Revert "scsi: iscsi: Fix HW conn removal use after free"
Date: Tue, 15 Jul 2025 15:39:26 +0800
Message-ID: <20250715073926.3529456-1-lilingfeng3@huawei.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemg500017.china.huawei.com (7.202.181.81)

This reverts commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e.

The invocation of iscsi_put_conn() in iscsi_iter_destory_conn_fn() is used
to free the initial reference counter of iscsi_cls_conn.
For non-qla4xxx cases, the ->destroy_conn() callback (e.g.,
iscsi_conn_teardown) will call iscsi_remove_conn() and iscsi_put_conn() to
remove the connection from the children list of session and free the
connection at last.
However for qla4xxx, it is not the case. The ->destroy_conn() callback
of qla4xxx will keep the connection in the session conn_list and doesn't
use iscsi_put_conn() to free the initial reference counter. Therefore,
it seems necessary to keep the iscsi_put_conn() in the
iscsi_iter_destroy_conn_fn(), otherwise, there will be memory leak
problem.

Link: https://lore.kernel.org/all/88334658-072b-4b90-a949-9c74ef93cfd1@huawei.com/
Fixes: c577ab7ba5f3 ("scsi: iscsi: Fix HW conn removal use after free")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c75a806496d6..743b4c792ceb 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2143,6 +2143,8 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 		return 0;
 
 	iscsi_remove_conn(iscsi_dev_to_conn(dev));
+	iscsi_put_conn(iscsi_dev_to_conn(dev));
+
 	return 0;
 }
 
-- 
2.46.1

