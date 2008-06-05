From: michaelc@cs.wisc.edu
Subject: [PATCH 4/7] qla2xxx: use new host byte transport errors.
Date: Wed,  4 Jun 2008 20:41:43 -0500
Message-ID: <1212630106-13413-5-git-send-email-michaelc@cs.wisc.edu>
References: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This has qla2xxx use the new transport error values instead of
DID_BUS_BUSY. I am not sure if all the errors
in qla_isr.c I changed are transport related. We end up blocking/deleting
the rport for all of them so it is ok to use the new transport error since
the fc classs will decide when to fail the IO.

With this patch if I pull a cable then IO that had reached
the driver, will be failed with DID_TRANSPORT_DISRUPTED. The
fc class will then fail the IO when the fast io fail tmo
has fired.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla2xxx/qla_isr.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5d9a64a..b1dec6e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1222,7 +1222,12 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		    cp->serial_number, comp_status,
 		    atomic_read(&fcport->state)));
 
-		cp->result = DID_BUS_BUSY << 16;
+		/*
+		 * We are going to have the fc class block the rport
+		 * while we try to recover so instruct the mid layer
+		 * to requeue until the class decides how to handle this.
+		 */
+		cp->result = DID_TRANSPORT_DISRUPTED << 16;
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
 			qla2x00_mark_device_lost(ha, fcport, 1, 1);
 		}
@@ -1250,7 +1255,12 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		break;
 
 	case CS_TIMEOUT:
-		cp->result = DID_BUS_BUSY << 16;
+		/*
+		 * We are going to have the fc class block the rport
+		 * while we try to recover so instruct the mid layer
+		 * to requeue until the class decides how to handle this.
+		 */
+		cp->result = DID_TRANSPORT_DISRUPTED << 16;
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			DEBUG2(printk(KERN_INFO
-- 
1.5.4.1
