From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 43/64] libfc: discovery restart sequence error fix
Date: Tue, 25 Aug 2009 14:02:17 -0700
Message-ID: <20090825210217.1553.85345.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbZHYVCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:15 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When an RSCN is received during fabric discovery, it restarts.
After the restart, disc->seq_count was incremented, so when
the first frame was received, it was considered "out of sequence".
That left the state disc->active, preventing further discoveries.

Change to advance the sequence count before parsing, so that it
won't be changed after a potential restart.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index ddf4944..fd3a6b2 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -629,11 +629,10 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 			    seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
 	}
 	if (buf) {
+		disc->seq_count++;
 		error = fc_disc_gpn_ft_parse(disc, buf, len);
 		if (error)
 			fc_disc_error(disc, fp);
-		else
-			disc->seq_count++;
 	}
 	fc_frame_free(fp);
 

