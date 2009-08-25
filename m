From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 48/64] libfc: discovery gpn_ft parse bug
Date: Tue, 25 Aug 2009 14:02:43 -0700
Message-ID: <20090825210243.1553.48206.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbZHYVCl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:41 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

In fc_disc_gpn_ft_parse(), after fc_disc_done() is called, the
disc state is changed by setting buf_len = 0.  This is wrong
since the discovery may have restarted.   Instead, return
after calling fc_disc_done.

Also, return an error on memory allocation failure.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 3efdbba..a2410dc 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -479,6 +479,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	plen = len;
 	np = (struct fc_gpn_ft_resp *)bp;
 	tlen = disc->buf_len;
+	disc->buf_len = 0;
 	if (tlen) {
 		WARN_ON(tlen >= sizeof(*np));
 		plen = sizeof(*np) - tlen;
@@ -519,10 +520,12 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 			rdata = lport->tt.rport_create(lport, &ids);
 			if (rdata)
 				rdata->disc_id = disc->disc_id;
-			else
+			else {
 				printk(KERN_WARNING "libfc: Failed to allocate "
 				       "memory for the newly discovered port "
 				       "(%6x)\n", ids.port_id);
+				error = -ENOMEM;
+			}
 		}
 
 		if (np->fp_flags & FC_NS_FID_LAST) {
@@ -546,8 +549,6 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 			memcpy(&disc->partial_buf, np, len);
 		}
 		disc->buf_len = (unsigned char) len;
-	} else {
-		disc->buf_len = 0;
 	}
 	return error;
 }

