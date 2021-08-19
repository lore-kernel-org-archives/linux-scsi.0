Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51017C43214
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 326966109E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhHSIkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 04:40:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58210 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbhHSIkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 04:40:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DD324200B3;
        Thu, 19 Aug 2021 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629362412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=h5T8B6MNnfs7HupsawhS9P84gqs3VgEbElLMmMK/PWI=;
        b=Qn0RD89waGWDC5o2fHPEG9S5XMtqjGEwIvE8LwgXpS3wE7TzWt+lBM7z6RXQxY7/B+7vQi
        kXy2AnxPrjfw+KscL6CsX87jjZzEBGUol1eBvAtX1eUw0BOiJ5xc7MMxs9yqxTkPf1pN9n
        El6SBm8/cIBeWjbDuEu2bdfdCmugEsI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629362412;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=h5T8B6MNnfs7HupsawhS9P84gqs3VgEbElLMmMK/PWI=;
        b=jZ6aJkHXqW1DaL/dnA1y/OTI2a+0gBi+S2yMJYRMmE3RG+CWj2N4taQ11IovvHfhbP8Xj6
        8ApiDjstFvnwNLCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 2DD8DA3B9F;
        Thu, 19 Aug 2021 08:40:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 63533518D25D; Thu, 19 Aug 2021 10:40:12 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] scsi: remove last references to scsi_cmnd.tag
Date:   Thu, 19 Aug 2021 10:40:03 +0200
Message-Id: <20210819084007.79233-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

with commit 4c7b6ea336c1 ("scsi: core: Remove scsi_cmnd.tag") drivers
cannot reference the SCSI command tag anymore.
Arguably these drivers would have stopped working since 2010 with
the switch to block layer tags in SCSI anyway, so chances are no-one
had been using tagging in these drivers.

This patchset fixes up these usage; for fas216 we're just switching
to use the appropriate wrapper.
For acornscsi the tagged queue handling is removed altogether as it
was broken in the first place, and no-one since the switch to git
could be bothered to fix it.
And the patchset has the nice side-effect that we can remove the
scsi_device.current_tag field.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  scsi: Introduct scsi_cmd_to_tag()
  fas216: kill scmd->tag
  acornscsi: remove tagged queuing vestiges
  scsi: remove 'current_tag'

 drivers/scsi/arm/Kconfig     |  11 ----
 drivers/scsi/arm/acornscsi.c | 103 ++++++++---------------------------
 drivers/scsi/arm/fas216.c    |  31 +++--------
 drivers/scsi/arm/queue.c     |   2 +-
 include/scsi/scsi_cmnd.h     |   7 +++
 include/scsi/scsi_device.h   |   1 -
 6 files changed, 38 insertions(+), 117 deletions(-)

-- 
2.29.2

