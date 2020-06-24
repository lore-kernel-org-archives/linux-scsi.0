Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4FAC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 08:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2135E207DD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 08:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="OJiT2kdb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388963AbgFXIxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 04:53:44 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.4]:39409 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728732AbgFXIxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jun 2020 04:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592988820; i=@ts.fujitsu.com;
        bh=xTlDTIhuzqELQkiMm6reVrPea5iD8zScdlt45oATRp4=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=OJiT2kdbLnPop0Fg+g1k8OK6Rr+n8hFJqZhhEsb7skAh2I7By8F5h8OL5K3K4d0e6
         73nhmRbdD6aL6qDMYhT5ZOTl1hvZ0AFDqgEGZA0ejYuzwrR99KN30MHCxrv5+XtACJ
         uX5yRRJc3KjPlSmholtvAGp7fIrvpy6r9dIMMSwWbyKfJlXtP7SfawQWn7jDcnwmi5
         H46HCMwrKLOuN+86erc8DPT/KvlmjZl2Qfk67GWN0a4/omVzSYHsw5ewZYKwwc9bWT
         PAeO+lSyomLxNUX4jhVieUxSXJfyWs7cjNTKtTvu8n0QWHYrdARHOVGtUPAtc2+RFY
         mYN7zIl6ARWpQ==
Received: from [100.113.3.51] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-central-1.aws.symcld.net id 2D/10-01380-49413FE5; Wed, 24 Jun 2020 08:53:40 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MxRXeKyOc
  4g8f7mS0OL3zDZPHo8ylGi+7rO9gsZrSFWSw//o/J4u+kG6wWrUvfMjmwe+ycdZfd43HPGTaP
  j09vsXh83iQXwBLFmpmXlF+RwJoxbeJS1oKZvBULzx1ja2Bcx93FyMUhJDCZUeL+jlksEM50R
  okvKzaxdTFycrAJGEismHQfLCEisIZRYuWdecwgDrPAakaJTx9ng1UJC3hLnOlrZQSxWQRUJX
  ac/w5UxMHBK2AnseNcEUhYQkBeouPAZJYJjJwLGBlWMVomFWWmZ5TkJmbm6BoaGOgaGhrrAkl
  jA73EKt1EvdRS3eTUvJKiRKCsXmJ5sV5xZW5yTopeXmrJJkZgqKQUMjTtYHz36oPeIUZJDiYl
  UV7vh5/ihPiS8lMqMxKLM+KLSnNSiw8xynBwKEnwnhf8HCckWJSanlqRlpkDDFuYtAQHj5IIb
  78QUJq3uCAxtzgzHSJ1ilFRSpz3NEhCACSRUZoH1waLlUuMslLCvIwMDAxCPAWpRbmZJajyrx
  jFORiVhHlPgEzhycwrgZv+CmgxE9BiScdPIItLEhFSUg1MU+YES4rebIu1k3OuuXpv/b6JS1U
  dW3bYHuDPm+p3d0VfffTF3Pn3XwRIKX37GSPz+Lr8I/YY/4WPa8JFd0j93umqGuyZ4MHIv+xz
  gMYSgeyTLXE9nszlkqo/LFxCZe33Cla7e/3YatDt+3++W9/ZtOSNX0M/GL/88eBEo2xGY+vdq
  BcquRxSe6p4KoQZ7WZaL0zrbtbtqIp6+9h7dYpoqwH3JJUM1wuimlP6c74d47vnuix/WqCe1g
  H1kPIlUeaS5xddT/mp5FbQ1CP5euqhcsYTxsEyRx+s91264qK55LSFU6SbZENeq/xNuKOQt9m
  mk8lPNIOtUMpvnfm32Vdt9y15bNTRFhmTul6uVImlOCPRUIu5qDgRAIwhKpMQAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-22.tower-228.messagelabs.com!1592988819!655672!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 8692 invoked from network); 24 Jun 2020 08:53:39 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-22.tower-228.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 24 Jun 2020 08:53:39 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05O8rck9011594;
        Wed, 24 Jun 2020 09:53:39 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id C545A205E2;
        Wed, 24 Jun 2020 10:53:35 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Henry Willard <henry.willard@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] scsi: target: tcmu: Fix crash on ARM during cmd completion
Date:   Wed, 24 Jun 2020 10:53:20 +0200
Message-Id: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
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

The fix is to use the maximum of remaining ring space and
sizeof(struct tcmu_cmd_entry) as the length param.

The patch was tested on kernel 4.19.118.

See https://bugzilla.kernel.org/show_bug.cgi?id=208045#c10

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: JiangYu <lnsyyj@hotmail.com>
---
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

