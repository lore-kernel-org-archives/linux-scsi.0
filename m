From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] scsi: Fix dm-multipath starvation when scsi host is busy
Date: Tue, 22 May 2012 17:59:07 +0900
Message-ID: <4FBB555B.5060608@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34810 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2EVJAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 05:00:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>

When a scsi host is kept busy by a dm-mpath device, other dm-mpath device
on the same host could be starved. For example:
http://www.redhat.com/archives/dm-devel/2012-May/msg00123.html

It happens because dm-mpath delays request submission when the underlying
scsi host is busy even if sdev is not busy.

For case like this, it is better to send the request down and let scsi do
appropriate starvation control over the shared resource.

Though it might seem odd to change scsi's definition of a LLD being "busy",
it is reasonable because scsi_lld_busy (and blk_lld_busy) was introduced
to provide a hint for request-based stacking driver (i.e. dm-multipath)
and dm-multipath is the only user of this function.

Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Tested-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..0eb4602 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1378,16 +1378,13 @@ static int scsi_lld_busy(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
-	struct scsi_target *starget;
 
 	if (!sdev)
 		return 0;
 
 	shost = sdev->host;
-	starget = scsi_target(sdev);
 
-	if (scsi_host_in_recovery(shost) || scsi_host_is_busy(shost) ||
-	    scsi_target_is_busy(starget) || scsi_device_is_busy(sdev))
+	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev)) 
 		return 1;
 
 	return 0;
