From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/27] libfc: fix mem leak in fc_seq_assign()
Date: Tue, 30 Nov 2010 16:18:28 -0800
Message-ID: <20101201001828.18369.80904.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61256 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0LAASn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:43 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

There is a typo cleaned, which triggers memory leakage.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 46973d6..8bfb421 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1274,7 +1274,7 @@ static struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
 
 	list_for_each_entry(ema, &lport->ema_list, ema_list)
 		if ((!ema->match || ema->match(fp)) &&
-		    fc_seq_lookup_recip(lport, ema->mp, fp) != FC_RJT_NONE)
+		    fc_seq_lookup_recip(lport, ema->mp, fp) == FC_RJT_NONE)
 			break;
 	return fr_seq(fp);
 }

