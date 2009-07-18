From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/scsi: possible double spin_lock_irqsave
Date: Sat, 18 Jul 2009 17:22:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907181722060.26792@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:50537 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZGRPXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Jul 2009 11:23:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If both the test on rport and the call to get_device fail, then the lock is
already held.  The re-lock is thus moved up into the two branches.

On the other hand if kref_put should not be called with the lock held then
something else should be done.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression lock1,lock2;
expression flags;
@@

*spin_lock_irqsave(lock1,flags)
... when != flags
*spin_lock_irqsave(lock2,flags)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/ibmvscsi/ibmvfc.c      |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 166d964..d2b88bd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4278,15 +4278,16 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 				if (!rport) {
 					spin_unlock_irqrestore(vhost->host->host_lock, flags);
 					ibmvfc_tgt_add_rport(tgt);
+					spin_lock_irqsave(vhost->host->host_lock, flags);
 				} else if (get_device(&rport->dev)) {
 					spin_unlock_irqrestore(vhost->host->host_lock, flags);
 					tgt_dbg(tgt, "Setting rport roles\n");
 					fc_remote_port_rolechg(rport, tgt->ids.roles);
 					put_device(&rport->dev);
+					spin_lock_irqsave(vhost->host->host_lock, flags);
 				}
 
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
-				spin_lock_irqsave(vhost->host->host_lock, flags);
 				break;
 			}
 		}
