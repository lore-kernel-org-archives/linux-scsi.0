Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9911C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86F120885
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Fjc+7+qY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgFRNDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:03:17 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:55668 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725953AbgFRNDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 09:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592485391; i=@ts.fujitsu.com;
        bh=MyKxM3Ra0pnYyAzuOIk8iI7gocuWNS3LRs/S7UaDOQc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=Fjc+7+qYv51A9XH9+IrQ8b3VlGQR2mmz4U2ckqeiA9xFDQS17tVDiWccX67VN6ALy
         SV+UoBLy4+Jy/JnD0gt7MYhx3JSNgemOLalGxAZSFhSa2NCYLLT/7/S28QbFmz0WWj
         U2b9lxcpzb2APJrkC2AYj866N9Lv3UikVjDFdCsFes5Ba4VviK/Kk+iRhwdVuAsEuf
         cEqIhT9qe2K8DZxMQ/inAh029P9TViT50AyioqZ2PbupLWwvE5oc09SPnpLbwKQICc
         fYwWQTmUwr0ncORC18qKSO9Ao4BZeQ28NjT+eZyIhL2YiuxY7N2L4AVNPByFPrHWEG
         Wb1TWYGFESJNA==
Received: from [100.113.3.197] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id F3/37-28492-F066BEE5; Thu, 18 Jun 2020 13:03:11 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRWlGSWpSXmKPExsViZ8MRqsuf9jr
  O4M1rAYvDC98wWXRf38FmMaMtzGL58X9MFn8n3WC1aF36lsmBzWPnrLvsHo97zrB5fHx6i8Xj
  8ya5AJYo1sy8pPyKBNaMV69XsBXMlKiYsKSugXGRaBcjF4eQwGRGiStTdzNDONMZJSZ8ncLWx
  cjJwSZgILFi0n0WkISIwBpGiZV35jGDJJgFKiVub50OZgsLhEgcObeEHcRmEVCV2LX1IguIzS
  tgJ7Fg10OwQRIC8hIdByaDxTkF7CW2P1vOBGILAdXsXbmJbQIj9wJGhlWMlklFmekZJbmJmTm
  6hgYGuoaGxrqGuoYmRnqJVbqJeqmlusmpeSVFiUBZvcTyYr3iytzknBS9vNSSTYzAcEopZOzb
  wTjxzQe9Q4ySHExKorzhia/jhPiS8lMqMxKLM+KLSnNSiw8xynBwKEnwvkwGygkWpaanVqRl5
  gBDGyYtwcGjJMLLlwKU5i0uSMwtzkyHSJ1i1OV4cXXxImYhlrz8vFQpcd58kBkCIEUZpXlwI2
  BxdolRVkqYl5GBgUGIpyC1KDezBFX+FaM4B6OSMO8ckCk8mXklcJteAR3BBHSEVvgrkCNKEhF
  SUg1M/N7CUyeeEDdWff70Z0hrTEpFWqHr6alt4V7Wl42tTl/gKwktWJFgWFW7/4zun0TLshqd
  U8fb0lurLiilHd0SsHWafPMhowsXfB5s9vqqb9394MSOhim68cJcQitXsfx4uvjwzL97xMt6n
  XNPZ252M+eTuSGexSE2U/vwa6V/QbHHejqZtrIsco1m33Nw9aP22RNK7U9/uHA29WCIxs8vUx
  cfiMr8O+Hf7YpbBaXpoknPTeb/XGE2680ds6mqLY/VvvFMtk/d6lOldc3rZOOUrseH8jtmbbi
  ZUmwrdPdpybHyJwfTD7Tt1VpQ/dB4YVXoxoc3J1/gONMj8viKrQ+rpumtetF999/d3bWo451n
  jhJLcUaioRZzUXEiAHRI0dIuAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-25.tower-232.messagelabs.com!1592485390!438837!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5302 invoked from network); 18 Jun 2020 13:03:11 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-25.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jun 2020 13:03:11 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05ID36F3017675;
        Thu, 18 Jun 2020 14:03:06 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 124B9206AF;
        Thu, 18 Jun 2020 15:03:06 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 2/2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM
Date:   Thu, 18 Jun 2020 15:03:00 +0200
Message-Id: <20200618130300.31094-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200618130300.31094-1-bstroesser@ts.fujitsu.com>
References: <20200618130300.31094-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following crash
(see https://bugzilla.kernel.org/show_bug.cgi?id=208045)

 Process iscsi_trx (pid: 7496, stack limit = 0x0000000010dd111a)
 CPU: 0 PID: 7496 Comm: iscsi_trx Not tainted 4.19.118-0419118-generic
        #202004230533
 Hardware name: Greatwall QingTian DF720/F601, BIOS 601FBE20 Sep 26 2019
 pstate: 80400005 (Nzcv daif +PAN -UAO)
 pc : flush_dcache_page+0x18/0x40
 lr : is_ring_space_avail+0x68/0x2f8 [target_core_user]
 sp : ffff000015123a80
 x29: ffff000015123a80 x28: 0000000000000000
 x27: 0000000000001000 x26: ffff000023ea5000
 x25: ffffcfa25bbe08b8 x24: 0000000000000078
 x23: ffff7e0000000000 x22: ffff000023ea5001
 x21: ffffcfa24b79c000 x20: 0000000000000fff
 x19: ffff7e00008fa940 x18: 0000000000000000
 x17: 0000000000000000 x16: ffff2d047e709138
 x15: 0000000000000000 x14: 0000000000000000
 x13: 0000000000000000 x12: ffff2d047fbd0a40
 x11: 0000000000000000 x10: 0000000000000030
 x9 : 0000000000000000 x8 : ffffc9a254820a00
 x7 : 00000000000013b0 x6 : 000000000000003f
 x5 : 0000000000000040 x4 : ffffcfa25bbe08e8
 x3 : 0000000000001000 x2 : 0000000000000078
 x1 : ffffcfa25bbe08b8 x0 : ffff2d040bc88a18
 Call trace:
  flush_dcache_page+0x18/0x40
  is_ring_space_avail+0x68/0x2f8 [target_core_user]
  queue_cmd_ring+0x1f8/0x680 [target_core_user]
  tcmu_queue_cmd+0xe4/0x158 [target_core_user]
  __target_execute_cmd+0x30/0xf0 [target_core_mod]
  target_execute_cmd+0x294/0x390 [target_core_mod]
  transport_generic_new_cmd+0x1e8/0x358 [target_core_mod]
  transport_handle_cdb_direct+0x50/0xb0 [target_core_mod]
  iscsit_execute_cmd+0x2b4/0x350 [iscsi_target_mod]
  iscsit_sequence_cmd+0xd8/0x1d8 [iscsi_target_mod]
  iscsit_process_scsi_cmd+0xac/0xf8 [iscsi_target_mod]
  iscsit_get_rx_pdu+0x404/0xd00 [iscsi_target_mod]
  iscsi_target_rx_thread+0xb8/0x130 [iscsi_target_mod]
  kthread+0x130/0x138
  ret_from_fork+0x10/0x18
 Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (f9400260)
 ---[ end trace 1e451c73f4266776 ]---

The solution is based on patch:

  "scsi: target: tcmu: Optimize use of flush_dcache_page"

which restricts the use of tcmu_flush_dcache_range() to
addresses from vmalloc'ed areas only.

This patch now replaces the virt_to_page() call in
tcmu_flush_dcache_range() - which is wrong for vmalloced addrs -
by vmalloc_to_page().

The patch was tested on ARM with kernel 4.19.118 and 5.7.2

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: JiangYu <lnsyyj@hotmail.com>
Tested-by: Daniel Meyerholt <dxm523@gmail.com>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a65e9671ae7a..835d3001cb0e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -601,7 +601,7 @@ static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
 	size = round_up(size+offset, PAGE_SIZE);
 
 	while (size) {
-		flush_dcache_page(virt_to_page(start));
+		flush_dcache_page(vmalloc_to_page(start));
 		start += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
-- 
2.12.3

