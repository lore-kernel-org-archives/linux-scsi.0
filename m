Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B918BC433E3
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D0A207BC
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgE2Nrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 09:47:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:35728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgE2Nrj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 09:47:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D25AEAF94;
        Fri, 29 May 2020 13:47:36 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 0/5] scsi: use xarray for devices and targets
Date:   Fri, 29 May 2020 15:47:25 +0200
Message-Id: <20200529134730.146573-1-hare@suse.de>
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
 - Most SCSI targets are only using the first 32 bits of the 64 bit
   LUN structure. So there we can use the LUN number as the index into
   the xarray; larger LUN numbers won't fit, so we'll allocate a
   separate index for those. For these device lookup won't be as
   efficient, but one can argue that we're running into scalability
   issues long before that.

With these changes we can implement an efficient lookup mechanism,
devolving into direct lookup for most cases.
And iteration over devices should be as efficient as the current,
list-based, approach.

It also removes the current duality between host-based and
target-based device lists; now all devices are listed per target,
and a full iteration would need to iterate first over all targets
and then over all devices per target.

As usual, comments and reviews are welcome

Changes to v1:
- Fixup __scsi_iterate_devices()
- Include reviews from Johannes
- Minor fixes
- Include comments from Doug

Changes to v2:
- Reshuffle hunks as per suggestion from Johannes

Changes to v3:
- Use GFP_ATOMIC instead of GFP_KERNEL
- Fixup target iteration as reported by Doug Gilbert
- Update scsi_error to make use of the new iterators

Hannes Reinecke (5):
  scsi: convert target lookup to xarray
  target_core_pscsi: use __scsi_device_lookup()
  scsi: move target device list to xarray
  scsi: remove direct device lookup per host
  scsi_error: use xarray lookup instead of wrappers

 drivers/scsi/hosts.c               |   4 +-
 drivers/scsi/scsi.c                | 151 +++++++++++++++++++++++++++++--------
 drivers/scsi/scsi_error.c          |  35 +++++----
 drivers/scsi/scsi_lib.c            |   9 +--
 drivers/scsi/scsi_priv.h           |   2 +
 drivers/scsi/scsi_scan.c           |  73 +++++++++---------
 drivers/scsi/scsi_sysfs.c          |  48 ++++++++----
 drivers/target/target_core_pscsi.c |   8 +-
 include/scsi/scsi_device.h         |  32 +++++---
 include/scsi/scsi_host.h           |   5 +-
 10 files changed, 243 insertions(+), 124 deletions(-)

-- 
2.16.4

