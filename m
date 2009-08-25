From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 45/64] libfc: handle discovery failure more correctly.
Date: Tue, 25 Aug 2009 14:02:27 -0700
Message-ID: <20090825210227.1553.90637.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbZHYVC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:26 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Abhijeet Joglekar wrote: "In gpn_ft_resp, if the payload is short,
or unexpected response or out of sequence frame, then we just
return and do nothing. We should either enter fc_disc_done()
with DISC_EV_FAIL which will then restart any queued discovery
requests or call lport module which will reset local port,
or we should call fc_disc_error() so that the gpn_ft is retried.

The situation as is causes discovery to remain pending and never
get restarted, in these rare cases.  We saw this due to a coding
bug in fc_disc before.  The only ways it could happen would be
bugs, packet corruption or an FC fabric problem.

Change it to fail discovery.  The local port will restart
discovery, although it probably should just give up until
the next link flap.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 819ec62..844376c 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -606,6 +606,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 		if (!cp) {
 			FC_DISC_DBG(disc, "GPN_FT response too short, len %d\n",
 				    fr_len(fp));
+			event = DISC_EV_FAILED;
 		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
 
 			/* Accepted, parse the response. */
@@ -619,6 +620,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 		} else {
 			FC_DISC_DBG(disc, "GPN_FT unexpected response code "
 				    "%x\n", ntohs(cp->ct_cmd));
+			event = DISC_EV_FAILED;
 		}
 	} else if (fr_sof(fp) == FC_SOF_N3 && seq_cnt == disc->seq_count) {
 		error = fc_disc_gpn_ft_parse(disc, fh + 1, len);
@@ -626,6 +628,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 		FC_DISC_DBG(disc, "GPN_FT unexpected frame - out of sequence? "
 			    "seq_cnt %x expected %x sof %x eof %x\n",
 			    seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
+		event = DISC_EV_FAILED;
 	}
 	if (error)
 		fc_disc_error(disc, fp);

