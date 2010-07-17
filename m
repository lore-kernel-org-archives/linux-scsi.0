From: Dan Carpenter <error27@gmail.com>
Subject: [patch] scsi/initio: add GFP_KERNEL flag
Date: Sat, 17 Jul 2010 12:24:32 +0200
Message-ID: <20100717102432.GD17585@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40210 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759797Ab0GQK0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Jul 2010 06:26:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Daniel Mack <daniel@caiaq.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Calling scb = kzalloc(i, GFP_DMA) is not the right idea.  If this is
what we really wanted it would be better to specify it explicitly as 
kzalloc(i, GFP_NOWAIT | GFP_DMA).  But in this case it's OK to wait so
I changed it to use GFP_KERNEL.  Also I added a __GFP_NOWARN, since we
expect the allocation to fail occasionaly (and we just try allocate a 
smaller amount on the next time through the loop).

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index a771416..a4baa44 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2885,7 +2885,8 @@ static int initio_probe_one(struct pci_dev *pdev,
 
 	for (; num_scb >= MAX_TARGETS + 3; num_scb--) {
 		i = num_scb * sizeof(struct scsi_ctrl_blk);
-		if ((scb = kzalloc(i, GFP_DMA)) != NULL)
+		scb = kzalloc(i, GFP_KERNEL | GFP_DMA | __GFP_NOWARN);
+		if (scb)
 			break;
 	}
 
