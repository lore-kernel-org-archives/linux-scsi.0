Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99D4C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 19:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7935E207BC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 19:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="I+Iv20jQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406595AbgE1Tbh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 15:31:37 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.2]:13995 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406369AbgE1Tbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 15:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1590694291; i=@ts.fujitsu.com;
        bh=9mosgJl5xAOlW/Tf6/Doel/hhKgfRQm8O6or2gF2Lps=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=I+Iv20jQ3ffAc7QD9s0s7w08en6DzR9NEJTMl1ov/9H4OmA/iXG8B34I93RlRmKcP
         B5VOJrYhZorDpkeKoasraLtPf4Bw6E9KYrJLPe4NwbHFWhwwiD1WRvzhTKIDwaR8L0
         QOo6U56l2FHiicpEru+CyXWAJ8fkZEDlpKGLe9IbdKAAqctDzQrl8ZVdqXIgMpEGcE
         6cuBq4MmBqBHfk/DwLLvsW1voiLtG7J9Mojdx8oAwcAjpFR09OFapNfvh5ogxLMdDa
         sYK3ZF3lZOpLUZldR7V9f5MTiQM7COD1Ol4d+D86e/U1/zVNcUN60B9KDakKnXvI+N
         0YDG6oU7YedTw==
Received: from [100.112.194.33] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-west-1.aws.symcld.net id 56/58-40611-39110DE5; Thu, 28 May 2020 19:31:31 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRWlGSWpSXmKPExsViZ8MxVXey4IU
  4g7NbeSy6r+9gs1h+/B+TxfojGxgtWpe+ZXJg8fj49BaLx/t9V9k8Pm+SC2COYs3MS8qvSGDN
  WLX/JHvBW5GK/VtnszcwbhPsYuTiEBKYzCjx6MECNghnOqPE2wNTmLsYOTnYBAwkVky6zwJii
  wiUSjw/vZoJxGYW0JOY9m8dO4gtLBAocWlFF1gNi4CqxO/zL8F6eQVsJU6d2Q1WIyEgL9FxYD
  LLBEbOBYwMqxgtkooy0zNKchMzc3QNDQx0DQ2NdA0tTYDYSC+xSjdRL7VUtzy1uETXUC+xvFi
  vuDI3OSdFLy+1ZBMjMABSCg4d2MG47M0HvUOMkhxMSqK8xqfOxwnxJeWnVGYkFmfEF5XmpBYf
  YpTh4FCS4FUWuBAnJFiUmp5akZaZAwxGmLQEB4+SCK8sSJq3uCAxtzgzHSJ1ilFRSpxXDyQhA
  JLIKM2Da4NFwCVGWSlhXkYGBgYhnoLUotzMElT5V4ziHIxKwryeIFN4MvNK4Ka/AlrMBLT4wZ
  JzIItLEhFSUg1MUss3Pq/fnf7s5uaP9luZ7f8KiImuXNYeGLnMPYszTrYuXWiq5y2bP5yN9rv
  n8Nmq6CjLu5QtE9/9Y1XIec3fV/o2bZrUt0SatWPbVWl3QYXy9ac6Rd30/LM39y42dCy3kZku
  L2dufJ4jR89v8pv16lydyow2S65k5OncFZn6U2/6Y2u7o+v5gkVsJ7ZFiC2xaOzjbi1cNen9f
  Yfri/50Lf29tdr58I8v2qXXQhZkh8960Vr/0bBwxcIrmjeffL9u6O5px5yhyqT+QuCnR4RU35
  rHXWr1an/uXQlp2ZPTzTLxTJpyoaZF/+sPD/VWzWCdKNIUOqPEMXfyt7+rLDc7bJvNvmVx8mF
  GpWqp3ZxKLMUZiYZazEXFiQDCNK6q+wIAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-9.tower-271.messagelabs.com!1590694290!697211!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 4987 invoked from network); 28 May 2020 19:31:31 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-9.tower-271.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 28 May 2020 19:31:31 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04SJVM8B021241;
        Thu, 28 May 2020 20:31:22 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id E71522071F;
        Thu, 28 May 2020 21:31:14 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     martin.petersen@oracle.com, mchristi@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range
Date:   Thu, 28 May 2020 21:31:08 +0200
Message-Id: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

1) If remaining ring space before the end of the ring is
   smaller then the next cmd to write, tcmu writes a padding
   entry which fills the remaining space at the end of the
   ring.
   Then tcmu calls tcmu_flush_dcache_range() with the size
   of struct tcmu_cmd_entry as data length to flush.
   If the space filled by the padding was smaller then
   tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
   an address range reaching behind the end of the vmalloc'ed
   ring.
   tcmu_flush_dcache_range() in a loop calls
      flush_dcache_page(virt_to_page(start));
   for every page being part of the range. On x86 the line is
   optimized out by the compiler, as flush_dcache_page() is
   empty on x86.
   But I assume the above can cause trouble on other
   architectures that really have a flush_dcache_page().
   For paddings only the header part of an entry is relevant
   Due to alignment rules the header always fits in the
   remaining space, if padding is needed.
   So tcmu_flush_dcache_range() can safely be called with
   sizeof(entry->hdr) as the length here.

2) After it has written a command to cmd ring, tcmu calls
   tcmu_flush_dcache_range() using the size of a struct
   tcmu_cmd_entry as data length to flush.
   But if a command needs many iovecs, the real size of the
   command may be bigger then tcmu_cmd_entry, so a part of
   the written command is not flushed then.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index f769bb1e3735..cdb4848d23c6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1026,7 +1026,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		entry->hdr.cmd_id = 0; /* not used for PAD */
 		entry->hdr.kflags = 0;
 		entry->hdr.uflags = 0;
-		tcmu_flush_dcache_range(entry, sizeof(*entry));
+		tcmu_flush_dcache_range(entry, sizeof(entry->hdr));
 
 		UPDATE_HEAD(mb->cmd_head, pad_size, udev->cmdr_size);
 		tcmu_flush_dcache_range(mb, sizeof(*mb));
@@ -1084,7 +1084,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
 	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
 	entry->req.cdb_off = cdb_off;
-	tcmu_flush_dcache_range(entry, sizeof(*entry));
+	tcmu_flush_dcache_range(entry, command_size);
 
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
-- 
2.12.3

