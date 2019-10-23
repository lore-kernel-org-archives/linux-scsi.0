Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348D9CA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C0DD20640
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 12:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391837AbfJWMxL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:53:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:49240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390962AbfJWMxL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 08:53:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 803CEB678;
        Wed, 23 Oct 2019 12:53:08 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/8] Fix cdrom autoclose.
Date:   Wed, 23 Oct 2019 14:52:39 +0200
Message-Id: <cover.1571834862.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Link: https://lore.kernel.org/lkml/cover.1513263482.git.msuchanek@suse.de/

Hello,

there is cdrom autoclose feature that is supposed to close the tray,
wait for the disc to become ready, and then open the device.

This used to work in ancient times. Then in old times there was a hack
in util-linux which worked around the breakage which probably resulted
from switching to scsi emulation.

Currently util-linux maintainer refuses to merge another hack on the
basis that kernel still has the feature so it should be fixed there.
The code needs not be replicated in every userspace utility like mount
or dd which has no business knowing which devices are CD-roms and where
the autoclose setting is in the kernel.

Michal Suchanek (8):
  cdrom: add poll_event_interruptible
  cdrom: factor out common open_for_* code
  cdrom: wait for the tray to close
  cdrom: separate autoclose into an IOCTL
  docs: cdrom: Add autoclose IOCTL
  bdev: add open_finish.
  scsi: sr: workaround VMware ESXi cdrom emulation bug
  scsi: sr: wait for the medium to become ready

 Documentation/filesystems/locking.rst |   2 +
 Documentation/ioctl/cdrom.rst         |  25 ++++
 drivers/cdrom/cdrom.c                 | 188 ++++++++++++++------------
 drivers/scsi/sr.c                     |  60 ++++++--
 fs/block_dev.c                        |  21 ++-
 include/linux/blkdev.h                |   1 +
 include/uapi/linux/cdrom.h            |   1 +
 7 files changed, 198 insertions(+), 100 deletions(-)

-- 
2.23.0

