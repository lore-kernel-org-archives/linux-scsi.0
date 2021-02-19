Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888DFC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 15:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 437CD64DFD
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 15:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhBSPl3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 10:41:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:47414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhBSPl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Feb 2021 10:41:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613749238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MHxag6mUxa0dootKy2U+lJVR2k8UiaKbpKfVyKM/EZ4=;
        b=jjsdawg1KZYf+nItuzbxyqaXeDKHiLv6YoeaErBu4tJer4zXSytLV7xk92MixdQUnvPRED
        iXUz6DrGfs47sGkqcF453+W0zBJW6WReMsknyI3WKg9iAusmhGukYAazPdCEFJ6k8mopm3
        ZGwTClr2lapCAwa2bLNQ99xzaXwou3k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 17FFFAED2;
        Fri, 19 Feb 2021 15:40:38 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 0/8] xen/events: bug fixes and some diagnostic aids
Date:   Fri, 19 Feb 2021 16:40:22 +0100
Message-Id: <20210219154030.10892-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first four patches are fixes for XSA-332. The avoid WARN splats
and a performance issue with interdomain events.

Patches 5 and 6 are some additions to event handling in order to add
some per pv-device statistics to sysfs and the ability to have a per
backend device spurious event delay control.

Patches 7 and 8 are minor fixes I had lying around.

Juergen Gross (8):
  xen/events: reset affinity of 2-level event when tearing it down
  xen/events: don't unmask an event channel when an eoi is pending
  xen/events: avoid handling the same event on two cpus at the same time
  xen/netback: fix spurious event detection for common event case
  xen/events: link interdomain events to associated xenbus device
  xen/events: add per-xenbus device event statistics and settings
  xen/evtchn: use smp barriers for user event ring
  xen/evtchn: use READ/WRITE_ONCE() for accessing ring indices

 .../ABI/testing/sysfs-devices-xenbus          |  41 ++++
 drivers/block/xen-blkback/xenbus.c            |   2 +-
 drivers/net/xen-netback/interface.c           |  24 ++-
 drivers/xen/events/events_2l.c                |  22 +-
 drivers/xen/events/events_base.c              | 199 +++++++++++++-----
 drivers/xen/events/events_fifo.c              |   7 -
 drivers/xen/events/events_internal.h          |  14 +-
 drivers/xen/evtchn.c                          |  29 ++-
 drivers/xen/pvcalls-back.c                    |   4 +-
 drivers/xen/xen-pciback/xenbus.c              |   2 +-
 drivers/xen/xen-scsiback.c                    |   2 +-
 drivers/xen/xenbus/xenbus_probe.c             |  66 ++++++
 include/xen/events.h                          |   7 +-
 include/xen/xenbus.h                          |   7 +
 14 files changed, 327 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-xenbus

-- 
2.26.2

