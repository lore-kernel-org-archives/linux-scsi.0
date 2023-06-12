Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FACBC88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 16:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbjFLQvw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjFLQvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 12:51:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA101B8;
        Mon, 12 Jun 2023 09:51:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B00111FDAD;
        Mon, 12 Jun 2023 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686588708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Gw1HkSxcFji9pQ2e7VCQEbcfVfklfdlYY9pVpQV61tk=;
        b=Zb2EQZdr/MFb9f4Xx56IZlyPlRVUrtYWmHPviHlCVjwmtEaaMbaC1Qj5dGicHaTsBCbYLP
        ljT+p9eJqcUkQMq0qb2KyUURxuy84s8CQX7gnLZEkr70ePYGBWnrB8L74PuZXpH65zL2Vl
        UqStHedt7ZSuEuQ3+dZ3nz+WBAw6mYo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5325F1357F;
        Mon, 12 Jun 2023 16:51:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I01nEiRNh2SOXwAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 16:51:48 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 0/7] scsi: fixes for targets with many LUNs, and scsi_target_block rework
Date:   Mon, 12 Jun 2023 18:50:42 +0200
Message-Id: <20230612165049.29440-1-mwilck@suse.com>
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
as suggested in the review of the v2 series. 7 improves a warning message.

Changes v4 -> v5:
 - added 7/7 to improve the WARN_ON_ONCE in scsi_device_block() (Bart van Assche)
 - 6/7: added WARN_ON_ONCE in scsi_block_targets() (Bart van Assche)
 - 4/7: improved comment (Bart van Assche)
 - Added tags

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

Martin Wilck (5):
  scsi: merge scsi_internal_device_block() and device_block()
  scsi: don't wait for quiesce in scsi_stop_queue()
  scsi: don't wait for quiesce in scsi_device_block()
  scsi: replace scsi_target_block() by scsi_block_targets()
  scsi: improve warning message in scsi_device_block()

 block/bsg.c                         |  2 +-
 drivers/scsi/scsi_lib.c             | 79 ++++++++++++++---------------
 drivers/scsi/scsi_transport_fc.c    |  2 +-
 drivers/scsi/scsi_transport_iscsi.c |  3 +-
 drivers/scsi/scsi_transport_srp.c   |  6 +--
 drivers/scsi/sg.c                   |  2 +-
 drivers/scsi/snic/snic_disc.c       |  2 +-
 include/scsi/scsi_device.h          |  2 +-
 8 files changed, 49 insertions(+), 49 deletions(-)

-- 
2.40.1

