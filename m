Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0338C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 18:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB95C61211
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 18:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbhIWS6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 14:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237009AbhIWS6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Sep 2021 14:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C717961038;
        Thu, 23 Sep 2021 18:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632423409;
        bh=oA9cN/OvRa/NHNZMtxn/7VPYWlgZX4G8M4XX5+D2XwQ=;
        h=From:To:Cc:Subject:Date:From;
        b=JDK4mMgboMSDvX6LRP+ZOdAMvYjGRwi2DRbADwL3B0JyOIMZ8ZacEZAnF71wnICIF
         qDQWFtjvQJe+xw9mA1ElX09HDcwx3CCwj61fUboLvBxG6dsEDHz1+Cfce5cBrB2KM7
         AHTe1cd7zyqxkJCqSJraKnhyj3al9/GoiJmshdyUXUjVezUl/+2ZZcUX4CrQubpbSH
         lZ6MnEtX28LR7i7yKRNpETZG4uRRc4O2bPjyfY5Y/eHqNzxw3SZ5z+/GMIdDVA32yR
         R3uKSkJBNUYR6gxR4NZDFablfDcH+iXM5+6hilEpI1m8JysiFqu6TlfAMtiw6xq7xY
         iTQxk4ChMF3kg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v3 0/4] blk-crypto cleanups
Date:   Thu, 23 Sep 2021 11:56:25 -0700
Message-Id: <20210923185629.54823-1-ebiggers@kernel.org>
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

This series applies to v5.15-rc2.

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
 block/blk-crypto-profile.c                | 564 +++++++++++++++++++++
 block/blk-crypto.c                        |  29 +-
 block/blk-integrity.c                     |   4 +-
 block/keyslot-manager.c                   | 578 ----------------------
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
 include/linux/blkdev.h                    |  18 +-
 include/linux/device-mapper.h             |   4 +-
 include/linux/keyslot-manager.h           | 120 -----
 include/linux/mmc/host.h                  |   4 +-
 21 files changed, 1203 insertions(+), 1130 deletions(-)
 create mode 100644 block/blk-crypto-profile.c
 delete mode 100644 block/keyslot-manager.c
 create mode 100644 include/linux/blk-crypto-profile.h
 delete mode 100644 include/linux/keyslot-manager.h

-- 
2.33.0

