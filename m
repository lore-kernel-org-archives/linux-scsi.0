Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1128BC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6875610FE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237492AbhHSJRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:17:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60568 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbhHSJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0FD9C220C1;
        Thu, 19 Aug 2021 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BYm5IXodufhhIGmaT8/O691A8hbVy3yQOS/o44FJzag=;
        b=q9DfD0R/T6lVtm0osD0hmSuYdY6p+2mrITrVEv1ffgrnBnFK5tpVPTy5MQm2FOu9LYpAVG
        Cwkgd0BlnGYbzY2IW015FytJXmkvtHKFnxwizimvA88V1ASv1QlEAkvhU1dGdUI5o+e3US
        GFTx1b1wrOYkKCl6XXt5rxXqxR+hJWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364600;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BYm5IXodufhhIGmaT8/O691A8hbVy3yQOS/o44FJzag=;
        b=pMgfdUl9mrkJl416Xk09Lg7ghhgN3b3aSg6LRsVdAdVGcFTzT9zIdl9614UqwKcDYEyQKH
        Uuczhnyf9j7z3yCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4DDB0A3B8D;
        Thu, 19 Aug 2021 09:16:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id F02BD518D28E; Thu, 19 Aug 2021 11:16:39 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] megaraid: Fixes for SCSI EH rework
Date:   Thu, 19 Aug 2021 11:16:33 +0200
Message-Id: <20210819091636.94311-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

with the SCSI EH rework the scsi_cmnd argument for the SCSI EH
callbacks is going away, so we need to fixup the drivers to work
without it.

This patchset modifies the megaraid driver to not rely on a
specific command for the SCSI EH callbacks.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  megaraid: complete all commands in megaraid_reset()
  megaraid: rename megaraid_abort_and_reset() to __megaraid_abort()
  megaraid: remove pointless bus_reset and device_reset handler

 drivers/scsi/megaraid.c | 63 +++++++++++++++++++++++++++--------------
 drivers/scsi/megaraid.h |  2 +-
 2 files changed, 42 insertions(+), 23 deletions(-)

-- 
2.29.2

