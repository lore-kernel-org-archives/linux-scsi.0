From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: libfc: drop an incorrect assertion
Date: Wed, 11 Jul 2018 22:15:24 +0200
Message-ID: <20180711201617.898598-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.de>, Satish Kharat <satishkh@cisco.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

gcc points out one case in which the added lockdep_assert_held()
is wrong:

In file included from include/linux/spinlock_types.h:18,
                 from include/linux/spinlock.h:82,
                 from drivers/scsi/libfc/fc_rport.c:61:
drivers/scsi/libfc/fc_rport.c: In function 'fc_rport_recv_plogi_req':
include/linux/lockdep.h:347:45: error: 'rdata' may be used uninitialized in this function [-Werror=maybe-uninitialized]
 #define lockdep_is_held(lock)  lock_is_held(&(lock)->dep_map)
                                             ^
drivers/scsi/libfc/fc_rport.c:1832:24: note: 'rdata' was declared here
  struct fc_rport_priv *rdata;

The pointer to the lock is not initialized here, so besides the
compile-time warning, this will likely lead to an immediate
crash when dereferencing that pointer.

Fixes: ee35624e1e4e ("scsi: libfc: Add lockdep annotations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/libfc/fc_rport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6aff9303251a..be640ad2b7b6 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1835,8 +1835,6 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	struct fc_seq_els_data rjt_data;
 	u32 sid;
 
-	lockdep_assert_held(&rdata->rp_mutex);
-
 	sid = fc_frame_sid(fp);
 
 	FC_RPORT_ID_DBG(lport, sid, "Received PLOGI request\n");
-- 
2.9.0
