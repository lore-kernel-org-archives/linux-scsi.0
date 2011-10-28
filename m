From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 2/4] libfc: fix checking FC_TYPE_BLS
Date: Fri, 28 Oct 2011 11:34:12 -0700
Message-ID: <20111028183412.15165.1173.stgit@localhost6.localdomain6>
References: <20111028183305.15165.96974.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab1J1Spf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2011 14:45:35 -0400
In-Reply-To: <20111028183305.15165.96974.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: robert.w.love@intel.com, Vasu Dev <vasu.dev@intel.com>, Yi Zou <yi.zou@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Its checked after skb freed, so instead have fh_type
cached and then check FC_TYPE_BLS against cached
fh_type value.

This wrong check was causing double exch locking as
reported by Bhanu at
https://lists.open-fcoe.org/pipermail/devel/2011-October/011793.html

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 7c055fd..81235f3 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -469,6 +469,7 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	int error;
 	u32 f_ctl;
+	u8 fh_type = fh->fh_type;
 
 	ep = fc_seq_exch(sp);
 	WARN_ON((ep->esb_stat & ESB_ST_SEQ_INIT) != ESB_ST_SEQ_INIT);
@@ -493,7 +494,7 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 	 */
 	error = lport->tt.frame_send(lport, fp);
 
-	if (fh->fh_type == FC_TYPE_BLS)
+	if (fh_type == FC_TYPE_BLS)
 		return error;
 
 	/*

