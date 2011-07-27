From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/10] libfc: Remove the reference to FCP packet from
 scsi_cmnd in case of error
Date: Wed, 27 Jul 2011 15:10:54 -0700
Message-ID: <20110727221054.23675.14885.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab1G0WKz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:55 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Neerav Parikh <Neerav.Parikh@intel.com>

From: Neerav Parikh <Neerav.Parikh@intel.com>

fc_queuecommand() allocates an FCP packet for each SCSI command and sends
it out on the wire. In the process it stores the reference to the FCP packet
in the scsi_cmnd structure.
Now, in case under stress testing the libfc exchange layer runs out of
exchanges the fc_queuecommand() may not be able to send out commands out on
the wire. In such a scenario if there is an error in sending the FCP packet
out the wire; fc_queuecommand() deletes the FCP packet from internal queue,
releases the FCP packet and returns a SCSI_MLQUEUE_HOST_BUSY status to the
scsi-ml. But, the reference to the FCP packet set in the scsi_cmnd is not
removed from the scsi_cmnd in this code path.

This might lead to a crash under stress testing where the scsi_cmnd failed by
fc_queuecommand() comes up to fc_eh_abort() via scsi eh thread. fc_eh_abort()
will get reference to the FCP packet to be aborted from the scsi_cmnd for
further FCP abort related processing and then try to release the FCP packet
that has already been released.

This patch removes the FCP packet reference from the scsi_cmnd before returning
back from fc_queuecommand() in case of an error in sending out the FCP packet.

Signed-off-by: Neerav Parikh <Neerav.Parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 14dd121..afb63c8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1084,6 +1084,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 	rc = lport->tt.fcp_cmd_send(lport, fsp, fc_fcp_recv);
 	if (unlikely(rc)) {
 		spin_lock_irqsave(&si->scsi_queue_lock, flags);
+		fsp->cmd->SCp.ptr = NULL;
 		list_del(&fsp->list);
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 	}

