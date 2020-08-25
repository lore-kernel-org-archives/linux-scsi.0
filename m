Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E38C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 04:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0039A2072D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 04:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgHYE5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 00:57:23 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:33396 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728848AbgHYE5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 00:57:21 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id EBFFD181D330D;
        Tue, 25 Aug 2020 04:57:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: star96_3d1160527059
X-Filterd-Recvd-Size: 3599
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 04:57:18 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/29] scai/arm: Avoid comma separated statements
Date:   Mon, 24 Aug 2020 21:56:17 -0700
Message-Id: <be30bb0f24a5fb4f70ca8ed7027ca7555816a3fb.1598331149.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1598331148.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use semicolons and braces.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/arm/cumana_2.c | 19 +++++++++++--------
 drivers/scsi/arm/eesox.c    |  9 +++++----
 drivers/scsi/arm/powertec.c |  9 +++++----
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 29294f0ef8a9..9dcd912267e6 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -166,14 +166,15 @@ cumanascsi_2_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 
 		bufs = copy_SCp_to_sg(&info->sg[0], SCp, NR_SG);
 
-		if (direction == DMA_OUT)
-			map_dir = DMA_TO_DEVICE,
-			dma_dir = DMA_MODE_WRITE,
+		if (direction == DMA_OUT) {
+			map_dir = DMA_TO_DEVICE;
+			dma_dir = DMA_MODE_WRITE;
 			alatch_dir = ALATCH_DMA_OUT;
-		else
-			map_dir = DMA_FROM_DEVICE,
-			dma_dir = DMA_MODE_READ,
+		} else {
+			map_dir = DMA_FROM_DEVICE;
+			dma_dir = DMA_MODE_READ;
 			alatch_dir = ALATCH_DMA_IN;
+		}
 
 		dma_map_sg(dev, info->sg, bufs, map_dir);
 
@@ -326,10 +327,12 @@ cumanascsi_2_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
 				cumanascsi_2_terminator_ctl(host, 0);
 			else
 				ret = -EINVAL;
-		} else
+		} else {
 			ret = -EINVAL;
-	} else
+		}
+	} else {
 		ret = -EINVAL;
+	}
 
 	return ret;
 }
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 591ae2a6dd74..5eb2415dda9d 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -165,12 +165,13 @@ eesoxscsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 
 		bufs = copy_SCp_to_sg(&info->sg[0], SCp, NR_SG);
 
-		if (direction == DMA_OUT)
-			map_dir = DMA_TO_DEVICE,
+		if (direction == DMA_OUT) {
+			map_dir = DMA_TO_DEVICE;
 			dma_dir = DMA_MODE_WRITE;
-		else
-			map_dir = DMA_FROM_DEVICE,
+		} else {
+			map_dir = DMA_FROM_DEVICE;
 			dma_dir = DMA_MODE_READ;
+		}
 
 		dma_map_sg(dev, info->sg, bufs, map_dir);
 
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index d99ef014528e..9cc73da4e876 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -138,12 +138,13 @@ powertecscsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 
 		bufs = copy_SCp_to_sg(&info->sg[0], SCp, NR_SG);
 
-		if (direction == DMA_OUT)
-			map_dir = DMA_TO_DEVICE,
+		if (direction == DMA_OUT) {
+			map_dir = DMA_TO_DEVICE;
 			dma_dir = DMA_MODE_WRITE;
-		else
-			map_dir = DMA_FROM_DEVICE,
+		} else {
+			map_dir = DMA_FROM_DEVICE;
 			dma_dir = DMA_MODE_READ;
+		}
 
 		dma_map_sg(dev, info->sg, bufs, map_dir);
 
-- 
2.26.0

