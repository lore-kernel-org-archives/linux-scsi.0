Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FEAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 16:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD5B61440
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 16:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345944AbhI2Qiv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 12:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345687AbhI2Qiv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 12:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C9AA60F6E;
        Wed, 29 Sep 2021 16:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632933430;
        bh=Vz3dxPeYTeA/c/WRIE4+cxucld3Y5IomwupSs4gY2Bg=;
        h=From:To:Cc:Subject:Date:From;
        b=X1vcZIk1uET1WVDZWIY71h0rWYDde2gtpvhWQgWJYe+4zrdK75WI8FEyOUnzYIyay
         8LaLcHDJqhARsZjbb9QlJEJIhoq5MCNk/69AUW8SscN3qzAN0MHwbD5FncLaJvGKVE
         03SQfRJYggS0jDIZp5yvEOlYf86z/ktySGGx5sXP4XtEH+BiUTnP3RnTT6UQeZneWS
         88oJd32czkdicJ83iTem+h+MZidjluoMj92qnGxvHtXkfziYgQUx7+fJipqPPz4Q3T
         d2XbOy6EmygOL4Pbup91In37/Xya5xrmNIOfZww0p4x1CAFPkrrNgGDuBVQkvowIFj
         Z1IhX0PGc1zYQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v4 0/4] blk-crypto cleanups
Date:   Wed, 29 Sep 2021 09:35:56 -0700
Message-Id: <20210929163600.52141-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series renames struct blk_keyslot_manager to struct
blk_crypto_profile, as it is misnamed; it doesn't always manage
keyslots.  It's much more logical to think of it as the
"blk-crypto profile" of a device, similar to blk_integrity_profile.

This series also improves the inline-encryption.rst documentation file,
and cleans up blk-crypto-fallback a bit.

This series applies to block/for-next.

Changed v3 => v4:
  - Rebased onto block/for-next to resolve a conflict due to
    'struct request' being moved.

Changed v2 => v3:
  - Made some minor tweaks to patches 3 and 4, mostly comments and
    documentation.
  - Clarified a commit message to mention no change in behavior.
  - Added a Reviewed-by tag.

Changed v1 => v2:
  - Fixed a build error in blk-integrity.c.
  - Removed a mention of "ksm" from a comment.
  - Dropped the patch "blk-crypto-fallback: consolidate static variables".
  - Added Acked-by and Reviewed-by tags.

Eric Biggers (4):
  blk-crypto-fallback: properly prefix function and struct names
  blk-crypto: rename keyslot-manager files to blk-crypto-profile
  blk-crypto: rename blk_keyslot_manager to blk_crypto_profile
  blk-crypto: update inline encryption documentation

 Documentation/block/inline-encryption.rst | 451 +++++++++--------
 block/Makefile                            |   2 +-
 block/blk-crypto-fallback.c               | 118 ++---
 block/blk-crypto-profile.c                | 565 +++++++++++++++++++++
 block/blk-crypto.c                        |  29 +-
 block/blk-integrity.c                     |   4 +-
 block/keyslot-manager.c                   | 579 ----------------------
 drivers/md/dm-core.h                      |   4 +-
 drivers/md/dm-table.c                     | 168 +++----
 drivers/md/dm.c                           |  10 +-
 drivers/mmc/core/crypto.c                 |  11 +-
 drivers/mmc/host/cqhci-crypto.c           |  33 +-
 drivers/scsi/ufs/ufshcd-crypto.c          |  32 +-
 drivers/scsi/ufs/ufshcd-crypto.h          |   9 +-
 drivers/scsi/ufs/ufshcd.c                 |   2 +-
 drivers/scsi/ufs/ufshcd.h                 |   6 +-
 include/linux/blk-crypto-profile.h        | 166 +++++++
 include/linux/blk-mq.h                    |   2 +-
 include/linux/blkdev.h                    |  16 +-
 include/linux/device-mapper.h             |   4 +-
 include/linux/keyslot-manager.h           | 120 -----
 include/linux/mmc/host.h                  |   4 +-
 22 files changed, 1204 insertions(+), 1131 deletions(-)
 create mode 100644 block/blk-crypto-profile.c
 delete mode 100644 block/keyslot-manager.c
 create mode 100644 include/linux/blk-crypto-profile.h
 delete mode 100644 include/linux/keyslot-manager.h


base-commit: 655d78c1328cfede3dfd1ccafd8433692e23d21e
-- 
2.33.0

