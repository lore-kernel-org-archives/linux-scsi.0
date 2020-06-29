Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C48CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 23:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EED520780
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 23:16:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="ZbSJ+mvX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgF2XQy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 19:16:54 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.83]:45435 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727817AbgF2XQy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 19:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593423508; i=@ts.fujitsu.com;
        bh=fs1LLzBeHp3ALlgkMNwTdXQOovck716fsAPn1mE0Zfo=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=ZbSJ+mvXrsWuETD5EGfX1Ocz7coUdMz0jkAAqkMzQ/nnAnoTJVEc4N+E4a9P51H9l
         83gdAcwNKpjqODGIaSJPWxoROIPGdiU+2EIEMglxzyCbDBJIxJn4iaZ7N+Z1r0wf/M
         d1mruXTaOrmPFp+G+6fp/547E8IXmsmBJhfKLpZQaoZ1ebcyEVJKCgz/9ccpk0P01I
         Wlv3eZYU4gYJKyQLOngh48wveIAVcVPqYwYtyUH7oyow41hRNIirNLpV0+ylmSN6ei
         jYFpxL6EMW5/YF1ma9gHaCL+FtuqqH+2E3U0GdLj3NYDY2x+KsXLFKwQ5cwu6A2Js4
         GNt/sj4aYD1WQ==
Received: from [100.112.197.196] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-west-1.aws.symcld.net id D2/7C-06299-496B9FE5; Mon, 29 Jun 2020 09:38:28 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeJIrShJLcpLzFFi42Kxs+EI1Z287We
  cwZm5phbTPvxktji88A2TxaPPpxgtuq/vYLOY0RZmsfz4PyaLv5NusFq0Ln3L5MDhcfmKt8fO
  WXfZPR73nGHz+Pj0FovH501yAaxRrJl5SfkVCawZh3/tYyuYylexv+cpawPjdJ4uRi4OIYHJj
  BLrn7xmh3CmM0rsXTuBqYuRk4NNwEBixaT7LCAJEYFbjBLHpveCVTELrGaUuH9wGgtIlbCAn8
  SKKW2MIDaLgKrE78ZbQN0cHLwCthK9KwpBwhIC8hIdByazTGDkXMDIsIrRPKkoMz2jJDcxM0f
  X0MBA19DQSNfQ0lLX0EIvsUo3SS+1VLc8tbhE11AvsbxYr7gyNzknRS8vtWQTIzBwUgqOC+1g
  fPP6g94hRkkOJiVRXqMJP+OE+JLyUyozEosz4otKc1KLDzHKcHAoSfBqbAXKCRalpqdWpGXmA
  IMYJi3BwaMkwqu8BSjNW1yQmFucmQ6ROsWoKCXO6wKSEABJZJTmwbXBIucSo6yUMC8jAwODEE
  9BalFuZgmq/CtGcQ5GJWFefZDtPJl5JXDTXwEtZgJaXGD6DWRxSSJCSqqBaY7V1V1Z5+U/BJ8
  VSH67RUOf6baMAeMLEdN9ccdcGU0ajBRmqN1pN5ityWi73en6cS0Rswk3p763L3l4KMrgV9BP
  7sYPhUfPNf2/6zBBoePDpeccir0FTYvzM2scE4oyu3oZDN6WV7j8Xhv+MHlatLnO+6vr79zTF
  sn4ezn4+bssgWP3PTfebVOJ2NZ+MzjQsl8u4LHC9U8yHV8Ty2Ua/i7dtsWOb+1h40PXfgpPSp
  WINmyYkNpUV1q+dKmQzhSlxmtBE+L1N1g275N/KGRXcfdTQpT8zbqngav7H+xek6ErfqrfIEs
  iiufPTQf2pbfCthr5yNrbbr8wsfDrRz+v258zj063U5/iWsUkNtlbiaU4I9FQi7moOBEAKv4V
  ARcDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-8.tower-285.messagelabs.com!1593423507!541431!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15427 invoked from network); 29 Jun 2020 09:38:27 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-8.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 29 Jun 2020 09:38:27 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05T9cMa5025514;
        Mon, 29 Jun 2020 10:38:26 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 579C8206B2;
        Mon, 29 Jun 2020 11:38:22 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        JiangYu <lnsyyj@hotmail.com>,
        Daniel Meyerholt <dxm523@gmail.com>,
        Henry Willard <henry.willard@oracle.com>
Subject: [PATCH v2] scsi: target: tcmu: Fix crash on ARM during cmd completion
Date:   Mon, 29 Jun 2020 11:37:56 +0200
Message-Id: <20200629093756.8947-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If tcmu_handle_completions() has to process a padding shorter
than sizeof(struct tcmu_cmd_entry), the current call to
tcmu_flush_dcache_range() with sizeof(struct tcmu_cmd_entry) as
length param is wrong and causes crashes on e.g. ARM, because
tcmu_flush_dcache_range() in this case calls
	flush_dcache_page(vmalloc_to_page(start));
with start being an invalid address above the end of the
vmalloc'ed area.

The fix is to use the minimum of remaining ring space and
sizeof(struct tcmu_cmd_entry) as the length param.

The patch was tested on kernel 4.19.118.

See https://bugzilla.kernel.org/show_bug.cgi?id=208045#c10

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: JiangYu <lnsyyj@hotmail.com>
Acked-by: Mike Christie <michael.christie@oracle.com>
---

v2: Description fixed (maximum --> minimum) and
    added Acked-by.

 drivers/target/target_core_user.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3885ca532f8f..82e476d48194 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1221,7 +1221,14 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 
 		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
 
-		tcmu_flush_dcache_range(entry, sizeof(*entry));
+		/*
+		 * Flush max. up to end of cmd ring, since current entry might
+		 * be a padding that is shorter than sizeof(*entry)
+		 */
+		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
+					       udev->cmdr_size);
+		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
+					ring_left : sizeof(*entry));
 
 		if (tcmu_hdr_get_op(entry->hdr.len_op) == TCMU_OP_PAD) {
 			UPDATE_HEAD(udev->cmdr_last_cleaned,
-- 
2.12.3

