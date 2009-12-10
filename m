From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/3] libfc: remote port gets stuck in restart state without
	really restarting
Date: Thu, 10 Dec 2009 09:59:20 -0800
Message-ID: <20091210175920.12227.814.stgit@localhost.localdomain>
References: <20091210175915.12227.50544.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5074 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761225AbZLJR7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 12:59:17 -0500
In-Reply-To: <20091210175915.12227.50544.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

We ran into a scenario where a remote port goes into RESTART state, but
never gets added to scsi transport. The running vmcore showed the following:
a) Port was in RESTART state
b) rdata->event was STOP
c) no work gets scheduled for the remote work to fc_rport_work

After this point, shut/no-shut of the remote port did not cause the port
to get re-discovered. The port would move betwen DELETE and RESTART states,
but the event would always be STOP, no work would get scheduled to
fc_rport_work and the port would not get added to scsi_transport.

The problem is that rdata->event is not set to NONE after a port is
restarted. After this point, no more work gets scheduled for the remote port
since new work is scheduled only if rdata->event is non-NONE. So, the event
and state keep changing, but fc_rport_work does not get scheduled to actually
handle the event.

Here's a transition of states that explains the above observation:

) Port is first in READY State, event is NONE

2) RSCN on shut, port goes to DELETED, event is stop

3) Before fc_rport_work runs, RSCN on no-shut, port goes to RESTART, event is
still STOP

4) fc_rport_work gets scheduled, removes the port from transport, sees state
as RESTART, begins the PLOGI state machine, event remains as STOP (event NOT
changed to NONE, this is the bug)

5) Plogi state machine completes, port state goes to READY, event goes to
READY, but no work is scheduled since event was STOP (non-NONE) before.
Fc_rport_work is not scheduled, port remains in READY state, but is not added
to transport.

Things are broken at this point. Libfc rport is ready, but no transport rport
created.

6) now a shut causes port state to change to DELETE, event to change to STOP,
no work gets scheduled

7) no-shut causes port state to change to RESTART, event remains at STOP,
no work gets scheduled

(6) and (7) now get repeated everytime we do shut/no-shut. No way to get out
of this state. Fcc reset does not help too.

Only way to get out is to load/unload module.

Fix is to set rdata->event to NONE while processing the STOP/LOGO/FAILED
events, inside the discovery and rport locks.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 35ca0e7..0230052 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -310,6 +310,7 @@ static void fc_rport_work(struct work_struct *work)
 				restart = 1;
 			else
 				list_del(&rdata->peers);
+			rdata->event = RPORT_EV_NONE;
 			mutex_unlock(&rdata->rp_mutex);
 			mutex_unlock(&lport->disc.disc_mutex);
 		}

