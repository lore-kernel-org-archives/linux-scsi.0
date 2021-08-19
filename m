Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27000C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FACC60EFE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237494AbhHSJLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:11:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60320 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbhHSJLA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:11:00 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 797BB21BDD;
        Thu, 19 Aug 2021 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HLhMSiKgs+WVfMATBWy2NPfvHwoY3i+WzNtKX9gjp8M=;
        b=MuN7cYHLVamq6ORrZThr70v1r0Ynpa3F6HppGI+CGJQRbRBBm3dYPIu8DdcELOyGGgd9EX
        hxDAj432z86wqWjxyHSzByxDAmDvFonEIsd+J4O9W2A+TkvUgQv29P5su60O3A+v2VCsNF
        8DJYM1cyoGdO3GFLiCWSuZwQPmH/W2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364223;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HLhMSiKgs+WVfMATBWy2NPfvHwoY3i+WzNtKX9gjp8M=;
        b=FT8DrnqKcOghvQqaxJ7lubGSL+ovoA7BRvQ37FvTDuaqlhfGobkSKCqBE2XcWf/qQr/KyB
        X/S9Q1WAgnCbxKAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B3808A3B9C;
        Thu, 19 Aug 2021 09:10:13 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 66C7D518D27E; Thu, 19 Aug 2021 11:10:23 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] mptfusion: Fixes for SCSI EH rework
Date:   Thu, 19 Aug 2021 11:10:14 +0200
Message-Id: <20210819091017.94142-1-hare@suse.de>
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

This patchset modifies the mptfusion driver to not rely on a
specific command for the SCSI EH callbacks.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  mptfusion: correct definitions for mptscsih_dev_reset()
  mptfc: use fc_block_rport() instead of open-coding it
  mptfc: iterate over all rports during bus reset

 drivers/message/fusion/mptfc.c    | 96 +++++++++++++++----------------
 drivers/message/fusion/mptscsih.c | 55 +++++++++++++++++-
 drivers/message/fusion/mptscsih.h |  1 +
 3 files changed, 100 insertions(+), 52 deletions(-)

-- 
2.29.2

