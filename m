Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B716C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD0D61100
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhHSJUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:20:01 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37176 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhHSJUA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:20:00 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 41D06200B2;
        Thu, 19 Aug 2021 09:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=jvyBlpnMdOIvXrO2ECjxFVOqBD2NVJVVULdnx15ntFE=;
        b=qMw0+0vrW9IkI3/oTTzByJ+EJPTqBBEsFRXtVAuohfQqJ1efc1VWefFX7PDElGpsvNscVd
        xGEI2w2ObEwfWrv/kzskh4PIXmc2tTkB0Y5tFvtZXEj29AQm76LcM3tMM2e6WnqRZhGtbM
        gOPB/HOl5iFuBE8ml3I7hhqveKWQjOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=jvyBlpnMdOIvXrO2ECjxFVOqBD2NVJVVULdnx15ntFE=;
        b=eVoy/VLxr1KGiW5hHY1Hn+Ai5bgT1TBGYdTpXAiJprttGHBbWKMXY6WaEgInHIYyxtLCvt
        DzOd8RsQG8hGgnAw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 7FA57A3B98;
        Thu, 19 Aug 2021 09:19:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 2D460518D296; Thu, 19 Aug 2021 11:19:24 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] qla2xxx: Fixes for SCSI EH rework
Date:   Thu, 19 Aug 2021 11:19:10 +0200
Message-Id: <20210819091913.94436-1-hare@suse.de>
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

This patchset modifies the qla2xxx driver to not rely on a
specific command for the SCSI EH callbacks.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  qla2xxx: Do not call fc_block_scsi_eh() during bus reset
  qla2xxx: Open-code qla2xxx_eh_target_reset()
  qla2xxx: Open-code qla2xxx_eh_device_reset()

 drivers/scsi/qla2xxx/qla_os.c | 116 ++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 42 deletions(-)

-- 
2.29.2

