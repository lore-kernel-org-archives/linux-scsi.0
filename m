From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 1/1] Drivers: scsi: storvsc: Initialize the sglist
Date: Wed,  6 Feb 2013 05:15:28 -0800
Message-ID: <1360156528-11240-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47547
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3BFMrw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Feb 2013 07:47:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org

Properly initialize scatterlist before using it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/storvsc_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 270b3cf..5ada1d0 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -467,6 +467,7 @@ static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 	if (!bounce_sgl)
 		return NULL;
 
+	sg_init_table(bounce_sgl, num_pages);
 	for (i = 0; i < num_pages; i++) {
 		page_buf = alloc_page(GFP_ATOMIC);
 		if (!page_buf)
-- 
1.7.4.1

