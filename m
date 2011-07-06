From: James Smart <james.smart@emulex.com>
Subject: [PATCH] scsi_lib: pause between error retries
Date: Wed, 6 Jul 2011 12:45:17 -0400
Message-ID: <c5b6ac69-8b34-45b0-9bb1-21f4d92e73a9@exht1.ad.emulex.com>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:34503 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754815Ab1GFQqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 12:46:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: alex.iannicelli@emulex.com

(You know host cpus and transport link speeds are getting fast when....)

During cable pull tests on our 16G FC adapter, we are seeing errors,
typically reads to close targets, which fail due to CRC or framing
errors caused by the cable being pull (return status DID_ERROR).
The adapter detects the error on one of the first frames received,
marks the FC exchange as dead (further frames go to bit bucket) and
signals the host of the error. This action is so quick, and coupled
with fast host CPUs, creates a scenario in which the midlayer sees
the failure and retries the io almost immediately. We've seen link
traces with the retry on the link while the original i/o is still
being processed by the target. We're also seeing the time window
for the "link to pull-apart" and the physical interface to report
disconnected to be in the few millisecond range. Which means, we're
encountering scenarios where the full retry count is exhausted
(all with error) by the midlayer before the link disconnect state
is detected.

We looked at 8G FC behavior and occasionally see the same behavior,
but as the link was slower, it rarely could exhaust all retries
before the link reported disconnect.

What is needed is a slight delay between io retries due to DID_ERROR
to cover this error.  It is inappropriate to put this delay in the
driver, as the error is indistinguishable from other link-related errors,
nor does the driver track whether the io is a retry or not. This is also
easier than tracking between-io-error bursts that are seen in this
scenario.

The patch below updates the retry path so that it inserts a delay as
if the target was busy.  The busy delay is on the order of 6ms. This
delay is sufficient to ensure the link down condition is reported
before the retry count is exhausted (at most 1 retry is seen).

-- james s


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_lib.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2011-05-23 14:16:21.000000000 -0400
+++ b/drivers/scsi/scsi_lib.c	2011-07-06 11:40:19.000000000 -0400
@@ -137,6 +137,7 @@ static int __scsi_queue_insert(struct sc
 		host->host_blocked = host->max_host_blocked;
 		break;
 	case SCSI_MLQUEUE_DEVICE_BUSY:
+	case SCSI_MLQUEUE_EH_RETRY:
 		device->device_blocked = device->max_device_blocked;
 		break;
 	case SCSI_MLQUEUE_TARGET_BUSY:


