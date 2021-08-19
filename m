Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B28C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 341BC6108B
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhHSJNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:13:08 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36764 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbhHSJNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:13:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E58F51FD84;
        Thu, 19 Aug 2021 09:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=eEoS7LeK32LRG5fToGNY0grWPPNf12oS4YZHjvgmZ4M=;
        b=f6m7hT0LsK5m68R2GjsFuh1nlhTgnYsq+bMRhjHcYwKIfAn3glxD1yOulQTjwFC+N3Jo8v
        uOuyAIXgr/tFDCUX3ROW2YgvuphoOtBSAD4MSsb2g4Zq1R3BLnipKlwsr+g7kRnCiJKMA8
        +bXM3zk5pk99tXIkWMUmtbZMROangUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364348;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=eEoS7LeK32LRG5fToGNY0grWPPNf12oS4YZHjvgmZ4M=;
        b=8aOxuYAd2B04R9gIRGKO/cL4lKdpzMFbrg6H6FyHr+J0lV5Sa4A+CCprOTf7qrzbQxzTnv
        fLG6ic76fdlAZ+AA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 28E73A3B9A;
        Thu, 19 Aug 2021 09:12:19 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CE416518D286; Thu, 19 Aug 2021 11:12:28 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] snic: Fixes for SCSI EH rework
Date:   Thu, 19 Aug 2021 11:12:21 +0200
Message-Id: <20210819091224.94213-1-hare@suse.de>
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

This patchset modifies the snic driver to not rely on a
specific command for the SCSI EH callbacks.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  snic: reserve tag for TMF
  snic: use dedicated device reset command
  snic: Use scsi_host_busy_iter() to traverse commands

 drivers/scsi/snic/snic.h      |   3 +-
 drivers/scsi/snic/snic_main.c |   3 +
 drivers/scsi/snic/snic_scsi.c | 308 ++++++++++++++++------------------
 3 files changed, 149 insertions(+), 165 deletions(-)

-- 
2.29.2

