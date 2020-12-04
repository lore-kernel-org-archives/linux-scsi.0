Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35666C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1005C22D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgLDXCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:02:43 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:21231 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgLDXCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122963; x=1638658963;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JDLY+/Z0WqZwPscaiXoly3dC+qxR+BHbvdoWrmgmWo0=;
  b=uct5d5dZY06xzvp/sUa0LMBxM8Jv/ibE3S6psh/X5HOSLT3tTs4HW2wK
   5KhUDpuTgMVRdDeohBI1lwC/3/N9bRwsCBoP4HM2BrgDAWnC3mb3dkHK+
   yY/2Tqg5ePfCQks4+wc/GpNcXn/OnMbEKINDhUiM2yK8lwYgNlVeYumH1
   BWP9ral5Er0h4doKtqf+Mh0Iyok4E8ELKUJKfwx0wPk5M6OigZmrpXV6W
   hf/0ODCsqjB7XU/HjQzTbOTgyLY5DsuV8SUFSFz9f3o+BDjmIf9gu1WcL
   vMeQp/+Y5FPDx+66cQlrqxhnvbMKgwdOS5j9TsFM2TfNUhPik5UrbkayQ
   w==;
IronPort-SDR: te07XTUooOpFfVicMEJNOyMyHgxhV0cr0j0FTaotcanDgsSdkC1/FkEhIfHCcfe1B4GWXgaTPj
 PyCKdQItjCYYylu8hVdCOmqqyVy4okAztj9e3e7gRUS1Isjkm+pVepFZsfa7wHk4rTwLLQ7gEi
 dvEI5o2n2nsliYNnoKHwQvP7bZOEt/MRFZX7avGm9V6zk7ukvs/byAfEJzbVbCgRrJG0Uoczax
 T1j0zljQMTECQnnb5qDLCcdMKQrahGfUgANupZ20+X80R1cfQVmgE0IhVjZ839aSJGorvHWt5P
 lUE=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="36192813"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:01:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:01:08 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:01:08 -0700
Subject: [PATCH 03/25] smartpqi: refactor build sg list code
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:01:08 -0600
Message-ID: <160712286807.21372.1703523876231635148.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* No functional changes.
* Factor out code common to all s/g list building.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  101 ++++++++++++++-------------------
 1 file changed, 42 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 99ea384d8211..553284a40d00 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4794,16 +4794,52 @@ static inline void pqi_set_sg_descriptor(
 	put_unaligned_le32(0, &sg_descriptor->flags);
 }
 
+static unsigned int pqi_build_sg_list(struct pqi_sg_descriptor *sg_descriptor,
+	struct scatterlist *sg, int sg_count, struct pqi_io_request *io_request,
+	int max_sg_per_iu, bool *chained)
+{
+	int i;
+	unsigned int num_sg_in_iu;
+
+	*chained = false;
+	i = 0;
+	num_sg_in_iu = 0;
+	max_sg_per_iu--;	/* Subtract 1 to leave room for chain marker. */
+
+	while (1) {
+		pqi_set_sg_descriptor(sg_descriptor, sg);
+		if (!*chained)
+			num_sg_in_iu++;
+		i++;
+		if (i == sg_count)
+			break;
+		sg_descriptor++;
+		if (i == max_sg_per_iu) {
+			put_unaligned_le64((u64)io_request->sg_chain_buffer_dma_handle,
+				&sg_descriptor->address);
+			put_unaligned_le32((sg_count - num_sg_in_iu) * sizeof(*sg_descriptor),
+				&sg_descriptor->length);
+			put_unaligned_le32(CISS_SG_CHAIN, &sg_descriptor->flags);
+			*chained = true;
+			num_sg_in_iu++;
+			sg_descriptor = io_request->sg_chain_buffer;
+		}
+		sg = sg_next(sg);
+	}
+
+	put_unaligned_le32(CISS_SG_LAST, &sg_descriptor->flags);
+
+	return num_sg_in_iu;
+}
+
 static int pqi_build_raid_sg_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_raid_path_request *request, struct scsi_cmnd *scmd,
 	struct pqi_io_request *io_request)
 {
-	int i;
 	u16 iu_length;
 	int sg_count;
 	bool chained;
 	unsigned int num_sg_in_iu;
-	unsigned int max_sg_per_iu;
 	struct scatterlist *sg;
 	struct pqi_sg_descriptor *sg_descriptor;
 
@@ -4819,36 +4855,10 @@ static int pqi_build_raid_sg_list(struct pqi_ctrl_info *ctrl_info,
 
 	sg = scsi_sglist(scmd);
 	sg_descriptor = request->sg_descriptors;
-	max_sg_per_iu = ctrl_info->max_sg_per_iu - 1;
-	chained = false;
-	num_sg_in_iu = 0;
-	i = 0;
 
-	while (1) {
-		pqi_set_sg_descriptor(sg_descriptor, sg);
-		if (!chained)
-			num_sg_in_iu++;
-		i++;
-		if (i == sg_count)
-			break;
-		sg_descriptor++;
-		if (i == max_sg_per_iu) {
-			put_unaligned_le64(
-				(u64)io_request->sg_chain_buffer_dma_handle,
-				&sg_descriptor->address);
-			put_unaligned_le32((sg_count - num_sg_in_iu)
-				* sizeof(*sg_descriptor),
-				&sg_descriptor->length);
-			put_unaligned_le32(CISS_SG_CHAIN,
-				&sg_descriptor->flags);
-			chained = true;
-			num_sg_in_iu++;
-			sg_descriptor = io_request->sg_chain_buffer;
-		}
-		sg = sg_next(sg);
-	}
+	num_sg_in_iu = pqi_build_sg_list(sg_descriptor, sg, sg_count, io_request,
+		ctrl_info->max_sg_per_iu, &chained);
 
-	put_unaligned_le32(CISS_SG_LAST, &sg_descriptor->flags);
 	request->partial = chained;
 	iu_length += num_sg_in_iu * sizeof(*sg_descriptor);
 
@@ -4862,12 +4872,10 @@ static int pqi_build_aio_sg_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_aio_path_request *request, struct scsi_cmnd *scmd,
 	struct pqi_io_request *io_request)
 {
-	int i;
 	u16 iu_length;
 	int sg_count;
 	bool chained;
 	unsigned int num_sg_in_iu;
-	unsigned int max_sg_per_iu;
 	struct scatterlist *sg;
 	struct pqi_sg_descriptor *sg_descriptor;
 
@@ -4884,35 +4892,10 @@ static int pqi_build_aio_sg_list(struct pqi_ctrl_info *ctrl_info,
 
 	sg = scsi_sglist(scmd);
 	sg_descriptor = request->sg_descriptors;
-	max_sg_per_iu = ctrl_info->max_sg_per_iu - 1;
-	chained = false;
-	i = 0;
 
-	while (1) {
-		pqi_set_sg_descriptor(sg_descriptor, sg);
-		if (!chained)
-			num_sg_in_iu++;
-		i++;
-		if (i == sg_count)
-			break;
-		sg_descriptor++;
-		if (i == max_sg_per_iu) {
-			put_unaligned_le64(
-				(u64)io_request->sg_chain_buffer_dma_handle,
-				&sg_descriptor->address);
-			put_unaligned_le32((sg_count - num_sg_in_iu)
-				* sizeof(*sg_descriptor),
-				&sg_descriptor->length);
-			put_unaligned_le32(CISS_SG_CHAIN,
-				&sg_descriptor->flags);
-			chained = true;
-			num_sg_in_iu++;
-			sg_descriptor = io_request->sg_chain_buffer;
-		}
-		sg = sg_next(sg);
-	}
+	num_sg_in_iu = pqi_build_sg_list(sg_descriptor, sg, sg_count, io_request,
+		ctrl_info->max_sg_per_iu, &chained);
 
-	put_unaligned_le32(CISS_SG_LAST, &sg_descriptor->flags);
 	request->partial = chained;
 	iu_length += num_sg_in_iu * sizeof(*sg_descriptor);
 

