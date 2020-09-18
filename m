Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AF1C43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3A5923770
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397656;
	bh=Mh4Vt3gLouXRzukpt2kY1pDDHByKAXbINrKSJTuOPM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=g5QnLHZOaEFhjGxyZ1bnf+Poum+gjZOxl4HZJ7arvJE5/FeB+AyY9QprTWfJitvrk
	 iZYQWSHSoO9Dyf/7oc+ThJh9uwyCAoS/m/BdLDETcYllYUyu9iO5wFDkAg3oixJCDo
	 sHb+eY7eUbl/zr6UdU4mr4mZOh1tYmBLSK9LM/DQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgIRCx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbgIRCHp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B69B2389E;
        Fri, 18 Sep 2020 02:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394864;
        bh=Mh4Vt3gLouXRzukpt2kY1pDDHByKAXbINrKSJTuOPM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTKEm9j7Q5GsN2CKC4DtVi3NO0GRSTfd/T4Bjfumi4sjQB90NhfSJsc/gKPCPIGf8
         qZBYGsY3nwILArDNOlH+AJ6wY23BfDYEgnHUv7+CuQOA6eqGWltrm1ChyWxkmqeZtG
         nP3KoKzLIhCNL+OTmDN+sl78eQjFW2FM/zuX6zqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Shyam Sundar <ssundar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, fcoe-devel@open-fcoe.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 317/330] scsi: libfc: Skip additional kref updating work event
Date:   Thu, 17 Sep 2020 22:00:57 -0400
Message-Id: <20200918020110.2063155-317-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 823a65409c8990f64c5693af98ce0e7819975cba ]

When an rport event (RPORT_EV_READY) is updated without work being queued,
avoid taking an additional reference.

This issue was leading to memory leak. Trace from KMEMLEAK tool:

  unreferenced object 0xffff8888259e8780 (size 512):
  comm "kworker/2:1", jiffies 4433237386 (age 113021.971s)
    hex dump (first 32 bytes):
	58 0a ec cf 83 88 ff ff 00 00 00 00 00 00 00 00
	01 00 00 00 08 00 00 00 13 7d f0 1e 0e 00 00 10
  backtrace:
  [<000000006b25760f>] fc_rport_recv_req+0x3c6/0x18f0 [libfc]
  [<00000000f208d994>] fc_lport_recv_els_req+0x120/0x8a0 [libfc]
  [<00000000a9c437b8>] fc_lport_recv+0xb9/0x130 [libfc]
  [<00000000a9c437b8>] fc_lport_recv+0xb9/0x130 [libfc]
  [<00000000ad5be37b>] qedf_ll2_process_skb+0x73d/0xad0 [qedf]
  [<00000000e0eb6893>] process_one_work+0x382/0x6c0
  [<000000002dfd9e21>] worker_thread+0x57/0x5c0
  [<00000000b648204f>] kthread+0x1a0/0x1c0
  [<0000000072f5ab20>] ret_from_fork+0x35/0x40
  [<000000001d5c05d8>] 0xffffffffffffffff

Below is the log sequence which leads to memory leak.  Here we get the
RPORT_EV_READY and RPORT_EV_STOP back to back, which lead to overwrite the
event RPORT_EV_READY by event RPORT_EV_STOP.  Because of this, kref_count
gets incremented by 1.

  kernel: host0: rport fffce5: Received PLOGI request
  kernel: host0: rport fffce5: Received PLOGI in INIT state
  kernel: host0: rport fffce5: Port is Ready
  kernel: host0: rport fffce5: Received PRLI request while in state Ready
  kernel: host0: rport fffce5: PRLI rspp type 8 active 1 passive 0
  kernel: host0: rport fffce5: Received LOGO request while in state Ready
  kernel: host0: rport fffce5: Delete port
  kernel: host0: rport fffce5: Received PLOGI request
  kernel: host0: rport fffce5: Received PLOGI in state Delete - send busy
  kernel: host0: rport fffce5: work event 3
  kernel: host0: rport fffce5: lld callback ev 3
  kernel: host0: rport fffce5: work delete

Link: https://lore.kernel.org/r/20200626094959.32151-1-jhasan@marvell.com
Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index aabf51df3c02f..64500417c22ea 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -483,10 +483,11 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 
 	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
 
-	kref_get(&rdata->kref);
-	if (rdata->event == RPORT_EV_NONE &&
-	    !queue_work(rport_event_queue, &rdata->event_work))
-		kref_put(&rdata->kref, fc_rport_destroy);
+	if (rdata->event == RPORT_EV_NONE) {
+		kref_get(&rdata->kref);
+		if (!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref, fc_rport_destroy);
+	}
 
 	rdata->event = event;
 }
-- 
2.25.1

