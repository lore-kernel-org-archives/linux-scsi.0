From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/8] target: Fixes for SPC/SBC device emulation
Date: Sat, 14 Feb 2015 03:27:35 +0000
Message-ID: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

The following patch series contains a number of target SPC/SBC
related emulation fixes that address failures occurring while
using Ronnie Sahlberg's excellent libiscsi test suite.

The first two are the important ones.  Patch #1 adds a missing
end-of-device sanity check for WRITE_SAME emulation, that Bart
had reported earlier.  Patch #2 fixes a case where the existing
end-of-device check did not take into account the potential of
LBA + sector wrapping overflowing sector_t.

The remaining patches address other minor test failures.  This
includes failing I/O + WRITE_SAME ops when PROTECT bit is set,
if the backend device is not configured to support protection
information.

Also included are sanity checks for DPO/FUA, WRITE_SAME w/ UNMAP=1
and UNMAP that will fail the command if the associated feature
bits are not being advertised by the backend device via existing
device attributes.

Please review.

Thank you,

--nab

Nicholas Bellinger (8):
  target: Add missing WRITE_SAME end-of-device sanity check
  target: Check for LBA + sectors wrap-around in sbc_parse_cdb
  target: Fail I/O with PROTECT bit when protection is unsupported
  target: Perform PROTECT sanity checks for WRITE_SAME
  target: Add sanity checks for DPO/FUA bit usage
  target: Fail WRITE_SAME w/ UNMAP=1 when emulate_tpws=0
  target: Fail UNMAP when emulate_tpu=0
  target: Set LBPWS10 bit in Logical Block Provisioning EVPD

 drivers/target/target_core_file.c   |   5 ++
 drivers/target/target_core_iblock.c |   5 ++
 drivers/target/target_core_sbc.c    | 140 ++++++++++++++++++++++++++++--------
 drivers/target/target_core_spc.c    |   2 +-
 4 files changed, 121 insertions(+), 31 deletions(-)

-- 
1.9.1
