From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/12] libfc: Handle discovery failure during ctlr link down
Date: Fri, 10 Feb 2012 17:18:57 -0800
Message-ID: <20120211011857.7668.44467.stgit@localhost6.localdomain6>
References: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761225Ab2BKBS5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 20:18:57 -0500
In-Reply-To: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

While we wait for GPN_FT response, if the ctlr link goes down, the stack
generates a completion for GPN_FT with error FC_EXCH_CLOSED, and reports a
discovery error. Discovery is not retried in this case, and rightly so.
However, the 'pending' flag stays set, which does not allow subsequent
discovery to succeed as GPN_FT will never be issued. Fix it by clearing the
pending flag when the discovery fails due to GPN_FT failure.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_disc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 1d1b0c9..8e561e6 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -337,6 +337,13 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 			schedule_delayed_work(&disc->disc_work, delay);
 		} else
 			fc_disc_done(disc, DISC_EV_FAILED);
+	} else if (PTR_ERR(fp) == -FC_EX_CLOSED) {
+		/*
+		 * if discovery fails due to lport reset, clear
+		 * pending flag so that subsequent discovery can
+		 * continue
+		 */
+		disc->pending = 0;
 	}
 }
 

