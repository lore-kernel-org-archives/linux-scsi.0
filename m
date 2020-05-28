Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833BFC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 614C820829
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405110AbgE1Qgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 12:36:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:33208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405062AbgE1Qgs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 12:36:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52D1BACCC;
        Thu, 28 May 2020 16:36:46 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/4] scsi: use xarray for devices and targets
Date:   Thu, 28 May 2020 18:36:21 +0200
Message-Id: <20200528163625.110184-1-hare@suse.de>
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
 - Most SCSI LUNs are below 256 (to ensure compability with older
   systems). So there we can use the LUN number as the index into
   the xarray; for larger LUN numbers we'll allocate a separate
   index.

With these changes we can implement an efficient lookup mechanism,
devolving into direct lookup for most cases.
And iteration should be as efficient as the current, list-based,
approach.

This patchset now survives basic testing, hence I've removed
the 'RFC' tag from the initial patchset.

Changes to v1:
- Fixup __scsi_iterate_devices()
- Include reviews from Johannes
- Minor fixes
- Include comments from Doug

Changes to v2:
- Reshuffle hunks as per suggestion from Johannes

Hannes Reinecke (4):
  scsi: convert target lookup to xarray
  target_core_pscsi: use __scsi_device_lookup()
  scsi: move target device list to xarray
  scsi: remove direct device lookup per host

 drivers/scsi/hosts.c               |   3 +-
 drivers/scsi/scsi.c                | 131 ++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_lib.c            |   9 ++-
 drivers/scsi/scsi_scan.c           |  66 ++++++++-----------
 drivers/scsi/scsi_sysfs.c          |  42 ++++++++----
 drivers/target/target_core_pscsi.c |   8 +--
 include/scsi/scsi_device.h         |  21 +++---
 include/scsi/scsi_host.h           |   5 +-
 8 files changed, 179 insertions(+), 106 deletions(-)

-- 
2.16.4

