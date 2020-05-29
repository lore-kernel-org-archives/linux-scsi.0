Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC218C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 09:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F35207D4
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 09:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Zp9qq+/c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgE2J1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 05:27:03 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.3]:57238 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgE2J1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 05:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1590744420; i=@ts.fujitsu.com;
        bh=F/F58PsdIWKqqeKnez2VulAPhgUIvW8QLlSIPSLcuBQ=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=Zp9qq+/cTgy68XmsmIzPQRLHfcQBStHHXCFIwWlnazED1St74vztFQDvyVYzcRz6G
         KQUFXjQcFAGKntalcuA+bqr4VPoV3IYPPk/fStTVF1f8tHRhnamR2xHPVQB7Ce0R7Z
         Q2v7iyLZ8AjYNUbVl2vA4G8/17vihp3D3XxGTF2q2jf0KSALtENxYaB07Pj82T4iQT
         IlhqGDQnyfekOC5KueYe8k7WaLcxyf+/4gfzk0DRHXhD6t1ByW+tL2C9wfM9tuIDGQ
         ma/VNEy1BS4PH9Ya4Qx2aep78jhbKY6NiwnebDs+WH+uETjqgfYjQ/QXacZyymh80d
         WN88KgJMZzw2Q==
Received: from [100.112.193.214] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-west-1.aws.symcld.net id 03/A4-09207-465D0DE5; Fri, 29 May 2020 09:27:00 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRWlGSWpSXmKPExsViZ8MRqpty9UK
  cwavNHBbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjJ2/jjIW
  fBar+HnxHVsD4z2hLkYuDiGByYwSvT1nGCGc6YwSKxbvAXI4OdgEDCRWTLrP0sXIwSEiUCsx7
  1QZSJhZQE9i2r917CC2sICXxJm93WA2i4CqRNuBE2wgNq+ArcSsQ2eZQWwJAXmJjgOTWSYwci
  5gZFjFaJ5UlJmeUZKbmJmja2hgoGtoaKRraGmia2aml1ilm6iXWqpbnlpcomuol1herFdcmZu
  ck6KXl1qyiRHo85SCQ047GN+//qB3iFGSg0lJlNf41Pk4Ib6k/JTKjMTijPii0pzU4kOMMhwc
  ShK8hlcuxAkJFqWmp1akZeYAww8mLcHBoyTCKwWS5i0uSMwtzkyHSJ1iVJQS500BSQiAJDJK8
  +DaYCF/iVFWSpiXkYGBQYinILUoN7MEVf4VozgHo5Iwb/hFoCk8mXklcNNfAS1mAlr8YMk5kM
  UliQgpqQamKp/sl6sWvt8odu1F2i+Tm60T9Z65MZ5nS78Y0rFkj9Yu7oAAqzkGsz4vXu2nImL
  ic9R+six/n82CsqroHbaTy0MW8SZr/22pTnnlte9949W6batvxnH8XH5ld0qkYEDil0tei194
  H3nIt7B5wUb+7zULp6+9/OxS0aPdck81J1vbnt/D0hUYqznDwXHy1LQ/bw9Mb2io0LMs3xwqr
  3ztlcCDMzkBvAHm3/vfXjereuD++68pd+7VjJsbY4w2Bklx/XqW/WJSiKxiqU2yYZa+0Uoevj
  3JTEd14+60+zVdd32pcPlceblRff+7k2tP6dl8iAmLcfsQJJkTdLkq9N4z7ynPbino82iobX/
  YJtOtxFKckWioxVxUnAgA9hHv+PQCAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-11.tower-271.messagelabs.com!1590744419!732836!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 32468 invoked from network); 29 May 2020 09:27:00 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-11.tower-271.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 29 May 2020 09:27:00 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04T9Qx0P012070;
        Fri, 29 May 2020 10:26:59 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id CA8862060A;
        Fri, 29 May 2020 11:26:58 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH RFC] scsi: target: tcmu: optimize use of flush_dcache_page
Date:   Fri, 29 May 2020 11:26:56 +0200
Message-Id: <20200529092656.1048-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

(scatter|gather)_data_area() need to flush dcache after
writing data to or before reading data from a page in
uio data area.
The two routines are able to handle data transfer to/from
such a page in fragments and flush the cache after each
fragment is copied by calling the wrapper
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

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---

Since I have x86 machines only, where flush_dcache_page()
is empty, this patch indeed is compile tested only.
Therefore it needs thorough review or ideally a test on
an architecture that has a non empty flush_dcache_page().


 drivers/target/target_core_user.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index cdb4848d23c6..d922a7087c31 100644
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

