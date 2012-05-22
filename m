From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH v2] scsi: Fix dm-multipath starvation when scsi host is busy
Date: Tue, 22 May 2012 18:57:17 +0900
Message-ID: <4FBB62FD.5040008@ce.jp.nec.com>
References: <4FBB555B.5060608@ce.jp.nec.com> <1337677994.28492.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48393 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2EVJ6e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 05:58:34 -0400
In-Reply-To: <1337677994.28492.12.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>

On 05/22/12 18:13, James Bottomley wrote:
> Isn't a more understandable explanation:

Thank you. That's quite elegant.
I replaced the description with it.

> And please put a comment in the code as well otherwise someone will
> eventually send a "fix" for this because we're not paying attention to
> host busy (and I'll have forgotten about the issue by then and might
> apply it).

Added the comment in code.

> A final note is that this is more a band aid than a fix because this is
> still a congestion situation dm-mp should be aware of.

Yes. To do that, we have to generalize the concept of "host"
and share it with block layer.

Attached below is the revised patch.

----------------------------------------------------------
[PATCH v2] scsi: Fix dm-multipath starvation when scsi host is busy

block congestion control doesn't have any concept of fairness across
multiple queues.  This means that if SCSI reports the host as busy in
the queue congestion control it can result in an unfair starvation
situation in dm-mp if there are multiple multipath devices on the same
host.  For example:
http://www.redhat.com/archives/dm-devel/2012-May/msg00123.html

The fix for this is to report only the sdev busy state (and ignore the
host busy state) in the block congestion control call back.
The host is still congested, but the SCSI subsystem will sort out the
congestion in a fair way because it knows the relation between the
queues and the host.

Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Tested-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..75dc2e6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1378,16 +1378,19 @@ static int scsi_lld_busy(struct request_queue *q)
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
+	/*
+	 * Ignore host/starget busy state.
+	 * Since block layer does not have a concept of fairness across
+	 * multiple queues, congestion of host/starget needs to be handled
+	 * in SCSI layer.
+	 */
+	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev)) 
 		return 1;
 
 	return 0;
