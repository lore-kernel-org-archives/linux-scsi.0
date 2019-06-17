From: "Alastair D'Silva" <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 0/7] Hexdump Enhancements
Date: Mon, 17 Jun 2019 12:04:23 +1000
Message-ID: <20190617020430.8708-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org
Cc: Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jose Abreu <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Stanislaw Gruszka <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benson Leung <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexa
List-Id: linux-scsi@vger.kernel.org

From: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>

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
V3:
 - Fix inline documention
 - use BIT macros
 - use u32 rather than u64 for flags
V2:
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
