From: Lance Roy <ldr709@gmail.com>
Subject: [PATCH 09/16] scsi: Replace spin_is_locked() with lockdep
Date: Tue,  2 Oct 2018 22:38:55 -0700
Message-ID: <20181003053902.6910-10-ldr709@gmail.com>
References: <20181003053902.6910-1-ldr709@gmail.com>
Reply-To: Lance Roy <ldr709@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003053902.6910-1-ldr709@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, Lance Roy <ldr709@gmail.com>, Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

lockdep_assert_held() is better suited to checking locking requirements,
since it won't get confused when someone else holds the lock. This is
also a step towards possibly removing spin_is_locked().

Signed-off-by: Lance Roy <ldr709@gmail.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/snic/snic_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index d9b2e46424aa..42e485139fc9 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2001,7 +2001,7 @@ snic_dr_finish(struct snic *snic, struct scsi_cmnd *sc)
 	}
 
 dr_failed:
-	SNIC_BUG_ON(!spin_is_locked(io_lock));
+	lockdep_assert_held(io_lock);
 	if (rqi)
 		CMD_SP(sc) = NULL;
 	spin_unlock_irqrestore(io_lock, flags);
@@ -2604,7 +2604,7 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
 	ret = SUCCESS;
 
 skip_internal_abts:
-	SNIC_BUG_ON(!spin_is_locked(io_lock));
+	lockdep_assert_held(io_lock);
 	spin_unlock_irqrestore(io_lock, flags);
 
 	return ret;
-- 
2.19.0
