Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F36C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbiE3XPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiE3XPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:39 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19747712D4
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:36 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 21573820F9D;
        Mon, 30 May 2022 23:15:36 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id A32D782116F;
        Mon, 30 May 2022 23:15:35 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952535; a=rsa-sha256;
        cv=none;
        b=KhaH9Fd55Ji+A6gKMXRb2oox0nhSJojTeCMT3yOYY/4X/B3tRhKqtPr7xZtiRew9yneqgd
        vNKSlp5J0taiRDsqdcNlYdqEQiz3YvvKvbwRr8oyjHH7HOWx6XsXDq82EnSVAWbUFfFCOf
        7okm/FCCnQrRysUunf5Tk5LjzBHSQCfTuzGB80ez+kk8p8VaWMKHhm/9vUiBfDDT6VKyhH
        dNB738LrmZ2IQI4pOTxpjmTVUDmDFeSdRpx+Ix3CUjjuBOajB9eucvTS8R9E6Zn90q+mpA
        wDuF2C2GRKA3Pnmzi7tfdumIOQAManUXF86pmDLTvgoliNPKJotAQZxATA0GRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:dkim-signature;
        bh=n35TnBH2Xxxk4DebajgfKZ1G+VRtmIlU0Kfo9mxIx40=;
        b=mHm5u6JV+oPXRh0JoN7XfjVPsR5mi9z3oJUfxkpjwboLuyRAErgaYGgsWpx334p5t+kuSi
        xxsFpUXOcsnwlMasaYFlns4ppLd4ozioC6JdU8ejR7Qrp5uPJ6SW/ZHUQiNS2aMAoot12n
        GI0NX8I5FnTxbmb8NktI/RrOrfn4FkdV61McF+Abzf96OcYJPNuIKFbpLDawO/721i6r2K
        Ef5NcPABon39UgK5fjY/qv3elS3xmCQUgzeBl19Pm73iqeAIGTMKKlB+s7Wb1gbsU4jSpz
        T38782aDMmROZwxAwMqrqUfE6XtryDm2vXKWuNYeYnAxdLCuAUjBgNRbqh0ytw==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-t8h82;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Bubble-Illegal: 1350ad7914b2f63b_1653952535982_2184320796
X-MC-Loop-Signature: 1653952535982:1546653184
X-MC-Ingress-Time: 1653952535982
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.127.95.72 (trex/6.7.1);
        Mon, 30 May 2022 23:15:35 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqV5hqYz15;
        Mon, 30 May 2022 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952535;
        bh=n35TnBH2Xxxk4DebajgfKZ1G+VRtmIlU0Kfo9mxIx40=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=CMD4R3iu/FTM42ERTzA0TMlzrTI0Wwyuf3oVsigEGGzdCRjqxXuC+MoTqD0PvW6CJ
         ByMoQuPYM9bZfa5rKBD82f03RfwVCwnfi6JZPsfKrL3KzrlQGO4TWLNdyHRtbXCGKH
         0zCj3S4m9yoeu6Q8M5dDFXORp4WBw8Ag9q8YlzMGOJ13ok8LIxkUqXNN1jCreK0BiJ
         mBYY8cO7x2KKHCOr0DtwSTlX9CZm9U7n+UU3pAs/NrUOze2MylSAC8TEsyNyoVMDWP
         ERtVmUnCVGigR+rvMJrrF1CECeGfc/jngswgU1ZYMBTC2KUP24OX7okWA4TbkYOioW
         ZN3JWLoR75q+Q==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net
Subject: [PATCH 00/10] scsi: Replace tasklets as BH
Date:   Mon, 30 May 2022 16:15:02 -0700
Message-Id: <20220530231512.9729-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In spirit of scsi drivers playing nicely with realtime, the following
removes most the use of tasklets throughout drivers/scsi/ replacing
them with either threaded irqs or workqueues such that they run in
regular task context instead of irq; and in addition cleans up a lot
of the async work deferral code. Only two users remain (those that
do the MSIX vector of tasklets): pm8001 and pmcraid, which I don't
have a suitable equivalent yet. One possibility would be to have a
single threaded wq per msix vector entry and thus run concurrently.

Yes, there's a bit more overhead with a task than for a softirq, but
the problem with softirqs and tasklets is that they can't be preempted,
and thus are more important than all tasks on the system. Furthermore
there are no guarantees it will run in irq context at all if ksoftirq
kicks in.

Because of a total lack of hardware, these patches have only been
compile-tested. Please consider for v5.21.

Thanks!

Davidlohr Bueso (10):
  scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
  scsi/megaraid: Replace adapter->dpc_h tasklet with threaded irq
  scsi/megaraid_sas: Replace instance->tasklet with threaded irq
  scsi/aic94xx: Replace the donelist tasklet with threaded irq
  scsi/isci: Replace completion_tasklet with threaded irq
  scsi/ibmvscsi_tgt: Replace work tasklet with threaded irq
  scsi/esas2r: Replace tasklet with workqueue
  scsi/ibmvfc: Replace tasklet with work
  scsi/ibmvscsi: Replace srp tasklet with work
  scsi/lpfc: Remove bogus references to discovery tasklet

 drivers/scsi/aic94xx/aic94xx_hwi.c          | 23 ++----
 drivers/scsi/aic94xx/aic94xx_hwi.h          |  5 +-
 drivers/scsi/aic94xx/aic94xx_init.c         |  5 +-
 drivers/scsi/aic94xx/aic94xx_scb.c          | 88 ++++++---------------
 drivers/scsi/aic94xx/aic94xx_task.c         | 16 ++--
 drivers/scsi/aic94xx/aic94xx_tmf.c          | 40 +++++-----
 drivers/scsi/esas2r/esas2r.h                | 19 ++---
 drivers/scsi/esas2r/esas2r_init.c           | 20 +++--
 drivers/scsi/esas2r/esas2r_int.c            | 20 ++---
 drivers/scsi/esas2r/esas2r_io.c             |  2 +-
 drivers/scsi/esas2r/esas2r_main.c           | 34 +++++---
 drivers/scsi/ibmvscsi/ibmvfc.c              | 21 ++---
 drivers/scsi/ibmvscsi/ibmvfc.h              |  3 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            | 38 ++++++---
 drivers/scsi/ibmvscsi/ibmvscsi.h            |  3 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    | 17 ++--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h    |  1 -
 drivers/scsi/isci/host.c                    | 12 +--
 drivers/scsi/isci/host.h                    |  3 +-
 drivers/scsi/isci/init.c                    | 17 ++--
 drivers/scsi/lpfc/lpfc.h                    |  2 -
 drivers/scsi/lpfc/lpfc_disc.h               |  2 +-
 drivers/scsi/megaraid/mega_common.h         |  2 -
 drivers/scsi/megaraid/megaraid_mbox.c       | 52 +++++-------
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 51 ++++++------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 18 +++--
 drivers/scsi/mvsas/Kconfig                  |  7 --
 drivers/scsi/mvsas/mv_init.c                | 44 ++---------
 drivers/scsi/mvsas/mv_sas.h                 |  1 -
 30 files changed, 245 insertions(+), 324 deletions(-)

--
2.36.1

