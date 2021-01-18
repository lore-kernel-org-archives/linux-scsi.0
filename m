Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4843EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 134B922DD3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394642AbhARV04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:26:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54866 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389058AbhARKLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:11:10 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YPz2ivAXYO8ypWKYs2DG4DM8bLkjnxAi8lTBSR5FHbg=;
        b=GfYI1+umBrd8K02Q4Q7xumP/54pZFLEdhLFrVXmx4sy3HOJi/I5eRU/HT2RXawz5RdT0Nv
        3g9PToAnC2SSf247OFZa0V3IE0rdgbcbCrQIcTiWfA/ELUxCzoQU/AKzleakJOxC9Rj50p
        dVYJqmovYUYMgg+7RehvakiQTBa/GgycSYs4qmwJUx2dH/BkfCKxjFwHriDpQ+EOPu+OQl
        cPQJUOHqOgmrr3FFw565cCh8U+gsHho8UlERTzRVbHHuemI8zHZJ8ks9Eje2JOUTIMg04X
        FKX88VFLLmXC6wdoWoO43duQPxg6E6Kw7VOCNZnT9Zj1CB+yCdMf+O6zz++FOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YPz2ivAXYO8ypWKYs2DG4DM8bLkjnxAi8lTBSR5FHbg=;
        b=FMUSDdIRLEXr6uSAEdNbX4AvkhHu0Msd6AmCIvjbcxnigdkdg3hHeBeNdXCoJQUdp8LlTv
        CL28ffE6efwgmOAg==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v3 00/19] scsi: libsas: Remove in_interrupt() check
Date:   Mon, 18 Jan 2021 11:09:36 +0100
Message-Id: <20210118100955.1761652-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Changelog v3
------------

- Include latest version of John's patch. Collect r-b tags.

- Limit all code to 80 columns, even for intermediate patches.

- Rebase over v5.11-rc4

Changelog v2
------------

https://lkml.kernel.org/r/20210112110647.627783-1-a.darwish@linutronix.de

- Rebase on top of John's patch "scsi: libsas and users: Remove notifier
  indirection", as it affects every other patch. Include it in this
  series (patch #2).

- Introduce patches #13 => #19, which modify call sites back to use the
  original libsas notifier function names without _gfp() suffix.

- Rebase over v5.11-rc3

v1 / Cover letter
-----------------

https://lkml.kernel.org/r/20201218204354.586951-1-a.darwish@linutronix.de

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

Patches #1, #2 => #7 have "Fixes: " tags and address bugs the were
noticed during the context analysis.

Thanks!

8<--------------

Ahmed S. Darwish (18):
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
  scsi: libsas: event notifiers API: Add gfp_t flags parameter
  scsi: hisi_sas: Switch back to original libsas event notifiers
  scsi: aic94xx: Switch back to original libsas event notifiers
  scsi: pm80xx: Switch back to original libsas event notifiers
  scsi: libsas: Switch back to original event notifiers API
  scsi: isci: Switch back to original libsas event notifiers
  scsi: mvsas: Switch back to original libsas event notifiers
  scsi: libsas: Remove temporarily-added _gfp() API variants

John Garry (1):
  scsi: libsas and users: Remove notifier indirection

 Documentation/scsi/libsas.rst          |  9 +----
 drivers/scsi/aic94xx/aic94xx_scb.c     | 24 ++++++------
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 29 +++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  7 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  7 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  7 ++--
 drivers/scsi/isci/port.c               | 11 +++---
 drivers/scsi/libsas/sas_event.c        | 27 ++++++-------
 drivers/scsi/libsas/sas_init.c         | 19 ++++-----
 drivers/scsi/libsas/sas_internal.h     |  6 +--
 drivers/scsi/mvsas/mv_sas.c            | 25 ++++++------
 drivers/scsi/pm8001/pm8001_hwi.c       | 54 ++++++++++++++++----------
 drivers/scsi/pm8001/pm8001_sas.c       | 12 ++----
 drivers/scsi/pm8001/pm80xx_hwi.c       | 46 ++++++++++++----------
 include/scsi/libsas.h                  |  9 +++--
 16 files changed, 149 insertions(+), 146 deletions(-)

base-commit: 19c329f6808995b142b3966301f217c831e7cf31
--
2.30.0
