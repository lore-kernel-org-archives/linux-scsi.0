Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1455BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01375610CB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhJLVra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233785AbhJLVr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 17:47:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A890C60F3A;
        Tue, 12 Oct 2021 21:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634075125;
        bh=hQJpD6LjLTdv6GdroR/ISuyIax4HObu3uU2ffcHXoh8=;
        h=From:To:Cc:Subject:Date:From;
        b=iNCp/gZs2RiE+SRbHjw4LiA0y2yjWHCQTaH1Fyue2A13nz+mkXhFNU+zWbI2ggyQO
         7J/zWiNV9+ntXnEAzv2tSOCej69gdHicG4cDxv+Z8IwN6vSVlDv6KZ6j3ta6oBjCm7
         8ju4ZzWe0wEs9Ry6VrI/4zqRkz36qnhuGLVMe4y1lSv2sc9DXRCL9PYtsEcHwGGExL
         wZqUxO3r1GzMU6xMAt5AFaZPn5N7stnNuQkne/5gFzU5v6Q/qJZlsx/ZsUwcSks3RU
         TlxfCHhU1fIwCp/7eozJ7dSH+TVswBXvGxeIzhDyZrwGLIiJdpiTDxMfqDl1TJuyJD
         nKJxMupULzJag==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v5 0/4] blk-crypto cleanups
Date:   Tue, 12 Oct 2021 14:43:26 -0700
Message-Id: <20211012214330.40470-1-ebiggers@kernel.org>
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

Changed v4 => v5:
  - Rebased onto block/for-next again
  - Added Reviewed-by tags

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


base-commit: 960d083b6eca8f150fcd6dc7cf56b0005635b649
-- 
2.33.0

