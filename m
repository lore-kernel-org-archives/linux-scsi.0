From: michaelc@cs.wisc.edu
Subject: [PATCH 7/9] qla2xxx: use new host byte transport errors.
Date: Tue, 19 Aug 2008 18:45:29 -0500
Message-ID: <1219189531-5243-8-git-send-email-michaelc@cs.wisc.edu>
References: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-3-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-4-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-5-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-6-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-7-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYHSXp5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:45:57 -0400
In-Reply-To: <1219189531-5243-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Vasquez <andrew.vasquez@qlogic.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This has qla2xxx use the new transport error values instead of
DID_BUS_BUSY. I am not sure if all the errors
in qla_isr.c I changed are transport related. We end up blocking/deleting
the rport for all of them so it is better to use the new transport error since
the fc classs will decide when to fail the IO.

With this patch if I pull a cable then IO that had reached
the driver, will be failed with DID_TRANSPORT_DISRUPTED (not including
tape). The fc class will then fail the IO when the fast io fail tmo
has fired, and the driver will flush any other commands running.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 874d802..5fd90ac 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1183,7 +1183,12 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
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
@@ -1211,7 +1216,12 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
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

