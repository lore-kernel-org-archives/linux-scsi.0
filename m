Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B1FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542AC207E8
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="eJTwD7/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgFRNRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:17:02 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:35922 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729995AbgFRNQr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 09:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592486204; i=@ts.fujitsu.com;
        bh=3FytLXG031tgejGRCpdGC+1ovLDdctaqeMEE7HvgEXY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=eJTwD7/zWQ7QNLxOMTgYOdCFI5ri0YOZVVC+DJd6jWb27VcsbJtG3DdqSQBPd1+xE
         SP2sZHt9ukbTUFTQs1sbCjTEN5J505epAP06nL5YZGSmpzg577srk97honHKWgZCRQ
         0mEVOFU6B7uD5X/Nar3CwVAGYuyjSFNN0kqQsDBeCe4xdUY/pD1gEii6TrCwxptxju
         QAv1WGqxZllxAPSH/uExRlaVTtRO6/Nu8o5ZzuGw6xwXBNOlO5ppEgD1cJoe585dXn
         ZKCdZ6NIZM9kzjXrHkXkdZyiEi6dKz9wr5HSqdWg9eKt1t8zrq4z36ULdPtSk+T8pR
         Nb9pLdFIcaKgQ==
Received: from [100.112.192.107] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id 46/53-28878-C396BEE5; Thu, 18 Jun 2020 13:16:44 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeJIrShJLcpLzFFi42Kxs+EI1bXOfB1
  nsHejtsXhhW+YLLqv72CzmNEWZrH8+D8mi7+TbrBatC59y+TA5rFz1l12j8c9Z9g8Pj69xeLx
  eZNcAEsUa2ZeUn5FAmtG66NetoJr4hU9uy+wNTBuF+5i5OIQEpjMKHH70iEWCGc6o8SUZ7PZu
  hg5OdgEDCRWTLoPlhARWMMosfLOPGaQBLNApcTtrdOBbA4OYQFfiXcrwepZBFQl3nUdZwMJ8w
  rYSWw6yAQSlhCQl+g4MJkFxOYUsJfYs62ZEaRECKhk+w3jCYzcCxgZVjGaJxVlpmeU5CZm5ug
  aGhjoGhoa6RpaGusaW+olVukm6qWW6panFpfoGuollhfrFVfmJuek6OWllmxiBIZRSsFB9R2M
  H19/0DvEKMnBpCTKG574Ok6ILyk/pTIjsTgjvqg0J7X4EKMMB4eSBO+DdKCcYFFqempFWmYOM
  KRh0hIcPEoivDIZQGne4oLE3OLMdIjUKUZFKXHefSB9AiCJjNI8uDZYHF1ilJUS5mVkYGAQ4i
  lILcrNLEGVf8UozsGoJMw7GWQKT2ZeCdz0V0CLmYAWa4W/AllckoiQkmpgWvgwr/RJXnXILfk
  7F1hctp2vvfe63O2D1I9+T8GQ0yUuq1W3aE8vW+8/8/7XT4sbdRZvaeZS974tH/Si+cjioHfF
  h34+EX4y+aua646HW+/U9ft8fM9+Uu+NxvY3Tyt1C8ouR7598N9Ze/IPH633FmVBh2s/revkY
  LXbPG/GAfG267z/8r/NuH3/tqJMi1TSFqa4+bxaLNdu7aw99vVnxrSqH82dIXdOPrvpNoHPyS
  xwl8jFhxf7X3YkeVdfutC9jIH3+LPZOXrC/3RUnO/6XIvh+iwVJHohc91qtekqycflpb3UNs7
  vKlxXE/sqbPlGlucO7YLPPdv2J56fcLuV12Wv7gHOx95asx4ZCZQX+CuxFGckGmoxFxUnAgDL
  YvfhHgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-42.tower-271.messagelabs.com!1592486202!422446!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 16099 invoked from network); 18 Jun 2020 13:16:43 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-42.tower-271.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jun 2020 13:16:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05IDGgnR029145;
        Thu, 18 Jun 2020 14:16:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 5FA8820300;
        Thu, 18 Jun 2020 15:16:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
Date:   Thu, 18 Jun 2020 15:16:31 +0200
Message-Id: <20200618131632.32748-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
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

