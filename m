Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D29AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jun 2022 16:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345057AbiFOQmN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jun 2022 12:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbiFOQmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2022 12:42:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17E34BFF8
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 09:42:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6101021C3D;
        Wed, 15 Jun 2022 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655311329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0eKr/SVcbEkgtLJ6ILiD98P2U8h/3LEaBuySCjEax6A=;
        b=GbNkRftgmo7+k+6yNekMtSp3Nqo51+90Q3vhjcbl8+AwxyxK604tvN5z7Ip2QQeRe1skns
        oBzTm/MOS7uUYJGcfEubLmVI0uyhJxhPFsBHqnpeuf84Ye+ZLKlYUR5ivOBm2S4WWfAx40
        feO8pE0XXbPL83UctkMY49x4tQsJ9Fk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1160B139F3;
        Wed, 15 Jun 2022 16:42:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7DJcAuELqmKIcwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 15 Jun 2022 16:42:09 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/2] Fixes for device probing on flaky connections
Date:   Wed, 15 Jun 2022 18:41:47 +0200
Message-Id: <20220615164149.3092-1-mwilck@suse.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

We have seen device probing errors in FCoE uplink failover tests.
After device loss and link recovery, spurious packet loss in the fabric may
cause device rediscovery to fail. With the two following patches, the
rediscovery failure could be avoided.

Reviews and comments welcome,
Martin

Hannes Reinecke (1):
  scsi: add BLIST_RETRY_SCAN to ignore errors during scanning

Martin Wilck (1):
  scsi: scan: retry INQUIRY after timeout

 drivers/scsi/scsi_scan.c    | 17 ++++++++++++++---
 include/scsi/scsi_devinfo.h |  4 +++-
 2 files changed, 17 insertions(+), 4 deletions(-)

-- 
2.36.1

