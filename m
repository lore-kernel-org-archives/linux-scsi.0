Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA6CC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 09:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50CE8610D2
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 09:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhHTJyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 05:54:49 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56182 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236384AbhHTJys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 05:54:48 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E37EC22065;
        Fri, 20 Aug 2021 09:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629453249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=133/t3hnQarby0bVF12kBqrKQyl9a4rOkU7a6doSgYc=;
        b=fTfkWzaHy6jggiZPt3TShrMde6l9XIYTQWkMXdLlpXb6yyaougjhfp+JpSJ7yHz41aDtES
        YugDwfN6g25Pqysc0Fu0cTUALjqFDfolKab5Oax6S1hj9fK+AHTp4DXeL8oN1jLKeasv7j
        q1WdF2cIOOsOJrn9snZ8m27GnL3lag4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629453249;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=133/t3hnQarby0bVF12kBqrKQyl9a4rOkU7a6doSgYc=;
        b=0TsoH4l5omnnx/b0IQHF3HNOmbem89NZBZg3b4XRZHJ6X8N2POVzim5r7SMKCE8gBcQHwI
        lEl6dvGa+X+YRjAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DA2A0A3B90;
        Fri, 20 Aug 2021 09:54:09 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C8BD9518D44F; Fri, 20 Aug 2021 11:54:09 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] ncr53c8xx: Fixes for SCSI EH rework
Date:   Fri, 20 Aug 2021 11:54:02 +0200
Message-Id: <20210820095405.12801-1-hare@suse.de>
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

This patchset modifies the ncr53c8xx driver to not rely on a
specific command for the SCSI EH callbacks.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  ncr53c8xx: remove 'sync_reset' argument from ncr_reset_bus()
  ncr53c8xx: Complete all commands during bus reset
  ncr53c8xx: Remove unused code

 drivers/scsi/ncr53c8xx.c | 199 +--------------------------------------
 1 file changed, 2 insertions(+), 197 deletions(-)

-- 
2.29.2

