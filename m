Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AF2C433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5F12068D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgFBLeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:34:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:37866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgFBLeT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jun 2020 07:34:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5B8D4AD3A;
        Tue,  2 Jun 2020 11:34:20 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 0/6] scsi: use xarray for devices and targets
Date:   Tue,  2 Jun 2020 13:33:05 +0200
Message-Id: <20200602113311.121513-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

based on the ideas from Doug Gilbert here's now my take on using
xarrays for devices and targets.
It revolves around two ideas:

- The scsi target 'channel' and 'id' numbers are never ever used
  to the full 32 bit range; channels are well below 10, and no
  driver is using more than 16 bits for the id. So we can reduce
  the type of 'channel' and 'id' to 16 bits, and use the 32 bit
  value 'channel << 16 | id' as the index into the target xarray.
- Nearly every target only ever uses the first two levels of the
  4-level SCSI LUN structure, which means that we can use the
  linearized SCSI LUN id as an index into the xarray.
  If we ever come across targets utilizing more that 2 levels of
  the LUN structure we'll allocate the first unused index and have
  to resort to a less efficient lookup instead of direct indexing.

With these changes we can implement an efficient lookup mechanism,
devolving into direct lookup for most cases. It also allows us to
detect duplicate entries or accidental overwrites of existing elements
by using xa_cmpxchg().
And iteration over targets and devices should be as efficient as the
current, list-based, approach.

As usual, comments and reviews are welcome.

Changes to v2:
- Implement safe device iteration as noted by Doug
- Add an additional patch to avoid a pointless memory allocation
  in scsi_alloc_target()

Hannes Reinecke (6):
  scsi: convert target lookup to xarray
  target_core_pscsi: use __scsi_device_lookup()
  scsi: move target device list to xarray
  scsi: remove direct device lookup per host
  scsi_error: use xarray lookup instead of wrappers
  scsi: avoid pointless memory allocation in scsi_alloc_target()

 drivers/scsi/hosts.c               |   5 +-
 drivers/scsi/scsi.c                | 151 +++++++++++++++++++++++++++++--------
 drivers/scsi/scsi_error.c          |  35 +++++----
 drivers/scsi/scsi_lib.c            |   9 +--
 drivers/scsi/scsi_priv.h           |   2 +
 drivers/scsi/scsi_scan.c           | 101 +++++++++++++++----------
 drivers/scsi/scsi_sysfs.c          |  72 +++++++++++++-----
 drivers/target/target_core_pscsi.c |   8 +-
 include/scsi/scsi_device.h         |  32 +++++---
 include/scsi/scsi_host.h           |   5 +-
 10 files changed, 288 insertions(+), 132 deletions(-)

-- 
2.16.4

