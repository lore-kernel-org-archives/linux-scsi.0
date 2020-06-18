Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC55C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B962073E
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="aE1J4JoF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgFRNRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:17:08 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.115]:47682 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730035AbgFRNQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 09:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592486205; i=@ts.fujitsu.com;
        bh=MyKxM3Ra0pnYyAzuOIk8iI7gocuWNS3LRs/S7UaDOQc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=aE1J4JoFhnCiIkom0bFKEacc71QMeKR7PT8n+S8vJWx+D0g4WHCZDdjI8jB2OYZvN
         GR1D8cv9JlkQUzAVQfS3V7aVM0U5D22KJROjjmetI0FQ+GMuiW8yZWi/lakjUmwSsP
         7zDnZZyjKcempbM57CIdsZVfC1OZ5CnhrmF6PxOsi2ocxXurN6lxAQme7tzutrRKMc
         APpqN9OhUYq+pCTEKxRhHdmeDQBiI61J98SWbbDLyLTLiT2LTOcv7YxAO6DWKb/4jN
         gxWr1NgvVxJ5h4ajtcbdXC1MZg+YWhcsqrNFR48ruRLhIRgEG4Z7wJZ/WHHki+xe4I
         vYXiwluIt72AA==
Received: from [100.113.4.66] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-central-1.aws.symcld.net id 9D/FE-28870-C396BEE5; Thu, 18 Jun 2020 13:16:44 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRWlGSWpSXmKPExsViZ8MRomuT+Tr
  O4GG7msXhhW+YLLqv72CzmNEWZrH8+D8mi7+TbrBatC59y+TA5rFz1l12j8c9Z9g8Pj69xeLx
  eZNcAEsUa2ZeUn5FAmvGq9cr2ApmSlRMWFLXwLhItIuRk0NIYDKjxOVpdl2MXED2dEaJbx8+M
  IMk2AQMJFZMus8CkhARWMMosfLOPLAEs0ClxO2t04FsDg5hgXCJR0csQMIsAqoS/6ctYQOxeQ
  XsJLZtX8cEYksIyEt0HJjMAmJzCthL7NnWzAjSKgRUs/2G8QRG7gWMDKsYLZOKMtMzSnITM3N
  0DQ0MdA0NjXXNgSxTvcQq3SS91FLd5NS8kqJEoKxeYnmxXnFlbnJOil5easkmRmAgpRSyZ+5g
  nPzmg94hRkkOJiVR3vDE13FCfEn5KZUZicUZ8UWlOanFhxhlODiUJHjl04FygkWp6akVaZk5w
  KCGSUtw8CiJ8J5MA0rzFhck5hZnpkOkTjHqcry4ungRsxBLXn5eqpQ4byBIkQBIUUZpHtwIWI
  RdYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTMyw8yhSczrwRu0yugI5iAjtAKfwVyREkiQkq
  qgUnNqLvK+dv9qwuYhGdlrK3j+/TxT3X2ZIv/P3SCg2vl7mm8Cc78+1pbUHrizVX6EjO1Vr2d
  IHufv6pfaP2MWuurTorZCmvnnXiwam3vm9LrRzc4mAuHmDguXJn0bVWe0Y7I3vis+34yIZ+1z
  87LUnKe9/beIu+7AZHzzNz2vP51Rnn3JIk1NosyDXdU6sjZFQV2/+bx6DlpXeT2KURr41+t30
  1pSer6Xu88GG4seXJmYmcUz6nVB1k9VTtnL/YQ3q3/47BQzXG+FbVH5sto9bec8zDvYOt8vuG
  vBXei2xROefWErkwW31+tFUYiVke6y/86vtTLezPjDefRZcqc7TFKZseUNq3IlE78aybZqMRS
  nJFoqMVcVJwIAChg/7UrAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-3.tower-238.messagelabs.com!1592486203!737660!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 18034 invoked from network); 18 Jun 2020 13:16:44 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-3.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Jun 2020 13:16:44 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05IDGhVt015493;
        Thu, 18 Jun 2020 14:16:43 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 4684620300;
        Thu, 18 Jun 2020 15:16:43 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM
Date:   Thu, 18 Jun 2020 15:16:32 +0200
Message-Id: <20200618131632.32748-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
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

