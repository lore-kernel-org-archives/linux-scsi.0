Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B065CC2BBCA
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ABFF23A79
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgLHUQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:16:05 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:32318 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgLHUPX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:15:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607458523; x=1638994523;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xnriuakHErWSuQ/TNdXXtkqup1jqGM9VGmYc1FDQgf4=;
  b=Zx6m+LDSvhUmzdfxP8+k0I1sg4C5V3YMH+FVLZRtp4BLKT5AplTscynE
   Mjwen6m01OS5WEqPVzuqDi/kQ10/BrxSOdyg3Yk1wSl+mKmyfJjcZkaZw
   BVeFayj145W+PKP3Jy2o0b6pVcnYkgFWgVpFiSPWRriCmcVcWDLPik9kW
   xF/NyH7ZzrtUDgbSHCFrt4/ISVt8NJaCEW0Zne0aQhSGvkRpBBQwCIkqe
   RU6OffhwdVBx586gBKEu+wLMnBSbPx577XBRKfNL+v1msf5Jnrr9n1muF
   dIoHEAWgQ7BjBI2DY9/vd/rBkPXhSFvwD51usH2KXUEHJOvjf1fvyfQZG
   Q==;
IronPort-SDR: ldjL9+Tv0lYQ3BkfSAzjSz3r3S5JcJn4A0bBCVdPslzE3JOPvUOkr/ri3ohyGXxrJq2cxFcVEY
 S8f+yLWtsuZjKDXf9WAe+GxjCqSlXOkOOCMiD1ALoEXiHuXwYPo2RsCGcVXhnDCe9UI2Fdtjlg
 UgtHJ9YZiUwmJX6Gnd/O9W/EwUiYcT3JeEBd3eaEtEAexI30TsP89Y8302nZ8O9T2GPmlPKZop
 EhNcMVJyB6dOqgjgzNcSIUQW+UXFEyMO0a6BBfG2asgHOxpSxuyEB07dozNVK3hT2Dfa0CsFan
 g50=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="101443181"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:36:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:36:53 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:36:52 -0700
Subject: [PATCH V2 03/25] smartpqi: refactor build sg list code
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:36:52 -0600
Message-ID: <160745621250.13450.3396484024045806277.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index 2348b9f24d8c..6bcb037ae9d7 100644
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
 

