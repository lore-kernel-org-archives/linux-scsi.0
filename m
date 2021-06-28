Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61375C2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 15:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB5E6198E
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 15:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhF1PWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 11:22:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57772 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237520AbhF1PTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 11:19:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4F93F22469;
        Mon, 28 Jun 2021 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624893439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8ZWEVrJwrn+hxAO00Z+EStZrq8T3UeML7tl1dzbCngM=;
        b=mptvKufWAftfIYnqMt1KjqzSKaAVVpw0sbWGpu29Pms8O8XMBEGvkMSb0HEV8fL2IVFUuN
        8e6qT1PSLCV9YlqHXjpquIbTEfxMJHB1ylL36/dTTJDarHFIh3uKHmifl51IeEeL02Oddm
        52ZflkSvI4NIX18EMVROSQv9703Btug=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id D421D11906;
        Mon, 28 Jun 2021 15:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624893439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8ZWEVrJwrn+hxAO00Z+EStZrq8T3UeML7tl1dzbCngM=;
        b=mptvKufWAftfIYnqMt1KjqzSKaAVVpw0sbWGpu29Pms8O8XMBEGvkMSb0HEV8fL2IVFUuN
        8e6qT1PSLCV9YlqHXjpquIbTEfxMJHB1ylL36/dTTJDarHFIh3uKHmifl51IeEeL02Oddm
        52ZflkSvI4NIX18EMVROSQv9703Btug=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id wRhVMv7n2WDaJwAALh3uQQ
        (envelope-from <mwilck@suse.com>); Mon, 28 Jun 2021 15:17:18 +0000
From:   mwilck@suse.com
To:     Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 0/3] scsi/dm: dm_blk_ioctl(): implement failover for SG_IO on dm-multipath
Date:   Mon, 28 Jun 2021 17:15:55 +0200
Message-Id: <20210628151558.2289-1-mwilck@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Hello Mike, hello Martin,

here is v5 of my attempt to add retry logic to SG_IO on dm-multipath
devices.

Christoph's comment on v4 has been received, but as I'm still confused
how to handle the SCSI result / blk_status_t conversion properly, and
waiting for more guidance, I want to fix the nasty bug in v4 first.

Regards
Martin

Changes v4->v5:

 - (2/3) Fixed bug in logical / bitwise and expression
   Reported-by: kernel test robot <lkp@intel.com>

Changes v3->v4 (thanks to Mike Snitzer):

 - Added an additional helper function sg_io_to_blk_status() to
   scsi_ioctl.c, in order to avoid open-coding handling of the SCSI result
   code in device-mapper.

 - Added a new method dm_sg_io_ioctl_fn() in struct target_type, define
   only by the multipath target. This allows moving the bulk of the new
   code to dm-mpath.c, and avoids the wrong limitation of the code to
   request-based multipath.

Changes v2->v3:

 - un-inlined scsi_result_to_blk_status again, and move the helper
   __scsi_result_to_blk_status to block/scsi_ioctl.c instead
   (Bart v. Assche)
 - open-coded the status/msg/host/driver-byte -> result conversion
   where the standard SCSI helpers aren't usable (Bart v. Assche)
    
Changes v1->v2:

 - applied modifications from Mike Snitzer
 - moved SG_IO dependent code to a separate file, no scsi includes in
   dm.c any more
 - made the new code depend on a configuration option 
 - separated out scsi changes, made scsi_result_to_blk_status()
   inline to avoid dependency of dm_mod from scsi_mod (Paolo Bonzini)

Martin Wilck (3):
  scsi: scsi_ioctl: export __scsi_result_to_blk_status()
  scsi: scsi_ioctl: add sg_io_to_blk_status()
  dm mpath: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO

Martin Wilck (3):
  scsi: scsi_ioctl: export __scsi_result_to_blk_status()
  scsi: scsi_ioctl: add sg_io_to_blk_status()
  dm mpath: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO

 block/scsi_ioctl.c            |  72 ++++++++++++++++++++++-
 drivers/md/Kconfig            |  11 ++++
 drivers/md/dm-core.h          |   5 ++
 drivers/md/dm-mpath.c         | 105 ++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  26 ++++++++-
 drivers/scsi/scsi_lib.c       |  24 +-------
 include/linux/blkdev.h        |   4 ++
 include/linux/device-mapper.h |   8 ++-
 8 files changed, 226 insertions(+), 29 deletions(-)

-- 
2.32.0

