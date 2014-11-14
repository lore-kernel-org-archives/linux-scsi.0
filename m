From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 04/13] hpsa: correct off-by-one sizing of chained SG block
Date: Fri, 14 Nov 2014 17:26:43 -0600
Message-ID: <20141114232643.20808.51191.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:13286 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422890AbaKNXZJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:09 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Correct the size calculation of the chained SG block

Signed-off-by: Don Brace <don.brace@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Reviewed-by: Stephen M. Cameron <stephenmcameron@gmail.com>
Reviewed-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ed92e9e..f57081c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6321,11 +6321,11 @@ static void hpsa_find_board_params(struct ctlr_info *h)
 	h->max_cmd_sg_entries = 31;
 	if (h->maxsgentries > 512) {
 		h->max_cmd_sg_entries = 32;
-		h->chainsize = h->maxsgentries - h->max_cmd_sg_entries + 1;
+		h->chainsize = h->maxsgentries - h->max_cmd_sg_entries;
 		h->maxsgentries--; /* save one for chain pointer */
 	} else {
-		h->maxsgentries = 31; /* default to traditional values */
 		h->chainsize = 0;
+		h->maxsgentries = 31; /* default to traditional values */
 	}
 
 	/* Find out what task management functions are supported and cache */

