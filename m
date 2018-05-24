From: Ivan Bornyakov <brnkv.i1@gmail.com>
Subject: [PATCH] scsi: isci: fix memcmp casting
Date: Thu, 24 May 2018 20:06:28 +0300
Message-ID: <20180524170628.24204-1-brnkv.i1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: intel-linux-scu@intel.com
Cc: artur.paszkiewicz@intel.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ivan Bornyakov <brnkv.i1@gmail.com>
List-Id: linux-scsi@vger.kernel.org

memcmp() returns int, but variable of type u8 is used to store it. When
casting int to u8, one can lose significant bits and get 0 from non-0
value returned by the memcmp().

Signed-off-by: Ivan Bornyakov <brnkv.i1@gmail.com>
---
 drivers/scsi/isci/host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 1ee3868ade07..dd5f41e86639 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1786,7 +1786,7 @@ static void power_control_timeout(struct timer_list *t)
 				 * them out of await_sas_power state.
 				 */
 				if (requester != NULL && requester != iphy) {
-					u8 other = memcmp(requester->frame_rcvd.iaf.sas_addr,
+					int other = memcmp(requester->frame_rcvd.iaf.sas_addr,
 							  iphy->frame_rcvd.iaf.sas_addr,
 							  sizeof(requester->frame_rcvd.iaf.sas_addr));
 
@@ -1840,7 +1840,7 @@ void sci_controller_power_control_queue_insert(struct isci_host *ihost,
 		struct isci_phy *current_phy;
 
 		for (i = 0; i < SCI_MAX_PHYS; i++) {
-			u8 other;
+			int other;
 			current_phy = &ihost->phys[i];
 
 			other = memcmp(current_phy->frame_rcvd.iaf.sas_addr,
-- 
2.16.1
