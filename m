From: Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 07/25] zfcp: fix missing REC trigger trace on enqueue without ERP thread
Date: Thu, 17 May 2018 19:14:49 +0200
Message-ID: <20180517171507.18237-8-maier@linux.ibm.com>
References: <20180517171507.18237-1-maier@linux.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180517171507.18237-1-maier@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Example trace record formatted with zfcpdbf from s390-tools:

Timestamp      : ...
Area           : REC
Subarea        : 00
Level          : 1
Exception      : -
CPU ID         : ..
Caller         : 0x...
Record ID      : 1                      ZFCP_DBF_REC_TRIG
Tag            : .......
LUN            : 0x...
WWPN           : 0x...
D_ID           : 0x...
Adapter status : 0x...
Port status    : 0x...
LUN status     : 0x...
Ready count    : 0x...
Running count  : 0x...
ERP want       : 0x0.                   ZFCP_ERP_ACTION_REOPEN_...
ERP need       : 0xc0                   ZFCP_ERP_ACTION_NONE

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 20fe59300d0e..69dfb328dba4 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -315,8 +315,11 @@ static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
 		goto out;
 	}
 
-	if (!adapter->erp_thread)
-		return -EIO;
+	if (!adapter->erp_thread) {
+		need = ZFCP_ERP_ACTION_NONE; /* marker for trace */
+		retval = -EIO;
+		goto out;
+	}
 
 	need = zfcp_erp_required_act(want, adapter, port, sdev);
 	if (!need)
-- 
2.16.3
