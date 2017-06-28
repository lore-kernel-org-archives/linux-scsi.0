From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/5] target: Zoned block device support and bug fixes
Date: Wed, 28 Jun 2017 14:58:55 +0900
Message-ID: <20170628055900.22889-1-damien.lemoal@wdc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A . Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

This series introduce zoned block device support for the pscsi backstore and
also fixes several problems with sense data handling for failed requests.

The first patch is only a cleanup, so not really necessary but nice to have I
think.

Patch 2 and 3 introduce support for host managed zoned block device type (14h)
in the SCSI passthrough backstore and fixes sense data handling for commands
failed by the backstore device. With these fixes, a host zoned block device
exported with the iscsi or loopback transport pass libzbc ZBC specification
conformance tests.

Finally, patch 4 and 5 fix sense data hadling with the user backstore code. A
prototype ZBC emulation tcmu-runner handler was used to test these fixes and
result in the emulated handler passing libzbc ZBC specification conformance
tests.

(Note: the ZBC emulation tcmu-runner handler will be submitted to the
tcmu-runner project on github)

Please consider these patches for inclusion with kernel 4.13.

Damien Le Moal (5):
  target: Use macro for WRITE_VERIFY_xx operation codes
  target: pscsi: Introduce TYPE_ZBC support
  target: pscsi: Fix sense data handling
  target: user: Fix sense data handling
  target: core: Fix failed command sense data handling

 drivers/target/target_core_device.c    |  4 ++--
 drivers/target/target_core_pscsi.c     | 20 +++++++++++++-------
 drivers/target/target_core_transport.c |  5 +++--
 drivers/target/target_core_user.c      |  4 +++-
 include/scsi/scsi_proto.h              |  1 +
 5 files changed, 22 insertions(+), 12 deletions(-)

-- 
2.9.4
