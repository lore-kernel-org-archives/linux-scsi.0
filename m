Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F02C7EE25
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 18:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjFGSXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFGSXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 14:23:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0138226A3;
        Wed,  7 Jun 2023 11:23:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DE2DD21A12;
        Wed,  7 Jun 2023 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686162194; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0tH7ZVZ8K6Zl7Tbv4Qxycx3ttP8l0Pu3O+4wFI22LQw=;
        b=dNHfVCccjTFPsWaqEyfhvhaVtSV4rPKP+4V0QIrJPXy2j1GWVgp2fAU9A6Pk8oyV/tSr9p
        JKEGCv0qyhJS8DmXuhwD9fFU0QDskagNYKS5/lpf0WLb734bQtsGziuh5IPKCJgu3lh6TU
        99+rWm66wWYkpFw8VfznV++DHattPaY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D5E81346D;
        Wed,  7 Jun 2023 18:23:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QfBpCxLLgGRzBQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 18:23:14 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/8] scsi: fixes for targets with many LUNs, and scsi_target_block rework
Date:   Wed,  7 Jun 2023 20:22:41 +0200
Message-Id: <20230607182249.22623-1-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

This patch series addresses some issues we saw in a test setup
with a large number of SCSI LUNs. The first two patches simply
increase the number of available sg and bsg devices. 3-6 fix
a large delay we encountered between blocking a Fibre Channel
remote port and the dev_loss_tmo. 7-8 apply additional changes
to scsi_target_block(), as suggested in the review of the v2 series.

Changes v2 -> v3:
 - Split previous 3/3 into 4 separate patches as suggested by
   Christoph Hellwig.
 - Added 7/8 and 8/8, as suggested by Christoph and Bart van Assche.
 - Added s-o-b and reviewed-by tags.

Changes v1 -> v2:
 - call blk_mq_wait_quiesce_done() from scsi_target_block() to
   cover the case where BLK_MQ_F_BL*** SUBJECT HERE ***

Hannes Reinecke (2):
  bsg: increase number of devices
  scsi: sg: increase number of devices

Martin Wilck (6):
  scsi: merge scsi_internal_device_block() and device_block()
  scsi: call scsi_stop_queue() without state_mutex held
  scsi: don't wait for quiesce in scsi_stop_queue()
  scsi: don't wait for quiesce in scsi_device_block()
  scsi: have scsi_target_block() expect a scsi_target parent argument
  scsi: add Scsi_Host argument to scsi_target_block()

 block/bsg.c                         |  2 +-
 drivers/scsi/scsi_lib.c             | 72 +++++++++++++----------------
 drivers/scsi/scsi_transport_fc.c    |  2 +-
 drivers/scsi/scsi_transport_iscsi.c |  3 +-
 drivers/scsi/scsi_transport_srp.c   |  4 +-
 drivers/scsi/sg.c                   |  2 +-
 drivers/scsi/snic/snic_disc.c       |  2 +-
 include/scsi/scsi_device.h          |  2 +-
 8 files changed, 41 insertions(+), 48 deletions(-)

-- 
2.40.1

