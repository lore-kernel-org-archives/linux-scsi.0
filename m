From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH v2 0/7] Hexdump Enhancements
Date: Wed,  8 May 2019 17:01:40 +1000
Message-ID: <20190508070148.23130-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: alastair@d-silva.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

Apologies for the large CC list, it's a heads up for those responsible
for subsystems where a prototype change in generic code causes a change
in those subsystems.

This series enhances hexdump.

These improve the readability of the dumped data in certain situations
(eg. wide terminals are available, many lines of empty bytes exist, etc).

The default behaviour of hexdump is unchanged, however, the prototype
for hex_dump_to_buffer() has changed, and print_hex_dump() has been
renamed to print_hex_dump_ext(), with a wrapper replacing it for
compatibility with existing code, which would have been too invasive to
change.

Hexdump selftests have be run & confirmed passed.

Changelog:
 - Fix failing selftests
 - Fix precedence bug in 'Replace ascii bool in hex_dump_to_buffer...'
 - Remove hardcoded new lengths & instead relax the checks in
   hex_dump_to_buffer, allocating the buffer from the heap instead of the
   stack.
 - Replace the skipping of lines of 0x00/0xff with skipping lines of
   repeated characters, announcing what has been skipped.
 - Add spaces as an optional N-group separator
 - Allow byte ordering to be maintained when HEXDUMP_RETAIN_BYTE_ORDERING
   is set.
 - Updated selftests to cover 'Relax rowsize checks' &
   'Optionally retain byte ordering'

Alastair D'Silva (7):
  lib/hexdump.c: Fix selftests
  lib/hexdump.c: Relax rowsize checks in hex_dump_to_buffer
  lib/hexdump.c: Optionally suppress lines of repeated bytes
  lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
  lib/hexdump.c: Allow multiple groups to be separated by lines '|'
  lib/hexdump.c: Allow multiple groups to be separated by spaces
  lib/hexdump.c: Optionally retain byte ordering

 drivers/gpu/drm/i915/intel_engine_cs.c        |   2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c       |   6 +-
 drivers/mailbox/mailbox-test.c                |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |   2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |   2 +-
 drivers/net/wireless/ath/ath10k/debug.c       |   3 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +-
 drivers/platform/chrome/wilco_ec/debugfs.c    |   2 +-
 drivers/scsi/scsi_logging.c                   |   8 +-
 drivers/staging/fbtft/fbtft-core.c            |   2 +-
 fs/seq_file.c                                 |   3 +-
 include/linux/printk.h                        |  34 ++-
 lib/hexdump.c                                 | 260 +++++++++++++++---
 lib/test_hexdump.c                            | 146 +++++++---
 14 files changed, 372 insertions(+), 102 deletions(-)

-- 
2.21.0
