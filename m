From: Satya Tangirala via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: [RFC PATCH v2 0/8] Inline Encryption Support
Date: Wed,  5 Jun 2019 16:28:29 -0700
Message-ID: <20190605232837.31545-1-satyat@google.com>
Reply-To: Satya Tangirala <satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: Kuohong Wang <kuohong.wang@mediatek.com>, Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, Satya Tangirala <satyat@google.com>, Barani Muthukumaran <bmuthuku@qti.qualcomm.com>, Parshuram Raju Thombare <pthombar@cadence.com>
List-Id: linux-scsi@vger.kernel.org

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

 Documentation/block/blk-crypto.txt | 185 ++++++++++
 block/Kconfig                      |   8 +
 block/Makefile                     |   2 +
 block/bio.c                        |  17 +-
 block/blk-core.c                   |  11 +-
 block/blk-crypt-ctx.c              |  90 +++++
 block/blk-crypto.c                 | 557 +++++++++++++++++++++++++++++
 block/blk-merge.c                  |  34 +-
 block/bounce.c                     |   9 +-
 block/keyslot-manager.c            | 315 ++++++++++++++++
 drivers/md/dm.c                    |  15 +-
 drivers/scsi/ufs/Kconfig           |  10 +
 drivers/scsi/ufs/Makefile          |   1 +
 drivers/scsi/ufs/ufshcd-crypto.c   | 438 +++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h   |  69 ++++
 drivers/scsi/ufs/ufshcd.c          |  84 ++++-
 drivers/scsi/ufs/ufshcd.h          |  23 ++
 drivers/scsi/ufs/ufshci.h          |  67 +++-
 fs/crypto/Kconfig                  |   7 +
 fs/crypto/bio.c                    | 159 ++++++--
 fs/crypto/crypto.c                 |   9 +
 fs/crypto/fscrypt_private.h        |  10 +
 fs/crypto/keyinfo.c                |  69 ++--
 fs/crypto/policy.c                 |  10 +
 fs/f2fs/data.c                     |  77 +++-
 fs/f2fs/super.c                    |   1 +
 include/linux/bio.h                | 180 ++++++++++
 include/linux/blk-crypto.h         |  40 +++
 include/linux/blk_types.h          |  39 ++
 include/linux/blkdev.h             |   9 +
 include/linux/fscrypt.h            |  64 ++++
 include/linux/keyslot-manager.h    | 116 ++++++
 include/uapi/linux/fs.h            |  12 +-
 33 files changed, 2668 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/block/blk-crypto.txt
 create mode 100644 block/blk-crypt-ctx.c
 create mode 100644 block/blk-crypto.c
 create mode 100644 block/keyslot-manager.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h
 create mode 100644 include/linux/blk-crypto.h
 create mode 100644 include/linux/keyslot-manager.h

-- 
2.22.0.rc1.311.g5d7573a151-goog
