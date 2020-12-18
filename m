Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0092C2D0E4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7862B23BA7
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbgLRUoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:44:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54694 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLRUoi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:44:38 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lu/dV1TyqURtGfqdtTj/c6N1W64ljY35p4U2iM/g55A=;
        b=N69850D8cM+PM4lLMISLwv48bT7+DVxy6T3AODJ6gnOE5+AEKqSoGq6DShIlWP31lXU2VZ
        xLgPbNdb1gPUZ+45g551vMGttmcQdO+zRfCqI5abO+CkMSp1gHKWIwLepM2BrWpo2iDsdl
        ue/Vi/pPeoxRcxakf74O4CjzSNYRAQzZDZUkpI6iuPlR62Q37LxMD3EIQa5DO4prOiBKiL
        eajG8H5280EE9T0v87XoZjpOL+L/ZeAaFvGxYq11Qe60dpApY1kTQwxEJOFdg2goQ/klV9
        vmNVLKPXS32DL3fe2hZOF9cG1XnQuAY16nVIztWLtQe0kJtHenaSWVOI5xKxHg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lu/dV1TyqURtGfqdtTj/c6N1W64ljY35p4U2iM/g55A=;
        b=g2R3y2BoNUE6A288AWYW6Pt70zoWRF5y0+clbQIcmVKLID3WjPAhAXf0gkbA7NGWjM5Wv/
        OnV1jPbTzFwgCMBg==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 00/11] scsi: libsas: Remove in_interrupt() check
Date:   Fri, 18 Dec 2020 21:43:43 +0100
Message-Id: <20201218204354.586951-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Folks,

In the discussion about preempt count consistency across kernel
configurations:

  https://lkml.kernel.org/r/20200914204209.256266093@linutronix.de

it was concluded that the usage of in_interrupt() and related context
checks should be removed from non-core code.

This includes memory allocation mode decisions (GFP_*). In the long run,
usage of in_interrupt() and its siblings should be banned from driver
code completely.

This series addresses SCSI libsas. Basically, the function:

  => drivers/scsi/libsas/sas_init.c:
  struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
  {
        ...
        gfp_t flags = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
        event = kmem_cache_zalloc(sas_event_cache, flags);
        ...
  }

is transformed so that callers explicitly pass the gfp_t memory
allocation flags. Affected libsas clients are modified accordingly.

The first six patches have "Fixes: " tags and address bugs the were
noticed during the context analysis.

Thanks!

8<--------------

Ahmed S. Darwish (11):
  Documentation: scsi: libsas: Remove notify_ha_event()
  scsi: libsas: Introduce a _gfp() variant of event notifiers
  scsi: mvsas: Pass gfp_t flags to libsas event notifiers
  scsi: isci: port: link down: Pass gfp_t flags
  scsi: isci: port: link up: Pass gfp_t flags
  scsi: isci: port: broadcast change: Pass gfp_t flags
  scsi: libsas: Pass gfp_t flags to event notifiers
  scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
  scsi: aic94xx: Pass gfp_t flags to libsas event notifiers
  scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
  scsi: libsas: event notifiers: Remove non _gfp() variants

 Documentation/scsi/libsas.rst          |  5 ++--
 drivers/scsi/aic94xx/aic94xx_scb.c     | 18 ++++++------
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 26 ++++++++++--------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  5 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  5 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 ++--
 drivers/scsi/isci/port.c               | 14 ++++++----
 drivers/scsi/libsas/sas_event.c        | 21 ++++++++------
 drivers/scsi/libsas/sas_init.c         | 11 ++++----
 drivers/scsi/libsas/sas_internal.h     |  4 +--
 drivers/scsi/mvsas/mv_sas.c            | 22 +++++++--------
 drivers/scsi/pm8001/pm8001_hwi.c       | 38 +++++++++++++-------------
 drivers/scsi/pm8001/pm8001_sas.c       |  8 +++---
 drivers/scsi/pm8001/pm80xx_hwi.c       | 30 ++++++++++----------
 include/scsi/libsas.h                  |  4 +--
 16 files changed, 116 insertions(+), 103 deletions(-)

base-commit: 2c85ebc57b3e1817b6ce1a6b703928e113a90442
--
2.29.2
