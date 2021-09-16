Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA30C4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E453560724
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350124AbhIPRpc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355843AbhIPRmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F077160F50;
        Thu, 16 Sep 2021 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631813086;
        bh=D8Padwz2dZC+/L7B3aEhL7lAnenKAQ9Yt0gw0ZJOTVE=;
        h=From:To:Cc:Subject:Date:From;
        b=EjEq5mSwvWxrTxAQ63E8jwzJLOw8fYGp7OgGpenXMGqpR1PQpp3OXa69DQY8I4sms
         xEAfXpEfGcUW44sQH9Q9P/tdYxPHjDnO2itustlutCGDXLycQFrzTyZWWVGNYV5TaA
         eLW7QxDsZgJVIBJODUSESGqEDAB+zc/ulM0ETxjQiIpcDRPRKTpiGodvx6QcuqKwLh
         eR0EWKn8beKw8X9DyrzexgXkE0NCcyd3/1Ooe3PtHBrxsxcb04J+uNzxyvb0abJcFF
         l+og74RJN+xWYbZcf/QZLD8XhtNQDmIGPaZqoAjZgDW7q3eNo2FnGh4gcy/O+V4IQj
         tFu0K7MGIQQxQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, Satya Tangirala <satyaprateek2357@gmail.com>
Subject: [PATCH v2 0/4] blk-crypto cleanups
Date:   Thu, 16 Sep 2021 10:22:45 -0700
Message-Id: <20210916172249.45813-1-ebiggers@kernel.org>
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

This series applies to v5.15-rc1.

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

 Documentation/block/inline-encryption.rst | 439 ++++++++--------
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
 21 files changed, 1194 insertions(+), 1127 deletions(-)
 create mode 100644 block/blk-crypto-profile.c
 delete mode 100644 block/keyslot-manager.c
 create mode 100644 include/linux/blk-crypto-profile.h
 delete mode 100644 include/linux/keyslot-manager.h


base-commit: 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f
-- 
2.33.0

