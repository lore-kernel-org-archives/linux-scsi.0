Return-Path: <SRS0=MIBM=WR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE543C3A59E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 07:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E0922D6D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 07:57:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m1Xurgto"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfHUH5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Aug 2019 03:57:19 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:47279 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfHUH5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2019 03:57:19 -0400
Received: by mail-pg1-f202.google.com with SMTP id l11so812566pgc.14
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2019 00:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qBYw6rmUbKKC3VdJzzhZFbO54DY8EqjVVgF8hqQ2BVM=;
        b=m1XurgtoPK+fka2z8sNyW0/MqfW9/U9hjy3nSxr5IPDOY+nWylWHuogp9jrVH5zFCF
         GRsgogC4tQFk3Yzt2zQT9kLISOv5wsMBdy297GHb/QuCYDrRmyg2JdtW+8NtfbPKafxi
         MoLg4eK/kitx8SnWOv3uhXpr8bDQGHHsBReb86MT16AaTYiI4ybrwjzBQhOsUVclUYKi
         h2r8/Dd7NUpMxrwKnp57d20sNxfcj6ISWEOSO/xFG1m1dMw4JodcZVcOlV72zDWzTlT4
         5wuG+eNl+GhXM1Qy3JjnLN/UwBFCyLiLUmtCEd4Xvs+uLqtP4gboeKPIJ038cFUHYTcZ
         v+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qBYw6rmUbKKC3VdJzzhZFbO54DY8EqjVVgF8hqQ2BVM=;
        b=Wl3CkIgNaiyzc0I9UesWbJWbEz+aJDpboRzXlpTdmVKlyrF/SDcDZMc17v3lMMAgaT
         QjZFZXxdLcrGFMqzpJlto4D/mls+Mp6MGEmxYXUAmbyB98YoIPJFNdA9WkDEW5f/Z9fp
         WEX2BNPAgyd6jQY5TZXEvtcg3PZCv0OYfpF/nWv+8WhbdIouVMqxLry2UfyOJMrQw81i
         iZlW+NUvVoucBXl5pSuVwruEBVB40DrKYbsGcL+t8We5BI3UhLoyjEf26QOZr2juUhlZ
         WkAG/x165QxCy2U6O9o2RO0kRZrT8Nneg6y5+iWHwQIP7LwkVZsMLGlj4Oixnev//52O
         2LWQ==
X-Gm-Message-State: APjAAAUZlgN+nyGHlmWHpmXsdL79U6gBpCf8xblA70TSuKdFoXkaznx7
        9zeAkIQaqf5SKf6buygkfFHZs2HZwjw=
X-Google-Smtp-Source: APXvYqyYG592CW3rXQWgTZpbKT/mH3YUzFok7GJ5iJ9kysnTWjWo+ii3lu2lURgc1SAlWfNK2GglwL02dCI=
X-Received: by 2002:a65:4507:: with SMTP id n7mr27027863pgq.86.1566374238228;
 Wed, 21 Aug 2019 00:57:18 -0700 (PDT)
Date:   Wed, 21 Aug 2019 00:57:06 -0700
Message-Id: <20190821075714.65140-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH v4 0/8] Inline Encryption Support
From:   Satya Tangirala <satyat@google.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series adds support for Inline Encryption to the block layer,
UFS, fscrypt and f2fs.

Inline Encryption hardware allows software to specify an encryption context
(an encryption key, crypto algorithm, data unit num, data unit size, etc.)
along with a data transfer request to a storage device, and the inline
encryption hardware will use that context to en/decrypt the data. The
inline encryption hardware is part of the storage device, and it
conceptually sits on the data path between system memory and the storage
device. Inline Encryption hardware has become increasingly common, and we
want to support it in the kernel.

Inline Encryption hardware implementations often function around the
concept of a limited number of "keyslots", which can hold an encryption
context each. The storage device can be directed to en/decrypt any
particular request with the encryption context stored in any particular
keyslot.

Patch 1 introduces a Keyslot Manager to efficiently manage keyslots.
The keyslot manager also functions as the interface that blk-crypto
(introduced in Path 3), will use to program keys into inline encryption
hardware. For more information on the Keyslot Manager, refer to
documentation found in block/keyslot-manager.c and linux/keyslot-manager.h.

Patch 2 introduces struct bio_crypt_ctx, and a ptr to one in struct bio,
which allows struct bio to represent an encryption context that can be
passed down the storage stack from the filesystem layer to the storage
driver.

Patch 3 introduces blk-crypto. Blk-crypto delegates crypto operations to
inline encryption hardware when available, and also contains a software
fallback to the kernel crypto API. Blk-crypto also makes it possible for
layered devices like device mapper to make use of inline encryption
hardware. Given that blk-crypto works as a software fallback, we are
considering removing file content en/decryption from fscrypt and simply
using blk-crypto in a future patch. For more details on blk-crypto, refer
to Documentation/block/blk-crypto.txt.

Patches 4-6 add support for inline encryption into the UFS driver according
to the JEDEC UFS HCI v2.1 specification. Inline encryption support for
other drivers (like eMMC) may be added in the same way - the device driver
should set up a Keyslot Manager in the device's request_queue (refer to
the UFS crypto additions in ufshcd-crypto.c and ufshcd.c for an example).

Patches 7 and 8 add support to fscrypt and f2fs, so that we have
a complete stack that can make use of inline encryption.

There have been a few patch sets addressing Inline Encryption Support in
the past. Briefly, this patch set differs from those as follows:

1) "crypto: qce: ice: Add support for Inline Crypto Engine"
is specific to certain hardware, while our patch set's Inline
Encryption support for UFS is implemented according to the JEDEC UFS
specification.

2) "scsi: ufs: UFS Host Controller crypto changes" registers inline
encryption support as a kernel crypto algorithm. Our patch views inline
encryption as being fundamentally different from a generic crypto
provider (in that inline encryption is tied to a device), and so does
not use the kernel crypto API to represent inline encryption hardware.

3) "scsi: ufs: add real time/inline crypto support to UFS HCD" requires
the device mapper to work - our patch does not.

Changes v3 => v4:
 - Fixed the issue with allocating crypto_skcipher in
   blk_crypto_keyslot_program.
 - bio_crypto_alloc_ctx is now mempool backed.
 - In f2fs, a bio's bi_crypt_context is now set up when the
   bio is allocated, rather than just before the bio is
   submitted - this fixes bugs in certain cases, like when an
   encrypted block is being moved without decryption.
 - Lots of refactoring and cleanup of blk-crypto - thanks Eric!

Changes v2 => v3:
 - Overhauled keyslot manager's get keyslot logic and optimized LRU.
 - Block crypto en/decryption fallback now supports data unit sizes
   that divide the bvec length (instead of requiring each bvec's length
   to be the same as the data unit size).
 - fscrypt master key is now keyed additionally by super_block and
   ci_ctfm != NULL.
 - all references of "hw encryption" are replaced by inline encryption.
 - address various other review comments from Eric.

Changes v1 => v2:
 - Block layer and UFS changes are split into 3 patches each.
 - We now only have a ptr to a struct bio_crypt_ctx in struct bio, instead
   of the struct itself.
 - struct bio_crypt_ctx no longer has flags.
 - blk-crypto now correctly handles the case when it fails to init
   (because of insufficient memory), but kernel continues to boot.
 - ufshcd-crypto now works on big endian cpus.
 - Many cleanups.

Satya Tangirala (8):
  block: Keyslot Manager for Inline Encryption
  block: Add encryption context to struct bio
  block: blk-crypto for Inline Encryption
  scsi: ufs: UFS driver v2.1 spec crypto additions
  scsi: ufs: UFS crypto API
  scsi: ufs: Add inline encryption support to UFS
  fscrypt: wire up fscrypt to use blk-crypto
  f2fs: Wire up f2fs to use inline encryption via fscrypt

 Documentation/block/inline-encryption.txt | 186 ++++++
 block/Kconfig                             |  10 +
 block/Makefile                            |   2 +
 block/bio-crypt-ctx.c                     | 142 +++++
 block/bio.c                               |  23 +-
 block/blk-core.c                          |  14 +-
 block/blk-crypto.c                        | 737 ++++++++++++++++++++++
 block/blk-merge.c                         |  35 +-
 block/bounce.c                            |  15 +-
 block/keyslot-manager.c                   | 351 +++++++++++
 drivers/md/dm.c                           |  15 +-
 drivers/scsi/ufs/Kconfig                  |  10 +
 drivers/scsi/ufs/Makefile                 |   1 +
 drivers/scsi/ufs/ufshcd-crypto.c          | 429 +++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h          |  86 +++
 drivers/scsi/ufs/ufshcd.c                 |  85 ++-
 drivers/scsi/ufs/ufshcd.h                 |  29 +
 drivers/scsi/ufs/ufshci.h                 |  67 +-
 fs/crypto/Kconfig                         |   6 +
 fs/crypto/bio.c                           | 137 +++-
 fs/crypto/fscrypt_private.h               |  23 +
 fs/crypto/keyinfo.c                       | 107 +++-
 fs/crypto/policy.c                        |   6 +
 fs/f2fs/data.c                            | 127 +++-
 fs/f2fs/super.c                           |  15 +-
 include/linux/bio-crypt-ctx.h             | 233 +++++++
 include/linux/bio.h                       |   1 +
 include/linux/blk-crypto.h                |  47 ++
 include/linux/blk_types.h                 |   6 +
 include/linux/blkdev.h                    |   6 +
 include/linux/fscrypt.h                   |  72 +++
 include/linux/keyslot-manager.h           |  94 +++
 include/uapi/linux/fs.h                   |   3 +-
 33 files changed, 3034 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/block/inline-encryption.txt
 create mode 100644 block/bio-crypt-ctx.c
 create mode 100644 block/blk-crypto.c
 create mode 100644 block/keyslot-manager.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h
 create mode 100644 include/linux/bio-crypt-ctx.h
 create mode 100644 include/linux/blk-crypto.h
 create mode 100644 include/linux/keyslot-manager.h

-- 
2.23.0.rc1.153.gdeed80330f-goog

