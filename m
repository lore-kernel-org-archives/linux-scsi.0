Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1575C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD31B64FD6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhCJUBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:01:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38386 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbhCJUBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:01:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406475; x=1646942475;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X0armAcG5eKsh8tStwU3a3eMsasHFZ2qKozsB1ayTYg=;
  b=NON1CP5d90XL2x4NPg6srQT0UYTguIu8NAdjch8eoxVwUk33tpYSaLLa
   Xk4En+EVew8Mc6jkDVoNpURAOuPUhD87/p18lvh021Oo4bqRPIljkTRjD
   2OhJUoFzACeiMMVDaeMMcKjkpHcGur+NMbGrf0NfcP2CzU8CMxDlFMDz5
   fIMzQeKVmw2ZZtAPertZQOrBTxNJulcfebmPiKoZQXC52G0RFzIuoW0rt
   khydGUMFVd9pp3CqEM1Gih6i4DUfYMt27jMczjEnwBlqJVKSt2aEAEPjl
   Nzh0lKb2LvB3/T/nEBxMHML3nEcd1lWmjbAVzdPrW++gBBWH2lAyPif9H
   Q==;
IronPort-SDR: Y3NPgdZx/NxsFsfzbcjE1IlK+JwRzwU/GpSOIIy8/QuuNfHwLKuISXyBBUa6Ohj63lZWBZvthU
 eFoNIXA95diYQbOyO0TXypIOfqTPTV4wnNPI1f3ZYyreJilPIpKbL+IPlUjhwkWo7BlcY8jRGa
 RTP2IIl8U7Cl/4ouhj2o2M7r4rZM+CeCwAtBguQuSJ63TLMqF62NwUupRIhyfhxeSrueVXq/5T
 OlcH+TuwrM2kg5zbdVGBQ44k3KTt7d8z6iJYmrIfcXhHybNrWsh7kcnJJIXvedb59dLrZGFgGs
 2xo=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="106699445"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:01:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:01:14 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:01:14 -0700
Subject: [PATCH V4 05/31] smartpqi: refactor build sg list code
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:01:14 -0600
Message-ID: <161540647412.19430.12123049623187141146.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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
index 0d615b20b23a..5d65464040df 100644
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
 

