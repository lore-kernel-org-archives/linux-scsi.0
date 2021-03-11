Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21B0C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C9264F88
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhCKUPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:15:51 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18753 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhCKUP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493728; x=1647029728;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6TGNgIwdBiRZPzM2mBnDH+wrkdXMaNkIiq3EO9/U1pc=;
  b=oEdA8DXEpn0cZ30fzecsszXOR0q9FQo47TFjpDPzc1xSpiO229xvoN+V
   98UmXkRqTyAPWWlrf7eNwSOVxF4D87axjmdaqky3dJ2XxscxHaYTILp7o
   GhZcny1iHkXLPrhQJl4+u/mIFqDse8R+lAsJ4G+eu4jlEvG1xkZSok2sz
   9juRLwcse+m7sM7hFYKPOGx438Q+mLxhGFt8KZYVBa/O21Z4Ne1syYd+A
   CKEHNbkCGf7IiH2tP/iTbp4wAkjMOLfBY67yXkaYKiNYFondOzPibU/pA
   TfvyE6PtErmRM5ro1ybuHjgItIIsYrMBJjCZGK6vworKBgpR7tPj6cY6N
   w==;
IronPort-SDR: Y9ALqx19mdm/TvaqUFHMlTQeLzK6uiEE56jaRIeHqtmBCHvXu8vUeZYZc89/TCsjR7IeWrH+nj
 fi1tDZCw7ysf/MLclkvQHLqVDkyFC8xSWGNJ4wdwnQ2KlloUCOISf1kS+h6qU+vw1KytMYHVgT
 zZH0/rdLX6DNkcsX6OSPhmhmED/81eoprJlQ4fHky4Ga4WmH4RguIwJtc6WMJ0wL+z5e3LnoXs
 qct7kszth4PNcpfj/Wgu0dTqtoNi7rCN7sL5EA98rzO6yjnTU4AryyMLBG4sc+jpwiAdQmXgjG
 wZw=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="47186592"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:15:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:15:22 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:15:21 -0700
Subject: [PATCH V5 05/31] smartpqi: refactor build sg list code
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:15:21 -0600
Message-ID: <161549372147.25025.9706613054649682229.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* No functional changes.
* Factor out code common to all s/g list building.
* Prepare for new AIO functionality.
  AIO - Accelerated I/O, AIO requests go directly to disk

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  101 ++++++++++++++-------------------
 1 file changed, 42 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c895d32952c1..0eb8d4744e3d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4857,16 +4857,52 @@ static inline void pqi_set_sg_descriptor(
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
 
@@ -4882,36 +4918,10 @@ static int pqi_build_raid_sg_list(struct pqi_ctrl_info *ctrl_info,
 
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
 
@@ -4925,12 +4935,10 @@ static int pqi_build_aio_sg_list(struct pqi_ctrl_info *ctrl_info,
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
 
@@ -4947,35 +4955,10 @@ static int pqi_build_aio_sg_list(struct pqi_ctrl_info *ctrl_info,
 
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
 

