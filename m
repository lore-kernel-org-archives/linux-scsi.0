From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.14-rc5
Date: Sat, 01 Mar 2014 14:02:36 -0800
Message-ID: <1393711356.6314.9.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target pending fixes for v3.14-rc5 code.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The bulk of the series are bugfixes for qla2xxx target NPIV support that
went in for v3.14-rc1.  Also included are a few DIF related fixes, a
qla2xxx fix (Cc'ed to stable) from Greg W., and vhost/scsi protocol
version related fix from Venkatesh.

Also just a heads up that a series to address a number of issues with
iser-target active I/O reset/shutdown is still being tested, and will be
included in a separate -rc6 PULL request.

Thank you,

--nab

Dr. Greg Wettstein (1):
  qla2xxx: Fix kernel panic on selective retransmission request

Nicholas Bellinger (7):
  qla2xxx: Fix qlt_lport_register base_vha callback race
  qla2xxx: Check + fail when npiv_vports_inuse exists in shutdown
  tcm_qla2xxx: Add NPIV specific enable/disable attribute logic
  tcm_qla2xxx: Perform configfs depend/undepend for base_tpg
  tcm_qla2xxx: Fix NAA formatted name for NPIV WWPNs
  target/sbc: Fix sbc_dif_copy_prot addr offset bug
  target: Add DIF sense codes in transport_generic_request_failure

Sagi Grimberg (1):
  Target/sbc: Don't use sg as iterator in sbc_verify_read

Venkatesh Srinivas (1):
  vhost/scsi: Check LUN structure byte 0 is set to 1, per spec

 drivers/scsi/qla2xxx/qla_target.c      |   42 +++++++--
 drivers/scsi/qla2xxx/qla_target.h      |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  158 +++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h     |    7 +-
 drivers/target/target_core_sbc.c       |   15 ++-
 drivers/target/target_core_transport.c |    3 +
 drivers/vhost/scsi.c                   |    6 ++
 7 files changed, 171 insertions(+), 62 deletions(-)
