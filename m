From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 14/24] hpsa: check that simple mode is supported
Date: Thu, 27 May 2010 15:13:53 -0500
Message-ID: <20100527201353.3116.64378.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40250 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:15 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: check that simple mode is supported
before trying to enter simple mode transport method.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bb1b86e..61fd71e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3421,6 +3421,11 @@ static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
 static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
 {
 	int i;
+	u32 trans_support;
+
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & SIMPLE_MODE))
+		return -ENOTSUPP;
 
 	h->max_commands = readl(&(h->cfgtable->CmdsOutMax));
 	/* Update the field, and then ring the doorbell */

