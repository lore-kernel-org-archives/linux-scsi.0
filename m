From: "Alastair D'Silva" <alastair@au1.ibm.com>
Subject: [PATCH v4 0/7] Hexdump Enhancements
Date: Tue, 25 Jun 2019 13:17:19 +1000
Message-ID: <20190625031726.12173-1-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: alastair@d-silva.org
Cc: linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Dan Carpenter <dan.carpenter@oracle.com>, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jani Nikula <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Benson Leung <bleung@chromium.org>, Kalle Valo <kvalo@codeaurora.org>, Karsten Keil <isdn@linux-pingi.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxf>
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
V4:
 - Add missing header (linux/bits.h)
 - Fix comment formatting
 - Create hex_dump_to_buffer_ext & make hex_dump_to_buffer a wrapper
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

 drivers/gpu/drm/i915/intel_engine_cs.c        |   5 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c       |  10 +-
 drivers/mailbox/mailbox-test.c                |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |   2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |   2 +-
 drivers/net/wireless/ath/ath10k/debug.c       |   7 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |   4 +-
 drivers/platform/chrome/wilco_ec/debugfs.c    |  10 +-
 drivers/scsi/scsi_logging.c                   |   8 +-
 drivers/staging/fbtft/fbtft-core.c            |   2 +-
 fs/seq_file.c                                 |   6 +-
 include/linux/printk.h                        |  75 ++++-
 lib/hexdump.c                                 | 267 +++++++++++++++---
 lib/test_hexdump.c                            | 154 +++++++---
 14 files changed, 438 insertions(+), 122 deletions(-)

-- 
2.21.0
