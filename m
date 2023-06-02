Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E03C7EE2A
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 16:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbjFBQjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jun 2023 12:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbjFBQjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2023 12:39:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2A13E;
        Fri,  2 Jun 2023 09:39:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4028621A27;
        Fri,  2 Jun 2023 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685723961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=JSAhD21I8oIRAF+FVtzDtku5fSJ0TvsKEcAyaT7dRWc=;
        b=uYMvmggQVeFGuYvsbc2QZXGh9phZb4g+iqSRBvWVGVN2Q3ezKyGmA8hIMJjx/Zmc4KyDtL
        51RtYH9u0f2IwX9l5yyOw331VYMDFfs+FwMWNZDYSXPzJ8xvxdEHLIYEhEIwBQ80DkI2Ij
        suhvOYsrNzTGZKe+K42nPONqagxvUxA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4CEC133E6;
        Fri,  2 Jun 2023 16:39:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8b89MjgbemSEDwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 02 Jun 2023 16:39:20 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] scsi: fixes for targets with many LUNs
Date:   Fri,  2 Jun 2023 18:38:42 +0200
Message-Id: <20230602163845.32108-1-mwilck@suse.com>
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

Hannes Reinecke (3):
  bsg: increase number of devices
  scsi: sg: increase number of devices
  scsi: simplify scsi_stop_queue()

 block/bsg.c             |  2 +-
 drivers/scsi/scsi_lib.c | 29 +++++++++++++++--------------
 drivers/scsi/sg.c       |  2 +-
 3 files changed, 17 insertions(+), 16 deletions(-)

-- 
2.40.1

