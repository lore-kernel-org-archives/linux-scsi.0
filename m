Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D48C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 15:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD80D20C09
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 15:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="t7JVsYD0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbgIJPwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 11:52:51 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.4]:53493 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731445AbgIJPvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 11:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1599753063; i=@ts.fujitsu.com;
        bh=rG75sMFClI3DV1LszWtXpNzzF0rKWTvh+SSxS7qOeHs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=t7JVsYD0huip3mna1nddjdSBmOsDlTnyj5g7ylUOrKFwKdszQqXom5PCnWBSiT4YB
         zPgGdJvypAvTGnR59MvS/qgbmPYoT607nzZ1TrdLmJhgZcHisAqSqPYoFm5CSfRIjU
         eA/BQtBR+WPUxS/wB/ct5OtEsz9AW4Y/CYeafO3DMDBQDQXouBjj9yQujipyn5wFAh
         /9VIECvI8DE6OvqbrCgATg12HU0DU70LNvds5Swl1rf3+F3WEBI/dlcMBPaK+GM80O
         reKrHwG4++76/Thsqbfjkb5BMndn2zUAGK4j017dR8gcsSm8OiZR056kgiqVUpiwKm
         hOdrteMuf7NZw==
Received: from [100.112.193.134] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-west-1.aws.symcld.net id 44/FD-17694-66B4A5F5; Thu, 10 Sep 2020 15:51:02 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRWlGSWpSXmKPExsViZ8MRopvmHRV
  vMH2hokX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE1o322VME6
  m4rrSx6wNzB+Nehi5OIQEpjMKNG/8g4zhDOdUWLFm0esXYycHGwCBhIrJt1nAUmICKxhlFh5Z
  x4zSIJZQE9i2r917F2MHBzCAs4S/auEQcIsAqoSe6d+AOvlFbCT2LaylRHElhCQl+g4MJkFxO
  YUsJc48XcOE4gtBFTT+3AJywRG7gWMDKsYLZKKMtMzSnITM3N0DQ0MdA0NjXQNLU2A2EgvsUo
  3US+1VLc8tbhE11AvsbxYr7gyNzknRS8vtWQTIzBIUgoOHdjBuOzNB71DjJIcTEqivAKOUfFC
  fEn5KZUZicUZ8UWlOanFhxhlODiUJHiNvYBygkWp6akVaZk5wICFSUtw8CiJ8F73BErzFhck5
  hZnpkOkTjEqSonzWoIkBEASGaV5cG2wKLnEKCslzMvIwMAgxFOQWpSbWYIq/4pRnINRCagCZD
  tPZl4J3PRXQIuZgBY3ykeCLC5JREhJNTDlxynp995P2XnS1vf82oqQTS4BErIV07naV5g72Ct
  0BhyTnbbstTpn697/t+fKO3tsSXy2lVdzo1B8zny2h7Wq19eqtNm/2u3o82OdqcZnxZgcvbmZ
  1W5HHf7Pcf3RuThlZlPedkk57okpq394p/9KyDbSckn8ufX3f4agv6LWi9m9Qy96Hz0ja/K+v
  83kZcmzT9bbZ25ofN+4Q2SFU/bRqeVB7/X+2ciznlyqrJz+Pvb1eiW3bfl9r6wFSrdyyl81K3
  XvuJkQlTDxRenkNp4pa4v+2afqXue44a6SqD71VK4styPrR96MkPXn1myY/ErW0jVk18l2u8Z
  HPT1790e/F1mV7ah78G5QZJP9ASWW4oxEQy3mouJEACre3C8NAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-15.tower-271.messagelabs.com!1599753061!537101!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.60.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 11710 invoked from network); 10 Sep 2020 15:51:02 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-15.tower-271.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Sep 2020 15:51:02 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 08AFow90028089;
        Thu, 10 Sep 2020 16:50:58 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id D5C3E20639;
        Thu, 10 Sep 2020 17:50:55 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 3/3] scsi: target: tcmu: optimize scatter_data_area
Date:   Thu, 10 Sep 2020 17:50:41 +0200
Message-Id: <20200910155041.17654-4-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scatter_data_area has two purposes:
 1) create the iovs for data area buffer of a SCSI cmd
 2) If there is data in DMA_TO_DEVICE direction, it copies
   the data from sg_list to data area buffer.
Both is done in a common loop.

In case of DMA_FROM_DEVICE data transfer, scatter_data_area is
called with parameter copy_data = false. But this flag is used
just to skip memcpy() for data, while radix_tree_lookup still
is called for every dbi of the area area buffer, and kmap and
kunmap are called for every page from sg_list and data_area as
well as flush_dcache_page() for the data area pages.
Since the only thing to do with copy_data = false would be to
set up the iovs, this is a noticeable overhead.
Therefore I reworked the iov creation in the main loop of
scatter_data_area providing the new function new_block_to_iov.
Based on this I created the short new function tcmu_setup_iovs
that only writes the iovs with no overhead.
This new function is now called instead of scatter_data_area
for bidi buffers and for data buffers in those cases, where
memcpy would have been skipped.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 139 +++++++++++++++++---------------------
 1 file changed, 63 insertions(+), 76 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5587bd4d1060..18798c5422c7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -181,6 +181,8 @@ struct tcmu_cmd {
 	uint32_t dbi_cur;
 	uint32_t *dbi;
 
+	uint32_t data_len_bidi;
+
 	unsigned long deadline;
 
 #define TCMU_CMD_BIT_EXPIRED 0
@@ -579,9 +581,47 @@ static inline void tcmu_cmd_set_block_cnts(struct tcmu_cmd *cmd)
 			len += se_cmd->t_bidi_data_sg[i].length;
 		cmd->dbi_bidi_cnt = DIV_ROUND_UP(len, DATA_BLOCK_SIZE);
 		cmd->dbi_cnt += cmd->dbi_bidi_cnt;
+		cmd->data_len_bidi = len;
 	}
 }
 
+static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+			    struct iovec **iov, int prev_dbi, int *remain)
+{
+	/* Get the next dbi */
+	int dbi = tcmu_cmd_get_dbi(cmd);
+	/* Do not add more than DATA_BLOCK_SIZE to iov */
+	int len = min_t(int, DATA_BLOCK_SIZE, *remain);
+
+	*remain -= len;
+	/*
+	 * The following code will gather and map the blocks to the same iovec
+	 * when the blocks are all next to each other.
+	 */
+	if (dbi != prev_dbi + 1) {
+		/* dbi is not next to previous dbi, so start new iov */
+		if (prev_dbi >= 0)
+			(*iov)++;
+		/* write offset relative to mb_addr */
+		(*iov)->iov_base = (void __user *)
+				(udev->data_off + dbi * DATA_BLOCK_SIZE);
+	}
+	(*iov)->iov_len += len;
+
+	return dbi;
+}
+
+static void tcmu_setup_iovs(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+			    struct iovec **iov, int data_length)
+{
+	/* start value of dbi + 1 must not be a valid dbi */
+	int dbi = -2;
+
+	/* We prepare the IOVs for DMA_FROM_DEVICE transfer direction */
+	while (data_length > 0)
+		dbi = new_block_to_iov(udev, cmd, iov, dbi, &data_length);
+}
+
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
@@ -646,45 +686,22 @@ static inline size_t head_to_end(size_t head, size_t size)
 	return size - head;
 }
 
-static inline void new_iov(struct iovec **iov, bool first)
-{
-	struct iovec *iovec;
-
-	if (!first)
-		(*iov)++;
-
-	iovec = *iov;
-	memset(iovec, 0, sizeof(struct iovec));
-}
-
 #define UPDATE_HEAD(head, used, size) smp_store_release(&head, ((head % size) + used) % size)
 
-/* offset is relative to mb_addr */
-static inline size_t get_block_offset_user(struct tcmu_dev *dev,
-		int dbi, int remaining)
-{
-	return dev->data_off + dbi * DATA_BLOCK_SIZE +
-		DATA_BLOCK_SIZE - remaining;
-}
-
-static inline size_t iov_tail(struct iovec *iov)
-{
-	return (size_t)iov->iov_base + iov->iov_len;
-}
-
-static void scatter_data_area(struct tcmu_dev *udev,
-	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
-	unsigned int data_nents, struct iovec **iov, bool copy_data)
+static void scatter_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
+			      struct iovec **iov)
 {
-	int i, dbi;
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+	/* start value of dbi + 1 must not be a valid dbi */
+	int i, dbi = -2;
 	int block_remaining = 0;
+	int data_len = se_cmd->data_length;
 	void *from, *to = NULL;
-	size_t copy_bytes, to_offset, offset;
+	size_t copy_bytes, offset;
 	struct scatterlist *sg;
 	struct page *page;
-	bool first = true;
 
-	for_each_sg(data_sg, sg, data_nents, i) {
+	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, i) {
 		int sg_remaining = sg->length;
 		from = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
@@ -694,50 +711,19 @@ static void scatter_data_area(struct tcmu_dev *udev,
 					kunmap_atomic(to);
 				}
 
-				block_remaining = DATA_BLOCK_SIZE;
-				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
+				/* get next dbi and add to IOVs */
+				dbi = new_block_to_iov(udev, tcmu_cmd, iov, dbi,
+						       &data_len);
 				page = tcmu_get_block_page(udev, dbi);
 				to = kmap_atomic(page);
+				block_remaining = DATA_BLOCK_SIZE;
 			}
 
-			/*
-			 * Covert to virtual offset of the ring data area.
-			 */
-			to_offset = get_block_offset_user(udev, dbi,
-					block_remaining);
-
-			/*
-			 * The following code will gather and map the blocks
-			 * to the same iovec when the blocks are all next to
-			 * each other.
-			 */
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
-			if (!first && to_offset == iov_tail(*iov)) {
-				/*
-				 * Will append to the current iovec, because
-				 * the current block page is next to the
-				 * previous one.
-				 */
-				(*iov)->iov_len += copy_bytes;
-			} else {
-				/*
-				 * Will allocate a new iovec because we are
-				 * first time here or the current block page
-				 * is not next to the previous one.
-				 */
-				new_iov(iov, first);
-				(*iov)->iov_base = (void __user *)to_offset;
-				(*iov)->iov_len = copy_bytes;
-				first = false;
-			}
-
-			if (copy_data) {
-				offset = DATA_BLOCK_SIZE - block_remaining;
-				memcpy(to + offset,
-				       from + sg->length - sg_remaining,
-				       copy_bytes);
-			}
+			offset = DATA_BLOCK_SIZE - block_remaining;
+			memcpy(to + offset, from + sg->length - sg_remaining,
+			       copy_bytes);
 
 			sg_remaining -= copy_bytes;
 			block_remaining -= copy_bytes;
@@ -1010,7 +996,6 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	int iov_cnt, iov_bidi_cnt, cmd_id;
 	uint32_t cmd_head;
 	uint64_t cdb_off;
-	bool copy_to_data_area;
 	/* size of data buffer needed */
 	size_t data_length = (size_t)tcmu_cmd->dbi_cnt * DATA_BLOCK_SIZE;
 
@@ -1084,17 +1069,19 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	/* prepare iov list and copy data to data area if necessary */
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	iov = &entry->req.iov[0];
-	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
-		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
-			  se_cmd->t_data_nents, &iov, copy_to_data_area);
+
+	if (se_cmd->data_direction == DMA_TO_DEVICE ||
+	    se_cmd->se_cmd_flags & SCF_BIDI)
+		scatter_data_area(udev, tcmu_cmd, &iov);
+	else
+		tcmu_setup_iovs(udev, tcmu_cmd, &iov, se_cmd->data_length);
+
 	entry->req.iov_cnt = iov_cnt - iov_bidi_cnt;
 
 	/* Handle BIDI commands */
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		iov++;
-		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
-				  se_cmd->t_bidi_data_nents, &iov, false);
+		tcmu_setup_iovs(udev, tcmu_cmd, &iov, tcmu_cmd->data_len_bidi);
 		entry->req.iov_bidi_cnt = iov_bidi_cnt;
 	}
 
-- 
2.12.3

