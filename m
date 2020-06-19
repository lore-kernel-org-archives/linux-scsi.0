Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B19C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 17:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BB4320C09
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 17:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="P+PJjoLP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733039AbgFSRic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 13:38:32 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.4]:38161 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730934AbgFSRic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jun 2020 13:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1592588309; i=@ts.fujitsu.com;
        bh=bxh83OrtNBrFtGURskqIZiHNmvXTBxqQ8cnMWONKgC0=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=P+PJjoLP4lGch9ctVMwkvSP3kwBel9A8Op9IdCNHwOiDb3nyqfaJtjtUu063coXnE
         ollcu+hqMQ4V4BXa2xRk+wf+TPPXXWrLURUV5CYHyHt/iPDXH02Guxe5hGmeyHkJaH
         lVGNf90xl8tsflCDdQeimonPbDrZqy/eQVH+yL0Gzu8n5+I7MS+GpzwsMZxvixxw7C
         FeOYy19FTLUcoSMN3dkHKsVOvDVDPN/f7KQrSJIXzYZ6dP6JdPXBn9uDxTSY0F3LrB
         V1RW1WVyDLfRkdqLzLIHNGxYA2rTxFaITmXH2KT0HujoadofhALK5TnEJ737+u2MDK
         uFUXF4KfLBEVw==
Received: from [100.112.192.88] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-west-1.aws.symcld.net id 47/2F-28622-518FCEE5; Fri, 19 Jun 2020 17:38:29 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRWlGSWpSXmKPExsViZ8MRoiv6402
  cwYeDPBbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjH/7j7IU
  9HFUvHq7gqmBsZe9i5GLQ0hgMqPEjMaLjBDOdEaJM9ums3YxcnKwCRhIrJh0nwUkISKwhlFi5
  Z15zCAJZgE9iWn/1rGD2MICgRKtH34xgtgsAqoSV1YcBmvmFbCVOL/uNli9hIC8RMeBySwTGD
  kXMDKsYjRPKspMzyjJTczM0TU0MNA1NDTSNbQ01TU20Uus0k3USy3VLU8tLtE11EssL9Yrrsx
  NzknRy0st2cQI9HtKwWGlHYzvXn/QO8QoycGkJMrbcetNnBBfUn5KZUZicUZ8UWlOavEhRhkO
  DiUJ3vJvQDnBotT01Iq0zBxgCMKkJTh4lER494KkeYsLEnOLM9MhUqcYFaXEeSNAEgIgiYzSP
  Lg2WNhfYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTMOxlkCk9mXgnc9FdAi5mAFmuFvwJZXJ
  KIkJJqYJpfNunR6VmZvxsbGe33+Zocajixusok6e1FroDrF/zfsVRMc2lpsEnjuPckOn9HzoG
  DbA9+bZn8p77Hw9ChNtTrWGpArGHw/BMJexUNaiNU9R/Yfq3T+7fEKyoj6r26/UoF/So7ztl6
  x/TvOr0zObgvTEIsqv+mgu1Prr/LCqzvWiia5twXYDU1l5cJjez3OL1xyXtRgbQ198RtPrieZ
  Dz24iGj9LxfuecXmUxTV34yXbmWt3ZNS+LlE7Z9O3x2rz145/ZKZqMHNS12LRkMykYHghX6zS
  b4hNgtT45z113+6Y+k+KkPbN/3HYxi3TndrXrdZ98vgp8uTVg6s+1lCsP9Xsdr2dO0TaY9n+G
  zXomlOCPRUIu5qDgRADN+xU32AgAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-3.tower-265.messagelabs.com!1592588308!1382521!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29399 invoked from network); 19 Jun 2020 17:38:29 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-3.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 19 Jun 2020 17:38:29 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05JHcLeU024033;
        Fri, 19 Jun 2020 18:38:21 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id DBBF520561;
        Fri, 19 Jun 2020 19:38:17 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] scsi: target: tcmu: Remove unnecessary bit TCMU_CMD_BIT_INFLIGHT
Date:   Fri, 19 Jun 2020 19:38:06 +0200
Message-Id: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since
commit 61fb24822166 ("scsi: target: tcmu: Userspace must not complete
 queued commands")
tcmu_cmd bit TCMU_CMD_BIT_INFLIGHT is set but never checked.
So we can remove it safely.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 560bfec933bc..b38da27e033f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -181,7 +181,6 @@ struct tcmu_cmd {
 	unsigned long deadline;
 
 #define TCMU_CMD_BIT_EXPIRED 0
-#define TCMU_CMD_BIT_INFLIGHT 1
 	unsigned long flags;
 };
 /*
@@ -1078,7 +1077,6 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
 
 	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
-	set_bit(TCMU_CMD_BIT_INFLIGHT, &tcmu_cmd->flags);
 
 	/* TODO: only if FLUSH and FUA? */
 	uio_event_notify(&udev->uio_info);
-- 
2.12.3

