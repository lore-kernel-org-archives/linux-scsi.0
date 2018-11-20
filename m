From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/4] scsi: Add scsi_prot_op_normal()
Date: Tue, 20 Nov 2018 22:59:01 +0800
Message-ID: <1542725944-244183-2-git-send-email-john.garry@huawei.com>
References: <1542725944-244183-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542725944-244183-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

It is a common pattern to check if a Scsi command protection option is
"normal", i.e. regular IO.

Add a common simple wrapper for this.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 include/scsi/scsi_cmnd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c891ada..3b26ea1 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -271,6 +271,11 @@ static inline unsigned char scsi_get_prot_op(struct scsi_cmnd *scmd)
 	return scmd->prot_op;
 }
 
+static inline bool scsi_prot_op_normal(struct scsi_cmnd *scmd)
+{
+	return scmd->prot_op == SCSI_PROT_NORMAL;
+}
+
 enum scsi_prot_flags {
 	SCSI_PROT_TRANSFER_PI		= 1 << 0,
 	SCSI_PROT_GUARD_CHECK		= 1 << 1,
-- 
1.9.1
