From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 01/17] smartpqi: change aio sg processing
Date: Fri, 26 Aug 2016 11:44:11 -0500
Message-ID: <147222985137.31214.834009335820995162.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0044.outbound.protection.outlook.com ([104.47.41.44]:4736
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754244AbcHZQ77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 12:59:59 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Take advantage of controller improvements.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   68 +++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 906f1aa..418f636 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4263,48 +4263,58 @@ static int pqi_build_aio_sg_list(struct pqi_ctrl_info *ctrl_info,
 	int i;
 	u16 iu_length;
 	int sg_count;
-	unsigned int num_sg_in_iu = 0;
+	bool chained;
+	unsigned int num_sg_in_iu;
+	unsigned int max_sg_per_iu;
 	struct scatterlist *sg;
 	struct pqi_sg_descriptor *sg_descriptor;
 
 	sg_count = scsi_dma_map(scmd);
 	if (sg_count < 0)
 		return sg_count;
+
+	iu_length = offsetof(struct pqi_aio_path_request, sg_descriptors) -
+		PQI_REQUEST_HEADER_LENGTH;
+	num_sg_in_iu = 0;
+
 	if (sg_count == 0)
 		goto out;
 
-	if (sg_count <= ctrl_info->max_sg_per_iu) {
-		sg_descriptor = &request->sg_descriptors[0];
-		scsi_for_each_sg(scmd, sg, sg_count, i) {
-			pqi_set_sg_descriptor(sg_descriptor, sg);
-			sg_descriptor++;
-		}
-		put_unaligned_le32(CISS_SG_LAST,
-			&request->sg_descriptors[sg_count - 1].flags);
-		num_sg_in_iu = sg_count;
-	} else {
-		sg_descriptor = &request->sg_descriptors[0];
-		put_unaligned_le64((u64)io_request->sg_chain_buffer_dma_handle,
-			&sg_descriptor->address);
-		put_unaligned_le32(sg_count * sizeof(*sg_descriptor),
-			&sg_descriptor->length);
-		put_unaligned_le32(CISS_SG_CHAIN, &sg_descriptor->flags);
-
-		sg_descriptor = io_request->sg_chain_buffer;
-		scsi_for_each_sg(scmd, sg, sg_count, i) {
-			pqi_set_sg_descriptor(sg_descriptor, sg);
-			sg_descriptor++;
+	sg = scsi_sglist(scmd);
+	sg_descriptor = request->sg_descriptors;
+	max_sg_per_iu = ctrl_info->max_sg_per_iu - 1;
+	chained = false;
+	i = 0;
+
+	while (1) {
+		pqi_set_sg_descriptor(sg_descriptor, sg);
+		if (!chained)
+			num_sg_in_iu++;
+		i++;
+		if (i == sg_count)
+			break;
+		sg_descriptor++;
+		if (i == max_sg_per_iu) {
+			put_unaligned_le64(
+				(u64)io_request->sg_chain_buffer_dma_handle,
+				&sg_descriptor->address);
+			put_unaligned_le32((sg_count - num_sg_in_iu)
+				* sizeof(*sg_descriptor),
+				&sg_descriptor->length);
+			put_unaligned_le32(CISS_SG_CHAIN,
+				&sg_descriptor->flags);
+			chained = true;
+			num_sg_in_iu++;
+			sg_descriptor = io_request->sg_chain_buffer;
 		}
-		put_unaligned_le32(CISS_SG_LAST,
-			&io_request->sg_chain_buffer[sg_count - 1].flags);
-		num_sg_in_iu = 1;
-		request->partial = 1;
+		sg = sg_next(sg);
 	}
 
-out:
-	iu_length = offsetof(struct pqi_aio_path_request, sg_descriptors) -
-		PQI_REQUEST_HEADER_LENGTH;
+	put_unaligned_le32(CISS_SG_LAST, &sg_descriptor->flags);
+	request->partial = chained;
 	iu_length += num_sg_in_iu * sizeof(*sg_descriptor);
+
+out:
 	put_unaligned_le16(iu_length, &request->header.iu_length);
 	request->num_sg_descriptors = num_sg_in_iu;
 

