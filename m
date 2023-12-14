X-Greylist: delayed 987 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 14 Dec 2023 04:42:19 PST
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AF6129;
	Thu, 14 Dec 2023 04:42:19 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4SrWkd4XgVz1kvF0;
	Thu, 14 Dec 2023 20:24:41 +0800 (CST)
Received: from canpemm500010.china.huawei.com (unknown [7.192.105.118])
	by mail.maildlp.com (Postfix) with ESMTPS id DCEEE1A0190;
	Thu, 14 Dec 2023 20:25:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 14 Dec
 2023 20:25:49 +0800
From: Ye Bin <yebin10@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ye Bin <yebin10@huawei.com>
Subject: [PATCH] scsi: core: add CMD_LAST flag for error handle scsi command
Date: Thu, 14 Dec 2023 20:29:19 +0800
Message-ID: <20231214122919.985087-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)

SCSI error handle will send scsi command bypass block layer. After commit
8930a6c20791 scsi support request batching. Some LLD only writing the hardware
doorbell when necessary, after the last request was prepared.
For scsi error handle, each command waits synchronously. So each scsi command
is both the beginning and the end. So add CMD_LAST flag for error handle scsi
command.

Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1bac12ef238e..9e79047a1250 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1147,6 +1147,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 	const unsigned long stall_for = msecs_to_jiffies(100);
 	int rtn;
 
+	scmd->flags |= SCMD_LAST;
 retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
 	shost->eh_action = &done;
-- 
2.31.1

