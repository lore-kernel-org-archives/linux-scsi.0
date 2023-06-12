Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD07C88CB4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbjFLPDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbjFLPDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:03:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6E0CC;
        Mon, 12 Jun 2023 08:03:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 652E61FDAA;
        Mon, 12 Jun 2023 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686582200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=4RRLF67QU9Cka1JulfEZOYPSL3pjhbA85Tmqle8Ma9k=;
        b=r/ahxzOTTp91xlft6REYlge957cZ1laMQsCwBCxtLEhdHMZREnY1OuJVw7u61vFOJZXH6D
        Eddj/UHlk6XCBb5nCamdUspU5i2M3CRrTeN0Gis+zYLyjDGsdDfFwfCH8beWvTCZuc+Ymy
        nqvND375Nsq2hIOEN1s8xKaA5BziXAQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 03BE6138EC;
        Mon, 12 Jun 2023 15:03:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XGmuObczh2RMMAAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 15:03:19 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 0/6] scsi: fixes for targets with many LUNs, and scsi_target_block rework
Date:   Mon, 12 Jun 2023 17:03:03 +0200
Message-Id: <20230612150309.18103-1-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

This patch series addresses some issues we saw in a test setup
with a large number of SCSI LUNs. The first two patches simply
increase the number of available sg and bsg devices. 3-5 fix
a large delay we encountered between blocking a Fibre Channel
remote port and the dev_loss_tmo. 6 renames scsi_target_block()
to scsi_block_targets(), and makes additional changes to this API,
as suggested in the review of the v2 series.

Changes v3 -> v4:
 - skipped 4/8: keep state_mutex held while quiescing queue (Bart van Assche),
   added a comment in 4/6 to explain the rationale
 - renamed scsi_target_block() to scsi_block_targets() (Christoph Hellwig), and
   merged the previous patches 7/8 and 8/8 modifying this API into 6/6.
 - rebased to latest mkp/queue branch

Changes v2 -> v3:
 - Split previous 3/3 into 4 separate patches as suggested by
   Christoph Hellwig.
 - Added 7/8 and 8/8, as suggested by Christoph and Bart van Assche.
 - Added s-o-b and reviewed-by tags.

Changes v1 -> v2:
 - call blk_mq_wait_quiesce_done() from scsi_target_block() to
   cover the case where BLK_MQ_F_BLOCKING is set (Bart van Assche)

Hannes Reinecke (2):
  bsg: increase number of devices
  scsi: sg: increase number of devices

Martin Wilck (4):
  scsi: merge scsi_internal_device_block() and device_block()
  scsi: don't wait for quiesce in scsi_stop_queue()
  scsi: don't wait for quiesce in scsi_device_block()
  scsi: replace scsi_target_block() by scsi_block_targets()

 block/bsg.c                         |  2 +-
 drivers/scsi/scsi_lib.c             | 76 ++++++++++++++---------------
 drivers/scsi/scsi_transport_fc.c    |  2 +-
 drivers/scsi/scsi_transport_iscsi.c |  3 +-
 drivers/scsi/scsi_transport_srp.c   |  6 +--
 drivers/scsi/sg.c                   |  2 +-
 drivers/scsi/snic/snic_disc.c       |  2 +-
 include/scsi/scsi_device.h          |  2 +-
 8 files changed, 46 insertions(+), 49 deletions(-)

-- 
2.40.1

