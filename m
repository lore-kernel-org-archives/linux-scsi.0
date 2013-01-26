From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Initialize the sglist
Date: Fri, 25 Jan 2013 18:19:14 -0800
Message-ID: <1359166754-8541-1-git-send-email-kys@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
