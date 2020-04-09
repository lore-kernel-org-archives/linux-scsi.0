Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32CAEC2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 10:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F8621D90
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 10:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="YR9Ity0k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgDIKKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 06:10:51 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.67]:54266 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgDIKKv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2020 06:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1586427048; i=@ts.fujitsu.com;
        bh=giM/dw1dcEYrqoVlqMwf3SlT3ImkBb6GTq12Vs5Bfjo=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=YR9Ity0kY4AOVexArcieauPMUX0bIoQoH036aWZEbLkmZ/craRcqpeFVkLl0IP7eE
         N8udRwj2uVmBEM8s8dScF8x8X5Rg5KI4Hv0NT12B7LmvgX5h3jrDFufRFCbK8yLYKM
         vFgZWYpqVfTtMt8Hsdp0fdyWOwdPETjYu3O7qozXqItwQoctyV7ybvQco/GYmMoBtB
         1UV3E+c2ItMlYb65+BY9to/vUV5ypWAFWoSTdOri6copfTUohbpKrzkv3W5VDJJwBL
         MtmfljrDZtVpR8CtAE4soEAK4QaVg1nhSCXG2N8xgvUAlsj/uuNAEpQDQ76/kqY9yq
         9leVtBTrYHDFQ==
Received: from [100.112.198.35] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-west-1.aws.symcld.net id 33/FB-36764-8A4FE8E5; Thu, 09 Apr 2020 10:10:48 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRWlGSWpSXmKPExsViZ8MxVXfFl74
  4g4lTmS26r+9gs1h+/B+TxfojGxgtWpe+ZXJg8fj49BaLx/t9V9k8Pm+SC2COYs3MS8qvSGDN
  uPB6PmPBDo6Kdfv/sjQwbmDvYuTiEBKYxChx9mAXE4QznVHi3b7dQA4nB5uAgcSKSfdZQGwRA
  RuJvsNLweLMAukSG9e3MYPYwgJeEq/2/mIHsVkEVCXenH4KVs8rYCdx+v5sMFtCQF6i48Bklg
  mMnAsYGVYxWiQVZaZnlOQmZuboGhoY6BoaGukaWlrqGhkZ6yVW6SbppZbqlqcWl+ga6iWWF+s
  VV+Ym56To5aWWbGIEBkBKwfH7OxiPr32vd4hRkoNJSZR319O+OCG+pPyUyozE4oz4otKc1OJD
  jDIcHEoSvIWfgXKCRanpqRVpmTnAYIRJS3DwKInw/v0ElOYtLkjMLc5Mh0idYlSUEuddC9InA
  JLIKM2Da4NFwCVGWSlhXkYGBgYhnoLUotzMElT5V4ziHIxKwryHQMbzZOaVwE1/BbSYCWjxta
  RukMUliQgpqQamLSmnBKSaeeVt2TjXuUzM3iTKd++B1ZHq+u1mTc0G+fwXi0J6xbzPbFiS9zH
  XdpqMScbREPv8O+GXrv1bmrDr0qVpRrH6SrIVq5j3ckfwb75hwMdgtObIBNt6Rq4vzVJbplvl
  hQvXKqx7b6fFmhO5/v6K+OtZ67vCr69S05rVUn5hwr26pdE7pu9q2K577U5v7caZi833ml84f
  9LoTILSZe2pja0Kx77W/Ny0xmTO8cpP1+bNY69M5Znj+NuzbobB5e5bPr6zVrc7rkyorxfRqR
  baPF/vWyzvu8Mcu0vW7d16/Jivv1zZpqcnzab1zbp6jr/ZTeJyZvXuFh7Zmffnnssx4bGvfD/
  hcB+z7xwrJZbijERDLeai4kQAofj4o/sCAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-27.tower-291.messagelabs.com!1586427047!1847499!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 8698 invoked from network); 9 Apr 2020 10:10:48 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-27.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 9 Apr 2020 10:10:48 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 039AAgin016480;
        Thu, 9 Apr 2020 11:10:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id E50F6204D8;
        Thu,  9 Apr 2020 12:10:41 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, martin.petersen@oracle.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
Date:   Thu,  9 Apr 2020 12:10:26 +0200
Message-Id: <20200409101026.17872-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In case command ring buffer becomes inconsistent, tcmu
sets device flag TCMU_DEV_BIT_BROKEN.
If the bit is set, tcmu rejects new commands from lio core
with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, and no longer
processes completions from the ring.
The reset_ring attribute can be used to completely clean up
the command ring, so after reset_ring the ring no longer is
inconsistent.

Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN
to allow normal processing.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 0b9dfa6b17bc..f769bb1e3735 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2073,6 +2073,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mb->cmd_tail = 0;
 	mb->cmd_head = 0;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 
 	del_timer(&udev->cmd_timer);
 
-- 
2.12.3

