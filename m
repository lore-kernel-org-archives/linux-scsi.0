Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C17C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D24B61100
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhHSJIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:08:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36562 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhHSJIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:08:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D7D5D1FD7C;
        Thu, 19 Aug 2021 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fvRPsVD2t4tDq1wGoJ6klcoAbNEUea0FL8iiGqHnM1E=;
        b=uUxzN18gtt7ADaleE8YwlNq9Ry9gp2Pf3/4T738NVQRYw452DWtvHGedyvHWEDdh9jysRa
        QuzGZw+8ud1mOfztuSmqWHQxjG+f8OCXj3osIEuSlq+sK+dLs1MBRxR93jgWZoigDU4Q91
        QoLKhNpvAXWnB7aPNRMEnQ5BiglCpz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fvRPsVD2t4tDq1wGoJ6klcoAbNEUea0FL8iiGqHnM1E=;
        b=wGHwNK21lruG0Xl7ejBE2wGQHc0lJXIbsnuJB0avVZgpEAH6i08E3XqI7zHFsRXCOou1bk
        MHKGhdzq5z4qNUCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1A449A3BA6;
        Thu, 19 Aug 2021 09:07:19 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C1F46518D273; Thu, 19 Aug 2021 11:07:28 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] sym53c8xx_2: Fixes for SCSI EH rework
Date:   Thu, 19 Aug 2021 11:07:12 +0200
Message-Id: <20210819090716.94049-1-hare@suse.de>
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

This patchset modifies the sym53c8xx_2 driver to split off the
combined SCSI EH routine into the individual EH callbacks and to
not rely on a specific command for those.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  sym53c8xx_2: move PCI EEH handling to host reset
  sym53c8xx_2: split off host reset from sym_eh_handler()
  sym53c8xx_2: split off bus reset from sym_eh_handler()
  sym53c8xx_2: rework reset handling

 drivers/scsi/sym53c8xx_2/sym_glue.c | 220 +++++++++++++++++++---------
 1 file changed, 147 insertions(+), 73 deletions(-)

-- 
2.29.2

