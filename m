From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 09/14] qla2xxx: Fix memory leak for abts processing
Date: Fri, 3 Feb 2017 14:40:50 -0800
Message-ID: <1486161655-2307-10-git-send-email-himanshu.madhani@cavium.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 359a79d..b61cbb8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6753,6 +6753,8 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_response_pkt_all_vps(vha, (response_t *)&op->atio);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	kfree(op);
 }
 
 void
-- 
1.8.3.1
