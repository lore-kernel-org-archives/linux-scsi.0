Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5114AC87FDE
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jun 2023 19:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbjFFTjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 15:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjFFTix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 15:38:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ED710CE;
        Tue,  6 Jun 2023 12:38:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 445D41FD8C;
        Tue,  6 Jun 2023 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686080331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=x9PNMHUYGFdwWzSVwJ8w2w+S5Qi9wxp3fYQY1vW3YkI=;
        b=LiSVi2GzsGvZ0D/KfAkAKje50SvWBi/e1Yr7g89HETxgqbfmS1Pv3GaIQHh/uocxvfORF+
        14gB/2gg3UCNMDCJUvGxSIQfekUWgDshO2yRK329+W3aDXwiH1QePOyNb350LG1vjMPvwo
        Pg6OX6oNG2qMj2+0osUmVltmLyu0Yp4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CAA8213776;
        Tue,  6 Jun 2023 19:38:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yYuFL0qLf2RaFwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 06 Jun 2023 19:38:50 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/3] scsi: fixes for targets with many LUNs
Date:   Tue,  6 Jun 2023 21:38:42 +0200
Message-Id: <20230606193845.9627-1-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

This patch series addresses some issues we saw in a test setup
with a large number of SCSI LUNs. The first two patches simply
increase the number of available sg and bsg devices. The last one
fixes an large delay we encountered between blocking a Fibre Channel
remote port and the dev_loss_tmo.

Changes v1 -> v2:
 - call blk_mq_wait_quiesce_done() from scsi_target_block() to
   cover the case where BLK_MQ_F_BLOCKING is set (Bart van Assche)

Hannes Reinecke (3):
  bsg: increase number of devices
  scsi: sg: increase number of devices
  scsi: simplify scsi_stop_queue()

 block/bsg.c             |  2 +-
 drivers/scsi/scsi_lib.c | 28 ++++++++++++++--------------
 drivers/scsi/sg.c       |  2 +-
 3 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.40.1

