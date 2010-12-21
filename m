From: Dan Carpenter <error27@gmail.com>
Subject: [patch -next] libfc: dereferencing ERR_PTR in fc_tm_done()
Date: Tue, 21 Dec 2010 07:01:37 +0300
Message-ID: <20101221040137.GE1936@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If we goto out, then it tries to call kfree_skb() on an ERR_PTR which
will oops.  Just return directly.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5962d1a..a918807 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1321,7 +1321,7 @@ static void fc_tm_done(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		 *
 		 * scsi-eh will escalate for when either happens.
 		 */
-		goto out;
+		return;
 	}
 
 	if (fc_fcp_lock_pkt(fsp))
