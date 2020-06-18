Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C99C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 333B720884
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="jmGO7D+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbgFRNDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:03:22 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.114]:60439 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730054AbgFRNDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 09:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592485395; i=@ts.fujitsu.com;
        bh=3FytLXG031tgejGRCpdGC+1ovLDdctaqeMEE7HvgEXY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=jmGO7D+m0iqchiFYSsoFHV+46DoDQD6PO48XRJbxRfimrplbC3DzMGis78t7WJgft
         JP9ZaSprUo9574bEBbFIHNaA1+KWpkNv/0coAMh6OKHhZ2nNC9857rUvYODsuJ8Y+/
         kqJpu+KPWODmT91ulkKZFf2k3ImN7WQQ/bbSlhoqXTfJUjqKt1VCkbDdyfARZNC+LN
         Jgn4+4tU6mEcny4VsSbnHpscLA8z22ilkjfo+iyp1AMzQ74YzQMjxxR1Dx+hwPN+Jk
         BRn7LAAVP+jM1+XYLcaG7NP7oa2+3knEaQDhdT7neBS/16pRbGoRviVs3YNlTk/0Fq
         RjAnt6Xp5NS+Q==
Received: from [100.113.6.202] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-central-1.aws.symcld.net id 5A/CF-28811-2166BEE5; Thu, 18 Jun 2020 13:03:14 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRWlGSWpSXmKPExsViZ8MxRVco7XW
  cwa42ZYvDC98wWXRf38FmMaMtzGL58X9MFn8n3WC1aF36lsmBzWPnrLvsHo97zrB5fHx6i8Xj
  8ya5AJYo1sy8pPyKBNaM1ke9bAXXxCt6dl9ga2DcLtzFyMUhJDCZUWLaxIXMEM50Rokn+/ezd
  TFycrAJGEismHSfBSQhIrCGUWLlnXnMIAlmgUqJ21ung9nCAl4Sn39vYwexWQRUJSbM3MAIYv
  MK2EmcejWbBcSWEJCX6DgwGczmFLCX2P5sOROILQRUs3flJrYJjNwLGBlWMVomFWWmZ5TkJmb
  m6BoaGOgaGhrrmuoamRjqJVbpJumlluomp+aVFCUCZfUSy4v1iitzk3NS9PJSSzYxAgMqpZD1
  4w7GQ68/6B1ilORgUhLlDU98HSfEl5SfUpmRWJwRX1Sak1p8iFGGg0NJgvdlMlBOsCg1PbUiL
  TMHGNwwaQkOHiURXr4UoDRvcUFibnFmOkTqFKOilDjvaZCEAEgiozQPrg0WUZcYZaWEeRkZGB
  iEeApSi3IzS1DlXzGKczAqCfOeBJnCk5lXAjf9FdBiJqDFWuGvQBaXJCKkpBqYNrSuFtsTKGn
  EFBsadfX9pAte+U+ObDBay1LbwrCOZeXuhYsWS1cdPv1nW/wrE78AbxYP5YTgP+2Fbj8DJ20R
  eyyk+aTvb47gbK7pTlP61t6L332SP65TgUtha9G1Xv2YyV1/Mjl17oax3buziN+Hb1f4I7WqD
  5NYK+Q3PP9+2HDPdwluFuOz/8NMbNkDA2N/X9liHp5cEz9DPdLt94LDs+bPOlecxCVSsuLEZ/
  FPvziPy3e18kqsqo/1ct7SM19X7Ux59PytK/V/v/YtYDvub9h23HjPAh99lkUnwxW+s3cxsOm
  GXkk1jOS/JyAZERXbbGiglOpdwcz7ZmGG+MGX9nu+lExsLtwdds3hXKUSS3FGoqEWc1FxIgAL
  3JKQIwMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-26.tower-248.messagelabs.com!1592485393!191676!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23601 invoked from network); 18 Jun 2020 13:03:14 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-26.tower-248.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jun 2020 13:03:14 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05ID353P025552;
        Thu, 18 Jun 2020 14:03:05 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 2E02320524;
        Thu, 18 Jun 2020 15:03:05 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 1/2] scsi: target: tcmu: Optimize use of flush_dcache_page
Date:   Thu, 18 Jun 2020 15:02:59 +0200
Message-Id: <20200618130300.31094-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200618130300.31094-1-bstroesser@ts.fujitsu.com>
References: <20200618130300.31094-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

(scatter|gather)_data_area() need to flush dcache after
writing data to or before reading data from a page in
uio data area.
The two routines are able to handle data transfer to/from
such a page in fragments and flush the cache after each
fragment was copied by calling the wrapper
tcmu_flush_dcache_range().

That means:
1) flush_dcache_page() can be called multiple times for
   the same page.
2) Calling flush_dcache_page() indirectly using the
   wrapper does not make sense, because each call of the
   wrapper is for one single page only and the calling
   routine already has the correct page pointer.

Therefore I changed (scatter|gather)_data_area() such,
that instead of calling tcmu_flush_dcache_range()
before/after each memcpy, it now calls flush_dcache_page()
before unmapping a page (when writing is complete for
that page) or after mapping a page (when starting to read
the page).

After this change only calls to tcmu_flush_dcache_range()
for addresses in vmalloc'ed command ring are left over.
This is a good preparation for the second patch of the series.

The patch was tested on ARM with kernel 4.19.118 and 5.7.2

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: JiangYu <lnsyyj@hotmail.com>
Tested-by: Daniel Meyerholt <dxm523@gmail.com>
---
 drivers/target/target_core_user.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 560bfec933bc..a65e9671ae7a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -676,8 +676,10 @@ static void scatter_data_area(struct tcmu_dev *udev,
 		from = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
-				if (to)
+				if (to) {
+					flush_dcache_page(page);
 					kunmap_atomic(to);
+				}
 
 				block_remaining = DATA_BLOCK_SIZE;
 				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
@@ -722,7 +724,6 @@ static void scatter_data_area(struct tcmu_dev *udev,
 				memcpy(to + offset,
 				       from + sg->length - sg_remaining,
 				       copy_bytes);
-				tcmu_flush_dcache_range(to, copy_bytes);
 			}
 
 			sg_remaining -= copy_bytes;
@@ -731,8 +732,10 @@ static void scatter_data_area(struct tcmu_dev *udev,
 		kunmap_atomic(from - sg->offset);
 	}
 
-	if (to)
+	if (to) {
+		flush_dcache_page(page);
 		kunmap_atomic(to);
+	}
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
@@ -778,13 +781,13 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 				dbi = tcmu_cmd_get_dbi(cmd);
 				page = tcmu_get_block_page(udev, dbi);
 				from = kmap_atomic(page);
+				flush_dcache_page(page);
 			}
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
 			if (read_len < copy_bytes)
 				copy_bytes = read_len;
 			offset = DATA_BLOCK_SIZE - block_remaining;
-			tcmu_flush_dcache_range(from, copy_bytes);
 			memcpy(to + sg->length - sg_remaining, from + offset,
 					copy_bytes);
 
-- 
2.12.3

