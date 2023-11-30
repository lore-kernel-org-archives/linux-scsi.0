Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C7F10D1;
	Thu, 30 Nov 2023 05:04:17 -0800 (PST)
Received: from dggpemd100001.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SgxBW1K0WzsRS5;
	Thu, 30 Nov 2023 21:00:35 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Thu, 30 Nov 2023 21:04:15 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wubo40@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH] scsi: libsas: Put the disk offline if all recovery actions fail
Date: Thu, 30 Nov 2023 13:01:18 +0000
Message-ID: <20231130130118.14367-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemd100001.china.huawei.com (7.185.36.94)
X-CFilter-Loop: Reflected

Currently, after all recovery actions in sas_eh_handle_sas_errors() fail
for sas disk, we just clear all IO, but the disk is still online. Perhaps
we should continue the subsequent recovery process for IO that cannot be
processed. If it still fails, the disk will be offline in
scsi_eh_ready_devs().

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Bo Wu <wubo40@huawei.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9047cfcd1072..3f9b99fa1769 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -637,8 +637,8 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 			       SAS_ADDR(task->dev->sas_addr),
 			       cmd->device->lun);
 
-			sas_eh_finish_cmd(cmd);
-			goto clear_q;
+			list_move_tail(&cmd->eh_entry, work_q);
+			goto out;
 		}
 	}
  out:
-- 
2.17.1

