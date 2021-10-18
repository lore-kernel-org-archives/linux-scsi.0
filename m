Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF91AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 18:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A38BC610FB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 18:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhJRSIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232286AbhJRSIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 14:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D437C60F24;
        Mon, 18 Oct 2021 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634580393;
        bh=DbLR5CY/RhSU72JPhM1PYPwwGwkgeewEpon5kk4xk+I=;
        h=From:To:Cc:Subject:Date:From;
        b=jReUnuuX/mOEsvFGi09zlOo9FXcOsrqbnUfwGP5QGIVyoF543UBBViXoqNZd3YzTq
         bIbwaTVFR1TNwEp7LBJYY2ciAmnMYYQT1En4zf5lAF9aeseDrc7EbyEommJ6pRipVi
         6NZ3VCw9pyM9FdqjRfLOMZBcfjhJd/Vgvo1xDhsxKxeOlmaAhxkqbUHBdkOIqwCTiq
         e0B9FgBRXWK3tNpBWqgCWDglbSZxa1dpL99smNEiPmRDndzJmriDl8fq5KeUpTlxtg
         VbzahhZDe4Q5PYjKgiSIRT3mBia1dxT37rMjOUbZMQuNW7slB5lKEzQRTvjja7K0xw
         Va5bw8IwDze+w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v6 0/4] blk-crypto cleanups
Date:   Mon, 18 Oct 2021 11:04:49 -0700
Message-Id: <20211018180453.40441-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.1
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

Changed v5 => v6:
  - Rebased onto block/for-next yet again
  - Added more Reviewed-by tags

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


base-commit: df300910c93e1a0e4ad9fe7a984c569dc118000c
-- 
2.33.1

