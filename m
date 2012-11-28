From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 13/13] Do not queue new I/O after scsi_remove_host() started
Date: Wed, 28 Nov 2012 13:53:58 +0100
Message-ID: <50B60966.40900@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:57141 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2K1Mx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:53:59 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

The function scsi_remove_host() may get invoked concurrently with
scsi_request_fn(). Kill those I/O requests for which processing
starts after scsi_remove_host() has been invoked. This makes
device removal a little quicker by avoiding that such SCSI
commands time out.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f3d6e0d..5fe25b3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1549,7 +1549,8 @@ static void scsi_request_fn(struct request_queue *q)
 		if (!req || !scsi_dev_queue_ready(q, sdev))
 			break;
 
-		if (unlikely(!scsi_device_online(sdev))) {
+		if (unlikely(!scsi_device_online(sdev) ||
+			     !scsi_host_scan_allowed(shost))) {
 			sdev_printk(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
 			scsi_kill_request(req, q);
-- 
1.7.10.4

